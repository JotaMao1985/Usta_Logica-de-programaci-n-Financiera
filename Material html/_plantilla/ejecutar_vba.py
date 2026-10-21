#!/usr/bin/env python3
"""
Comprobación 9, la parte de VBA: las salidas declaradas tras `'>`, ejecutadas
en Excel real.

`ejecutar_salidas.py` corre Python y R desde la terminal. VBA no se puede correr
así, porque necesita Excel. Este guion hace todo lo demás, en dos pasos:

    python3 _plantilla/ejecutar_vba.py preparar 05_LPF_*.html
        Arma con los bloques VBA que declaran salida un módulo de arnés y lo
        deja en el portapapeles. En Excel, con un libro nuevo: Herramientas ›
        Macro › Editor de Visual Basic, Insertar › Módulo y ⌘V. Si los bloques
        mezclan `Option Explicit` y no, salen dos módulos; el guion dice cómo
        copiar el segundo.

    python3 _plantilla/ejecutar_vba.py comparar
        Corre el arnés en Excel con AppleScript (`run VB macro`) y compara lo
        que imprime cada bloque con lo que declara, igual que
        `ejecutar_salidas.py`.

Lo único que se hace a mano es pegar el módulo. El riesgo R2 del plan maestro
decía que VBA no se podía ejecutar desde macOS; con Excel para Mac instalado,
sí se puede, y el VBA de Excel para Mac es el mismo lenguaje que el de Windows
en todo lo que usa el material: tipos, `Format`, `Print`, errores.

Qué cambia el arnés en cada bloque, y por qué eso no cambia lo que se mide:

  · `Debug.Print` pasa a ser `Print #canalArnes,`. La ventana Inmediato no se
    puede leer desde fuera de Excel, y `Print #` escribe la misma lista de
    impresión con las mismas reglas: el espacio del signo antes de un número,
    las zonas de la coma, el `;` final que no salta de renglón.
  · Los procedimientos y las variables de módulo llevan el sufijo `_b<N>`,
    porque dos bloques con el mismo `Sub` no caben en un módulo. Se renombra
    solo el código: nunca el texto entre comillas ni los comentarios.
  · `MsgBox` e `InputBox` se cambian por versiones del arnés: la primera
    escribe en el mismo canal, la segunda lee de una cola de entradas. Un
    procedimiento del proyecto con ese nombre tiene prioridad sobre el de la
    librería de VBA, así que el bloque no se toca.
  · Un error en tiempo de ejecución no detiene el arnés: queda escrito como
    `@@ERROR <número> <descripción>`, y se compara como cualquier salida.

La comparación es exacta, con una sola salvedad, que se informa aparte: los
separadores decimal y de miles los pone la configuración regional del sistema.
En un Mac con región Colombia, `Format(x, "0.00")` escribe `916799,93`, y el
material declara `916799.93`, que es lo que da un Windows en inglés. Si la
única diferencia es esa, el bloque coincide y el informe lo dice.

Por omisión entran los bloques que declaran salida, como en
`ejecutar_salidas.py`. `--incluir NOMBRE` añade otro: un bloque que lee datos
(`--incluir EJ_CAJA=250000,-1` le da esas entradas a `InputBox`) o las líneas
VBA de un `DetectaError`. Esos no declaran salida: se muestran, no se comparan.
Un bloque que no termina deja a Excel colgado; no se incluye.

Devuelve 0 si todo cuadra, 1 si alguna salida no coincide y 2 si no se pudo
ejecutar: Excel cerrado, un arnés de otra versión pegado, o macOS que no le dio
permiso de Automatización a la terminal.
"""

import argparse
import hashlib
import json
import os
import re
import subprocess
import sys
import tempfile
from datetime import datetime
from pathlib import Path

AQUI = Path(__file__).resolve().parent
MATERIAL = AQUI.parent
sys.path.insert(0, str(AQUI))
import ejecutar_salidas as es  # noqa: E402

