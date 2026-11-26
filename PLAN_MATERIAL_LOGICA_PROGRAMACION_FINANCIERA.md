# Plan de implementación — Material de estudio
## Lógica de Programación Financiera · Universidad Santo Tomás · 2026-II

> Documento de planeación. No contiene material final: define **qué** se construye, **en qué orden**, **con qué criterios de aceptación** y **cómo se verifica**.
> Creado: 2026-08-03 · Última actualización: 2026-08-05
> **Estado: Fases 0 y 0-bis completadas y verificadas.**
> ✅ Auditoría del 2026-08-04, ampliada el 2026-08-05: **las cinco correcciones
> aplicadas y verificadas el 2026-08-05.** Pestañas por bloque (revoca **D4**),
> barra lateral cerrada en móvil, progreso visible en el botón del E3, y
> `enunciado` y `explicacion` por lenguaje con la comprobación 8 que lo vigila.
> Detalle en **`TRASPASO_AUDITORIA_FORMATO.md`**. Sigue el punto de control A.

---

## 1. Resumen

Se construirán **8 archivos HTML autocontenidos** (uno por fila de contenido del syllabus, 64 horas en total), con el formato del material de Deep Learning: React 18 + Babel en el navegador, Tailwind, Plotly, MathJax, barra lateral con progreso, reanudación por `localStorage` y una librería de componentes pedagógicos compartida.

Cuatro decisiones marcan el carácter del material:

1. **Cuatro lenguajes en pestañas** — cada bloque de código se presenta como `Pseudocódigo → Python → R → VBA`. El pseudocódigo es el lenguaje *normativo* (es lo que el RA1 evalúa); los otros tres son *traducciones* que muestran que la lógica es invariante y que el estudiante ya sabe leer el lenguaje que usa la industria.
2. **Ejercicios de interpretación, no de transcripción** — se define una taxonomía cerrada de 8 tipos de ejercicio (§4). Queda **explícitamente excluido** el ejercicio "escriba desde cero un programa que…"; eso pertenece a los talleres evaluables, no al material de estudio.
3. **Toda sección abre con una motivación** — una escena concreta del sector financiero y la pregunta que la sección viene a responder, antes de cualquier definición. No es decorativo: es lo que sostiene la lectura autónoma, que es el modo en que este material se usa. Es obligatorio y verificable (§4 bis).
4. **Trazabilidad 1:1 con el syllabus** — un archivo por fila de contenido, con las horas y el Resultado de Aprendizaje declarados en la portada de cada uno. Facilita la evidencia para acreditación.

Entregables complementarios: portal índice de navegación, banco de preguntas cloze para Moodle (R/exams) y guía docente con rúbricas operacionalizadas.

---

## 2. Decisiones de arquitectura

| # | Decisión | Justificación |
|---|---|---|
| **D0** | **Cuatro lenguajes en paralelo: pseudocódigo (normativo) → Python → R → VBA** · *decisión del docente, 2026-08-03* | Es la decisión que más define el material y condiciona a todas las demás. Detalle completo en §2 bis. El pseudocódigo es lo único que el RA1 evalúa; los otros tres muestran que **la lógica es invariante y solo cambia la sintaxis**, y dejan al estudiante leyendo el lenguaje que su sector usa. |
| D1 | **8 archivos HTML, 1:1 con el syllabus** | Trazabilidad para acreditación; cada archivo (~2 000–2 800 líneas) es abarcable en una sesión de trabajo y de estudio. |
| D2 | **Autocontenido, sin build step** | El archivo se abre con doble clic (`file://`). No hay npm, ni bundler, ni servidor. Es la propiedad que hace utilizable el material de Deep Learning y se conserva. |
| D3 | **Librería de componentes duplicada + verificador de deriva** | D2 impide un `import` compartido desde `file://`. Se mantiene un bloque de componentes idéntico en los 8 archivos, delimitado por centinelas, y un script compara su hash SHA-256. La deriva se detecta, no se previene por arquitectura. |
| D4-bis | **`CodeTabs` por bloque, recordando la última preferencia** | Sustituye a la D4 original (*pestaña sincronizada en todo el capítulo*), **revocada el 2026-08-04** tras revisión del docente: sincronizar impedía tener dos lenguajes en pantalla a la vez para compararlos, que es justo lo que hace ver que la lógica es invariante (D0). Regla: cambiar un bloque **nunca** mueve a otro; la última elección se guarda en `localStorage` y es con la que abren, al montarse, los bloques que el estudiante aún no ha tocado —también entre visitas—. No se va a un «por bloque puro» porque un capítulo tiene hasta 10 bloques de exposición y 5 componentes de ejercicio: sin memoria, quien lea en VBA tendría que elegirlo 15 veces. La preferencia recordada **gana sobre el `defecto` del bloque**; `defecto` solo actúa en la primera visita de todas. Aplicada y verificada el 2026-08-05. |
| D5 | **Pseudocódigo en español según Joyanes/Cairo** | Ambos están en la bibliografía del syllabus. Convención: `Inicio/Fin`, `Leer`, `Escribir`, `Si…Entonces…Sino…FinSi`, `Segun…FinSegun`, `Mientras…FinMientras`, `Para…FinPara`, `Repita…Hasta`. |
| D6 | **Reordenar: Entorno VBA (cap. 6) antes que Arrays (cap. 7)** | El syllabus lista Arrays primero, pero no se pueden codificar arreglos en un entorno que aún no se conoce. Las horas no cambian (12 h + 12 h). **Desviación documentada respecto del syllabus.** |
| ~~D7~~ | ~~Paleta financiera navy `#0A2647` / gold `#F0A500`~~ | **REVOCADA el 2026-08-04.** Ver D7-bis. |
| D7-bis | **Paleta institucional USTA: `primary #3D008D` · `secondary #ED1E79` · `navy #001A4D` · `gold #FDB913` · `teal #0E7490`** | Idéntica al material de referencia. Dos razones, y la segunda pesa más que la primera: (1) la morada/magenta es la **institucional** —aparece igual en los 5 archivos del curso de Deep Learning y así está rotulada en su CSS—, mientras que la navy/gold no correspondía a ninguna identidad; (2) el gold `#F0A500` se usaba como **color de los títulos `h3`** y da **1,99:1** de contraste sobre el fondo `#F8FAFC`: falla WCAG AA incluso para texto grande (mínimo 3,0:1). El `#ED1E79` institucional da 3,96:1 y sí pasa. |
| D8 | **Banco Moodle vía R/exams `cloze` → `exams2moodle()`** | `exams 2.4.3` ya está instalado y verificado en la máquina. Los cloze permiten variantes aleatorias por estudiante (anti-copia) y corrección automática de sub-respuestas mixtas (`num`, `schoice`, `string`). |
| D9 | **Hilo financiero conductor, sin proyecto evaluable por fases** | Se descartó el proyecto integrador. En su lugar, todos los capítulos operan sobre el mismo dominio —**cartera de crédito de libre inversión de un banco colombiano**— para que el vocabulario financiero se acumule en vez de reiniciarse. |
| D10 | **Motivación obligatoria al inicio de cada sección** | El material se estudia sin docente delante. Una sección que abre con una definición pierde al lector antes del tercer párrafo; una que abre con una escena y una pregunta le da una razón para seguir. Se implementa como componente `Motivacion` y se comprueba automáticamente. |
| D11 | **La plantilla se genera, no se copia a mano** | `ensamblar.py` compone `lp-base.html` desde piezas revisables por separado. Añadido durante la Fase 0: el plan original solo *detectaba* la deriva de componentes; ahora también permite **regenerar** la librería y volver a estamparla en los capítulos. No rompe D2 —la salida sigue siendo un HTML autocontenido—. |

---

## 2 bis. Los cuatro lenguajes en paralelo

Desarrollo de **D0**. Todo algoritmo del material se presenta simultáneamente en cuatro versiones, en este orden fijo, dentro de un componente `CodeTabs` cuya pestaña es **propia de cada bloque** y recuerda la última preferencia del estudiante (D4-bis).

### Qué papel cumple cada uno

| Lenguaje | Papel | Por qué está |
|---|---|---|
| **Pseudocódigo** | **Normativo** — es el único que se evalúa | El RA1 del syllabus dice «construye un algoritmo», no «programa en X». El pseudocódigo expresa la lógica sin atarla a ninguna herramienta, y es la notación de Joyanes y Cairo, que están en la bibliografía |
| **Python** | Comprobación | Legible y ejecutable en cualquier parte. Permite verificar en segundos que el algoritmo hace lo que se dice que hace |
| **R** | Perfil cuantitativo | Es el lenguaje del análisis estadístico y financiero, cercano al programa académico. Además es el motor del banco de preguntas (D8) |
| **VBA (Excel)** | Destino profesional | Es lo que efectivamente se usa en las áreas financieras y lo que el RA2 exige. Los capítulos 6–8 son suyos |

### Reglas de aplicación

1. **Orden fijo:** Pseudocódigo → Python → R → VBA. No se altera entre capítulos.
2. **Pestaña por defecto:** `pseudo` en los capítulos 1–5 (dominio del RA1); `vba` en los capítulos 6–8 (dominio del RA2).
3. **Una sola elección por capítulo:** al cambiar de pestaña en cualquier bloque, todos los demás cambian y la preferencia se recuerda entre visitas.
4. **Los ejercicios también, no solo la exposición.** Los cinco componentes de ejercicio (E1, E3, E4, E5, E6) siguen la misma regla que `CodeTabs` (D4-bis): pestaña propia y arranque en la última preferencia guardada. Si el estudiante lee en VBA y el ejercicio abriera en pseudocódigo, el material cambiaría de idioma justo al pasar de la teoría a la práctica. **Atención:** en `DetectaError` la línea del fallo cambia con el lenguaje —en el ejemplo de la plantilla es la 5, la 4, la 4 y la 7—, así que `lineaCorrecta` va por lenguaje; un número fijo califica mal en silencio (regla 6 de `verificar.py`). Y con la clave va el **texto**: un `enunciado` o una `explicacion` que citen «la línea N» tienen el mismo problema, y lo vigila la regla 8.
5. **Lo que NO se traduce:** los valores de las variables en una tabla de traza son idénticos en los cuatro lenguajes, y hacérselo ver al estudiante es justamente el objetivo del ejercicio.
6. **La traducción no es obligatoria cuando no aporta.** Si un concepto solo existe en un lenguaje —el modelo de objetos de Excel, por ejemplo— se usa `CodeBlock` de un solo lenguaje y **se dice por qué**. Traducir por completismo produce ruido.
7. **Toda salida documentada debe haberse ejecutado.** Python y R se ejecutan por script; VBA se verifica en Excel real (riesgo R2). Nunca se documenta una salida supuesta.

### Énfasis por capítulo

Los cuatro están presentes en todos, pero el peso cambia:

| Cap. | Pseudo | Python | R | VBA | Nota |
|---|:--:|:--:|:--:|:--:|---|
| 1 · Introducción | ●●● | ●● | ●● | ● | El punto flotante se ve mejor en Python y R |
| 2 · Algoritmos | ●●● | ● | ● | ● | Predominio del pseudocódigo y el flujograma |
| 3 · Secuencial | ●●● | ●● | ●● | ● | Traza sobre pseudocódigo |
| 4 · Selectivo | ●●● | ●● | ●● | ●● | `Select Case` anticipa el cap. 6 |
| 5 · Repetitivo | ●●● | ●● | ●● | ●● | La TIR por bisección luce en R |
| 6 · Entorno VBA | ● | ● | ● | ●●● | Aquí el pseudocódigo pasa a segundo plano |
| 7 · Arrays | ●● | ●● | ●●● | ●●● | R aporta la matriz de covarianzas |
| 8 · Funciones | ●● | ●● | ●● | ●●● | Las UDF son el objetivo |

### El costo, declarado

Cuatro lenguajes × ~30 bloques × 8 capítulos ≈ **960 fragmentos de código**. Es la mayor superficie de error del proyecto y está registrada como riesgo **R3**. Las reglas 6 y 7 existen precisamente para acotarla.

---

## 2 ter. Presentación de los bloques de código

**Referencia adoptada:** `Bosque 2026/Diseno de experimentos/Htmls/capitulo-1-introduccion-comparativos.html`, módulo 1.1, subsección *«El diseño, escrito en código»*. Es el patrón que se replica.

### Anatomía del patrón de referencia

| Elemento | Especificación |
|---|---|
| Pestañas | Encima del bloque, forma de carpeta (`border-radius: .5rem .5rem 0 0`). Inactiva `#E2E8F0` sobre `#64748B`; activa en degradado oscuro, conectada visualmente con el bloque (`border-top-left-radius: 0`) |
| Cabecera | Mismo degradado oscuro. Título del lenguaje en versalitas `#94A3B8` a la izquierda; **Copiar** y **Mostrar/Ocultar** a la derecha, sobre `rgba(255,255,255,.1)` |
| Cuerpo | `background #1E293B`, `padding 1.5rem`, Fira Code `.875rem`, `line-height 1.625` |
| Plegado | **Colapsado a 150 px** con degradado de desvanecido al pie; expandible a 2000 px; por defecto `max-height 300px` con scroll |
| Resaltado | **Prism.js 1.29** con tema `prism-tomorrow` y gramáticas oficiales |
| **Salida** | **Intercalada dentro del bloque como comentarios `#>`**, justo debajo de la llamada que la produce |

La última fila es la más importante y la que más cambia respecto de lo que hay hoy.

### Lo que se adopta

1. **Salida intercalada.** Hoy la salida vive en un panel «Salida» aparte. Pasa a ir dentro del bloque, pegada a la instrucción que la produjo. Tres ventajas: se lee sin saltar la vista, admite varias salidas en un mismo bloque, y **copiar el bloque produce un guion reproducible**. Desaparece la propiedad `salidas`.

   Prefijo = marcador de comentario del lenguaje + `>`, de modo que la salida siga siendo un comentario válido:

   | Lenguaje | Prefijo |
   |---|---|
   | Pseudocódigo | `//>` |
   | Python · R | `#>` |
   | VBA | `'>` |

   **Mejora sobre la referencia:** allí la salida se colorea igual que un comentario del autor. Aquí llevará un color propio, para que el estudiante distinga *«esto lo escribió el docente»* de *«esto lo respondió la máquina»*.

2. **Prism.js 1.29** en lugar del resaltador propio por expresiones regulares (~80 líneas que se retiran). Verificado: Prism trae `r`, `python` y `visual-basic` —esta última con alias `vba`— y tokeniza VBA correctamente, incluido el comentario con comilla simple. **El pseudocódigo no tiene gramática oficial**, así que se registra una propia (`Prism.languages.pseudo`) con las palabras clave de Joyanes/Cairo.

3. **Cromo visual** del bloque: pestañas de carpeta, cabecera oscura con Copiar y Mostrar/Ocultar, cuerpo `#1E293B`.

4. **Plegado con desvanecido** para bloques largos.

### Lo que NO se adopta, y por qué

| Divergencia | Razón |
|---|---|
| **Colapsado por defecto solo en la exposición** y solo si el bloque pasa de ~12 líneas; **nunca dentro de un ejercicio** | Una traza que hay que desplegar antes de poder trazarla estorba |
| **Cromo neutro `#0F172A/#1E293B`**, con la pestaña activa en el degradado institucional | El gris azulado no compite con el color de la sintaxis; el degradado de marca en la pestaña activa mantiene la identidad USTA |

> **Ya no hay divergencia en el alcance de la pestaña.** Hasta el 2026-08-04 esta
> tabla incluía «la pestaña sigue siendo global al capítulo (D4)». Revocada tras
> la revisión del docente: ahora, como en la referencia, **cada bloque tiene la
> suya**. Lo que sí se añade sobre la referencia es la *memoria* de la última
> elección (D4-bis), que es lo que hace tolerable tener 15 bloques por capítulo.

---

## 3. Estructura de archivos

```
Logica de programacion/
├── Syllabus Logica de Programacion Financiera.xlsx
├── PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md   ← este documento
│
├── Material html/
│   ├── README.md                        Guía de autoría y convenciones      ✅
│   ├── index.html                       Portal índice con progreso global
│   ├── portal-nav.js                    Navegación flotante entre capítulos
│   ├── _plantilla/
│   │   ├── lp-base.html                 PLANTILLA GENERADA — no se edita     ✅
│   │   ├── lp-core-extra.jsx            Fuente: componentes nuevos           ✅
│   │   ├── lp-demo.jsx                  Fuente: capítulo demo + App          ✅
│   │   ├── ensamblar.py                 Genera lp-base.html                  ✅
│   │   └── verificar.py                 Verificador (5 comprobaciones)       ✅
│   ├── 01_LPF_Introduccion.html         ← migrado; falta adaptarlo (T7)      ✅
│   ├── 02_LPF_Algoritmos.html
│   ├── 03_LPF_Control_Secuencial.html
│   ├── 04_LPF_Control_Selectivo.html
│   ├── 05_LPF_Control_Repetitivo.html
│   ├── 06_LPF_Entorno_VBA.html
│   ├── 07_LPF_Arrays.html
│   └── 08_LPF_Funciones.html
│
├── Banco Moodle/
│   ├── rmd/capNN/                       Ejercicios cloze fuente (.Rmd)       ✅ cap03
│   ├── xml/                             Moodle XML generado por exams2moodle() ✅
│   ├── compilar_banco.R                 Compilación y validación             ✅
│   └── inventario_banco.csv             Inventario generado                  ✅
│
├── Guia docente/
│   └── guia_docente_y_rubricas.html     Rúbrica operacionalizada, tiempos, claves
│
└── .claude/launch.json                  Servidor local de verificación       ✅
```

*(✅ = construido en la Fase 0)*

**Migración del archivo existente:** `01_Logica_Programacion_Financiera_Intro.html` se **copió** a `Material html/01_LPF_Introduccion.html`. El original **sigue** en la carpeta de Deep Learning: copiar en lugar de mover es la opción reversible mientras no se resuelva la pregunta abierta 6.

---

## 4. Taxonomía de ejercicios — interpretación, análisis y apropiación

Este es el núcleo del encargo. Ocho tipos, cada uno con un componente asociado y un verbo cognitivo objetivo.

| Tipo | Nombre | Qué mide realmente | Componente | Nivel |
|---|---|---|---|---|
| **E1** | **Traza / prueba de escritorio** | Ejecutar el algoritmo mentalmente y sostener el estado de las variables paso a paso | `TablaTraza` *(nueva)* | Analizar |
| **E2** | **Predice la salida** | Modelo mental del flujo de control; los distractores codifican errores conceptuales típicos, no descuidos | `MCQ` *(existe)* | Analizar |
| **E3** | **Detecta y diagnostica el error** | No basta con señalar la línea: hay que **nombrar** el error y anticipar su consecuencia financiera | `DetectaError` *(nueva)* | Evaluar |
| **E4** | **Equivalencia y comparación** | Distinguir la lógica de su implementación: ¿estos dos algoritmos hacen lo mismo? ¿cuál conviene y por qué? | `Comparador` *(nueva)* | Evaluar |
| **E5** | **Ordena los pasos** | Reconstruir un algoritmo desordenado — expone la comprensión de dependencias entre instrucciones | `OrdenaPasos` *(nueva)* | Analizar |
| **E6** | **Emparejamiento entre representaciones** | Traducir entre pseudocódigo ↔ flujograma ↔ código ↔ situación financiera | `Emparejamiento` *(nueva)* | Comprender |
| **E7** | **Interpretación financiera del resultado** | El algoritmo corrió bien: ¿qué significa ese número para el negocio, el cliente o el riesgo? | `MCQ` + `Reto` *(existen)* | Evaluar |
| **E8** | **Justifica la decisión de diseño** | Criterio profesional: ¿por qué `Mientras` y no `Para`? ¿por qué `Currency` y no `Double` para dinero? | `Reto` con solución revelable | Crear |

**Excluido por diseño:** enunciados del tipo *"escriba un programa que calcule…"*. El material de estudio se dedica a leer, trazar, diagnosticar, comparar y justificar. La escritura desde cero corresponde a los talleres y entregables que el syllabus ya define.

### Cuota por capítulo

| Tipo | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 | Quiz final |
|---|---|---|---|---|---|---|---|---|---|
| Cantidad | 3–4 | 2–4 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 | 10 preguntas |

Total: **14–19 ejercicios interactivos + 1 cuestionario integrador** por capítulo. Mínimo obligatorio: al menos un E1, un E3 y un E7 en cada capítulo (son los tres que más empujan hacia interpretación y apropiación).

El máximo de **E2 subió de 3 a 4 el 2026-09-21**, al auditar el capítulo 4. El
motivo no es querer más preguntas: es que con los ocho tipos en su máximo el
capítulo quedaba **saturado**, y un hueco de cobertura —De Morgan con un solo
ejercicio, y la sección más densa del capítulo con uno solo mientras otra tenía
cuatro— no se podía tapar sin quitar algo que sí valía. El E2 es el tipo más
barato de añadir y el que mejor absorbe un concepto que se quedó sin evaluar,
así que es donde tiene sentido el margen. Si un capítulo llega a 4 E2 conviene
mirar por qué: suele significar que un concepto de exposición no tiene
ejercicio propio en su sección.

### Mapeo con la rúbrica del syllabus

| Criterio de la rúbrica | Tipos de ejercicio que lo evidencian |
|---|---|
| Procesos de modelación | E4, E6, E8 |
| Solución de problemas | E1, E2, E5 |
| Dominio de algoritmos y procedimientos | E1, E2, E3 |
| Desarrollo de proyectos y actividades | Quiz integrador + entregables del syllabus |

---

## 4 bis. Motivación de apertura

Cada sección de cada capítulo —incluidas la portada y la evaluación— **abre obligatoriamente** con el componente `Motivacion`. La regla la comprueba `verificar.py`, que identifica la sección exacta y con qué componente abre si falla.

### Qué es y qué no es

Una motivación **no resume lo que viene**: eso ya está en la barra lateral. Da una razón para seguir leyendo. La receta, en un máximo de ~80 palabras:

1. Una **escena concreta** del sector financiero: personas, cifras, un plazo.
2. La **tensión o el costo** que esa escena revela.
3. El **gancho**: la pregunta que la sección viene a responder, destacada tipográficamente.

**Antipatrón:** «En esta sección estudiaremos las estructuras de control selectivo, sus tipos y su representación en diagramas de flujo.» Es un índice, no una motivación.

**Ejemplo real** (portada de la plantilla):

> Son las 8 de la mañana y a dos analistas les entregan el mismo archivo: 40 000 desembolsos y una pregunta —cuánta cartera está vencida— para antes del mediodía. Uno abre la hoja y empieza a filtrar y contar a mano. El otro escribe veinte líneas que responden en segundos y que el próximo mes volverán a servir sin tocar nada.
>
> **La diferencia entre las dos personas no es saber más Excel: es saber descomponer el problema en pasos. Eso es lo que se aprende aquí.**

### Ganchos previstos por capítulo

Sirven de guía al redactar; se afinan al escribir cada capítulo.

| Cap. | Gancho de la motivación |
|---|---|
| 1 | Un centavo de diferencia por transacción, multiplicado por un millón de transacciones, es un descuadre contable que nadie sabe explicar. |
| 2 | Dos algoritmos correctos para el mismo problema, y uno tarda mil veces más. ¿Qué los diferencia si ambos dan el resultado bueno? |
| 3 | El programa corrió sin errores y la liquidación salió mal. ¿Cómo se encuentra un fallo que la máquina no reporta? |
| 4 | El sistema aprobó un crédito que no debía aprobar, y las condiciones estaban «bien» escritas. El problema era el orden. |
| 5 | La tabla de amortización tiene 240 filas. Nadie las escribió: se escribieron solas. ¿Cómo? |
| 6 | Un error de digitación en el nombre de una variable, sin `Option Explicit`, no produce ningún mensaje: solo produce cifras equivocadas. |
| 7 | Recorrer 40 000 celdas una por una tarda minutos; leerlas de golpe a memoria tarda menos de un segundo. Es el mismo cálculo. |
| 8 | Una función escrita una vez y usada en cuarenta hojas se corrige una vez. Cuarenta fórmulas copiadas se corrigen cuarenta veces, y siempre se olvida una. |

---

## 5. Plan capítulo por capítulo

Cada capítulo produce: **1 archivo HTML** + **6–10 ejercicios cloze** + **1 sección de guía docente**.

---

### Capítulo 1 — Introducción: sistemas de numeración, estructura del computador, operadores
**Syllabus:** fila 1 · **4 horas** · RA1 · *Estado: existe, requiere adaptación*

**Secciones internas**
1. Sistemas de numeración (decimal, binario, octal, hexadecimal) y conversión
2. Estructura del computador — arquitectura de Von Neumann
3. Operadores aritméticos, relacionales y lógicos
4. **[NUEVA]** Representación de números reales y el error de redondeo en dinero

**Por qué la sección 4 es la más importante del capítulo:** es el único punto del curso donde el sistema de numeración deja de ser trivia y se vuelve un problema financiero real. `0.1 + 0.2 ≠ 0.3` en punto flotante; un centavo de diferencia por transacción × millones de transacciones es un descuadre contable. Justifica el tipo `Currency` de VBA (cap. 6) y el redondeo bancario. Sin esta sección, el capítulo 1 es un capítulo de relleno.

**Artefactos interactivos**
- `ConversorBases` — *ya existe*
- `TablaPosicionesSVG`, `VonNeumannSVG`, `ConversionSVG` — *ya existen*
- `InteresCompuestoChart` — *ya existe*
- **[NUEVO]** `FlotanteVisualizer` — descompone un número en signo/exponente/mantisa y muestra el error absoluto acumulado al sumar 0.01 diez mil veces

**Trabajo de adaptación**
- Convertir los 3 `CodeBlock` de Python a `CodeTabs` de 4 lenguajes
- Migrar la librería de componentes a la versión canónica (`lp-base.html`)
- Rebalancear ejercicios: hoy hay 6 MCQ + 4 Quiz + 4 Reto, predominantemente de recuerdo. Añadir E1, E3, E5, E6 hasta cumplir cuota
- Añadir portada con horas y RA del syllabus

**Cloze Moodle (7):** conversión entre bases (num), valor posicional (num), identificar componente Von Neumann (schoice), precedencia de operadores (num), evaluación de expresión lógica (schoice), error de redondeo acumulado (num + schoice), máscara de bits sobre estado de transacción (mchoice).

---

### Capítulo 2 — Introducción a algoritmos
**Syllabus:** fila 2 · **4 horas** · RA1

**Secciones internas**
1. Qué es (y qué no es) un algoritmo — precisión, finitud, definición, entrada y salida
2. Del problema al algoritmo: el análisis Entrada–Proceso–Salida *(corresponde al "Formato Definición y Análisis" que el syllabus exige como entregable)*
3. Cuatro formas de representar el mismo algoritmo: lenguaje natural, pseudocódigo, diagrama de flujo, código
4. Variables, constantes, tipos de datos y **asignación ≠ igualdad matemática**
5. Nociones de eficiencia: dos algoritmos correctos no son igual de buenos

**Artefactos interactivos**
- `SimboIogiaANSI` — tabla SVG de símbolos de flujograma, clickeable, con ejemplo de uso de cada uno
- `CuatroRepresentaciones` — el mismo algoritmo (interés simple) mostrado simultáneamente en las 4 formas, con resaltado sincronizado: al pasar el cursor por una línea del pseudocódigo se ilumina el bloque correspondiente del flujograma
- `AsignacionPasoAPaso` — memoria como casilleros; muestra por qué `x ← x + 1` tiene sentido y `x = x + 1` es falso como ecuación

**Ejercicios destacados**
- **E8:** «Esta receta dice "sal al gusto". ¿Es un algoritmo? Justifique con las cinco propiedades.» — ataca directamente la propiedad de *precisión*
- **E5:** reconstruir el algoritmo de liquidación de una cuota desordenado
- **E6:** emparejar 6 símbolos ANSI con su función y con un fragmento de pseudocódigo

**Cloze Moodle (6):** propiedades de un algoritmo (mchoice), identificar entrada/proceso/salida (string ×3), símbolo ANSI correcto (schoice), resultado de una secuencia de asignaciones (num), contar operaciones de dos algoritmos (num + schoice), clasificar variable/constante (mchoice).

---

### Capítulo 3 — Control secuencial
**Syllabus:** fila 3 · **6 horas** · RA1 · **← CAPÍTULO PILOTO**

**Secciones internas**
1. La secuencia como estructura básica: el orden importa
2. Lectura, asignación y escritura
3. Expresiones aritméticas y precedencia de operadores (retoma cap. 1)
4. **La prueba de escritorio como método formal** ← núcleo del capítulo
5. Casos financieros: interés simple, descuento comercial, conversión de tasa nominal ↔ efectiva, liquidación de nómina

**Artefactos interactivos**
- `Trazador` — **el componente más importante del curso.** Motor de traza paso a paso: se avanza instrucción por instrucción y la tabla de variables se va llenando, con la línea activa resaltada. Se reutiliza en los capítulos 4, 5 y 7
- `FlujogramaSecuencial` — SVG del flujo lineal con anotación de estado
- `CalculadoraTasas` — nominal ↔ efectiva ↔ periódica, con la fórmula en MathJax actualizándose

**Ejercicios destacados**
- **E1 ×4:** trazas de complejidad creciente, la última con 5 variables y 12 instrucciones
- **E3:** el intercambio de dos variables sin variable temporal, mal hecho — `a ← b; b ← a` pierde un valor. Diagnóstico: "sobrescritura antes de lectura"
- **E7:** dado el resultado de una conversión de tasa, decidir cuál de dos créditos conviene al cliente

**Cloze Moodle (8):** completar 3 filas de una tabla de traza (num ×3), salida de una secuencia (num), efecto de intercambiar dos líneas (schoice), precedencia (num), tasa efectiva anual (num, `extol` 0.0001), interpretar cuál crédito conviene (schoice).

---

### Capítulo 4 — Control selectivo
**Syllabus:** fila 4 · **8 horas** · RA1

**Secciones internas**
1. Condiciones y expresiones lógicas; tablas de verdad; evaluación en cortocircuito
2. Selectiva simple (`Si…Entonces`)
3. Selectiva doble (`Si…Entonces…Sino`)
4. Selectivas anidadas y en cascada
5. Selectiva múltiple (`Segun` / `Select Case`)
6. Casos financieros: clasificación de riesgo crediticio, escalas tarifarias, retención en la fuente, aprobación automática de crédito

**Artefactos interactivos**
- `EvaluadorLogico` — se construye la tabla de verdad de una expresión compuesta marcando valores; muestra la evaluación en cortocircuito
- `ArbolRiesgo` — árbol de decisión de riesgo crediticio navegable: al elegir valores de ingreso, score y endeudamiento se ilumina la rama recorrida y la decisión final
- `SelectivasComparadas` — el mismo problema resuelto con `Si` anidados y con `Segun`, lado a lado

**Ejercicios destacados**
- **E3 (alto valor):** una escala tarifaria en cascada con **rangos solapados y en mal orden** — el bug clásico que hace que un cliente pague la tarifa equivocada. El estudiante debe identificarlo, nombrarlo y estimar el impacto monetario
- **E4:** ¿son equivalentes estos `Si` anidados y este `Segun`? ¿Hay algún valor de entrada donde difieran?
- **E7:** el sistema rechazó un crédito. Dada la traza, explicar al cliente **cuál** condición falló

**Cloze Moodle (9):** tabla de verdad (mchoice), salida de un `Si` anidado (num), rama ejecutada (schoice), condición faltante (string), tarifa aplicada con la cascada correcta (num), tarifa aplicada con la cascada errónea (num) + diferencia (num), `Segun` sin caso por defecto (schoice), cortocircuito (schoice).

---

### Capítulo 5 — Control repetitivo
**Syllabus:** fila 5 · **8 horas** · RA1

**Secciones internas**
1. Necesidad de la iteración; contadores y acumuladores
2. `Mientras` — evaluación previa
3. `Repita…Hasta` — evaluación posterior
4. `Para` — iteración con contador definido
5. Ciclos anidados
6. Terminación, ciclos infinitos y valores centinela
7. Casos financieros: tabla de amortización, saldo insoluto, capitalización, TIR por aproximaciones sucesivas

**Artefactos interactivos**
- `AmortizacionPasoAPaso` — construye la tabla de amortización una fila por clic, con el estado del acumulador visible. Deja ver que una tabla de amortización *es* un ciclo
- `TIRBiseccion` — búsqueda de la TIR por bisección, animada, con el criterio de parada explícito. El mejor ejemplo del curso de "iteración con condición de convergencia"
- `TresCiclosComparados` — el mismo problema con `Mientras`, `Para` y `Repita`, con el conteo de iteraciones de cada uno

**Ejercicios destacados**
- **E3 (alto valor):** error de *off-by-one* en el número de cuotas — el crédito queda con una cuota de más o de menos. Impacto monetario calculable
- **E4:** equivalencia `Para` ↔ `Mientras`: reescribir y verificar que el número de iteraciones coincide
- **E8:** ¿cuándo `Repita…Hasta` en lugar de `Mientras`? Caso: validación de entrada de un monto
- **E1:** traza de un ciclo anidado que llena una matriz de amortización de 3 créditos × 4 cuotas

**Cloze Moodle (10):** iteraciones ejecutadas (num), valor final del acumulador (num), traza de 3 iteraciones (num ×3), identificar ciclo infinito (schoice), saldo tras N cuotas (num, `extol` 0.01), total de intereses pagados (num), efecto de mover la actualización del contador (schoice), condición de parada de la bisección (schoice).

---

### Capítulo 6 — Entorno de programación VBA
**Syllabus:** fila 7 · **12 horas** · RA2 · *(reordenado — ver D6)*

**Secciones internas**
1. Por qué VBA en finanzas: Excel como plataforma de cálculo del sector
2. El editor VBE: proyecto, módulos, ventana Inmediato, Explorador de objetos
3. Del algoritmo al código: `Sub`, declaración de variables, `Option Explicit`
4. Tipos de datos de VBA y el tipo `Currency` (retoma el punto flotante del cap. 1)
5. Interacción con la hoja: `Range`, `Cells`, `ActiveSheet` — y por qué es lento
6. **Depuración: puntos de interrupción, F8 y ventana Locales** — la prueba de escritorio del cap. 3, ahora ejecutada por la máquina
7. Manejo de errores, seguridad de macros y buenas prácticas

**Artefactos interactivos**
- `SimuladorVBE` — reproducción HTML del editor de VBA con ventana de código, ventana Locales y botón F8. Permite hacer una traza real sin tener Excel abierto. **Cierra el círculo con el `Trazador` del cap. 3**
- `MapaObjetosExcel` — jerarquía `Application → Workbook → Worksheet → Range` navegable
- `RendimientoRangeVsArray` — gráfica Plotly del tiempo de ejecución celda-por-celda vs. lectura en bloque (prepara el cap. 7)

**Ejercicios destacados**
- **E3 (alto valor):** el bug silencioso de VBA — sin `Option Explicit`, un error de digitación en el nombre de una variable (`totalIntres`) crea una variable nueva en 0 y el cálculo da mal sin lanzar error
- **E8:** ¿por qué `Currency` y no `Double` para almacenar dinero? Enlaza con la sección 4 del cap. 1
- **E6:** emparejar objeto ↔ propiedad ↔ método sobre un caso de hoja de cálculo

**Cloze Moodle (8):** tipo de dato adecuado (schoice), valor en la celda tras ejecutar (string), efecto de omitir `Option Explicit` (num), rango referenciado por `Cells(3,2)` (string), diferencia `Sub` vs `Function` (schoice), resultado en ventana Locales tras 3 pasos F8 (num ×2), alcance de una variable (schoice).

> **Nota de plataforma:** VBA para Mac difiere de VBA para Windows (no hay `ActiveX`, algunos objetos cambian). El material declarará **Excel 365 para Windows** como referencia y marcará con un aviso los puntos donde Mac difiere.

> **Pendiente desde el cierre del capítulo 5 (2026-11-02): las dos rarezas de `Debug.Print`.** Van en la sección 2, con la ventana Inmediato, que es donde se ven:
> - **El espacio del signo.** `Debug.Print` escribe un número positivo con un espacio delante, el que ocuparía el signo: « 150», no «150».
> - **Las zonas de 14 columnas.** La coma entre dos valores no separa con un espacio: salta a la siguiente zona de 14 columnas. Excel escribe « 0.018         0.02».
>
> Desde el 2026-10-27, cuando el arnés de VBA corrió en Excel, las muestran salidas declaradas del material: `CICLO_INSTRUCCION` y `META_AHORRO` en el capítulo 1, y `CMP_MENSUALES` y `CMP_EFECTIVAS` en el 3. Ninguna parte del material las explica todavía, y un estudiante que compare la salida de VBA con la de Python las ve antes de llegar aquí. La regla 25 de `verificar.py` deja fuera a VBA por estas dos razones.

---

### Capítulo 7 — Arrays: unidimensionales y bidimensionales
**Syllabus:** fila 6 · **12 horas** · RA2 · *(reordenado — ver D6)*

**Secciones internas**
1. Del escalar al arreglo: por qué 200 variables sueltas no son una opción
2. Arreglos unidimensionales: declaración, índices, `Option Base`, `LBound` / `UBound`
3. Recorridos: `For` con índice vs. `For Each`; acumular sobre un arreglo
4. Arreglos bidimensionales — la hoja de cálculo *es* una matriz
5. Arreglos dinámicos: `ReDim` y `ReDim Preserve`
6. Lectura masiva de un `Range` a un array: el patrón de rendimiento clave en finanzas
7. Casos: flujo de caja como vector, matriz de covarianzas de un portafolio, tabla de amortización como matriz

**Artefactos interactivos**
- `VisualizadorArray` — celdas con índice y contenido; durante un recorrido se resalta el elemento activo y el acumulador. Reutiliza el motor del `Trazador`
- `MatrizPortafolio` — matriz de covarianzas 4×4 interactiva: al seleccionar dos activos se muestra qué significa esa celda
- `IndicesInteractivo` — muestra el mismo arreglo bajo `Option Base 0` y `Option Base 1` simultáneamente

**Ejercicios destacados**
- **E3 ×2:** (a) índice fuera de rango por confundir `Option Base`; (b) `ReDim` sin `Preserve` que borra silenciosamente los datos ya cargados
- **E7:** leer una matriz de covarianzas y decir qué par de activos diversifica mejor — interpretación pura, sin cálculo
- **E1:** traza de un recorrido con acumulador sobre un vector de flujo de caja

**Cloze Moodle (9):** valor de `UBound` (num), elemento en una posición dada (num), total de elementos de una matriz 2D (num), efecto de `ReDim` sin `Preserve` (schoice), suma acumulada tras el recorrido (num), índice de la celda `(3,2)` en la hoja (string), interpretación de una celda de la matriz de covarianzas (schoice), `For` vs `For Each` (mchoice), VPN a partir del vector de flujos (num, `extol` 0.01).

---

### Capítulo 8 — Funciones
**Syllabus:** fila 8 · **10 horas** · RA2

**Secciones internas**
1. Modularidad: por qué descomponer un problema
2. `Sub` vs. `Function`; el valor de retorno
3. **Paso de argumentos: `ByVal` vs. `ByRef`** ← concepto de mayor dificultad del capítulo
4. Argumentos opcionales y `ParamArray`
5. Ámbito de las variables; la idea de función pura
6. UDF: funciones definidas por el usuario, visibles desde la hoja de Excel
7. Casos: VPN, TIR, cuota fija (`PMT`) y tasa efectiva implementadas como UDF, contrastadas con las funciones nativas de Excel

**Artefactos interactivos**
- `ByValByRefVisualizer` — dos cajas de memoria lado a lado: se ve exactamente qué se copia y qué se comparte. Es la única forma de que el concepto quede claro
- `UDFEnAccion` — hoja de cálculo simulada donde se escribe `=MiVPN(B2:B10; 0.12)` y se ve el resultado
- `DescomposicionSVG` — el cálculo de una cuota descompuesto en 4 funciones, con las dependencias como grafo

**Ejercicios destacados**
- **E3:** una función que modifica su argumento sin querer (`ByRef` por defecto en VBA) y corrompe el dato del llamador
- **E4:** la UDF propia vs. la función nativa de Excel — ¿dan el mismo resultado? ¿en qué casos difieren y por qué?
- **E8:** ante 5 escenarios, decidir `Sub` o `Function` y justificar
- **E7:** dos proyectos con VPN positivo pero TIR distinta — ¿cuál se elige y con qué criterio?

**Cloze Moodle (8):** valor devuelto (num), valor de la variable del llamador tras `ByRef` (num), lo mismo con `ByVal` (num), `Sub` o `Function` (schoice), alcance de una variable declarada en un módulo (schoice), resultado de una UDF de VPN (num, `extol` 0.01), argumento opcional omitido (num), orden de evaluación con funciones anidadas (schoice).

---

## 6. Lista de tareas

### Fase 0 — Fundación · ✅ COMPLETADA (2026-08-04)

> Ejecutada y verificada. El detalle de lo construido y la evidencia de verificación están en §11.
> Desviaciones respecto de lo planeado: se añadió `ensamblar.py` (D11), se añadió el componente
> `Motivacion` y una quinta comprobación en `verificar.py` (D10), y el capítulo 1 se **copió** en
> lugar de moverse, a la espera de confirmación (pregunta abierta 6).

#### Tarea 1 · Estructura de carpetas y migración del capítulo 1
**Descripción:** Crear el árbol de `Material html/`, `Banco Moodle/` y `Guia docente/`. Mover el archivo existente y renombrarlo.

**Criterios de aceptación**
- [ ] El árbol de §3 existe
- [ ] `01_LPF_Introduccion.html` está en `Material html/` y abre sin errores
- [ ] El original en `Deep learning course/` está eliminado (previa confirmación del usuario)

**Verificación:** abrir el archivo en el navegador; consola sin errores; la navegación lateral y la reanudación por `localStorage` funcionan.
**Dependencias:** ninguna · **Alcance:** XS

---

#### Tarea 2 · Plantilla base y librería de componentes canónica
**Descripción:** Crear `_plantilla/lp-base.html` con el `<head>` completo (CDNs, Tailwind config, estilos), la librería de componentes existente y el armazón de la `App` (sidebar, progreso, navegación, footer). Delimitar la librería con centinelas `/* === LP-CORE INICIO === */` y `/* === LP-CORE FIN === */`.

**Criterios de aceptación**
- [ ] La plantilla renderiza un capítulo de ejemplo con 2 secciones
- [ ] Contiene los 14 componentes ya existentes: `CodeBlock`, `Box`, `CalloutPro`, `Eq`, `SectionHeader`, `Pipeline`, `Timeline`, `Tabs`, `Accordion`, `Reto`, `MCQ`, `Quiz`, `ChartFrame`, `Termino`
- [ ] Los centinelas delimitan exactamente el bloque compartido

**Verificación:** abrir en el navegador y comprobar consola limpia; cada componente se ejercita al menos una vez en el capítulo de ejemplo.
**Dependencias:** T1 · **Alcance:** M

---

#### Tarea 3 · Componentes nuevos de la taxonomía de ejercicios
**Descripción:** Implementar los componentes nuevos dentro del bloque `LP-CORE`: `CodeTabs`, `TablaTraza`, `DetectaError`, `Comparador`, `OrdenaPasos`, `Emparejamiento`, más `Motivacion` (D10) y el envoltorio `Ejercicio` que etiqueta E2/E7/E8.

**Criterios de aceptación**
- [ ] `CodeTabs` acepta las 4 claves `pseudo | python | r | vba`, resalta sintaxis por lenguaje, tiene botón de copiar y **persiste la pestaña elegida en `localStorage` para todo el documento**
- [ ] `TablaTraza` permite al estudiante escribir los valores de cada paso, comprueba celda por celda y muestra la traza correcta al revelar
- [ ] `DetectaError` exige dos respuestas: **ubicar** la línea y **clasificar** el tipo de error de una lista
- [ ] `OrdenaPasos` y `Emparejamiento` funcionan con clic (no drag-and-drop, por accesibilidad y compatibilidad táctil)
- [ ] Todos tienen foco visible, `aria-label` y navegación por teclado

**Verificación:** capítulo de ejemplo con una instancia de cada componente; probar con teclado únicamente; consola limpia; probar en viewport móvil (375 px).
**Dependencias:** T2 · **Alcance:** L → **se subdivide en T3a (`CodeTabs` + resaltado) y T3b (los 5 componentes de ejercicio)**

---

#### Tarea 4 · Verificador estructural
**Descripción:** `_plantilla/verificar.py` que, para cada archivo de capítulo, comprueba deriva y cumplimiento de cuotas.

**Criterios de aceptación**
- [ ] Compara el SHA-256 del bloque `LP-CORE` de cada capítulo contra `lp-base.html` y reporta divergencias
- [ ] Cuenta ejercicios por tipo y los contrasta con la cuota de §4
- [ ] Verifica que todo componente usado en JSX esté definido en el archivo
- [ ] Verifica que cada `CodeTabs` tenga las 4 claves de lenguaje
- [ ] Verifica que cada sección del `curriculum` abra con `<Motivacion>` (D10)
- [ ] Sale con código ≠ 0 si algo falla

**Comprobaciones añadidas después** (el verificador va por ocho; cada una tiene su prueba negativa):
- **6 · ejercicios multilingües** — un ejercicio en varios lenguajes los trae los cuatro, y `DetectaError` no usa una `lineaCorrecta` fija cuando sus líneas cambian con el lenguaje
- **7 · salida** — va dentro del bloque y con el prefijo de su lenguaje; no sobrevive ninguna propiedad `salidas={...}`
- **8 · texto por lenguaje** *(2026-08-05)* — un `DetectaError` con `lineas` multilingüe no cita «la línea N» en un `enunciado` o una `explicacion` fijos. Es la 6 aplicada a la prosa: se arregló la clave y se dejó el texto

**Verificación:** `python3 _plantilla/verificar.py Material\ html/*.html` corre limpio sobre la plantilla y falla deliberadamente al alterar un componente.
**Dependencias:** T2, T3 · **Alcance:** S

---

#### Tarea 5 · Andamiaje del banco Moodle
**Descripción:** `Banco Moodle/compilar_banco.R` que compila todos los `.Rmd` de `rmd/` a HTML (revisión visual) y a Moodle XML, con validación previa de metadatos.

**Criterios de aceptación**
- [ ] Valida, antes de compilar, que en cada `.Rmd` el número de valores de `exsolution` coincida con el de `exclozetype`
- [ ] Valida la regla de conteo del `answerlist` (Σ opciones de cada `schoice`/`mchoice` + nº de sub-ítems `num`/`string`)
- [ ] `exams2html()` y `exams2moodle()` corren sin error sobre un cloze de prueba
- [ ] Genera un reporte con el listado de ejercicios y sus tipos

**Verificación:** `Rscript Banco\ Moodle/compilar_banco.R` produce XML válido para un ejercicio piloto; el XML se importa correctamente en Moodle (verificación manual del usuario).
**Dependencias:** T1 · **Alcance:** S

---

### ✅ Punto de control A — Fundación
- [x] La plantilla y los 22 componentes renderizan sin errores de consola
- [x] `verificar.py` corre limpio (y falla en las 5 pruebas negativas)
- [x] `compilar_banco.R` genera XML válido, importable en Moodle
- [x] Las salidas de Python y R documentadas fueron **ejecutadas**, no supuestas
- [ ] **Revisión con el usuario:** validar el aspecto y comportamiento de `Motivacion`, `CodeTabs`, `TablaTraza` y `DetectaError` antes de producir 8 capítulos con ellos ← **pendiente**

---

### Fase 0-bis — Presentación de código · ✅ COMPLETADA (2026-08-04)

> Debe completarse **antes** de la Tarea 6. Toca la librería compartida: hacerlo ahora cuesta un archivo; después del capítulo 3, cuesta rehacer el piloto; después de la Fase 4, ocho capítulos.
> Especificación en §2 ter.

#### Tarea A · Prism.js y cromo del bloque
**Descripción:** Sustituir el resaltador propio por Prism 1.29 y rehacer `CodeBlock` con el cromo de la referencia.

**Criterios de aceptación**
- [ ] Cargan Prism 1.29, tema `prism-tomorrow` y los componentes `r`, `python`, `visual-basic`
- [ ] Queda registrada la gramática propia `pseudo` con las palabras clave de Joyanes/Cairo
- [ ] Los cuatro lenguajes resaltan; se retiran el resaltador por regex y las constantes `C_*`
- [ ] Cabecera con título, **Copiar** y **Mostrar/Ocultar**; plegado a 150 px con desvanecido
- [ ] **Copiar entrega el texto plano**, sin el marcado que inserta Prism

**Verificación:** abrir en el navegador y comparar con la referencia; consola limpia; copiar un bloque y pegarlo en un archivo `.py` que corra sin tocar nada.
**Dependencias:** ninguna · **Alcance:** M

#### Tarea B · Salida intercalada `#>`
**Descripción:** Retirar la propiedad `salidas` y llevar la salida al interior del bloque, con prefijo por lenguaje y color propio.

**Criterios de aceptación**
- [ ] `//>` en pseudocódigo, `#>` en Python y R, `'>` en VBA
- [ ] Las líneas de salida se distinguen visualmente de los comentarios del autor
- [ ] No queda ninguna propiedad `salidas` en la plantilla ni en los capítulos
- [ ] Copiar sigue produciendo un guion ejecutable

**Verificación:** ejecutar por script los fragmentos de Python y R y contrastar con lo escrito (regla 7 de §2 bis).
**Dependencias:** A · **Alcance:** S

#### Tarea C · Pestañas de carpeta
**Descripción:** Rehacer la navegación de `CodeTabs` con el patrón de carpeta y alinear el `SelectorLenguaje` de los ejercicios con el nuevo aspecto.

**Criterios de aceptación**
- [x] La pestaña activa se conecta visualmente con el bloque
- [x] **Cada bloque cambia por separado (D4-bis)**, también en los cinco componentes de ejercicio, y todos abren en la última preferencia guardada
- [x] Navegación por teclado y foco visible conservados

**Verificación:** cambiar de lenguaje en un bloque y comprobar que los demás **no** lo siguen; recargar y comprobar que todos abren en la última preferencia; recorrer con teclado.
*(El criterio original decía «la sincronización global (D4) sigue intacta»; se reescribió el 2026-08-05 al revocarse D4.)*
**Dependencias:** A · **Alcance:** S

#### Tarea D · Plantilla, verificador y documentación
**Descripción:** Migrar los ejemplos de la demo al formato nuevo y ajustar las comprobaciones.

**Criterios de aceptación**
- [ ] Los dos `CodeTabs` de la sección 1 y los ejercicios de la sección 2 usan salida intercalada
- [ ] `verificar.py` falla si sobrevive una propiedad `salidas`
- [ ] README y §2 ter concuerdan con lo implementado

**Verificación:** `ensamblar.py` + `verificar.py` en verde; prueba negativa de la comprobación nueva.
**Dependencias:** A, B, C · **Alcance:** S

### ✅ Punto de control A-bis — Presentación de código
- [x] El bloque se ve como el de la referencia
- [x] Los cuatro lenguajes resaltan correctamente (Prism + gramática propia de pseudocódigo)
- [x] La salida intercalada se distingue de los comentarios
- [x] Copiar entrega texto plano ejecutable
- [ ] **Revisión con el usuario** antes de la Tarea 6 ← **pendiente**

---

### Fase 1 — Piloto vertical

> ⚠️ **El orden real de ejecución no fue este, y eso cambia lo que significa
> esta fase.** Se hicieron primero el capítulo 1 (Tarea 7, 2026-08-05) y el
> capítulo 2 (Tarea 8, 2026-08-09). Cuando se escriba el capítulo 3 ya no será
> un *piloto*: el formato lleva dos capítulos validados, la librería está
> estampada y verificada, y el punto de control B —«corregir el formato aquí
> cuesta un capítulo»— ya se cobró en esos dos.
>
> Lo que **sí** sigue vigente de esta tarea: el capítulo 3 es el primero que
> necesita el `Trazador` reutilizable —que los capítulos 4, 5 y 7 heredarán— y
> es donde la prueba de escritorio pasa de ser un ejercicio a ser el método
> central del capítulo. Sigue siendo la rebanada más pesada, pero por su
> contenido, no por el riesgo de formato.
>
> El **punto de control B** se da por superado por los capítulos 1 y 2. El que
> queda abierto es el **C**, a falta solo del capítulo 3.

#### Tarea 6 · Capítulo 3 completo (Control secuencial) · ✅ COMPLETADA (2026-08-25)

> Detalle en `PLAN_TAREA6_CAPITULO_03.md`; bitácora en §11. El `Trazador` quedó en
> LP-CORE y los capítulos 4, 5 y 7 lo heredan.
**Descripción:** Construir el capítulo 3 de punta a punta: HTML con las 5 secciones, el componente `Trazador`, los 14–18 ejercicios de la taxonomía, los 8 cloze de Moodle y la sección de guía docente.

**Por qué el capítulo 3 y no el 2:** es el primer capítulo que ejercita **todo** a la vez — los 4 lenguajes, flujogramas, el motor de traza (que luego se reutiliza en 4, 5 y 7) y los 8 tipos de ejercicio. Es la rebanada más riesgosa y representativa: si el formato falla, conviene que falle aquí y no en el capítulo 8.

**Criterios de aceptación**
- [x] Las 5 secciones internas más portada y evaluación están completas
- [x] **Cada una de las 7 secciones abre con su `Motivacion`**, redactada según la receta de §4 bis
- [x] Todo bloque de código aparece en los 4 lenguajes y **cada versión produce el mismo resultado**
- [x] Cuota de ejercicios cumplida, con al menos un E1, E3 y E7 — 18 ejercicios: E1:4 E2:3 E3:2 E4:2 E5:2 E6:1 E7:2 E8:2
- [x] El `Trazador` funciona con al menos 3 algoritmos distintos — liquidación de un crédito, conciliación de una cuenta y abono extraordinario
- [x] Los 8 cloze compilan a HTML y a Moodle XML
- [x] Portada declara: 6 horas, RA1, contenido del syllabus

**Verificación**
- [x] `python3 _plantilla/verificar.py --con-salidas Material\ html/*.html` — en verde sobre los tres capítulos, cuota incluida
- [x] Abrir en navegador; consola sin errores ni advertencias de React
- [x] Ejecutar los snippets de Python y R y confirmar que coinciden con la salida documentada — 22 bloques ejecutados y comparados
- [x] `Rscript Banco\ Moodle/compilar_banco.R --cap 03` — 8 ejercicios, 24 preguntas en `cap03.xml`
- [x] Responder manualmente los 18 ejercicios y contrastar con las claves — incluido el cuestionario entero, 10/10

**Dependencias:** T2–T5 · **Alcance:** L → **se subdivide en T6a (secciones 1–3 + `Trazador`), T6b (secciones 4–5 + ejercicios), T6c (cloze + guía docente)**

---

### ✅ Punto de control B — Piloto (revisión obligatoria con el usuario)
- [ ] El capítulo 3 está completo y verificado
- [ ] **El usuario revisa y aprueba:** densidad de contenido, tono, profundidad del caso financiero, dificultad de los ejercicios, utilidad real del `Trazador`
- [ ] Los ajustes acordados se retropropagan a `lp-base.html` **antes** de producir los 7 capítulos restantes

> Este punto de control es el de mayor valor del plan: corregir el formato aquí cuesta un capítulo; corregirlo al final cuesta ocho.

---

### Fase 2 — Fundamentos (RA1)

#### Tarea 7 · Adaptar el capítulo 1
Migrar a la librería canónica, convertir Python → `CodeTabs`, añadir la sección de punto flotante y `FlotanteVisualizer`, rebalancear ejercicios, añadir 7 cloze.
**Dependencias:** T6 (formato aprobado) · **Alcance:** M

#### Tarea 8 · Capítulo 2 — Introducción a Algoritmos · ✅ COMPLETADA (2026-08-09)
Incluye `CuatroRepresentaciones` con resaltado sincronizado, que es el artefacto de mayor dificultad técnica del capítulo.
**Dependencias:** T6 · **Alcance:** M
Detalle en `PLAN_TAREA8_CAPITULO_02.md`; bitácora en §11.

### ✅ Punto de control C — Fundamentos
- [x] Capítulos 1, 2 y 3 verificados y sin deriva de componentes
- [x] La progresión conceptual entre los tres es coherente (sin saltos ni repeticiones): el
      capítulo 3 **cita** la tabla de precedencia del 1 en vez de repetirla, y retoma el
      análisis Entrada–Proceso–Salida del 2 aplicándolo a las cuatro rutinas de su sección 5
- [ ] **Revisión del docente:** leer el capítulo 3 completo y aprobar dificultad de los
      ejercicios y utilidad real del `Trazador` en contexto ← **pendiente**

---

### Fase 3 — Estructuras de control (RA1)

#### Tarea 9 · Capítulo 4 — Control selectivo · **Alcance:** M
#### Tarea 10 · Capítulo 5 — Control repetitivo · **Alcance:** M

*Paralelizables entre sí* (comparten el `Trazador` ya construido y no dependen uno del otro). **Dependencias:** T6.

### ✅ Punto de control D — RA1 completo
- [x] Capítulos 1–5 cubren las 30 horas del RA1 del syllabus *(4 + 4 + 6 + 8 + 8,
      con el capítulo 5 escrito el 2026-10-21; falta fundir su rama en `main`)*
- [ ] El hilo financiero (cartera de crédito) es continuo entre capítulos *(el 5
      lo sigue: el crédito de 10 000 000 al 1,5 % en 12 cuotas recorre sus siete
      secciones; lo decide el docente)*
- [ ] Banco Moodle del RA1: ~40 cloze compilando *(hay 34: 7, 6, 8, 5 y 8. El
      capítulo 4 se quedó en 5 de los 9 de su plan)*

---

### Fase 4 — VBA (RA2)

#### Tarea 11 · Capítulo 6 — Entorno VBA · **Alcance:** M
#### Tarea 12 · Capítulo 7 — Arrays · **Alcance:** M
#### Tarea 13 · Capítulo 8 — Funciones · **Alcance:** M

Secuenciales: 7 depende del entorno de 6, y 8 reutiliza los arrays de 7. **Dependencias:** T11 → T12 → T13.

### ✅ Punto de control E — RA2 completo
- [ ] Capítulos 6–8 cubren las 34 horas del RA2
- [ ] **Todo el código VBA fue ejecutado en Excel real y su salida verificada** (ver riesgo R2)

---

### Fase 5 — Integración

#### Tarea 14 · Portal índice y navegación
`index.html` con las 8 tarjetas de capítulo, horas, RA, estado de avance leído de `localStorage`; `portal-nav.js` con navegación flotante entre archivos.
**Dependencias:** T7–T13 · **Alcance:** S

#### Tarea 15 · Banco Moodle consolidado
Compilar los ~65 cloze a un XML por capítulo más uno global; documentar el procedimiento de importación.
**Dependencias:** T7–T13 · **Alcance:** S

#### Tarea 16 · Guía docente y rúbricas
Rúbrica del syllabus (4 criterios × 5 niveles) operacionalizada por capítulo, mapeo ejercicio → criterio, tiempos sugeridos por sesión y claves de respuesta ampliadas.
**Dependencias:** T7–T13 · **Alcance:** M

### ✅ Punto de control final
- [ ] Los 8 capítulos suman 64 horas y cubren las 8 filas del syllabus
- [ ] `verificar.py` corre limpio sobre los 8 archivos: sin deriva, cuotas cumplidas
- [ ] Los ~65 cloze compilan y se importan en Moodle
- [ ] Todo el material abre desde `file://` sin errores de consola
- [ ] Revisado en viewport móvil y con navegación por teclado
- [ ] Guía docente completa

---

## 7. Riesgos y mitigaciones

| # | Riesgo | Impacto | Mitigación |
|---|---|---|---|
| R1 | **Deriva de la librería de componentes** entre 8 archivos duplicados | Alto | Centinelas + comparación de hash en `verificar.py` (T4), ejecutada en cada punto de control |
| R2 | **El código VBA no se puede ejecutar automáticamente** desde macOS; errores silenciosos llegan al estudiante | Alto | Toda salida VBA documentada debe ejecutarse en Excel real antes de publicar (criterio del punto de control E). Alternativa si no hay Excel disponible: marcar los bloques VBA como "no verificados en ejecución" y contrastarlos contra Walkenbach/Roman |
| R3 | **4 lenguajes × ~30 bloques × 8 capítulos ≈ 960 fragmentos de código** — superficie de error grande | Alto | Python y R se ejecutan por script y su salida se compara con la documentada; pseudocódigo y VBA se revisan a mano. Regla: si un concepto no aporta en un lenguaje, ese bloque no se traduce (se documenta la omisión) |
| R4 | **Dependencia de CDN** — sin internet el material no renderiza | Medio | Documentado en el README. Si se requiere uso sin conexión, tarea adicional de *vendoring* de las 6 librerías (~2 MB) |
| R9 | **Iconos inexistentes en la versión de Font Awesome cargada** — aparecen como huecos en blanco, sin ningún error en consola | Bajo | Detectado en la Fase 0: `fa-clipboard-question` (usado por `Quiz`) llevaba invisible desde el material heredado. Se subió el CDN a 6.5.2 y `ensamblar.py` **falla** si la versión baja de 6.5 |
| R11 | **Prism no cubre el pseudocódigo** — hay que mantener una gramática propia | Bajo | Es una sola definición (`Prism.languages.pseudo`) con las palabras clave ya fijadas en D5; vive en LP-CORE y la protege la comprobación de deriva |
| R12 | **La salida intercalada puede quedar desactualizada** respecto del código, y ya no hay un panel aparte que lo delate | Medio | La regla 7 de §2 bis lo exige: Python y R se ejecutan por script antes de publicar; VBA se verifica en Excel (R2) |
| R10 | **Motivaciones que degeneran en índices** («en esta sección estudiaremos…») | Medio | Receta explícita y antipatrón documentado en §4 bis; ganchos previstos capítulo por capítulo; `verificar.py` obliga a que exista, pero **la calidad del texto solo la juzga una persona** — es punto fijo de cada revisión |
| R5 | **Peso del archivo** — Plotly + React + contenido puede superar 300 KB por capítulo | Medio | Plotly solo en los capítulos que realmente lo necesitan (1, 5, 6, 7); en el resto, SVG propio |
| R6 | **Desviación del orden del syllabus** (cap. 6 ↔ 7) | Bajo | Documentada en D6 y declarada en la portada del capítulo 6; las horas por contenido no cambian |
| R7 | **Cuatro lenguajes pueden dispersar al estudiante novato** | Medio | El pseudocódigo es la pestaña por defecto en los capítulos 1–5 y el único lenguaje que se evalúa en el RA1; los demás se presentan explícitamente como "la misma lógica, otra sintaxis" |
| R8 | **Tolerancias mal calibradas en los cloze** con respuestas monetarias | Medio | `extol` explícito en todo sub-ítem `num`; formateo idéntico en `solution` y `exsolution`; verificación por compilación repetida (T5) |

---

## 8. Supuestos declarados

> Un supuesto es algo que **yo** declaro y puedo revisar si resulta falso. Lo que decidió el docente va en la tabla de decisiones (§2), no aquí. Los cuatro lenguajes son la decisión **D0** y se detallan en §2 bis.

1. **Reordenamiento** de Entorno VBA (cap. 6) antes de Arrays (cap. 7); horas sin cambio.
2. **Pseudocódigo en español** según convención Joyanes/Cairo (ambos en la bibliografía del syllabus).
3. **Versiones de cada lenguaje:** Python 3.11+ solo con biblioteca estándar (`numpy` únicamente en el cap. 7); R base sin paquetes externos; VBA de Excel 365 para Windows como referencia, con avisos donde macOS difiere.
4. El material se abre por `file://` y **requiere conexión a internet** para los CDN.
5. Se usa la **paleta institucional USTA**, idéntica a la del material de referencia (D7-bis). El gold `#FDB913` es solo acento sobre fondos oscuros: **nunca** texto sobre fondo claro (1,66:1).
6. **Sin proyecto integrador evaluable por fases** (descartado); en su lugar, hilo financiero narrativo continuo.
7. Los ejercicios del material **no son calificables**: son de autoevaluación con retroalimentación inmediata. Lo calificable son los talleres y cuestionarios de Moodle que el syllabus ya define.
8. **Font Awesome 6.5.2 o superior** (verificado por `ensamblar.py` — ver R9).

---

## 9. Preguntas abiertas

1. **Campos de identificación del syllabus.** El formato dice `PROGRAMA ACADÉMICO: Estadística y Probabilidad` y `DENOMINACIÓN DEL ESPACIO ACADÉMICO: Probabilidad`, que no corresponden a Lógica de Programación Financiera —parecen residuo de una plantilla anterior—. El correo figura como `@usantotomas.edu.do` (`.do`, no `.co`). **¿Cuál es el programa correcto?** Lo necesito para la tabla de identificación de la portada de cada capítulo.
2. **Código del espacio académico:** la celda del syllabus está vacía. ¿Existe uno asignado?
3. ~~**Nombre del docente** para el pie de página.~~ **RESUELTA (2026-08-04):** Javier Mauricio Sierra, docente del curso y autor del formato HTML. Ya aplicado en `CONFIG.docente` y en el pie de página.
4. **¿Hay acceso a Excel para Windows** (real o virtualizado) para verificar la ejecución del código VBA de los capítulos 6–8? De la respuesta depende cómo se mitiga el riesgo R2.
5. **Versión de Moodle** de la USTA, para confirmar compatibilidad del XML generado por `exams2moodle()`.
6. **¿Se elimina el archivo original** `01_Logica_Programacion_Financiera_Intro.html` de la carpeta de Deep Learning? **Sigue ahí:** en la Fase 0 se **copió**, no se movió, por ser la opción reversible mientras esta pregunta no se resuelva.

> Ninguna bloquea la Tarea 6 (capítulo 3 piloto). Las dos primeras hacen falta antes de la **Tarea 7** (portadas definitivas); la cuarta, antes de la **Fase 4** (VBA).

---

## 10. Resumen de esfuerzo

| Fase | Tareas | Alcance agregado |
|---|---|---|
| 0 · Fundación ✅ | T1–T5 | 1 XS + 2 S + 1 M + 1 L |
| 0-bis · Presentación de código ✅ | A–D | 1 M + 3 S |
| 1 · Piloto (cap. 3) | T6 | 1 L (3 subtareas) |
| 2 · Fundamentos (caps. 1, 2) | T7–T8 | 2 M |
| 3 · Control (caps. 4, 5) | T9–T10 | 2 M · paralelizables |
| 4 · VBA (caps. 6, 7, 8) | T11–T13 | 3 M · secuenciales |
| 5 · Integración | T14–T16 | 2 S + 1 M |

**Total: 20 tareas, 6 puntos de control.** Ninguna tarea toca más de 5 archivos. Las dos tareas de alcance L (T3, T6) se subdividen antes de ejecutarse.

**Producto final:** 8 archivos HTML (~18 000 líneas), 1 portal, ~65 ejercicios cloze de Moodle, ~130 ejercicios interactivos de interpretación y análisis, 1 guía docente con rúbricas.

---

## 11. Registro de ejecución

### Fase 0 — Fundación · 2026-08-04

**Construido**

| Archivo | Qué es |
|---|---|
| `Material html/_plantilla/lp-base.html` | Plantilla canónica generada · 2 406 líneas · 141 KB |
| `Material html/_plantilla/lp-core-extra.jsx` | Fuente: componentes nuevos y resaltado de 4 lenguajes |
| `Material html/_plantilla/lp-demo.jsx` | Fuente: capítulo de demostración y armazón de la App |
| `Material html/_plantilla/ensamblar.py` | Genera la plantilla; verifica anclas de corte y versión de Font Awesome |
| `Material html/_plantilla/verificar.py` | Las 5 comprobaciones sobre cada capítulo |
| `Material html/README.md` | Guía de autoría y convenciones |
| `Material html/01_LPF_Introduccion.html` | Capítulo 1 migrado (aún sin adaptar — Tarea 7) |
| `Banco Moodle/compilar_banco.R` | Valida y compila el banco cloze a Moodle XML |
| `Banco Moodle/rmd/cap03/traza_interes_simple.Rmd` | Cloze piloto: E1 traza + E7 interpretación |
| `.claude/launch.json` | Servidor local para verificar interactividad |

**22 componentes** en `LP-CORE`: los 14 heredados, más `Motivacion`, `CodeTabs`, `TablaTraza`, `DetectaError`, `Comparador`, `OrdenaPasos`, `Emparejamiento` y `Ejercicio`.

**Evidencia de verificación**

- Consola sin errores de React ni Babel en las 5 secciones (solo el aviso esperado del CDN de Tailwind).
- `TablaTraza` calificó 15/15 con formatos deliberadamente sucios: `—`, `-`, `20.000`, `1.020.000`, `1020000,00`.
- `DetectaError` devolvió la retroalimentación parcial correcta ante línea acertada + tipo errado.
- `CodeTabs`: al cambiar un bloque, el otro siguió; preferencia persistida en `localStorage`.
- `OrdenaPasos` → «¡Secuencia correcta!»; `Emparejamiento` → «4 de 4 correctos».
- `verificar.py`: las **5 comprobaciones disparan** en prueba negativa (deriva por cambio de un carácter, componente inexistente, `CodeTabs` incompleto, sección sin motivación, cuota incumplida).
- Banco: el cloze piloto compila y genera XML bien formado, 3 variantes, con `{1:NUMERICAL:=4860000:1}` y `{1:MULTICHOICE:…~=27.0 %~…}`. Aritmética de una variante comprobada a mano.
- Salidas de Python y R **ejecutadas**, no supuestas.

**Tres defectos que la verificación cazó**

1. **Salida de R mal documentada.** `print(saldo)` imprime `6e+05`, no `600000`: R usa notación científica por defecto. Corregido con `sprintf`; el comentario quedó en el código porque es una trampa real al mostrar dinero en R.
2. **El cloze no compilaba.** `answerlist()` emite su propio encabezado `Answerlist`; al escribir además uno a mano quedaban dos entornos en la misma pregunta y `read_exercise()` fallaba. Documentado en el `.Rmd` para no repetirlo en los ~65 restantes.
3. **Iconos invisibles.** Font Awesome 6.0.0 no incluye `fa-clipboard-question`, que usa el componente `Quiz` **heredado del material existente**: llevaba invisible desde el principio, sin ningún error en consola. CDN subido a 6.5.2 y guardia añadida en `ensamblar.py` (R9).

**Pendiente del punto de control A:** la revisión humana del aspecto y comportamiento de `Motivacion`, `CodeTabs`, `TablaTraza` y `DetectaError`.

### Corrección de paleta · 2026-08-04

Detectada por el usuario: el material no usaba la paleta del archivo de referencia. Al validarlo aparecieron **dos** problemas, no uno.

| | Antes | Ahora |
|---|---|---|
| `primary` | `#0A2647` | `#3D008D` |
| `secondary` | `#F0A500` | `#ED1E79` |
| `navy` | `#0A2647` | `#001A4D` |
| `gold` | `#F0A500` | `#FDB913` |
| `teal` | `#1A5F7A` | `#0E7490` |

1. **No era la institucional.** La morada/magenta aparece idéntica en los 5 archivos del curso de Deep Learning, rotulada `/* Gradientes institucionales USTA */`. La navy/gold no correspondía a ninguna identidad; la decisión D7 que la conservaba estaba mal fundada y quedó revocada.
2. **Fallaba accesibilidad.** El gold `#F0A500` era el color de los títulos `h3`: **1,99:1** sobre `#F8FAFC`, por debajo del mínimo WCAG AA de 3,0:1 para texto grande. Con `#ED1E79` sube a 3,96:1. El material de referencia no tenía este problema porque allí el gold solo aparece dos veces, como icono y etiqueta sobre el fondo navy oscuro de la barra lateral — nunca como texto sobre fondo claro.

**Alcance:** 82 ocurrencias en 3 archivos. Para el `head` y el CSS se tomaron los valores **exactos** del archivo de referencia, selector por selector, en vez de sustituir a ojo. En los `.jsx` el mapeo fue por rol: el violeta de la etiqueta E8 pasó a ámbar `#B45309` porque junto a un `primary` morado se leía como el mismo color, y el degradado de `DetectaError` pasó a una rampa rojo→ámbar independiente de la marca.

**Verificación:** barrido de 1 851 nodos en las 5 secciones → **cero** rastros de la paleta anterior; `tailwind.config` idéntico al de referencia (`diff` vacío); sin errores de consola.

### Los ejercicios pasan a los cuatro lenguajes · 2026-08-04

Señalado por el docente. La exposición tenía sus `CodeTabs`, pero **los ejercicios de la sección 2 estaban fijados a pseudocódigo**: cero `CodeTabs` y tres `lang="pseudo"`. Un estudiante que eligiera VBA veía toda la teoría en VBA y todos los ejercicios en pseudocódigo. Rompía D0 en el punto donde más importa.

**Lo hecho:** un hook `useLenguajeActivo` y un ayudante `porLenguaje` en LP-CORE; los cinco componentes de ejercicio pasan a seguir la pestaña global y muestran su propio `SelectorLenguaje`. Toda propiedad con código admite `{pseudo, python, r, vba}`. Se escribieron las variantes de los seis ejercicios de la plantilla.

**El detalle que casi se me escapa:** `lineaCorrecta` de `DetectaError` no puede ser un número. El mismo fallo está en la línea **5** en pseudocódigo, la **4** en Python, la **4** en R y la **7** en VBA. Un número fijo habría calificado mal al cambiar de pestaña **sin producir ningún error visible**. Es ahora la regla 6 de `verificar.py`.

**Verificación:** las líneas del E3 pasan a 7/5/5/9 según el lenguaje; en VBA la línea 7 se acepta y la 5 —correcta en pseudocódigo— se rechaza con «el error está en otra línea»; los pasos del E5 y el lado izquierdo del E6 cambian de sintaxis. Tres pruebas negativas de la regla 6, las tres disparan.

**Un error propio, encontrado al probar:** la primera versión de la regla 6 no detectaba nada. El patrón `<DetectaError[\s\S]*?/>` se cortaba a los 281 caracteres, porque el `</>` de un fragmento JSX contiene `/>`. Reescrito con un recorrido que lleva la cuenta de las llaves y corta en el primer `/>` que esté fuera de toda expresión `{...}`. Las pruebas negativas existen para esto: una comprobación que nunca falla no está comprobando nada.

### Presentación de código · 2026-08-04

Adoptado el patrón del material de Diseño de Experimentos (§2 ter).

**Hecho:** Prism.js 1.29 sustituye al resaltador propio (≈80 líneas retiradas), con gramática propia para el pseudocódigo; cromo del bloque y pestañas de carpeta como la referencia; plegado con desvanecido en bloques de más de 12 líneas y nunca dentro de un ejercicio; y la salida pasa al interior del bloque con el prefijo de cada lenguaje.

**De paso:** `ensamblar.py` dejó de cortar por número de línea. Añadir librerías al `head` desplazaba todas las anclas; ahora los tramos se localizan por contenido.

**Verificación:** los cuatro lenguajes tokenizan (19–44 tokens); las líneas de salida se detectan y colorean en los cuatro; copiar devuelve texto sin etiquetas ni entidades, idéntico a lo renderizado.

**Dos errores propios que la verificación cazó:**

1. **Salida falsa en el ejercicio E4.** Al mover las salidas usé `str.replace`, que sustituye *todas* las apariciones: `CMP_PARA` y `CMP_MIENTRAS` terminan igual que `EJ_ACUMULADOR` y se llevaron un `#> 600000` cuando su resultado real es 2 400 000 —12 meses, no 3—, **contradiciendo la clave del propio ejercicio**. Lo detectó el guion que ejecuta los bloques y compara con lo declarado; ningún vistazo lo habría visto. Los bloques del comparador ya no llevan salida: mostrarla regalaría la respuesta.
2. **Patrón que solo veía la mitad.** La comprobación 7 consumía el `\n` final del bloque, que es el mismo que el bloque siguiente necesita para empezar: veía 10 de 20 bloques y nunca los de Python ni VBA. Resuelto con un *lookahead*.

**Defecto adicional que la captura reveló:** la etiqueta de tipo de ejercicio del envoltorio `Ejercicio` se superponía al enunciado cuando este ocupaba dos líneas. Se reancló sobre el borde superior de la tarjeta; comprobación geométrica de las 8 etiquetas → 0 solapamientos.

### Correcciones de la auditoría de formato · 2026-08-05

Aplicadas las cinco correcciones de `TRASPASO_AUDITORIA_FORMATO.md`, más una sexta hallada al ejecutarlas.

**A · Pestañas por bloque (revoca D4, ver D4-bis).** `CodeTabs`, `useLenguajeActivo` y `SelectorLenguaje` dejan de emitir y escuchar `lpf:cambio-lenguaje`; el evento se retira por completo. Cada instancia guarda su lenguaje en estado propio y, al montarse, arranca en el valor de `localStorage`. Cambiar un bloque ya no mueve a ninguno otro. `useLenguajeActivo` pasa a devolver el par `[lang, cambiar]`, porque el cambiador ya no puede vivir en el evento global.

**B · Barra lateral cerrada en móvil.** `useState(true)` → `useState(() => window.innerWidth >= 1024)`. Era un defecto heredado del material de Deep Learning: el `<aside>` es hermano flex del contenido, así que no lo superpone sino que lo **comprime**, y a 375 px dejaba el texto en 79 px.

**C1 · El botón del E3 dice qué falta.** `DetectaError` exige dos respuestas y mantenía el botón `disabled` sin explicar por qué: quien completaba el Paso 1 y pulsaba no obtenía ninguna reacción. Ahora rotula el progreso —«Comprobar diagnóstico (1/2)», el patrón que ya usaba `Emparejamiento`— y nombra el paso que falta.

**C2 · El texto del E3 también va por lenguaje.** El enunciado decía, fijo, «el comentario de **la línea 4**», cierto solo en pseudocódigo: en Python la 4 es `interes = capital * tasa`, justamente la respuesta. Reescrito **sin citar ningún número** («el comentario que acompaña a la asignación de `tasa`»), que es lo que no envejece al retocar el código.

**El defecto que la auditoría no había visto:** la `explicacion` tenía el mismo fallo y era peor —citaba dos números *y* escribía la corrección en sintaxis de pseudocódigo (`<-`), que no vale en Python ni en VBA—. Como debe señalar la línea exacta, no se puede redactar sin números: pasa a objeto `{pseudo, python, r, vba}`, igual que `lineaCorrecta`. `DetectaError` filtra ahora `enunciado` y `explicacion` por `porLenguaje`.

**Comprobación 8 del verificador.** Avisa cuando un `DetectaError` con `lineas` multilingüe tiene un `enunciado` o una `explicacion` que citan «línea N» sin ser multilingües. Reconoce las dos formas de escribir un mapa —constante con nombre y objeto literal en el sitio— y quita las etiquetas antes de buscar, porque el número suele venir dentro de un `<strong>`.

**Verificación (ejecutada, no de vista).** Tres pruebas negativas de la regla 8: enunciado fijo con «línea 4» → dispara; explicación fija con «línea 5» → dispara; explicación fija **sin** citar líneas → no dispara (control contra el falso positivo). En el navegador, a 8777: los dos `CodeTabs` de la sección 1 pasan de `[Pseudo, Pseudo]` a `[VBA, Pseudo]` y luego a `[VBA, R]` —dos lenguajes en pantalla a la vez—; tras recargar, los dos bloques y los cinco ejercicios abren en `R`, la última preferencia; cambiar el E3 a Python deja los otros cuatro en R. El botón recorre (0/2) → (1/2) → (2/2) y solo se habilita al final. Los cuatro lenguajes del E3 califican bien en su línea (5/4/4/7 sobre 7/5/5/9 líneas) y su explicación cita el número correcto con la sintaxis correcta. A 375 px el contenido arranca en 367 px, sin desborde horizontal; a 1280 px la barra sigue abierta (288 px). Consola limpia.

**Un tropiezo del método, no del material.** Dos mediciones dieron falsos negativos por el entorno de prueba, no por el código: el navegador sirvió una copia en caché del `lp-base.html` anterior —de ahí que las pestañas parecieran seguir sincronizadas—, y con el panel de vista previa oculto las transiciones CSS no avanzan, de modo que el `<aside>` medía 0 px aunque su estilo en línea ya dijera 18 rem. Conviene recordarlo: **al medir en el navegador, forzar la recarga sin caché y tener el panel visible.**

### Tarea 7 · Capítulo 1 adaptado, y el proceso empaquetado · 2026-08-05

Ejecutada la Tarea 7 completa. El capítulo 1 pasa las once comprobaciones con la cuota cumplida —**13 ejercicios**: E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1— y el banco Moodle suma sus siete cloze. Registro detallado en `PLAN_TAREA7_CAPITULO_01.md`.

**Tres herramientas nuevas, y una reconstruida.** `migrar.py` estampa `LP-CORE` y el `App` desde la plantilla: reconoce solo si el capítulo trae centinelas —migra si no, reestampa si sí— y es la pieza que faltaba para cerrar el ciclo que el README ya describía. `ejecutar_salidas.py` es la **comprobación 9** y reconstruye el guion que se perdió al cerrar la sesión de la auditoría: ejecuta los bloques de Python y R y contrasta su salida real con la declarada tras `#>`. Se añadieron además las comprobaciones **10** (contraste sobre el fondo de la página) y **11** (ningún enunciado pide escribir un programa desde cero). Y `Banco Moodle/verificar_cloze.R` comprueba el **contenido** de los cloze, no su estructura.

**H1 · La circularidad medida, no supuesta.** `ensamblar.py` toma el `head`, `partA` y `partB` **del propio capítulo 01**, así que ese archivo es fuente y destino a la vez. Tras estamparlo, `partA` y `partB` quedan adyacentes —las 95 líneas del `CodeBlock` viejo que las separaban desaparecen— y regenerar devuelve `lp-base.html` **sin cambiar un byte** (`6662f394cdfa2369` antes y después). Queda comprobado, no razonado.

**Cinco defectos que solo aparecieron al ejecutar.** (a) El estampado cambió el `lang` por defecto de `CodeBlock` de `python` a `pseudo`, y los tres bloques del capítulo quedaron pintando Python con la gramática de pseudocódigo: JSX válido, bloque visible, ninguna comprobación lo detecta. (b) La portada llamaba «RA1/RA2/RA3» a objetivos propios mientras `CONFIG.ra` rotulaba «RA1» con el RA del syllabus, que dice otra cosa. (c) Los puntos clave afirmaban «Python usa evaluación de cortocircuito» —cierto, y engañoso en un capítulo de cuatro lenguajes: **VBA no lo hace**, y `cuenta <> 0 And saldo / cuenta > 1` revienta ahí con división por cero—. (d) El ejemplo de punto flotante que se iba a usar en el E3 de la sección 4 **no fallaba**: `(1000000/3)*3` vuelve a dar exactamente 1 000 000 porque los redondeos se cancelan, igual que `0.1+0.2+0.3+0.4 == 1.0` da `True`. Se probaron seis candidatos y se eligieron los que fallan de verdad. (e) En el cloze `precedencia_operadores`, media tanda de variantes salía con `e1 = e2 = 2`, y ahí `b^(2^2)` y `(b^2)^2` **valen lo mismo**: el ejercicio que existe para mostrar la asociatividad por la derecha no la mostraba, y compilaba y validaba igual.

**Sección 4, la que el plan pedía.** «Representación de reales y error de redondeo», con `FlotanteVisualizer` —local del capítulo, no de `LP-CORE`— que descompone un número en sus 64 bits y muestra la deriva al acumular. El contraste entre `0,25`/`0,5` (exactos) y `0,1`/`0,07` (no) deja que el estudiante descubra que el problema no es «los decimales» sino **cuáles**. En VBA el bloque muestra que con `Currency` el problema desaparece: eso justifica la decisión que tomará el capítulo 6.

**Verificación.** Todo ejercicio que califica se condujo por DOM hasta el veredicto, en los cuatro lenguajes y con una respuesta incorrecta de control: los dos `DetectaError` aciertan en sus líneas (4·5·5·8 y 8·6·7·9) y cada explicación cita el número que le toca; el `Emparejamiento` da 6 de 6 con la permutación declarada; las dos `TablaTraza`, 6/6 y 3/3. Las trazas se compararon además contra el ciclo **ejecutado**, y se confirmó que los tres saldos del interés compuesto son exactos en IEEE 754 —conviene medirlo, no suponerlo, porque `1.02` no es exacto en binario—. Las tres comprobaciones nuevas tienen prueba negativa; los cloze pasan 1000 sorteos. A 375 px, las seis secciones dan 367 px sin desborde. Consola limpia.

**Lo único que descansa en criterio y no en medición** es el bloque de VBA que afirma que `Currency` resuelve el problema: VBA no se ejecuta aquí. Conviene comprobarlo en Excel real antes de publicar.

**Skill `lpf-capitulo`.** Escrita **al final** a propósito, para codificar el ciclo ya recorrido y no lo que se suponía antes de empezar. Remite al README y a este plan para las normas en lugar de copiarlas —duplicarlas crearía deriva y no habría forma de saber cuál manda—; lo que sí lleva es el procedimiento, las nueve trampas conocidas y las puertas que deben pasar.

**Lo que sigue:** Tarea 6 (capítulo 3 piloto) y el resto de la Fase 2. El capítulo 1 se adelantó a la T6; si el piloto mueve el formato, `migrar.py` reestampa en un comando.

### El material entra en control de versiones y se publica · 2026-08-06

El proyecto pasa a git y a GitHub Pages:
<https://jotamao1985.github.io/Usta_Logica-de-programaci-n-Financiera/>

**Qué NO se subió, y por qué.** El repositorio es **público**, así que quedan
fuera dos cosas: el **banco de Moodle** —los `.Rmd` llevan la clave y los `.xml`
son bancos listos para importar; el material HTML revela sus soluciones a
propósito, pero un instrumento de evaluación no— y el **syllabus institucional**
en `.xlsx`, que es un formato interno de la USTA. La trazabilidad no se pierde:
el `CONFIG` de cada capítulo cita textualmente el RA, los contenidos y las horas.
También se excluyeron el `.bak` de `migrar.py`, los `.DS_Store`, el `__pycache__`
y `Banco~+~Moodle/` —un directorio vacío que creó el propio bug de las rutas con
espacios de Rscript—.

`.claude/launch.json` se sustituyó por un `launch.json.example`: el archivo real
lleva una ruta absoluta a otro curso del docente y es específico de su equipo.

**Tarea 14, parcialmente.** El `index.html` de la raíz existe ya y es lo que
sirve Pages: las ocho tarjetas de capítulo con sus horas, las publicadas
enlazadas y las pendientes en gris. **Falta** lo que la Tarea 14 pedía además:
el progreso global leído de `localStorage` y el `portal-nav.js` de navegación
flotante entre archivos. Queda abierta.

Vive en la **raíz** y no en `Material html/` a propósito: esa carpeta lleva un
espacio en el nombre y una URL con `%20` es mala para dar a estudiantes. Desde la
raíz, el enlace que se reparte es limpio y el espacio queda escondido detrás.

---

### Tarea 8 · Capítulo 2 escrito desde cero · 2026-08-09

Primer capítulo construido **íntegramente con la skill `lpf-capitulo`** —el 1 se
adaptó de material previo—, y por tanto su primera prueba real. El detalle está
en `PLAN_TAREA8_CAPITULO_02.md`; aquí queda lo que cambia para el resto del
proyecto.

**Lo entregado.** `02_LPF_Algoritmos.html`, 3 899 líneas: siete secciones, tres
artefactos propios del capítulo (`SimbologiaANSI`, `CuatroRepresentaciones`,
`AsignacionPasoAPaso`), 13 ejercicios con la cuota exacta del §4
(E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1) y un cuestionario de 10 preguntas.
Más los 6 cloze del banco, que no se versionan.

**Un defecto de la librería que nadie había visto: la pregunta inacertable.**
`Quiz` y `MCQ` deciden con `toggle(qi, oi, q.multiple)` si la selección es única
o múltiple. Una pregunta con dos `correcta: true` y **sin `multiple: true`** no
se puede acertar: la segunda elección reemplaza a la primera mientras la
calificación sigue exigiendo el conjunto completo. Se pinta bien y el veredicto
dice «incorrecto» sin explicar nada.

Apareció al **responder** el cuestionario con las diez respuestas buenas y sacar
9. Es la tercera vez en este proyecto que un defecto solo aparece al conducir el
material hasta el veredicto, y no al leerlo: se suma al `#> 600000` que
contradecía su propia clave y al ejemplo de punto flotante que no fallaba.

De ahí sale la **comprobación 12 de `verificar.py`**, con prueba negativa. Y de
ella, un aviso sobre cómo se escriben las comprobaciones: la primera versión de
la regla no encontraba nada, porque el comentario que explica la bandera
contiene literalmente `multiple: true` y eso bastaba para darla por satisfecha.
Lo cazó su propia prueba negativa. Toda regla que busque una cadena en el JSX
debe retirar antes los comentarios —sustituyéndolos por espacios, para no
falsear el número de línea—.

**Sobre la skill, siete hallazgos.** Los cuatro primeros son huecos del
procedimiento: le falta el paso 0 (crear el archivo copiando `lp-base.html`,
porque `migrar.py` no genera, estampa); no advierte de que esa copia trae el
capítulo de demostración entero, con un ejercicio de cada tipo, de modo que
`verificar.py` puede dar **verde con contenido ajeno**; el `grep TODO` de su
paso 3 no sirve en ese camino, porque `migrar.py` respeta el `CONFIG` que ya
existe; y su trampa 6 dice que hay siete iconos cuando hay diecisiete. Los otros
tres son de fondo: la pregunta inacertable, la puerta de los «~367 px» que no
corresponde a ninguna medida real del capítulo 1 —lo que se sostiene es «sin
desborde horizontal», y así se comprueba—, y que en este panel no se pueden
medir eventos de foco, porque `document.hasFocus()` es falso y Chrome no los
despacha para ningún elemento.

**Decisión de contenido que se aparta del plan.** El §5 pedía `string ×3` para
`entrada_proceso_salida`; se escribió en `schoice ×3`. En Moodle un `string` se
califica por coincidencia exacta y «entrada», «Entrada» y «dato de entrada» son
la misma respuesta para un humano y tres distintas para el motor: la dificultad
estaría en teclear, no en clasificar. Aprobado por el docente.

**Tarea 14, un paso más.** El `index.html` ya enlaza el capítulo 2. Siguen
faltando el progreso global desde `localStorage` y el `portal-nav.js`.

### Tarea 6 · Capítulo 3, y un defecto que estaba en los tres · 2026-08-25

Cierra la Fase 1 y con ella el punto de control C. El detalle está en
`PLAN_TAREA6_CAPITULO_03.md`; aquí queda lo que cambia para el resto del
proyecto.

**Lo entregado.** `03_LPF_Control_Secuencial.html`, 4 746 líneas: siete
secciones, el `Trazador` —que se fue a LP-CORE porque lo heredan los capítulos 4,
5 y 7—, dos artefactos propios (`FlujogramaSecuencial` y `CalculadoraTasas`), 18
ejercicios con la cuota exacta del §4 (E1:4 E2:3 E3:2 E4:2 E5:2 E6:1 E7:2 E8:2) y
un cuestionario de 10. Más los 8 cloze del banco, que no se versionan.

**El defecto de fondo: la clave estaba siempre en la misma letra.** Las diez
respuestas correctas del cuestionario del capítulo 3 quedaron en la «a». Al medir
los otros dos resultó que no era un descuido de un día sino el patrón de todo el
material: el capítulo 1 tenía sus veintisiete preguntas —cuatro `Quiz`, ocho
`MCQ` y un `Comparador`— con la clave en la «a», y el 2, nueve de diez en la «b».
Se acertaban enteros sin leer un enunciado.

Lo importante para el proyecto no es el defecto sino **cómo escapó**. La regla
más fuerte que teníamos —«responda el cuestionario entero y acierte las diez»— se
cumplía: yo lo respondí, dio 10/10, y estaba roto. Es la primera vez que aparece
un defecto que **sobrevive a conducir el material hasta el veredicto**, porque no
está en ninguna respuesta sino en la distribución de todas. Solo se ve contando.

De ahí la **comprobación 14 de `verificar.py`**, con su prueba negativa —que no
hubo que fabricar: la traían los capítulos 1 y 2— y con el umbral afinado por
ellos: la primera versión exigía unanimidad y el capítulo 2 pasaba en verde,
porque su décima pregunta es de selección múltiple y su primera correcta cae en
otro sitio. Nueve de diez ya es un patrón.

Y una regla de redacción que sale de la corrección: **una justificación nombra el
contenido de la opción, nunca su letra**. Cuatro justificaciones citaban la
posición del distractor y rotar las opciones las habría vuelto mentira.

**La potencia no se asocia igual en los cuatro lenguajes.** La sección 3 daba la
potencia como asociativa por la derecha y añadía que el orden de evaluación es el
mismo en los cuatro. Es falso en VBA: `2 ^ 3 ^ 2` vale 512 en pseudocódigo,
Python y R —los dos últimos ejecutados— y 64 en VBA. Es la única discrepancia de
evaluación entre los cuatro lenguajes de todo el curso, y toca el riesgo R2: el
valor de VBA queda pendiente de confirmar en Excel real.

**Un ejercicio del banco puede no tener quien lo compruebe.** `verificar_cloze.R`
solo miraba los `.Rmd` escritos en `REGLAS`, así que uno añadido y no apuntado
quedaba con la estructura validada y el contenido sin comprobar, en verde. Le
pasó al piloto `traza_interes_simple` desde la Fase 0. Ahora el guion compara los
dos conjuntos y falla si sobra un archivo.

**Sobre la skill, tres hallazgos.** El primero es el de arriba: su lista de
«verificar de verdad» recoge cuatro defectos invisibles en pantalla, y todos se
cazan **respondiendo**; falta el quinto, que solo se caza **contando**, y que la
propia ritual de respuesta declara sano. El segundo es la regla de las
justificaciones posicionales, que no está en ninguna parte. El tercero es menor:
la trampa 2 dice que no se edite `lp-base.html` a mano, pero no advierte de que
`verificar.py` **aborta antes de mirar un solo capítulo** si la plantilla no
coincide con sus fuentes; durante una semana el verificador no verificó nada y el
único síntoma fue una línea que parecía hablar solo de la plantilla.

**Decisiones de contenido que se apartan del plan.** La sección 5 no vuelve a
exponer el interés simple —lo cita como el algoritmo ya trazado en la sección
4—, porque repetirlo a dos secciones de distancia es lo que el punto de control C
prohíbe entre capítulos. Aprobado por el docente.

**Tarea 14, un paso más.** El `index.html` ya enlaza el capítulo 3 y la Unidad 2
deja de estar entera en gris. Siguen faltando el progreso global desde
`localStorage` y el `portal-nav.js`.

### Auditoría del capítulo 4, y seis reglas que faltaban · 2026-09-21

El capítulo 4 se auditó entero —redacción, coherencia, código en los cuatro
lenguajes, artefactos y banco de preguntas— con `verificar.py` en verde de
principio a fin. Esa es la primera conclusión: **el verificador daba OK a un
capítulo con dos claves falsas, un cuestionario que se aprobaba sin leerlo y un
hueco de cobertura entero**. Lo que sigue es lo que se arregló y lo que se
aprendió, que no es lo mismo.

**Lo que el capítulo tenía mal, por familias.**

1. *Dos claves afirmaban un número que el código no da.* La escala por tramos
   sin caso por defecto: el ejercicio y la pregunta 10 decían que con una
   devolución de −50 000 «la cascada asigna 25 000». Asigna **2 500**, porque
   `monto <= 100000` también es cierto para un negativo y decide la primera
   rama. El artefacto interactivo del propio capítulo lo mostraba bien, y la
   justificación remitía a él: el estudiante que obedeciera vería que la
   respuesta marcada como correcta era falsa. **Un tope sin piso es un segundo
   defecto, distinto del que la sección enseña**, y ahora se enseñan los dos.
2. *Los cuatro lenguajes no eran equivalentes.* Pseudocódigo y VBA acotaban los
   tramos por abajo (`Caso 1..100000`, `Case 1 To 100000`) y Python y R no. Con
   un negativo, Python daba 6 000, R 2 500 y los otros dos nada. Se pusieron las
   cotas: comprobado sobre catorce valores frontera, decimales incluidos.
3. *El cuestionario era un instrumento inválido.* 14 de 18 claves en la «b»,
   cinco seguidas; marcando siempre la «b» se sacaba 8 sobre 10 y el componente
   felicitaba por «excelente dominio del tema». Además tres preguntas repetían
   ejercicios ya respondidos, la sección 6 no tenía ninguna y el conjunto vivía
   dos niveles de Bloom por debajo de los ejercicios que decía cerrar.
4. *Faltaba lo que el syllabus nombra.* «CONTROL SELECTIVO: algoritmos,
   **flujograma**, pseudocódigo y codificación» se imprime en la portada del
   capítulo, y el capítulo no tenía un solo `<svg>`. Tampoco usaba el
   `Trazador`, que este plan da por reutilizado aquí (§7).

**Las seis comprobaciones nuevas.** Cada una nació de un defecto real de este
capítulo, y cada una tiene su prueba negativa registrada:

| # | Qué mira | Prueba negativa |
|---|---|---|
| 15 | El bloque JSX compila (Babel, en `comprobar_jsx.js`) | Las dos roturas reales de la auditoría: una comilla invertida en un `template literal` y un comentario JSX como hermano de un elemento |
| 16 | Las claves del capítulo entero no se concentran ni forman rachas | El propio capítulo 4 antes de la auditoría: 14 de 18 en la «b» |
| 17 | La clave no se delata por medir el doble | Salta hoy en los capítulos 1, 2 y 3, con cinco ítems reales |
| 18 | El cuestionario no repite una opción ya vista | La pregunta 6 del capítulo 4, copia literal de un `tipoCorrecto` |
| 19 | El cuestionario cubre todas las secciones | Cambiar una `seccion` y dejar la 6 sin preguntas |
| 12 (ampliada) | También los `<MCQ>` y `<Comparador>` sueltos | Quitarle la bandera a un `<MCQ>` de dos respuestas correctas |

**Lo que hay que aprender de aquí, que es lo que no se ve en la tabla.**

- **La regla 12 llevaba meses sin mirar la mayoría de los ejercicios.** Buscaba
  `pregunta:` con dos puntos, que es la sintaxis del objeto de `Quiz`; los
  `<MCQ>` y `<Comparador>` sueltos la escriben como prop JSX, `pregunta=`. Una
  regla que solo cubre una de las dos formas de escribir lo mismo es una regla
  que no existe para la otra. **Al escribir una comprobación, enumerar las
  formas sintácticas antes que los casos.**
- **La regla 14 existía y no bastaba.** Exigía casi unanimidad, y 8 de 10 no lo
  es. Un umbral puesto para que los capítulos de entonces pasaran es un umbral
  calibrado contra el defecto, no contra la norma. La 16 se calibró al revés:
  contra lo que los cuatro capítulos sanos reparten de verdad —como mucho un
  38 % en una posición, y nunca más de dos seguidas—.
- **Dos veces en una auditoría se rompió el archivo y las catorce reglas dieron
  verde.** Las reglas de texto no ven sintaxis. Cualquier comprobación sobre un
  archivo que se ejecuta tiene que empezar por ejecutarlo, o al menos
  compilarlo; lo demás es opinar sobre un archivo que quizá ni arranca.
- **El máximo de E2 subió de 3 a 4** (§4). No por querer más preguntas: con los
  ocho tipos en su máximo el capítulo estaba saturado y un hueco de cobertura no
  se podía tapar sin quitar algo que valía. Si un capítulo llega a 4 E2, mirar
  por qué: suele significar que un concepto de la exposición se quedó sin
  ejercicio en su sección.
- **Una justificación no debe citar la posición de una opción.** «La primera
  opción…», «la última opción…»: barajar las claves convierte esas frases en
  mentiras, y barajarlas es exactamente lo que hubo que hacer. Ahora todas citan
  el contenido. Conviene que la skill lo recoja.

**Lo que queda pendiente.** La comprobación 10 de contraste sigue con
`MINIMO_WCAG = 3.0` —el mínimo de *texto grande*—, no mira el CSS del `<style>`
y no compone fondos con alfa, así que no ve los 26 `<h3>` del capítulo a 3,96:1
ni los tintes `/10` de los artefactos. Medirlo bien pide un navegador; sería una
regla 20 opcional, como la 9.

### Segunda lectura del capítulo 4, con el verificador ya arreglado · 2026-09-21

El capítulo se volvió a auditar entero **después** de la auditoría anterior y de
las seis reglas nuevas. Salieron treinta y siete correcciones más. Esa es la
primera lección, y no es cómoda: **una revisión no encuentra lo que no fue a
buscar**. La primera pasada arregló el barajado de las claves y añadió reglas
para vigilarlo; esta encontró que el instrumento entero se podía aprobar sin
leer el capítulo, por dos vías que ninguna regla mira.

**Las dos que más valían.**

1. *Una tabla de traza enviada en blanco aprobaba.* `normalizarCelda` manda la
   cadena vacía y «—» al mismo token, así que no responder vale como responder
   siempre que la respuesta correcta sea «—» —y eso es lo normal, no la
   excepción: las variables nacen sin valor—. Medido: 61 %, 70 %, 58 % y 67 %
   en las cuatro tablas del capítulo. La de la sección 3 devolvía «70 %» y
   color ámbar a quien no había escrito nada. Se arregló en LP-CORE con una
   bandera opcional, `exigeRespuesta`, porque solo 4 de las 14 tablas del
   material piden explícitamente escribir la raya y las cuatro son de este
   capítulo (en los capítulos 1 a 3 son 0 de 3, 2 de 3 y 1 de 4).

2. *El cuestionario compartía pantalla con sus respuestas.* La sección de
   evaluación es una página con scroll: el `Emparejamiento` arriba y el glosario
   abajo. La columna «Idea» escribía con casi las mismas palabras las claves de
   cuatro preguntas. Mover el glosario habría roto el formato de los cuatro
   capítulos —todos tienen la misma estructura—, así que lo que se quitó fue la
   coincidencia literal, no el mueble.

**Lo que un arreglo rompe.** Tres de las falsedades de esta pasada las dejó la
pasada anterior, y las tres son de la misma clase: *el arreglo de A invalidó un
texto que hablaba de A*. Permutar las opciones de una pregunta dejó su
justificación señalando «las dos primeras» cuando las claves pasaron a ser la
primera y la tercera. Añadir una nota a un `Trazador` metió un número —«de
quince escritas»— que solo es cierto en pseudocódigo (12 en Python, 13 en R, 17
en VBA). Y corregir las cotas de los cuatro bloques de código dejó intacta la
tabla que, dos pantallas más abajo, seguía mostrando la forma incorrecta. Antes
de dar por cerrado un arreglo conviene buscar quién más hablaba de lo que se
cambió.

**Lo que solo se ve midiendo.**

- **El contraste, componiendo alfa y leyendo el `<style>`.** Las condiciones que
  la cascada no llega a evaluar se pintaban a 2,54:1 —y son justamente el «no se
  evaluó» que el capítulo enseña—. Lo grave está en LP-CORE y sigue abierto: las
  fichas sin emparejar a **1,48:1** (blanco sobre `#CBD5E1`) y **los números de
  línea del código a 2,35:1**, que duelen porque hay dos ejercicios que piden
  señalar una línea.
- **El tamaño de la letra dentro de un SVG no es un problema de `font-size`, es
  de ancho de `viewBox`.** En una columna de 319 px la escala es 319 dividido
  por el ancho del `viewBox`; con 486 unidades, un `font-size` de 12,5 se
  renderiza a 8,2 px CSS, la mitad del cuerpo del texto. No se arregla bajando
  el `viewBox` si el contenido necesita ese ancho, y el desplazamiento lateral
  lo descarta el propio capítulo. Se resolvió con **dos versiones del mismo
  diagrama**, alternadas con `hidden sm:block` / `sm:hidden`: la estrecha pone
  el resultado debajo de su rombo en vez de al costado y lleva las ramas por dos
  carriles laterales, con lo que cabe en 248 unidades y la letra sube a
  14-17 px. Y una leyenda de simbología no necesitaba dos versiones: necesitaba
  dejar de ser SVG. Un `<text>` no fluye; la forma va en SVG y el texto en HTML,
  que se queda a 14,4 px a cualquier ancho.
- **JSX descarta el espacio en blanco cuando el salto de línea separa texto de
  un elemento**, aunque lo conserve entre dos textos. Dos correcciones salieron
  pegadas en pantalla —«ya no puede ser*ninguna*»— y no lo vio ni Babel ni
  `verificar.py`: solo el DOM.

**Huecos del verificador, para cuando toque la regla 20 y siguientes.** Ninguna
comprobación mira: un numeral en prosa fija junto a un bloque multilingüe fuera
de `DetectaError` (la regla 8 solo cubre ese componente); una justificación que
cita posiciones de opción; el solapamiento entre el glosario o un
`Emparejamiento` y el cuestionario de la misma sección; una `TablaTraza` donde
«—» sea mayoría de las celdas ocultas; el `font-size` de un SVG contra el ancho
de su `viewBox`; el contraste de un `fill` dentro de un `<text>`; y una
afirmación de un capítulo que otro capítulo contradice —«es el primero donde los
cuatro no se comportan igual» lo desmiente el capítulo 1, y «la única
discrepancia» del capítulo 3 lo desmiente el 4—.

Cinco commits, uno por frente: falsedades, instrumento, la bandera de LP-CORE,
flujogramas y fronteras. Los cuatro capítulos pasan `verificar.py --con-salidas`.


### Un mismo capítulo con cuatro nombres · 2026-09-22

Al enlazar el capítulo 4 en el índice se vio que el portal lo llamaba de una
forma y el capítulo de otra. Mirando los cuatro juntos, el desacuerdo era mayor
de lo que parecía: el nombre de un capítulo se escribe **en cinco sitios
distintos** —`<title>`, `<meta description>`, `CONFIG.titulo`, el título del
`Quiz` final y la tarjeta de `index.html`— y ninguno de los cinco se comparaba
con los demás. Salieron tres formatos de `<title>` para cuatro capítulos; una
mayúscula de más en «Introducción a Algoritmos», el único de los ocho nombres
del índice que no iba en minúscula de oración; y un cuestionario que se
anunciaba como «Evaluación final · Unidad 1» siendo el del capítulo 1, cuando
el capítulo 2 es de esa misma unidad y trae su propia evaluación.

Ninguno rompe nada, y por eso duraron un año: son **defectos que solo se ven
poniendo los cuatro capítulos en la misma pantalla**, y nada del flujo de
trabajo obliga a hacerlo. La convención quedó escrita en
`Material html/README.md`, con la tabla de los cinco sitios. `verificar.py`
tampoco lo comprueba, y no puede: audita capítulo a capítulo y no lee
`index.html`. Queda anotado como candidato a regla —haría falta una
comprobación de repositorio, no de capítulo—.

**Y un hueco de herramienta.** `ensamblar.py` sustituye el título y la
descripción del capítulo 1 por los de la plantilla. El título lo anclaba en la
etiqueta `<title>`; la descripción, en las primeras palabras del texto del
capítulo 1 —`content="Material de aprendizaje`—. Al reescribir esa frase, el
`if` dejó de entrar y la plantilla se llevó la descripción del capítulo 1, **sin
una línea de aviso**: el patrón «busca una cadena, y si no está no hagas nada»
convierte un cambio de contenido en un fallo silencioso. Ahora se ancla en
`<meta name="description"` y aborta si no la encuentra, como ya hacía el título.
Probado en negativo: quitando la etiqueta, sale por 1.


### Las preguntas del capítulo 4, y un arreglo que empeoró lo que arreglaba · 2026-09-28

Auditadas las 17 preguntas con opciones del capítulo —7 en las secciones, 10 en
el cuestionario—. La mayoría son buenas: el barajado no tiene sesgo (A:4 B:4
C:3 D:4), todo lo que se pregunta está enseñado, y varias están bien
construidas de verdad —dos opciones que dan la misma cifra por causas
distintas, un umbral de 30 días contra una condición de `> 30`—.

Dos de las diez del cuestionario, en cambio, se contestaban sin leer el
capítulo. Y la lección no está en que existieran, sino en **cómo llegaron a
existir**.

**La 6 se contestaba con su propio enunciado.** Tres de los cuatro distractores
afirmaban que había una regla defectuosa; el enunciado acababa de decir que
todas eran correctas. Quedaba una sola opción compatible, y además repetía el
enunciado palabra por palabra.

Esa redacción la introdujo `4637904`, el commit titulado *«un cuestionario que
se aprobaba sin leerlo»*. Antes, las cuatro opciones medían 18 · 22 · **76** ·
18 y la clave se delataba por larga. El arreglo alargó los distractores —bien—
y reescribió la clave con las palabras del enunciado —mal—. **Cambió un delator
que el verificador medía por uno que no medía nadie.** Y dejó intacto el
problema de fondo: las cuatro categorías eran las del `DetectaError` de la
sección 4, que el estudiante acaba de responder.

De ahí la regla que faltaba, y es general: **una pregunta repetida no se
arregla reescribiéndola**. Reescribirla solo despista a la comprobación. Si
está repetida se cambia la pregunta.

**La 2 era el ejercicio de la sección 1 sin el prefijo.** Misma política,
mismos números, tres de sus cuatro opciones sin el `rechazado <- ` de delante.
La regla 18 existía justamente para esto y no lo veía: comparaba cadenas
enteras.

Las dos reglas quedaron reforzadas, cada una con su prueba negativa contra la
versión anterior del capítulo:

- **17 · clave más larga.** Tenía una sola vara —el doble que el distractor más
  largo—, que solo ve el caso extremo. Se le añadió una segunda: siendo la más
  larga de todas, vez y media la media de los suyos. Al encenderla aparecieron
  **17 ítems en los cuatro capítulos**, ocho de ellos en el 3 y siete en el 2.
  Ninguno se había mirado nunca con este criterio.
- **18 · pregunta repetida.** Ahora compara también por inclusión —el prefijo
  ya no la vence— y, sobre todo, **a nivel de ítem**: si dos o más opciones de
  una pregunta del cuestionario dicen lo que decía un ejercicio anterior, se
  avisa aunque ninguna coincida al pie de la letra. Con una sola no se avisa:
  dos preguntas sobre el mismo concepto comparten vocabulario sin ser la misma.
  De paso, `_normaliza` dejó de borrar los operadores: `score < 680` y
  `score <= 680` le resultaban idénticos, que es ser ciego justo a la
  distinción de frontera que el capítulo 4 enseña.

Encendidas, las dos reglas encontraron en el **capítulo 3** una duplicación que
nadie había visto: la pregunta del cuestionario sobre la factura de 8 000 000
es la del ejercicio E2 de la sección, con los mismos números y tres de sus
cuatro opciones reescritas. Queda anotada; el capítulo 3 no se tocó.

**Post scriptum del 2026-09-28.** Arreglada también la duplicación del capítulo
3 que las reglas nuevas encontraron. La pregunta 2 del cuestionario era el
ejercicio E2 de la sección 1 —misma factura, mismos números, tres de sus cuatro
opciones reescritas—. En su lugar va lo único de esa sección que ninguna
pregunta tocaba: que el programa mal ordenado **no está roto**, sino que
contesta otra pregunta y presenta la respuesta como si fuera la que se hizo.
Ahora se da el resultado equivocado y se pregunta qué es exactamente esa cifra.

Y el distractor reciclado de la pregunta 9 —el 1,5 % del contrato, que ya se
descartaba en el E7 de la sección 5— pasa a ser el error de base: medir los
450 000 sobre los 15 000 000 de la factura en vez de sobre los 14 550 000 que
el proveedor recibió. Al darle cuerpo, esa pregunta dejó además de disparar la
regla 17 —la clave medía 103 contra 61 de media—, que es el arreglo que la
propia regla recomienda: alargar los distractores, no acortar la clave.

Queda anotado un hueco más: **el cuestionario del capítulo 3 no declara
`seccion:` en ninguna pregunta**, así que la regla 19 —cobertura de las
secciones— se salta en silencio. La regla está escrita para no adivinar, y hace
bien; pero entonces un capítulo que no declara nada pasa sin que nadie note que
no se comprobó.


Cerrado ese hueco: las diez preguntas del 3 declaran su sección, dos por cada
una. No hubo que decidir nada —cada pregunta se enseña en un solo sitio, y la
portada de la evaluación ya prometía por escrito «dos preguntas de cada una»—;
la etiqueta convierte esa promesa en algo que la regla 19 puede romper. Se
comprobó que la rompe: con las dos de `cap5` movidas a `cap4` avisa que falta
`cap5`, y con una etiqueta de menos avisa que declaran unas sí y otras no.

Y al contar apareció que el hueco era mayor de lo anotado: **los capítulos 1 y
2 tampoco declaran ninguna**. Hasta hoy la regla 19 solo trabajaba en el 4.
Queda pendiente.

### La regla 19 miraba el cuestionario equivocado · 2026-09-28

Al declarar las secciones del 1 y del 2, la regla 19 falló en los dos, y en
ninguno de los dos por culpa del capítulo:

- En el **1** tomó por cuestionario final el minicuestionario de la sección 1.
  Buscaba el *primer* `<Quiz>`, que da igual mientras haya uno solo, y el 1
  tiene cuatro. Contaba como del final las preguntas de todos, y como solo el
  final las declaraba, avisaba que «unas sí y otras no».
- En el **2** sacaba la lista de secciones de cualquier `id:` del capítulo, y
  exigía preguntas de «terminal», «entrada» o «decision»: los símbolos del
  diagrama de flujo. En el 3 y el 4 no había otro `id:` y funcionaba por suerte.

La regla 18 tenía el mismo primer defecto: en el 1 comparaba el cuestionario
final solo contra lo anterior a la sección 1. Las dos leen ahora el último
`<Quiz>` —con un auxiliar común, `_cuestionario_final`— y la 19 lee las
secciones del `curriculum`. De paso avisa si una etiqueta nombra una sección
que no existe: un `'cap6'` mal tecleado pasaba en silencio si esa pregunta no
era la única de su sección. Pruebas negativas: sin `cap5` en el 2 y en el 3
avisa que falta; con un `'cap6'` avisa de la sección ajena; y una opción de un
ejercicio de la sección 3 del 1 copiada en el cuestionario final la ve la regla
18 nueva y no la vieja. Las reglas 1 a 18 dan salida idéntica antes y después
en los cuatro capítulos.

Con la regla ya mirando lo que debe, el **2** reparte dos preguntas por sección.
El **1 no**: sus ocho preguntas son 2 de numeración, 2 de estructura, **4 de
operadores y ninguna de la sección 4**, reales y error de redondeo. Es la sección
que más importa para un curso de finanzas y la única que el cuestionario no
evalúa. Queda en rojo a propósito: la etiqueta dice la verdad, y lo que falta
es una pregunta.

Y una que no vigila nadie: la pregunta 8 del final del 1, `False or True and
False`, es la de `True and False or True` del minicuestionario de la sección 3
con los términos cambiados de sitio. La regla 18 no la ve porque solo compara
opciones de 25 caracteres o más, y las de ese ítem son `True` y `False`.

**Post scriptum del mismo día.** Cerrado el rojo del 1 cambiando dos preguntas
de operadores por dos de la sección 4; el cuestionario sigue en ocho y queda en
2 por sección. Salieron la 8, que repetía el minicuestionario de la sección 3, y
la 6 —«el operador // realiza:»—, que era memoria de una definición. Entran las
dos ideas de la sección 4 que ningún ejercicio evaluaba:

- **Qué resuelve el problema de raíz** en un cierre que decide si un saldo
  cuadra: centavos enteros, `Currency` o `Decimal`. El distractor fuerte es la
  tolerancia de medio centavo, que la tabla de la sección reserva para cálculos
  intermedios; la justificación explica por qué no basta con un caso ejecutado:
  `round(2.675, 2)` da `2.67` en Python, porque ese 2,675 está guardado como
  2,67499….
- **Cuál de 0,1, 0,2 y 0,75 se guarda exacto.** El 0,75 no aparece en ninguna
  parte del capítulo, así que se contesta entendiendo, no recordando el
  laboratorio. El distractor del 0,2 es el que enseña: multiplicar por dos sí es
  exacto en base 2, y `0.1 * 2 == 0.2` da `True`, pero el 0,2 guardado no es
  0,2 —su error es exactamente el doble del de 0,1—. Es la tesis de la sección
  hecha pregunta: el error no es de la operación, es de la representación.

De paso la regla 17 pasa de 4 avisos a 3 en el 1: el que se fue era la clave de
la vieja pregunta 8, de 76 caracteres contra «True». Comprobado en el navegador:
8/8 bien respondido, 6/8 fallando solo las dos nuevas con sus justificaciones a
la vista, y a 375 px sin desborde.

Y la regla 19 ya no calla: un cuestionario final sin ninguna etiqueta da un
**aviso** —no un fallo: no está mal, no se miró—. Es el caso del capítulo 5
recién copiado de la plantilla, cuya demostración no trae etiquetas: el aviso
sale hasta que se declaren. Prueba negativa: el 1 sin etiquetas avisa y pasa;
con etiquetas a medias, o sin `cap5`, sigue fallando; sin `Quiz`, no dice nada.

### Las claves largas del capítulo 2 · 2026-09-28

Los siete avisos de la regla 17 en el 2, más uno que la regla no ve: la
pregunta 2 del cuestionario —clave de 65 caracteres contra «La salida.» y «La
entrada.»— es el peor caso del capítulo (3,5 veces la media de los
distractores), y la regla lo salta porque solo mide ítems con todas las opciones
de 20 caracteres o más. El filtro existe para no medir opciones como «Cero» o
una cifra; aquí deja fuera justo los distractores más pobres, que son los que
más regalan la clave.

El arreglo es el de siempre, **alargar los distractores**: cada uno recibe una
razón, como la clave ya tenía, y la razón es la creencia equivocada —«ocupa
menos memoria: carga 12 registros en vez de 39 814», «una cédula está hecha
solo de dígitos, así que el tipo entero es el que le corresponde»—. Tres cosas
que salieron al hacerlo:

- **Un distractor alargado puede volverse defendible.** «Una salida: se le
  informa al cliente junto con la cuota» era verdad a medias, porque el
  algoritmo de la sección 2 sí imprime el seguro total. Se reescribió con una
  razón inequívocamente falsa. Lo mismo con la inflación («no se sabe cuánto
  cuesta de verdad» es cierto; «cualquier cifra depende de la inflación» no, las
  24 cuotas son fijas) y con «ninguna de las dos cifras se nota», que en tiempo
  de reloj puede ser cierto.
- **Pasarse de largo crea la pista contraria.** Al primer intento la clave quedó
  la más corta en las preguntas 1, 2 y 3 seguidas. Se acortó un distractor en
  cada una: ahora la clave queda en medio en seis de ocho, y en las otras dos a
  menos de 1,1 veces la media.
- **Las cifras de los distractores se ejecutan.** El seguro de 0,12 % son
  345 600, el 6 % del sobrecosto, así que atribuirle «la mayor parte» sigue
  siendo falso. Y la justificación de la pregunta 10 dice ahora que partir por
  la mitad cuesta como mucho 16 comparaciones con 40 000 registros y 22 con
  4 000 000: corrido con el contador del propio capítulo, exhaustivo en 40 000.

El 2 queda sin ningún aviso, el primero de los cuatro. Navegador: 10/10, y 6/10
fallando las preguntas 1, 2, 3 y 10; los dos E7 dan «Revisa la explicación» con
un distractor y «¡Correcto!» con la clave; a 375 px, sin desborde.

Queda anotada una repetición que la regla 18 no ve: la pregunta 10 del
cuestionario —¿bajo qué condición se puede usar la búsqueda por mitades?— es el
comparador de la sección 5 con otras palabras, y las dos claves dicen lo mismo:
solo si la cartera está ordenada. La regla pide dos opciones calcadas y aquí
solo lo está la clave.

### Las claves largas del capítulo 3, y una clave falsa · 2026-09-28

Los cuatro avisos del 3, con el mismo método del 2: cada distractor recibe la
razón de la creencia equivocada, y la clave queda entre 1,02 y 1,06 veces la
media en los cuatro. El 3 queda sin avisos.

Al comprobar las cifras antes de escribir apareció algo más grave que el
tamaño: **la clave de la pregunta 6 era falsa.** Decía que `(a + b) / 2` y
`a / 2 + b / 2`, con división entera, dejan de coincidir «cuando alguno de los
dos valores es impar». Con 3 y 4 dan 3 las dos. Difieren si y solo si **los dos**
son impares —3 y 5 dan 4 y 3—: cada mitad pierde su medio por separado, y la
suma, dividida una sola vez, no pierde nada porque es par. Si solo uno es impar,
la suma también lo es y pierde el mismo medio. Comprobado en los 900 pares de 0
a 29, y en Python también con negativos; con el `\` de VBA y signos mezclados
basta uno solo impar (`-3` y `4`), pero el ejercicio habla de saldos. La
pregunta lo había copiado de la sección 3, donde la justificación del
comparador decía lo mismo; se corrigieron las dos. Y la frase vieja entra como
distractor: es exactamente el error que el propio capítulo cometía, y solo se
descarta probando con 3 y 4.

Dos distractores más se cambiaron por **defendibles**, no por cortos:

- «Cuando a y b son muy grandes, porque la suma se desborda» es cierto en VBA:
  `a + b` puede pasarse de un `Long` —21 millones de pesos en centavos— cuando
  `a \ 2 + b \ 2` no. Es el fallo clásico del punto medio en la búsqueda
  binaria.
- La justificación de la pregunta 10 decía que «2 % mensual» se detiene antes de
  componer. Pero 2 % mensual es exacto si capitaliza cada mes; el error es dar
  por sabido el dato que falta. Si el 24 % fuera efectivo anual, el mes costaría
  1,81 %.

Navegador: 10/10, y 6/10 fallando las cuatro tocadas —la 6 con la clave vieja,
que ahora cuenta como error—; el comparador de la sección 3 muestra la
advertencia corregida; a 375 px, sin desborde.

Ninguna regla podía ver una clave falsa: todas miden la forma de la pregunta,
no si lo que afirma es cierto. La encontró ejecutar la cifra antes de
reescribir el ítem —la misma regla que cazó el `#> 600000` del capítulo 1—.

### La clave larga del capítulo 4 · 2026-09-28

El único aviso del 4 era el E2 de la sección 3: con la versión de dos `Si`,
¿qué tarifa recibe un cliente no preferencial de 800 000? La clave —«0, ninguna
condición se cumple»— medía 84 contra una media de 56. Cada distractor recibió
su razón, y las cifras se ejecutaron: 800 000 × 0,002 = 1 600 y × 0,005 =
4 000. El fuerte es el de 4 000: es lo que daría la versión correcta con
`Si…Sino`, así que lo marca quien lee la intención del programa y no el
programa. Clave a 1,02 veces la media. Navegador: «Revisa la explicación» con
el 4 000 y «¡Correcto!» con la clave; a 375 px, sin desborde.

Con esto el 2, el 3 y el 4 pasan sin ningún aviso. **Quedan tres en el 1**, en la
sección 2 —el E del cajero automático que tarda 15 segundos y dos preguntas del
minicuestionario—: se anotaron al arreglar el cuestionario final del 1 y se
dieron por resueltos al hacer la cuenta de lo que faltaba. No lo estaban.

### Las claves largas del capítulo 1 · 2026-09-28

Los tres avisos del 1 estaban en la sección 2 —el cajero que tarda 15 segundos,
la ALU y el paso *decode*—, pero el capítulo tenía **ocho más que la regla 17
no ve**: sus minicuestionarios y su cuestionario final están llenos de opciones
cortas («11», «RAM», «False»), y la regla se salta todo ítem con una opción de
menos de 20 caracteres. Se arreglaron los once.

Casi todos los invisibles eran de un tipo que no había aparecido en los otros
capítulos: **la clave trae su propia cuenta.** `'21 (16 + 4 + 1 = 21)'` contra
`'17'` y `'10101'`; `'2 (17 dividido entre 5 da 3, sobra 2)'` contra `'3.4'` y
`'3'`; `'255 (2⁸ - 1).'` contra `'1024'` y `'128'`. Se acierta sin saber el
tema: la única opción que razona es la buena, y su aritmética cuadra. El arreglo
es darle a cada distractor su cuenta equivocada, que es la creencia que
representa, ejecutada antes de escribirla:

- `42 (32 + 8 + 2)`: los pesos binarios empezando en 2 en vez de en 1.
- `11 (1 + 2 + 0 + 8)`: los pesos leídos al revés.
- `3.4 (% divide)` y `3 (% da el cociente)`: las dos confusiones del módulo.
- `256 (2⁸)` en lugar de `1024`: el error de uno —256 valores, pero el último
  es el 255—, que es exactamente lo que explica la justificación.

En el ciclo de instrucción, los distractores de «¿qué hace *decode*?» son ahora
los otros tres pasos que la sección enseña —leer, ejecutar, guardar—, no «se
guarda en el disco duro». Y los de la ALU, lo que hace la Unidad de Control,
que es lo que dice la justificación.

Resultado: **los cuatro capítulos pasan sin ningún aviso.** Navegador: los
tres minicuestionarios y el final con puntaje completo, y con exactamente el
puntaje esperado al marcar los distractores nuevos (2/3, 1/3, 1/4, 5/8); los dos
MCQ, «¡Correcto!» y «Revisa la explicación»; a 375 px, sin desborde en las
cuatro secciones.

Dos cosas anotadas, sin tocar:

- **La regla 17 no ve 8 de las 11 claves largas del 1.** El filtro de 20
  caracteres existe para no medir opciones como «Cero», pero deja fuera también
  las claves que traen su cuenta, que son las que más regalan. Queda propuesto
  ajustarlo.
- **`True and False or True` da `True` se agrupe como se agrupe**, así que esa
  pregunta del minicuestionario de la sección 3 no mide la precedencia, que es
  para lo que está. Pide otra expresión, no otros distractores.

### La regla 17 ve las opciones cortas · 2026-09-28

La regla se saltaba todo ítem con una opción de menos de 20 caracteres, y por
ahí se le escaparon ocho claves del 1 y una del 2. El filtro no se quitó sin
más: existía porque entre cifras la proporción no dice nada —`'10'` es el doble
que `'7'`—. Se cambió por un **margen**: si alguna opción es corta, además de
cumplir una de las dos varas, la clave tiene que sacarle **8 caracteres** al
distractor más largo. En prosa la regla queda como estaba.

El 8 sale de lo medido. Los 17 avisos que la regla ya daba le sacan al
distractor más largo entre 16 y 65 caracteres; las claves del punto ciego,
entre 9 y 35 (la más justa, `'255 (2⁸ - 1).'` contra `'1024'`); las listas de
cifras se diferencian en 1 a 4.

Prueba negativa, contra las versiones de antes de cada arreglo:

- el 1 pasa de 3 avisos a 10: las siete claves nuevas son siete de las ocho
  invisibles;
- el 2 pasa de 7 a 8: el nuevo es la finitud, el «uno que la regla no ve»
  anotado al arreglar ese capítulo;
- el 3 y el 4, iguales; ningún aviso de los que ya salían se pierde;
- los cuatro capítulos de hoy, cero avisos: el ajuste no mete ruido.

Casos sintéticos: `'10'` entre `'7'` y `'8'`, `'1000'` entre `'1'`, `'10'` y
`'100'`, y `'Cero'` entre cifras, callan. `'Error de tipo (TypeError)'` como
clave entre `'53'` y `'8'` **salta, y es a propósito**: ser la única opción
escrita con palabras la delata igual que el tamaño. Como distractor, calla.

La octava clave del 1 sigue sin verse, y no por el tamaño:
`'13 (8 + 4 + 0 + 1 = 13)'` competía con `'1101 (es el mismo número)'`, que mide
más. Lo que la delataba era ser la única que razona, y eso no se mide contando
caracteres. Queda anotado en el README como algo que se mira leyendo.

### La clave del acumulador del 3 ya no es la única sin razón · 2026-09-28

Al calibrar la regla 17 apareció el caso contrario, que ninguna regla mira: en
el E2 del acumulador (sección 2 del 3) la clave era `'1 050 000.'`, pelada, y
los tres distractores traían su razón —39, 72 y 73 caracteres—. Es la quinta
forma del README vista del revés: la única opción que no razona también se
distingue.

Se le dio a la clave su razón, como a las demás, y de paso se cambió un
distractor. `'2 050 000, la suma de los tres números'` era sumar mal, no una
creencia sobre la asignación. El nuevo es la que la justificación desmiente:
`'700 000: a la derecha, saldo vale siempre lo que se le dio al principio'`,
que es leer `saldo` como una incógnita fija, ejecutado (1 200 000 − 500 000).
La justificación suma una frase para quien lo marque. Las cuatro opciones miden
ahora 72–74.

Navegador: con el 700 000, «Revisa la explicación»; con la clave, «¡Correcto!»
y la frase nueva a la vista; a 375 px, sin desborde en la sección 2; consola
limpia.

### Tres errores del material, corregidos · 2026-10-16

Los tres estaban anotados y sin tocar.

**Capítulo 4 · el error de VBA de la guardia no era el 11.** El ejemplo
`EJ_GUARDIA` divide `total / compras` con los dos en 0, y el capítulo decía en
tres sitios —el comentario del bloque VBA, el recuadro «El único de los cuatro
que no perdona» y una pregunta del cuestionario final— que eso es el error 11,
«División por cero». Se comprobó en Excel 16.112 con una macro que ejecuta la
línea tal cual, `compras` Long y `total` Currency: **0/0 da el error 6,
«Desbordamiento»**; con `total = 5`, la misma línea da el 11. En Double pasa lo
mismo (0/0 → 6; 1/0 → 11, nunca infinito). El texto dice ahora las dos cosas, y
la pregunta del cuestionario habla de «un error de ejecución», porque no fija el
total. Lo cazó el agente que escribía el cloze `cortocircuito` del Parcial II,
que por eso usa siempre un numerador distinto de cero.

**Capítulo 1 · `True and False or True` no medía la precedencia.** Da `True` se
agrupe como se agrupe, así que el ítem del minicuestionario de la sección 3 —que
existe para eso— se acertaba sin saberla. Ahora es `True or True and False`:
con la precedencia da `True` y de izquierda a derecha da `False`, ejecutado en
Python y en R. El distractor nuevo es justamente la lectura de izquierda a
derecha.

**Capítulo 2 · la pregunta 10 del cuestionario repetía el Comparador.** Las dos
tenían la misma clave —la búsqueda binaria exige la cartera ordenada—, y la regla
18 no lo veía porque solo la clave estaba parafraseada. La nueva sigue en la
sección 5 pero mide otra cosa: cuántas comparaciones hace el algoritmo A para el
crédito 2 500. La clave sale de ejecutar `EJ_CONTEO` del propio capítulo con ese
crédito (A: 2 500; B: 4), y los distractores son tres creencias: que A recorre
siempre toda la cartera, que A también descarta mitades, que cuesta el promedio.

Verificación: `verificar.py --con-salidas` en verde en el 1, el 2 y el 4;
`ensamblar.py` no mueve `lp-base.html`. Navegador: el minicuestionario del 1 da
4/4 y 3/4 con la lectura de izquierda a derecha; el cuestionario final del 2, 10/10
y 9/10 con el distractor nuevo; el 4 muestra los textos nuevos; consola limpia.

### Tarea 10 · Capítulo 5, «Control repetitivo» · 2026-09-28 a 2026-10-21

El plan, con sus hallazgos y lo medido en cada tarea, está en
`PLAN_TAREA10_CAPITULO_05.md`. Rama `cap05/control-repetitivo`, en el *worktree*
`.claude/worktrees/cap05`. Aquí va lo que sirve para los capítulos que siguen.

**Construido.** Siete secciones, portada y evaluación: 19 ejercicios (E1:4 E2:4
E3:2 E4:2 E5:2 E6:1 E7:2 E8:2) y un glosario de veinte términos. Tres artefactos
propios del capítulo, fuera de LP-CORE:
- `AmortizacionPasoAPaso`, la tabla de 240 filas que prometieron los capítulos 3
  y 4;
- `TresCiclosComparados`, con el `for` de R y el `range` de Python como paneles
  opcionales;
- `TIRBiseccion`.

En el banco privado, ocho cloze con 19 sub-ítems, compilados a Moodle con nueve
variantes cada uno. La tarjeta 05 del portal ya es un enlace.

**Hallazgos de fondo, medidos en Python y en R:**
- **`Mientras saldo > 0` da una vuelta de más en dos de cada seis créditos.** El
  signo del residuo de punto flotante decide, y cambia con el orden de las
  operaciones: un crédito de 240 cuotas da 241. Por eso la tabla de amortización
  va por contador, y ningún cloze cuenta vueltas de un ciclo por saldo.
- **`Para` no significa lo mismo en los cuatro lenguajes.**
  - En R, `for (k in 1:n)` con n = 0 da dos vueltas.
  - `range(1, n)` da n − 1.
  - En VBA, el cuerpo puede cambiar el contador.
- **Una bisección con tolerancia 10⁻¹⁸ no termina:** el intervalo se queda en el
  espacio entre dos Double vecinos (3,5 × 10⁻¹⁸).

**Herramientas nuevas:**
- **`_plantilla/ejecutar_vba.py`:** el arnés que corre en Excel para Mac el VBA
  que declara salida (riesgo R2). Todavía no se ha corrido contra Excel.
- **Regla 21 de `verificar.py` (la 20 hasta fundirse con la del `head`) y `comprobar_cifras.js`:** las cifras de la prosa
  no se parten entre renglones. Se pasó a los cinco capítulos: 816 espacios duros.
- **Un intérprete del pseudocódigo del capítulo, en las reglas del banco
  privado.** Las reglas de los cloze ejecutan el código impreso, el que lee el
  estudiante, en vez de rehacer la cuenta.

**La auditoría (Fase 3).** La hicieron cuatro auditores en paralelo: tres
ejecutaron unas 240 cifras y uno cotejó el capítulo con los capítulos 1 a 4. Se
corrigieron un error y cuatro cifras ambiguas, una afirmación falsa («en este
capítulo las diferencias entre lenguajes dejan de ser de acento», cuando el 4 ya
era el primero) y nueve inexactas. Ninguna regla habría visto nada de eso.

**Trampas nuevas, para la skill:**
- `num()` usa `format()`, que redondea a 7 cifras significativas. Una cuota de
  613 097,12 se imprimía `613097.1` en el código del cloze, y el código ya no era
  el del sorteo.
- Con el panel de vista previa en segundo plano, las animaciones y las
  transiciones se quedan en su estado inicial. La medida de contraste dio 1,00
  hasta que se neutralizaron.
- El árbol de React se lee desde `stateNode.current`; el nodo del contenedor da a
  veces la copia vieja.

**Queda pendiente:**
- correr el VBA en Excel;
- las deudas de LP-CORE (P3): `Salir`, `localStorage` sin `try`, la sangría de
  `OrdenaPasos`, la justificación de `MCQ` y el plegado de tildes;
- el desborde de la sección 3 del capítulo 2 a 375 px, que ya existía y quedó
  como tarea aparte;
- la revisión del docente en el punto de control final.

### El desborde de la sección 3 del 2 y la transición de `.lp-card` · 2026-10-21

**Capítulo 2 · el pseudocódigo empujaba la página a 375 px.** En «Cuatro
representaciones», la columna de lenguaje natural y pseudocódigo es un ítem de
grid con `min-width: auto`, y las seis líneas del pseudocódigo van con
`white-space: pre`. La más larga, `interes <- capital * tasa * plazo`, mide
311 px; con el padding del botón y el de la tarjeta, la columna crecía a 359 px
en una pista de 319, y el panel de la lección daba `scrollWidth` 383 contra
`clientWidth` 367. Ahora la columna lleva `min-w-0` y el pseudocódigo se
desplaza dentro de su tarjeta, con un `min-w-max` interior para que la franja del
paso activo llegue a la línea más larga (commit 9df2270).

**Parecía depender de haber visitado antes otras secciones, y no dependía.**
`.lp-card` tenía `transition: all 0.3s ease`. En una carga directa a la sección 3,
el Tailwind del CDN genera `.p-4` después del primer render, y el padding de las
tarjetas entraba animado desde 0; con el panel de vista previa oculto esa
transición se queda congelada (trampa 15 de la skill), así que la medida daba
367/367 con tarjetas sin padding. Visitando antes otras secciones, `.p-4` ya
existía y no había transición. Con las animaciones terminadas, la carga directa
también daba 383.

**La transición de `.lp-card` es ahora solo `box-shadow` y `transform`**, lo
único que cambia con `:hover`. Se editó en el `head` del capítulo 1, que es la
fuente (trampa 1), se regeneró `lp-base.html` con `ensamblar.py` y se copió la
misma línea en el `head` del 2, el 3 y el 4. `migrar.py` no tenía nada que
estampar: el hash de LP-CORE no cambia.

**Hueco de las herramientas: el `head` de los capítulos no lo propaga ni lo
compara nadie.** `ensamblar.py` lo lee del 1, `migrar.py` estampa solo LP-CORE y
el `App`, y `verificar.py` compara LP-CORE (comprobación 1) y la plantilla con
sus fuentes (13), no el `head` del 2 en adelante. Prueba negativa: el capítulo 3
con el `head` anterior a este cambio pasa `verificar.py` en verde. Hoy los cuatro
`head` son idénticos salvo el `<title>` y la descripción.

Queda fuera: seis botones `lp-card p-2 … transition-all` propios del capítulo 2
(línea 2787) y varios botones de LP-CORE y del `App` con `transition-all` siguen
animando el padding 0,15 s en la primera carga.

Verificación: `verificar.py` en verde en los cuatro capítulos, con la 13
incluida. Navegador a 375 px, carga directa a la sección 3 del 2, **sin terminar
las animaciones**: tarjetas con 16 px de padding desde el primer render, columna
de 319 px, panel 367/367, pseudocódigo desplazable (327 en 287); un `:hover`
simulado anima solo `box-shadow` y `transform`; consola limpia.

### Comprobación 20: el `head` de cada capítulo es el del 1 · 2026-10-22

Cierra el hueco anotado en la entrada anterior. `verificar.py` compara ahora el
`head` de cada capítulo —hasta `<script type="text/babel">`, la misma ancla de
`ensamblar.py`— con el del capítulo 1, después de vaciar en los dos el texto del
`<title>` y el `content` de la descripción, que son lo único propio de cada uno.
Vaciar no quita líneas, así que la falla cita la línea del archivo y muestra las
dos versiones tal como están escritas. Es una falla, no un aviso: un `head`
distinto es otro CSS u otras librerías.

| Prueba | Resultado |
|---|---|
| El 3 con el `head` anterior al cambio de `.lp-card` | Falla en la línea 117 |
| El 4 con una librería de más tras Tailwind | Falla en la línea 18 |
| El 4 sin una línea de CSS de `.lp-card` | Falla en la línea 115 |
| El 2 sin la `<meta>` de descripción | Falla en la línea 7 |
| El 2 con otro `<title>` y otra descripción (control) | Pasa |

Los cuatro capítulos pasan. De paso: la lista numerada del README se queda en la
regla 12; la lista completa, del 1 al 20, está en el docstring de `verificar.py`.
El README explica ahora en «Flujo de trabajo» cómo se cambia el `head`.

### LP-CORE arranca sin cdnjs · 2026-10-23

**El fallo.** Sin acceso a cdnjs (sin red, o bloqueado) el `<head>` deja `window.Prism = { manual: true }` y Prism
no llega. La guarda de la gramática del pseudocódigo, `if (window.Prism && !Prism.languages.pseudo)`, lanzaba
entonces un `TypeError` al ejecutarse el script de Babel, y React no montaba nada: el capítulo quedaba en blanco.
`resaltar` tenía el mismo defecto (`(nombre && window.Prism) ? Prism.languages[nombre]`). Lo destapó la auditoría
de las diapositivas del cap. 5 de Muestreo: la guarda de la skill `diapositivas-clase` venía de aquí.

**El arreglo**, en la fuente: `lp-core-extra.jsx` calcula una vez `const hayPrism = !!(window.Prism &&
Prism.languages)` y las dos guardas la usan; sin Prism el código sale sin color y el capítulo carga. `ensamblar.py`
regeneró `lp-base.html` y `migrar.py --sin-copia` reestampó del 1 al 4. Cada archivo cambia solo en esas 7 líneas,
byte a byte igual al parche a mano.

**Verificado.** `verificar.py`: los 4 capítulos pasan, deriva incluida. Una sonda en Chrome sin ventana recorre
todas las lecciones con «Siguiente». Con cdnjs bloqueado, antes los cuatro y `lp-base.html` quedaban en blanco con
`Cannot read properties of undefined (reading 'pseudo')`. Ahora cargan sus 6, 7, 7 y 8 lecciones (y las 5 de la
plantilla), con el código sin color, sin errores de JavaScript y con el mismo texto que con red. Con red, idéntico
antes y después.

**Lo que queda.** Sin commit. Con la red caída del todo los capítulos siguen en blanco: React, Babel y Tailwind vienen de unpkg y de cdn.tailwindcss.com. El arreglo cubre cdnjs bloqueado o caído con lo demás accesible. Los worktrees `cap05` y `magical-hamilton-f5c27e` tienen su propio
`lp-base.html` sin el arreglo: el 05 lo recibe al reestamparlo tras fusionar, y si no, `verificar.py` marca la
deriva. Los capítulos de Python para APIs e IA, que montan LP-CORE con `montar.py`, se parchearon a mano allí.

### La rama del capítulo 5 recoge la del `head` · 2026-10-27

**Dos reglas 20.** La rama `cap05/control-repetitivo` y la del desborde del 2
(`claude/magical-hamilton-f5c27e`) salieron las dos de `fec3737` y crearon cada una
su regla 20: la de las cifras partibles y la del `head` al día. Al fundir la segunda
en la primera, la del `head` se queda con el 20, que es el que ya citaba la memoria,
y la de las cifras pasa a ser la **21**. Los textos vigentes (docstring, README,
`PLAN_TAREA10`) dicen 21; las entradas viejas de esta bitácora que hablan de «una
regla 20 opcional» son de antes de ambas y se dejan como están. El docstring de la
21 decía todavía U+202F para el separador de miles: se corrigió a U+00A0, que es lo
que pone `comprobar_cifras.js`.

**La regla 20 cazó el 05 en cuanto llegó.** Su `head` no tenía el cambio de la
transición de `.lp-card`; se le aplicó el mismo parche de cinco líneas que al 3. Es
justo el olvido para el que nació la regla.

**Verificado.** `verificar.py --con-salidas`: los cinco capítulos pasan las 21
reglas. Prueba negativa de la 21 tras el cambio de número: una cifra con espacios
normales en una celda del 05 falla. Con `file://`, una sonda en Chrome sin ventana
—perfil nuevo, sin banderas que cambien la seguridad de `file://`, como un doble
clic— monta los cinco capítulos, recorre sus 6, 7, 7, 8 y 9 lecciones con
«Siguiente» y no da ningún error de JavaScript; los cinco guardan su clave en
`localStorage`.

**Después, `main`.** El docente pidió versionar el arreglo de cdnjs (entrada anterior),
que estaba sin commit en el árbol de `main`; se hizo con sus siete rutas, tras pasar
`verificar.py` en verde del 1 al 4. Se trajo `main` a la rama: solo chocó esta
bitácora, y sus entradas quedan en orden de fecha. El 05 se reestampó con
`migrar.py --sin-copia` y cambia solo en las siete líneas del arreglo.

**Una reestampada destapó una corrección que no estaba en su fuente.** La pasada de
la regla 21 había puesto el espacio duro de «{progreso} %» en el `App` de los cinco
capítulos, pero el `App` sale de `lp-demo.jsx`, que seguía con el espacio normal:
reestampar lo deshacía en silencio. Ahora está en la fuente, y reestampar no mueve
ningún capítulo del 1 al 4.

**`migrar.py` estampaba con cualquier opción.** Las opciones que no conoce no
contaban, y sin rutas el caso por omisión es estampar todos los capítulos: un
`--help` escribió en los cinco y dejó sus `.bak`. Por suerte la plantilla ya era la
nueva y las copias eran idénticas al índice. Ahora una opción desconocida muestra el
uso, no escribe nada y sale con 2. Probado con `--help` y con `--dry_run`.

**Verificado.** `verificar.py --con-salidas`: los cinco pasan. Con `file://` y con red,
los cinco montan, recorren todas sus lecciones y no dan errores de JavaScript. Con
cdnjs bloqueado en el resolvedor de Chrome, el 05 monta y recorre sus nueve
lecciones con el mismo texto y el código sin color; los únicos errores son las doce
descargas de cdnjs que no llegan.

### Las deudas de LP-CORE (P3) · 2026-10-27

En la rama `lpcore/deudas-p3`, salida de `main` ya con el capítulo 5. Una sola
reestampada de los cinco capítulos para todo lo que se venía apuntando desde el
capítulo 4.

**Lo que se arregló.**

| Deuda | Qué cambia |
|---|---|
| H6 · `Salir` | Entra en la gramática del pseudocódigo. Se colorea en la búsqueda del 2. |
| H16 · `localStorage` | `leerGuardado` y `guardar` con `try`. Sin almacenamiento, los cinco cargan; antes quedaban en blanco. Regla **22** nueva: el contenido no lo toca directo. |
| P2 del 4 · tildes | `TablaTraza` las ignora: «sí» y «si» valen igual. La ñ cuenta. |
| L3 · coma de miles | `1,350,000`, como imprime Python, ya no se lee 1,35. Una respuesta ambigua (`1.250`) vale por cualquiera de sus lecturas; la clave tiene una sola. |
| L1 · desorden | `OrdenaPasos` usa una permutación sembrada con el texto de los pasos: sin pasos en su sitio, sin pares seguidos ni saltos regulares, en los 32 casos del curso. Antes era `[n−1, 0, n−2, 1, …]` en todos. |
| H17 / L2 · sangría | Los pasos y la solución la conservan (`whitespace-pre-wrap`). Se califica por texto. |
| H9 del 4 · `MCQ` | Muestra la justificación de cada opción mal elegida y la de todas las correctas. Ningún `MCQ` del material tiene hoy distractores justificados, así que nada publicado cambia. |
| Etiqueta doble | Dentro de `<Ejercicio>`, `DetectaError`, `Comparador` y `Emparejamiento` la mostraban dos veces en el 4 y el 5. Ahora va una, con el tipo del envoltorio. |
| `Emparejamiento` | El círculo de un elemento emparejado muestra la letra de su pareja, no un número. |
| L5 · `Trazador` | Variables `efimera: true`. La columna «saldo > 0» de la sección 2 del 5 la usa, y se fueron los seis «—» puestos a mano. |
| L6 · `Pipeline` | La flecha va con su etapa y se esconde al final de una fila. |
| L6 · `ChartFrame` | Admite `descripcion` (`role="figure"`, para no esconder los botones de Plotly). |
| L6 · marcadores | Cada flujograma del 4 tiene su `id`. Antes la variante estrecha apuntaba al marcador de la ancha, oculta a 375 px. |
| L4 · `not-prose` | Solo en títulos y tablas (ver abajo). |

**`not-prose`, medido antes de tocarlo.** Se compararon los estilos calculados de
todo lo que hay dentro de un `.not-prose` con el CSS de siempre y con uno que lo
respeta, lección por lección. Respetarlo del todo cambiaba cientos de medidas:
- la motivación de cada sección perdía interlineado (28,6 → 22,4 px);
- los párrafos de los componentes, su margen;
- las listas de `CalloutPro`, sus viñetas.

Esos componentes se ajustaron con la prosa puesta. Se aplicó solo a `h3`, `h4`,
`table`, `th` y `td`, y lo único que cambia es lo que la revisión señalaba:
- los `h4` de unos pocos componentes recuperan su `text-primary`;
- la tabla de verdad del 4 centra sus encabezados y entra entera;
- la de amortización del 5 los alinea a la derecha, sobre sus cifras.

Se miró en capturas de antes y después.

**Herramientas.**
- **`sonda_navegador.mjs`, nueva.** Chrome sin ventana con `file://`, en cuatro
  modos: `file`, `375`, `sin-almacen` y `sin-cdnjs`. Se versiona porque el panel
  de vista previa no sirve para esto: ahí `requestAnimationFrame` no corre y
  `ResizeObserver` no notifica (medido). La primera prueba del `Pipeline` dio una
  medida vieja por eso, y no por el componente.
- **La medida de 375 px cuenta aparte lo recortado.** Es lo que queda dentro de
  un `overflow-x: hidden`, como los bloques de código plegados. Es idéntico al
  de `main` salvo dos elementos del 2, que son los `Salir` ahora coloreados.
- **Un hallazgo del instrumento.** Una sonda que muere sin cerrar su Chrome deja
  el puerto ocupado, y la siguiente se conecta a la página vieja sin ningún
  error. `sonda_navegador.mjs` usa un puerto por proceso.

**Verificado.**
- `verificar.py --con-salidas`: los cinco pasan las 22 reglas.
- La regla 22, con su prueba negativa: un `localStorage` en el `App` falla, y
  dos comentarios que lo nombran no cuentan.
- La sonda, en sus cuatro modos sobre los cinco capítulos. Su propia prueba
  negativa: el 05 de `main` no monta sin almacenamiento.
- Por DOM en el 5:
  - la traza de la sección 2, columna por columna;
  - `OrdenaPasos` en pseudocódigo y en Python, con una respuesta buena y una
    mala (11/11 y 9/11; 8/8 y 6/8), con 34 px de sangría;
  - la `TablaTraza` de la sección 2 llena con cifras al estilo Python: 15/15, y
    14/15 con una mala;
  - `Emparejamiento`, con «C A» al emparejar;
  - diecinueve etiquetas para diecinueve ejercicios;
  - un `MCQ` de prueba, simple y múltiple, con distractores justificados.
- Las 22 comparaciones de celdas y el desorden, probados como funciones.
- El `Pipeline` del 4, a seis anchos.

**Lo que queda.**
- Que `DetectaError` pida anticipar el `impacto` antes de mostrarlo: cambia
  cómo se resuelven los E3 de todo el curso, y es decisión del docente.
- Hacer valer `not-prose` del todo, que sería rediseñar los componentes.
- Safari y Firefox, sin probar.
- Los `id` repetidos de los flujogramas del 5: ninguno se oculta, así que se
  pintan bien, pero son inválidos.

### Comprobación 23: el `App` de cada capítulo es el de la plantilla · 2026-10-27

`migrar.py` estampa dos regiones, LP-CORE y el `App`, y solo la primera tenía
regla. El 2026-10-20, `comprobar_cifras.js --corregir` puso el espacio duro de
«{progreso} %» en el `App` de los cinco capítulos y no en `lp-demo.jsx`, su
fuente; las veintiuna reglas siguieron en verde. El 2026-10-27, la reestampada
accidental de los cinco capítulos (un `migrar.py --help`) se lo quitó, y se vio en
el diff. La regla 21 lo habría señalado, pero como una cifra del capítulo, y su
`--corregir` lo habría devuelto al capítulo y no a la fuente: el mismo ciclo otra
vez.

`verificar.py` compara ahora el `App` de cada capítulo con el de `lp-base.html`,
con las anclas de `migrar.py`: se compara exactamente lo que él sobrescribe. Es
una falla, no un aviso. Cita la línea del archivo, las dos versiones y, como la
diferencia que dio origen a la regla es invisible, la columna y el código del
carácter de cada lado.

| Prueba | Resultado |
|---|---|
| El 01 y la plantilla de `ba32c8c`, el caso real | Falla en la línea 4502: `U+00A0` aquí, `U+0020` en la base |
| El 3 con el espacio normal en «{progreso} %» | Falla en la línea 4840, columna 100 |
| El 3 con una línea de más al principio o al final del `App` | Falla en la línea añadida |
| El 3 con una letra cambiada («Leccion») | Falla en la columna 46 |
| El 3 sin el ancla `root.render(<App />);` | Falla: no se pudo comparar |
| El 3 con un cambio en `CONFIG`, que no es `App` (control) | Pasa |

Los cinco capítulos pasan. El README corrige de paso su «comprueba doce cosas»:
son veintitrés, y la lista completa sigue siendo la del docstring.

### `DetectaError` pide anticipar la consecuencia · 2026-10-27

La taxonomía (§4) pide al E3 nombrar el error y **anticipar su consecuencia
financiera**. El componente pedía la línea y el tipo, y después **mostraba** el
`impacto` sin preguntarlo. Era la última deuda de P3 a decisión del docente, que
eligió un Paso 3 de **opción múltiple calificada** y, en la misma pasada, que la
regla 17 mirara también los `tipos`. Rama `lpcore/e3-consecuencia`.

**El componente.**
- `consecuencias` y `consecuenciaCorrecta`, como `tipos` y `tipoCorrecto`. No van
  por lenguaje.
- El contador pasa a (n/3), y el veredicto nombra lo que falla («Revise la
  consecuencia: lo demás está bien»).
- Al cambiar de lenguaje se borra la línea y se conservan el tipo y la
  consecuencia.
- El `impacto` sale al comprobar, como explicación del Paso 3.
- Sin `consecuencias`, el ejercicio se queda en dos pasos en vez de dejar el
  capítulo en blanco.

**Las reglas.**
- **La 24, nueva:** todo E3 trae al menos tres consecuencias y una clave que
  señale una de ellas.
- **Las 16, 17 y 18** leen los dos pasos de opción múltiple de cada E3 con una
  sola función. Antes, la 16 leía `tipoCorrecto` con su propia expresión, la 18
  los `tipos` con otra, y la 17 no los miraba.
- **Lo que la 17 encontró al mirarlos:** dos E3 del 1 y uno del 3 delataban el
  tipo correcto por el tamaño (93 caracteres contra una media de 56; 104 contra 52;
  121 contra 72). Se reescribieron al largo de sus distractores, sin cambiar la
  clave.

**El contenido.** Diez E3, cuarenta consecuencias.
- La correcta sale del `impacto`, que ya estaba comprobado.
- Los distractores salen de confusiones reales:
  - se detiene o sigue en silencio;
  - una cifra sacada de leer mal el código: 330 000 en vez de 198 000 en el abono
    del 3;
  - el sentido contrario.

  Ninguno contradice el enunciado. Las claves van sobre todo en la «a» y la «d»,
  porque las de los tipos están casi todas en la «b» y la «c».
- En el 5, los dos E3 traían la consecuencia fundida en las opciones del tipo
  («da una vuelta de menos y la última fila deja un saldo de 903 251,16»). Se
  separó: el Paso 2 es el tipo y el saldo pasa al Paso 3. Los dos enunciados que
  decían «en el segundo paso diga… con qué saldo» se ajustaron.
- El docente revisó la tabla de las cuarenta antes de tocar `main`.

**Verificado.**
- **Las cuarenta afirmaciones, ejecutadas** contra el código de su ejercicio, por
  ejemplo:
  - la tabla de verdad del 1 en 24 combinaciones;
  - la cascada del 4 en 48 casos;
  - las once vueltas del plan del 5.

  Las diez correctas salen ciertas y los treinta distractores, falsos. Hay
  excepciones:
  - tres distractores se descartan leyendo el código, no ejecutándolo: el
    programa no bloquea, no hay registro, el ciclo no divide;
  - en el primer E3 del 2 se ejecutó Python. Que R se detenga y que VBA informe
    0 sale del `impacto` (Excel no se corrió).
- **Pruebas negativas, nueve de nueve:**
  - la regla 24 falla sin `consecuencias`, con dos opciones, con la clave fuera de
    rango, sin clave y con una constante en vez de un arreglo;
  - la 17 avisa de una consecuencia correcta larga y deja pasar unas parejas;
  - la 16 cuenta la clave nueva.
- **Por DOM, en un Chrome sin ventana,** los once E3 (los diez y el de la
  demostración) pasan sus 8 comprobaciones:
  - contador;
  - consecuencia mal, y el veredicto la nombra;
  - «Reintentar»;
  - cambio de lenguaje;
  - todo bien, y aparece el impacto;
  - línea mal, y el veredicto la nombra.
- **`verificar.py --con-salidas`:** los cinco pasan las 24.
- **La sonda,** en sus cuatro modos.
- **Las cifras de las opciones** llevan espacio duro, y `--corregir` no tocó
  ninguna otra línea.

**Un hallazgo aparte.** La demostración de `lp-base.html` tiene tres preguntas que
se delatan por el tamaño: un `MCQ` E2, un `MCQ` E7 y una del `Quiz`. Nunca se
midieron, porque `verificar.py` no revisa la plantilla. No llega a ningún capítulo,
porque la demostración se sustituye al escribirlo.

**Lo que queda.**
- `not-prose` del todo.
- Safari y Firefox.
- Los `id` repetidos de los flujogramas del 5.
- Las tres preguntas de la demostración.

### El arnés de VBA corre en Excel por primera vez · 2026-10-27

`ejecutar_vba.py` llevaba armado desde el capítulo 5 y no se había ejecutado
nunca de punta a punta. Esta vez sí, en Excel para Mac: 42 bloques de los cinco
capítulos.

**Dos defectos del guion, cazados al correrlo.**
- **Los bloques sin procedimiento.** Los dos del `Comparador` del 3
  (`CMP_MENSUALES` y `CMP_EFECTIVAS`) son instrucciones sueltas, y el guion los
  copiaba tal cual al módulo. VBA no admite instrucciones fuera de un
  procedimiento, así que el proyecto entero no compilaba y no corría ninguna
  macro. Ahora cada uno va envuelto en un `Sub Fragmento_b<N>`, y esos dos también
  se comparan.
- **Un mensaje que despistaba.** Si la macro no corre, Excel acepta la llamada de
  AppleScript y no devuelve nada. El guion lo tomaba por un arnés de otra versión
  y mandaba a pegar de nuevo. Ahora dice que la macro no corrió y que
  Depurar › Compilar muestra el error.

Lo que la impedía en esta corrida, además, fue el segundo módulo pegado también
dentro del primero: «Ambiguous name detected».

**El resultado.**
- **30 bloques coinciden exactos.**
- **7 coinciden salvo la coma decimal,** que pone la región Colombia del Mac: el
  guion lo informa aparte.
- **5 no cuadran.** Son salidas declaradas que nadie había ejecutado:
  - **`CICLO_INSTRUCCION` y `META_AHORRO`, del 1:** `Debug.Print` de un número
    escribe un espacio delante, el del signo (« 150», « 3»), y el material
    declara «150» y «3».
  - **`CMP_MENSUALES` y `CMP_EFECTIVAS`, del 3:** la coma de `Debug.Print` salta a
    la siguiente zona de 14 columnas. Excel escribe « 0.018         0.02», y el
    material declara «0.018  0.02».
  - **`EJ_PLAN_PAGOS`, del 5:** la última fila. El material declara «-0.00», que
    es lo que dan Python y R; el `Format` de VBA escribe «0.00», sin signo. El
    propio comentario del bloque decía que ese −0.00 estaba «sin cotejar en
    Excel». La `nota` del `CodeTabs` («La última fila sale con −0.00 y no con
    0.00») vale para tres lenguajes, no para VBA.

**Corregidas el mismo día.** Con el visto bueno del docente, las cinco salidas
declaradas dicen ahora lo que imprime Excel:
- « 150» y « 3», con su espacio;
- las dos del 3, con las zonas de 14 columnas;
- la última fila del plan de pagos, con «0.00».

En el 5 cambiaron además tres textos:
- el comentario del bloque;
- la `nota` del `CodeTabs`, que ahora dice que VBA guarda el mismo residuo y que
  su `Format` lo escribe sin signo («que la tabla diga cero no quiere decir que
  el saldo lo sea»);
- una frase de la explicación del E3 de la sección 6, que decía que la sección 4
  «imprimió» −0.00.

*Cómo se comprobó sin volver a pegar los módulos:*
- El arnés generado con el material corregido es, byte a byte, el que está
  pegado en Excel: solo cambiaron líneas `'>` y prosa.
- La salida de esa corrida, contra las salidas declaradas de hoy, da 32 bloques
  exactos, 10 iguales salvo el separador decimal y ninguno que no cuadre.
- `verificar.py --con-salidas` y la sonda en modo `file` pasan.

El libro de Excel salió del repositorio: está en `Usta 2026II/Arnes_VBA_LPF.xlsm`,
con los dos módulos de esta corrida.

**El identificador del arnés, arreglado el mismo día.** Incluía la hora y las
salidas declaradas, que no van en el módulo. Por eso corregir un `'>` obligaba a
pegar de nuevo un módulo idéntico al que ya estaba en Excel. Ahora es la huella
de los módulos que se pegan, y de nada más:
- corregir una salida pide `preparar` otra vez, no pegar;
- `preparar` avisa cuando el código no cambió;
- `comparar` sigue pidiendo pegar cuando sí cambió.

Trece pruebas, con Excel simulado por la salida real de esta corrida:
- con el material real, ninguna salida que no cuadre;
- con un `'>` cambiado en una copia, el mismo identificador, y `comparar` caza
  ese bloque sin pedir pegar;
- con una línea de código cambiada, otro identificador, y `comparar` pide pegar.

La negativa: con la huella de antes, fallan las tres que importan.

El libro guardado tiene todavía el módulo con el identificador viejo, así que la
próxima corrida pide pegar una última vez.

**Lo que queda.**
- **El material no explica todavía ninguna de las dos rarezas de `Debug.Print`:**
  el espacio que escribe delante de un número y las zonas de 14 columnas. Es
  tema del capítulo 6.

### El cierre del capítulo 5 · 2026-11-02

El docente revisó en un artefacto los puntos que quedaban para cerrar «Control
repetitivo» y marcó cuáles hacer. Se hicieron por fases, en la rama
`cap05/cierre05`; el detalle de cada una está en `PLAN_CIERRE_CAPITULO_05.md`.

**Dos decisiones, anotadas sin tocar código.**
- **`not-prose` en párrafos y listas (L4)** se queda como está, a medias: vale en
  títulos y tablas. El docente aprobó dejarlo para cuando se rediseñen los
  componentes, porque llevarlo a párrafos y listas cambia cientos de medidas en
  los cinco capítulos.
- **Las dos rarezas de `Debug.Print`** se explican en el capítulo 6. Quedó anotado
  en su plan (§5): el espacio del signo y las zonas de 14 columnas.

**El capítulo 5.**
- **Siete frases de la §3 de la revisión,** corregidas:
  - «tres renglones», contado en los cuatro lenguajes;
  - la portada, que ahora dice lo que enseña la sección 5;
  - «La condición no está mal»;
  - «El área de cobranza»;
  - «la macro de Excel que lo calcula»;
  - «el ciclo que acumula su variable»;
  - el abono 0, que ahora está «mal registrado».

  La octava, «a sí misma», ya no estaba.
- **Tres ejercicios, sin cambiar su clave:**
  - la glosa de la «a» del E2 de la sección 2 ya no delata la respuesta;
  - la clave del E4 de la sección 4 ya no promete algo con n = 0, porque con
    n = 0 la fórmula de la cuota divide entre cero;
  - la justificación del E2 de la sección 1 nombra las variables por lo que
    llevan, y vale en los cuatro lenguajes.
- **Una nota en la sección 1:** el 0,9 % y el 2 % mensual son ilustrativos.
  Equivalen al 11,35 % y al 26,82 % efectivo anual, ejecutado en Python y R. No
  cita ninguna tasa de usura, porque no hay fuente verificada en el repositorio:
  dice que la certifica la Superintendencia Financiera.
- **Los flujogramas dibujan su código.**
  - `FlujogramaMientras` asigna el saldo y el abono, como `EJ_ACUERDO`, y escribe
    meses y saldo.
  - `FlujogramaPara` dibuja el plan de pagos que sigue, y no el cobro.
  - Cada flujograma tiene sus propias puntas de flecha: `flechaDefs(id)`, como en
    el 4. La sección 2 tenía `lp-flecha5` dos veces.

**Las herramientas.**
- **Regla 11:** deja pasar «¿Qué escribe el programa?» y sigue cazando los
  encargos.
- **`comprobar_cifras.js --corregir`:** no toca el `App`, y avisa que el cambio va
  en `lp-demo.jsx`.
- **Las tres preguntas de la demostración** que se delataban por el tamaño, ya no
  se delatan. Las encontró la función de la regla 17 aplicada a `lp-base.html`.
- **Regla 25, nueva, de aviso:** las `//>` contra las `#>` de Python.
  - Se midió antes de escribirla: de 42 bloques, 11 coincidían exactos y los
    otros 31 diferían solo en la coma de miles de Python, en los espacios y en
    `True`/`False`. Son las tres diferencias que se normalizan.
  - `SUMA_DECIMAL`, del 1, es una excepción declarada, atada a su salida.

**Medido.**
- **Por DOM, en Chrome sin ventana:**
  - los tres ejercicios, en los cuatro lenguajes, con una respuesta buena y una
    mala: 123 comprobaciones;
  - los ids de las nueve lecciones, a escritorio y a 375 px: ningún id
    repetido, y los 39 `marker-end` encuentran su marcador;
  - la nota de las tasas cabe a 375 px.
- **`verificar.py --con-salidas`** y **la sonda** en sus cuatro modos, en los
  cinco capítulos, al final de cada fase.

**Pruebas negativas.**
- **Regla 11:** seis frases que la regla de antes daba por encargos, y siete
  encargos que siguen fallando.
- **`--corregir`:** sobre una copia, el guion de antes cambiaba el `App`, y el
  nuevo no.
- **Regla 25:**
  - un `//>` cambiado avisa, también dentro de una cifra con miles;
  - solo espacios de más, no avisa;
  - la excepción deja de valer si cambia la salida de `SUMA_DECIMAL`.
- **Los ids:** un marcador clonado y una referencia rota salen.
- **375 px:** un div de 600 px dentro de la nota sale.

**Lo que no se hizo.**
- **El arnés de VBA no se pegó en Excel.** El acceso al escritorio no se puede
  aprobar en una corrida programada. Su huella cambia en una sola línea de
  comentario del módulo 1. Hay que pegarlo igual, porque el libro tiene el
  módulo de antes del 27 de octubre.

**Un hallazgo, sin tocar.** La clave del E2 de la demostración (1 000 000) solo vale
en VBA. En Python y R, intercambiar las líneas 3 y 4 da error.

### Los demás menores del capítulo 5 · 2026-11-03

El docente pidió corregir también los menores de la revisión del 20 de octubre
que no estaban en la lista del cierre. Con eso, la §3 de la revisión queda
cerrada. El detalle está en el «Estado al 2026-11-03» de
`REVISION_CAPITULOS_04_05.md`.
- **Ocho correcciones,** commit `7dbc723`. Ninguna cambia una clave ni una cifra.
- **Cinco ya estaban resueltas** por trabajo anterior, y una se queda a propósito:
  el 0,00 de `AmortizacionPasoAPaso`.

**Lo que enseñó.** Un flujograma puede dibujar con sus propias funciones.
`FlujogramaAnidado` no usa `fjProceso` ni `fjDecision`: tiene `caja` y `rombo`.
Cambiar el estilo en las funciones comunes dejaba el anidado como estaba, y solo
lo cazó la prueba por DOM, que mira el color de cada pieza dibujada y no el
código.

**Verificación.**
- 48 comprobaciones por DOM en los cuatro lenguajes, con la tabla de traza
  hasta el veredicto.
- Su negativa contra la copia de antes: fallan 36, nueve puntos en cada uno de
  los cuatro lenguajes.
- `verificar.py --con-salidas`, las cifras y la sonda en sus cuatro modos pasan.

**Publicado el mismo día.** Por decisión del docente, `main` avanzó hasta el
cierre y se subió: `fec3737..ca7397f`, 44 commits. El despliegue de GitHub
Pages terminó bien en 25 s. El portal y los capítulos 1, 4 y 5 que sirve el
sitio son, byte a byte, los de `main`. El 5 carga en el navegador sin errores
de consola.

**El arnés de VBA, al día.** El mismo día se pegó en `Arnes_VBA_LPF.xlsm` el arnés
`a5ae0595b7`, el primero con el identificador nuevo, y `comparar` dio 42 bloques:
- 32 exactos;
- 10 iguales salvo la coma decimal;
- ninguno que no cuadre.

Desde ahora solo hay que pegarlo cuando cambie el código VBA de algún capítulo.
Un tropiezo al pegar: el portapapeles ya no tenía el módulo que `preparar` dejó
ahí, porque algo se copió después. Conviene copiar cada módulo con `pbcopy`
justo antes de pegarlo.

**La Tarea 10, cerrada.** El mismo día, el docente terminó su lectura completa
del capítulo 5 y abrió el sitio publicado en Safari. Era la última casilla del
punto de control final.

### Tailwind con respaldo: el capítulo 5 en un iPhone · 2026-11-03

**Qué pasó.** En Safari de un iPhone, el capítulo 5 publicado salía desarmado y
con tramos en blanco. Para ver sus errores se le sirvió al teléfono, por la red
local, una copia que los escribía en pantalla:
- `cdn.tailwindcss.com` no cargaba, y por eso fallaba `tailwind.config`;
- React y el contenido sí llegaban, a los ocho segundos;
- sin Tailwind, la barra lateral no se esconde y nada tiene su sitio.

Abierto directamente en el iPhone, `cdn.tailwindcss.com` daba «Safari can't open
the page because the server can't be found». El Mac, en la misma Wi-Fi, lo
resolvía. Es algo del teléfono (un bloqueador, un perfil de DNS o el Relay
privado), pero un estudiante con lo mismo vería los cinco capítulos así.

**El arreglo.** El `head` de los cinco capítulos y de la plantilla:
- fija la versión: `cdn.tailwindcss.com/3.4.17`, a la que ya redirigía la URL
  sin versión;
- si no llega, carga `_vendor/tailwind-3.4.17.js` con `document.write`. Es el
  mismo archivo, con el mismo SHA-256 en dos descargas, y se carga antes de
  `tailwind.config`.

Un capítulo descargado como archivo suelto sigue necesitando el CDN.

**Un hueco de la sonda, cerrado.** La sonda no miraba los estilos. Un capítulo
sin Tailwind montaba, recorría sus lecciones y no daba más error que el de
`tailwind.config`. Ahora exige en todos sus modos que Tailwind haya aplicado su
regla de `max-w-4xl`, y tiene un quinto modo, `sin-tailwind`, que deja sin
resolver `cdn.tailwindcss.com`, como en el iPhone.

**Verificación.**
- **Pruebas negativas en `sin-tailwind`:**
  - los capítulos publicados fallan con «SIN Tailwind» y
    `tailwind is not defined`, lo mismo que en el iPhone;
  - los nuevos, copiados a una carpeta sin `_vendor/`, también fallan.
- **Los nuevos, en su carpeta,** pasan los cinco modos.
- **`verificar.py --con-salidas`** pasa, con la regla 20 del `head` incluida.
- **`ensamblar.py`** dos veces da el mismo SHA.

### El botón del menú tapaba la cabecera de la lección · 2026-11-03

**Qué pasó.** En el iPhone, el botón flotante del menú caía encima de «LECCIÓN N
DE 9». No era del iPhone. Medido en Chrome, de 320 a 900 px el botón (fijo en
`top-4 left-4`, 32 × 44 px) tapaba la etiqueta en los cinco capítulos, y en el
teléfono también «Anterior», que pasa a la segunda línea. Desde 1000 px el
contenido ya empieza a su derecha.

**El arreglo.** En el `App` de `lp-demo.jsx`, la fila «Lección N de M» lleva
`pl-10 lg:pl-0`. Por debajo de `lg` arranca 16 px a la derecha del botón, el
mismo margen que lo separa del borde. La cabecera no gana altura. Se regeneró
la plantilla y se reestamparon los cinco capítulos: el mismo cambio de 7 líneas
en cada uno, y regenerar después de estampar el 01 da el mismo SHA.

**Dos huecos de la sonda, cerrados.**
- **No miraba el botón.** El modo `375` exige ahora, en cada lección, que el
  botón del menú no toque la etiqueta ni los botones de esa fila. Su prueba
  negativa corre antes de medir: sin la sangría, tiene que tocarla.
- **La línea del capítulo no reflejaba las lecciones.** Con una lección mal a
  375 px, la sonda salía con 1, pero la línea del capítulo decía ✓. Ahora dice ✗.

**Verificación.**
- **Prueba negativa:** la sonda nueva, en modo `375` sobre el capítulo 5 de
  `main`, falla en las nueve lecciones («el botón del menú tapa «LECCIÓN 1 DE 9 ·
  11 %», «Anterior»»).
- **Barrido de anchos** (320, 360, 375, 414, 640, 768, 900, 1000, 1023, 1024 y
  1280 px; desde 1024, también con la barra cerrada a mano), en los capítulos 1
  y 5: nada tapado. Antes fallaban de 320 a 900.
- **La sonda en sus cinco modos** y **`verificar.py --con-salidas`** pasan en los
  cinco capítulos.

### El recargo del 5 % del capítulo 4 queda como ilustrativo · 2026-11-03

**La decisión.** El docente deja el recargo como está, declarado ilustrativo: un
5 % sobre todo el saldo por un mes de mora equivale a un 79,6 % EA, por encima
de la usura, y se cobra sobre lo vencido.

**No hubo que tocar el capítulo.** La nota ya estaba desde el 2026-10-20
(`b63f1f7`), en la del bloque «El recargo que no se cobró» de la sección 2: «El
5 % sobre todo el saldo es ilustrativo: en Colombia, el cobro por mora está
topado por la tasa de usura y se liquida sobre lo vencido». Es el primer bloque
que usa el 5 %, y todas las apariciones del recargo están en esa sección. El
estado del 2026-11-02 de `REVISION_CAPITULOS_04_05.md` la daba por pendiente sin
haberla buscado; se corrigió.

**Verificación.** En Chrome, la nota se ve en la lección 3 de 8 con las cuatro
pestañas. La primera búsqueda no la encontró: buscaba «5 %» con un espacio
normal, y la cifra lleva el espacio duro de la regla 21 de `verificar.py`.

### El cuestionario del capítulo 5, revisado · 2026-11-09

**Por qué.** La revisión de contenido del 2026-10-19 no lo alcanzó, porque aún no
estaba escrito, y la auditoría del 2026-10-21 miró que funcionara y que sus cifras
fueran ciertas. Nadie había mirado si cada pregunta evalúa lo que dice. Las diez
claves estaban bien.

**Lo que se cambió, con el visto bueno del docente:**
- **Pregunta 7.** Pedía un saldo insoluto, no evaluaba ningún ciclo y su clave
  repetía casi literal la sección 7. Ahora pregunta qué pasa si se intercambian
  los topes de los dos ciclos de esa sección: coinciden en 4 141 315,47, y eso es
  lo que debía con 6 cuotas pagadas.
- **Opciones de las preguntas 1, 2, 5, 6, 8 y 10.** Cada una traía su razón, así
  que se elegía la explicación que sonaba bien, sin trazar. Pasaba en 31 de 40
  opciones; en los capítulos 1 a 4, entre 5 de 26 y 17 de 36. Ahora dicen solo el
  resultado, y las justificaciones refutan cada distractor.
- **Pregunta 5.** Las cuatro opciones decían 10 en la segunda cifra. «10 y 10»
  pasó a «5 y 11», el error de creer que el ciclo de dentro da al menos una vuelta.
- **Pregunta 10.** Se resolvía por eliminación. El 170 pasó a 21, y el enunciado
  da el ancho inicial.
- **Pregunta 2.** `range(n)` con un solo número no se enseñaba. Lo dice ahora la
  sección 4, sin dar la consecuencia, que es lo que se pregunta.
- **Pregunta 4.** Se acertaba mirando dónde estaba la condición, sin leerla. Una
  opción pasó a `Do … Loop Until saldo > 0`.
- **Pregunta 9.** La justificación decía que el `Para` termina siempre, contra la
  tabla de la sección 4. Ahora dice «siempre que el cuerpo no toque el contador».
- **Pregunta 8.** El enunciado pide el resultado «redondeado al peso», porque la
  opción ya no lo explica.

Las claves no se movieron: b d a bd c a d b cd a.

**Se queda:** el E6, justo encima del cuestionario, muestra que el `<> 0` no se
detiene, y eso ayuda con una opción de la 9.

**Verificación.**
- Las cifras nuevas se ejecutaron en Python y en R.
- En Chrome: 10/10 con las claves y las diez justificaciones visibles; 5/10 con
  las preguntas 5, 7 y 10 malas y la 4 y la 9 incompletas; 9/10 eligiendo en la 4
  la opción nueva.
- `verificar.py --con-salidas` pasa en los cinco capítulos, y la sonda, en sus
  cinco modos, en el capítulo 5.

**Huecos de las herramientas.**
- **`verificar.py`** no ve una opción que trae su razón, ni que las cuatro
  opciones compartan una cifra. Las reglas 17 y 18 no miran eso.
- **La sonda** espera 30 segundos a que el capítulo monte. Con cinco Chrome a la
  vez dio «no montó» en todos los modos; de uno en uno, los cinco pasan.

### Mejora de contenido · capítulo 1, fases 1 y 2 · 2026-11-10

Plan: `PLAN_TAREA11_CAPITULO_01_CONTENIDO.md` (aprobado el 2026-11-10). Rama
`claude/cap01-fase2-operadores`, sin fusionar.

**Fase 1 — leer lo que falta.** Siete fuentes ya registradas pasaron a «leída» y
entraron seis nuevas a Zotero (tanda 02): la especificación del lenguaje VBA
(MS-VBAL), *Dive into Systems*, la página de cifras de Swift, la Ley 1266 de 2008
y las ayudas de `Hex` y de `as.hexmode`. Las 30 afirmaciones pendientes del
capítulo quedaron con decisión escrita en el vault. Sin acceso: Goldberg 1991,
IEEE 754 y el informe de Von Neumann.

**Fase 2 — sección 3, Operadores.**
- Las tablas de aritméticos, relacionales y lógicos van en los cuatro lenguajes.
- La tabla de precedencia es la del pseudocódigo, y una segunda tabla dice dónde
  se apartan R y VBA: dos potencias seguidas (VBA agrupa por la izquierda) y el
  residuo y la división entera (antes que `*` y `/` en R, después en VBA).
  `2 * 7 MOD 4 * 3` da 6 en Python, 18 en R y 2 en VBA.
- El cortocircuito se dice por lenguaje, con cita: en R es de `&&` y `||`; en
  VBA lo respalda la especificación, no la ayuda de `And`.
- Siete pares clave–localizador nuevos en `afirmaciones/01.yaml` (13 en total).
- Dos verificadores sin contexto leyeron 16 parejas frase–pasaje: 13 respaldadas
  a la primera y tres corregidas hasta quedar respaldadas.

**Huecos de las herramientas.**
- **`registrar_afirmaciones.py`** solo admitía notas en `estado: verificada`. El
  esquema del vault sigue con `resuelta` cuando el HTML ya quedó bien, y al
  marcar así las seis notas del piloto el registro salía vacío («ninguna nota
  citada y verificada»). Ahora admite `verificada` y `resuelta`. Prueba: con las
  seis notas en `resuelta`, `--dry-run` daba 0 filas antes del cambio y 6 después.
- **La regla de cotejo** exige que las salidas del pseudocódigo sean las de
  Python. Obligó a cambiar dos ejemplos de la tabla de aritméticos (`60000` frente
  a `60000.0`): la regla hizo su trabajo, pero el README no la menciona junto a
  la convención de salidas.
- **VBA.** Los tres bloques nuevos declaran 13 salidas de VBA que no se han
  ejecutado en Excel: `ejecutar_vba.py preparar` deja el módulo en el
  portapapeles y falta pegarlo y correr `comparar`.
- **`generar_tanda.py`** (vault) no añade pasajes a una nota que ya existe.
- **Nombre repetido.** Este plan llama «Tarea 11» al capítulo 6, y el plan de
  contenido del capítulo 1 también se llama «Tarea 11».
- El capítulo 3 dice que el orden de los operadores «es el mismo en los cuatro
  lenguajes del curso» (`03…:3427`): ya no es cierto. Se corrige en la fase 8.

### Mejora de contenido · capítulo 1, fase 3 · 2026-11-10

Rama `claude/cap01-fase3-seccion4`, sobre la de la fase 2; sin fusionar.

**Sección 4, lo que el piloto dejó fuera.**
- «El problema tampoco es el tamaño del error» pasó a decir lo que dice su
  fuente: el error es diminuto, impide confiar en la igualdad y puede acumularse.
  Con eso deja de contradecir el caso del descuadre.
- «La solución de la banca» pasó a ser una recomendación del curso, en la tabla
  y en la justificación del cuestionario final.
- «Los enteros no tienen este problema» pasó a citar lo que dice la R FAQ.
- El laboratorio de bits: la leyenda lleva los colores de los bits que nombra,
  el rótulo dice «(20 decimales)» y tiene pie con su procedencia.
- La sección tiene minicuestionario (cuatro preguntas).
- La apertura dice que el descuadre lo produjeron la representación **y el
  momento en que se redondea**, como su ejercicio final. La portada se alinea
  en la fase 6.
- Dos pares frase–pasaje leídos por dos verificadores; uno objetó la frase de
  los enteros y quedó su corrección. 15 filas en `afirmaciones/01.yaml`.

**Huecos de las herramientas.**
- **La regla 9 no ejecuta las `lineas` de un `DetectaError`.** La explicación de
  «La conciliación que siempre reporta descuadre» da `1.0000000000000007`; se
  comprobó a mano en Python y en R, y ninguna regla lo vigila.
- **Los guiones de sustitución tropiezan con el espacio duro** que pone
  `comprobar_cifras.js`: un patrón escrito con espacio normal no casa con
  «$8 432». No es un defecto del corrector, pero conviene saberlo al editar por
  guion.
- Los rótulos «signo (1) · exponente (11) · mantisa (52)» del laboratorio siguen
  sin fuente leída (decisión D).

### Mejora de contenido · capítulo 1, fase 4 · 2026-11-10

Rama `claude/cap01-fase4-seccion1`, sobre la de la fase 3; sin fusionar.

**Sección 1, Sistemas de numeración.**
- El caso `0x0A` queda bien planteado (un byte, ocho banderas) y resuelto en la
  sección: `0000 1010`, bits 1 y 3. Un ejercicio E7 lo hace practicar con `0x05`.
  La pasarela, el manual y las banderas se declaran ilustrativos.
- Las cifras de Swift se actualizaron (más de 12 500 instituciones, más de
  53 millones de mensajes FIN al día), con cita y fecha de consulta. Salió
  «Esto es exactamente lo que hace SWIFT».
- Salieron «diez dedos», «5V/0V», «ubicuo» y el código de color; entraron las
  citas del libro de arquitectura y de la documentación de `bin()`, `Hex()` y
  `as.hexmode()`.
- Nueve parejas frase–pasaje leídas por dos verificadores, que coincidieron en
  cinco «parcial»; se corrigieron y pasaron una segunda lectura. 21 filas en
  `afirmaciones/01.yaml`.

**Huecos de las herramientas.**
- **La etiqueta del tipo de ejercicio tapa el enunciado** cuando este ocupa dos
  renglones (`Ejercicio` sobre un `MCQ`). Pasa en el E2 que ya existía y en el
  E7 nuevo. Es de LP-CORE: arreglarlo obliga a reestampar los cinco capítulos.
- **La cuota** avisa «E7: hay 3, la cuota sugiere máximo 2» en el capítulo 1.
  El ejercicio nuevo es de interpretación; queda a decisión del docente dejarlo
  como E7, cambiarle el tipo o subir el tope.
- La primera cita elegida para «dos estados» no servía (hablaba solo de los
  dispositivos de almacenamiento): la lectura independiente lo vio; quien
  escribió, no.

### Mejora de contenido · capítulo 1, fase 5 · 2026-11-10

Rama `claude/cap01-fase5-seccion2`, sobre la de la fase 4; sin fusionar.

**Sección 2, Estructura del computador.**
- La historia, los componentes, el ciclo de instrucción y la memoria citan el
  libro de arquitectura (*Dive into Systems*). Salieron «por los mismos buses»,
  «exactamente lo que propuso Von Neumann», ROM/BIOS/UEFI, la arquitectura
  Harvard, `MOV AL, 61h`, «memory-bound», «swap» y el programa que «se modifica
  a sí mismo».
- El diagrama se rehízo: la caché dentro de la CPU, el almacenamiento aparte,
  el bus de doble sentido, rótulos en español y colores de la paleta.
- Tabla nueva de latencias (registro, caché, memoria, disco, red), citada.
- El E4 conserva su código y cambia su explicación; el caso del reporte de
  cuarenta minutos se cierra con una cuenta a la vista (240 000 × 0,01 s).
- 24 parejas frase–pasaje leídas por dos verificadores; ocho corregidas y
  vueltas a leer. 29 filas en `afirmaciones/01.yaml`.

**Huecos de las herramientas.**
- **`registrar_afirmaciones.py`** falla, con razón, si una nota `citada` no
  trae ancla. Pero el esquema no dice qué clase lleva una frase que repite algo
  ya citado desde un sitio donde no cabe un `<Cita>` (la justificación de una
  pregunta, que es una cadena). Se resolvió dándole a la nota el mismo par y un
  ancla dentro de la cadena.
- **La regla 31 sí mira los `<Fuente k=… loc=…>`**, además de los `<Cita>`. El
  README no lo dice.
- Quedan dos afirmaciones nuevas sin fuente, encontradas en esta fase: que un
  Excel con macros llega bloqueado (reto E8) y que la RAM pierde su contenido al
  apagar (cuestionario final). Van a la fase 6.

### Mejora de contenido · capítulo 1, fase 6 · 2026-11-10

Rama `claude/cap01-fase6-portada-cierre`, sobre la de la fase 5; sin fusionar.

**Portada, cierre y evaluación.**
- La portada cuenta el descuadre como su ejercicio final, y su ficha tiene el
  formato de los capítulos 2 a 5 (falta la fila «Evaluación asociada»: no se
  conoce el nombre del cuestionario de Moodle).
- «Lo que viene» nombra el capítulo 2. El glosario pasó a tabla, con 19
  términos puestos al día.
- Todo el capítulo trata de usted, y lo interno se llama «sección».
- El cuestionario final tiene 10 preguntas, y cada justificación dice por qué
  fallan las otras opciones. Salió la pregunta de la memoria volátil, que no
  tenía fuente.
- Ejercicios heredados: las seis preguntas sueltas pasaron a los
  minicuestionarios de sus secciones; el reto de conversión de la sección 1 se
  retiró; el de la TIR quedó como exposición; la solución de la tabla de la
  evaluación va en un acordeón. El capítulo queda con 13 ejercicios con tipo y
  ninguno sin él, y la cuota sin avisos.
- «Recursos complementarios» pasó a «Para practicar», sin la referencia que
  estaba tecleada de memoria. Los siete enlaces responden (uno, con 403 a la
  consulta automática).

**Huecos de las herramientas.**
- **`Quiz` no admite retroalimentación por opción**, solo por pregunta; `MCQ`
  sí. En los cuestionarios la retroalimentación de los distractores va dentro
  de la justificación de la pregunta.
- **«Para profundizar» no se puede generar todavía**: `estampar_referencias.py`
  solo estampa lo citado, y no hay componente para una lista de lecturas
  recomendadas. Hacerlo toca LP-CORE; va con la fase 7.
- **Un corte por sangría falló**: al reemplazar un bloque «hasta el primer
  `</div>` con dieciséis espacios», el patrón casó con uno más sangrado y dejó
  el JSX roto. La regla 1 lo vio al instante. Conviene cortar por líneas
  completas, no por subcadenas.

### Mejora de contenido · capítulo 1, fases 7 y 8 · 2026-11-10

Ramas `claude/cap01-fase7-figuras`, `claude/cap01-fase7-lpcore` y
`claude/cap01-fase8-coherencia`, una sobre otra; sin fusionar.

**Fase 7 — figuras y LP-CORE.**
- Las seis figuras del capítulo 1 llevan fuente, usan solo la paleta y se
  vieron a 375 px. «Una cantidad, cuatro bases» muestra el 22 en las cuatro; la
  gráfica de interés sombrea la franja entre las curvas y usa punto de miles.
- LP-CORE, hecho por la subsesión de citas y revisado aquí: la etiqueta del
  tipo de ejercicio ya no se cruza con el enunciado (17 de 33 en escritorio y
  31 de 33 a 375 px, antes), y existe `<ParaProfundizar k="…" />`, estampado
  desde Zotero. Los cinco capítulos se reestamparon.

**Fase 8 — coherencia hacia adelante.**
- Se revisaron las 17 menciones del capítulo 1 en los capítulos 2 a 5.
- Capítulo 3: ya no dice que el orden de los operadores es el mismo en los
  cuatro lenguajes ni que la potencia en VBA es la única discrepancia.
- Capítulo 2: ya no remite a una medición del capítulo 1 que no existe.
- Capítulos 4 y 5: lo que dicen del 1 es cierto ahora, sin tocarlos.
- Se entregó al docente la lista de preguntas del banco de evaluación del
  capítulo 1 que el cambio deja desfasadas (el banco no se tocó).

**Huecos de las herramientas.**
- **Nada vigilaba el solape de la etiqueta.** Estaba en los cinco capítulos
  con todas las reglas y la sonda en verde. Falta un modo de solapes en la
  sonda.
- **Nada vigila lo que un capítulo dice de otro.** Las frases del capítulo 3
  eran falsas desde antes y solo se vieron al leer. El vault lleva esas
  remisiones a mano, en sus notas de hilo.
- **La APA no imprime el ISBN de un libro**: en «Para profundizar», Joyanes y
  Cairó salen sin identificador a la vista.
- `POLITICA_DE_FUENTES.md` y la skill `lpf-capitulo` no nombran «Para
  profundizar». Va al cierre.

### Mejora de contenido · capítulo 1, fase 9 (cierre) · 2026-11-10

Rama `claude/cap01-fase9-cierre`, sobre la de la fase 8; sin fusionar. Queda lo
que es del docente: leer el capítulo completo, verlo en Safari y en un
teléfono, y decidir la fusión en `main`.

**Lo que se comprobó al cierre.**
- `verificar.py --con-salidas --con-pandoc`: los cinco capítulos pasan; el 01
  en «OK», sin avisos.
- Sonda del navegador: 25 de 25 (cinco modos, cinco capítulos, de a uno).
- Lectura independiente de las 51 citas del capítulo, sobre el texto final y
  extraídas por guion del propio HTML. Primera pasada, dos verificadores: 38 y
  46 respaldadas, ninguna sin respaldo. De las 13 objeciones, 8 eran al pasaje
  copiado en la nota —resumido de más— y 5 a la frase. Se ampliaron los
  pasajes, cotejados contra la fuente descargada, y se corrigieron las frases.
  Segunda pasada: 46 respaldadas y 5 observaciones; dos se corrigieron y tres
  son la misma frase con tres citas seguidas, una por lenguaje, que se dejó así.
- Vault: 51 afirmaciones, todas resueltas o verificadas; 7 hilos cerrados; 13
  de 14 conceptos coherentes. Queda abierto el índice de los arreglos en
  pseudocódigo, que es del capítulo 7.

**Criterios de aceptación del plan.** Se cumplen los ocho, con dos salvedades:
el concepto que queda abierto, y que la última redacción de siete frases es la
corrección que propuso un verificador y no se volvió a someter.

**Lo que deja el capítulo para los siguientes.**
- En la primera lectura de cada sección, una de cada tres frases decía más que
  su pasaje (17 de 51). El método está en la skill `lpf-capitulo`, sección
  «Las fuentes».
- La política de fuentes nombra «Para profundizar», la cita por fuente cuando
  una frase habla de varias, y la fecha de consulta para un dato sin fecha.

**Huecos de las herramientas.**
- **El pasaje de la nota tiene que bastarse solo.** Un extracto recortado con
  «[…]» puede dejar fuera justo la línea que respalda la frase; el verificador
  lo ve como «parcial» y tiene razón. El registro público guarda la huella del
  extracto, no si alcanza.
- **No hay guion que arme las parejas frase–pasaje.** Se hizo uno de usar y
  tirar; convendría llevarlo a `_plantilla/`, porque la lectura final de un
  capítulo lo necesita.
- **Las salidas de VBA de la fase 2 siguen sin ejecutarse en Excel** (13 líneas
  en tres bloques): falta pegar el módulo de `ejecutar_vba.py preparar`.
- El README raíz decía «02–08 en preparación» y «once comprobaciones»; se
  corrigió. `comprobar_cifras.js` se llamaba «Comprobación 20» y es la 21.

### Auditoría del capítulo 1 después de la fusión · 2026-11-14

La fusión de las nueve fases quedó en `main` (`a4aa899`). Después se auditó el
capítulo completo, en la rama `claude/cap01-auditoria`.

**Qué se comprobó.**
- `verificar.py --con-salidas --con-pandoc`: los cinco capítulos pasan; el 1,
  sin avisos. Sonda de navegador del capítulo 1, en escritorio y a 375 px.
- Los pasajes del vault, cotejados contra las fuentes vueltas a descargar: 89
  fragmentos literales y tres notas con transcripción no literal, que se
  corrigieron. Una había enmendado sin decirlo una errata de la fuente.
- Una lectura crítica del capítulo entero por un lector sin contexto, que
  ejecutó las cuentas en Python y en R: 3 hallazgos altos, 21 medios y 26 bajos.

**Qué se corrigió (29 frases).** El ejemplo de los tres tipos de operador
contaba dos relacionales y son tres. «Reconstruya el ciclo» pedía «un orden que
funcione» y solo acepta uno: ahora lo dice. El reto del descuadre daba por
descartada una hipótesis que la división no descarta, y llamaba «de
representación» a un desvío de centavos, contra lo que enseña el cuestionario
de la misma sección. La tolerancia se recomendaba para conciliar un saldo en
dos sitios y se prohibía en otros dos. El comparador recorría en Python una
lista de doce con índices de 1 a 12. Y varias frases que hablaban de «los
lenguajes» con sintaxis de uno solo.

**Qué queda para el docente.**
- **La cifra del descuadre no sale del mecanismo que se le atribuye.** 840 000
  pagos redondeados al centavo se desvían a lo sumo 4 200 pesos; truncados,
  menos de 8 400. El caso se declaró inventado, pero la cifra o el mecanismo
  hay que cambiarlos.
- El laboratorio de bits rotula «mantisa (52)» y los puntos clave dicen «53
  bits de precisión»; explicar el bit implícito pide leer IEEE 754.
- Afirmaciones sin clase que son de criterio o de ambiente (la entrevista
  técnica, «la línea más famosa», los compiladores en la solución de E8) y el
  `round(2.675, 2)` del cuestionario final, que es cierto y no está ni citado
  ni en un bloque ejecutado.
- El comparador mezcla en pseudocódigo y VBA `memoria[0]` con `cuota[1..12]`:
  depende de la decisión D09 sobre el índice de los arreglos.

**Huecos de las herramientas.**
- **Ninguna regla lee el capítulo como lo lee un estudiante.** El verificador
  estaba en verde con tres errores altos dentro. La lectura crítica sin
  contexto debería ser un paso fijo del cierre de cada capítulo, antes de la
  fusión y no después.
- **`OrdenaPasos` solo acepta un orden**, aunque haya varios válidos. O el
  enunciado fija el orden, o el componente aprende dependencias.
- **El contador «Lección N de M»** de LP-CORE cuenta la portada: la sección 1
  aparece como «Lección 2 de 6».
- **El cotejo de pasajes contra la fuente** se hizo con un guion de usar y
  tirar; es el mismo hueco del guion de parejas frase–pasaje.

### El descuadre del capítulo 1 pasa a $4 187 · 2026-11-14

La auditoría dejó dicho que $8 432 sobre 840 000 pagos no podía salir de
redondear al centavo. El docente aprobó cambiar la cifra y el mecanismo: el
sistema **recorta** los decimales de cada pago en vez de redondear, lo que
pierde en promedio medio centavo por pago, y 840 000 × 0,005 = 4 200. El
descuadre queda en $4 187 y la cuenta está a la vista en la solución del reto.
Cambian la portada, la apertura de la sección 4 y el reto; ningún otro capítulo
nombraba la cifra. `PLAN_TAREA11_CAPITULO_01_CONTENIDO.md` conserva la vieja
como registro de lo que se planeó.

### Cierre de los pendientes del capítulo 1 · 2026-11-14

Rama `claude/cap01-pendientes`. Lo que la auditoría había dejado para decidir.

**Cerrado.**
- **La causa del descuadre.** La portada y la apertura de la sección 4 culpaban
  también a la representación de los decimales. Ahora nombran solo el recorte, y
  la representación queda como lo que la sección enseña después.
- **«Mantisa (52)» frente a «53 bits».** Un párrafo tras el laboratorio explica
  el reparto con tres citas de Goldberg (1991), leído en la reimpresión abierta
  que aloja Oracle: 64 bits, 11 de exponente y 53 de precisión; un bit de signo;
  y el bit oculto. La cuenta 64 − 1 − 11 = 52 va a la vista. Goldberg pasa de
  «Para profundizar» a «Referencias».
- **Afirmaciones sin clase.** La entrevista técnica se presenta como escena; «la
  línea más famosa» y «casi siempre por una de tres razones» se quitaron; los
  compiladores de E8 son ahora un ejemplo y no una historia; `round(2.675, 2)`
  salió de la justificación; los once créditos quedaron declarados inventados.
- **Menores.** Dos distractores que se delataban solos, una pregunta del
  cuestionario final que repetía la tabla de encima, «opcode», el glosario sin
  «Máscara de bits» (el capítulo no usa el término) y el título de E5.

**Sigue abierto.**
- El comparador de la sección 2 mezcla `memoria[0]` con `cuota[1..12]` en
  pseudocódigo y VBA: es la decisión D09, del capítulo 7.
- Las 13 salidas de VBA sin ejecutar en Excel, las tres preguntas desfasadas del
  banco Moodle y la revisión en Safari y teléfono: son del docente.
- La figura de Von Neumann cita solo §5.2 y dibuja también la caché, que el
  texto cita en §11.

**Huecos de las herramientas.**
- **El verificador de citas volvió a tener razón a la primera.** La frase del
  bit oculto decía del formato doble lo que el artículo solo dice en general.
  Confirma que la lectura sin contexto va antes de registrar la nota, no después.
- **El texto extraído de la fuente perdió la letra β.** El cotejo mecánico de
  pasajes no ve los caracteres que la extracción se come.
- **`estampar_referencias.py 01` no encuentra el capítulo**; hay que pasarle la
  ruta del archivo. `registrar_afirmaciones.py` sí acepta el número.

### Lo que seguía abierto del capítulo 1 · 2026-11-14

Rama `claude/cap01-comparador`.

- **Comparador de la sección 2.** El enunciado dice ahora que cada lenguaje
  numera las posiciones a su modo y que eso se explica más adelante. Con eso el
  capítulo 1 deja de depender de la decisión D09, que sigue abierta para el
  capítulo 7.
- **Banco Moodle.** Las tres preguntas desfasadas tienen borrador corregido y
  compilado con R/exams (tres variantes cada una). Los borradores están en el
  vault; el banco, que es un repositorio aparte, no se tocó.
- **No se pudo desde esta sesión.** Ejecutar el VBA en Excel (el docente no dio
  acceso a la aplicación), ver el capítulo en Safari de iPhone (el simulador
  pide Xcode completo) y leer a Goldberg en el original de ACM (la página pone
  una verificación de navegador que no se salta).

**Hueco de las herramientas.** La sonda de navegador solo corre en Chrome. En
el equipo hay un WebKit de Playwright, pero no el paquete que lo maneja: con él,
la sonda podría tener un modo «webkit» que haga de Safari.

### Las salidas de VBA del capítulo 1, ejecutadas en Excel · 2026-11-14

`ejecutar_vba.py comparar` corrió en Excel para Mac los nueve bloques de VBA del
capítulo 1 que declaran salida (arnés `1b7a15d46a`, 20 líneas): **todas
coinciden**. En dos bloques, `OPERADORES_ARITMETICOS` y `VPN_PROYECTO`, la única
diferencia es el separador regional: este Excel escribe coma decimal y el
capítulo declara punto, como ya advierte el guion. Queda cerrado el pendiente de
las 13 salidas de la fase 2.

**Hueco de las herramientas.** El editor de Visual Basic no acepta texto ni
pegado desde una sesión que trabaja en segundo plano: el pegado del módulo
necesitó control de pantalla, aprobado por el docente. Sigue siendo el único
paso manual de la comprobación.

### Capítulo 2, fase 1: línea base y fuentes · 2026-11-14

El docente aprobó `PLAN_TAREA12_CAPITULO_02_CONTENIDO.md` con las ocho
recomendaciones (A–H). La fase 1 no toca el capítulo: deja la línea base en el vault
y las fuentes leídas.

**Línea base** (sobre `c82fc71`). Un lector sin contexto inventarió 90 afirmaciones
y 26 figuras y tablas; un guion comprobó que el ancla de cada una aparece una sola
vez en el archivo. Por clase: 33 piden cita, 19 son ejecutadas, 17 de criterio, 10
ilustrativas, 8 derivadas y 3 son remisiones a otros capítulos. 68 de las 90 no se
presentan hoy como lo que son. De las 33 que piden cita, 9 tienen fuente leída, 7
esperan un libro impreso del syllabus y 17 no tienen ninguna: se reescriben como
criterio, se demuestran ejecutando o se quitan.

**Fuentes leídas.**

- *Símbolos del flujograma (decisión C).* La norma ANSI X3.5-1970 está reproducida
  entera en FIPS PUB 24 del National Bureau of Standards, abierta en el NIST. Se
  leyó sobre las páginas escaneadas. Contradice al capítulo en dos puntos: la
  decisión «determina cuál de varios caminos alternativos se sigue» y la norma
  dibuja rombos con tres salidas y más, así que «exactamente dos salidas» es
  convención del curso; y no son «unos pocos símbolos» sino 28, de los que el curso
  usa seis. Respalda que entrada y salida compartan símbolo. No nombra las formas:
  las dibuja. Su vigencia no se verificó.
- *Norma de transparencia (decisión D).* Ley 1748 de 2014, leída completa en el
  Gestor Normativo de Función Pública. Obliga a informar el Valor Total Unificado,
  que incluye intereses, seguros, gastos y comisiones, y a diferenciar dentro de él
  el componente de la tasa de interés. No dice que la cuota deba desglosarse.
- *Cinco propiedades (decisión B).* No se encontró ninguna fuente abierta que la
  política admita: lo que aparece son apuntes de clase, blogs y Wikilibros. Queda a
  la espera del pasaje de un libro impreso del syllabus.

La tanda 03 de Zotero (las dos fuentes) está preparada en el vault y **no se ha
importado**: espera la aprobación del docente.

**Huecos de las herramientas.**

- La política de fuentes no tiene clase para una remisión a otro capítulo («el
  capítulo 3 toma…»). Las tres del capítulo 2 quedaron sin clasificar; se comprueban
  a mano contra el otro capítulo en la fase 9.
- El esquema del vault numeraba la evaluación como `s5`, que en un capítulo de cinco
  secciones choca con la quinta. Se corrigió: la evaluación es la sección siguiente
  a la última (`s6` en el capítulo 2). También se añadió `tabla` a las clases de
  figura.
- La lectura automática de páginas falló en las dos fuentes: el PDF del NIST es un
  escaneo que hubo que extraer con `pdftotext` y mirar página por página, y los
  sitios `.gov.co` dan error de certificado fuera del navegador.
- El inventario sale de un lector, no de una regla: nada garantiza que no se le haya
  escapado una afirmación. La lectura crítica de la fase 10 es la segunda red.

**Importación de la tanda 03 (aprobada por el docente el 2026-11-14).** Las dos
referencias están en Zotero y en `referencias.json` (`nbs1973`,
`congreso2014ley1748`). Hubo un error: entraron primero en «3 Fuentes primarias»
de Teoría del Riesgo, porque hay seis colecciones con ese nombre y la comprobación
previa miró el nombre y no el curso. Se movieron a la de LPF desde la ventana de
Zotero, sin borrar nada, y la API confirma que la colección de Teoría del Riesgo
quedó como estaba. Regla nueva para las tandas siguientes: comprobar el id de la
colección seleccionada y su colección madre, no solo el nombre. Además, Zotero
guardó la fecha de consulta en UTC y las dos dicen 2026-11-15; la lectura fue el
14. Sin corregir.

### Capítulo 2, fase 2: la sección 2 dice lo que calcula · 2026-11-14

Rama `claude/cap02-fase2`. Decisiones A y D del plan.

- **El caso (A).** Se conserva la cuenta y se dice lo que es: «interés simple del
  1,8 % mensual sobre el capital prestado», repartido en 24 cuotas iguales. Se
  pide «la cuota mensual»; «cuota fija» desaparece de la sección. Un
  `<Ilustrativo>` declara que el crédito, sus cifras y su regla de liquidación
  son inventados. El capítulo no afirma nada sobre cómo se liquida un crédito
  real. Las salidas no cambian (5 184 000, 345 600, 730 400).
- **La norma (D).** «La norma de transparencia» pasa a ser la Ley 1748 de 2014,
  art. 1.º, citada: primera cita del capítulo, con su lista «Referencias» y su
  registro `afirmaciones/02.yaml`. El verificador independiente calificó la
  primera redacción de *parcial* (omitía «siempre que la naturaleza del producto
  lo permita» y cambiaba «Valor Total Unificado» por «valor total»); se
  reescribió y **la redacción final se volvió a someter: respalda**. La frase «el
  cliente tiene derecho a saber por qué paga lo que paga» se quitó.
- **La constante.** La nota del bloque dice que el pseudocódigo y VBA tienen
  palabra para declararla y que en Python y R es una variable como las demás
  (ejecutado: los dos reasignan sin error). Promete que la sección 4 vuelve sobre
  ello: queda como obligación de la fase 6.
- **La traza** lleva `exigeRespuesta` (en blanco ya no aprueba) y pide la raya
  «donde el algoritmo todavía no le haya asignado nada», que vale también en VBA.
- **Ordenar pasos.** El enunciado ya no dice que una variable no puede usarse sin
  valor, y la lista de VBA lee las tres entradas. Sigue aceptando un solo orden
  habiendo varios válidos: es del componente y va en la fase 8.
- La motivación ya no da «media hora ahorra dos días» como regla.

Sin tocar en esta fase: la mención del syllabus (fase 7, con la portada) y la
clave de la evaluación que suma el seguro al «uso del dinero» (fase 7).

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco capítulos;
sonda de navegador del capítulo 2 en verde, en escritorio y a 375 px (7 de 7
lecciones, 0 errores de JS).

**Hueco de las herramientas, cerrado.** `sonda_navegador.mjs file 02` respondía
«no montó», que parece un fallo del capítulo, cuando «02» no es un archivo: Chrome
cargaba una página de error. Ahora la sonda comprueba que cada ruta exista y, si
no, lo dice y sale con 2. Costó varias pruebas descubrirlo.

### Capítulo 2, fase 3: la sección 5 cuenta vueltas y las llama vueltas · 2026-11-14

Rama `claude/cap02-fase3`. Decisión E del plan.

- **El conteo.** El contador de los cuatro bloques se llama `vueltas` y la salida
  dice «39814 vueltas» y «12 vueltas». Un párrafo nuevo explica por qué no se
  habla de comparaciones (A compara una vez por vuelta con el dato buscado; B,
  hasta dos) y que el conteo depende del crédito: A da tantas vueltas como su
  posición; B, a lo sumo 16 en esta cartera. Ejecutado para los 40 000 créditos:
  máximo 16, mínimo 1.
- **La contradicción.** Desaparece «depende solo del algoritmo». La sección dice
  que el número de vueltas no cambia con la máquina y sí con el algoritmo y con
  el dato.
- **El caso.** La anécdota ya no trae «ocho minutos» ni «cuarenta», que no
  cuadraban con las cifras del propio capítulo, ni afirma que el servidor no
  hacía falta. Un `<Ilustrativo>` declara inventados la cartera, el cierre y las
  5 000 búsquedas; los conteos se declaran ejecutados.
- **Por qué B no siempre sirve.** «Solo es correcto si la cartera está ordenada»,
  con un caso que se sigue a mano: en la lista 5, 1, 4, 2, 3 busca el 5 y no lo
  halla (ejecutado).
- **El ejercicio de interpretación.** «Suponga que el cierre diario hace 5 000
  búsquedas como esa»; 199 070 000 frente a 60 000, «unas 3 318 veces menos». El
  distractor que afirmaba algo cierto —que los computadores hacen millones de
  operaciones por segundo— se cambió por uno falso por lo que la sección enseña.
- **Opiniones como opiniones.** «En este curso la corrección va primero»;
  «conviene mirar el código antes de pedir más máquina».
- Para que el mismo conteo tenga el mismo nombre en todo el capítulo se tocaron
  también la portada («39 814 vueltas; la segunda, doce»; el gancho ya no dice
  «tarda mil veces más»), la pregunta del crédito 2 500 del cuestionario y la
  entrada «Eficiencia» del glosario.

**Para la fase 9.** El capítulo 5 dice tres veces que el 2 encontró el crédito
«en 12 comparaciones» (líneas 3081, 4221 y 7550-7551). Son vueltas.

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos; sonda del capítulo 2 en verde, en escritorio y a 375 px.

### Capítulo 2, fase 5: la sección 3 cita la norma y separa lo que es del curso · 2026-11-14

Rama `claude/cap02-fase5`. Decisión C del plan. Se adelantó a la fase 4, con
permiso del docente, porque la 4 espera el pasaje de un libro impreso.

- **La norma.** «El estándar ANSI fija unos pocos símbolos» pasa a decir lo que la
  norma ANSI X3.5 de 1970 dice: un símbolo básico para cada una de cuatro
  funciones y símbolos especializados (§3.1). Debajo del widget, una lista cita
  la norma símbolo por símbolo —entrada y salida (§3.2.1), decisión (§3.3.2.1 y
  §4.10.1), terminal (§3.4.2), conector (§3.4.1) y línea de flujo (§4.4.1)— y
  dice en cada uno qué añade el curso.
- **Convención del curso, y dicho así:** las dos salidas de la decisión, el único
  Inicio y el único Fin, y la punta de flecha en todas las líneas. La norma
  habla de «varios caminos alternativos». La pregunta del cuestionario que daba
  por incorrecta esa lectura dice ahora «según la convención de este curso».
- **El widget** lleva `<Fuente>`: «formas adaptadas de» la norma. Un lector
  independiente comparó los seis dibujos con las páginas escaneadas: son
  reconocibles, pero tres están aplanadas respecto a la proporción 1:2/3 que la
  norma pide mantener y la punta de flecha es rellena donde la norma la dibuja
  abierta. Por eso «adaptadas» y no «conformes». Queda para la fase 8 decidir si
  se redibujan.
- **Verificador independiente.** Siete frases contra sus pasajes: seis respaldan
  y una, la de las puntas de flecha, salió *parcial* (sobraba «solo»: con flujo
  bidireccional también son obligatorias). Se adoptó la redacción que el mismo
  verificador dio por respaldada. Ocho filas nuevas en `afirmaciones/02.yaml`.
- **Frases sin respaldo, fuera o reescritas:** «El lenguaje que más se usa en el
  sector financiero es el que menos protege» (quitada); «es el símbolo más
  frecuente» (quitada); el pseudocódigo «es la única» representación sin
  ambigüedad (ahora, decisión del curso); los límites de la tabla de
  representaciones (criterio del curso, con `<Fuente propia>`); la escena del
  comité (supuesto).
- **El ejercicio de detectar el error** ya no adelanta la consecuencia en el
  enunciado. El microcrédito lleva `<Ilustrativo>`.

Lo que no se afirma: que la norma siga vigente. No se comprobó.

Sin tocar: la mención del RA1 (fase 7) y los defectos de las figuras (fase 8).

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos; sonda del capítulo 2 en verde, en escritorio y a 375 px.

**Hueco de las herramientas.** El verificador de citas lee texto; una `<Fuente>`
que atribuye un dibujo no se puede comprobar así. Aquí se resolvió con un lector
que abrió las páginas escaneadas y comparó forma por forma, pero nada en
`verificar.py` distingue una fila del registro respaldada por texto de una
respaldada por una imagen.

### Capítulo 2: lo que quedó abierto de la fase 5, y el hueco del respaldo por imagen · 2026-11-14

Rama `claude/cap02-abiertos`, sobre la fase 5.

**Lo abierto.**

- *Vigencia de la norma.* La lista oficial del NIST de publicaciones FIPS
  retiradas trae FIPS 24 como publicada el 30 de junio de 1973 y **retirada el
  23 de agosto de 1988**. De la norma ANSI misma no se halló aviso oficial de
  retiro. El capítulo la sigue citando con su año y sin decir que sea la
  vigente; el dato queda en la nota de la fuente.
- *El syllabus y el RA1.* Lo que el capítulo le atribuye se cotejó contra el
  documento: el RA1 dice «Construye un algoritmo computacional…», los entregables
  incluyen el «Formato Definición y Análisis» y la rúbrica trae «Dominio de
  algoritmos y procedimientos propios del pensamiento matemático». Como en el
  capítulo 1, el syllabus se nombra y no se cita: es un documento propio del
  curso y no está en Zotero. La ficha de la portada lleva su `fuente-ok`.
- *Las formas del widget.* Redibujadas con la proporción de la norma (1:2/3 para
  entrada/salida, proceso y decisión; 1:3/8 para el terminal) y con la punta de
  flecha abierta. El pie dice ahora «formas y proporciones de». La ficha de cada
  símbolo muestra el rótulo de ejemplo, que antes no se pintaba.

Sigue abierto: el flujograma del ejemplo (`BloqueFlujo`) no usa esas
proporciones porque sus cajas llevan texto largo —el pie del widget no se refiere
a él—; su texto de 12,5 px y el foco de teclado van en la fase 8. La fase 4
espera el pasaje del libro impreso.

**El hueco, cerrado.** El registro no distinguía una fila respaldada por un
pasaje de una respaldada por un dibujo, que el verificador de citas no puede
leer. Ahora:

- la nota del vault lleva `respaldo: imagen` y `cotejado_por` (quién miró la
  página); el esquema y la plantilla los traen;
- `registrar_afirmaciones.py` escribe `respaldo: "imagen"` en la fila y se niega
  a escribir el registro si falta `cotejado_por`; las filas de texto no cambian
  (`01.yaml` quedó idéntico);
- la regla 31 falla si un `<Cita>` —una frase— se apoya en una fila de imagen:
  eso solo sirve para la procedencia de una figura (`<Fuente>`).

Pruebas negativas, sobre copias: marcar como imagen la fila de una frase falla;
un valor distinto de `texto` o `imagen` falla; una nota de imagen sin
`cotejado_por` no se registra. README y cabecera de `verificar.py` al día.

**Hueco que sigue abierto, y es de política.** No hay clase para lo que el curso
dice de sus propios documentos: las remisiones a otros capítulos y las menciones
del syllabus. Están comprobadas y quedan `sin-clasificar` (nueve notas en el
capítulo 2). Decidirlo es del docente: una sexta clase, o tratarlas como
derivadas.

### Capítulo 2, fase 6: la sección 4 dice de cada lenguaje lo que ese lenguaje hace · 2026-11-14

Rama `claude/cap02-fase6`.

- **La constante.** Ya no se declara «para que el lenguaje avise»: se declara
  «para que quien lea el algoritmo lo sepa». Un párrafo nuevo —el que la sección
  2 prometía— dice que el pseudocódigo y VBA tienen palabra para declararla y que
  en Python y R el nombre en mayúsculas es un acuerdo entre personas: si se
  reasigna, ninguno protesta (ejecutado). No se afirma qué hace VBA ante el
  intento; se comprueba en Excel en la fase 9.
- **La tabla de tipos.** Fuera «la causa más común de descuadres de un peso». La
  fila Moneda cita la ayuda de VBA: entero con escala de 10 000, punto fijo con
  cuatro decimales (verificador: respalda). «Decimales exactos» pasó a «un
  número fijo de decimales». La fila Real reconoce que los bloques de Python y R
  del capítulo guardan así el dinero y redondean al mostrarlo. El ejemplo de los
  ceros a la izquierda ya no es la cédula —no consta que empiecen por cero— sino
  un código de oficina inventado, 0045, también en el cuestionario. La tabla lleva
  `<Fuente propia>`.
- **Asignar y comparar.** La nota del acumulador decía que `=` no significa «es
  igual a» en ninguno de los cuatro. En VBA y en el pseudocódigo el mismo `=`
  compara. Ahora dice que Python y R tienen `==` para preguntar y que en los otros
  dos lo distingue el lugar en la línea.
- **El reparto.** Las explicaciones prometían que declarar la variable como
  moneda arreglaba el error. No lo arregla: 100 000 no es divisible entre 3. Ahora
  dicen que con decimales la pérdida se achica y que el peso que no se puede
  partir necesita una regla escrita. En Python y R, sin `int` el total vuelve a
  dar 100 000 (ejecutado), pero queda una fracción de peso por cuenta.
- **La remisión al capítulo 1 estaba desfasada.** Decía que allí el descuadre
  venía «por el binario»; desde la auditoría del capítulo 1 viene del recorte de
  decimales en cada pago. Corregida.
- **Trazas.** Las dos llevan `exigeRespuesta` y piden la raya «donde el algoritmo
  todavía no le haya asignado nada», que vale también en VBA.
- **Opiniones como opiniones:** «la instrucción más común que existe», «el único
  sitio donde el valor sobrevive», «debe inicializarse».
- Un `<Ilustrativo>` declara inventadas las cifras de los ejercicios.

Sin tocar: las definiciones de variable y constante como «espacio de memoria con
nombre», que esperan con las de la sección 1 el pasaje del libro impreso.

Para la fase 9, en Excel: el redondeo de VBA al guardar en `Long`, el valor del
reparto con `Currency`, `Option Compare` y qué pasa al reasignar un `Const`.

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos; sonda del capítulo 2 en verde, en escritorio y a 375 px.

### Capítulo 2, fase 7: portada, evaluación y cierre · 2026-11-14

Rama `claude/cap02-fase7`.

- **La clave que sumaba el seguro al «uso del dinero»** (hallazgo alto de la
  línea base). La opción correcta dice ahora que el cliente devuelve 17 529 600,
  que son 5 529 600 más de lo recibido —el 46,1 % del capital—, y que de esa
  diferencia 5 184 000 son intereses y 345 600 son seguro. La justificación
  muestra la cuenta entera y ya no invoca «la norma de transparencia»: remite a
  la sección 2, donde está la cita.
- **La ficha de la portada**, cotejada celda por celda con el syllabus:
  contenido, 4 horas, cuestionario «Algoritmos» y naturaleza coinciden.
- **La rúbrica.** El criterio va con su nombre completo, y «más difícil» pasó a
  «que este curso considera más exigente».
- **Distractores sin hechos sin respaldo:** fuera «Python […] el más usado hoy»
  y «el lenguaje que usa el sector financiero».
- **Opiniones como opiniones:** el gancho de la evaluación ya no cuenta «diez
  respuestas»; «el algoritmo rápido de este capítulo supone algo», no «suele
  suponer»; la prueba de escritorio es «una forma», no «la forma».
- El paso 5 del recorrido de la portada dice «contar vueltas».

Con esta fase quedan corregidos los tres hallazgos altos de la línea base, salvo
la parte del ejercicio de ordenar que depende del componente (fase 8).

Sin tocar, a la espera del libro impreso (fase 4): toda la sección 1 y tres
entradas del glosario (Definición «también se le llama determinismo»,
pseudocódigo, prueba de escritorio).

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos; sonda del capítulo 2 en verde, en escritorio y a 375 px.

### Capítulo 2, fase 8: `OrdenaPasos` acepta más de un orden · 2026-11-14

Rama `claude/cap02-fase8`. Decisión F del plan. Es un cambio de LP-CORE: se hizo
en `lp-core-extra.jsx`, se ensambló y se estampó en los cinco capítulos.

- **La propiedad nueva, `libres`.** Declara los pasos que pueden cambiar de lugar
  entre sí sin que el algoritmo cambie: grupos de posiciones del orden canónico,
  por lenguaje como `pasos`. Dentro de un grupo cualquier orden cuenta como bien.
  Sin `libres` el componente califica contra un solo orden, igual que antes: los
  demás capítulos no cambian de comportamiento.
- Cuando hay grupos, el componente lo dice al comprobar («Este ejercicio admite
  más de un orden…») y la solución se titula «Un orden correcto».
- **El capítulo 2** declara sus grupos en los cuatro lenguajes: la constante y las
  lecturas entre sí, y el interés y el seguro entre sí. Era el último hallazgo
  alto de la línea base.
- Dos diagramas llevan su `fuente-ok`.

Probado en Chrome, sobre el capítulo 2: el orden canónico y uno alterno válido
dan «¡Secuencia correcta!»; la cuota antes del interés, y el Fin de primero, se
rechazan (6 de 8). Prueba negativa: un grupo con una posición fuera de rango y
otra repetida sale por `console.error` y la sonda marca el capítulo en rojo.

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos (regla 1, deriva, incluida); sonda en verde en los cinco.

**Huecos de las herramientas.**

- Ninguna regla puede saber si a un ejercicio de ordenar le **falta** `libres`:
  eso solo lo ve quien lo resuelve de otra manera válida. Queda en el README. Los
  ejercicios de ordenar de los capítulos 3 (dos), 4 (dos) y 5 (dos) están sin
  revisar; el del capítulo 1 se dejó con un solo orden y lo dice en su título.
- `libres` cubre grupos de pasos intercambiables, no cualquier orden parcial
  (por ejemplo, un paso que pudiera ir en cualquier punto antes de su primer
  uso). Bastó para el capítulo 2.
- La sonda comprueba que los capítulos montan, no que un ejercicio califique
  bien. La prueba de esta fase se hizo con un guion de usar y tirar sobre la
  sonda; no quedó en el repositorio.

Sin hacer, anotado: el texto de 12,5 px del flujograma del ejemplo en pantallas
estrechas y el foco de teclado de sus bloques.

### Capítulo 2, fase 9: los demás capítulos, el banco y VBA en Excel · 2026-11-14

Rama `claude/cap02-fase9`.

**Lo que los demás capítulos dicen del 2.** Se leyeron todas las menciones del
capítulo 2 en el 1, el 3, el 4 y el 5. Solo el 5 quedaba desfasado: decía tres
veces que la búsqueda encontró el crédito «en 12 comparaciones». Ahora dice
vueltas, y el comentario que anotaba «en el peor caso harían falta 16, aunque el
capítulo 2 no lo dice» recoge que ya lo dice. Ningún otro capítulo usa las cifras
del caso de la cuota. Una dependencia que hay que cuidar en la fase 4: el
capítulo 5 cita literal la frase del 2 sobre la TIR que no converge.

**VBA en Excel.** `ejecutar_vba.py comparar`, arnés `2c921dca6a`: los cinco
bloques que declaran salida **coinciden**. Con `--incluir` se mostraron además los
dos ejercicios de detectar el error: «Interes: 0» al usar la variable antes de
asignarla, y 33333 y 99999 en el reparto, como dice el capítulo. Un módulo aparte
comprobó lo que la fase 6 dejó pendiente: con `Currency` el reparto da 33333,3333
y 99999,9999; `Long` redondea al guardar (2,5 → 2; 3,5 → 4; 33333,5 → 33334);
`"Si" = "SI"` es falso; una variable `Currency` sin asignar vale 0. **Sin
comprobar:** qué pasa al reasignar un `Const`, que es un error de compilación e
impediría correr lo demás; el capítulo no afirma nada sobre eso.

**Banco Moodle.** Las seis preguntas del capítulo 2 se revisaron contra el
capítulo corregido, solo leyendo el banco: una sigue vigente y cinco tienen
borrador en el vault. El detalle y las dudas que decide el docente están en la
nota del vault. Nada se copió al banco.

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos; sonda del capítulo 5 en verde.

**Huecos de las herramientas.**

- El módulo 2 del arnés llegó a Excel con los comentarios en caracteres rotos
  (acentos y rayas). El guion copia bien el primer módulo, pero para el segundo
  daba la orden `pbcopy < archivo`, que sin configuración regional UTF-8 rompe
  esos caracteres. No afectó lo ejecutado, porque el código y las cadenas eran
  ASCII; un bloque con tildes en una cadena habría salido mal. **Cerrado:** la
  orden que imprime `ejecutar_vba.py` lleva ahora `LC_ALL=en_US.UTF-8`.
- Un error de compilación no se puede comprobar con el arnés: no deja correr
  nada. Lo que el material diga de «VBA no deja compilar…» hay que mirarlo a mano.
- Pegar en el editor de Visual Basic sigue necesitando control de pantalla.

### Capítulo 2, fase 4: las cinco propiedades son convención del curso · 2026-11-14

Rama `claude/cap02-fase4`. Decisión B del plan, resuelta por el docente: en lugar
de atribuir las propiedades y las definiciones a un libro, se presentan como lo
que son, **convención del curso**.

- **Las cinco propiedades.** «Este curso le pide cinco cosas, con estos nombres,
  y son las que se usan para evaluar. Otros textos las agrupan o las llaman de
  otro modo.» La tabla lleva `<Fuente propia>` y declara inventados los ejemplos
  de su tercera columna.
- **La definición de algoritmo** empieza por «En este curso…».
- **El glosario** dice que sus definiciones son las del curso y lleva
  `<Fuente propia>`. La entrada Definición ya no dice «también se le llama
  determinismo».
- **Fuera la Superintendencia**: una liquidación que depende de quién la corra «no
  se puede auditar ni reproducir».
- «Tres frases que aparecen en manuales reales» pasó a «Tres frases inventadas,
  del tipo que trae un instructivo». La escena de la factura es un supuesto. «El
  manual es, a juicio de este curso, el peligroso». Los 90 días de mora son «por
  ejemplo».
- La frase de la TIR que no converge no se tocó: el capítulo 5 la cita literal.

Con esto el capítulo 2 pasa `verificar.py` **sin avisos**: ninguna figura sin
fuente y ninguna entidad o norma sin cita. Sonda en verde, en escritorio y a
375 px.

Queda la fase 10: lectura crítica final y verificación de todas las citas.

### Capítulo 2, fase 10: lectura crítica final y verificación de las citas · 2026-11-14

Rama `claude/cap02-fase10`. Dos lectores sin contexto sobre el capítulo ya
corregido, antes de fusionar, como pedía la lección del capítulo 1.

**El lector del capítulo entero** encontró 2 hallazgos altos, 12 medios y 17
bajos. Todas las salidas declaradas de Python y R coinciden con la ejecución y
todas las claves son correctas.

- *Alto 1, un error introducido en esta misma mejora.* En la fase 6 se escribió
  que «el pseudocódigo y VBA usan el mismo `=`» para asignar y para comparar. Es
  falso para el pseudocódigo, que asigna con `<-`. Corregido: solo VBA usa el
  mismo símbolo para las dos cosas.
- *Alto 2.* El ejercicio de ordenar decía que dos líneas que no dependen una de
  otra pueden ir en cualquier orden, y rechazaba órdenes que cumplían esa regla
  (la constante declarada justo antes de usarla). `libres` no expresa órdenes
  parciales, así que se acotó el enunciado: la constante y las lecturas van antes
  de los cálculos, y dentro de cada grupo el orden es libre. Con esa regla los
  grupos declarados cubren todos los órdenes válidos.
- *Los doce medios, corregidos.* Entre ellos: la solución de la receta decía que
  no fallaba la finitud, con la misma forma de condición que el capítulo pone como
  ejemplo de falla; el reparto decía que con cualquier tipo con decimales la
  pérdida no desaparece, y con Real el total vuelve a 100 000; dos frases le
  anunciaban al estudiante la respuesta de un ejercicio; el pseudocódigo de la
  búsqueda no decía que los créditos van numerados del 1 al 40 000.
- De los bajos se corrigieron cuatro; los demás quedan listados en la nota del
  capítulo en el vault.

**El verificador de las diez citas** comprobó, una por una, que la frase del
capítulo es la de la nota, que el ancla está en la oración citada y que clave y
localizador coinciden con la fila. Las diez respaldan. Señaló ocho ajustes
alrededor de ellas, todos aplicados:

- dos frases contiguas a una cita eran convención del curso y no lo decían;
- la justificación del cuestionario decía que la norma «admite más de dos»
  salidas, que solo sale de un dibujo;
- «la ley obliga», en presente, daba por vigente una norma cuya vigencia no se
  comprobó: ahora «la Ley 1748 de 2014 estableció […] la obligación». Esa frase
  se volvió a someter y salió *parcial* por una razón que los verificadores
  anteriores dejaron pasar —la condición «siempre que la naturaleza del producto
  lo permita» limitaba la obligación y en la ley solo limita qué conceptos
  entran—; se adoptó la redacción que el verificador dio por respaldada;
- el pie del widget localiza ahora la punta de flecha en §4.4.1, que es de donde
  sale. Un lector independiente cotejó el redibujado midiendo los dibujos de la
  norma: formas y proporciones coinciden.

Comprobado: `verificar.py --con-salidas --con-pandoc` pasa en los cinco
capítulos y el 2 queda sin avisos; sonda del capítulo 2 en verde, en escritorio
y a 375 px.

**Lo que esta fase enseña sobre el método.**

- La lectura final encontró un error alto que la propia mejora había metido. El
  verificador automático estaba en verde. La lectura independiente antes de
  fusionar no es un trámite.
- Cuatro verificadores leyeron la frase de la ley; los tres primeros no vieron
  lo que vio el cuarto. Un «respalda» no es definitivo: depende de quién lee.
- Tres borradores del banco Moodle copiaron frases que esta fase volvió a
  cambiar. Hay que realinearlos antes de copiarlos; está anotado en el vault.

**Criterios de aceptación del plan.** 1, parcial: nueve afirmaciones
comprobadas quedan sin clase porque la política no tiene una para remisiones y
menciones del syllabus. 2 a 7, cumplidos (las salidas de VBA, en Excel). 8,
cumplido: sin hallazgos altos abiertos y los medios corregidos. 9, cumplido.

### 2026-11-15 — Capítulo 2: fusión, publicación y las decisiones que quedaban

La rama `claude/cap02-fase10` se fusionó en `main` (`04c8393`) con la aprobación
del docente y se subió a GitHub el mismo día. Pages publicó: el capítulo 2
publicado se descargó y es idéntico al de `main`.

Después el docente decidió lo que estaba abierto. Rama `claude/cap02-decisiones`:

- **La tasa del caso de la cuota: frase de advertencia.** El `<Ilustrativo>` del
  caso dice ahora que no es una tasa de mercado: el 1,8 % mensual simple sobre el
  capital inicial equivale a 3,10 % mensual sobre saldo, 44,20 % efectivo anual, y
  a 3,28 % y 47,36 % con el seguro. Es una cifra derivada (tasa que iguala las 24
  cuotas con el capital recibido), calculada y vuelta a comprobar. No se compara
  con la tasa de usura, que no se leyó.
- **Sexta clase de afirmación: remisión.** `POLITICA_DE_FUENTES.md` §1 y la regla
  4 de `CLAUDE.md` la definen: dice qué trata otro capítulo o qué pide el
  syllabus, no lleva `<Cita>` y se coteja con su destino. Las diez notas del
  capítulo 2 que estaban sin clase se cotejaron de nuevo contra los capítulos 1,
  3 y 5 y el syllabus, y quedaron clasificadas. Con eso el criterio 1 del plan
  del capítulo 2 queda cumplido.
- **Fecha de consulta de las dos referencias nuevas.** La norma ANSI y la Ley
  1748 quedaron en 2026-11-14 en Zotero y en `referencias.json`. Al corregir la
  segunda, un clic por coordenada cayó en el campo URL (la ventana se había
  desplazado) y le antepuso la fecha; se restauró y se comprobó por la API que
  URL, título y tipo son los originales.
- **Borradores del banco Moodle del capítulo 2.** Las seis recomendaciones y la
  realineación con la fase 10 están aplicadas en el vault y compilan. No se
  copiaron al banco.

**Huecos de las herramientas.**

- Ninguna regla de `verificar.py` conoce la clase `remision`: que una remisión
  siga siendo cierta cuando cambia el capítulo de destino depende de la fase de
  coherencia, a mano. El registro público (`afirmaciones/NN.yaml`) solo lleva
  citas, así que las remisiones no aparecen en él.
- Zotero no deja corregir un campo sin la interfaz: la API local es de solo
  lectura. Al importar, Zotero puso como fecha de consulta el instante de la
  importación en UTC y no la del archivo RIS; hay que revisarla después de cada
  tanda. Y al editar por la interfaz hay que apuntar al campo por su
  elemento de accesibilidad, no por coordenada, y comprobar después por la API.

### 2026-11-15 — Los ejercicios de ordenar de los capítulos 1 a 5

Quedaba abierto desde la fase 8 del capítulo 2: `OrdenaPasos` aprendió a aceptar
más de un orden (`libres`), pero solo el capítulo 2 lo declaraba. Rama
`claude/ordenar-pasos`. Se revisaron los ocho ejercicios.

**Lo que estaba mal.** Los dos del capítulo 3 (la factura y el CDT) leen tres
datos en tres líneas en Python y en R, y solo aceptaban un orden, sin decirlo. La
sección 1 de ese capítulo enseña que esas tres lecturas «se pueden barajar como
se quiera»: el ejercicio castigaba lo que el texto acababa de afirmar.

**Lo que estaba resuelto con convenciones.** Los de los capítulos 1, 4 y 5 ya
tenían una sola respuesta porque el enunciado imponía un orden «que no cambia el
resultado». Era la salida disponible antes de `libres`. Ahora el ejercicio acepta
lo que es libre y el enunciado solo fija lo que `libres` no puede expresar:

| Ejercicio | Libre ahora | Convención que queda |
|---|---|---|
| Cap. 1, ciclo de la máquina | las tres cargas de memoria | primero cargar; después captar, ejecutar y almacenar |
| Cap. 3, factura y CDT | las tres lecturas (Python y R) | las lecturas, antes de los cálculos |
| Cap. 4, recargo por mora | lecturas y valor por defecto | van antes de la condición |
| Cap. 4, `Segun` | nada | casos en orden alfabético y el caso por defecto al final (son bloques de dos líneas) |
| Cap. 5, recaudo | lo de antes del ciclo | la vuelta se cuenta al final del cuerpo |
| Cap. 5, oficinas | tres parejas de líneas vecinas | ninguna |

**Cómo se comprobó.** Con la versión de Python de cada ejercicio: se ejecutaron
todos los órdenes posibles (hasta nueve pasos; el de oficinas, de once, solo los
aceptados) con dos juegos de datos, comparando lo impreso y las variables con el
orden canónico. Ningún orden aceptado cambia el resultado. Cada orden válido que
un ejercicio rechaza incumple una convención escrita en su enunciado, incluido el
del capítulo 2. Pseudocódigo, R y VBA se revisaron leyendo qué líneas cae en
cada grupo. Verificador y sonda (capítulos 1, 3, 4 y 5), en verde.

**Huecos de las herramientas.**

- La prueba de «todos los órdenes» vive en un guion temporal; no está en
  `verificar.py`. Solo ejecuta Python: R y VBA se revisaron a ojo.
- No se probó la calificación con clics en el navegador. La lógica de `libres`
  no cambió desde la fase 8, donde sí se probó; la sonda confirma que ningún
  grupo declarado está mal formado.
- `libres` no expresa órdenes parciales ni intercambio de bloques. El README lo
  dice ahora, con la regla de autoría: lo que `libres` no cubre lo excluye el
  enunciado.

### 2026-11-15 — El material en Safari de un iPhone, y la sonda a 320 px

Pendiente desde el cierre del capítulo 1. Se abrió el capítulo 1 publicado en
Safari de un iPhone 15 Pro, a través de la duplicación del iPhone en el Mac.

**Lo que se vio.** El teléfono tiene activado el zoom de pantalla y Safari
dibuja la página a **320 px** de ancho, no a 393. Se comparó con la misma página
emulada a 320 px: los saltos de línea coinciden uno por uno. El menú lateral, el
cambio de lección y las pestañas de código responden al toque, y las fórmulas
se desplazan dentro de su caja.

**Lo que estaba roto a 320 px**, y la sonda no veía porque mide a 375:

- la cabecera de los bloques de código que se pliegan: el título y los botones
  «Copiar» y «Mostrar» no caben en una fila, y «Mostrar» salía cortado. Visto
  también en el teléfono. Ahora la cabecera parte en dos filas;
- la cabecera de los ejercicios: la etiqueta del tipo («E6 · Emparejar») se
  salía 12 px. Ahora baja de fila si no cabe;
- en el capítulo 2, el contador del paso a paso de la asignación se salía 13 px.

El CSS se cambió en el `head` del capítulo 1 y se copió a los otros cuatro; lo
demás, en `lp-core-extra.jsx`, regenerado y reestampado. La sonda tiene un modo
nuevo, `320`. Los cinco capítulos pasan a 320, a 375 y en escritorio, y el
verificador completo.

**Lo que no se hizo.** No se recorrió el capítulo entero en el teléfono: se
vieron la portada, la sección 3 y un bloque de código. Lo demás se apoya en que
el teléfono y la emulación a 320 px dieron lo mismo. La versión publicada que
vio el teléfono es la anterior a estas correcciones.

**Queda a criterio del docente.** El botón flotante del menú tapa las dos
primeras letras de la línea que pasa por debajo al desplazarse. A 320 px la
tarjeta «Antes de empezar» deja 172 px para el texto: unas veinte letras por
línea.

**Huecos de las herramientas.**

- La duplicación del iPhone no recibe teclado ni desplazamiento en segundo
  plano: hay que tomar la pantalla del Mac. Los clics sí llegan.
- La sonda mide que nada se salga, no que algo quede tapado por el botón
  flotante fuera de la fila «Lección N de M».

### 2026-11-15 — Capítulo 1: las tres citas de Goldberg, con página

El docente aportó el PDF del artículo de la revista (Goldberg 1991, *ACM
Computing Surveys* 23(1), pp. 5-48). Rama `claude/cap01-goldberg`.

Las tres afirmaciones de la sección 4 que lo citan se habían leído el 14 de
noviembre en una reimpresión editada de acceso abierto, y por eso se localizaban
por apartado. Cotejadas con la revista, llevan página impresa:

| Afirmación | Antes | Ahora |
|---|---|---|
| El doble ocupa 64 bits, 11 de exponente y 53 de precisión | apartado «Precision», tabla | p. 18, tabla 1 |
| En los formatos de IEEE el signo ocupa un bit | apartado «Exponent» | p. 18, §2.1.3 |
| El bit oculto de los formatos en base 2 | apartado «Base» | p. 16, §2.1.1 |

El pasaje de la revista dice lo mismo que el de la reimpresión, con dos
diferencias de redacción que no cambian el sentido, y el texto del capítulo no
se tocó: no se volvió a someter al verificador independiente. El PDF quedó
adjunto al ítem en Zotero; las notas y el registro dicen `pdf-zotero`.

**Huecos y avisos.**

- El PDF está suelto en la raíz de la carpeta del curso, que es el repositorio
  público. No está versionado ni ignorado: un `git add` sin rutas lo publicaría.
  Queda a decisión del docente moverlo o borrarlo; la copia de Zotero basta.
- La página del PDF no es la de la revista (n + 4). Hay que leer el encabezado
  impreso antes de escribir un localizador.

### 2026-11-15 — Capítulo 2: los trece hallazgos bajos que quedaban

La lectura crítica final (fase 10) dejó anotados trece hallazgos bajos sin
corregir. El docente pidió cerrarlos. Rama `claude/cap02-bajos`.

| Hallazgo | Cómo quedó |
|---|---|
| La salida del pseudocódigo dependía de entradas que no se veían | cada `Leer` dice en un comentario qué valores se leen |
| Una opción mezclaba coma de miles y coma decimal | las opciones dicen «un descuento de 2 400 pesos» |
| «TIR que no converge», sin definir | la frase sigue igual (el capítulo 5 la cita) y lleva una glosa que remite al capítulo 5 |
| `Entero porCuenta` sin presentar | comentario en la propia línea |
| La constante, dentro de la columna Entrada | la celda dice que va aparte, porque no entra |
| «Los otros tres», «esta columna» | «Python, R y VBA», «el pseudocódigo» |
| «Se actualiza sumándose a sí misma» | «sumándole un valor a lo que ya tenía: total <- total + pago» |
| El glosario sin Entrada, Salida ni traza | dos entradas nuevas y «Prueba de escritorio o traza» |
| Flujograma del ejemplo con puntas rellenas y otras proporciones | punta abierta; el pie declara que los símbolos van más anchos que en la norma |
| El ejercicio de ordenar solo escribía la cuota | escribe interés, seguro y cuota, como pide el recuadro de la salida |
| «Recorría los 40 000 créditos uno por uno» | «miraba los créditos uno por uno hasta dar con el que buscaba» |
| Las lecturas no decían la unidad de la tasa; Python da 5183999.999999999 | «Tasa mensual, en decimal»; el enunciado de la traza avisa de la cifra |
| La norma ANSI citada con una referencia que se llama FIPS PUB 24 | la oración dice que se lee en esa publicación, donde está reproducida |

Comprobado: verificador completo, sonda del capítulo 2 a 320, a 375 y en
escritorio, y la prueba de todos los órdenes del ejercicio de ordenar en Python
(48 aceptados, ninguno cambia el resultado).

**Lo que no se hizo.** El flujograma del ejemplo no se redibujó con las
proporciones de la norma: con ellas el texto de cada paso no cabe; se declara la
diferencia. Dos frases tocadas quedan junto a una cita (la de la norma, §3.1) o
son glosas nuevas, y no pasaron por el verificador independiente: el inciso de
la norma dice dónde se leyó, no qué dice. Las líneas de VBA que cambiaron en el
ejercicio de ordenar no se ejecutaron en Excel.

### 2026-11-15 — El botón del menú ya no flota sobre el texto

Visto en el iPhone del docente: por debajo de 1024 px el botón del menú era fijo
y quedaba encima del contenido; al desplazarse tapaba las dos primeras letras de
la línea que pasaba por debajo. Rama `claude/boton-menu`.

**Lo que se hizo.** Por debajo de `lg`, el contenido empieza bajo una barra fija
y opaca de 48 px (`#barra-movil`), que lleva el botón encima y, a su derecha,
«Lección N de M · %». El texto pasa por debajo de la barra, no del botón. La
fila de arriba de cada lección conserva «Anterior» y «Siguiente». Desde 1024 px
todo queda como estaba. El cambio está en `lp-demo.jsx` (la plantilla del
`App`), regenerado y reestampado en los cinco capítulos.

**Lo que cuesta.** 48 px de alto en el teléfono, siempre. A cambio, «Lección N
de M» queda a la vista durante toda la lectura.

**La sonda.** La comprobación del botón cambió de sentido: antes miraba que no
tapara la primera fila; ahora exige que su rectángulo no toque el del contenido
que se desplaza y que la barra traiga el rótulo. Prueba negativa: sin la barra,
el botón tiene que tocar el contenido. Los cinco capítulos pasan a 320, a 375 y
en escritorio.

**Lo que no se hizo.** No se comprobó en el iPhone: se verá cuando se publique.
Entre 1024 px y el ancho en que el contenido queda centrado, con el menú
cerrado, el botón sigue siendo flotante; el relleno de 48 px lo deja fuera del
texto, pero la sonda no mide ese tramo.

### 2026-11-15 — Lo que el iPhone mostró y la sonda no veía

Revisión de la barra del menú en el iPhone del docente, ya publicada. Rama
`claude/alto-iphone`.

**1. La página entera se desplazaba.** El `App` medía su alto con `100vh`. En
Safari de iPhone eso es la pantalla sin las barras del navegador: el documento
quedaba unos 30 px más alto que lo visible y se movía entero. La barra nueva se
iba bajo la muesca y el botón del menú, que es fijo, volvía a quedar sobre el
texto; además, desplazar hacia arriba llegó a recargar la página. El defecto
era anterior a la barra; la barra lo hizo visible. Ahora el alto es `100dvh` y
el contenido lleva `overscroll-contain`.

Se probó en el teléfono **antes de publicar**, sirviendo la rama por la red
local: la barra no se mueve aunque se siga desplazando al llegar al final, el
pie se ve completo sobre la barra de Safari y subir no recarga.

**2. Palabras pegadas.** En el teléfono se leyó «llamaoperador de información».
JSX borra el salto de línea entre un texto y una etiqueta. Había diecisiete
casos: once en el capítulo 1, uno en el 2 y cinco en el 4; siete se veían
pegados (negrita, cursiva, términos con definición) y el resto era código en
línea, que se ve separado por su relleno pero se copia y se lee en voz alta
pegado. Corregidos con `{' '}`. La sonda los busca ahora en el DOM, en todos
sus modos, y falla si encuentra uno.

**3. Una corrección a lo dicho antes.** Los 320 px no venían de un ajuste del
teléfono («zoom de pantalla»), como se anotó: en otra dirección el mismo
teléfono dibuja a tamaño normal. Era el zoom de página de Safari para el sitio
publicado, cerca del 125 %. El modo `320` de la sonda sigue valiendo, por esa
razón y no por la otra. README, sonda y memoria corregidos.

**Lo que no se hizo.** La prueba en el teléfono fue al 100 % de zoom, no al
125 % del sitio publicado: habría que haber cambiado un ajuste de Safari del
docente. Del teléfono no se abrió el menú lateral con la barra nueva ni se vio
«Mostrar» en un bloque de código; lo segundo lo mide la sonda a 320 px.

**Un tropiezo.** Para el servidor de la red local se escribió
`.claude/launch.json` en el worktree sin mirar que ya existía, y se
sobrescribió. No está versionado. Se rehízo con el de la carpeta principal más
la configuración nueva; si el del worktree tenía algo propio, se perdió.

**Huecos de las herramientas.**

- La sonda no puede ver el desplazamiento del documento en Safari de iPhone:
  Chrome no tiene barras que cambien el alto. Solo se ve en el aparato.
- La detección de palabras pegadas solo mira lo pintado. Lo plegado se buscó
  con una expresión regular sobre el código, que no quedó en el repositorio.

### 2026-11-15 — Un tramo en blanco al final de la lección, y de dónde salía

Revisando en el iPhone la versión publicada, la lección 4 del capítulo 1
terminaba en varias pantallas en blanco, con una etiqueta «E7 · Interpretación»
suelta abajo. Rama `claude/etiqueta-ejercicio`.

**La causa.** La etiqueta del tipo de ejercicio se coloca midiendo con
`offsetTop` dónde empieza su tarjeta, respecto de un envoltorio que debía estar
posicionado por la clase `relative`. Cuando el capítulo se abre directamente en
una lección guardada, ese primer pintado ocurre antes de que Tailwind genere
sus estilos: el envoltorio aún no está posicionado y la medida sale respecto de
la página. La etiqueta queda miles de píxeles por debajo de su tarjeta y alarga
la lección con un tramo vacío. Pasa en cualquier navegador; entrando por
«Siguiente» no pasa. El defecto venía del 2026-11-10, cuando se empezó a medir.

**El arreglo.** El envoltorio lleva `position: relative` también en `style`, y
la medida se repite con un `ResizeObserver`. Librería regenerada y reestampada.

**La sonda.** No lo veía porque siempre entra por la lección 1 y avanza. Ahora
comprueba que cada etiqueta esté junto a su tarjeta y, además, vuelve a cada
lección con etiquetas, recarga la página y lo comprueba recién cargada. Antes
del arreglo falló en los capítulos 1 y 4 con etiquetas a entre 2 900 y 6 700 px
de su tarjeta; después pasa en los cinco, a 320, a 375 y en escritorio.

**En el teléfono**, por la red local: la lección 4 abierta directamente mide
18 943 px en vez de 23 815, las dos etiquetas quedan en 0 px y el final muestra
el pie.

**Cómo se llegó, y lo que se descartó.** Primero se creyó que Safari dejaba de
pintar contenido muy alto. Se probaron en el teléfono, con copias temporales
que recorrían la lección solas y mostraban sus medidas en pantalla: el código
anterior a los cambios de hoy (fallaba igual: no lo habían causado), sin la
animación de entrada, con el documento entero desplazándose en vez de una caja
interna, sin transformaciones ni animaciones, y sin gráficas. Solo cambió el
resultado al fijar la etiqueta. Las medidas en pantalla mostraron que el
desplazamiento sí llegaba al final: lo que había era alto de más.

**Dos tropiezos en el teléfono.** Para reproducir el fallo se subió el zoom de
página de Safari en la dirección local de prueba y se devolvió al 100 %. Y al
buscar ese control se tocó «Hide Distracting Items»; se canceló sin ocultar
nada.

**Lo que no se hizo.** No se revisó en el teléfono la versión publicada con
este arreglo; se verá al publicar. Al elegir una lección desde el menú estando
al final de otra, la vista quedó una vez al final de la nueva en vez de al
principio: visto una sola vez, sin investigar.

### 2026-11-16 — Capítulo 3: plan de la mejora de contenido

Plan `PLAN_TAREA13_CAPITULO_03_CONTENIDO.md`, rama `claude/cap03-plan`. Propuesto;
espera la aprobación del docente y diez decisiones (A–J). No se tocó el capítulo.

**Línea base.** Un lector sin contexto leyó el capítulo entero, ejecutó los bloques de
Python y R y rehízo las cuentas: 4 hallazgos altos, 19 medios y 15 bajos. Las 22 salidas
declaradas de Python y R coinciden. Los altos se comprobaron después aparte: `2 ^ 3 ^ 2`
da 3 en Python; lo que se dice del depurador es falso y el cuestionario lo marca como
correcto; los 590 000 pesos del ejercicio de las dos ofertas dependen de un supuesto que
no se dice. El cuarto —si el descuento por pronto pago reduce la base del IVA— queda
**sin verificar**: se resuelve leyendo la norma en la fase 1.

**Medido.** Ninguna cita, ningún caso declarado ilustrativo, siete figuras y tablas sin
fuente, cuatro trazas que aprueban en blanco, y ninguna norma tributaria o financiera en
Zotero.

**Huecos de las herramientas.**

- La regla 32 del verificador no ve «la regulación colombiana obliga», ni el IVA, la
  retención o los aportes: busca nombres de entidades, no cifras legales.
- Ninguna regla comprueba que una traza cuyo enunciado pide la raya lleve
  `exigeRespuesta`: las cuatro del capítulo aprueban en blanco y el verificador pasa.
- La regla 9 ejecuta las salidas de Python y R, pero no mira cómo las imprime R: cuatro
  ejercicios preguntan «¿qué imprime?» con una forma que `cat()` no produce.

### 2026-11-16 — Capítulo 3, fase 1: línea base y fuentes

El docente aprobó el plan con las diez recomendaciones (A–J). Rama `claude/cap03-fase1`.
El capítulo no se tocó.

**Inventario (en el vault).** 213 afirmaciones: 27 citadas, 34 ejecutadas, 68 derivadas,
24 ilustrativas, 33 de criterio y 27 remisiones; 85 no se presentan hoy como lo que son.
35 figuras, 33 con defectos anotados. 29 conceptos (16 nuevos) y 20 hilos (16 nuevos).
Quince cuentas derivadas no dan, siete remisiones no coinciden del todo con su destino y
cinco esperan el cotejo con el syllabus. El inventario sacó dieciséis hallazgos que la
lectura crítica no había visto (N1–N16, en la nota del capítulo).

**Normas leídas en su página oficial** (Secretaría del Senado, Compilación Jurídica de la
DIAN y Gestor Normativo de Función Pública), con los pasajes en el vault:

- Estatuto Tributario, arts. 447, 454 y 468. El artículo 454 solo saca de la base del IVA
  el descuento que consta en la factura y no está sujeto a condición: **el descuento por
  pronto pago no reduce la base**, y el caso central de la sección 1 enseña lo contrario.
  Se confirma el hallazgo H4; se aplica la decisión A.
- Decreto 1625 de 2016, arts. 1.2.4.9.1, 1.2.4.2.5 y 1.2.4.2.83. El 2,5 % y la base sin
  IVA se confirman con matices. **La retención de un CDT no es hoy del 7 % sino del 4 %**:
  hallazgo nuevo.
- Ley 100 de 1993, arts. 18, 20 y 204, y Decreto 4982 de 2007: 4 % de salud literal; 4 %
  de pensión como cuenta (16 % × 25 %); misma base para las dos.
- Ley 1480 de 2011, art. 45: la tasa efectiva anual, con esas palabras, solo para quien
  da crédito sin estar vigilado. Con la Ley 1748, ya en Zotero, alcanza para una frase
  más precisa que «la regulación obliga».

La tanda 04 de Zotero (cinco normas) quedó preparada y **no se importó**: espera la
aprobación del docente.

**Lo que no se hizo o no se verificó.** Ningún pasaje pasó por el verificador
independiente (se hace al citar, en la fase de cada sección). No se comprobó la vigencia
de la reforma pensional (Ley 2381 de 2024), ni se leyó la Circular Básica Jurídica, ni
los oficios de la DIAN sobre descuentos condicionados. Las cinco remisiones al syllabus
están sin cotejar.

**Huecos de las herramientas.**

- El guion de tandas (`generar_tanda.py`, en el vault) no actualiza una nota de fuente
  que ya existe como candidata: la del Estatuto Tributario hubo que reescribirla aparte.
- Al terminar el agente del inventario aparecieron 91 copias de notas con un número
  añadido o cambiado al final del nombre. Se apartaron sin borrar. `registrar_afirmaciones.py`
  rechaza un `id` repetido, pero solo se ejecuta al registrar las citas de un capítulo: en
  la línea base nada lo corre, y las copias se vieron al contar los archivos.
- El buscador no devolvió ninguna página oficial para tres de las cinco normas: hubo que
  ir a la dirección de la Secretaría del Senado y de la DIAN directamente.

### 2026-11-16 — Capítulo 3, fase 2: sección 1, la secuencia

El docente aprobó la fase 1 y la importación de la tanda 04. Rama `claude/cap03-fase2`.

**Zotero.** Las cinco normas entraron por el conector local a «3 Fuentes primarias» de
LPF (11 ítems en la colección, todas con clave). La colección seleccionada en Zotero era
la del mismo nombre en Teoría del Riesgo: se vio en `getSelectedCollection` y se cambió
antes de enviar. `referencias.json` exportado.

**Sección 1.**

- El caso de la factura ya no enseña la regla al revés: el descuento es «concedido en la
  misma factura, sin ninguna condición», con las mismas cifras, y la regla se cita
  (Estatuto Tributario, art. 454); la tarifa del 19 %, también (art. 468). Un párrafo
  explica por qué un descuento por pronto pago no cabe en la regla. El caso lleva
  `<Ilustrativo>`.
- La regla de dependencia dice lo que es: una condición suficiente. Un párrafo nuevo
  trae el caso de dos restas sobre la misma variable.
- El flujograma lee `tasaIva`; fuera «compila» y «es donde más dinero se pierde»; la
  Motivación ya no da la respuesta del primer ejercicio; `input` pide «Tasa de IVA»; la
  pista del ejercicio de ordenar no afirma nada sobre los lenguajes.
- Primeras dos citas del capítulo, `<Referencias />` al cierre y `afirmaciones/03.yaml`.

**Verificador independiente.** La cita del artículo 454 salió «parcial» en la primera
redacción (faltaba «efectivos», y sin esa palabra la frase cubría más descuentos que la
norma); corregida y vuelta a someter, «respalda». El razonamiento sobre el pronto pago
decía «la cuenta correcta sería otra», que el artículo no permite afirmar: dice qué sale
de la base, no qué entra. Quedó «ese artículo ya no bastaría para sacarlo de la base».

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco capítulos pasan.
Sonda en `file`, 375 y 320: siete lecciones, cero errores; los recortes (3, 3, 5 y 22 a
320 px) son los mismos de la línea base y quedan para las fases 8 y 9.

**Lo que no se hizo.** No se miró la sección en el navegador a ojo ni en el teléfono
(fase 9). VBA sin ejecutar. No se leyó doctrina de la DIAN sobre descuentos
condicionados.

**Hueco de las herramientas.** `registrar_afirmaciones.py` rechazó una nota que había
pasado de `citada` a criterio en el texto pero seguía con `clase: citada` y
`estado: resuelta`: el aviso («le falta `leido_por`») no dice que el problema puede ser
la clase. Se corrigió la nota; el mensaje merece una segunda línea.

### 2026-11-16 — Capítulo 3, fase 3: sección 3, expresiones y precedencia

Rama `claude/cap03-fase3`, sobre la fase 2.

- **La potencia (hallazgo alto H1).** El aviso decía que `2 ^ 3 ^ 2` vale 512 «en
  pseudocódigo, Python y R». Ahora dice qué símbolo usa cada lenguaje, y un bloque nuevo
  (`EJ_POTENCIAS`) lo muestra: 512 en pseudocódigo, Python (`**`) y R, 64 en VBA. La
  pestaña de Python trae una segunda línea, ejecutada, con `2 ^ 3 ^ 2`: da 3, sin error.
  Un recuadro lo explica con cita (referencia de Python, §6.9: `^` es el XOR bit a bit).
- La tabla de precedencia dice que es un resumen de las del capítulo 1 y ya no cuenta
  «dos» diferencias entre lenguajes, que eran tres con la del signo en Python.
- El saldo promedio es un supuesto declarado (decisión G). La línea que el ejercicio
  pregunta imprime con formato en Python y en R (decisión F): antes R escribía `1.3e+07`
  y Python `13000000.0`. 62,5 % en vez de 62 %. La división entera se explica con una
  cuenta a la vista. El recuadro previo ya no da la respuesta del ejercicio.

**Verificador independiente.** La cita de Python: «respalda».

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan. Sonda en
`file` y 320: siete lecciones, cero errores, mismos recortes que la línea base.

**Lo que no se hizo.** El 64 de VBA de `EJ_POTENCIAS` no se ejecutó en Excel: es la misma
expresión que el capítulo 1 ejecutó el 2026-11-14, y se vuelve a correr en la fase 9. No
se miró la sección a ojo.

**Hueco de las herramientas.** La regla 25 (cotejo del pseudocódigo con Python) no tiene
manera de decir «Python imprime una línea de más a propósito» salvo la lista
`COTEJO_DISTINTO`, que vive en `verificar.py`: se añadió `EJ_POTENCIAS` allí. Con dos
excepciones en dos capítulos, la lista empieza a pedir vivir junto al bloque (un
comentario `cotejo-distinto` en el propio capítulo) y no en el verificador.

### 2026-11-16 — Capítulo 3, fase 4: sección 2, leer, asignar, escribir

Rama `claude/cap03-fase4`, sobre la fase 3. Ninguna cita nueva.

- La sección remite al capítulo 2 donde repetía sin decirlo: las tres instrucciones son
  su entrada, proceso y salida; `x = x + 1`; la variable temporal es su auxiliar.
- Fuera tres absolutos: «no hay una cuarta» instrucción, «intercambiar no se puede hacer
  en dos líneas» y «el patrón más viejo de la programación». Queda lo que el capítulo
  muestra: con dos asignaciones sueltas el intercambio no funciona.
- La lectura por teclado (Python, R) y por celda (VBA) se dice como convención del
  material. La Motivación ya no adelanta la cifra del ejercicio, que además era 340
  millones donde el descuadre es de 255.
- La traza del intercambio exige respuesta: la raya ya no se aprueba en blanco. El
  bloque de VBA del acumulador es un `Sub` completo. La línea de R del ejercicio de
  detectar el error imprime con formato (salía `8.5e+07`).

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan. Sonda en
`file` y 320: sin errores, mismos recortes.

**Lo que no se hizo.** `exigeRespuesta` no se probó a mano en el navegador: es la misma
propiedad que el capítulo 2 usa en tres trazas. VBA sin ejecutar. La línea 6 de la traza
en R sigue imprimiendo en notación científica; nadie pregunta por esa salida.

**Hueco de las herramientas.** Sigue sin regla que avise de una traza cuyo enunciado pide
la raya y no lleva `exigeRespuesta`: esta se corrigió porque el lector la contó a mano.
Quedan tres en el capítulo, para la fase 5.

### 2026-11-16 — Capítulo 3, fase 5: sección 4, la prueba de escritorio

Rama `claude/cap03-fase5`, sobre la fase 4. El docente decidió el CDT al 4 %, citado.

- **El depurador (hallazgo alto H2).** Fuera «es la única herramienta que sirve cuando el
  programa no falla», y corregida la opción del cuestionario que lo premiaba. Queda lo que
  el capítulo sostiene: la traza es su método y no necesita más que el algoritmo.
- La escena de la nómina es un supuesto y ya no contradice la traza de la sección 5
  («cuatro columnas», «fila siete»). La raya de la tabla se dice como convención del
  método. Las notas de los trazadores valen en los cuatro lenguajes y dos de ellas
  escriben la expresión con los valores sustituidos, que la sección recomendaba y no hacía.
- Un solo `<Ilustrativo>` declara inventados los casos de la sección y dice que el interés
  simple y el mes de 30 días son simplificaciones.
- Las dos trazas exigen respuesta. El ejercicio del abono tenía dos líneas defendibles:
  ahora pide «la instrucción que cambia un dato antes de que el cálculo del mes lo haya
  usado», y el error se llama igual que en la sección 2. Las notas previas ya no dan las
  cifras que el ejercicio pregunta.
- R imprime con formato en la traza de la factura; `EJ_INTERMEDIAS` define `subtotal` y
  su VBA es un `Sub`; el VBA del crédito usa `Currency`.
- **Tres citas del Decreto 1625 de 2016**: la retención del 2,5 %, su base sin impuestos y
  el 4 % del CDT (antes 7 %, en cuatro líneas de código y en el enunciado).

**Verificador independiente.** Tres rondas. El 2,5 % salió «parcial»: la frase lo daba
por incondicional, y el artículo exige agente retenedor, fija 3,5 % para quien no declara
renta y define el concepto por una fecha. La del CDT, «parcial» en la segunda ronda,
porque «sobre todo el interés» no lo dice el artículo. Las dos quedaron con sus supuestos
a la vista y «respalda».

**Lo que no se hizo.** La decisión D pedía decir que un depurador hace lo mismo sobre la
máquina: esa frase necesita fuente, y no se escribió. Quedó preparada, **sin importar**, la
tanda 05 de Zotero con la documentación del depurador de Python. Los literales sin nombre
de las trazas (0.19, 0.025, 1200000) siguen; VBA sin ejecutar; nada visto a ojo.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan. Sonda en
`file` y 320.

**Hueco de las herramientas.** El verificador de citas trabaja sobre una oración, y aquí
la conclusión iba en la oración siguiente, sin cita: hubo que pedirle expresamente que
dijera si «se sigue». El encargo al verificador debería incluir siempre la oración que
viene después de la cita.

### 2026-11-16 — Capítulo 3, fase 6: sección 5, casos financieros, y la frase del depurador

Rama `claude/cap03-fase6`, sobre la fase 5. El docente aprobó la tanda 05 de Zotero (la
documentación del depurador de Python), que entró a «4 Datos y software» de LPF.

- **El depurador (decisión D).** La sección 4 dice ahora que el depurador de Python
  permite ejecutar línea por línea e inspeccionar el estado donde se detiene, con cita, y
  que en este curso la traza va primero porque sirve aunque todavía no haya programa.
- **Los 590 000 pesos (hallazgo alto H3).** El ejercicio dice su supuesto —un solo pago
  al cabo del año—, ya no dice «casi media cuota» y avisa que con cuotas la diferencia
  sería menor.
- **El 1,55 %.** Era una tasa simple en la sección que enseña a componer: ahora da las
  dos cuentas, 1,55 % repartido y 1,53 % compuesto.
- **La nómina.** El 4 % de salud se cita (Ley 100, art. 204); el de pensión se muestra
  como cuenta, 16 % de cotización total (Decreto 4982 de 2007) por la cuarta parte a cargo
  del trabajador (Ley 100, art. 20); la base común, también (art. 204, par. 1.º). El
  recuadro «Lo que pasó de verdad el viernes» es «Lo que hacía la rutina del caso», sin
  EPS ni ingreso base de cotización. La traza exige respuesta.
- **La tasa efectiva anual.** Fuera «la regulación colombiana obliga a informar»: la
  frase dice quién está obligado a qué, con la Ley 1480 (art. 45) y la Ley 1748 (art. 1.º).
- Un `<Ilustrativo>` declara inventados las ofertas, la factura descontada y la nómina.

**Verificador independiente.** Ocho citas en dos rondas. La del depurador salió
«parcial»: generalizaba a «los lenguajes» desde la documentación de uno, y puesta antes
de «sirve cuando el programa no falla» sugería un contraste que el propio pasaje
desmiente. La de la Ley 1480, «parcial»: decía «quien financia una compra… sin estar
vigilado», y la ley habla del proveedor que financia sus propios bienes y de quien da
crédito sin que una autoridad vigile esa actividad. Las dos quedaron con la redacción
que el verificador propuso.

**Decisión tomada sin consultar.** Las definiciones y fórmulas de matemática financiera
de la sección (descuento comercial; nominal, periódica y efectiva) se dejaron como
definiciones del curso, sin cita. El inventario las había propuesto como citadas.

**Lo que no se hizo.** No se comprobó el estado de la reforma pensional más allá del
aviso de la Secretaría del Senado. VBA sin ejecutar. Nada visto a ojo.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan. Sonda en
`file` y 320.

**Hueco de las herramientas.** La regla de la «clave larga» avisó bien cuando la opción
correcta creció al corregirla. Pero ninguna regla mira que la pregunta de un ejercicio
declare el supuesto del que depende su clave: el de los 590 000 lo encontró el lector.

### 2026-11-16 — Capítulo 3, fase 7: portada, evaluación y glosario

Rama `claude/cap03-fase7`, sobre la fase 6. Ninguna cita nueva.

- **Portada.** El caso de la nómina se cuenta como supuesto y con la misma razón de
  reclamo que la sección 5; antes daban dos distintas. Fuera «once segundos» y «veintiséis
  personas». «Los algoritmos de este curso se arman con tres estructuras de control», en
  vez de «todo programa».
- **Cuestionario.** Cinco preguntas ajustadas a lo que las secciones dicen ahora: sin
  «57 000 idénticos en cada factura», sin «ningún lenguaje la reporta», la división
  entera sin nombrar operadores y con valores positivos, y el costo del descuento con sus
  dos cuentas. La clave del depurador se había corregido en la fase 5.
- **Glosario.** La regla de dependencia como condición suficiente; el descuento comercial
  sin «siempre menor». Lleva su `<Fuente>`.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; al capítulo
3 le queda un solo aviso de figura sin fuente, el flujograma, que es de la fase 8. Sonda
en `file` y 320.

**Lo que no se hizo.** Las cinco remisiones al syllabus no se cotejaron contra el archivo
`.xlsx`, sino contra la fila anotada en esta sesión y las notas del capítulo 2. La
pregunta 5 sigue repitiendo el escenario de la Motivación de la sección 3. La portada no
dice que el pseudocódigo sea el lenguaje normativo; la del capítulo 2 tampoco.

**Hueco de las herramientas.** El cuestionario cita afirmaciones de las secciones en sus
justificaciones, y nada avisa cuando la sección cambia y la justificación no: las cinco
de esta fase se encontraron releyendo. El inventario del vault las tenía enlazadas, y por
ahí se llegó.

### 2026-11-16 — Capítulo 3, fase 8: figuras

Rama `claude/cap03-fase8`, sobre la fase 7. No hizo falta tocar LP-CORE.

- El flujograma de la sección 1 dibuja las puntas de flecha abiertas, como el capítulo 2,
  y su pie dice que los símbolos van más anchos que en la norma. Mirado en el navegador.
- Con eso el capítulo 3 pasa `verificar.py` sin ningún aviso: las siete figuras y tablas
  sin fuente de la línea base quedaron con `<Fuente>` o con su marca razonada en las
  fases 2 a 8.
- Las 35 notas de figura del vault tienen estado: 28 corregidas, 1 correcta y 6 con un
  defecto menor anotado.

**Corrección.** En los informes de las fases 2 a 7 llamé «recortes de texto a 320 px» a
lo que la sonda informa como «recortados». No lo son: son líneas de código dentro de
bloques plegados, que la sonda cuenta aparte a propósito. Un recorte fuera de un bloque
plegado hace fallar la sonda, y el capítulo no tiene ninguno.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan, y el
capítulo 3 sale «OK». Sonda en `file`, 375 y 320.

**Hueco de las herramientas.** La salida de la sonda dice «(22 recortados)» sin decir que
son de bloques plegados ni que no son un fallo: se leyó mal durante seis fases. La línea
debería decir «22 en bloques plegados». Además, el navegador integrado muestra una
instantánea fija cuando se abre un archivo con `file://`: para mirar un cambio hay que
levantar el servidor local.


### 2026-11-16 — Capítulo 3, fase 9: cotejos, VBA en Excel y banco Moodle

Rama `claude/cap03-fase9`, sobre la fase 8; sin fusionar.

- **Remisiones.** Lo que los capítulos 2, 4 y 5 dicen que el 3 estableció coincide con el
  capítulo 3 revisado.
- **VBA en Excel.** Los 12 bloques con salida declarada se ejecutaron con
  `ejecutar_vba.py`: coinciden. Se corrigió una salida, la de `EJ_POTENCIAS`
  (`Debug.Print` antepone un espacio al número: `'>  64`). Tres difieren solo en la coma
  decimal regional, como avisa el capítulo.
- **Banco Moodle.** Las ocho preguntas del capítulo 3 se revisaron contra el capítulo:
  siete quedaron desfasadas en la redacción y una coincide; las ocho claves siguen
  siendo correctas. Los siete borradores y la nota están en el vault. **No se copió nada
  al banco.**
- **Tres ajustes que salieron de esa revisión.** La regla de dependencia dice «lee ni
  modifica» (dos asignaciones a la misma variable tampoco se intercambian); el cierre
  del reto y el glosario dicen «esas dos normas piden informar», no «la ley manda»; la
  efectiva anual es «una unidad común», no «la unidad», como ya decía el comparador.
- **Sonda.** El rótulo pasa de «N recortados» a «N en bloques plegados», y el README lo
  explica.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan y el
capítulo 3 sale «OK». Sonda a 320: 7 de 7 lecciones, sin errores.

**Lo que no se hizo.** La prueba en el iPhone del docente por red local. «iPhone
Mirroring» conectó y se abrió una pestaña nueva, pero escribir la dirección exige el
control de pantalla completa, que nadie aprobó, y la conexión se cortó. No se ejecutaron
en Excel los bloques VBA sin salida declarada. No se ejecutó `verificar_cloze.R` sobre
los borradores (compilan con `exams2html` y `exams2moodle`). Siguen abiertos: la traza
en R que imprime `8.5e+07`, la pregunta 5 y las remisiones al syllabus sin cotejar
contra el `.xlsx`.

**Hueco de las herramientas.** La escritura en segundo plano no llega a «iPhone
Mirroring» (teclea «aaaa»): la prueba en el teléfono necesita al docente presente.
`ejecutar_vba.py` exige pegar el módulo a mano en Excel, y eso también pide el control
de pantalla.

### 2026-11-16 — Capítulo 3, fase 10: lectura crítica final

Rama `claude/cap03-fase10`, sobre la fase 9; sin fusionar. Dos lectores sin contexto y sin
permiso de escritura: uno leyó el capítulo entero y rehízo las cuentas; el otro cotejó
cada `<Cita>` con el pasaje guardado en el vault.

- **Citas: 13; 11 respaldadas y 2 parciales, corregidas.** El caso de la factura no decía
  que el descuento fuera normal según la costumbre comercial, tercera condición del
  artículo 454: quedó como supuesto del `<Ilustrativo>`. El 4 % de pensión no tenía el
  puente entre el 16 % del Decreto 4982 y el reparto del artículo 20 de la Ley 100: la
  frase cita ahora también el artículo 2.º del decreto, que ya estaba leído.
- **Lectura del capítulo: ningún hallazgo alto.** Todas las cuentas y las salidas de
  Python y R que el lector ejecutó cuadran. De los medios se corrigieron: la regla de
  dependencia (dos salidas a pantalla tampoco se intercambian, y la pregunta del
  cuestionario habla del valor final de las variables); `^` en Python (con una tasa
  decimal sí da error de tipo: ejecutado); la Motivación de la sección 3, que
  contradecía la clave de la pregunta 5; la leyenda de *J* y *m*; qué líneas no ocupan
  fila en una traza. De los bajos: un distractor cuya razón no daba su cifra, la opción
  del comparador de las dos mitades, «como enseña el apartado siguiente», «no hay forma
  de saber», «media tasa», «la regla práctica», el rótulo del orden equivocado, el
  título de la precedencia, la sigla CDT, la solución del reto y la nota del primer
  bloque («de Python o el de R»).
- **Vault.** Doce notas que seguían como `citada` sin fuente o `reescribir` quedaron en
  `criterio` o `remision`, con su razón.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan y el
capítulo 3 sale «OK». Sonda en `file`, 375 y 320: 7 de 7 lecciones, sin errores.

**Anotado y sin corregir, con su razón.** El flujograma de la sección 1 lee los datos y
el bloque los asigna (el flujograma es del algoritmo general; se dejó). El ejercicio de
emparejar se resuelve en parte por eliminación. La variable temporal: el texto ya dice
«con dos asignaciones sueltas» y «en este algoritmo»; la asignación múltiple de Python
no es del curso. El pseudocódigo declara `0.0200` sin instrucción de formato. «Cada una
exactamente una vez» frente al `Mientras` de la portada. «Acumulador» aparece una vez
antes de definirse. *d* y *n* sin decir que van en la misma unidad. «Causación», «mora»
y «XOR» sin glosa. Tildes desiguales en comentarios de código. El comentario interno
llama «Estructuras secuenciales» a la tarea que la ficha llama «Estructuras de Control
Secuencial»: va con el cotejo pendiente contra el syllabus `.xlsx`.

**Lo que sigue sin comprobar.** Que los pasajes del vault sean literales (el verificador
comparó capítulo contra nota, no nota contra fuente). La vigencia del 2,5 % y del 4 %
después del Decreto 572 de 2025 y la de la Ley 2381 de 2024 en pensiones. La prueba en
el iPhone.

**Hueco de las herramientas.** Una nota puede quedar en `clase: citada` con
`estado: sin-fuente` indefinidamente: `registrar_afirmaciones.py` solo mira las
verificadas y nada avisa de las otras. Las doce de este capítulo las encontró el
verificador final, no una regla.

### 2026-11-16 — Capítulo 3 publicado; capítulo 4, línea base y plan

- **Capítulo 3.** Fusionado a `main` (`b3e13e3`) con la aprobación del docente y subido a
  GitHub por orden suya. La prueba en el iPhone quedó parcial: el capítulo carga y se ve
  bien al 100 % en la portada, la ficha y el inicio de la lección 3, pero la ventana de
  «iPhone Mirroring» no deja desplazar la página (la rueda no llega y el arrastre
  selecciona texto), así que no se recorrieron las lecciones ni se probó el 125 %.
- **Capítulo 4.** `PLAN_TAREA14_CAPITULO_04_CONTENIDO.md`, rama `claude/cap04-plan`.
  Línea base de un lector sin contexto: ningún hallazgo alto, 12 medios y 24 bajos; las
  22 salidas de Python y R coinciden. El capítulo no tiene citas ni casos declarados, y
  da por ciertas la retención por servicios, la UVT, la mora topada por la usura y «lo
  que la norma llama fraccionamiento». El plan espera las decisiones A–I del docente.

**Hueco de las herramientas.** La regla 32 avisa de «DIAN» y «tasa de usura», pero no ve
«retención», «UVT» ni «la norma»: en el capítulo 4 se le pasan tres de las cinco
afirmaciones normativas. Queda anotado para ampliar su vocabulario con su prueba
negativa, en la fase 9 de ese capítulo.

### 2026-11-16 — Capítulo 4, fase 1: inventario y normas

Rama `claude/cap04-fase1`, sobre la del plan. El capítulo no se tocó.

- **Vault.** 224 notas de afirmación (31 que piden fuente, 26 ejecutadas, 70 derivadas,
  21 ilustrativas, 44 de criterio y 32 remisiones), 39 de figura, 21 de concepto y 11 de
  hilo narrativo. Sin duplicados: esta vez no aparecieron las copias del capítulo 3.
- **Normas leídas en su página oficial.** El 4 % y el 6 % de la retención por servicios
  están respaldados (Decreto 1625, art. 1.2.4.4.14; Estatuto Tributario, art. 392). **La
  base mínima es de 2 UVT desde el Decreto 572 de 2025, y el capítulo dice 4**: el
  docente decidió usar 2. La UVT la publica el Director de la DIAN antes de cada 1.º de
  enero (art. 868). La frase de la mora dice más de lo leído (Ley 45 de 1990, arts. 65 y
  69; Código de Comercio, art. 884). «Fraccionamiento de pagos» no es de ninguna norma:
  son dos conceptos de la DIAN de 2025, y uno dice que la base se mira pago a pago.
- **Zotero.** Tanda 06 importada con la aprobación del docente (cuatro referencias) y
  exportada a `referencias.json`.
- **De paso, el capítulo 3.** El Decreto 572 de 2025 no cambió el 2,5 % ni el 4 % que ese
  capítulo cita: se cierra la duda de vigencia anotada en su fase 10.
- **Cinco defectos nuevos** que la línea base no traía (un bloque que usa variables sin
  asignar, puntas de flecha rellenas, dos notas que regalan la traza, una traza de
  cuatro reglas donde el texto dice cinco, una frase sin referente). Están en el plan.

**Lo que no se hizo.** No se ejecutó VBA. No se cotejaron las remisiones a los capítulos
1, 3 y 5 ni al syllabus. No se leyó la resolución con el valor de la UVT de 2026: el
capítulo conserva su 50 000 redondeado y declarado. No se leyó el Código Penal más allá
de su artículo 305, que no se propone para Zotero.

**Hueco de las herramientas.** Zotero tenía seleccionada una colección de otro curso
con el mismo nombre («4 Datos y software», de Teoría del Riesgo): la comprobación previa
del identificador lo detuvo, pero `connector/import` no deja elegir la colección por
parámetro y hay que cambiarla a mano en la ventana. Y el lector de línea base dio por
buena la base de 4 UVT: una lectura crítica sin acceso a la norma no detecta una norma
que cambió.

### 2026-11-16 — Capítulo 4, fase 2: sección 1, La condición

Rama `claude/cap04-fase2`, sobre la fase 1. Ninguna cita nueva.

- Las remisiones al capítulo 1 (operadores, tablas de verdad, aviso de VBA) y al capítulo
  3 (quinta fila de la tabla de precedencia) se cotejaron con los capítulos publicados:
  coinciden.
- Un `<Ilustrativo>` declara inventados la regla de aprobación, sus umbrales, los
  solicitantes y los casos de los dos ejercicios.
- Fuera lo que nadie leyó o es opinión: las fechas de De Morgan, «muy endeudado», «los
  que un analista habría detenido sin dudar», «es el caso de la portada». «La forma de
  conseguir el mismo efecto en VBA» pasó a «una forma».
- Lo que la sección dice de la precedencia en Python y R se ejecutó: coincide.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
4 conserva sus dos avisos de línea base (figuras sin fuente, de la fase 9, y dos normas
sin cita, de las fases 3 y 7). Sonda a 320: 8 de 8 lecciones.

**Lo que no se hizo.** Lo que la sección afirma de VBA —que `\` y `Mod` van por debajo de
`*` y `/`, y que la guardia se detiene con el error 6 o el 11— sigue sin ejecutar: va a
Excel en la fase 10. Las cinco tablas y el evaluador siguen sin `<Fuente>` (fase 9).

### 2026-11-16 — Capítulo 4, fase 3: sección 2, Si…Entonces

Rama `claude/cap04-fase3`, sobre la fase 2. Entran las dos primeras citas del capítulo, la
lista «Referencias» generada y `afirmaciones/04.yaml`.

- **La mora.** Salió «en Colombia, el cobro por mora está topado por la tasa de usura y
  se liquida sobre lo vencido», que decía más de lo leído. Queda lo que sí está: un
  recargo por el simple retardo de una obligación dineraria es interés de mora (Ley 45
  de 1990, art. 65), y en los negocios mercantiles el interés moratorio no pactado es
  una y media veces el bancario corriente (Código de Comercio, art. 884). El verificador
  sin contexto dio las dos por parciales —faltaba «de una obligación dineraria», y «el
  interés de mora tiene límite» afirmaba un tope general— y se adoptó su redacción.
- **Un bloque que no corría.** `EJ_GUARDIA_SI` usaba `compras` y `total` sin asignarlas;
  ahora las asigna en los cuatro lenguajes. Ejecutado en Python y R.
- La nota del bloque de la mora ya no da el resultado de la traza que sigue. «Cambie el
  30 por un 31» decía cuál de los dos treintas. La traza dice qué líneas no ocupan fila
  y que la raya se anota también en VBA. El ejercicio de ordenar dice dónde están los
  datos en VBA.
- Un `<Ilustrativo>` declara el caso de la mora.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan. Al capítulo
4 le quedan dos avisos: las 13 figuras sin fuente (fase 9) y «DIAN» sin cita (fase 7); el
de «tasa de usura» desapareció con la frase. Sonda a 320: 8 de 8 lecciones.

**Lo que no se hizo.** Que `Dim` deje en 0 una variable en VBA sigue sin ejecutar (fase
10). El video del syllabus no se abrió ni se cotejó contra el `.xlsx` (fase 10). La Ley
510 de 1999, que dio su texto actual al artículo 884, no está en Zotero y no se cita.

### 2026-11-16 — Capítulo 4, fase 4: sección 3, Si…Sino

Rama `claude/cap04-fase4`, sobre la fase 3. Ninguna cita nueva; no se tocó código ni
salidas.

- **La tarifa plena tiene una sola definición** (decisión F): plena para todo cliente no
  preferencial, que es lo que el código ya hacía. «Transacciones de más de un millón» es
  la condición equivocada de la anécdota, no la regla. Salieron «para casi todos los
  clientes daba igual», que contradecía al cliente de 800 000, y «durante un trimestre».
- Un `<Ilustrativo>` declara las tarifas, el umbral, los clientes y las cuatrocientas
  transacciones.
- La nota del primer bloque ya no da el resultado de la traza. La traza dice qué líneas
  no ocupan fila. El pie del flujograma dice que él lee los datos y los bloques los
  traen asignados. Las dos reglas de los símbolos que son convención dicen «en este
  curso», como en el capítulo 2.
- Dos opiniones fuera.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; al capítulo
4 le quedan los mismos dos avisos (figuras, fase 9; «DIAN», fase 7). Sonda a 320: 8 de 8.

**Lo que no se hizo.** VBA sin ejecutar y el video del syllabus sin cotejar (fase 10).

### 2026-11-16 — Capítulo 4, fase 5: sección 4, la cascada

Rama `claude/cap04-fase5`, sobre la fase 4. Ninguna cita nueva.

- **Los conteos de la política.** Son cuatro condiciones y un caso por defecto; con el
  orden equivocado, al solicitante de ingresos altos se le evalúa la primera y las otras
  tres no llegan a mirarse. El gancho de la sección y la nota del bloque lo dicen así. La
  portada y la sección 6, que cuentan «cuatro», se igualan en sus fases.
- **La traza guiada** usa una versión de cuatro reglas; su enunciado ahora lo dice.
- **R.** `cat(decision, "\n")` dejaba un espacio antes del salto de línea; los tres
  bloques usan `cat(sprintf("%s\n", decision))`, como el resto del capítulo.
- **La equivalencia** entre la versión anidada y la cascada se reprodujo en Python sobre
  115 884 combinaciones, sin diferencias. El comentario decía «36 456», que no se podía
  reproducir desde el archivo; ahora dice la rejilla.
- Un `<Ilustrativo>` declara la política, sus umbrales, los solicitantes y las mil
  solicitudes. Cinco opiniones fuera.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; al capítulo
4 le quedan los mismos dos avisos. Sonda a 320: 8 de 8.

**Lo que no se hizo.** VBA sin ejecutar (fase 10).

### 2026-11-16 — Capítulo 4, fase 6: sección 5, Segun

Rama `claude/cap04-fase6`, sobre la fase 5. Ninguna cita nueva; cambia un bloque.

- **El caso por defecto de los tramos** (decisión G). `EJ_SEGUN_RANGOS` cobraba 25 000, la
  tarifa más alta, a una devolución, a un cero y a un monto con centavos entre dos
  tramos. Ahora el caso por defecto deja la tarifa en 0 y escribe «Monto fuera de la
  escala: a revision», en los cuatro lenguajes. Ejecutado en Python y R con seis montos,
  bordes incluidos.
- **Desviación de lo aprobado.** G pedía también dejar explícito el último tramo. El
  pseudocódigo del curso no tiene cómo escribir un tramo abierto («más de 5 000 000»),
  así que el tramo implícito de 25 000 se quitó: la escala son tres tramos y lo demás va
  al aviso. El comparador y el panel interactivo conservan la cascada con `Sino` de
  25 000, que es la versión defectuosa que ese ejercicio discute.
- Fuera lo que nadie leyó o es opinión: «lo hereda de la familia BASIC», «de las pocas
  cosas que VBA hace mejor», «`match` exige 3.10». La definición de selectiva múltiple ya
  no exige caso por defecto. «De los pocos puntos del curso» pasó a «uno de los dos
  puntos de este capítulo». El ejercicio de ordenar dice que es una versión reducida.
- Un `<Ilustrativo>` declara las cuotas, la escala y los doce tramos.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; al capítulo
4 le quedan los mismos dos avisos. Sonda a 320: 8 de 8.

**Lo que no se hizo.** Lo que la sección dice de VBA —`Case 1 To 100000`, que
`1 <= m <= 100000` da siempre `True`, que la variable conserva su valor— sigue sin
ejecutar (fase 10). La pregunta `segun_sin_defecto` del banco no se ha mirado contra el
bloque nuevo (fase 10). «El capítulo 6 vuelve sobre esto» es una promesa a un capítulo
que no existe todavía.

**Hueco de las herramientas.** El pseudocódigo del curso no tiene notación para un tramo
abierto en un `Segun`; LP-CORE lo resalta, pero ningún documento dice qué se puede
escribir después de `Caso`. Queda anotado para el README.

### 2026-11-16 — Capítulo 4, fase 7: sección 6, casos financieros

Rama `claude/cap04-fase7`, sobre la fase 6. Entran ocho citas; el capítulo queda con diez.

- **La base mínima a 2 UVT.** Cambió en el código de los cuatro lenguajes, en la traza y
  en sus filas. Con la UVT de 50 000 la base baja de 200 000 a 100 000, y tres casos
  dejaban de servir: el pago de la traza y los tres pagos del reto pasaron de 150 000 a
  80 000, y la pregunta 9 del cuestionario, de 180 000 a 80 000. Las salidas del bloque
  principal no cambian.
- **Las tres cifras llevan cita**: 2 UVT y 4 % (Decreto 1625, arts. 1.2.4.4.1 y
  1.2.4.4.14) y 6 % (Estatuto Tributario, art. 392). El `<Ilustrativo>` declara los
  supuestos que esas normas exigen, incluida la persona natural no declarante que supera
  3 300 UVT, con su cita.
- **La UVT.** Con cita del artículo 868. Salieron «redondeada» y «no es el valor real»:
  suponían un valor vigente que nadie leyó. Ahora es «un número redondo… no se tomó de la
  resolución de ningún año».
- **El reto del fraccionamiento.** Ya no atribuye a «la norma» lo que es doctrina de la
  DIAN, ni propone sumar los pagos del mes, que contradecía el Concepto 012327 de 2025.
  Cita los dos conceptos y pregunta qué dato haría falta para revisar un fraccionamiento.
- **Verificador sin contexto**: de siete citas, cinco respaldadas y dos parciales; se
  adoptó su redacción. Encontró además una norma afirmada sin cita dentro del
  `<Ilustrativo>` y el «redondeada» sin respaldo.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan. Al capítulo
4 solo le queda el aviso de las 13 figuras sin fuente (fase 9). Sonda a 320: 8 de 8.

**Lo que no se hizo.** VBA sin ejecutar (fase 10). No se leyó la resolución con el valor
de la UVT de ningún año. El inciso cuarto del artículo 392, al que remite el artículo
1.2.4.4.14, no se leyó con su numeración: el `<Ilustrativo>` dice «al servicio le aplican
las tarifas de los dos artículos citados» en vez de afirmar qué servicios tienen tarifa
propia.

**Hueco de las herramientas.** La regla de cobertura del cuestionario cuenta la cadena
«pregunta:» dentro de una justificación como si fuera otra pregunta: una frase que
terminaba en «lo que se pregunta:» hizo fallar el verificador con un mensaje que apunta
a la primera línea del `Quiz`. Y las notas de fuente que genera `generar_tanda.py`
conservan «sin importar» después de la importación: nada las actualiza.

### 2026-11-17 — Capítulo 4, fase 8: portada, evaluación y glosario

Rama `claude/cap04-fase8`, sobre la fase 7. Ninguna cita nueva.

- **Portada.** Un `<Ilustrativo>` declara el comité, los 40 millones y la política de cinco
  reglas. El conteo quedó igual que en las secciones 4 y 6: tres de las cuatro
  condiciones no llegaron a mirarse. Salió «es el primero donde esas diferencias deciden
  el resultado de un programa», que contradecía al capítulo 3 ya publicado.
- **Cuestionario.** La justificación falsa sobre invertir los operandos en VBA; el
  distractor que daba la misma cifra que la clave; la pregunta de `switch`, que ahora
  dice «tal cual, igualando el valor con cada caso»; la frase sin referente. Fuera dos
  afirmaciones sobre otros lenguajes que nadie leyó («eso lo hacen otros lenguajes»,
  «AndAlso es de VB.NET»).
- **Glosario.** La selectiva múltiple admite tramos donde el lenguaje lo permite; el caso
  por defecto se enuncia como criterio del curso.
- **Remisiones** al capítulo 3 y al 5 cotejadas con los capítulos publicados: coinciden.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; al capítulo
4 solo le queda el aviso de las figuras (fase 9). Sonda a 320: 8 de 8. En el vault no
queda ninguna nota `citada` sin fuente ni `reescribir`.

**Lo que no se hizo.** El lema del curso, «el lenguaje solo cambia de acento», no se
tocó: lo llevan también los capítulos 3 y 5, y es decisión del docente. Las remisiones
al syllabus y lo que el cuestionario dice de VBA (`AndAlso`, errores 6 y 11) esperan a
la fase 10.

### 2026-11-17 — Capítulo 4, fase 9: figuras y la regla 32

Rama `claude/cap04-fase9`, sobre la fase 8. No hizo falta tocar LP-CORE.

- **Figuras.** Las 13 figuras y tablas sin fuente del capítulo 4 tienen `<Fuente propia>`
  o su marca razonada. El capítulo pasa `verificar.py` sin ningún aviso.
- **Flechas.** Los flujogramas dibujan la punta abierta, como en los capítulos 2 y 3.
  Mirado en el navegador integrado.
- **Regla 32.** Su léxico incluye ahora «la norma», «la ley» y «la regulación» dichas sin
  nombre, y la UVT. Ocho pruebas negativas sobre una copia del capítulo 4, anotadas en
  `verificar.py`. Al correrla sobre los cinco capítulos encontró nueve menciones, en el
  2, el 3 y el 4: todas eran remisiones a una norma ya citada, y llevan `fuente-ok`. En
  el capítulo 3 se cambió una frase («de los artículos citados en las secciones 1 y 4»)
  porque la marca no cabe en medio del texto de un párrafo. El README lo explica.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; los
capítulos 1 a 4 salen «OK». Sonda a 320 en los capítulos 2, 3 y 4, y de escritorio en
el 4.

**Lo que no se hizo.** Las 28 notas de figura que son bloques, trazas o ejercicios no se
miraron una por una en el navegador: se revisaron por su contenido en las fases 2 a 8 y
las recorre la sonda. El capítulo 5 tiene el mismo marcador de flecha rellena y 23
figuras sin fuente: es de su propia tarea.

**Hueco de las herramientas.** La marca `fuente-ok` no se puede poner en medio del texto
de un párrafo JSX sin partirlo; y entre los atributos de un componente se escribe sin
llaves. No estaba dicho en ningún sitio: ahora está en el README.

### 2026-11-17 — Capítulo 4, fase 10 (a medias): syllabus, remisiones y banco

Rama `claude/cap04-fase10`, sobre la fase 9. **Falta el VBA en Excel y la prueba en el
iPhone.**

- **Syllabus.** La portada se cotejó contra el `.xlsx` leído directamente: resultado de
  aprendizaje (fila 31), contenido, 8 horas, taller, formato y videos (fila 34) y rúbrica
  (fila 44). Coincide. Los cuatro videos existen; no se vieron. De paso se cerró un
  pendiente del capítulo 3: su ficha usa el nombre de la actividad y su comentario
  interno el del entregable, y los dos son del syllabus (fila 33).
- **Remisiones.** Lo que los capítulos 1, 3 y 5 dicen del 4 —diecisiete remisiones—
  coincide con el capítulo revisado. No hubo que tocar el capítulo 5.
- **Banco Moodle.** Las cinco preguntas se revisaron contra el capítulo: las cinco claves
  siguen siendo correctas (ningún fallo en 3 000 semillas por pregunta, recalculadas por
  dos caminos) y ninguna usa la UVT ni la escala que cambió. Los cinco borradores, que
  ajustan la redacción, compilan y están en el vault con su nota. **No se copió nada al
  banco.**
- **Del cotejo con el banco.** Una pregunta asigna un valor en el caso por defecto porque
  la política del enunciado lo dice, y el capítulo decía que ese caso «se usa para
  avisar». El glosario y el reto de la sección 5 dicen ahora: hace lo que la regla diga
  para lo demás y, si la regla no lo dice, avisa.

**Lo que no se hizo.** El VBA: el módulo está preparado (12 bloques y 15 pruebas de
lenguaje), pero Excel no admite pegar en segundo plano y el docente estaba trabajando en
otra aplicación; se dejó de insistir. La prueba en el iPhone, que hace el docente.

**Hueco de las herramientas.** Esta fase se cortó a media mañana por un error de red y
se retomó horas después sin memoria de lo hecho: lo que la salvó fue que el vault y el
scratchpad tenían el trabajo a medias, no ningún registro del estado. Una fase larga
debería anotar en la nota del capítulo qué partes lleva, a medida que las cierra. Y
`ejecutar_vba.py` sigue dependiendo de un pegado a mano que quita la pantalla.

### 2026-11-17 — Capítulo 4, fase 10: el VBA, ejecutado en Excel

Misma rama. El docente pidió que el módulo lo pegara la sesión; con Excel al frente se
pegó de una vez.

- **Bloques.** Los 9 con salida declarada coinciden con Excel. `EJ_GUARDIA` se detiene
  con el error 6, como dice el capítulo; `EJ_GUARDIA_SI`, corregido en la fase 3, no
  falla.
- **Quince pruebas de lenguaje**, escritas para lo que el capítulo afirma de VBA y nadie
  había ejecutado: `\` y `Mod` van por debajo de `*`; `Dim` deja una variable en 0; 0
  entre 0 da el error 6 y un divisor cero el 11; `And` evalúa los dos lados;
  `1 <= m <= 100000` da siempre `True`; `Case … To` y las listas funcionan; sin
  `Case Else` la variable conserva su valor; `Not` va por debajo de los relacionales y
  `And` por encima de `Or`. Las quince confirman el texto.
- **Lo único que no se ejecutó: `AndAlso`.** Un módulo que no compila bloquea el arnés
  entero. La justificación de la pregunta 7 ya no lo nombra: dice que el material no ha
  encontrado en VBA un operador lógico que deje de evaluar el segundo.

**Verificación.** `verificar.py`: los cinco pasan; el capítulo 4, «OK». En el vault, de
229 notas del capítulo quedan dos abiertas a propósito: el lema del curso (decisión del
docente) y la promesa al capítulo 6.

**Lo que no se hizo.** La prueba en el iPhone, que hace el docente.

**Hueco de las herramientas.** El archivo que escribe una macro queda dentro del
contenedor de Excel y no se puede leer desde la terminal; se leyó abriéndolo con el
propio Excel por AppleScript. `ejecutar_vba.py` lo resuelve devolviendo el texto desde
la macro: una prueba suelta debe hacer lo mismo.

### 2026-11-17 — Capítulo 4, fase 11: lectura crítica final

Rama `claude/cap04-fase11`. Dos lectores independientes, sin permiso de edición.

- **Verificador de citas:** las 10 citas, respaldadas por su pasaje; registro y anclas
  coinciden una a una. Dos frases sin cita decían más que la norma y se corrigieron: la
  justificación de la pregunta 9 («cuando el pago llega al umbral», no «por encima») y el
  reto de la sección 6 (el concepto habla del total de los pagos efectuados, sin «a cada
  proveedor en el período»).
- **Lector sin contexto:** ningún hallazgo alto; rehízo las cuentas y ejecutó Python y R,
  y todo coincide. De 11 medios y 16 bajos se corrigieron: el `Sino` de 25 000 de la
  cascada del comparador queda nombrado como resultado inventado; el caso por defecto
  «pone 0 como marca» (texto y comentarios de los cuatro bloques); `<Ilustrativo>` en la
  evaluación; la etiqueta de 1 500 000 («el límite del codeudor: ya no aplica»); el
  expediente «se queda sin la marca de revisión», no «pasa automático»; «en VBA este
  capítulo escribe dos Si», no «VBA necesita»; las dos `Fuente` que afirman cosas de VBA
  dicen que se ejecutó en Excel; y siete de redacción.
- **Anotados sin corregir, con su razón:** `AndAlso` (no se ejecutó y no hay fuente en
  Zotero para decir que no existe en VBA); «match exige Python 3.10» (se quitó en la
  fase 6 por no tener fuente; sigue pendiente de una referencia); que los 2 UVT rigen
  desde 2025 y la referencia lleva año 2016; términos del dominio sin definir (UVT sin
  expandir, agente retenedor, bancario corriente); «guarda» frente a «guardia»; tres
  claves marginalmente más largas; y los criterios del curso redactados como tales.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el
capítulo 4, «OK». Sonda en `file`, 375 y 320: 8 de 8 lecciones, sin errores de JS.

**Lo que no se hizo.** La prueba en el iPhone (el docente, antes de publicar). En el
vault, 42 notas no citadas conservan anclas o nombres de archivo de la línea base: la
regla 31 solo vigila las del yaml.

**Hueco de las herramientas.** Nada avisa cuando el ancla de una nota no citada deja de
estar en el capítulo; `registrar_afirmaciones.py` solo comprueba las citadas.

### 2026-11-17 — Capítulo 4, pendientes de la fase 11

Rama `claude/cap04-pendientes`, sobre `main` ya publicado. Decisiones del docente del
mismo día.

- **Lema del curso: se deja y se matiza.** No cambia en los capítulos 3, 4 y 5; la
  portada del 4 dice que este capítulo trae su primera excepción.
- **`AndAlso`:** la sección 1 enumera los seis operadores lógicos de la tabla de
  precedencia de la especificación de VBA (`microsoft2026vbal`, §5.6.9.1, que ya estaba
  en Zotero) y dice que `AndAlso` no está entre ellos. La pregunta 7 remite a eso. No
  hizo falta importar la página de Microsoft Learn. Sigue sin ejecutarse en Excel.
- **`match` desde Python 3.10:** tanda 07, una referencia (`psf2026match`), importada a
  Zotero con la aprobación del docente. La sección 5 lo dice en el texto visible.
- **2 UVT:** el texto dice que es el que dejó el Decreto 572 de 2025, con la cita del
  concepto 012327 de la DIAN (num. 3), y expande la sigla UVT.
- **Verificador independiente:** dos citas respaldadas y una parcial («los bloques de
  esta sección que la usan», no todos); se adoptó su redacción en las tres.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
4, «OK», con 13 citas registradas. Sonda a 320: 8 de 8.

**Lo que no se hizo.** Definir en el texto «agente retenedor» y «bancario corriente»;
unificar «guarda» y «guardia». Los borradores del banco Moodle se resuelven en el vault
y no se copian al banco.

### Capítulo 4, cabos sueltos: tres términos · 2026-11-18

Rama `claude/cap04-terminos`, sobre `main` (`7a98d2c`). Cierra lo que la entrada
anterior dejó sin hacer.

- **«Agente retenedor»:** la sección 6 dice que el Estatuto Tributario llama agentes de
  retención a quienes, por sus funciones, intervienen en actos u operaciones en los que
  la ley les ordena retener (art. 368, leído en la Secretaría del Senado), y que el
  capítulo usa «agentes retenedores», como el Decreto 1625. El Estatuto ya estaba en
  Zotero.
- **«Bancario corriente»:** la sección 2 dice «interés bancario corriente» y que, según
  el mismo artículo 884, se prueba con certificado de la Superintendencia Bancaria. El
  capítulo no dice cómo se llama hoy esa entidad: el pasaje no lo permite.
- **«Guarda» y «guardia»:** no se unifican, porque nombran cosas distintas. La sección 5
  dice que la guarda de `match` es lo que la referencia de Python llama *guard* (§8.6.2,
  con cita) y que no es la condición guardia de la sección 1.
- **Verificador independiente:** las tres primeras redacciones salieron parciales y se
  adoptó la suya; la de la guarda, ya con cita, respalda.
- **Excel, el mismo día:** `AndAlso` no compila («Compile error: Syntax error»), y la
  división entre `Currency` da el error 11, o el 6 si es 0 entre 0.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
4, «OK», con 15 citas registradas. Sonda a 320: 8 de 8.

**Hueco de las herramientas.** `verificar_cloze.R` del banco valida cada sorteo con
bandas de longitud fijas, calibradas sobre la redacción anterior de las opciones: al
cambiar una opción hay que volver a medirlas (pasó con `segun_sin_defecto` y con
`variable_o_constante`). Nada lo avisa antes de copiar.

### Tarea 15 · Capítulo 5, mejora de contenido: fases 1 y 2 · 2026-11-19 y 2026-11-20

Plan: `PLAN_TAREA15_CAPITULO_05_CONTENIDO.md`, doce fases, aprobado por el docente el
2026-11-19 con la opción recomendada en las ocho decisiones.

**Fase 1, línea base y fuentes** (rama `claude/cap05-fase1`).
- Lectura crítica independiente: ningún alto, 7 medios y 9 bajos.
- Inventario en el vault: 243 afirmaciones, 49 figuras, 63 conceptos y 43 hilos; 69
  afirmaciones piden reescribirse. Treinta defectos que la lectura crítica no traía.
- Leídos el artículo 305 del Código Penal y cuatro páginas de Microsoft Learn
  (`For...Next`, `Dim`, `Integer`, el error 6). Tanda 08 importada a Zotero con la
  aprobación del docente: 53 referencias.
- Excel: los once bloques de VBA con salida declarada coinciden; la cuota 37 da 37.

**Fase 2, sección 1** (rama `claude/cap05-fase2`).
- El caso de la clienta lleva su `<Ilustrativo>`.
- El contador se define por la ocurrencia, y el acumulador incluye el de producto, que la
  tabla de la misma sección ya traía.
- El recuadro de tasas declara ilustrativas las siete del capítulo, con sus equivalentes
  anuales, y la frase de la usura dice lo que dice el artículo 305, con cita. El
  verificador independiente la dio por parcial («una tasa real se mira contra ese
  interés» quitaba el umbral de la mitad) y se adoptó su redacción.
- El corte de 30 días de mora se declara convención del ejemplo; la pregunta ya no dice
  «qué muestra el programa», porque cada lenguaje escribe la cifra a su manera; la pista
  del ejercicio de ordenar nombra las cuatro líneas que van fuera del ciclo.
- El capítulo estrena `<Referencias />` y `afirmaciones/05.yaml`, con una cita.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5 queda con un solo aviso, las 23 figuras sin fuente (fase 10). Sonda a 320: 9 de 9.

**Huecos de las herramientas.**
- La regla 30 no ve el comparador de los tres ciclos ni las tablas de `TablaTraza` y
  `Trazador`: el inventario cuenta 49 figuras y el verificador, 23. Se decide en la fase
  10.
- Zotero rechaza una segunda importación por el conector con `SESSION_EXISTS` y no
  importa nada: hay que pasar `?session=` propio. El primer intento falló en silencio
  hasta que se exportó la colección y faltaban cuatro claves.
- Cuando una corrección cambia el texto de una afirmación que no es `citada`, el ancla de
  su nota del vault se pierde y nada lo avisa: en esta fase se perdieron cinco y se
  repusieron a mano.

### Tarea 15 · Capítulo 5, fase 3: sección 2, Mientras · 2026-11-20

Rama `claude/cap05-fase3`, sobre la de la fase 2.

- El caso del acuerdo de pago lleva su `<Ilustrativo>`.
- **`While … Wend`:** salió «más antigua», que ninguna fuente leída dice. La fila de VBA
  dice ahora que `While … Wend` solo pregunta antes de cada vuelta y que `Do` admite la
  condición al principio o al final, con `While` o con `Until`, con cita a la
  especificación del lenguaje (§5.4.2.2 y §5.4.2.6), que ya estaba en Zotero.
- **`Dim`:** «una variable numérica declarada con Dim se inicializa en 0», con cita a la
  página de la instrucción. Todas las declaraciones del capítulo llevan su tipo: ninguna
  es una `Variant`, que se inicializaría en `Empty`.
- **Simbología del flujograma:** dice «en este curso» donde la del capítulo 4, declara
  el retorno como añadido del curso y cambia de título.
- Las llaves de R se dicen como forma del curso; la actualización, como lo que detiene a
  un Mientras; y la nota de la traza avisa de que no se detiene en la línea de cierre.
- Verificador independiente: las tres citas respaldan; se adoptaron dos ajustes suyos de
  redacción.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con cuatro citas registradas y el aviso de las 23 figuras. Sonda a 320 y en
escritorio: 9 de 9.

### Tarea 15 · Capítulo 5, fase 4: sección 3, Repita…Hasta · 2026-11-21

Rama `claude/cap05-fase4`, sobre la de la fase 3.

- **Motivación (N6):** salió la cifra de 916 799,93, que era la cuota de un crédito que
  el capítulo no presenta hasta la sección 4. «A paz y salvo» se define en el sitio, y un
  `<Ilustrativo>` declara inventados el banco y sus dos rutinas.
- **Python:** «No tiene la estructura» pasó a «Python repite con while y con for, y el
  while prueba la condición antes de cada vuelta», con cita a la referencia del lenguaje
  (§8.2 y §8.3). La página no afirma que falte un ciclo de evaluación posterior: el
  recuadro del `break` lo dice como derivada, y ya no dice «no tienen otra forma de
  preguntar al final». Cerrar el Repita con `break` queda escrito como decisión del curso.
- **VBA:** el recuadro de las cuatro combinaciones lleva cita a la especificación
  (§5.4.2.6), escribe la equivalencia como la da la fuente (`Do Until c` = `Do While Not
  (c)`) y avisa del `Do` sin condición, que solo para con `Exit Do`; el capítulo no lo usa.
- **Actualización:** en un Repita, el cuerpo tiene que poder volver verdadera la
  condición; en la validación lo hace la lectura.
- **Flujograma del Repita:** el cuerpo dibuja las dos instrucciones del código (el
  mensaje, abreviado, y la lectura). Visto en el navegador: el texto cabe.
- El bloque se titula «hasta que sea positivo» y su nota dice que solo mira el signo.
  «Lo que sigue» ya no dice «este mismo cobro».
- Verificador independiente: «parcial» a la cita de Python (se adoptaron su redacción y
  su localización) y «respalda» a la de VBA (se adoptaron dos ajustes).

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con seis citas registradas y el aviso de las 23 figuras. Sonda a 320 y en
escritorio: 9 de 9.

### Tarea 15 · Capítulo 5, fase 5: sección 4, Para · 2026-11-21

Rama `claude/cap05-fase5`, sobre la de la fase 4.

- **Motivación:** lleva su `<Ilustrativo>` y define el paz y salvo.
- **El recuadro del banco (decisión B):** ya no dice qué hace «un banco». Se titula «Si la
  cuota se redondeara» y dice lo que se deduce: redondeada al peso, las doce cuotas no
  dejan el saldo en cero y habría que ajustar la última.
- **El for de cada lenguaje, con cita:** `For...Next` de VBA (Microsoft Learn, Sintaxis y
  Comentarios), el `for` de Python (§8.3) y el de R (§3.2.5). Salieron «no compara ni suma
  nada» y «ya hecha», que las fuentes no dicen; el contraste va después de la cita.
- **El contador cambiado en VBA:** salió el enlace crudo y «desaconseja»; va `<Cita>`, y la
  página «advierte» que «podría» ser más difícil de leer. «Una cuota de cada dos» queda
  como derivada: no está ejecutada en Excel (fase 11).
- **`range(1, n)`:** da n − 1 vueltas «si n es al menos 1» (B1).
- **La remisión rota al capítulo 1 (M1):** la cita entre comillas se cambió por la frase
  que el capítulo 1 tiene hoy, sin comillas.
- **Sin fuente, retirado:** «amortización francesa» (prosa, cuatro comentarios del código y
  la descripción del flujograma) y «off-by-one» (definición y glosario). En Zotero no hay
  ningún texto de matemáticas financieras ni de terminología que los respalde.
- **VBA:** el comentario ya no dice que con Currency el saldo cerraría en −0,0005, que
  nunca se ejecutó; el de Format dice lo ejecutado (Excel escribió coma); y la nota del
  plan dice que cabe esperar el mismo residuo, no que VBA lo guarda.
- La leyenda del flujograma y «En pseudocódigo, el contador lo lleva el ciclo» acotan lo
  que es de pseudocódigo y VBA (M2).
- Verificador independiente: «respalda» a una cita y «parcial» a tres; se adoptó su
  redacción en las tres.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con diez citas registradas y el aviso de las 23 figuras. Sonda a 320 y en
escritorio: 9 de 9.

**Huecos.** (1) El guion de edición no pone el espacio duro en las cifras nuevas si se
escriben con espacio normal: la regla de la cifra partible lo atrapó en tres sitios.
(2) «recorre una secuencia ya hecha» sigue en la sección 6 y en el glosario (fases 7 y
9), y el comentario de Format, en el simulador de la sección 5 (fase 6).

### Tarea 15 · Capítulo 5, fase 6: sección 5, ciclos anidados · 2026-11-21

Rama `claude/cap05-fase6`, sobre la de la fase 5.

- **Motivación:** lleva su `<Ilustrativo>`; las tres cifras salen de los dos simuladores,
  vueltos a ejecutar en Python y en R.
- **Quién mueve el contador (M2):** la nota de la traza ya no dice que la cabecera
  «aumenta» k en Python y R ni que «lo hace el Next» en VBA, que la página de `For...Next`
  no dice. En Python y R, el for le asigna el elemento siguiente; en VBA, el paso se suma
  al terminar la vuelta, y la traza lo marca en el `Next`.
- **El contador al salir:** Python y R lo dejan en 3 (ejecutado). Para VBA ya no se
  afirma: se deduce de lo citado en la sección 4 y se dice que no se ejecutó (fase 11).
- **El abono constante:** ya no es «otra forma de amortizar» (sin fuente en Zotero); es un
  supuesto declarado del reporte.
- **Comentario de `Format` del simulador:** sin el mecanismo regional; remite al plan de
  la sección 4.
- **Menores:** la cuenta de los 33 pasos aclara cómo se reparten en la pestaña de VBA
  (B6); «justo antes» pasó a «antes»; el comentario interno de `ORDENA_OFICINAS`, al día.
- Sin citas nuevas: ninguna afirmación de la sección pidió fuente externa, y no hubo
  verificador independiente. Las remisiones a la sección 1 y al capítulo 4, cotejadas.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con diez citas y el aviso de las 23 figuras. Sonda a 320 y en escritorio: 9 de 9.
**Pendiente:** las dos pestañas de VBA del simulador y el contador al salir del `For`,
en Excel (fase 11); la tabla y el flujograma, sin fuente declarada (fase 10).

### Tarea 15 · Capítulo 5, fase 7: sección 6, cuándo para un ciclo · 2026-11-21

Rama `claude/cap05-fase7`, sobre la de la fase 6.

- **Motivación:** lleva su `<Ilustrativo>` y dice que la cuota va sin redondear, como
  todas las del capítulo; así no choca con el recuadro del redondeo de la sección 4 (M4).
- **«Un Para termina siempre»:** ya no. Los Para del capítulo, que avanzan de uno en uno,
  terminan con las vueltas de su primera línea, con dos salvedades de VBA: tocar el
  contador y el paso de 0, con cita a `For...Next` (Comentarios). Salió «ni siquiera
  compara: recorre una secuencia ya hecha». La tabla final también lo dice.
- **El saldo que llega a cero:** sin fuente de matemáticas financieras, la propiedad se
  ejecutó con fracciones exactas (12 y 36 cuotas dan saldo 0) y el texto lo dice así.
- **El desbordamiento de VBA:** el rango de `Integer` y el error 6, con cita a sus dos
  páginas de Microsoft Learn, ya en Zotero. La vuelta 32 768 queda como deducción
  declarada, sin ejecutar. La consecuencia correcta del ejercicio vale ahora para VBA.
- **La regla del capítulo 1 (B2):** va con su condición, «dinero guardado en flotantes»,
  las dos veces.
- **La tabla de los seis créditos:** dice dónde se midió (Python y R; la fila de 37,
  también en Excel).
- **Menores:** «es muy difícil de auditar» (B4); el cuarto cuidado del reto ya no promete
  que `Currency` lleva el saldo a cero; el comentario interno de la cuota 37 registra la
  corrida de Excel del 2026-11-19.
- Verificador independiente: «respalda» a las tres citas; corrigió la localización de
  dos (esas páginas no tienen sección «Comentarios») y afinó la redacción del error 6.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con trece citas y el aviso de las 23 figuras. Sonda a 320 y en escritorio: 9 de 9.
**Hueco:** otra cifra nueva con espacio normal (−7,5 × 10⁻⁸); la atrapó la regla de la
cifra partible. **Pendiente (fase 11, Excel):** `Step 0`, el desbordamiento en la vuelta
32 768 y las otras cinco filas de la tabla.

### Tarea 15 · Capítulo 5, fase 8: sección 7, casos financieros · 2026-11-21

Rama `claude/cap05-fase8`, sobre la de la fase 7. Sin citas nuevas: no hay en Zotero
ningún texto de matemáticas financieras, y lo que pedía uno se derivó, se ejecutó o se
redactó como definición o supuesto del capítulo.

- **Motivación:** lleva su `<Ilustrativo>` (M5); la resta del cliente va con su
  aritmética a la vista.
- **Saldo insoluto:** la definición ya no afirma qué se paga al cancelar un crédito: es
  un supuesto del caso. El glosario dice lo mismo.
- **«No es casualidad»:** la igualdad entre el saldo y el valor presente de las cuotas
  que faltan se deriva a la vista, deshaciendo las cuotas desde el final, y se ejecutó
  con fracciones exactas (las dos cuentas dan la misma cifra).
- **La TIR:** la definición dice «en esta sección se toma como el costo del crédito
  contando la comisión». Salió «No hay una fórmula que la despeje» (N9), del texto, del
  glosario y del emparejamiento: «este capítulo no la despeja: la busca».
- **`uniroot`:** salió «un método más rápido»; van las 6 iteraciones contra las 17
  vueltas y la tolerancia por omisión con su valor, 0,00012 (ejecutado).
- **Menores:** fuera «el residuo de siempre» y «la cifra que el cliente verá en el
  extracto final»; 138 498,00 con sus decimales; lo pagado en la vivienda «son 120
  cuotas», y la remisión al interactivo queda para el saldo y los intereses.
- **VBA (M7):** el arnés nuevo (7a96ad5822) se pegó en Excel y los once bloques del
  capítulo coinciden, entre ellos los tres de la sección 7 y el simulador de la sección
  5. Ese Excel escribe coma decimal; la nota del primer bloque lo avisa.
- La bisección con tolerancia 10⁻¹⁸ (sección 6) se volvió a ejecutar: se queda en dos
  flotantes vecinos, 3,5 × 10⁻¹⁸, y no sale (probado hasta 2 000 vueltas).

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con trece citas y el aviso de las 23 figuras. Sonda a 320 y en escritorio: 9 de 9.
Cifras de la sección vueltas a ejecutar en Python y R. Remisiones a los capítulos 2 y 3,
cotejadas. **Hueco:** `ejecutar_vba.py preparar` deja el módulo en el portapapeles, y si
el docente copia otra cosa antes de pegar, se pega lo suyo: pasó una vez; se repitió
`preparar` y se pegó de inmediato. **Pendiente:** el interactivo de la TIR sin abrir en
navegador; su gráfica sin fuente (fase 10).

### Tarea 15 · Capítulo 5, fase 9: portada, evaluación, glosario y cierre · 2026-11-21

Rama `claude/cap05-fase9`, sobre la de la fase 8. Sin citas nuevas.

- **Portada:** la motivación lleva su `<Ilustrativo>` (M5); el mapa usa los títulos de
  la barra lateral (corregido en la fase 10: solo cambian los pasos 5 y 7); las cuatro diferencias entre lenguajes remiten a su sección (3 y 4),
  donde van las citas, y dicen que se ejecutaron, la de VBA en Excel (M6).
- **Evaluación:** la motivación de la auditoría y las situaciones del emparejamiento,
  declaradas como inventadas. Pregunta 3: el 0 del `Dim` remite a la sección 2, lo de
  `Option Explicit` se ejecutó en Excel y el mensaje de R ya no va como cita literal
  (N8). Pregunta 9: «Este Para termina», sin generalizar. Ninguna clave cambió.
- **Glosario:** acumulador y contador dicen lo mismo que sus `<Termino>` (B3); la
  evaluación previa ya no le atribuye una condición al `for` de Python y R (M2);
  `range(1, 12)` da once vueltas en vez de «n − 1» (B1); el Repita suma la forma de R; la
  variable de control pierde «ya hecha»; el VPN y la bisección, acotados a la sección 7;
  entra «paz y salvo» (B9). Son 21 entradas.
- **«Lo que viene»:** cotejado con el plan maestro del capítulo 6; dice que es lo que el
  plan anuncia y que el capítulo no está escrito; «por qué el dinero se guarda en
  Currency» pasó a «qué cambia al guardar…».
- **Promesas a los capítulos 6, 7 y 8:** cotejadas con el plan maestro y registradas como
  hilos abiertos en el vault; se cierran cuando existan esos capítulos.
- **VBA ejecutado en Excel** (módulo `PruebasFase9`, aparte del arnés): el acuerdo de
  pago sin inicializar da «Meses: 0» con `Option Explicit`; `k = k + 1` dentro de un
  `For` no da error (3 vueltas de 5); tras `For k = 1 To 3`, k queda en 4; `For 1 To 0`
  da cero vueltas; un `Integer` en 32 767 más 1 da el error 6; `Step 0` no avanza (1 000
  vueltas con salida de seguridad). Las secciones 5 y 6 ya lo dicen como ejecutado.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan; el capítulo
5, con trece citas y el aviso de las 23 figuras. Sonda a 320 y en escritorio: 9 de 9. El
arnés de VBA sigue coincidiendo en sus once bloques. **Hueco:** al pegar el módulo de
pruebas, un clic cayó en la ventana del libro y no en el editor; no se pegó nada en la
hoja (comprobado: A1:B3 vacías) y se repitió. `ejecutar_vba.py` no tiene una forma de
añadir pruebas sueltas sin pegar a mano. **Pendiente (fase 11):** el programa completo
hasta la vuelta 32 768 y las otras cinco filas de la tabla de créditos, en Excel.

### Tarea 15 · Capítulo 5, fase 10: figuras y tablas · 2026-11-21

Rama `claude/cap05-fase10`, sobre la de la fase 9. No se tocó LP-CORE.

- **Las 23 figuras y tablas sin fuente:** once con `<Fuente propia>` a la vista (las que
  traen datos o resumen secciones) y doce con `fuente-ok` y su motivo (flujogramas de
  casos ya declarados, la simbología, la ficha, dos índices, las negaciones y las tablas
  que calcula un interactivo). El aviso de la regla 30 desapareció.
- **Dos interactivos más**, que la regla no ve o ve a medias: `<Fuente propia>` tras la
  tabla de amortización y tras el comparador de los tres ciclos.
- **Formato de cifras (B8):** los tres interactivos escriben los miles con espacio, como
  la prosa, y el eje de la gráfica de la TIR también.
- **Tabla del Para:** la celda de VBA ya no atribuye la suma al `Next`. **Tabla de las
  tres formas:** el Para pregunta «si queda alguna por dar», no «contra un tope».
- **Simbología:** el retorno explica el punto relleno por el que entra al flujo.
- **Corrección a la fase 9:** el mapa de la portada había tomado cuatro títulos de
  `CONFIG.temas`, y la barra lateral usa los de la lista de lecciones. Los pasos 1 y 6
  volvieron a «Contar y acumular» y «Cuándo para»; solo cambian el 5 y el 7. Se vio al
  abrir el capítulo en el navegador.
- **Regla 30:** se decidió no ampliarla a `TablaTraza`, `Trazador` ni a los
  interactivos sin tabla; el motivo y qué hacer con un interactivo nuevo están en el
  README. Ahí quedó también cómo se redactan los hijos de `<Fuente propia>`.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan, y el
capítulo 5 sin avisos. Sonda a 320 y en escritorio: 9 de 9. En el navegador: las
secciones 4 y 7 con sus interactivos; la bisección da 17 vueltas y deja la TIR entre
1,9923401 % y 1,9924164 %. **Hallazgo fuera del capítulo:** en el capítulo 4, dos
`<Fuente propia>` empiezan por «elaboración propia» y se leen «Fuente: elaboración
propia elaboración propia; …» (líneas 3880 y 5732); otras dos y cinco del capítulo 2 y
del 3 quedan sin conector («elaboración propia convención del curso»). Va en la fase 11.
**Pendiente (fase 11):** el VBA del cierre de caja, que lee datos.

### Tarea 15 · Capítulo 5, fase 11: coherencia, banco, VBA y teléfono · 2026-11-21

Rama `claude/cap05-fase11`, sobre la de la fase 10.

- **Remisiones, en los dos sentidos:** lo que los capítulos 2, 3 y 4 dicen del 5 (la TIR
  que «el capítulo 5 calcula», las tablas de 240 filas, el acumulador dentro de un ciclo,
  el cierre del capítulo 4) y las cerca de treinta menciones del 5 a los capítulos 1 a
  4, cotejadas con el texto de hoy: todas se sostienen. La ficha de la portada, otra
  vez contra las filas 10, 31, 35 y 44 del syllabus. Hilos del vault al día.
- **VBA, todo ejecutado en Excel** (arnés 2165e82642, con `--incluir`, y un módulo
  `PruebasFase11`): los once bloques con salida coinciden; los cinco que leen datos dan
  lo que el capítulo dice (cartera en mora, las dos validaciones, «4 pagos por 799999» y
  «3 pagos por 800000» en los cierres de caja); el plan con `saldo <> 0` y `k As Integer`
  escribe 32 767 cuotas y se detiene con el error 6; las seis filas de la tabla de
  créditos salen iguales a Python y R. La sección 6 ya lo dice como ejecutado. Queda
  sin correr en Excel solo el cierre de caja cuando el primer dato es el −1.
- **Banco Moodle (decisión F):** las ocho preguntas, revisadas por un lector sin
  contexto contra el capítulo corregido, con 3 000 semillas cada una y la clave
  recalculada por otro camino. Ninguna clave está mal. Ocho borradores en
  `Vault/Borradores Moodle/cap05/` y la nota «Banco Moodle del capítulo 5 - preguntas
  desfasadas», con siete dudas para el docente. El banco solo se leyó (misma suma de
  verificación antes y después); nada se copió ni se tocó en Moodle.
- **Capítulos 2, 3 y 4:** trece `<Fuente propia>` completan ahora la frase («según la
  convención del curso», «que resume…») en vez de repetir «elaboración propia».
- Un comentario de Python de la sección 3 ya no dice «Python no tiene Repita».

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan, sin
avisos en el 5. Sonda del 5 a 320, a 375, en escritorio y sin almacenamiento; la de los
capítulos 2, 3 y 4, a 320. **Teléfono (decisión G):** el servidor de red local responde
en el Mac, pero el iPhone del docente no llegó a él (ninguna petición en el registro);
pendiente de saber si es la red, el `https` o el relay privado. **Huecos:** el permiso
de pantalla caduca si el docente no está, y la ejecución en Excel se queda a medias;
`--incluir` admite un solo juego de entradas por bloque, así que el caso del −1 de
entrada pide otra pegada.

**Teléfono, el mismo día.** El capítulo se abrió en el iPhone del docente por iPhone
Mirroring, en una pestaña nueva de Safari, desde el servidor de red local: carga
(petición de 192.168.1.7 en el registro), el menú de lecciones abre, y la lección 7 se
recorrió de arriba abajo: el `<Ilustrativo>`, los bloques de código, la tabla de VPN,
la traza y los botones Anterior y Siguiente se ven bien y nada se sale del ancho. No se
recorrieron las otras ocho lecciones en el aparato. Por qué el docente no vio nada
antes no quedó establecido: al volver, el servidor ya no estaba escuchando y hubo que
levantarlo otra vez. Ajuste menor a raíz de la prueba: `1 + tasa` ya no se parte entre
dos renglones. **Visto y sin tocar:** las etiquetas de la tarjeta de la portada salen
de `CONFIG.temas` («Contador y acumulador», «Terminación») y no coinciden con los
títulos de las lecciones («Contar y acumular», «Cuándo para»); va a la fase 12.

### Tarea 15 · Capítulo 5, fase 12: lectura crítica final · 2026-11-21

Rama `claude/cap05-fase12`, sobre la de la fase 11. Dos lectores sin contexto, que no
editan: uno leyó el capítulo entero y ejecutó Python y R; el otro cotejó las 13 citas
contra el pasaje en la fuente misma.

- **Lectura crítica:** ningún hallazgo alto; 3 medios y 11 bajos, todos corregidos.
  Las claves de los 19 ejercicios, del emparejamiento y de las 10 preguntas son
  correctas, con una sola opción defendible; los 22 bloques de Python y R con salida
  declarada coinciden; las remisiones a los capítulos 1 a 4 y al syllabus cuadran.
  - Medios: «una tarjeta de crédito. Ahí no hay un número de cuotas que contar» pasó a
    «una tarjeta a la que se abona una cifra fija cada mes»; la pregunta 8 decía «con su
    acumulador de intereses» de una traza que no lo tiene; el flujograma anidado no
    dibuja Inicio ni Fin y la simbología dice «uno de cada uno»: el pie dice ahora que
    es un fragmento.
  - Bajos: «secciones 4 a 7» (no 3 a 7); «para con una instrucción de salida, como Exit
    Do»; la línea de R con `sum` da «los mismos VPN hasta el centavo, y la misma TIR»
    (difieren en milmillonésimas); la tabla de la sección 6 ya no adelanta la tolerancia
    ni la bisección; «la tasa de la memoria»; «con tope 12 no da trece»; `range(3)` y
    `range(0, 3)` ejecutados en vez de una propiedad general sin cita; «un ciclo que
    cuenta las cuotas, bien escrito»; el interactivo dice «para después de la vuelta n»;
    la portada separa lo de Python de las tres diferencias que dan «otro número»; dos
    comentarios internos que decían «VBA sin ejecutar».
- **Citas:** 11 respaldan limpio. Corregidas las otras dos: la de `For...Next` cubría
  también el pseudocódigo (ahora «En VBA, el For…; el Para del pseudocódigo hace lo
  mismo, por convención del curso») y la de `Dim` daba «Comentarios» por «Observaciones».
  El artículo 305 se leyó ese día en la página oficial. La frase que sigue a la cita de
  la usura se apegó al artículo. Cuatro notas del vault, renombradas.
- **Portada:** las etiquetas de la tarjeta (`CONFIG.temas`) llevan los títulos de las
  lecciones, como en el capítulo 4.

**Verificación.** `verificar.py --con-salidas --con-pandoc`: los cinco pasan, el 5 sin
avisos, con trece citas registradas. Sonda del 5 a 320, a 375 y en escritorio: 9 de 9.
**Sin comprobar:** el inciso inexequible del artículo 305 (la página lo muestra
colapsado; no afecta lo citado); cinco fuentes se cotejaron solo contra la copia
guardada; el cierre de caja con el −1 de entrada no se corrió en Excel; en el iPhone se
recorrió una lección de nueve. **Decisiones que quedan al docente:** copiar al banco
los ocho borradores (y las siete dudas de su nota); el texto de matemáticas financieras
y el de terminología que Zotero no tiene. **Estado:** doce fases hechas, ramas apiladas
de `claude/cap05-plan` a `claude/cap05-fase12`, sin fusionar: la fusión a `main` espera
la aprobación del docente.

**Cierre (2026-11-22).** Con la aprobación del docente, `claude/cap05-fase12` se fusionó
en `main` (`1e1d37e`, «Fusión: capítulo 5, mejora de contenido (doce fases)») y se subió
a GitHub; Pages lo publicó. Los ocho borradores del banco siguen sin copiar.

### Tarea 16 · Capítulo 6, fase 1: inventario, fuentes y archivo · 2026-11-23

Plan `PLAN_TAREA16_CAPITULO_06.md`, aprobado el 2026-11-23 con la opción recomendada en
las ocho decisiones. Rama `claude/cap06-fase1`, sobre `main` en `1e1d37e`; sin fusionar.

- **Inventario de promesas:** 49 filas en los capítulos 1 a 5 (13 expresas en 9
  pasajes, 27 implícitas, 9 dudosas), por un lector sin contexto que buscó por patrones;
  no leyó las 17 879 líneas una por una. Sin sección en el plan maestro: `Select Case …
  To` (irá en la 3), sus listas con comas, y la frase del capítulo 5 «que todavía no
  está escrito», que se corrige al publicar.
- **Fuentes:** leídas 99 páginas de Microsoft en español, cotejadas con la inglesa; los
  pasajes se extrajeron del HTML con código. Quedaron en el vault. Se proponen 48 para
  Zotero, sin importar todavía. Tres cosas que la documentación **no dice**: el ancho de
  14 columnas de la zona de impresión y el espacio del signo de `Debug.Print` (lo
  segundo solo lo dice `Str`); la jerarquía de objetos de Excel en una sola página; y
  los atajos del editor en Mac. Las páginas en español son traducción automática y en
  varias la sintaxis o las cifras salen rotas.
- **Herramientas (H3).** Medido con un archivo de prueba: un bloque de solo VBA escrito
  como `const X = { vba: … }` ya entra al arnés de `ejecutar_vba.py`, y la regla 4 no lo
  toca porque solo mira `<CodeTabs>`. Una constante suelta con `'>` no la veía nadie ni
  se listaba: `ejecutar_salidas.py` la avisa ahora (`sueltas_vba_con_salida`). Prueba
  negativa: el archivo de prueba da el aviso; los cinco capítulos, ninguno. README al día.
- **`SimuladorVBE` (H8).** El `Trazador` de LP-CORE admite `codigo` de un solo lenguaje,
  con línea activa, variables y salida. El simulador será local; LP-CORE no se toca.
- **Archivo:** `06_LPF_Entorno_VBA.html`, desde `lp-base.html`, con `CONFIG` contra la
  fila del syllabus y siete secciones vacías; ningún resto de la demostración. Sonda a
  375 px: 9 de 9 lecciones, cero errores. `verificar.py` le marca 12 fallos, todos por
  vacío (cuota y motivación): no se pusieron motivaciones de relleno. Mientras dure la
  construcción, el verificador global falla en esta rama por el capítulo 6.
- **Desvío del plan:** decía «nota de hilo por cada promesa»; quedó un hilo agrupado por
  sección y la tabla completa en una nota del vault.

### Tarea 16 · Capítulo 6, fase 2: los tres artefactos · 2026-11-23

Rama `claude/cap06-fase2`, sobre la fase 1; sin fusionar.

- **Artefactos:** `SimuladorVBE`, `MapaObjetosExcel` y `RendimientoHoja`, locales del
  capítulo. Están en las secciones 6 y 5, bajo el aviso «En construcción», con datos de
  Excel 16.115 para Mac; el registro de la ejecución quedó en el vault. Sonda a 320 y a
  375 px: 9 de 9 lecciones, cero errores. En el navegador, el simulador recorrido entero
  coincide parada por parada con lo que se copió de Excel.
- **Recorrido de `OtroAcuerdo`:** 23 paradas. El editor no se detiene en la línea `Dim`.
  Tres paradas no se leyeron directamente de la pantalla (una captura salió antes del
  repintado y dos líneas quedaron fuera del área visible); se confirmaron por el conteo,
  por la salida de Inmediato y por la línea donde quedó el cursor.
- **Atajos:** en este Excel el menú Debug muestra ⇧⌘I para el paso a paso, y F8 no
  avanzó. La tecla fue sintética: falta probarla en el teclado físico antes de escribir la
  sección 6, cuyo título dice «F8».
- **Tiempos:** `Timer` avanzó de a 1/256 de segundo, y con una sola pasada el bloque daba
  cero. Se repite 40 veces lo rápido y se divide. Escribir en bloque fue de 66 a 77 veces
  más rápido; leer, unas 9. Una máquina, una sesión.
- **Corrección a la fase 1:** el ancho de 14 columnas y los espacios de `Debug.Print` sí
  tienen fuente, MS-VBAL §5.4.5.8, que ya está en Zotero; el número se escribe con un
  espacio delante y otro detrás.
- **Huecos:** el control de Excel en segundo plano no pega ni teclea en el editor de VBA
  ni pulsa Debug › Step Into; hizo falta la pantalla completa, con el docente presente y
  el Mac desbloqueado. `ejecutar_vba.py` no captura Locales: el recorrido se lee de la
  pantalla. `verificar.py` sigue marcando los mismos 12 fallos por vacío.

### Tarea 16 · Capítulo 6, fase 3: sección 1, «Por qué VBA» · 2026-11-23

Rama `claude/cap06-fase3`, sobre la fase 2; sin fusionar. El punto de control 2 se aprobó
el mismo día.

- **Sin citas, a propósito (H6).** Remisión al syllabus (el RA2 textual y los tres
  contenidos que nombran VBA), remisión a los capítulos 1 y 5, dos conteos derivados y un
  recuadro de criterio del docente con las razones para estudiar VBA. La sección dice que
  ni el syllabus ni el material tienen una fuente que mida el uso de VBA en el sector.
- **Mapa del capítulo:** la rutina `OtroAcuerdo` del capítulo 5, sin cambios, y una tabla
  de qué pregunta deja cada parte y qué sección la responde. Remite a secciones que aún
  no existen: se coteja en la fase 11.
- **Ejercicio:** un E8 (reto con solución revelable). Regla 21: las cifras copiadas del
  capítulo 5 necesitaban el espacio duro; el verificador lo cazó.
- **Comprobado:** sonda a 320 y 375 px, 9 de 9 lecciones y cero errores; en el navegador,
  la sección dibuja el bloque resaltado, la tabla y la solución del reto, sin espacios
  comidos. `verificar.py` marca ahora 11 fallos, todos por lo que falta escribir.
- **Pendiente del docente:** la fila 37 del syllabus anuncia un video sin dirección.

### Tarea 16 · Capítulo 6, fase 4: sección 2, «El editor de VBA» · 2026-11-23

Rama `claude/cap06-fase4`, sobre la fase 3; sin fusionar.

- **Contenido:** la advertencia de macros (aviso corto, como decidió el plan), cómo abrir
  el editor, sus cinco zonas con un esquema propio, escribir y ejecutar una rutina, la
  ventana Inmediato, las reglas de `Debug.Print` y el formato `.xlsm`. Solo VBA. Dos E2,
  probados en el navegador con respuesta buena y mala.
- **Fuentes:** tanda 09 en Zotero, nueve páginas de Microsoft de la lista aprobada en el
  punto de control 1. Zotero abrió en la colección de otro curso; se comprobó el id antes
  de importar. 18 afirmaciones citadas, con su nota y su fila en `afirmaciones/06.yaml`.
- **Verificador sin contexto:** 12 respaldaban y 6 decían más que su pasaje (una
  posición en pantalla que la página no da, un «el que» que excluía otros formatos, una
  excepción omitida). Además cazó un pasaje que esta sesión copió mal: a la oración de la
  coma de MS-VBAL se le había puesto un operando que está en la oración anterior. Todo
  corregido; cinco localizadores pasaron de «En este artículo», que es el rótulo del
  índice de la página, a «párrafo inicial».
- **Ejecutado:** las seis salidas del bloque de `Debug.Print` coinciden con Excel. La
  especificación dice que un número lleva un espacio delante y otro detrás; Excel no puso
  el de delante en `-150000`. Se dice así, como dato ejecutado que la especificación no
  prevé.
- **Dicho como no comprobado:** el guardado en `.xlsm` en Mac, y que una variable esté
  vacía en Inmediato fuera de su rutina.
- **Huecos:** `comparar` recorta los espacios finales y el archivo de salida del arnés no
  se puede leer desde fuera de Excel, así que el espacio final de un número solo se ve
  cuando va seguido de texto. Y el portapapeles lo comparte todo el equipo: un pegado
  metió en el módulo una ruta ajena; copiar y pegar deben ir en la misma tanda.
- **Estado del verificador:** 10 fallos, todos por lo que falta escribir.

### Tarea 16 · Capítulo 6, fase 5: sección 3, «Del algoritmo al código» · 2026-11-23

Rama `claude/cap06-fase5`, sobre la fase 4; sin fusionar.

- **Contenido:** de Inicio y Fin a `Sub` y `End Sub` (el mismo algoritmo en los cuatro
  lenguajes y una tabla de equivalencias), lo que hace `Dim`, `Option Explicit` con el
  caso de la variable mal escrita, `Select Case` con `To` y el orden de los casos, y
  `Const`, `InputBox` y `MsgBox`. Un E5, un E3 y un E2, probados en el navegador con
  respuesta buena y mala. `Select Case … To` no tenía sección en el plan maestro: quedó
  aquí (decisión 5 del plan del capítulo).
- **Fuentes:** tanda 10 en Zotero, siete páginas de Microsoft; `Sub`, `Select Case` y
  `Const` en su versión inglesa, porque la traducción está rota. 21 afirmaciones citadas.
- **Verificador sin contexto:** de 19 frases, 15 respaldaban y 4 decían más que su
  pasaje. Leyó además la sección entera y señaló diez frases sin cita; entre ellas un
  error de la motivación (decía que la variable mal escrita guardó 50 000 y guarda
  70 000) y una prueba que no probaba nada: ejecutar `OtroAcuerdo` dos veces no muestra
  que las variables locales no sobreviven, porque la rutina reasigna todo al empezar. El
  mismo razonamiento estaba en un ejercicio de la sección 2, ya confirmada; se corrigió
  allí también. Dos citas se partieron en dos; las dos notas nuevas llevan la redacción
  que propuso el verificador y no tuvieron segunda lectura.
- **Ejecutado en Excel:** los cinco bloques con salida declarada coinciden y los tres
  mostrados dan lo que dice el texto. El aviso de `Option Explicit` se copió de la
  pantalla: «Compile error: Variable not defined», con el nombre no declarado
  seleccionado; sale igual al compilar que al llamar la rutina. Una rutina con un
  contador, llamada dos veces, escribió 1 las dos veces: esa sí es la prueba de que las
  variables locales empiezan de cero. Y `? TypeName(saldo)` en Inmediato respondió
  `Empty`, lo que cierra el pendiente de la sección 2.
- **Dicho como no comprobado:** dónde está la opción que escribe `Option Explicit` en
  los módulos nuevos, y el texto del aviso en un Excel en español.
- **Huecos:** `preparar` sin `--incluir` genera otro arnés (cinco bloques, otra huella)
  y pisa el anterior sin avisar; si ya se pegó el de ocho, `comparar` fallaría por la
  huella. Hay que repetir los `--incluir` cada vez. Y pegar en el editor sigue pidiendo
  el control de pantalla completa: la primera solicitud venció sin respuesta y la fase
  esperó al docente.
- **Estado del verificador:** 9 fallos, todos por lo que falta escribir (E1, E3, E7 y
  seis motivaciones). Sondas de 320 y 375 px: 9 de 9 lecciones, cero errores.

### Tarea 16 · Capítulo 6, fase 6: sección 4, «Tipos de datos y Currency» · 2026-11-24

Rama `claude/cap06-fase6`, sobre la fase 5; sin fusionar.

- **Contenido:** quién decide el tipo (los mismos cinco datos en los cuatro lenguajes),
  la tabla de los siete tipos del curso, `Currency` con la suma de cien centavos del
  capítulo 1, lo que `Currency` no guarda (una tasa de cinco decimales), el error 6,
  las conversiones, `Round` y `Format`, y `Variant`. Un E7, un E3 en cuatro lenguajes y
  el E8 de `Currency` frente a `Double`. El E4 pasa a la sección 5.
- **Fuentes:** tanda 11 en Zotero, cuatro páginas de la lista aprobada. 15 afirmaciones
  citadas. `Round` y `Format` no estaban en la lista: la sección dice de ellas solo lo
  ejecutado, y lo declara.
- **Verificador sin contexto:** 11 de 14 respaldaban y 3 decían más que su pasaje (una
  fila de la tabla, el número del error atribuido a un pasaje que no lo traía y una
  promoción de tipos generalizada). Señaló además 18 frases sin cita: un «todas las
  variables llevan su As» que la propia sección contradecía, una rutina con la cuota en
  `Double` sin salvedad, un «no alcanzan para una tasa» falso para la tasa del primer
  bloque, y un argumento contra `Variant` que no valía para el caso de la sección. Todo
  aplicado; las tres frases reescritas o añadidas tuvieron segunda lectura. Cinco
  localizadores «párrafo inicial» se precisaron.
- **Ejecutado en Excel:** doce bloques comparados coinciden; las salidas se predijeron
  antes de ejecutar. El error 6 se vio con dos `Integer` cuyo producto cabía en el
  `Long` de destino.
- **Hallazgo para la fase 11:** el capítulo 2 dice que VBA redondea «al entero más
  cercano»; con 2,5 y 3,5 Excel dejó 2 y 4. La sección 4 lo dice como dato ejecutado.
- **Huecos:** `cat` de R escribe 1e+06 y 9e+05 para un millón y novecientos mil, y eso
  obligó a cambiar dos veces el capital del E3 hasta que la salida fuera legible; no
  hay regla que avise. Y Zotero volvió a amanecer fuera de la colección de LPF.
- **Estado del verificador:** 7 fallos, todos por lo que falta escribir (E1, un E7 y
  cinco motivaciones). Sondas de 320 y 375 px: 9 de 9 lecciones, cero errores.

### Tarea 16 · Capítulo 6, fase 7: sección 5, «La hoja: Range y Cells» · 2026-11-24

Rama `claude/cap06-fase7`, sobre la fase 6; sin fusionar.

- **Contenido:** los cuatro niveles de objetos con el mapa de la fase 2, `Range` y
  `Cells`, la propiedad `Value`, la hoja activa y la hoja con nombre, un ciclo que
  recorre filas, y los tiempos de celda por celda frente a bloque con la gráfica de la
  fase 2. Solo VBA. Un E4 y un E7, probados en el navegador con respuesta buena y mala.
  Los arreglos solo se asoman: se remite al capítulo 7.
- **Fuentes:** tanda 12 en Zotero, nueve páginas de la lista aprobada. 18 afirmaciones
  citadas.
- **Verificador sin contexto:** 12 de 14 respaldaban y 2 decían más que su pasaje.
  Señaló 22 frases sin cita. Las de fondo: una razón «74 veces» que con las cifras
  redondeadas del propio texto daba 78; «la misma macro y el mismo resultado» para dos
  rutinas cuyo resultado nunca se comparó; el orden fila, columna apoyado en la página de
  `Item` sin el pasaje que la une con `Cells`; y una consecuencia de la hoja activa que
  no se pudo observar con un libro de una sola hoja. En la segunda lectura, una de las
  seis frases cambiadas volvió a salir parcial y se corrigió otra vez.
- **Ejecutado en Excel:** 17 bloques comparados coinciden, predichos antes de ejecutar.
  Las dos rutinas del E4 se ejecutaron a mano: una llenó J2:J4 y la otra B10:D10. De
  paso se vio que una celda que recibe un `Currency` queda con formato de moneda.
- **Dicho como no comprobado:** el efecto de tener otra hoja activa, y el nombre de la
  hoja nueva en un Excel en español.
- **Huecos:** la regla 6 exige cuatro lenguajes a todo `Comparador` y no admite declarar
  un ejercicio de solo VBA; se pasó el código como texto con `lang="vba"`, que el
  componente ya soporta. Queda sin regla que distinga «falta un lenguaje» de «es de un
  solo lenguaje a propósito». La sonda de 320 px cazó un código en línea de 358 px. Y la
  aprobación del control de pantalla volvió a vencer sin respuesta: la sección se
  escribió y se verificó con las salidas predichas, y se ejecutó después.
- **Estado del verificador:** 5 fallos, todos por lo que falta escribir (los E1 y
  cuatro motivaciones). Sondas de 320 y 375 px: 9 de 9 lecciones, cero errores.

### Tarea 16 · Capítulo 6, fase 8: sección 6, «Depurar con F8» · 2026-11-24

Rama `claude/cap06-fase8`, sobre la fase 7; sin fusionar.

- **Contenido:** Step Into, el recorrido de `OtroAcuerdo` con el simulador de la fase 2,
  lo que el editor hace distinto de la traza a mano (no se detiene en `Dim`, muestra 0
  donde se escribía raya, tiene más paradas que filas), la ventana Locales, el punto de
  interrupción y cómo salir de una pausa. Solo VBA. Los tres E1 del capítulo están aquí:
  con ellos la cuota queda completa salvo el E6, que va en la evaluación.
- **Fuentes:** tanda 13 en Zotero, cuatro páginas de la lista aprobada; tres en inglés.
  14 afirmaciones citadas.
- **Verificador sin contexto:** 7 de 11 respaldaban y 4 decían más que su pasaje; en la
  segunda lectura, 2 de las 7 frases cambiadas volvieron a salir parciales. Señaló
  además 18 frases sin cita: «se detiene antes de cada instrucción», que contradecía al
  propio `Dim`; «el editor puede hacer esa tabla por usted», cuando Locales muestra una
  parada a la vez; y una frase que atribuía a Run To Cursor lo que es de Step Over.
- **Ejecutado en Excel:** las tres rutinas de los E1 se recorrieron paso a paso y dieron
  las secuencias escritas de antemano. Lo que no se sabía y se vio: el paso a paso se
  detiene en `Select Case`, en cada `Case` que evalúa y en `End Select`; la línea `For`
  se resalta una sola vez; y Locales escribe las cadenas entre comillas.
- **Dicho como no comprobado:** F8 en el teclado físico (la sección conserva el título
  y explica que en este Mac el menú muestra ⇧⌘I), y cómo se interrumpe una rutina que
  no termina. Esto último era una promesa implícita del capítulo 5 y queda sin cumplir.
- **Huecos:** mientras Excel ejecuta una rutina, ni las teclas ni los clics enviados por
  programa llegan al editor, así que una interrupción no se puede probar sin el
  docente. Otra aplicación pasó al frente a mitad de una tanda y se perdieron tres
  capturas: la primera detención del segundo E1 se dedujo de las cinco siguientes. Y la
  aprobación del control de pantalla venció una vez más sin respuesta.
- **Estado del verificador:** 3 fallos, todos por lo que falta escribir (las
  motivaciones de la portada, la sección 7 y la evaluación). Sondas de 320 y 375 px: 9
  de 9 lecciones, cero errores.

### Tarea 16 · Capítulo 6, fase 9: sección 7, «Errores y seguridad» · 2026-11-24

Rama `claude/cap06-fase9`, sobre la fase 8; sin fusionar.

- **Contenido:** los tres momentos en que algo sale mal (compilación, ejecución,
  lógica), lo que pasa sin controlador, la guardia, `On Error GoTo` con el objeto `Err`,
  por qué `On Error Resume Next` esconde el error, y la seguridad de macros. Solo VBA.
  Un E4 que compara la guardia con `Resume Next`.
- **Fuentes:** tanda 14 en Zotero, cuatro páginas de la lista aprobada. 11 afirmaciones
  citadas.
- **La ejecución corrigió al autor.** Los bloques declaraban el error 11 para una
  división entre cero. Excel dio el 6, «Overflow»: el dividendo era `Currency`. El 11
  salió con una división de literales en Inmediato. El texto cuenta las dos cosas y
  dice que no se aisló la causa. **Deja una duda sobre el capítulo 4**, ya publicado,
  que afirma que su `total / compras` daría el 11 con un total distinto de cero, y su
  `total` es `Currency`: queda para ejecutar y corregir en la fase 11.
- **Verificador sin contexto:** 9 de 11 respaldaban y 2 decían más que su pasaje; las
  tres frases cambiadas pasaron la segunda lectura. Señaló 20 frases sin cita: una
  causa atribuida a `Currency` sin aislarla, «la que más encontrará en macros ajenas»
  sin dato, «las rutinas de este curso no la usan» en la sección que la usa para
  mostrarla, y dos consejos de seguridad que afirmaban hechos (que se puede leer el
  código sin habilitar las macros, y que `.xlsm` es la extensión de todo libro con
  macros). Todo aplicado; el consejo ya no promete lo que no se probó.
- **Huecos:** `ejecutar_vba.py` da por fallido un bloque que termina con `Err` distinto
  de cero, aunque sus salidas coincidan; el bloque de `Resume Next` necesitó un
  `On Error GoTo 0` final. Y un pegado cayó en el módulo equivocado porque el árbol del
  explorador de proyectos se había desplazado: se mira el título de la ventana antes
  de pegar.
- **Estado del verificador:** 2 fallos, por las motivaciones de la portada y la
  evaluación (fase 10). Sondas de 320 y 375 px: 9 de 9 lecciones, cero errores.

### Tarea 16 · Capítulo 6, fase 10: portada, evaluación y glosario · 2026-11-24

Rama `claude/cap06-fase10`, sobre la fase 9; sin fusionar.

- **Contenido:** la portada (caso de apertura, ficha del syllabus, cambio de orden frente
  al syllabus, qué secciones traen cuatro lenguajes, con qué Excel se preparó), el E6 que
  faltaba, el cuestionario integrador de diez, un glosario de 27 términos y «Lo que
  viene». Con esto el capítulo no tiene secciones en construcción.
- **`verificar.py --con-salidas --con-pandoc` en verde para los seis capítulos**, por
  primera vez con el 6 completo: 16 ejercicios, cuota cumplida.
- **Lectura crítica independiente**, contra las siete secciones: las diez claves del
  cuestionario eran correctas. Lo que encontró: dos justificaciones que contradecían el
  cuerpo; un enunciado falso en el E6; una definición del E6 que entregaba la regla que
  evaluaba una pregunta posterior; nueve definiciones del glosario que generalizaban
  (entre ellas la del desbordamiento, que atribuía al `Currency` lo que la sección 7
  dice que no se aisló); y un recuento equivocado en la portada de qué secciones traen
  cuatro lenguajes. Se cambiaron tres preguntas que repetían ejercicios del capítulo.
- **El caso de la portada no se cerraba en ninguna sección.** Preguntaba si las cifras
  de `OtroAcuerdo` estaban bien, y la sección 6 solo explicaba el mecanismo. Se añadió
  allí la respuesta: el cuarto abono cobró 150 000 de más.
- **Reglas que trabajaron:** la 21 (ocho cifras del cuestionario sin espacio duro), la de
  la clave larga (tres preguntas que se acertaban por el tamaño) y la de pregunta
  repetida (una opción del cuestionario igual a la de un ejercicio).
- **Comprobado en el navegador:** el cuestionario respondido entero, 10 de 10 con las
  claves y 0 de 10 con respuestas malas; el emparejamiento, 7 de 7.
- **Pendiente para la fase 12:** las justificaciones del cuestionario repiten hechos que
  las secciones citan, y no tienen nota de afirmación propia.

### Tarea 16 · Capítulo 6, fase 11 (primera parte): coherencia hacia atrás e índice · 2026-11-24

Rama `claude/cap06-fase11`, sobre la fase 10; sin fusionar.

- **Promesas:** las 49 filas del inventario de promesas de los capítulos 1 a 5 tienen
  cierre. Una sola pedía tocar un capítulo anterior: el «Lo que viene» del capítulo 5
  decía que el 6 «todavía no está escrito», hablaba en futuro y prometía repetir allí
  las tres vueltas de la bisección, que el 6 no repite. Corregido. Las demás menciones
  al capítulo 6 en los capítulos 1 y 4 siguen siendo ciertas.
- **Recuento:** los «155» y «147» de la sección 1 se volvieron a contar y coinciden.
- **Índice:** `index.html` enlaza el capítulo 6, con una descripción de lo que trae.
- **Sin cambio:** la frase del capítulo 2 sobre el redondeo no es falsa; el 6 la afina.
- **Comprobado:** sondas en los cinco modos (`file`, `375`, `sin-almacen`,
  `sin-cdnjs`, `sin-tailwind`) y a 320 px, sobre los capítulos 5 y 6; verificador en
  verde para los seis.
- **Queda de esta fase, a la espera del docente:** la ejecución que decide la frase del
  capítulo 4 sobre el error 11 (un `Currency` entre un `Long` en cero), el recorrido en
  el iPhone, y los borradores del banco, que se propusieron como sesión aparte.

### Tarea 16 · Capítulo 6, fase 11 (segunda parte): la división entre cero · 2026-11-24

Rama `claude/cap06-fase11`; sin fusionar.

- **La duda sobre el capítulo 4 se resolvió a su favor.** Seis divisiones en la ventana
  Inmediato: un `Currency` entre un `Long` o un `Integer` en cero da el error 11 si el
  resultado se escribe o se guarda en un `Double`, y el 6 si se guarda en un `Currency`;
  cero entre cero da el 6. El capítulo 4 compara el resultado, no lo guarda, así que su
  frase («con un total distinto de cero sería el 11») es correcta. No se tocó.
- **Lo que estaba incompleto era la sección 7 del capítulo 6**, que decía que la causa
  del 6 no se había aislado. Ahora cuenta las tres pruebas y dice qué decide: el
  destino del resultado.
- **Para la próxima vez:** una diferencia entre dos ejecuciones no se atribuye a una
  causa mientras cambien dos cosas a la vez. La fase 9 lo dejó dicho en el texto en vez
  de adivinar, y eso permitió corregirlo aquí sin desdecirse.

### Tarea 16 · Capítulo 6, fase 11 (tercera parte): recorrido en el iPhone · 2026-11-25

Rama `claude/cap06-fase11`; sin fusionar. **Recorrido parcial**: portada y lección 5.

- **Defecto que solo se ve en el aparato:** la gráfica de tiempos de la sección 5 salía
  aplastada, de unos píxeles de ancho, al llegar a la lección desde el menú de
  lecciones. `usePlotly` (LP-CORE) dibuja con `responsive: true`, que solo atiende al
  cambio de tamaño de la ventana; en un teléfono la barra lateral comprime el contenido
  mientras está abierta, la gráfica se dibuja con ese ancho y no se vuelve a medir al
  cerrarse la barra.
- **Arreglo, local al capítulo 6:** `RendimientoHoja` observa el tamaño de su contenedor
  y vuelve a medir la gráfica. De paso, eje x logarítmico (los rótulos de 1 000, 5 000 y
  20 000 se montaban) y marcas del eje y escritas a mano (Plotly rotulaba 0,0001 como
  «100µ»). Visto corregido en el iPhone.
- **Huecos, sin cerrar:** (1) el defecto de fondo está en LP-CORE y alcanza a las
  gráficas de los capítulos 1 y 5, que no se miraron en el aparato; corregirlo allí
  obliga a reestampar, y es decisión del docente. (2) La sonda avanza con «Siguiente» y
  nunca entra a una lección por la barra lateral: por eso pasaba en verde a 320 y 375 px
  con la gráfica rota. Falta un modo que entre por la barra y mida el ancho de las
  gráficas, con su prueba negativa.
- **Sin ver en el aparato:** las lecciones 1 a 4 y 6 a 9. El recorrido se detuvo porque
  otra aplicación pasó al frente dos veces mientras se manejaba el teléfono.
- **Tropiezos del entorno:** iPhone Mirroring no conecta si el Mac usa Sidecar, ni sin
  wifi; y la ventana quedó fuera de la pantalla hasta moverla con el menú Window.

### Librería: las gráficas se vuelven a medir al cambiar de ancho su contenedor · 2026-11-25

Rama `claude/cap06-fase11`; sin fusionar. Aprobado por el docente tras el recorrido en
el iPhone.

- **Qué cambió:** `usePlotly` (bloque LP-CORE del capítulo 1, su fuente) observa el
  ancho del contenedor y llama a `Plotly.Plots.resize` cuando cambia. `lp-base.html`
  regenerado y los seis capítulos reestampados con `migrar.py`. El arreglo local que
  llevaba la gráfica del capítulo 6 se quitó.
- **A quién alcanzaba:** a toda gráfica de Plotly a la que se llegara desde la barra
  lateral en un teléfono. Hay dos en el capítulo 1 y una en el 5, además de la del 6. El
  capítulo 5 publicado en `main` tiene el defecto.
- **Hueco cerrado, con prueba negativa:** `sonda_navegador.mjs`, en los modos `375` y
  `320`, entra a cada lección con gráfica desde la barra lateral y exige que la gráfica
  mida lo que su contenedor. Con `ResizeObserver` anulado tiene que fallar, y falla.
  Contra el capítulo 5 de `main` informa «gráfica de 700 px en un contenedor de 265 px».
  README actualizado.
- **Lo que enseñó la prueba negativa:** el síntoma no es el mismo en los dos motores. En
  Safari de iPhone la gráfica quedó de unos píxeles; en Chrome, Plotly cae a su ancho
  por omisión, 700 px, y se sale de la caja. La primera versión de la medida solo miraba
  si la gráfica era más angosta, y por eso la prueba negativa no la dejó pasar.
- **Comprobado:** sondas `file`, `320` y `375` sobre los seis capítulos, de a uno;
  `verificar.py --con-salidas --con-pandoc` en verde.
- **Sin comprobar:** el arreglo de la librería no se volvió a mirar en el iPhone. Se vio
  allí el arreglo local del capítulo 6, que hace lo mismo.

### Capítulo 6, fase 12: lectura crítica final · 2026-11-25

- **Qué se hizo:** ocho lecturas independientes, sin contexto, del capítulo terminado.
  Tres de lectura crítica (portada y secciones 1–3; 4–5; 6–7 con la evaluación), dos que
  rehicieron las cifras que no están en una línea de salida (unas 1 660) y tres que
  cotejaron las 97 notas de afirmación contra la página viva de Microsoft.
- **Resultado:** ningún error de hecho, ninguna clave mal calificada, ninguna salida que
  contradiga lo ejecutado. Los 97 extractos están en sus páginas. 74 correcciones.
- **Citas:** 85 de 97 respaldaban la frase entera. En 11 la frase decía algo más que el
  pasaje (una palabra o una deducción metida en la oración citada: «predeterminado»,
  «nace», «no devuelve un valor», «cuando ninguna rutina se está ejecutando») y en una
  el localizador era otro párrafo. Se cambió la frase, no el pasaje; la deducción del
  material quedó en su propia oración, sin cita. La proporción bajó de una de cada tres
  (capítulo 1) a una de cada ocho.
- **Lo que se afirmaba haber visto y el registro no tenía:** «este capítulo vio el aviso»
  de macros en el Mac (el libro nunca se guardó ni se reabrió), «región Colombia», el
  aviso que «estará traducido», `Module1` recién creado, «el editor de VBA no retrocede».
  Se redactaron como lo que consta. El comentario de `F8_PARADAS` dice ahora que las
  paradas 8, 22 y 23 se dedujeron.
- **Ejercicios:** el E3 del CDT tenía tres distractores que contradecían su propio
  enunciado (se acertaba sin interpretar); se cambiaron por tres cifras compatibles con
  «sin mensaje y menor». El de ordenar decía «tres líneas» y son cuatro, y admitía otro
  orden válido (`Dim` a nivel de módulo): el enunciado lo fija. La traza de la mora pedía
  una parada en `End Select` que el texto no enseña: el enunciado la anuncia. El reto E8
  pedía clasificar «el factor de la cuota fija», que ningún capítulo nombra.
- **Términos:** `TypeName`, «objeto», «propiedad», `Address` y `Count` se usaban sin decir
  qué son. Las promesas a los capítulos 7 y 8 pasaron a futuro.
- **Lo que no se cambió y queda a criterio del docente:** los menús del editor van solo
  en inglés, como se vieron; mover el ejercicio de las dos ejecuciones después del
  apartado de la ventana Inmediato; `CInt(True)` y la prueba de `veces = 1` se cuentan en
  prosa, no en un bloque con salida; tres preguntas del cuestionario repiten el resultado
  de un bloque del cuerpo.
- **Límite:** las redacciones nuevas de las frases citadas siguen la propuesta del
  verificador y no pasaron por una segunda lectura independiente. Los bloques de código
  no cambiaron, así que no se volvió a Excel.
- **Comprobado:** `verificar.py --con-salidas --con-pandoc` en verde para los seis
  capítulos; sondas `file`, `375` y `320` del capítulo 6.
