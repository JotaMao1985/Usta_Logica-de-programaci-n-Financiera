# Plan · Tarea 9 — Capítulo 4, «Control selectivo»

**Rama:** `cap04/control-selectivo` · **Base:** `main` (b0f876b) · **Fecha:** 2026-09-19
**Encargo:** `PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md` §5 (Capítulo 4) y §6 (Tarea 9)
**Skill:** `lpf-capitulo`

---

## 0. Qué se decidió antes de planificar

La Tarea 9 abre la **Fase 3** del plan maestro. Es paralelizable con la Tarea 10
—el capítulo 5— porque las dos comparten el `Trazador`, que ya está construido, y
ninguna depende de la otra.

Tres cosas del contexto cambian este plan:

1. **El punto de control C sigue con una casilla abierta:** la revisión del
   docente sobre el capítulo 3 —dificultad de los ejercicios y utilidad real del
   `Trazador`—. Esta tarea no depende de ella para empezar, pero sí la hereda:
   el capítulo 4 repite el patrón del 3, y lo que allí se corrija hay que
   corregirlo aquí antes de escribirlo, no después. → **Riesgo R1.**
2. **Es la primera tarea de capítulo que no toca la librería.** Los capítulos 1,
   2 y 3 añadieron componentes a LP-CORE y obligaron a reestampar los demás.
   Aquí no hace falta: ver **H4**.
3. **El capítulo 3 dejó deudas escritas en su propio texto.** No son sugerencias:
   están publicadas y un estudiante las va a leer. Ver **H2**.

### Datos del syllabus, textuales

Leídos de `Syllabus Logica de Programacion Financiera.xlsx`, hoja 1, **fila 34**:

| Campo | Valor textual |
|---|---|
| Resultado de aprendizaje (fila 31, col 7) | «Construye un algoritmo computacional incorporando variables de tipo financiero cuya solución lo pueda hacer una calculadora o una computadora» |
| Contenidos (col 26) | «CONTROL SELECTIVO: algoritmos, flujograma, pseudocódigo y codificación.» |
| Actividades didácticas (col 33) | «"Taller Estructuras de Control Selectivo" y "Formato Definición y Análisis"» |
| Tiempos (col 40) | «8 horas» |
| Entregable (col 47) | «Taller y formato Subido en Moodle "Estructuras de control selectivo".» |
| Recursos (col 54) | Charla tutorial 1 «ESTRUCTURAS DE CONTROL» (`https://youtu.be/Dw58xKJiUVc`) y **tres videos propios**: «Estructura selectiva simple» (`https://youtu.be/T9sg17TVgo4`), «Estructura selectiva compuesta» (`https://youtu.be/RNpDw9_JpVo`) y «Estructura selectiva múltiple» (`https://youtu.be/3w3Ue1LkPNI`) |

**Dato heredado:** como el capítulo 3, el entregable es un **taller**, no un
cuestionario. La fila «Evaluación asociada» de la portada debe decir eso. Los 9
cloze del banco siguen siendo autoevaluación y banco del docente, no el
entregable. → **Supuesto S1**, idéntico al del capítulo 3.

**Dato nuevo, y es el más útil:** los tres videos propios de la fila 34 se
corresponden **uno a uno con tres secciones** del capítulo —simple, compuesta,
múltiple—. El corte en secciones que propone el plan maestro no es una invención
nuestra: el syllabus ya lo hace. Las secciones 2, 3 y 5 se alinean con esos tres
videos, y la portada puede enlazarlos donde corresponde en vez de amontonarlos al
principio. (No es la única fila que desglosa recursos por subtema —la 36, de
arrays, hace lo mismo—, pero sí la única donde el desglose coincide con el corte
en secciones que ya teníamos planeado.)

---

## 1. Estado medido

Ejecutado en la rama, antes de tocar nada:

```
LP-CORE de referencia: 7adb03f7f11c0422…
OK    01_LPF_Introduccion.html        13 ejercicios · E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1
OK    02_LPF_Algoritmos.html          13 ejercicios · E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1
OK    03_LPF_Control_Secuencial.html  18 ejercicios · E1:4 E2:3 E3:2 E4:2 E5:2 E6:1 E7:2 E8:2
Los 3 capítulos pasan la verificación.
```

