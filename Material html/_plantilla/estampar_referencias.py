#!/usr/bin/env python3
"""
Estampa en cada capítulo la isla de referencias que leen `Cita`, `Referencias`
y `Fuente`: las entradas de `_fuentes/referencias.json` que el capítulo cita,
ya formateadas en APA 7.

Es un guion aparte de `migrar.py` a propósito: este necesita pandoc, y
`migrar.py` —que estampa la librería y el `App`— tiene que seguir funcionando
en una máquina que no lo tenga.

Por cada capítulo:
  1. lee las claves que cita (`<Cita k>`, `<Fuente k>`, `<ChartFrame fuente>`);
  2. las formatea TODAS JUNTAS con `pandoc --citeproc`, `apa-es.csl` y el idioma
     es-CO —juntas, porque con dos obras del mismo autor y año el «2024a» de
     una depende de que la otra esté—;
  3. separa el autor y el año de la cita en el texto, y deja el HTML de cada
     entrada en `em`, `i`, `sup`, `sub` y `a[href]`, nada más;
  4. escribe la isla entre `<!-- === LP-REFS INICIO … -->` y
     `<!-- === LP-REFS FIN === -->`, después del `</script>` de Babel.

Un capítulo que no cita nada se queda sin isla; si tenía una, se le quita.

Uso:
    python3 _plantilla/estampar_referencias.py                 # todos los capítulos
    python3 _plantilla/estampar_referencias.py 01_LPF_*.html   # archivos concretos
    python3 _plantilla/estampar_referencias.py --dry-run       # muestra y no escribe
    python3 _plantilla/estampar_referencias.py --sin-copia     # no deja .bak
    python3 _plantilla/estampar_referencias.py --comprobar     # no escribe; sale con 1
                                                               # si algo cambiaría
    python3 _plantilla/estampar_referencias.py --demo          # la isla de la plantilla:
                                                               # lp-demo-referencias.html,
                                                               # con las fuentes de pruebas_fuentes/
    python3 _plantilla/estampar_referencias.py --fuentes DIR   # otra carpeta de fuentes

Devuelve 0 si todo se estampó (o, con --comprobar, si todo está al día), 1 si
algo falló y 2 si se le pasó una opción que no existe o falta pandoc (en ese
caso no escribe nada).
"""

import html as html_lib
import json
import re
import shutil
import subprocess
import sys
import tempfile
from html.parser import HTMLParser
from pathlib import Path

try:
    import fuentes
except ImportError:  # se ejecuta desde otro directorio
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import fuentes

AQUI = Path(__file__).resolve().parent
MATERIAL = AQUI.parent
DEMO_FUENTE = AQUI / "lp-demo.jsx"
DEMO_ISLA = AQUI / "lp-demo-referencias.html"

ROJO, VERDE, AMAR, GRIS, FIN = "\033[31m", "\033[32m", "\033[33m", "\033[90m", "\033[0m"


class Fallo(Exception):
    """Algo impide estampar este archivo. Se aborta entero, sin escribir nada."""


class SinPandoc(Exception):
    """pandoc no está o no se pudo ejecutar."""


# ------------------------------------------------------------------- formato

