# Plan · Tarea 6 — Capítulo 3, «Control secuencial»

**Rama:** `cap03/control-secuencial` · **Base:** `main` (a2ec960) · **Fecha:** 2026-08-10
**Encargo:** `PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md` §5 (Capítulo 3) y §6 (Tarea 6)
**Skill:** `lpf-capitulo`

---

## 0. Qué se decidió antes de planificar

La Tarea 6 fue escrita como **piloto vertical**: el primer capítulo, el que
descubriría los defectos del formato. El orden real de ejecución fue otro —
capítulo 1 (Tarea 7, 2026-08-05) y capítulo 2 (Tarea 8, 2026-08-09)— y la nota
que abre la Fase 1 del plan maestro lo registra. De ahí salen tres consecuencias
que cambian el plan de esta tarea:

1. **El punto de control B ya se cobró.** El riesgo «si el formato falla, que
   falle aquí» se pagó dos veces en los capítulos 1 y 2, que dejaron doce
   comprobaciones en `verificar.py` y cuatro defectos documentados. Este capítulo
   ya no es un piloto de formato.
2. **Lo que sigue vigente es el contenido.** El capítulo 3 es el primero que
   necesita el `Trazador` —que heredarán los capítulos 4, 5 y 7— y es donde la
   prueba de escritorio pasa de ejercicio a método. Sigue siendo la rebanada más
   pesada, pero por lo que enseña, no por el riesgo de formato.
3. **El punto de control abierto es el C**, no el B: capítulos 1, 2 y 3
   verificados y sin salto conceptual entre ellos.

### Datos del syllabus, textuales

Leídos de `Syllabus Logica de Programacion Financiera.xlsx`, hoja 1, **fila 33**:

| Campo | Valor textual |
|---|---|
| Resultado de aprendizaje (fila 31, col 7) | «Construye un algoritmo computacional incorporando variables de tipo financiero cuya solución lo pueda hacer una calculadora o una computadora» |
| Contenidos (col 26) | «CONTROL SECUENCIAL: algoritmos, flujograma, pseudocódigo y codificación.» |
| Actividades didácticas (col 33) | «"Formato Definición y Análisis" y Taller "Estructuras de Control Secuencial".» |
| Tiempos (col 40) | «6 horas» |
| Entregable (col 47) | «Tarea subida en Moodle "Estructuras secuenciales".» |
| Recursos (col 54) | Charla tutorial 1 «ESTRUCTURAS DE CONTROL», videos 1, 2 y 3 — `https://youtu.be/Dw58xKJiUVc` |

**Dato que cambia la portada:** los capítulos 1 y 2 tienen como entregable un
*cuestionario* de Moodle, y su portada lo declara así. El capítulo 3 **no**: su
entregable es una **tarea** —el taller «Estructuras de Control Secuencial» más el
«Formato Definición y Análisis»—. La fila «Evaluación asociada» debe decir eso, y
no inventar un cuestionario que el syllabus no pide. Los 8 cloze del banco siguen
teniendo sentido como **autoevaluación y banco del docente**, que es para lo que
el plan maestro los pide, pero no son el entregable del capítulo. → **Supuesto S1.**

---

## 1. Estado medido

Ejecutado en la rama, antes de tocar nada:

```
LP-CORE de referencia: 9cc19ee3e3e1ce33…
OK    01_LPF_Introduccion.html   13 ejercicios · E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1
OK    02_LPF_Algoritmos.html     13 ejercicios · E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1
Los 2 capítulos pasan la verificación.
```

| Cosa | Medida |
|---|---|
| `lp-base.html` | 2 812 líneas · 164 153 bytes |
| `01_LPF_Introduccion.html` | 4 314 líneas |
| `02_LPF_Algoritmos.html` | 3 899 líneas |
| `03_LPF_Control_Secuencial.html` | **no existe** |
| Componentes de ejercicio en LP-CORE | `TablaTraza`, `DetectaError`, `Comparador`, `OrdenaPasos`, `Emparejamiento`, `MCQ`, `Quiz`, `Reto` |
| Componente `Trazador` | **no existe** — ni en LP-CORE ni en ningún capítulo |
| Iconos de barra lateral | 17 definidos, **15 utilizables** (`ChevronLeft`/`Right` son de navegación) |
| Cloze de `cap03` en el banco | **1 de 8** — `traza_interes_simple.Rmd`, el piloto de la Fase 0 |
| Reglas de contenido de ese cloze en `verificar_cloze.R` | **ninguna** |
| Herramientas | `Rscript` y `python3` presentes |