| Cosa | Medida |
|---|---|
| `lp-base.html` | 3 053 líneas |
| `01_LPF_Introduccion.html` | 4 545 líneas |
| `02_LPF_Algoritmos.html` | 4 130 líneas |
| `03_LPF_Control_Secuencial.html` | 4 746 líneas |
| `04_LPF_Control_Selectivo.html` | **no existe** |
| `Trazador` en LP-CORE | **sí** — `lp-base.html:1930`; el capítulo 3 lo invoca **3 veces** |
| `EvaluadorLogico`, `ArbolRiesgo`, `SelectivasComparadas` | **no existen** — y no deben ir a LP-CORE (H4) |
| Iconos | 17 definidos, **15 utilizables** |
| Cloze de `cap04` en el banco | **0 de 9** |
| «tabla de verdad» en el material | 2 apariciones, ambas en el capítulo 1 (AND y OR) |
| «De Morgan» en el material | **0 apariciones** |
| Cuota que impone `verificar.py` | E1 3–4 · E2 2–3 · E3 2 · E4 1–2 · E5 1–2 · E6 1 · E7 2 · E8 1–2 · **máximo 18** |

---

## 2. Hallazgos

### H1 · La sección 1, tal como la pide el plan maestro, repetiría el capítulo 1

El plan maestro define la sección 1 como «Condiciones y expresiones lógicas;
tablas de verdad; evaluación en cortocircuito». Medido contra el capítulo 1, eso
**ya está escrito**:

| Contenido | Dónde está ya |
|---|---|
| Operadores relacionales | `01_LPF_Introduccion.html:3583`, sección 3 completa |
| `Y / O / NO` en los cuatro lenguajes | `:3605`–`:3613` y el resumen de `:3843` |
| Tablas de verdad de AND y OR | `:3620` y `:3632` |
| Cortocircuito **y la excepción de VBA** | `:3844`, con el ejemplo `cuenta <> 0 And saldo / cuenta > 1` |

El punto de control C exige explícitamente «sin saltos **ni repeticiones**», y el
capítulo 3 ya resolvió un caso igual: **citó** la tabla de precedencia del
capítulo 1 en vez de repetirla. La sección 1 del capítulo 4 debe hacer lo mismo.

Lo que sí es nuevo y sostiene una sección entera:

1. **La precedencia de relacionales y lógicos.** Es una deuda explícita del
   capítulo 3 (H2) y no está en ningún sitio.
2. **Negar una condición compuesta — De Morgan.** Cero apariciones en los tres
   capítulos. Y es exactamente el error que produce la cascada mal negada de la
   sección 4.
3. **La tabla de verdad como herramienta de decisión, con tres variables.** El
   capítulo 1 muestra las de AND y OR, de dos variables, como referencia de
   operador. Aquí la tabla sirve para otra cosa: decidir si una condición
   compuesta de tres variables —ingreso, score, endeudamiento— dice lo que uno
   cree que dice. Ocho filas, no cuatro, y la pregunta no es «¿qué hace AND?»
   sino «¿aprueba a quien debe?».
4. **El cortocircuito como recurso de diseño.** El capítulo 1 lo presenta como
   una diferencia entre lenguajes. Aquí es una técnica: la condición guardia que
   protege a la siguiente de dividir por cero, y por qué en VBA hay que anidar
   dos `Si` para conseguir lo mismo.

**Decisión:** la sección 1 se titula «Condiciones: lo que el capítulo 1 dejó a
medias», abre citando al capítulo 1 sin repetirlo, y cubre solo esos cuatro
puntos.

### H2 · El capítulo 3 dejó tres deudas escritas, y son contrato

Están publicadas en el material. No son notas internas: un estudiante que llega
al capítulo 4 las ha leído.

1. **La tabla de precedencia, fila 5.ª** (`03_LPF_Control_Secuencial.html:2945`):
   «Relacionales y lógicos — **Al final (capítulo 4)**». Este capítulo tiene que
   cerrar esa fila, con las cuatro sintaxis y con el orden entre `NO`, `Y` y `O`,
   que es donde está el error real: `NO` liga más fuerte que `Y`, y `Y` más que
   `O`.