DIR_ARNES = Path(tempfile.gettempdir()) / "lpf_arnes_vba"
MANIFIESTO = DIR_ARNES / "manifiesto.json"
PREFIJO = "'>"
MACRO = "CorrerArnes"

ROJO, VERDE, AMAR, GRIS, FIN = es.ROJO, es.VERDE, es.AMAR, es.GRIS, es.FIN

DEF_PROC = re.compile(r"^\s*(?:(?:Public|Private|Friend)\s+)?(?:Static\s+)?"
                      r"(Sub|Function|Property\s+(?:Get|Let|Set))\s+(\w+)\s*(\(([^)]*)\))?", re.I)
FIN_PROC = re.compile(r"^\s*End\s+(Sub|Function|Property)\b", re.I)
DECL_MODULO = re.compile(r"^\s*(?:(?:Public|Private|Global|Dim)\s+(?:Const\s+)?|Const\s+)(.*)$", re.I)
DEF_TIPO = re.compile(r"^\s*(?:(?:Public|Private)\s+)?(?:Type|Enum)\s+(\w+)", re.I)
OPTION_EXPLICIT = re.compile(r"^\s*Option\s+Explicit\s*$", re.I)


# ── Lectura de los bloques ──────────────────────────────────────────────────

def lineas_vba(texto, nombre):
    """Las líneas VBA de un arreglo `const NOMBRE = { …, vba: [ '…', … ] }`."""
    m = re.search(r"const\s+" + re.escape(nombre) + r"\s*=\s*\{", texto)
    if not m:
        return None
    v = re.compile(r"\n\s+vba\s*:\s*\[").search(texto, m.end())
    if not v:
        return None
    lineas, i = [], v.end()
    cadena = re.compile(r"\s*(?:'((?:[^'\\]|\\.)*)'|\"((?:[^\"\\]|\\.)*)\")\s*,?")
    while True:
        c = cadena.match(texto, i)
        if not c:
            break
        lineas.append(es.desescapar(c.group(1) if c.group(1) is not None else c.group(2)))
        i = c.end()
    return "\n".join(lineas) if lineas else None


def bloques_vba(rutas, incluir):
    """[{capitulo, nombre, codigo, esperado, entradas}] de los capítulos."""
    fuera = []
    pedidos = {}
    for item in incluir:
        nombre, _, datos = item.partition("=")
        pedidos.setdefault(nombre, []).append(datos.split(",") if datos else None)
    for ruta in rutas:
        texto = es.cuerpo(ruta.read_text(encoding="utf-8"))
        vistos = set()
        for nombre, lenguaje, codigo in es.bloques_de(texto):
            if lenguaje != "vba":
                continue
            ejecutable, esperado = es.separar(codigo, PREFIJO)
            if esperado and nombre not in pedidos:
                fuera.append(dict(capitulo=ruta.name, nombre=nombre, codigo=ejecutable,
                                  esperado=esperado, entradas=None))
            if nombre in pedidos:
                vistos.add(nombre)
                for entradas in pedidos[nombre]:
                    fuera.append(dict(capitulo=ruta.name, nombre=nombre, codigo=ejecutable,
                                      esperado=None, entradas=entradas))
        for nombre in set(pedidos) - vistos:
            codigo = lineas_vba(texto, nombre)
            if codigo:
                vistos.add(nombre)
                for entradas in pedidos[nombre]:
                    fuera.append(dict(capitulo=ruta.name, nombre=nombre, codigo=codigo,
                                      esperado=None, entradas=entradas))
    return fuera


# ── El arnés ────────────────────────────────────────────────────────────────