class _Recolector(HTMLParser):
    """Recoge, saneado, lo que hay dentro de cada `<div id="…">` pedido.

    Sanear es dejar pasar solo `em`, `i`, `sup`, `sub` y `a` con un `href`
    http(s); cualquier otra etiqueta se desenvuelve —queda su texto— y el texto
    se escapa. La isla la pinta el navegador de cada estudiante: lo que llegue
    de un campo de Zotero no puede traer un `<script>` ni un `onclick`.
    """

    def __init__(self, ids):
        super().__init__(convert_charrefs=True)
        self.ids = set(ids)
        self.salida = {}
        self.actual = None
        self.prof = 0
        self.pila = []          # ¿se emitió la apertura de esta etiqueta?

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if self.actual is None:
            if tag == "div" and attrs.get("id") in self.ids:
                self.actual, self.prof = attrs["id"], 1
                self.salida[self.actual] = []
            return
        if tag == "div":
            self.prof += 1
            return
        if tag in ("br", "hr", "img", "wbr"):
            return
        emitida = False
        if tag in ("em", "i", "sup", "sub"):
            self.salida[self.actual].append(f"<{tag}>")
            emitida = True
        elif tag == "a":
            href = (attrs.get("href") or "").strip()
            if re.fullmatch(r"https?://[^\s\"<>]+", href):
                self.salida[self.actual].append(f'<a href="{html_lib.escape(href, quote=True)}">')
                emitida = True
        self.pila.append((tag, emitida))

    def handle_endtag(self, tag):
        if self.actual is None:
            return
        if tag == "div":
            self.prof -= 1
            if self.prof == 0:
                self.actual, self.pila = None, []
            return
        for n in range(len(self.pila) - 1, -1, -1):
            if self.pila[n][0] == tag:
                for t, emitida in reversed(self.pila[n:]):
                    if emitida:
                        self.salida[self.actual].append(f"</{t}>")
                del self.pila[n:]
                return

    def handle_data(self, data):
        if self.actual is not None:
            self.salida[self.actual].append(html_lib.escape(data, quote=False))

    def resultado(self):
        return {k: " ".join("".join(v).split()) for k, v in self.salida.items()}


def version_de_pandoc():
    try:
        r = subprocess.run(["pandoc", "--version"], capture_output=True, text=True, timeout=30)
    except (FileNotFoundError, subprocess.TimeoutExpired):
        raise SinPandoc("no se encontró pandoc; instálelo con `brew install pandoc`")
    return r.stdout.splitlines()[0] if r.stdout else "pandoc"