---

## 2. Hallazgos

### H1 · El `Trazador` va a LP-CORE, y la skill no dice cómo se hace eso

La trampa 5 de la skill dice que los componentes de un capítulo **no** van a
LP-CORE, y da la razón: meter ahí algo que usa un solo capítulo obliga a
reestampar los ocho. Pero el `Trazador` es el caso contrario y está declarado
así en §5 del plan maestro: **lo reutilizan los capítulos 4, 5 y 7.** Dejarlo
local obligaría a copiarlo cuatro veces, que es exactamente la deriva que la
comprobación 1 existe para impedir.

De modo que va a `lp-core-extra.jsx`. Y ahí aparece el hueco: **la skill describe
el camino de estampar, no el de ampliar la librería.** El procedimiento completo,
que hay que ejecutar en este orden, es:

1. editar `lp-core-extra.jsx`;
2. `ensamblar.py` → regenera `lp-base.html`;
3. `migrar.py` sobre **todos** los capítulos que ya existen (01 y 02), no solo el
   nuevo;
4. `verificar.py` sobre los tres, porque la comprobación 1 compara byte a byte;
5. y la comprobación de la **trampa 1**: `ensamblar.py` lee el `head`, `partA` y
   `partB` de `01_LPF_Introduccion.html`, así que ese archivo es fuente y destino
   a la vez. Tras estampar hay que **volver a ensamblar** y confirmar que el SHA
   de `lp-base.html` no se movió.

Consecuencia práctica: **esta rama toca tres archivos HTML, no uno.** Los
capítulos 1 y 2 cambiarán aunque su contenido no cambie. Va en un commit aparte
para que el diff sea legible. → **Riesgo R-A.**

### H2 · `Trazador` y `TablaTraza` no son el mismo componente

Conviene fijarlo antes de escribir, porque el nombre invita a confundirlos:

| | `TablaTraza` (existe) | `Trazador` (por construir) |
|---|---|---|
| Qué es | **Ejercicio E1**: el estudiante rellena las celdas ocultas | **Artefacto de exposición**: el estudiante avanza y mira |
| Quién pone los valores | El estudiante; el componente califica | El componente; nadie califica |
| Para qué sirve | Comprobar que sabe trazar | **Enseñar** qué es trazar, antes de pedírselo |
| Dónde vive | LP-CORE | LP-CORE (H1) |

El capítulo los usa en ese orden: primero se **ve** una traza ejecutarse paso a
paso (`Trazador`), después se **hace** una (`TablaTraza`). Extender `TablaTraza`
con un modo «guiado» mezclaría dos responsabilidades en un componente que ya
califica con tolerancia; se construye aparte.

### H3 · La sección 4 es el núcleo y necesita un fallo que solo la traza encuentre

El gancho del capítulo, fijado en §4 bis del plan maestro, es: *«el programa corrió
sin errores y la liquidación salió mal»*. Para que la sección 4 lo sostenga hace
falta un ejemplo donde **la máquina no reporte nada** y la traza sea la única
forma de encontrar el fallo. El intercambio `a <- b; b <- a` del E3 previsto en §5
es exactamente eso, y por eso va en la sección 2 —donde se presenta la
asignación—, no en la 4: en la 4 hace falta uno **financiero**, con un descuadre
en pesos. Se escribirá uno de orden de operaciones sobre una liquidación
(descontar antes de aplicar la tasa, o al revés).

### H4 · El capítulo 3 hereda de los dos anteriores y hay que declarar de dónde