def trozos(linea):
    """[(tipo, texto)] de una línea de VBA: «codigo», «cadena» o «comentario»."""
    fuera, i, ini, n = [], 0, 0, len(linea)
    while i < n:
        c = linea[i]
        if c == '"':
            if i > ini:
                fuera.append(("codigo", linea[ini:i]))
            j = i + 1
            while j < n:
                if linea[j] == '"':
                    if j + 1 < n and linea[j + 1] == '"':
                        j += 2
                        continue
                    break
                j += 1
            fuera.append(("cadena", linea[i:j + 1]))
            i = ini = j + 1
            continue
        if c == "'" or (linea[i:i + 4].lower() == "rem " and not linea[:i].strip()):
            if i > ini:
                fuera.append(("codigo", linea[ini:i]))
            fuera.append(("comentario", linea[i:]))
            return fuera
        i += 1
    if ini < n:
        fuera.append(("codigo", linea[ini:]))
    return fuera


def solo_codigo(linea):
    return "".join(t for tipo, t in trozos(linea) if tipo == "codigo")


def nombres_propios(lineas):
    """(procedimientos [(nombre, params)], otros nombres de módulo)."""
    procs, otros, dentro = [], [], False
    for linea in lineas:
        cod = solo_codigo(linea)
        m = DEF_PROC.match(cod)
        if m:
            procs.append((m.group(2), (m.group(4) or "").strip()))
            dentro = True
            continue
        if FIN_PROC.match(cod):
            dentro = False
            continue
        if dentro:
            continue
        t = DEF_TIPO.match(cod)
        if t:
            otros.append(t.group(1))
            continue
        d = DECL_MODULO.match(cod)
        if d:
            for parte in d.group(1).split(","):
                p = re.match(r"\s*(?:WithEvents\s+)?(\w+)", parte, re.I)
                if p:
                    otros.append(p.group(1))
    return procs, otros


def adaptar(bloque, n):
    """(código del bloque listo para el arnés, procedimiento de entrada, explícito)."""
    lineas = bloque["codigo"].split("\n")
    explicito = any(OPTION_EXPLICIT.match(solo_codigo(l)) for l in lineas)
    lineas = [l for l in lineas if not OPTION_EXPLICIT.match(solo_codigo(l))]
    procs, otros = nombres_propios(lineas)
    sufijo = f"_b{n}"
    nombres = [p for p, _ in procs] + otros
    patron = re.compile(r"\b(" + "|".join(map(re.escape, nombres)) + r")\b", re.I) if nombres else None

    fuera = []
    for linea in lineas:
        partes = []
        for tipo, t in trozos(linea):
            if tipo == "codigo":
                t = re.sub(r"\bDebug\.Print\b", "Print #canalArnes,", t, flags=re.I)
                if patron:
                    t = patron.sub(lambda m: m.group(0) + sufijo, t)
            partes.append(t)
        fuera.append("".join(partes))

    # La entrada: un Sub sin parámetros al que no llame ningún otro procedimiento.
    cuerpo_codigo = [solo_codigo(l) for l in lineas]
    candidatos = []
    for nombre, params in procs:
        es_sub = any(re.match(r"^\s*(?:(?:Public|Private)\s+)?Sub\s+" + nombre + r"\b", c, re.I)
                     for c in cuerpo_codigo)
        if not es_sub or params:
            continue
        llamado = any(re.search(r"\b" + nombre + r"\b", c, re.I) and not DEF_PROC.match(c)
                      and not FIN_PROC.match(c) for c in cuerpo_codigo)
        if not llamado:
            candidatos.append(nombre)
    entrada = candidatos[-1] + sufijo if candidatos else None
    return "\n".join(fuera), entrada, explicito


def vba_cadena(s):
    return '"' + s.replace('"', '""') + '"'