2. **La tabla de traza gana una columna** (`:4554`): «ya no basta con anotar qué
   valía cada variable, hay que anotar también *por dónde pasó el flujo*». Es una
   promesa concreta sobre el E1 de este capítulo. Ver H3.
3. **El ejercicio de alto valor ya está anunciado**, en el mismo recuadro: «un
   crédito aprobado que no debía aprobarse, con las condiciones "bien" escritas y
   en el orden equivocado».

La tercera choca con el plan maestro, que para el E3 pide «una escala tarifaria
en cascada con rangos solapados y en mal orden». Son **el mismo defecto sobre dos
casos distintos**. Escribir los dos sería contar dos veces la misma historia y
gastar la mitad de la cuota de E3. **Propuesta:** un solo caso, el de aprobación
de crédito que el capítulo 3 ya anunció —es además el hilo financiero del curso—,
y la escala tarifaria se queda como el caso de la sección 5, resuelta *bien*, con
`Segun`. → **P1.**

### H3 · La columna «rama» no obliga a tocar LP-CORE — pero tiene una trampa de tildes

`TablaTraza` (`lp-base.html:1348`) recibe `columnas` y `filas` con claves libres y
`ocultas` por clave; `celdasIguales` compara **primero como texto** y solo después
intenta el camino numérico. Una columna `rama` con valores de texto funciona sin
tocar la librería. La promesa del capítulo 3 se puede cumplir tal cual.

El problema es cuál texto. `normalizarCelda` baja a minúsculas, quita espacios y
unifica los guiones y el vacío, pero **no pliega tildes**: `sí` y `si` son cadenas
distintas y la celda se marca mal. En un capítulo cuya palabra clave es `Si` y
cuya pregunta natural es «¿entró o no entró?», esto es un fallo silencioso
garantizado: el estudiante escribe «sí», que es lo correcto en español, y el
ejercicio le dice que está mal sin explicar nada. Es de la misma familia que la
pregunta imposible de acertar del capítulo 2.

**Salida barata, y la que se toma:** que la columna no se conteste con sí/no. Los
valores son `entonces`, `sino` y `—`, declarados en el enunciado y en la leyenda
de la tabla. Se prueba en el navegador con las dos grafías antes de dar el
ejercicio por bueno.

**Salida cara:** plegar tildes en `normalizarCelda`. Obliga a tocar LP-CORE y
reestampar los cuatro capítulos por algo que solo necesita este. No en esta
tarea. → **P2.**

### H4 · Esta tarea no tiene Fase 1

El capítulo 3 tuvo que construir el `Trazador`, meterlo en LP-CORE y reestampar
los capítulos 1 y 2 — una fase entera antes de escribir una línea de contenido.
Aquí eso no existe:

- `Trazador` **ya está** en LP-CORE y probado en tres trazas del capítulo 3.
- Los tres artefactos que pide el plan maestro —`EvaluadorLogico`, `ArbolRiesgo`,
  `SelectivasComparadas`— son componentes **de un solo capítulo**. La trampa 5 de
  la skill es explícita: meterlos en la librería obligaría a reestampar los ocho
  capítulos por algo que usa uno.

**Consecuencia:** el bloque LP-CORE no se toca, no hay reestampado y la
comprobación 1 —que compara el bloque byte a byte— debe seguir en verde de
principio a fin. Si en algún momento falla, es que alguien editó la librería a
mano, y hay que deshacerlo, no ajustarlo.

### H5 · Seis secciones, seis iconos, sin repetir

Hay 15 iconos utilizables y este capítulo necesita 6 de sección. La convención de
los tres capítulos anteriores es `BookOpen` para la portada y `Award` para la
evaluación; repetir entre capítulos está bien, dentro de uno no.

