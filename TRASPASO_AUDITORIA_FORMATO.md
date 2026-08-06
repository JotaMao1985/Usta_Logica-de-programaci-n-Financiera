# Traspaso · Auditoría del formato y correcciones pendientes

> **Para retomar en una sesión nueva.** Contexto completo en
> `PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md` (§2 bis, §2 ter, §4, §4 bis)
> y `Material html/README.md`.
> Auditoría: 2026-08-04, ampliada el 2026-08-05 · Autor del material: Javier Mauricio Sierra.
>
> ## ✅ TODAS LAS TAREAS APLICADAS Y VERIFICADAS · 2026-08-05
>
> A1, A2, A3, B1, C1 y C2 están hechas, más la **comprobación 8** de
> `verificar.py` con sus tres pruebas negativas. Se corrigió además un **sexto
> defecto que esta auditoría no había visto**: la `explicacion` del E3 tenía el
> mismo fallo que el enunciado —citaba «línea 4» y «línea 5» y escribía la
> corrección en sintaxis de pseudocódigo—, así que pasó a objeto por lenguaje.
> Registro completo en la bitácora del plan (§11, entrada del 2026-08-05).
>
> **Lo que sigue:** puntos de control A y A-bis (revisión del docente) y luego
> la **Tarea 6: el capítulo 3 piloto**. Este documento se conserva como
> descripción de los defectos y de cómo se comprobaron.
>
> ## ↪ Continuado en `PLAN_TAREA7_CAPITULO_01.md` · 2026-08-05
>
> La **Tarea 7** se ejecutó completa y adelantada a la T6: el capítulo 1 está
> adaptado (13 ejercicios, once comprobaciones, 7 cloze) y el proceso quedó
> empaquetado en tres guiones nuevos —`migrar.py`, `ejecutar_salidas.py`,
> `verificar_cloze.R`— y la skill `lpf-capitulo`.
>
> Dos cosas de este documento quedaron **desactualizadas** y conviene leerlas ya
> corregidas en el plan nuevo: el capítulo 01 ya **no** está «migrado sin
> adaptar», y el guion que ejecuta las salidas —que la §5 daba por conservado—
> se había perdido y hubo que reconstruirlo. Esa pérdida es, por sí sola, el
> mejor argumento de la nota que cierra este documento.

---

## 1. Dónde está el proyecto

**Fases 0 y 0-bis completadas y verificadas.** Existe una plantilla funcional con
22 componentes, un banco Moodle que compila, y ocho comprobaciones automáticas.
**No hay ningún capítulo escrito todavía**: el 01 está migrado pero sin adaptar.

```
Logica de programacion/
├── PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md   plan maestro
├── TRASPASO_AUDITORIA_FORMATO.md                     este documento
├── Material html/
│   ├── README.md                     convenciones de autoría
│   ├── 01_LPF_Introduccion.html      migrado, SIN adaptar (Tarea 7)
│   └── _plantilla/
│       ├── lp-base.html              GENERADA — no editar a mano
│       ├── lp-core-extra.jsx         ← fuente de los componentes
│       ├── lp-demo.jsx               ← fuente de la demo + App
│       ├── ensamblar.py              genera lp-base.html
│       └── verificar.py              8 comprobaciones
├── Banco Moodle/                     compilar_banco.R + cloze piloto cap03
└── .claude/launch.json               servidores locales 8777 / 8778
```

**Ciclo de trabajo.** Nunca se edita `lp-base.html` ni el bloque `LP-CORE` de un
capítulo: se edita la fuente y se regenera.

```bash
python3 "Material html/_plantilla/ensamblar.py"
python3 "Material html/_plantilla/verificar.py" "Material html/_plantilla/lp-base.html" --sin-cuota
Rscript "Banco Moodle/compilar_banco.R"
```

Para ver la interactividad hace falta servirlo (el panel de vista previa
convierte los archivos externos en instantáneas estáticas):

```bash
python3 -m http.server 8777 --directory "Material html"
```

---