def armar(bloques, ident):
    """(módulos [(título, texto)], bloques con su entrada y su módulo)."""
    adaptados = []
    for n, b in enumerate(bloques, 1):
        codigo, entrada, explicito = adaptar(b, n)
        adaptados.append(dict(b, n=n, entrada=entrada, explicito=explicito, adaptado=codigo))

    hay_explicitos = any(a["explicito"] for a in adaptados)
    hay_libres = any(not a["explicito"] for a in adaptados)

    cabecera = [
        f"' Arnés de ejecutar_vba.py · {ident}",
        "' Generado; no se edita. Se vuelve a generar con «ejecutar_vba.py preparar».",
        "",
        "Public canalArnes As Integer",
        "Private colaArnes As Variant",
        "Private posArnes As Long",
        "",
        "Public Function MsgBox(Prompt As Variant, Optional Buttons As Variant, Optional Title As Variant, _",
        "                       Optional HelpFile As Variant, Optional Context As Variant) As Long",
        "    Print #canalArnes, Prompt",
        "    MsgBox = 1",
        "End Function",
        "",
        "Public Function InputBox(Prompt As Variant, Optional Title As Variant, Optional Default As Variant, _",
        "                         Optional XPos As Variant, Optional YPos As Variant, _",
        "                         Optional HelpFile As Variant, Optional Context As Variant) As String",
        "    If IsEmpty(colaArnes) Then Err.Raise 5, , \"InputBox sin entradas en el arnés\"",
        "    If posArnes > UBound(colaArnes) Then Err.Raise 5, , \"InputBox: se acabaron las entradas\"",
        "    InputBox = colaArnes(posArnes)",
        "    posArnes = posArnes + 1",
        "End Function",
        "",
        f"Public Function {MACRO}() As String",
        "    Dim ruta As String, f As Integer, texto As String",
        "    ruta = Environ(\"TMPDIR\")",
        "    If ruta = \"\" Then ruta = Environ(\"TEMP\")",
        "    If ruta = \"\" Then ruta = Environ(\"HOME\")",
        "    If Right(ruta, 1) <> Application.PathSeparator Then ruta = ruta & Application.PathSeparator",
        "    ruta = ruta & \"lpf_arnes_vba.txt\"",
        "    canalArnes = FreeFile",
        "    Open ruta For Output As #canalArnes",
        f"    Print #canalArnes, \"@@ARNES {ident}\"",
    ]
    for a in adaptados:
        cabecera.append(f"    Print #canalArnes, \"@@BLOQUE {a['n']}\"")
        if a["entrada"] is None:
            cabecera.append("    Print #canalArnes, \"@@ERROR arnés: el bloque no tiene un Sub de entrada\"")
            continue
        if a["entradas"]:
            cabecera.append("    colaArnes = Array(" + ", ".join(vba_cadena(e) for e in a["entradas"]) + ")")
        else:
            cabecera.append("    colaArnes = Empty")
        cabecera += [
            "    posArnes = 0",
            "    On Error Resume Next",
            f"    {a['entrada']}",
            "    If Err.Number <> 0 Then Print #canalArnes, \"@@ERROR \" & Err.Number & \" \" & Err.Description",
            "    Err.Clear",
            "    On Error GoTo 0",
        ]
    cabecera += [
        "    Print #canalArnes, \"@@FIN\"",
        "    Close #canalArnes",
        "    f = FreeFile",
        "    Open ruta For Binary Access Read As #f",
        "    texto = Space$(LOF(f))",
        "    Get #f, , texto",
        "    Close #f",
        f"    {MACRO} = texto",
        "End Function",
    ]

    def seccion(a):
        return [
            "",
            f"' ── Bloque {a['n']} · {a['capitulo']} · {a['nombre']} " + "─" * 20,
            a["adaptado"].strip("\n"),
        ]

    modulos = []
    primero = (["Option Explicit", ""] if hay_explicitos else []) + cabecera
    for a in adaptados:
        if a["explicito"] == hay_explicitos:
            primero += seccion(a)
    modulos.append(("Módulo 1" + (" (con Option Explicit)" if hay_explicitos else ""),
                    "\n".join(primero) + "\n"))
    if hay_explicitos and hay_libres:
        segundo = [f"' Arnés de ejecutar_vba.py · {ident} · segundo módulo, sin Option Explicit"]
        for a in adaptados:
            if not a["explicito"]:
                segundo += seccion(a)
        modulos.append(("Módulo 2 (sin Option Explicit)", "\n".join(segundo) + "\n"))
    return modulos, adaptados