def formatear(entradas, ruta_csl, idioma=fuentes.IDIOMA):
    """(orden, {clave: {autor, anio, html, plano}}) de las entradas dadas.

    Un solo documento para pandoc: por cada clave, la cita narrativa (`@clave`,
    «Autor (2024a)») y la que omite al autor (`[-@clave]`, «(2024a)»); al final,
    la bibliografía. El autor es la narrativa sin su « (año)» final: si eso no
    cuadra, se falla en vez de adivinar por dónde cortar.
    """
    claves = [e["id"] for e in entradas]
    lineas = ["---", f"lang: {idioma}", "---", ""]
    for n, clave in enumerate(claves):
        lineas += [f"::: {{#lp-n-{n}}}", f"@{clave}", ":::", "",
                   f"::: {{#lp-a-{n}}}", f"[-@{clave}]", ":::", ""]
    lineas += ["::: {#refs}", ":::", ""]

    with tempfile.TemporaryDirectory(prefix="lpf-refs-") as tmp:
        biblio = Path(tmp) / "referencias.json"
        biblio.write_text(json.dumps(entradas, ensure_ascii=False), encoding="utf-8")
        try:
            r = subprocess.run(
                ["pandoc", "--from", "markdown", "--to", "html", "--wrap=none", "--citeproc",
                 "--csl", str(ruta_csl), "--bibliography", str(biblio)],
                input="\n".join(lineas), capture_output=True, text=True, timeout=180)
        except FileNotFoundError:
            raise SinPandoc("no se encontró pandoc; instálelo con `brew install pandoc`")
        except subprocess.TimeoutExpired:
            raise Fallo("pandoc no terminó en 180 s")
    if r.returncode != 0:
        raise Fallo(f"pandoc falló: {r.stderr.strip()[:400]}")
    # Con una clave que no encuentra, citeproc no falla: avisa por stderr y
    # escribe «(clave?)». Aquí eso es un fallo.
    if "citeproc" in r.stderr and "not found" in r.stderr:
        raise Fallo(f"pandoc no encontró alguna clave: {r.stderr.strip()[:400]}")

    ids = [f"lp-n-{n}" for n in range(len(claves))] + [f"lp-a-{n}" for n in range(len(claves))] \
        + [f"ref-{c}" for c in claves]
    rec = _Recolector(ids)
    rec.feed(r.stdout)
    partes = rec.resultado()

    orden = [m for m in re.findall(r'<div id="ref-([^"]+)"', r.stdout) if m in claves]
    if sorted(orden) != sorted(claves):
        faltan = sorted(set(claves) - set(orden))
        raise Fallo(f"pandoc no devolvió la entrada de: {', '.join(faltan)}")

    salida = {}
    for n, clave in enumerate(claves):
        narrativa, solo_anio = partes.get(f"lp-n-{n}", ""), partes.get(f"lp-a-{n}", "")
        m = re.fullmatch(r"\((.+)\)", solo_anio)
        if not m:
            raise Fallo(f"«{clave}»: no se pudo leer el año de la cita «{solo_anio}»")
        # Con el tipo `legislation`, apa.csl no separa autor y año: `@clave`
        # y `[-@clave]` dan lo mismo, «(Ley 1328 de 2009, 2009)». No hay
        # cita narrativa que partir, y se dice así en vez de fallar más abajo
        # con un mensaje que no se entiende.
        if narrativa == solo_anio:
            tipo = next((e.get("type") for e in entradas if e["id"] == clave), "?")
            raise Fallo(f"«{clave}» (tipo `{tipo}`): el estilo no le da una cita con autor y "
                        f"año por separado, sino «{narrativa}». Una norma se registra en Zotero "
                        f"como informe, con autor institucional")
        anio = m.group(1)
        cola = f" ({anio})"
        if not narrativa.endswith(cola) or not narrativa[:-len(cola)].strip():
            raise Fallo(f"«{clave}»: la cita narrativa «{narrativa}» no termina en «{cola.strip()}»; "
                        f"no se pudo separar el autor del año")
        html = partes.get(f"ref-{clave}", "")
        if not html or not fuentes.solo_etiquetas_permitidas(html):
            raise Fallo(f"«{clave}»: la entrada formateada quedó vacía o con etiquetas que no "
                        f"se admiten: {html[:120]}")
        autor = narrativa[:-len(cola)].strip()
        for campo, valor in (("autor", autor), ("año", anio)):
            if not fuentes.solo_etiquetas_permitidas(valor):
                raise Fallo(f"«{clave}»: el {campo} trae etiquetas que no se admiten: {valor[:120]}")
        salida[clave] = {"autor": autor, "anio": anio, "html": html,
                         "plano": fuentes.texto_plano(html)}
    return orden, salida


def bloque_para(texto, referencias, directorio):
    """(bloque o None, claves) que corresponde AHORA al capítulo `texto`."""
    citas, problemas = fuentes.citas_de(texto)
    if problemas:
        lineas = [f"línea {texto.count(chr(10), 0, pos) + 1}: {msg}" for pos, msg in problemas]
        raise Fallo("hay citas que no se pueden leer:\n            " + "\n            ".join(lineas))
    claves = fuentes.claves_citadas(texto)
    if not claves:
        return None, claves
    indice = fuentes.por_clave(referencias)
    faltan = [c for c in claves if c not in indice]
    if faltan:
        raise Fallo(f"se citan claves que no están en {fuentes.ARCHIVO_REFERENCIAS}: "
                    f"{', '.join(faltan)}")
    entradas = [indice[c] for c in sorted(claves)]
    orden, formateadas = formatear(entradas, fuentes.ruta_csl(directorio))
    huella = fuentes.huella(entradas, fuentes.sha_csl(directorio))
    return fuentes.componer_bloque(huella, orden, formateadas), claves


def detalle_de(bloque):
    """La lista tal como quedaría, para cotejarla con la bibliografía de Zotero."""
    lineas = []
    for clave in bloque["orden"]:
        e = bloque["entradas"][clave]
        autor = fuentes.texto_plano(e["autor"])
        lineas.append(f"{clave}\n"
                      f"            en el texto:  ({autor}, {e['anio']})  ·  {autor} ({e['anio']})\n"
                      f"            en la lista:  {e['plano']}")
    return lineas