La sección 3 «retoma cap. 1» (precedencia) y todo el capítulo se apoya en el
análisis Entrada–Proceso–Salida de cap. 2 §2, que el syllabus llama «Formato
Definición y Análisis» y que aquí vuelve como actividad didáctica de la fila 33.
El punto de control C pide justamente que no haya salto ni repetición entre los
tres capítulos. Se resuelve **citando** —«como se vio en el capítulo 1»— y no
repitiendo la exposición. Es una comprobación de lectura, no automatizable.

### H5 · Un cloze puede vivir en el banco sin una sola regla de contenido

`traza_interes_simple.Rmd` lleva en el banco desde la Fase 0 y **no tiene entrada
en `REGLAS`** de `verificar_cloze.R`. `compilar_banco.R` comprueba la estructura,
no lo que el ejercicio afirma (trampa 8 de la skill). Es decir: el ejercicio se
compila en verde sin que nadie haya comprobado que sus números cierran. Se le
escriben reglas en la Fase 4, junto con las de los siete nuevos. Y se propone una
comprobación estructural nueva: **todo `.Rmd` del banco debe tener entrada en
`REGLAS`**, para que el hueco no se repita. → **Tarea 4.3.**

### H7 · La cadena de comprobación tenía un eslabón menos *(hallado al ejecutar, 2026-08-10)*

La comprobación 1 compara **capítulo ↔ `lp-base.html`**. Faltaba la de antes:
**`lp-base.html` ↔ sus fuentes**. Editar `lp-core-extra.jsx` y olvidar
`ensamblar.py` deja los tres capítulos coincidiendo con una plantilla vieja, y
las doce reglas en verde mientras el material corre la librería anterior.

Apareció al escribir el `Trazador`: el capítulo se abrió **en blanco**, con un
`Minified React error #31` que no dice qué componente lo produjo. Nada estático
lo veía, porque estructuralmente todo era coherente —con el archivo equivocado—.

De ahí la **comprobación 13**, que corre antes que las demás y aborta si falla:
si la plantilla está vieja, el hash de referencia es el de una librería vieja y
todo lo que venga después mide contra el patrón equivocado. Cubre además la
trampa 1 del procedimiento (`ensamblar.py` lee el `head` del capítulo 1, así que
tocarlo también desactualiza la plantilla, y hasta ahora eso no lo veía nadie).

**Prueba negativa registrada:** con una línea añadida a `lp-core-extra.jsx` y sin
ensamblar, `verificar.py` devuelve 1 y señala la línea 2119 como primera
diferencia; restaurada la fuente, vuelve a 0.

### H6 · Siete secciones, siete iconos, sin repetir

Hay 15 iconos utilizables y el capítulo tiene 7 secciones: no hace falta repetir
ninguno (el capítulo 1 repite `Binary`). Asignación propuesta en la Tarea 1.4.

---

## 3. Grafo de dependencias

```
T1.1  Trazador en lp-core-extra.jsx
  │
  ├── T1.2  ensamblar.py → lp-base.html
  │     │
  │     ├── T1.3  migrar.py sobre 01 y 02 + verificar deriva + SHA idempotente
  │     └── T1.4  cp lp-base → 03 + CONFIG + curriculum + purga de la demo
  │                 │
  │                 ├── T2.1  Portada + §1 (la secuencia)
  │                 │     └── T2.2  §2 (leer, asignar, escribir)   ← E3 del intercambio
  │                 │           └── T2.3  §3 (expresiones y precedencia)
  │                 │                 └── T2.4  §4 (prueba de escritorio)  ← núcleo
  │                 │                       └── T2.5  §5 (casos financieros)
  │                 │                             └── T2.6  Evaluación + glosario
  │                 │                                   │
  │                 │                                   └── T3.x  Auditoría
  │                 │                                         └── T4.x  Banco + cierre
  │                 └── (los artefactos propios del capítulo se escriben
  │                      dentro de la sección que los usa, no antes)
```

Nada de la Fase 2 es paralelizable: cada sección referencia a la anterior y la
cuota de ejercicios se reparte entre todas. La Fase 4 (banco) **sí** es
independiente del HTML y podría adelantarse; se deja al final a propósito, para
que los números de los cloze salgan de los mismos casos ya verificados en el
capítulo.

---

## 4. Tareas

### Fase 0 — Rama y plan