def al_portapapeles(texto):
    entorno = dict(os.environ, LANG="en_US.UTF-8", LC_ALL="en_US.UTF-8")
    subprocess.run(["pbcopy"], input=texto.encode("utf-8"), env=entorno, check=True)


def rutas_de(args):
    if not args:
        return sorted(MATERIAL.glob("[0-9][0-9]_LPF_*.html"))
    rutas = []
    for a in args:
        p = Path(a)
        rutas.extend([p] if p.exists() else sorted(MATERIAL.glob(a)))
    return rutas


def preparar(opciones):
    rutas = rutas_de(opciones.capitulos)
    bloques = bloques_vba(rutas, opciones.incluir)
    if not bloques:
        print(f"{AMAR}Ningún bloque VBA que ejecutar.{FIN}")
        return 0
    huella = hashlib.sha1(json.dumps(bloques, sort_keys=True).encode()).hexdigest()[:10]
    ident = f"{datetime.now():%Y-%m-%d %H:%M} {huella}"
    modulos, adaptados = armar(bloques, ident)

    DIR_ARNES.mkdir(exist_ok=True)
    for i, (_, texto) in enumerate(modulos, 1):
        (DIR_ARNES / f"arnes_{i}.bas").write_text(texto, encoding="utf-8")
    MANIFIESTO.write_text(json.dumps(dict(ident=ident, bloques=[
        {k: a[k] for k in ("n", "capitulo", "nombre", "entrada", "esperado", "entradas")}
        for a in adaptados]), ensure_ascii=False, indent=1), encoding="utf-8")
    al_portapapeles(modulos[0][1])

    print(f"Arnés {ident}: {len(adaptados)} bloques de {len(rutas)} capítulos, "
          f"{len(modulos)} módulo(s) en {DIR_ARNES}")
    for a in adaptados:
        estado = "lee datos" if a["entradas"] else ("se muestra" if a["esperado"] is None else
                                                    f"{len(a['esperado'])} líneas declaradas")
        aviso = "" if a["entrada"] else f"  {ROJO}sin Sub de entrada{FIN}"
        print(f"  {a['n']:3d}  {a['capitulo'][:2]} {a['nombre']:28s} {estado}{aviso}")
    print(f"\n{modulos[0][0]} copiado al portapapeles. En Excel, con un libro nuevo:\n"
          f"  Herramientas › Macro › Editor de Visual Basic › Insertar › Módulo › ⌘V")
    if len(modulos) > 1:
        print(f"Después, {modulos[1][0]}, en otro módulo:  "
              f"pbcopy < {DIR_ARNES / 'arnes_2.bas'}")
    print(f"Y luego:  python3 _plantilla/ejecutar_vba.py comparar")
    return 0


# ── La comparación ──────────────────────────────────────────────────────────

def correr_en_excel():
    guion = (f'with timeout of 600 seconds\n'
             f'tell application "Microsoft Excel" to run VB macro "{MACRO}"\n'
             f'end timeout')
    try:
        p = subprocess.run(["osascript", "-e", guion], capture_output=True, text=True, timeout=660)
    except subprocess.TimeoutExpired:
        return None, "Excel no respondió en 11 minutos: ¿un bloque que no termina?"
    if p.returncode != 0:
        return None, "AppleScript: " + (p.stderr.strip() or f"código {p.returncode}")
    return p.stdout, None


def por_bloque(salida):
    """(identificador del arnés, {n: [líneas]})."""
    lineas = re.split(r"\r\n|\r|\n", salida.rstrip("\r\n"))
    ident, actual, bloques = None, None, {}
    for l in lineas:
        if l.startswith("@@ARNES "):
            ident = l[len("@@ARNES "):].strip()
        elif l.startswith("@@BLOQUE "):
            actual = int(l.split()[1])
            bloques[actual] = []
        elif l.startswith("@@FIN"):
            actual = None
        elif actual is not None:
            bloques[actual].append(l.rstrip())
    return ident, bloques