| Sección | Icono | Por qué |
|---|---|---|
| 1 · Condiciones | `Binary` | verdadero/falso, la tabla de verdad |
| 2 · Selectiva simple | `GitBranch` | la bifurcación; **no lo usa ningún capítulo todavía** |
| 3 · Selectiva doble | `ArrowDownUp` | los dos caminos |
| 4 · Anidadas y en cascada | `Layers` | literal |
| 5 · Selectiva múltiple | `Table` | la tabla de casos; **sin usar todavía** |
| 6 · Casos financieros | `Grid` | igual que la sección de casos del capítulo 3 |

Queda `FunctionSquare` libre para el capítulo 8.

### H6 · `Segun` no existe igual en los cuatro lenguajes, y la regla 4 no perdona

La comprobación 4 de `verificar.py` exige que **todo** `CodeTabs` traiga los
cuatro lenguajes. La sección 5 tiene que mostrar la selectiva múltiple en los
cuatro, y no se comportan igual:

| Lenguaje | Forma | Qué pasa con los **rangos** |
|---|---|---|
| Pseudocódigo | `Segun … Caso` | los admite por convención |
| VBA | `Select Case` | **los admite de verdad**: `Case 1 To 5` |
| Python | `match … case` | necesita guarda: `case x if x < 5` |
| R | `switch` | **no puede**: solo iguala valores exactos; hay que caer a `if / else if` |

No es un inconveniente: es el contenido. La escala tarifaria por rangos —el caso
financiero de la sección 5— se escribe naturalmente con `Select Case` y se
retuerce en R, y eso es justo lo que el plan maestro anota cuando dice que
«`Select Case` anticipa el cap. 6». El bloque se escribe en los cuatro, con la
diferencia explicada en un `Box`, no omitida.

### H7 · El banco de `cap04` no existe, y un cloze sin reglas ya no pasa

Cero de los nueve. Y desde la Tarea 6, `verificar_cloze.R:612` rechaza cualquier
`.Rmd` que no tenga reglas de contenido propias —la comprobación «SIN REGLAS»—.
Cada uno de los nueve nace con su regla en el mismo commit, no después.

Dos trampas heredadas que aplican de lleno aquí:

- **La 9 de la skill:** todo número que se imprima va envuelto en
  `num <- function(x) format(x, scientific = FALSE, trim = TRUE)`. Los cloze de
  tarifa manejan importes por encima de 10⁴ y el fallo es **intermitente**: solo
  aparece cuando el sorteo da un número grande, y solo en el driver de Moodle.
- **La 8:** un cloze puede compilar y no enseñar nada. El caso a vigilar aquí es
  el de la cascada mal ordenada: si el sorteo da un ingreso que cae en el primer
  tramo, la cascada buena y la mala dan **el mismo resultado** y el ejercicio que
  existe para mostrar la diferencia no la muestra. La regla de contenido tiene
  que exigir que el valor sorteado caiga en un tramo donde difieran.

---

## 3. Grafo de dependencias

```
Fase 0 (rama + plan)
   └─► ⏸ PC0 ─► Fase 1 (archivo + 3 artefactos)
                   └─► ⏸ PC1 ─► Fase 2 (contenido, 7 tareas)
                                   ├─► ⏸ PC2 (tras la sección 3)
                                   └─► ⏸ PC3 (contenido completo)
                                          └─► Fase 3 (auditoría) ─► ⏸ PC4
                                                 └─► Fase 4 (banco + cierre) ─► ⏸ PC final
```

Fuera del grafo, pero encima de él: **la revisión del capítulo 3** (punto de
control C). Cuanto más tarde llegue, más caro sale aplicar aquí lo que corrija.

---

## 4. Tareas

### Fase 0 — Rama y plan

#### Tarea 0.1 · Rama nueva · ✅
`cap04/control-selectivo`, desde `main` en `b0f876b`.

#### Tarea 0.2 · Este documento · ✅
Estado medido, siete hallazgos, cuota repartida y las preguntas abiertas.

### ⏸ Punto de control 0 — El plan
- [ ] **P1:** ¿el E3 de alto valor es la aprobación de crédito que anunció el
      capítulo 3, o la escala tarifaria que pide el plan maestro? (H2)
- [ ] **P2:** ¿se acepta `entonces`/`sino` como vocabulario de la columna de
      rama, o se prefiere tocar LP-CORE para plegar tildes? (H3)