#### Tarea 0.1 · Rama nueva
`cap03/control-secuencial` desde `main`. **Hecho.**

#### Tarea 0.2 · Este documento
**Alcance:** S · **Archivos:** `PLAN_TAREA6_CAPITULO_03.md`

---

### ⏸ Punto de control 0 — El plan
- [ ] El usuario aprueba el alcance, la distribución de ejercicios y los tres
      supuestos declarados (§7)
- [ ] En particular: **S1** (el entregable es un taller, no un cuestionario) y
      **D1** (el `Trazador` va a LP-CORE y eso reestampa los capítulos 1 y 2)

---

### Fase 1 — El `Trazador` y el andamio del capítulo · ✅ COMPLETADA (2026-08-10)

> Decisiones del punto de control 0, aprobadas: el `Trazador` va a **LP-CORE**;
> la portada declara el **taller** y no un cuestionario; **18 ejercicios**; y el
> `Trazador` con **trazas fijas**, sin entradas editables.
>
> Añadido no previsto: la **comprobación 13** (H7) y el `Trazador` incorporado a
> la regla 6, para que un `codigo` al que le falte un lenguaje no deje la
> pestaña vacía en silencio. Corregido también un defecto de presentación
> propio: el bloque de código llevaba `overflow-x` **por línea**, de modo que a
> 375 px salía una barra de desplazamiento debajo de cada instrucción y cada
> línea se desplazaba por su cuenta, rompiendo la sangría. Ahora el
> desplazamiento es uno solo para todo el bloque.

#### Tarea 1.1 · Componente `Trazador` en `lp-core-extra.jsx` · ✅
**Descripción:** motor de traza paso a paso. Recibe el código en los cuatro
lenguajes y una lista de pasos `{ linea, estado, nota }`; pinta el código con la
línea activa resaltada y una tabla de variables que se va llenando. Controles:
anterior, siguiente, reiniciar, y salto directo a un paso. La preferencia de
lenguaje es la compartida (`SelectorLenguaje`), como el resto de componentes.

**Criterios de aceptación**
- [x] Los pasos van por lenguaje en `linea` y en `salida` —el número cambia con
      las declaraciones de VBA, y lo impreso no coincide entre Python y R—; los
      **valores de las variables no**, que es justo lo que hay que hacerle ver al
      estudiante (convención del README)
- [x] Navegación por teclado: `←` `→` mueven de paso, `Home`/`End` a los
      extremos, con `role="status"` y `aria-live` en la nota del paso
- [x] Sin dependencias nuevas; sin estado global; no rompe la comprobación 1 en
      ningún capítulo

**Verificación** — medida en el navegador, no de vista
- [x] `verificar.py --con-salidas` en verde sobre los 3 capítulos
- [x] Probado por DOM: siete pasos, valores acumulados correctos, la columna
      Salida aparece en los pasos 6 y 7, y el octavo clic no pasa de 7
- [x] Cambio de lenguaje **a mitad de traza**: el paso se mantiene en 7 y la
      línea activa pasa de 12 (pseudo) a 11 (Python), 11 (R) y 15 (VBA), con la
      salida cambiando a `Total: 22,160,000` solo en Python
- [x] Teclado: `←` retrocede de 7 a 6 y `Home` vuelve a 0. Se despacharon
      eventos `keydown` sintéticos porque en este panel no se puede medir el
      foco (trampa 12)
- [x] Salto directo por los números: el chip 4 lleva al paso 4
- [x] A 375 px, las siete secciones con `scrollWidth` = 375; la tabla mide
      631 px y se desplaza **dentro** de su propio contenedor
- [x] Consola limpia en pestaña nueva (solo los dos avisos de CDN de siempre)

**Dependencias:** ninguna · **Alcance:** M · **Archivos:** `lp-core-extra.jsx`

#### Tarea 1.2 · Regenerar la plantilla · ✅
`ensamblar.py`. SHA de LP-CORE: `9cc19ee3e3e1ce33…` → `7adb03f7f11c0422…`.
**Dependencias:** T1.1 · **Alcance:** XS