ENTRE_DIGITOS = re.compile(r"(?<=\d)[.,](?=\d)")


def salvo_separadores(declara, produce):
    """¿Son iguales si se ignora qué separador puso la región entre dos dígitos?"""
    return ENTRE_DIGITOS.sub("·", declara) == ENTRE_DIGITOS.sub("·", produce)


def comparar(opciones):
    if not MANIFIESTO.exists():
        print(f"{ROJO}No hay arnés preparado. Corra antes «ejecutar_vba.py preparar».{FIN}")
        return 2
    manifiesto = json.loads(MANIFIESTO.read_text(encoding="utf-8"))
    salida, error = correr_en_excel()
    if error:
        print(f"{ROJO}No se pudo ejecutar en Excel.{FIN} {error}")
        return 2
    ident, obtenidos = por_bloque(salida)
    if ident != manifiesto["ident"]:
        print(f"{ROJO}El arnés que corre en Excel es «{ident}», y el preparado es "
              f"«{manifiesto['ident']}». Pegue el módulo nuevo.{FIN}")
        return 2

    fallos, regionales, comparados, mostrados = [], [], 0, []
    for b in manifiesto["bloques"]:
        obtenido = obtenidos.get(b["n"], [])
        rotulo = f"{b['capitulo'][:2]} · {b['nombre']}"
        if b["esperado"] is None:
            mostrados.append((rotulo, b["entradas"], obtenido))
            continue
        comparados += 1
        quiere = [l.rstrip() for l in b["esperado"]]
        if obtenido == quiere:
            continue
        if len(obtenido) == len(quiere) and all(salvo_separadores(d, o) for d, o in zip(quiere, obtenido)):
            regionales.append(rotulo)
            continue
        detalle = [f"{rotulo}: la salida de Excel no coincide con la declarada"]
        for i in range(max(len(quiere), len(obtenido))):
            d = quiere[i] if i < len(quiere) else "(nada)"
            o = obtenido[i] if i < len(obtenido) else "(nada)"
            marca = " " if d == o or salvo_separadores(d, o) else "≠"
            detalle.append(f"          {marca} declara «{d}»  ·  produce «{o}»")
        fallos.append("\n".join(detalle))

    print(f"Arnés {ident} · {comparados} bloques comparados · {len(mostrados)} solo mostrados")
    for f in fallos:
        print(f"  {ROJO}✗{FIN} {f}")
    if regionales:
        print(f"  {AMAR}!{FIN} Coinciden salvo el separador regional entre dígitos "
              f"(este Excel escribe «,» decimal): {', '.join(regionales)}")
    for rotulo, entradas, obtenido in mostrados:
        con = f" con {', '.join(entradas)}" if entradas else ""
        print(f"  {GRIS}·{FIN} {rotulo}{con}:")
        muestra = obtenido if len(obtenido) <= 12 else obtenido[:5] + [f"… ({len(obtenido) - 10} líneas más) …"] + obtenido[-5:]
        for l in muestra:
            print(f"        {l}")
    if fallos:
        print(f"{ROJO}{len(fallos)} bloques VBA con salidas que no cuadran.{FIN}")
        return 1
    print(f"{VERDE}Las salidas VBA declaradas coinciden con las de Excel.{FIN}")
    return 0


def main():
    p = argparse.ArgumentParser(description=__doc__.split("\n\n")[0])
    sub = p.add_subparsers(dest="orden", required=True)
    pr = sub.add_parser("preparar", help="arma el módulo de arnés y lo copia al portapapeles")
    pr.add_argument("capitulos", nargs="*")
    pr.add_argument("--incluir", action="append", default=[], metavar="NOMBRE[=e1,e2,…]")
    sub.add_parser("comparar", help="corre el arnés en Excel y compara")
    opciones = p.parse_args()
    return preparar(opciones) if opciones.orden == "preparar" else comparar(opciones)


if __name__ == "__main__":
    sys.exit(main())
