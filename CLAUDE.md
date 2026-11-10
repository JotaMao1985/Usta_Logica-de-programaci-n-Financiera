# Lógica de Programación Financiera — material del curso

Material de estudio HTML de la asignatura (Universidad Santo Tomás). Un archivo
autocontenido por capítulo, con todo el código en cuatro lenguajes en paralelo
(pseudocódigo → Python → R → VBA). El repositorio es **público** y GitHub Pages publica
la raíz tal cual: todo lo que se versiona, se publica.

Responder en español y tratar al docente de usted.

## Dónde está cada cosa

| Ruta | Contenido |
|---|---|
| `Material html/0N_LPF_*.html` | Los capítulos. Cada uno lleva estampada la librería LP-CORE. |
| `Material html/README.md` | Convenciones de autoría. Leerlo antes de tocar un capítulo. |
| `Material html/_plantilla/` | `ensamblar.py`, `migrar.py`, `verificar.py` y sus auxiliares. |
| `Material html/_fuentes/` | Referencias exportadas de Zotero, registro de afirmaciones y `POLITICA_DE_FUENTES.md`. |
| `PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md` | Plan maestro; la bitácora está en la §11. |
| `PLAN_TAREA*_CAPITULO_*.md` | El plan de cada capítulo, con sus puntos de control. |
| `Vault/`, `.obsidian/` | Vault privado de Obsidian. **No está en el repositorio** (ver abajo). |
| `Banco Moodle/`, `parcial/blueprint*.yml`, syllabus `.xlsx` | Instrumentos de evaluación y documento institucional. **Nunca se versionan aquí.** |

## Reglas de fuentes (obligatorias)

La política completa está en `Material html/_fuentes/POLITICA_DE_FUENTES.md`. Lo que
ninguna sesión puede saltarse:

1. **Una referencia solo existe si está en Zotero.** No se escribe una referencia de
   memoria, ni en el HTML ni en una nota. Los metadatos se traen de donde se verifica el
   identificador: Crossref para un DOI, un catálogo para un ISBN, la página oficial para
   una norma o un dato.
2. **La lista «Referencias» de un capítulo se genera**, con `estampar_referencias.py`,
   desde `Material html/_fuentes/referencias.json`. Nunca se teclea ni se retoca a mano.
3. **Una afirmación solo se atribuye a una fuente que se haya leído**: el pasaje, con
   página o sección, queda copiado en la nota de la afirmación en el vault antes de
   escribir `<Cita>`. Si no se pudo leer la fuente, no se cita.
4. **Toda afirmación fáctica cae en una de cinco clases**: citada, ejecutada (regla 9),
   derivada (la aritmética está a la vista), ilustrativa (inventada y declarada como
   tal) o criterio del docente (redactada como opinión). Lo que no cabe en ninguna se
   reescribe o se quita.
5. **No respaldan nada**: Wikipedia, blogs, W3Schools, salidas de IA ni la memoria del
   modelo. Sirven para encontrar la fuente, no para citarla.
6. Si una cifra, una fecha o una norma no se puede verificar, se dice así y se deja
   pendiente. No se rellena.

## El vault

- Es la carpeta principal del curso abierta en Obsidian. Todo lo que el vault produce
  vive bajo `Vault/`; las propiedades y sus valores permitidos están en
  `Vault/Esquema de datos.md`, y el estado del trabajo en `Vault/00 Inicio.md`.
- Una nota por fuente (`Vault/Fuentes/`), una por afirmación (`Vault/Afirmaciones/`),
  una por concepto, figura, hilo narrativo y decisión. Se crean con las plantillas de
  `Vault/Plantillas/`. Solo Bases nativo: ningún plugin de comunidad.
- Los extractos de libros se quedan en el vault. Al repositorio solo va
  `Material html/_fuentes/afirmaciones/NN.yaml`, que se genera desde las notas y no
  lleva el texto del extracto.
- Desde un worktree, la carpeta principal se encuentra con `git worktree list`. Si una
  sesión no alcanza el vault, deja la afirmación como pendiente; no inventa el registro.

## Reglas de git

- En este repositorio trabajan varias sesiones a la vez. `git add` con rutas explícitas
  de lo que se tocó; **nunca `git add -A` ni `git add .`**. Mirar `git status --short`
  antes de hacer commit y preguntar por cualquier archivo que no se reconozca.
- `Vault/` y `.obsidian/` están excluidos en `.gitignore`. Si aparecen en
  `git status`, parar y avisar.
- Nada llega a `main` sin la aprobación del docente en un punto de control.

## Cómo se trabaja

- **Por fases, con puntos de control.** Se presenta el plan, se ejecuta una fase y se
  para en el punto de control acordado aunque quede tiempo.
- **Los huecos de las herramientas se reportan** con el mismo detalle que el entregable,
  y se cierran en el repositorio: README, regla nueva con su prueba negativa, bitácora.
- No editar a mano `lp-base.html`, el bloque `LP-CORE` de un capítulo ni el bloque
  `LP-REFS`: se regeneran con `ensamblar.py`, `migrar.py` y `estampar_referencias.py`.
- Antes de dar algo por terminado: `python3 "Material html/_plantilla/verificar.py"`.
- Los ejercicios son de interpretación (taxonomía E1–E8); no se escribe «elabore un
  programa que…».