#### Tarea 1.3 · Reestampar los capítulos 1 y 2 · ✅
`migrar.py --dry-run` y luego real sobre `01` y `02`; `verificar.py` sobre ambos;
**volver a ejecutar `ensamblar.py` y confirmar que el SHA de `lp-base.html` no se
movió** (trampa 1). Commit aparte, solo con esto.

**Criterios de aceptación**
- [x] El diff de `01` y `02` toca **únicamente** la región LP-CORE: una
      inserción pura de 216 líneas, sin una sola línea retirada
- [x] `verificar.py` en verde sobre los dos, con la misma cuenta de ejercicios de
      antes (13 y 13)
- [x] SHA de `lp-base.html` idéntico antes y después de reestampar

**Dependencias:** T1.2 · **Alcance:** S

#### Tarea 1.4 · Crear el capítulo 3 y purgar la demostración · ✅
`cp lp-base.html 03_LPF_Control_Secuencial.html`, `migrar.py`, y **de una sola
vez** —al reemplazar la región entre `LP-CORE FIN` y `const App`— sustituir el
capítulo de demostración por el andamio real: `CONFIG` con los datos de la fila
33, `curriculum` de 7 secciones con 7 iconos distintos, y las siete secciones
vacías salvo su `Motivacion`.

**Iconos propuestos:** `BookOpen` (portada) · `Workflow` (1. la secuencia) ·
`ArrowDownUp` (2. leer/asignar/escribir) · `Calculator` (3. expresiones) ·
`Bug` (4. prueba de escritorio) · `Grid` (5. casos financieros) · `Award` (evaluación).

**Criterios de aceptación**
- [x] `grep` sin resultados para `Seccion1`, `EJ_INTERES`, `EJ_ACUMULADOR`,
      `TRAZA_CODIGO`, `ORDENA_PASOS`, `EMPAREJA_IZQ`, `chart-demo-saldo`,
      `Plantilla base` — este último aparecía en el `<title>` y en la
      `<meta name="description">`, que `ensamblar.py` reescribe para la
      plantilla y que hay que devolver al capítulo
- [x] `CONFIG` cita la fila 33 textualmente en un comentario, como el capítulo 2
      cita la 32, y deja anotado que aquí el entregable es una tarea
- [x] `verificar.py --sin-cuota` en verde (la cuota estará a cero: es correcto)

**Verificación:** el informe dice **0 ejercicios · E1:0 … E8:0**, que es la
prueba de que la demostración se fue entera: si hubiera quedado, aparecería
exactamente uno de cada tipo y la cuota daría verde con contenido ajeno.

Las siete secciones se entregan ya con su `Motivacion` definitiva —redactada
según §4 bis— porque son las que fijan el arco del capítulo, y con el primer
`Trazador` en la sección 4. El resto del contenido va en la Fase 2.

**Dependencias:** T1.2 · **Alcance:** M

---

### ⏸ Punto de control 1 — El `Trazador` funcionando
- [ ] El usuario ve el `Trazador` corriendo una traza real y aprueba **la
      interacción**: ritmo, cuánta información muestra, si la línea activa se
      distingue, si la tabla se lee
- [ ] Se aprueba antes de escribir las cinco secciones, porque el componente
      aparece en todas y corregirlo después cuesta el capítulo entero
- [ ] Los capítulos 1 y 2 siguen en verde

---

### Fase 2 — Contenido, sección por sección

Una tarea = una sección terminada: motivación + código en cuatro lenguajes +
sus ejercicios. Todas las salidas declaradas se ejecutan **en el momento de
escribirlas**, no al final.

#### Tarea 2.1 · Portada + Sección 1 — «La secuencia: el orden importa»
Portada con identificación (fila 33), qué se lleva, `Pipeline` de 5 pasos y la
nota de los cuatro lenguajes. Sección 1: la secuencia como una de las tres
estructuras básicas; por qué el orden no es negociable; `FlujogramaSecuencial`
(SVG propio del capítulo) con el flujo lineal anotado.
**Ejercicios:** E5 (ordenar una liquidación desordenada) · E2 (predecir la salida
de una secuencia con dos líneas permutadas).
**Alcance:** M

