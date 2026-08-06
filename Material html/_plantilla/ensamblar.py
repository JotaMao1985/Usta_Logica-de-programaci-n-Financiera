#!/usr/bin/env python3
"""
Ensambla `_plantilla/lp-base.html` — la FUENTE DE VERDAD de la librería de
componentes del curso Lógica de Programación Financiera.

El archivo resultante es autocontenido (se abre con doble clic, sin servidor
ni build). Este script existe únicamente para *construir* esa plantilla a
partir de piezas revisables por separado, y para poder regenerarla cuando la
librería cambie.

Composición (los tramos se localizan por contenido, no por número de línea):
    head            del capítulo 1 hasta <script type="text/babel">
    LP-CORE INICIO
      partA         helpers de MathJax, Icons, renderIcon
      partB         Box … Termino  (omite el CodeBlock viejo, que se reemplaza)
      lp-core-extra.jsx              iconos extra, resaltado de 4 lenguajes,
                                     CodeBlock nuevo, Timeline, CodeTabs y los
                                     5 componentes de ejercicio
    LP-CORE FIN
    lp-demo.jsx     capítulo de demostración + App

Uso:
    python3 _plantilla/ensamblar.py
"""

import re
import sys
from pathlib import Path

AQUI = Path(__file__).resolve().parent
MATERIAL = AQUI.parent

FUENTE = MATERIAL / "01_LPF_Introduccion.html"
EXTRA = AQUI / "lp-core-extra.jsx"
DEMO = AQUI / "lp-demo.jsx"
SALIDA = AQUI / "lp-base.html"

# Los cortes se localizan POR CONTENIDO, no por número de línea: el `head`
# crece cada vez que se añade una librería, y unas constantes numéricas
# obligarían a recalcularlas a mano en cada cambio.
ANCLA_FIN_HEAD = '<script type="text/babel">'
ANCLA_INICIO_A = "const { useState, useEffect, useRef } = React;"
ANCLA_FIN_A = "const renderIcon = "
ANCLA_INICIO_B = "const Box = "
ANCLA_FIN_B = "const Termino = "
CIERRE = "        };"

SENTINELA_INICIO = "        /* === LP-CORE INICIO — no editar a mano: se genera con ensamblar.py === */"
SENTINELA_FIN = "        /* === LP-CORE FIN === */"

FA_MINIMA = (6, 5, 0)

TITULO = "Lógica de Programación Financiera — Plantilla base"
DESCRIPCION = (
    "Plantilla base y catálogo de componentes del material de Lógica de "
    "Programación Financiera. Universidad Santo Tomás."
)


def indice_de(lineas, fragmento, desde=0):
    for i in range(desde, len(lineas)):
        if fragmento in lineas[i]:
            return i
    raise SystemExit(f"ERROR: no se encontró «{fragmento}» en {FUENTE.name}.")


def cierre_de(lineas, desde):
    """Primera línea que sea exactamente `        };` a partir de `desde`.

    Los cierres anidados llevan más sangría, así que el primero con esta
    sangría exacta es el del componente que se está delimitando.
    """
    for i in range(desde, len(lineas)):
        if lineas[i].rstrip() == CIERRE:
            return i
    raise SystemExit(f"ERROR: no se encontró el cierre del bloque en {FUENTE.name}.")


def main():
    for f in (FUENTE, EXTRA, DEMO):
        if not f.exists():
            print(f"ERROR: no se encuentra {f}", file=sys.stderr)
            sys.exit(1)

    lineas = FUENTE.read_text(encoding="utf-8").splitlines()

    i_head = indice_de(lineas, ANCLA_FIN_HEAD)
    i_a0 = indice_de(lineas, ANCLA_INICIO_A, i_head)
    i_a1 = cierre_de(lineas, indice_de(lineas, ANCLA_FIN_A, i_a0))
    i_b0 = indice_de(lineas, ANCLA_INICIO_B, i_a1)
    i_b1 = cierre_de(lineas, indice_de(lineas, ANCLA_FIN_B, i_b0))

    head = lineas[:i_head + 1]
    part_a = lineas[i_a0:i_a1 + 1]
    part_b = lineas[i_b0:i_b1 + 1]

    # Título y descripción propios de la plantilla.
    head_txt = "\n".join(head)
    ini = head_txt.find("<title>")
    fin = head_txt.find("</title>")
    if ini == -1 or fin == -1:
        print("ERROR: no se encontró la etiqueta <title> en el head.", file=sys.stderr)
        sys.exit(1)
    head_txt = head_txt[:ini] + f"<title>{TITULO}</title>" + head_txt[fin + len("</title>"):]

    ini = head_txt.find('content="Material de aprendizaje')
    if ini != -1:
        fin = head_txt.find('"', ini + len('content="'))
        head_txt = head_txt[:ini] + f'content="{DESCRIPCION}"' + head_txt[fin + 1:]

    # Font Awesome < 6.5 no trae fa-clipboard-question, fa-money-bill-trend-up
    # ni fa-magnifying-glass-chart: los iconos salen como huecos en blanco,
    # sin error de consola. Se falla aquí antes que descubrirlo en el aula.
    m = re.search(r"font-awesome/(\d+)\.(\d+)\.(\d+)", head_txt)
    if not m:
        print("ERROR: no se encontró el CDN de Font Awesome en el head.", file=sys.stderr)
        sys.exit(1)
    version = tuple(int(x) for x in m.groups())
    if version < FA_MINIMA:
        print(f"ERROR: Font Awesome {'.'.join(map(str, version))} es anterior a "
              f"{'.'.join(map(str, FA_MINIMA))}; varios iconos del material no existen "
              f"en esa versión.\n       Actualice el enlace en {FUENTE.name}.", file=sys.stderr)
        sys.exit(1)

    partes = [
        head_txt,
        "",
        SENTINELA_INICIO,
        "\n".join(part_a),
        "\n".join(part_b),
        EXTRA.read_text(encoding="utf-8").rstrip("\n"),
        SENTINELA_FIN,
        "",
        DEMO.read_text(encoding="utf-8").rstrip("\n"),
        "    </script>",
        "</body>",
        "",
        "</html>",
        "",
    ]

    SALIDA.write_text("\n".join(partes), encoding="utf-8")

    n_lineas = len(SALIDA.read_text(encoding="utf-8").splitlines())
    kb = SALIDA.stat().st_size / 1024
    print(f"OK  {SALIDA.relative_to(MATERIAL.parent)}")
    print(f"    {n_lineas} líneas · {kb:.0f} KB")


if __name__ == "__main__":
    main()
