#!/usr/bin/env python3
"""
Estampa la librería canónica (`LP-CORE`) y el `App` de `_plantilla/lp-base.html`
en uno o varios capítulos del material.

Cubre los dos casos, y la diferencia la decide el propio archivo:

  · **Migrar** un capítulo heredado, que todavía trae la librería suelta y sin
    centinelas: se reemplaza desde `const { useState… }` hasta el cierre de
    `const Termino`, que es exactamente el tramo del que `ensamblar.py` compone
    la plantilla. El `CodeBlock` viejo que hay en medio desaparece: lo sustituye
    el de `lp-core-extra.jsx`.

  · **Reestampar** un capítulo ya migrado, cuando la librería cambia: se
    reemplaza de centinela a centinela. Es la operación que el README describe
    —«regenerar y volver a estampar el bloque en los capítulos ya escritos»— y
    la que hace que el ciclo de trabajo se cierre sin editar nada a mano.

En ambos casos se estampa además el `App`, no solo la librería. No es un extra:
el `App` es donde vivió el defecto de la barra lateral en móvil, que se corrigió
en `lp-demo.jsx` y nunca llegó al capítulo 1. Todo lo que varía de un capítulo a
otro está en `CONFIG` y en `curriculum`; el `App` en sí es plantilla.

Lo que NO se toca: todo lo que hay entre `LP-CORE FIN` y `const App`. Ahí vive el
contenido del capítulo.

Uso:
    python3 _plantilla/migrar.py                        # todos los capítulos
    python3 _plantilla/migrar.py 01_LPF_*.html          # archivos concretos
    python3 _plantilla/migrar.py --dry-run              # informa y no escribe
    python3 _plantilla/migrar.py --sin-copia            # no deja .bak

Devuelve 0 si todo se estampó, 1 si algo falló.
"""

import hashlib
import re
import shutil
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
MATERIAL = AQUI.parent
BASE = AQUI / "lp-base.html"

MARCA_INICIO = "/* === LP-CORE INICIO"
MARCA_FIN = "/* === LP-CORE FIN === */"

# Las mismas anclas que usa `ensamblar.py`, y por el mismo motivo: los números de
# línea cambian en cuanto alguien añade una librería al head.
ANCLA_LIB_INICIO = "const { useState, useEffect, useRef } = React;"
ANCLA_TERMINO = "const Termino = "
CIERRE = "        };"

ANCLA_APP_INICIO = "const App = () => {"
ANCLA_APP_FIN = "root.render(<App />);"

ROJO, VERDE, AMAR, GRIS, FIN = "\033[31m", "\033[32m", "\033[33m", "\033[90m", "\033[0m"


class Fallo(Exception):
    """Un ancla que no aparece. Se aborta el archivo entero, sin escribir nada."""


def indice_de(lineas, fragmento, desde=0):
    for i in range(desde, len(lineas)):
        if fragmento in lineas[i]:
            return i
    raise Fallo(f"no se encontró «{fragmento}»")


def cierre_de(lineas, desde):
    """Primera línea que sea exactamente `        };` a partir de `desde`.

    Los cierres anidados llevan más sangría, así que el primero con esta sangría
    exacta es el del componente que se está delimitando.
    """
    for i in range(desde, len(lineas)):
        if lineas[i].rstrip() == CIERRE:
            return i
    raise Fallo("no se encontró el cierre del bloque de la librería")


def tramo_libreria(lineas):
    """(inicio, fin, modo) del tramo que ocupa la librería de componentes.

    Si el capítulo ya trae centinelas, el tramo es de centinela a centinela.
    Si no, es el que `ensamblar.py` reconoce en un capítulo heredado.
    """
    try:
        i = indice_de(lineas, MARCA_INICIO)
        j = indice_de(lineas, MARCA_FIN, i)
        return i, j, "reestampado"
    except Fallo:
        pass

    i = indice_de(lineas, ANCLA_LIB_INICIO)
    j = cierre_de(lineas, indice_de(lineas, ANCLA_TERMINO, i))
    return i, j, "migración"


def tramo_app(lineas):
    i = indice_de(lineas, ANCLA_APP_INICIO)
    j = indice_de(lineas, ANCLA_APP_FIN, i)
    return i, j


def sha_core(texto):
    """SHA-256 del bloque LP-CORE, calculado igual que en `verificar.py`.

    Tiene que coincidir byte a byte: la comprobación 1 compara justo esto.
    """
    i = texto.find(MARCA_INICIO)
    j = texto.find(MARCA_FIN)
    if i == -1 or j == -1:
        return None
    return hashlib.sha256(texto[i:j + len(MARCA_FIN)].encode("utf-8")).hexdigest()


def config_para(ruta):
    """Esqueleto de `CONFIG` con lo que se puede deducir del nombre del archivo.

    El resto queda marcado con TODO a propósito: es más seguro que un valor
    inventado que parezca correcto. `grep TODO` los encuentra todos.
    """
    m = re.match(r"(\d+)_LPF_(.+)\.html$", ruta.name)
    numero = m.group(1) if m else "NN"
    nombre = m.group(2).replace("_", " ") if m else "Título del capítulo"
    clave = f"lpf_cap{numero}_{(m.group(2).lower() if m else 'capitulo')}"
    return f"""
        /* ============================================================
           CONFIGURACIÓN DEL CAPÍTULO
           Al crear un capítulo nuevo, esto es lo único que cambia aquí
           arriba; el contenido va en las secciones de más abajo.
        ============================================================ */
        const CONFIG = {{
            asignatura: 'Lógica de Programación Financiera',   // TODO si es otro curso
            lema: 'La lógica es la misma; el lenguaje solo cambia de acento.',   // TODO
            notaPie: 'Material de aprendizaje autónomo.',       // TODO
            numero: '{numero}',
            titulo: '{nombre}',                    // TODO revisar acentos y redacción
            subtitulo: '',                         // TODO
            horas: 0,                              // TODO del syllabus
            ra: 'RA1',                             // TODO del syllabus
            contenidoSyllabus: '',                 // TODO fila del syllabus
            temas: [],                             // TODO
            storageKey: '{clave}',
            docente: 'Javier Mauricio Sierra',
        }};
"""