#### Tarea 2.2 · Sección 2 — «Leer, asignar, escribir»
Las tres instrucciones elementales. Asignación destructiva: qué le pasa al valor
anterior. Aquí va el **E3 del intercambio** (`a <- b; b <- a`), diagnosticado como
*sobrescritura antes de lectura*, con su costo en pesos.
**Ejercicios:** E3 (intercambio) · E1 (traza de 3 variables) · E2 (predecir salida).
**Alcance:** M

#### Tarea 2.3 · Sección 3 — «Expresiones y precedencia»
Retoma el capítulo 1 **citándolo**, no repitiéndolo (H4). El caso propio: una
fórmula de liquidación donde el paréntesis cambia el resultado en pesos.
**Ejercicios:** E2 (precedencia) · E4 (dos expresiones, ¿equivalentes?).
**Alcance:** M

---

### ⏸ Punto de control 2 — Tono, densidad y primer tercio
- [ ] El usuario lee portada y secciones 1–3 y aprueba densidad, tono y
      profundidad del caso financiero
- [ ] Se confirma que la sección 3 **cita** el capítulo 1 sin repetirlo
- [ ] 7 ejercicios escritos; `verificar.py --sin-cuota --con-salidas` en verde

---

#### Tarea 2.4 · Sección 4 — «La prueba de escritorio como método» ← núcleo
El método formal: qué columnas tiene una tabla de traza, cuándo se escribe una
fila, qué se hace con las expresiones intermedias. `Trazador` con **tres
algoritmos distintos** (criterio de aceptación de la Tarea 6 del plan maestro).
El fallo silencioso de H3: una liquidación que corre sin error y da mal.
**Ejercicios:** E1 ×2 (la segunda con 5 variables y 12 instrucciones) · E3 (el
fallo silencioso) · E5.
**Alcance:** M-L · **es la sección más pesada del capítulo**

#### Tarea 2.5 · Sección 5 — «Casos financieros»
Interés simple, descuento comercial, conversión nominal ↔ efectiva y liquidación
de nómina, los cuatro como rutinas secuenciales. `CalculadoraTasas` (artefacto
propio del capítulo) con la fórmula en MathJax actualizándose.
**Ejercicios:** E1 (traza de nómina) · E4 (nominal vs. efectiva) · E7 ×2 (cuál
crédito conviene; qué significa esa cifra para el cliente) · E8 (por qué se
convierte la tasa antes de comparar).
**Alcance:** M-L

#### Tarea 2.6 · Evaluación y glosario
E6 (emparejamiento que cruza las cinco secciones), E8 (justificar una decisión de
diseño), `Quiz` de 10 preguntas y glosario.
**Criterio no negociable:** el cuestionario se **responde entero** y se sacan
10/10 (trampa 11).
**Alcance:** M

---

### ⏸ Punto de control 3 — Contenido completo
- [ ] Las 7 secciones completas, 18 ejercicios, cuota cumplida
- [ ] El usuario aprueba el capítulo completo: dificultad de los ejercicios y
      utilidad real del `Trazador` en contexto
- [ ] `verificar.py --con-salidas` en verde **con** cuota

---

### Fase 3 — Auditoría

#### Tarea 3.1 · Las doce comprobaciones y las salidas ejecutadas
`verificar.py --con-salidas` sobre los tres capítulos. Toda cifra declarada tras
`#>` ejecutada de verdad.
**Alcance:** S

#### Tarea 3.2 · Auditoría por DOM en el navegador
- Cada ejercicio que califica, conducido hasta el veredicto **en los cuatro
  lenguajes**, incluida una respuesta incorrecta
- El `Trazador` recorrido entero en sus tres algoritmos
- Cuestionario respondido con las diez buenas → debe dar 10/10
- Consola limpia
**Alcance:** M · **es la tarea que más defectos ha encontrado en este proyecto**

#### Tarea 3.3 · Viewport de 375 px, sección por sección
Con la barra lateral **cerrada**: `document.documentElement.scrollWidth` igual al
viewport, y ningún elemento fuera de él que no esté dentro de su propio
contenedor con `overflow-x`.
**Alcance:** S

