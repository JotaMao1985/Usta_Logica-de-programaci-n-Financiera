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
| Cantidad | 3–4 | 2–3 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 | 10 preguntas |

Total: **14–18 ejercicios interactivos + 1 cuestionario integrador** por capítulo. Mínimo obligatorio: al menos un E1, un E3 y un E7 en cada capítulo (son los tres que más empujan hacia interpretación y apropiación).

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

### Capítulo 2 — Introducción a Algoritmos
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

#### Tarea 6 · Capítulo 3 completo (Control secuencial) — rebanada vertical de referencia
**Descripción:** Construir el capítulo 3 de punta a punta: HTML con las 5 secciones, el componente `Trazador`, los 14–18 ejercicios de la taxonomía, los 8 cloze de Moodle y la sección de guía docente.

**Por qué el capítulo 3 y no el 2:** es el primer capítulo que ejercita **todo** a la vez — los 4 lenguajes, flujogramas, el motor de traza (que luego se reutiliza en 4, 5 y 7) y los 8 tipos de ejercicio. Es la rebanada más riesgosa y representativa: si el formato falla, conviene que falle aquí y no en el capítulo 8.

**Criterios de aceptación**
- [ ] Las 5 secciones internas más portada y evaluación están completas
- [ ] **Cada una de las 7 secciones abre con su `Motivacion`**, redactada según la receta de §4 bis
- [ ] Todo bloque de código aparece en los 4 lenguajes y **cada versión produce el mismo resultado**
- [ ] Cuota de ejercicios cumplida, con al menos un E1, E3 y E7
- [ ] El `Trazador` funciona con al menos 3 algoritmos distintos
- [ ] Los 8 cloze compilan a HTML y a Moodle XML
- [ ] Portada declara: 6 horas, RA1, contenido del syllabus

**Verificación**
- [ ] `python3 _plantilla/verificar.py Material\ html/03_LPF_Control_Secuencial.html`
- [ ] Abrir en navegador; consola sin errores ni advertencias de React
- [ ] Ejecutar los snippets de Python y R y confirmar que coinciden con la salida documentada
- [ ] `Rscript Banco\ Moodle/compilar_banco.R --cap 03`
- [ ] Responder manualmente los 18 ejercicios y contrastar con las claves

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

#### Tarea 8 · Capítulo 2 — Introducción a Algoritmos
Incluye `CuatroRepresentaciones` con resaltado sincronizado, que es el artefacto de mayor dificultad técnica del capítulo.
**Dependencias:** T6 · **Alcance:** M

### ✅ Punto de control C — Fundamentos
- [ ] Capítulos 1, 2 y 3 verificados y sin deriva de componentes
- [ ] La progresión conceptual entre los tres es coherente (sin saltos ni repeticiones)

---

### Fase 3 — Estructuras de control (RA1)

#### Tarea 9 · Capítulo 4 — Control selectivo · **Alcance:** M
#### Tarea 10 · Capítulo 5 — Control repetitivo · **Alcance:** M

*Paralelizables entre sí* (comparten el `Trazador` ya construido y no dependen uno del otro). **Dependencias:** T6.

### ✅ Punto de control D — RA1 completo
- [ ] Capítulos 1–5 cubren las 30 horas del RA1 del syllabus
- [ ] El hilo financiero (cartera de crédito) es continuo entre capítulos
- [ ] Banco Moodle del RA1: ~40 cloze compilando

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