def estampar(ruta, referencias, directorio, escribir, con_copia, detalle):
    """(notas, cambió) de estampar la isla en un capítulo."""
    texto = ruta.read_text(encoding="utf-8")
    try:
        bloque, claves = bloque_para(texto, referencias, directorio)
        nuevo = fuentes.poner_isla(texto, fuentes.texto_de_isla(bloque) if bloque else None)
        mal_puesta = fuentes.isla_bien_puesta(nuevo)
    except fuentes.ErrorFuentes as e:
        raise Fallo(str(e))
    if mal_puesta:
        raise Fallo(mal_puesta)

    if bloque is None:
        notas = ["no cita ninguna fuente"]
        if nuevo != texto:
            notas.append("tenía una isla de referencias y se le quita")
    else:
        notas = [f"{len(claves)} fuentes citadas · huella {bloque['huella'][:12]}… · "
                 f"sello {bloque['sello'][:12]}…"]
    if nuevo == texto:
        notas.append("ya estaba al día — no hubo cambios")
    if bloque is not None and (detalle or nuevo != texto):
        notas += detalle_de(bloque)
    if nuevo != texto and escribir:
        if con_copia:
            shutil.copy2(ruta, ruta.with_suffix(ruta.suffix + ".bak"))
            notas.append(f"{GRIS}copia en {ruta.name}.bak{FIN}")
        ruta.write_text(nuevo, encoding="utf-8")
    return notas, nuevo != texto


def estampar_demo(referencias, directorio, escribir, detalle):
    """La isla de `lp-base.html`, que `ensamblar.py` toma de `lp-demo-referencias.html`.

    La plantilla no puede depender de pandoc para ensamblarse, así que su isla
    se genera aquí y se guarda en un archivo aparte, versionado como las demás
    fuentes de la plantilla. La regla 13 de `verificar.py` compara lo ensamblado
    con `lp-base.html`, y con eso este archivo queda vigilado también.
    """
    bloque, claves = bloque_para(DEMO_FUENTE.read_text(encoding="utf-8"), referencias, directorio)
    if bloque is None:
        raise Fallo(f"{DEMO_FUENTE.name} no cita ninguna fuente: la demo se quedaría sin isla")
    nuevo = fuentes.texto_de_isla(bloque) + "\n"
    viejo = DEMO_ISLA.read_text(encoding="utf-8") if DEMO_ISLA.exists() else None
    notas = [f"{len(claves)} fuentes citadas · huella {bloque['huella'][:12]}… · "
             f"sello {bloque['sello'][:12]}…"]
    if nuevo == viejo:
        notas.append("ya estaba al día — no hubo cambios")
    if detalle or nuevo != viejo:
        notas += detalle_de(bloque)
    if nuevo != viejo and escribir:
        DEMO_ISLA.write_text(nuevo, encoding="utf-8")
        notas.append(f"{GRIS}siguiente: ensamblar.py, que la pone en lp-base.html{FIN}")
    return notas, nuevo != viejo