- [ ] ¿Se aprueba el recorte de la sección 1? (H1)
- [ ] ¿Se aprueba el reparto de iconos? (H5)

---

### Fase 1 — El archivo y los tres artefactos

#### Tarea 1.1 · Crear el capítulo y purgar la demostración **de una vez**
`cp` de `lp-base.html`, `migrar.py --dry-run` y luego en firme. La demostración
—~2 800 líneas con un ejercicio de cada tipo E1–E8— se retira **en el mismo paso**
en que se sustituye la región entre `LP-CORE FIN` y `const App`. Si no, la
verificación da verde con contenido ajeno.
**Cierre:** `grep` de `Seccion1`, `EJ_INTERES`, `TRAZA_CODIGO`, `ORDENA_PASOS`,
`EMPAREJA_IZQ`, `chart-demo-saldo`, `Plantilla base` — cero apariciones.

#### Tarea 1.2 · `CONFIG` y `curriculum` contra la fila 34
El `CONFIG` que llega con la plantilla **no tiene ningún `TODO`**: hay que
reescribirlo a mano. Entregable = taller (S1). Los tres videos, cada uno en su
sección.

#### Tarea 1.3 · `EvaluadorLogico`
Tabla de verdad construible: se marcan los valores de tres variables y la
expresión compuesta se evalúa a la vista, mostrando **qué se evaluó y qué no** por
cortocircuito. Componente de capítulo.

#### Tarea 1.4 · `ArbolRiesgo`
Árbol de decisión de riesgo crediticio navegable: al elegir ingreso, score y
endeudamiento se ilumina la rama recorrida y la decisión final. Es el artefacto
que da sentido a la sección 6 y el que sostiene el E7.

#### Tarea 1.5 · `SelectivasComparadas`
El mismo problema con `Si` anidados y con `Segun`, lado a lado. Sostiene el E4
—¿son equivalentes? ¿hay algún valor donde difieran?—.

### ⏸ Punto de control 1 — Los tres artefactos
- [ ] Los tres funcionan en el navegador, con teclado y a 375 px
- [ ] La comprobación 1 sigue en verde: **el bloque LP-CORE no se movió** (H4)
- [ ] Ningún residuo de la demostración

---

### Fase 2 — Contenido, sección por sección

Una tarea = una sección terminada: motivación + código en los cuatro lenguajes +
sus ejercicios. No se recorre el capítulo tres veces.

#### Tarea 2.1 · Portada + Sección 1 — «Condiciones: lo que el capítulo 1 dejó a medias»
Los cuatro puntos de H1. Cierra la fila 5.ª de la tabla de precedencia (H2.1).

#### Tarea 2.2 · Sección 2 — «Si…Entonces: la instrucción que puede no ejecutarse»
Aquí entra el E1 con la columna de rama (H2.2, H3).

#### Tarea 2.3 · Sección 3 — «Si…Entonces…Sino: los dos caminos»

### ⏸ Punto de control 2 — Tono, densidad y primer tercio
Es el punto donde se corrige el rumbo barato. Se lee el capítulo hasta aquí y se
juzga: ¿las motivaciones son ganchos o índices? ¿la densidad es la del capítulo 3?

#### Tarea 2.4 · Sección 4 — «Anidadas y en cascada» ← **núcleo**
El E3 de alto valor: la cascada con los rangos en el orden equivocado. El
estudiante identifica el defecto, lo **nombra** y estima el impacto monetario. El
`DetectaError` lleva `lineaCorrecta` y `explicacion` **por lenguaje** —el mismo
fallo no cae en la misma línea en los cuatro— y el enunciado no cita ningún
número (trampas 4 y 8 de la skill).

#### Tarea 2.5 · Sección 5 — «Segun: la selectiva múltiple»
Los cuatro lenguajes con sus diferencias reales (H6), y el `Box` que explica por
qué en R hay que caer a `if / else if`.

#### Tarea 2.6 · Sección 6 — «Casos financieros»
Clasificación de riesgo, escalas tarifarias, retención en la fuente, aprobación
automática. `ArbolRiesgo` vive aquí. El E7: el sistema rechazó un crédito; dada la
traza, explicarle al cliente **cuál** condición falló.