#### Tarea 3.4 · Contraste
Medir en el navegador sobre el fondo real cada aviso de la comprobación 10 y
escribir `contraste-ok` con la razón medida. Nada se indulta de vista.
**Alcance:** XS

---

### ⏸ Punto de control 4 — Auditoría
- [ ] Las cuatro tareas de la Fase 3, cerradas y con evidencia
- [ ] Punto de control **C** del plan maestro: capítulos 1, 2 y 3 sin deriva y sin
      salto conceptual entre ellos

---

### Fase 4 — Banco de Moodle y cierre

#### Tarea 4.1 · Siete cloze nuevos
Sobre el único existente (`traza_interes_simple`), hasta los 8 que pide §5:

| # | Nombre | Tipos | Qué comprueba |
|---|---|---|---|
| 1 | `traza_interes_simple` *(existe)* | num·num·schoice | traza + interpretación |
| 2 | `traza_filas` | num ×3 | completar tres filas de una tabla de traza |
| 3 | `salida_secuencia` | num | qué imprime una secuencia |
| 4 | `intercambio_lineas` | schoice | efecto de permutar dos instrucciones |
| 5 | `precedencia_liquidacion` | num | precedencia en una fórmula de liquidación |
| 6 | `tasa_efectiva_anual` | num, `extol` 0.0001 | conversión nominal → efectiva |
| 7 | `credito_conviene` | schoice | cuál de dos créditos conviene al cliente |
| 8 | `liquidacion_nomina` | num·num·schoice | traza de nómina + interpretación |

El 5 debe ser **distinto** del `precedencia_operadores` de cap01: aquí la
expresión es una liquidación con dinero, no una expresión abstracta.
**Trampa 9:** todo número que se imprima va envuelto en
`num <- function(x) format(x, scientific = FALSE, trim = TRUE)`.
**Alcance:** L → se ejecuta en dos tandas de cuatro
**Archivos:** `Banco Moodle/rmd/cap03/*.Rmd` *(no se versionan: `.gitignore`)*

#### Tarea 4.2 · Reglas de contenido para los ocho
Una entrada en `REGLAS` de `verificar_cloze.R` por ejercicio, **incluida la del
piloto que no la tiene** (H5). `--reps 1000`.
**Alcance:** M

#### Tarea 4.3 · Comprobación nueva: ningún `.Rmd` sin reglas
Que `verificar_cloze.R` falle si encuentra un `.Rmd` en el banco sin entrada en
`REGLAS`. **Con su prueba negativa registrada**: se comprueba renombrando
temporalmente una entrada y viendo que falla.
**Alcance:** S

#### Tarea 4.4 · Compilar y verificar el banco
`compilar_banco.R --cap 03` y `verificar_cloze.R --reps 1000`. Inventario
actualizado: 8 filas de `cap03`.
**Alcance:** XS

#### Tarea 4.5 · Cierre
- Bitácora §11 del plan maestro: qué se entregó, qué defectos aparecieron, qué
  aprendió la skill
- §6 del plan maestro: Tarea 6 y punto de control C marcados
- `index.html` de la raíz: tarjeta del capítulo 3
- Informe al usuario de **los huecos de la skill** encontrados en esta tarea
  (H1 y H5 ya son dos)
- PR contra `main`
**Alcance:** S

---

### ⏸ Punto de control final
- [ ] `verificar.py --con-salidas` en verde sobre los 3 capítulos
- [ ] `compilar_banco.R` y `verificar_cloze.R --reps 1000` en verde, 8 cloze
- [ ] Sin residuos de plantilla ni de andamio
- [ ] Bitácora escrita y PR abierto

---

## 5. Cuota de ejercicios — distribución objetivo

18 ejercicios: el **techo** del rango §4 (14–18). Se justifica porque el capítulo
son 6 horas frente a las 4 de los capítulos 1 y 2, que cerraron con 13.