def main():
    con_valor = {"--fuentes"}
    banderas = {"--dry-run", "--sin-copia", "--comprobar", "--demo"}
    opciones, args, malas = {}, [], []
    argv = sys.argv[1:]
    i = 0
    while i < len(argv):
        a = argv[i]
        nombre, _, pegado = a.partition("=")
        if not a.startswith("--"):
            args.append(a)
        elif nombre in banderas and not pegado:
            opciones[nombre] = True
        elif nombre in con_valor and pegado:
            opciones[nombre] = pegado
        elif nombre in con_valor and i + 1 < len(argv) and not argv[i + 1].startswith("--"):
            opciones[nombre] = argv[i + 1]
            i += 1
        else:
            malas.append(a)
        i += 1

    # Como en `migrar.py`: una opción que no se conoce no puede caer en el caso
    # por omisión, que escribe en todos los capítulos.
    if malas:
        print(__doc__.strip().split("Uso:")[1].split("Devuelve")[0].rstrip(), file=sys.stderr)
        print(f"\n{ROJO}ERROR{FIN}: opción desconocida o sin valor {', '.join(malas)}; "
              f"no se escribió nada.", file=sys.stderr)
        return 2
    demo = "--demo" in opciones
    if demo and args:
        print(f"{ROJO}ERROR{FIN}: --demo no admite capítulos; no se escribió nada.", file=sys.stderr)
        return 2

    comprobar = "--comprobar" in opciones
    dry_run = "--dry-run" in opciones
    escribir = not (comprobar or dry_run)
    directorio = Path(opciones["--fuentes"]) if "--fuentes" in opciones else (
        fuentes.DIR_PRUEBAS if demo else fuentes.DIR_FUENTES)

    try:
        referencias = fuentes.leer_referencias(directorio)
        fuentes.sha_csl(directorio)
        pandoc = version_de_pandoc()
    except fuentes.ErrorFuentes as e:
        print(f"{ROJO}ERROR{FIN}: {e}.", file=sys.stderr)
        return 1
    except SinPandoc as e:
        print(f"{ROJO}ERROR{FIN}: {e}. No se escribió nada.", file=sys.stderr)
        return 2

    print(f"{GRIS}Fuentes: {directorio} · {len(referencias)} entradas · "
          f"{fuentes.ruta_csl(directorio).name} · {fuentes.IDIOMA} · {pandoc}{FIN}")
    if dry_run:
        print(f"{AMAR}--dry-run: no se escribe nada.{FIN}")
    if comprobar:
        print(f"{AMAR}--comprobar: no se escribe nada; sale con 1 si algo cambiaría.{FIN}")
    print()

    if demo:
        rutas = [DEMO_ISLA]
    elif args:
        rutas = []
        for a in args:
            p = Path(a)
            rutas.extend([p] if p.exists() else sorted(MATERIAL.glob(a)))
    else:
        rutas = sorted(MATERIAL.glob("[0-9][0-9]_LPF_*.html"))
    if not rutas:
        print(f"{AMAR}Sin capítulos que estampar.{FIN}")
        return 0

    fallos = cambios = 0
    for ruta in rutas:
        try:
            if demo:
                notas, cambio = estampar_demo(referencias, directorio, escribir, dry_run)
            else:
                notas, cambio = estampar(ruta, referencias, directorio, escribir,
                                         "--sin-copia" not in opciones, dry_run)
            cambios += cambio
            if cambio and comprobar:
                estado = f"{ROJO}VIEJO{FIN}"
            else:
                estado = f"{VERDE}OK   {FIN}" if cambio else f"{GRIS}=    {FIN}"
            print(f"{estado} {ruta.name}")
            for n in notas:
                print(f"        {GRIS}·{FIN} {n}")
        except SinPandoc as e:
            print(f"{ROJO}ERROR{FIN}: {e}. No se escribió nada más.", file=sys.stderr)
            return 2
        except Fallo as e:
            print(f"{ROJO}FALLA{FIN} {ruta.name}")
            print(f"        {ROJO}✗{FIN} {e}")
            fallos += 1
        print()

    if fallos:
        print(f"{ROJO}{fallos} de {len(rutas)} sin estampar.{FIN}")
        return 1
    if comprobar and cambios:
        print(f"{ROJO}{cambios} de {len(rutas)} con la isla desactualizada: ejecute "
              f"estampar_referencias.py{' --demo' if demo else ''}.{FIN}")
        return 1
    print(f"{VERDE}{'La isla de la demo quedó' if demo else f'Los {len(rutas)} capítulos quedaron'} "
          f"al día.{FIN}")
    if escribir and cambios:
        print(f"{GRIS}Siguiente: {'ensamblar.py' if demo else 'verificar.py'}{FIN}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