## 2. Resultado de la auditoría

### 🔴 A · Las pestañas de lenguaje se sincronizan entre bloques

**Confirmado.** Con dos `CodeTabs` en la sección 1, al pulsar «Python» en el
primero el segundo cambia también: `activasAntes: [Pseudo, Pseudo] →
activasDespues: [Python, Python]`.

Es la decisión **D4**, implementada a propósito mediante `localStorage` más un
evento `lpf:cambio-lenguaje`, y declarada en §2 ter como divergencia respecto del
material de Diseño de Experimentos. **El docente la ha revisado y no la quiere.**

**Decisión tomada (2026-08-04):** *por bloque, recordando la preferencia*.

- Cambiar un bloque **nunca** mueve a otro.
- El último lenguaje elegido pasa a ser el que muestran los bloques que el
  estudiante **aún no ha tocado**, y se recuerda entre visitas.
- Motivo de no ir a un «por bloque puro»: un capítulo tiene hasta 10 bloques de
  exposición y 5 componentes de ejercicio; sin memoria, quien lea en VBA
  tendría que elegirlo una y otra vez.

### 🟠 B · En móvil el contenido queda en 79 px

En un viewport de 375 px la barra lateral arranca **abierta** y ocupa 288 px
(18 rem), dejando el contenido en una columna de **79 px**: ilegible. Solo se
recupera (367 px, todo correcto) cuando el estudiante cierra el menú a mano.

Es un defecto **heredado del material de Deep Learning**, no introducido por la
Fase 0-bis: `useState(true)` en `sidebarOpen`, y el `<aside>` es hermano flex del
contenido, de modo que no superpone sino que **comprime**.

### 🔴 C · «Comprobar diagnóstico» parece no funcionar (E3)

Reportado por el docente el 2026-08-05. Al investigarlo aparecieron **dos**
defectos distintos; el segundo es más grave que el reportado.

#### C-1 · El botón está deshabilitado sin decir por qué

`DetectaError` exige **dos** respuestas —ubicar la línea y clasificar el error— y
mantiene el botón `disabled` hasta tener ambas. Reproducido: tras marcar solo la
línea, el botón sigue `disabled`, con `opacity: 0.4` y `cursor: default`, y
**nada indica qué falta**. Quien completa el Paso 1 y pulsa el botón no obtiene
ninguna reacción: desde su lado, está roto.

No es un fallo de la lógica —al completar los dos pasos responde bien— sino de
retroalimentación. Los demás componentes sí la dan: `Emparejamiento` rotula
«Comprobar (2/4)» y `TablaTraza` nunca deshabilita.

#### C-2 · El enunciado cita un número de línea que solo vale en pseudocódigo

El enunciado dice, fijo: *«así lo indica el comentario de **la línea 4**»*. Medido
en los cuatro lenguajes:

| Lenguaje | Comentario `PORCENTAJE` | Operación incorrecta | Total de líneas |
|---|:--:|:--:|:--:|
| Pseudocódigo | **4** | 5 | 7 |
| Python | **3** | 4 | 5 |
| R | **3** | 4 | 5 |
| VBA | **6** | 7 | 9 |

Es decir: **en Python, R y VBA el enunciado señala una línea que no es la que
dice**. En Python la línea 4 es `interes = capital * tasa`, justamente la
respuesta — el enunciado la regala mientras afirma otra cosa.

Es el mismo error que ya se corrigió en `lineaCorrecta`, pero en el **texto de la
pregunta**: se arregló la clave por lenguaje y se dejó el enunciado fijo.

### ✅ C · Lo que la auditoría descartó

Comprobado y sin hallazgos:

| Aspecto | Resultado |
|---|---|
| Contraste de los elementos nuevos | Todos ≥ 4,5:1 (`lp-code-title`, `lp-code-btn`, `lp-tab` inactiva, `lp-salida`, comentarios de Prism) |
| Foco de teclado | La regla `button:focus-visible` alcanza `.lp-tab` y `.lp-code-btn` |
| Desborde horizontal de página | Ninguno, ni en escritorio ni en móvil con el menú cerrado |
| Código largo | Desborda dentro de su propio contenedor con scroll, como debe |
| Gramática `pseudo` de Prism | Reconoce comment, string, keyword, builtin, function, number, operator |
| Cabeceras de bloque en móvil | Caben con el menú cerrado |
| Pestañas en móvil | 2 filas a 375 px — aceptable |

---

## 3. Tareas · ✅ todas aplicadas el 2026-08-05

### ✅ Tarea A1 · Pestañas por bloque con preferencia recordada
**Archivo:** `Material html/_plantilla/lp-core-extra.jsx`

**Qué hay hoy:** `CodeTabs` y `useLenguajeActivo` leen `CODETABS_KEY` y se
suscriben al evento `CODETABS_EVENTO`; al cambiar, cualquier instancia emite el
evento y **todas** las demás se actualizan.

**Qué debe quedar:**
- Cada instancia guarda su propio lenguaje en estado local.
- Al montarse, si el estudiante **no** ha tocado esa instancia, toma el valor de
  `localStorage[CODETABS_KEY]`; si no existe, el `defecto` del bloque.
- Al cambiar una instancia: actualiza **solo** su estado y escribe
  `localStorage[CODETABS_KEY]`. **No emite el evento global.**
- Retirar `CODETABS_EVENTO` y sus `addEventListener` de `CodeTabs` y de
  `useLenguajeActivo`, salvo que se decida conservarlo para otro uso.

**Criterios de aceptación**
- [x] Cambiar el bloque 1 a Python deja el bloque 2 como estaba
- [x] Recargar y abrir el capítulo muestra todos los bloques en el último
      lenguaje elegido
- [x] Los cinco componentes de ejercicio siguen la misma regla
- [x] `verificar.py` sigue en verde

**Verificación:** servir en 8777; comprobar `activasAntes` ≠ `activasDespues`
solo en el bloque tocado; recargar y confirmar la preferencia.

### ✅ Tarea A2 · Reescribir el texto de la demo que explica la sincronización
**Archivo:** `lp-demo.jsx`, sección 1

Hoy dice: *«Este segundo bloque existe para hacer visible la sincronización: al
cambiar la pestaña en cualquiera de los dos, el otro cambia también.»* Deja de
ser cierto. Sustituir por una explicación del comportamiento nuevo: los bloques
son independientes —para poder comparar dos lenguajes en pantalla a la vez— y el
material recuerda la última preferencia.

También hay que corregir la portada: *«La pestaña que se elija **se aplica a
todos los bloques del capítulo**»*, y la etiqueta «se aplica a todo el capítulo»
que `CodeTabs` pinta a la derecha de las pestañas.

### ✅ Tarea A3 · Actualizar D4 y §2 ter en el plan
`D4` pasa a describir el comportamiento por bloque. En §2 ter, la fila «la
pestaña sigue siendo global al capítulo» de la tabla de divergencias sale: ya no
hay tal divergencia con el material de referencia.

### ✅ Tarea B1 · Barra lateral cerrada por defecto en móvil
**Archivo:** `lp-demo.jsx`, componente `App`

`useState(true)` → abierta si `window.innerWidth >= 1024`, cerrada si no.

**Criterios de aceptación**
- [x] A 375 px el contenido arranca con ~367 px de ancho
- [x] En escritorio la barra sigue abierta al entrar
- [x] El botón flotante sigue abriéndola y cerrándola

**Verificación:** `resize_window` a mobile, recargar, medir
`#contenido-scroll.clientWidth`.

### ✅ Tarea C1 · Que el botón diga qué falta
**Archivo:** `lp-core-extra.jsx`, componente `DetectaError`

Mantener las dos respuestas obligatorias, pero hacer visible el progreso, como
hace `Emparejamiento`. Opciones (basta una):

- Rotular el botón con el estado: «Comprobar diagnóstico (1/2)».
- O no deshabilitarlo y, al pulsarlo incompleto, resaltar el paso que falta.