def estampar(ruta, core, app, dry_run, con_copia):
    texto = ruta.read_text(encoding="utf-8")
    lineas = texto.splitlines()

    # Todo se localiza sobre el ORIGINAL antes de tocar nada: si un ancla falta,
    # el archivo se queda como estaba en vez de a medio estampar.
    lib_i, lib_j, modo = tramo_libreria(lineas)
    app_i, app_j = tramo_app(lineas)
    if app_i <= lib_j:
        raise Fallo("el `App` aparece antes del final de la librería; anclas cruzadas")

    nuevas = lineas[:lib_i] + core + lineas[lib_j + 1:app_i] + app + lineas[app_j + 1:]
    nuevo = "\n".join(nuevas) + ("\n" if texto.endswith("\n") else "")

    notas = [f"librería estampada ({modo}, {lib_j - lib_i + 1} → {len(core)} líneas)",
             f"App estampado ({app_j - app_i + 1} → {len(app)} líneas)"]

    # CONFIG: solo si no existe. Reescribirlo borraría lo que el docente ya puso.
    if not re.search(r"^\s*const CONFIG\s*=\s*\{", nuevo, re.M):
        k = nuevo.find(MARCA_FIN)
        corte = nuevo.find("\n", k) + 1
        nuevo = nuevo[:corte] + config_para(ruta) + nuevo[corte:]
        notas.append("CONFIG insertado con TODO por rellenar")
    else:
        notas.append(f"{GRIS}CONFIG ya existía, no se toca{FIN}")

    # El `STORAGE_KEY` suelto del App viejo queda huérfano: el App nuevo lee de
    # `CONFIG.storageKey`. Solo se borra si ya no lo referencia nadie más.
    if len(re.findall(r"\bSTORAGE_KEY\b", nuevo)) == 1:
        nuevo = re.sub(r"^\s*const STORAGE_KEY\s*=.*\n", "", nuevo, count=1, flags=re.M)
        notas.append("`STORAGE_KEY` huérfano retirado")

    h_cap, h_base = sha_core(nuevo), sha_core(BASE.read_text(encoding="utf-8"))
    if h_cap != h_base:
        raise Fallo(f"tras estampar, el LP-CORE no coincide con la plantilla "
                    f"({(h_cap or '—')[:12]}… ≠ {h_base[:12]}…). No se escribió nada.")

    if nuevo == texto:
        return ["ya estaba al día — no hubo cambios"], False

    if not dry_run:
        if con_copia:
            shutil.copy2(ruta, ruta.with_suffix(ruta.suffix + ".bak"))
            notas.append(f"{GRIS}copia en {ruta.name}.bak{FIN}")
        ruta.write_text(nuevo, encoding="utf-8")

    return notas, True


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    dry_run = "--dry-run" in sys.argv
    con_copia = "--sin-copia" not in sys.argv

    if not BASE.exists():
        print(f"{ROJO}ERROR{FIN}: falta {BASE}. Ejecute antes ensamblar.py.", file=sys.stderr)
        return 1

    base_lineas = BASE.read_text(encoding="utf-8").splitlines()
    try:
        ci, cj, _ = tramo_libreria(base_lineas)
        ai, aj = tramo_app(base_lineas)
    except Fallo as e:
        print(f"{ROJO}ERROR{FIN}: en lp-base.html, {e}.", file=sys.stderr)
        return 1
    core = base_lineas[ci:cj + 1]
    app = base_lineas[ai:aj + 1]

    if args:
        rutas = []
        for a in args:
            p = Path(a)
            rutas.extend([p] if p.exists() else sorted(MATERIAL.glob(a)))
    else:
        rutas = sorted(MATERIAL.glob("[0-9][0-9]_LPF_*.html"))

    if not rutas:
        print(f"{AMAR}Sin capítulos que estampar.{FIN}")
        return 0

    print(f"{GRIS}Plantilla: {sha_core(BASE.read_text(encoding='utf-8'))[:16]}…"
          f" · LP-CORE {len(core)} líneas · App {len(app)} líneas{FIN}")
    if dry_run:
        print(f"{AMAR}--dry-run: no se escribe nada.{FIN}")
    print()

    fallos = 0
    for ruta in rutas:
        try:
            notas, cambio = estampar(ruta, core, app, dry_run, con_copia)
            estado = f"{VERDE}OK   {FIN}" if cambio else f"{GRIS}=    {FIN}"
            print(f"{estado} {ruta.name}")
            for n in notas:
                print(f"        {GRIS}·{FIN} {n}")
        except Fallo as e:
            print(f"{ROJO}FALLA{FIN} {ruta.name}")
            print(f"        {ROJO}✗{FIN} {e}")
            fallos += 1
        print()

    if fallos:
        print(f"{ROJO}{fallos} de {len(rutas)} capítulos sin estampar.{FIN}")
        return 1
    print(f"{VERDE}Los {len(rutas)} capítulos quedaron con la librería al día.{FIN}")
    if not dry_run:
        print(f"{GRIS}Siguiente: verificar.py{FIN}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