| Sección | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 | Total |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 · La secuencia | | 1 | | | 1 | | | | 2 |
| 2 · Leer, asignar, escribir | 1 | 1 | 1 | | | | | | 3 |
| 3 · Expresiones y precedencia | | 1 | | 1 | | | | | 2 |
| 4 · Prueba de escritorio | 2 | | 1 | | 1 | | | | 4 |
| 5 · Casos financieros | 1 | | | 1 | | | 2 | 1 | 5 |
| Evaluación | | | | | | 1 | | 1 | 2 |
| **Total** | **4** | **3** | **2** | **2** | **2** | **1** | **2** | **2** | **18** |
| Cuota §4 | 3–4 | 2–3 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 | 14–18 |

Más el `Quiz` integrador de 10 preguntas.

---

## 6. Riesgos

| # | Riesgo | Impacto | Mitigación |
|---|---|---|---|
| R-A | Reestampar LP-CORE toca los capítulos 1 y 2; un error ahí rompe material ya publicado | Alto | Commit aparte solo con el reestampado · `verificar.py` sobre los tres · SHA de `lp-base.html` comprobado antes y después (trampa 1) |
| R-B | El `Trazador` es el componente más complejo del curso y lo heredan tres capítulos más; corregirlo después cuesta cuatro reestampados | Alto | Punto de control 1 **antes** de escribir las secciones |
| R-C | 18 ejercicios × 4 lenguajes = 72 fragmentos que califican; un `lineaCorrecta` fijo califica mal en silencio | Alto | Comprobaciones 6 y 8 · auditoría por DOM en los cuatro lenguajes (T3.2) |
| R-D | Las cifras de los casos financieros (tasa efectiva, nómina) se escriben más rápido de lo que se ejecutan | Alto | Toda salida se ejecuta al escribirla, no al final · `--con-salidas` en cada punto de control |
| R-E | La conversión nominal ↔ efectiva usa convenciones que difieren entre textos (año de 360 o 365 días, periodo vencido o anticipado) | Medio | Se declara la convención **en el capítulo**, visible para el estudiante, y se usa la misma en el HTML y en los cloze |
| R-F | Los cloze `num` con dinero fallan de forma intermitente si el sorteo da un número ≥ 10⁴ (trampa 9) | Medio | `num()` obligatorio en todo valor impreso · `--reps 1000` |

---

## 7. Supuestos declarados

- **S1 · El entregable del capítulo 3 es un taller, no un cuestionario.** La
  portada declarará «Taller "Estructuras de Control Secuencial" y "Formato
  Definición y Análisis", subidos a Moodle», que es lo que dice la fila 33. Los 8
  cloze quedan como autoevaluación y banco del docente. *(Si prefiere anunciar
  también un cuestionario, cámbielo aquí y se refleja en la portada.)*
- **S2 · La convención de tasas será: año de 360 días, periodo vencido**, salvo
  indicación contraria, declarada de forma visible en la sección 5. Es la de uso
  corriente en la banca colombiana para créditos de consumo.
- **S3 · El hilo financiero sigue siendo la cartera de crédito**, como en los
  capítulos 1 y 2, para que el punto de control D («el hilo financiero es
  continuo entre capítulos») se pueda sostener.

---

## 8. Comandos

```bash
cd "…/Logica de programacion"

python3 "Material html/_plantilla/ensamblar.py"
python3 "Material html/_plantilla/migrar.py" --dry-run "Material html/03_LPF_Control_Secuencial.html"
python3 "Material html/_plantilla/migrar.py"           "Material html/03_LPF_Control_Secuencial.html"
python3 "Material html/_plantilla/verificar.py" --con-salidas

Rscript "Banco Moodle/compilar_banco.R" --cap 03
Rscript "Banco Moodle/verificar_cloze.R" --reps 1000

python3 -m http.server 8777 --directory "Material html"
```

---

## 9. Preguntas abiertas

1. **¿18 ejercicios o 16?** 18 es el techo del rango y son 6 horas de capítulo.
   Si le parece denso, se recortan un E2 y un E5 y quedan 16 sin tocar los
   mínimos obligatorios.
2. **¿El `Trazador` debe permitir editar los valores de entrada** —trazar el
   mismo algoritmo con otro capital— o basta con una traza fija por algoritmo?
   Lo segundo es más simple y suficiente para enseñar el método; lo primero lo
   vuelve una herramienta que el estudiante usaría después. Propongo lo segundo
   ahora y dejarlo abierto para el capítulo 5.