**Criterios de aceptación**
- [x] Con un solo paso hecho, la interfaz dice cuál falta
- [x] Con los dos, el botón califica como hasta ahora
- [x] La retroalimentación diferenciada («ubicó bien la línea pero…») se conserva

**Verificación:** servir en 8777; marcar solo la línea y comprobar que hay
indicación; completar y confirmar el veredicto.

### ✅ Tarea C2 · Enunciado por lenguaje en `DetectaError`
**Archivos:** `lp-core-extra.jsx` y `lp-demo.jsx`

`enunciado` debe admitir un objeto `{pseudo, python, r, vba}`, igual que `lineas`
y `lineaCorrecta` (usar el ayudante `porLenguaje` que ya existe). Reescribir el
enunciado de la demo con el número correcto en cada lenguaje —4, 3, 3 y 6— o,
mejor, **redactarlo sin citar ningún número**: «así lo indica el comentario que
acompaña a la asignación de `tasa`». Lo segundo es más robusto y evita que el
enunciado envejezca al retocar el código.

**Criterios de aceptación**
- [x] Al cambiar de pestaña, el enunciado sigue siendo cierto en los cuatro
- [x] Ningún enunciado cita un número de línea que dependa del lenguaje sin ser
      por lenguaje

**Verificación:** recorrer los cuatro lenguajes y contrastar el enunciado con la
tabla de C-2.

**Ampliar `verificar.py` (comprobación 8):** avisar cuando un `DetectaError` con
`lineas` multilingüe tenga un `enunciado` que **no** sea multilingüe y contenga
la expresión «línea N». Es el mismo fallo silencioso que motivó la comprobación 6.
Recordar la prueba negativa.

### ✅ Checkpoint
- [x] `ensamblar.py` + `verificar.py` en verde
- [x] Consola sin errores
- [x] Revisión del docente antes de la Tarea 6

---

## 4. Lo que viene después

Con esto cerrado quedan pendientes los **puntos de control A y A-bis** (revisión
del docente) y luego la **Tarea 6: el capítulo 3 piloto**, «Control secuencial»,
descrita en §5 y §6 del plan.

---

## 5. Notas para quien retome

**El patrón que se repite.** Cuatro de los cinco defectos hallados son el mismo
error de fondo: **se arregló el mecanismo y se dejó sin arreglar lo que lo
acompaña.** Se hizo `lineaCorrecta` multilingüe y se dejó el enunciado fijo; se
sincronizaron las pestañas y se dejó el texto que lo explicaba; se hicieron los
ejercicios multilingües y la exposición ya lo era. Al tocar un componente,
revisar SIEMPRE los textos que hablan de él.

**Verificar de verdad, no de vista.** Tres errores de esta sesión no se veían en
pantalla y solo aparecieron al ejecutar:

- Un `#> 600000` copiado por descuido a los bloques del ejercicio E4, cuyo
  resultado real es 2 400 000: **el código contradecía la clave del propio
  ejercicio**. Lo cazó el guion que ejecuta los bloques de Python y R y compara
  su salida real con la declarada. Conviene conservarlo y correrlo en cada
  capítulo.
- Una comprobación del verificador que no detectaba nada porque el patrón
  `<DetectaError[\s\S]*?/>` se cortaba en el `</>` de un fragmento JSX.
- Otra que veía la mitad de los bloques por consumir el `\n` que el bloque
  siguiente necesitaba.

**Siempre prueba negativa.** Una comprobación que nunca ha fallado no está
comprobando nada. Las siete de `verificar.py` tienen la suya.

**Iconos.** Font Awesome ≥ 6.5 es obligatorio y `ensamblar.py` lo verifica:
`fa-clipboard-question` estuvo invisible desde el material heredado sin producir
un solo error en consola.

**Contraste.** Medir todo color nuevo sobre `#F8FAFC` antes de usarlo. El gold
`#FDB913` **nunca** va como texto sobre fondo claro (1,66:1).
