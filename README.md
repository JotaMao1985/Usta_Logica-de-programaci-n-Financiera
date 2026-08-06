# Lógica de Programación Financiera · Universidad Santo Tomás

Material de aprendizaje autónomo del curso, 2026-II. Cada capítulo es **un
archivo HTML autocontenido** que se abre con doble clic: sin servidor, sin
`npm`, sin compilar nada.

**→ [Abrir el material](https://jotamao1985.github.io/Usta_Logica-de-programaci-n-Financiera/)**

Docente y diseño del material: Javier Mauricio Sierra.

## De qué va

Todo el código del curso se presenta en **cuatro lenguajes a la vez**
—pseudocódigo, Python, R y VBA— en pestañas independientes por bloque. El
pseudocódigo es el único normativo, que es lo que evalúa el RA1 del syllabus;
los otros tres existen para hacer visible que la lógica no cambia, solo el
acento.

Los ejercicios **no piden escribir programas desde cero**: eso es de los
talleres. Aquí se lee, se traza, se diagnostica, se compara y se interpreta,
según una taxonomía cerrada de ocho tipos (E1–E8) con cuota por capítulo.

## Estado

| Capítulo | Estado |
|---|---|
| 01 · Introducción | ✅ publicado — 13 ejercicios, 4 secciones |
| 02–08 | en preparación |

## Estructura

```
├── index.html                    portal (lo que sirve GitHub Pages)
├── Material html/
│   ├── 01_LPF_Introduccion.html  … 08_LPF_Funciones.html
│   ├── README.md                 ← convenciones de autoría: EMPIECE AQUÍ
│   └── _plantilla/
│       ├── lp-base.html          plantilla GENERADA — no se edita a mano
│       ├── lp-core-extra.jsx     componentes compartidos (fuente)
│       ├── lp-demo.jsx           capítulo de demostración + App (fuente)
│       ├── ensamblar.py          fuentes  → lp-base.html
│       ├── migrar.py             plantilla → capítulos
│       ├── verificar.py          once comprobaciones estructurales
│       └── ejecutar_salidas.py   ejecuta el código y contrasta lo que declara
├── PLAN_MATERIAL_…md             plan maestro y bitácora
├── PLAN_TAREA7_CAPITULO_01.md    registro de la adaptación del capítulo 1
└── TRASPASO_AUDITORIA_FORMATO.md auditoría de formato (2026-08-05)
```

Las **convenciones** —paleta, prefijos de salida, catálogo de componentes,
reglas de los ejercicios multilingües— viven en
[`Material html/README.md`](Material%20html/README.md). Este archivo no las
repite a propósito: duplicarlas garantizaría que en unos meses digan cosas
distintas.

## Trabajar en el material

```bash
python3 "Material html/_plantilla/ensamblar.py"                 # solo si cambió la librería
python3 "Material html/_plantilla/migrar.py" --dry-run          # ver qué estamparía
python3 "Material html/_plantilla/migrar.py"                    # estampar LP-CORE + App
python3 "Material html/_plantilla/verificar.py" --con-salidas   # auditar
python3 -m http.server 8777 --directory "Material html"         # servirlo para depurar
```

Nunca se edita `lp-base.html` ni el bloque `LP-CORE` de un capítulo: se edita la
fuente, se regenera y se reestampa. La comprobación 1 compara ese bloque byte a
byte contra la plantilla y falla si alguien lo tocó.

`verificar.py --con-salidas` **ejecuta** los bloques de Python y R y compara su
salida real con la declarada tras `#>`. Es el único control que caza una cifra
falsa: una salida equivocada no se ve en pantalla, se lee como cualquier otra.

## Lo que deliberadamente no está aquí

- **El banco de preguntas de Moodle.** Los ejercicios cloze contienen las claves
  de los cuestionarios evaluables, y este repositorio es público. Vive fuera de
  él. (El material HTML sí revela sus soluciones: es de estudio, no de
  evaluación.)
- **El syllabus institucional.** Es un formato interno de la USTA. El material
  cita textualmente lo que necesita —RA, contenidos y horas— en el objeto
  `CONFIG` de cada capítulo.

## Requisitos

Para **leer** el material: un navegador y conexión a internet la primera vez
(React, Tailwind, Plotly, Prism, Font Awesome y MathJax se cargan desde CDN y
después quedan en caché).

Para **trabajar** en él: Python 3.10+ y R 4.x con el paquete `exams`. Font
Awesome debe ser ≥ 6.5 — `ensamblar.py` falla si no lo es, porque varios iconos
del material no existen antes de esa versión y aparecen como huecos en blanco
sin producir un solo error en consola.