#### Tarea 2.7 · Evaluación y glosario
Diez preguntas. **La bandera `multiple: true` en toda pregunta con dos respuestas
correctas** — la trampa 11, que en el capítulo 2 produjo una pregunta imposible de
acertar. El E6 (`Emparejamiento`) cruza las seis secciones.

### ⏸ Punto de control 3 — Contenido completo
- [ ] Las seis secciones, la portada y la evaluación
- [ ] Cuota cumplida (§5)
- [ ] Las tres deudas del capítulo 3 saldadas (H2)

---

### Fase 3 — Auditoría

#### Tarea 3.1 · `verificar.py --con-salidas`
Las doce comprobaciones, con las salidas de Python y R **ejecutadas**.

#### Tarea 3.2 · Auditoría por DOM
Cada ejercicio que califica, conducido hasta el veredicto en los cuatro lenguajes,
**incluida una respuesta mala**. El cuestionario final respondido entero, y
acertadas las diez: es la única forma de descubrir una pregunta imposible.

#### Tarea 3.3 · La prueba de la tilde
Específica de este capítulo (H3): en cada `TablaTraza` con columna de rama,
comprobar por DOM que el vocabulario declarado se acepta y que ninguna respuesta
razonable en español se marca mal por una tilde.

#### Tarea 3.4 · 375 px, sección por sección
Con la barra lateral **cerrada**. `scrollWidth` igual al viewport.

#### Tarea 3.5 · Contraste
El gold nunca es texto sobre fondo claro. Medido en el navegador, con la razón
escrita en la línea; no indultado de vista.

### ⏸ Punto de control 4 — Auditoría
- [ ] Las doce en verde · consola limpia · 375 px · contraste medido
- [ ] Toda comprobación nueva con su **prueba negativa** registrada

---

### Fase 4 — Banco de Moodle y cierre

#### Tarea 4.1 · Nueve cloze
Tabla de verdad (mchoice), salida de un `Si` anidado (num), rama ejecutada
(schoice), condición faltante (string), tarifa con la cascada correcta (num),
tarifa con la cascada errónea (num) + diferencia (num), `Segun` sin caso por
defecto (schoice), cortocircuito (schoice).

#### Tarea 4.2 · Sus nueve reglas de contenido
En `verificar_cloze.R`, en el mismo commit (H7). Incluida la regla que impide que
la cascada buena y la mala coincidan.

#### Tarea 4.3 · Compilar y verificar
`compilar_banco.R --cap 04` y `verificar_cloze.R --reps 1000`.

#### Tarea 4.4 · Portal
La tarjeta 04 de `index.html` deja de ser `pendiente` y pasa a enlace.

#### Tarea 4.5 · Cierre
Bitácora en la §11 del plan maestro. Si apareció un defecto de fondo, su regla
nueva en `verificar.py` o en `verificar_cloze.R`.

### ⏸ Punto de control final
- [ ] `verificar.py --con-salidas` en verde sobre los **cuatro** capítulos
- [ ] Banco compilado y verificado con `--reps 1000`
- [ ] El capítulo abre desde `file://` sin errores de consola
- [ ] **Revisión del docente:** leído completo, aprobada la dificultad

---

## 5. Cuota de ejercicios — distribución objetivo

18 ejercicios, el máximo que permite la cuota. El capítulo 3 llegó a 18 con 6
horas; este tiene 8.

| Sección | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 | Total |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 · Condiciones | | 1 | | | | | | | 1 |
| 2 · Simple | 1 | | | | 1 | | | | 2 |
| 3 · Doble | 1 | 1 | | | | | | 1 | 3 |
| 4 · Anidadas y cascada | 1 | | **2** | 1 | | | | | 4 |
| 5 · Múltiple | | 1 | | 1 | 1 | | | 1 | 4 |
| 6 · Casos financieros | 1 | | | | | | 2 | | 3 |
| Evaluación | | | | | | 1 | | | 1 |
| **Total** | **4** | **3** | **2** | **2** | **2** | **1** | **2** | **2** | **18** |
| Cuota | 3–4 | 2–3 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 | |

Los dos E3 son la cascada mal ordenada (sección 4, el de alto valor) y uno menor
sobre una condición negada al revés, que es De Morgan aplicado.

---

## 6. Riesgos

| # | Riesgo | Impacto | Mitigación |
|---|---|---|---|
| R1 | **La revisión del capítulo 3 llega tarde** y obliga a rehacer secciones ya escritas del 4 | Alto | Pedirla antes del PC1. El capítulo 4 repite el patrón del 3: cuanto más tarde se corrija, más caro |
| R2 | **La sección 1 se escribe repitiendo el capítulo 1** por inercia | Medio | H1 fija los cuatro puntos y prohíbe el resto; el PC2 lo revisa leyendo los dos seguidos |
| R3 | **La columna de rama marca mal respuestas correctas** por una tilde | Alto — silencioso | Vocabulario sin tildes (H3) y la Tarea 3.3, que lo prueba por DOM |
| R4 | **Los cloze de tarifa fallan de forma intermitente** por la notación científica | Medio | `num()` desde el primer `.Rmd` y `--reps 1000` |
| R5 | **Un cloze de cascada que no distingue** la versión buena de la mala | Medio | Regla de contenido que exige un valor sorteado en un tramo donde difieran (H7) |
| R6 | **Alguien edita LP-CORE** para que la columna de rama quede más bonita | Alto | La comprobación 1 lo caza byte a byte; H4 dice que la respuesta es deshacerlo |
| R7 | **Una pregunta imposible de acertar** en la evaluación | Alto | `multiple: true`, la regla 12, y responder las diez acertándolas |

---

## 7. Supuestos declarados

- **S1 · El entregable es un taller, no un cuestionario.** Igual que el capítulo
  3, leído de la col. 47 de la fila 34. Los 9 cloze son autoevaluación y banco del
  docente.
- **S2 · El hilo financiero sigue siendo la cartera de crédito.** Es lo que da
  continuidad con los capítulos 1 a 3 y lo que el capítulo 3 anunció.
- **S3 · Los tres videos del syllabus se enlazan en su sección**, no en la
  portada. Si se prefiere agruparlos, es un cambio de una línea.
- **S4 · 18 ejercicios.** El máximo de la cuota, coherente con 8 horas.

---

## 8. Comandos

```bash
cd "…/Logica de programacion"

cp "Material html/_plantilla/lp-base.html" "Material html/04_LPF_Control_Selectivo.html"
python3 "Material html/_plantilla/migrar.py" --dry-run "Material html/04_LPF_Control_Selectivo.html"
python3 "Material html/_plantilla/migrar.py"           "Material html/04_LPF_Control_Selectivo.html"

python3 "Material html/_plantilla/verificar.py" --sin-cuota    # capítulo a medias
python3 "Material html/_plantilla/verificar.py" --con-salidas  # el completo

Rscript "Banco Moodle/compilar_banco.R" --cap 04
Rscript "Banco Moodle/verificar_cloze.R" --reps 1000

python3 -m http.server 8777 --directory "Material html"
```

---

## 9. Preguntas abiertas

- **P1 · ¿Cuál es el caso del E3 de alto valor?** El capítulo 3 anunció «un
  crédito aprobado que no debía aprobarse»; el plan maestro pide «una escala
  tarifaria en cascada». Es el mismo defecto sobre dos casos. Propuesta: el
  crédito en la sección 4 —porque ya está prometido— y la escala tarifaria en la
  sección 5, resuelta bien con `Segun`. (H2)
- **P2 · ¿Vocabulario sin tildes o LP-CORE con plegado de tildes?** Lo barato es
  `entonces`/`sino`. Lo correcto a largo plazo es que `normalizarCelda` pliegue
  tildes, pero obliga a reestampar los cuatro capítulos. (H3)
- **P3 · ¿Cuánto VBA se adelanta en la sección 5?** `Select Case` con rangos es
  contenido del capítulo 6. Mostrarlo aquí funciona y el plan maestro lo prevé,
  pero hay que decidir si se explica o solo se enseña.
- **P4 · ¿La revisión del capítulo 3, antes o después del PC1?** Antes abarata el
  R1; después no bloquea el arranque. (R1)
