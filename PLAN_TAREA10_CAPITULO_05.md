# Plan · Tarea 10 — Capítulo 5, «Control repetitivo»

**Rama:** `cap05/control-repetitivo`, en el *worktree* `.claude/worktrees/cap05` · **Base:** `main` (b4712a2) · **Fecha:** 2026-09-28
**Encargo:** `PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md` §5 (Capítulo 5) y §6 (Tarea 10)
**Skill:** `lpf-capitulo`
**Estado:** PC0 y PC1 aprobados el 2026-09-28 (§9); PC2 aprobado el 2026-10-18. El 2026-10-19 se trajo `main` y se escribieron las secciones 4 y 5 (Tareas 2.4 y 2.5); la 4 quedó aprobada ese día. El 2026-10-20 se revisó el contenido de los capítulos 4 y 5 y se corrigieron sus graves y medios (H18). Siguiente: la sección 6 (Tarea 2.6).

---

## 0. Qué se decidió antes de planificar

La Tarea 10 cierra la **Fase 3** del plan maestro y, con ella, el RA1: las horas
de las filas 31 a 35 del syllabus suman 4 + 4 + 6 + 8 + 8 = **30**, que es lo
que exige el punto de control D.

Hay tres cosas del contexto que cambian este plan:

1. **Quedan revisiones del docente sin hacer, y el capítulo 5 las hereda.** Está
   abierta la del capítulo 3, en el punto de control C, y las de los PC1, PC2 y PC
   final del capítulo 4. El capítulo 5 repite el patrón de los dos: lo que se
   corrija allí habrá que corregirlo aquí, y sale más barato antes de escribirlo.
   → **Riesgo R1.**
2. **El capítulo 4 no está cerrado del todo.** Su Fase 4 —los nueve cloze— no se
   ejecutó: en `Banco Moodle/rmd/` no hay carpeta `cap04`. El punto de control D
   pide unos cuarenta cloze del RA1, y hoy hay 21. Esta tarea no depende de eso,
   pero el PC D no se puede cerrar sin él. → **H12.**
3. **Hay otra sesión trabajando en esta misma carpeta** («Revisión capítulo 4»).
   Cambiar de rama aquí le movería el árbol de trabajo. La rama del capítulo 5 se
   creó en un *worktree* (`.claude/worktrees/cap05`), porque esa sesión seguía
   abierta al aprobarse el PC0. → **R9.**

### Datos del syllabus, textuales

Leídos de `Syllabus Logica de Programacion Financiera.xlsx`, hoja 1, **fila 35**:

| Campo | Valor textual |
|---|---|
| Resultado de aprendizaje (fila 31, col 7) | «Construye un algoritmo computacional incorporando variables de tipo financiero cuya solución lo pueda hacer una calculadora o una computadora» |
| Contenidos (col 26) | «CONTROL REPETITIVO: algoritmos, flujograma, pseudocódigo y codificación.» |
| Actividades didácticas (col 33) | «"Taller Estructuras de Control Repetitivo" y "Formato Definición y Análisis" Estructuras de control juego (Millonario)» |
| Tiempos (col 40) | «8 horas» |
| Entregable (col 47) | «Tarea subida en Moodle "Estructuras de control repetitivo". Plataforma Moodle Estructuras de control juego en Moodle» |
| Recursos (col 54) | Charla tutorial 1 «ESTRUCTURAS DE CONTROL», videos 1, 2 y 3 (`https://youtu.be/Dw58xKJiUVc`) |

**Lo que se hereda del capítulo 4:** el entregable es una **tarea**, no un
cuestionario, así que los diez cloze siguen siendo autoevaluación y banco del
docente. → **S1.**

**Lo que cambia respecto del capítulo 4:**

- **No hay videos propios.** En la fila 34 había tres videos, uno por sección. La
  fila 35 solo trae la charla general de estructuras de control, así que el
  syllabus no dicta el corte en secciones: el que se propone es nuestro.
- **Aparece un juego**, el «Millonario». Es la primera fila del RA1 con una
  actividad así. El docente lo tiene montado con preguntas **cloze**, así que se
  alimenta del mismo banco. → **H11.**

---

## 1. Estado medido

Ejecutado sobre `main` en 02a3b9b, antes de tocar nada. Vuelto a medir en b4712a2
al crear la rama: solo cambian los cuestionarios de los capítulos 1 y 2 (el 1 baja
de 4 avisos de la regla 17 a 3), y las líneas citadas en H1 siguen apuntando a lo
mismo.

```
LP-CORE de referencia: 03dba46fa0fae198…
AVISO 01_LPF_Introduccion.html       13 ejercicios · E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1   (3 avisos de la regla 17)
AVISO 02_LPF_Algoritmos.html         13 ejercicios · E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1   (7)
AVISO 03_LPF_Control_Secuencial.html 18 ejercicios · E1:4 E2:3 E3:2 E4:2 E5:2 E6:1 E7:2 E8:2   (4)
AVISO 04_LPF_Control_Selectivo.html  19 ejercicios · E1:4 E2:4 E3:2 E4:2 E5:2 E6:1 E7:2 E8:2   (1)
Los 4 capítulos pasan la verificación.
```

| Cosa | Medida |
|---|---|
| `lp-base.html` | 3 077 líneas |
| Capítulos 1 · 2 · 3 · 4 | 4 579 · 4 164 · 4 780 · 5 665 líneas (en b4712a2) |
| `05_LPF_Control_Repetitivo.html` | **no existe** |
| `Trazador` en LP-CORE | **sí** — `lp-base.html:1954`. Se usa cuatro veces entre los capítulos 3 y 4, y ya calcula lo ejecutado **por pasos, no por líneas**. Su comentario prevé los ciclos del capítulo 5 (H9) |
| `TablaTraza` con `exigeRespuesta` | **sí** — `lp-base.html:1355` |
| Plotly | cargado en la plantilla (2.35.2), con `ChartFrame` + `usePlotly` (`lp-base.html:831`) |
| `AmortizacionPasoAPaso`, `TIRBiseccion`, `TresCiclosComparados` | **no existen**, y no deben ir a LP-CORE (H9) |
| Iconos | 17 definidos, **15 utilizables**; `FunctionSquare` sin usar |
| `Salir` en la gramática del pseudocódigo | **no está** (`lp-base.html:997`), y el capítulo 2 lo usa cuatro veces (H6) |
| Cloze en el banco | cap01: 7 · cap02: 6 · cap03: 8 · **cap04: 0** · cap05: 0 |
| Cuota que impone `verificar.py` | E1 3–4 · E2 2–4 · E3 2 · E4 1–2 · E5 1–2 · E6 1 · E7 2 · E8 1–2 · **máximo 19** |
| Ciclos que el material ya hace trazar antes del capítulo 5 | **siete sitios**, en los capítulos 1 y 2 (H1) |

---

## 2. Hallazgos

### H1 · El estudiante llega al capítulo 5 habiendo trazado ciclos

El plan maestro trata el capítulo 5 como el lugar donde aparece la repetición.
Medido contra el material publicado, no es así: los capítulos 1 y 2 ya piden
leer y trazar ciclos, y algunos de esos ejercicios son justo los que el plan
maestro pondría aquí.

| Qué | Dónde está ya |
|---|---|
| Conversión a binario con `Mientras numero > 0` y su **E1, una fila por vuelta** | `01_LPF_Introduccion.html:2633` y `:2813`, sección 1 |
| `Para i <- 1 Hasta 12` que lee la tasa dentro del ciclo (E4) | `01:3029`, sección 2 |
| `Mientras saldo < meta` (E1) y **la frontera `<` contra `<=`** (E2, meta de 1 020 000) | `01:3446` y `:3738`, sección 3 |
| Acumular 0,1 tres veces (E1) y conciliar cien centavos con un `Para` (E3) | `01:4131` y `:3983`, sección 4 |
| «Repita hasta obtener un resultado razonable» **falla la finitud** | `02_LPF_Algoritmos.html:2399`, sección 1 |
| Búsqueda lineal (`Para` + `Salir`) contra búsqueda binaria (`Mientras izq <= der`), **contando vueltas** | `02:3541`, sección 5; el recuadro de `02:3750` dice que son «las estructuras repetitivas del capítulo 5» y que «basta con leerlas» |
| El patrón **acumulador**, con ese nombre | `02_LPF_Algoritmos.html:3445` y `:3482`, sección 4, con la inicialización en cero y su entrada de glosario; después, `03_LPF_Control_Secuencial.html:2798` y `:3200` *(la fila del capítulo 2 se añadió en la Fase 2: el plan solo citaba el 3)* |

Hay dos consecuencias:

1. **El capítulo no puede presentarse como el primer contacto con los ciclos.**
   Una frase como «por primera vez un programa repite» la desmienten los
   capítulos 1 y 2, y ninguna regla lo caza (es uno de los huecos anotados tras
   la segunda lectura del capítulo 4). Queda como comprobación manual en la
   Tarea 3.6.
2. **Lo que ya está escrito se cita y no se repite**, como hizo el capítulo 4 con
   las tablas de verdad. No se vuelven a enseñar la frontera `<` / `<=` en un
   `Mientras`, la acumulación de décimos ni el conteo de operaciones. Lo nuevo
   es: las tres formas y cuándo conviene cada una, la evaluación **previa**
   frente a la **posterior**, lo que significa `Para` en cada lenguaje, los
   ciclos anidados, los centinelas y **el ciclo que para porque converge**.

**Decisión:** la sección 1 abre desde ahí: *usted ya trazó cuatro ciclos sin que
nadie le dijera cómo se llamaban*.

### H2 · Cuatro capítulos dejaron promesas escritas, y son contrato

Están publicadas. Un estudiante que llega al capítulo 5 las ha leído.

1. **«240 filas que nadie escribió».** Aparece en `03:3200` (el acumulador es «el
   patrón con el que el capítulo 5 construirá tablas de 240 filas»), en `03:3592`
   (la tabla de traza es indispensable en el 5, «donde un ciclo asigna sobre la
   misma variable doscientas cuarenta veces») y en el recuadro «Lo que viene» del
   capítulo 4 (`04:5479`). Es también el gancho del §4 bis. **Hay que enseñar una
   tabla de 240 filas**, no una de 12 que la sugiera.
2. **Las dos preguntas del capítulo**, del mismo recuadro del 4: la pregunta
   «deja de ser *por dónde pasó* para volverse *cuántas veces, y cuándo para*».
   Esa frase da la estructura: las secciones 2 a 4 responden **cuántas veces**, y
   la 6 y la bisección de la 7 responden **cuándo para**.
3. **La tabla de traza con muchas vueltas** (`03:3592`). Una traza de 240 vueltas
   no se puede pedir. El E1 traza tres o cuatro, y es el componente el que
   muestra las otras (H9).
4. **La finitud** (`02:2399`). El capítulo 2 la presentó como una propiedad; la
   sección 6 la convierte en técnica y cita el capítulo 2.

### H3 · `Mientras saldo > 0` cobra una cuota de más en dos de cada seis créditos

El ciclo más natural para una tabla de amortización es «mientras quede saldo».
Medido en Python, con amortización francesa y sin redondear la cuota:

| Crédito | Tasa mensual | Plazo | Vueltas con `saldo > 0` | Saldo tras exactamente *n* cuotas |
|---|---|---|---|---|
| 10 000 000 | 1,5 % | 12 | 12 | −7,5 × 10⁻⁸ |
| 20 000 000 | 1,8 % | 36 | **37** | **+2,0 × 10⁻⁸** |
| 80 000 000 | 1,2 % | 240 | 240 | −2,0 × 10⁻⁷ |
| 5 000 000 | 2,0 % | 24 | **25** | **+5,4 × 10⁻⁹** |
| 150 000 000 | 1,1 % | 240 | 240 | −3,6 × 10⁻⁶ |
| 30 000 000 | 1,45 % | 60 | 60 | −1,2 × 10⁻⁷ |

Después de la última cuota queda un residuo de punto flotante, y **su signo
decide** si el ciclo da una vuelta más. Cuando el residuo es positivo, el
programa cobra la cuota 37 de un crédito a 36. Es el punto flotante del
capítulo 1 reapareciendo como **condición de parada**. Y la versión con
`saldo <> 0` no termina nunca: el residuo no es cero, y la vuelta siguiente deja
el saldo en negativo, que tampoco lo es.

Consecuencias:

1. **Para escribir el capítulo:** toda amortización que se controle por saldo se
   ejecuta con las cifras exactas del texto, y se cuenta cuántas vueltas da. Una
   salida declarada puede estar bien por azar y dejar de estarlo si alguien
   cambia la tasa. La tabla de amortización del capítulo se controla **por
   contador** (`Para k <- 1 Hasta n`).
2. **Es el mejor E8 del capítulo:** ¿por qué la tabla se controla con el número de
   cuotas y no con el saldo? La respuesta no es de estilo: es la tabla de arriba.
3. **Es el E3 de la sección 6:** el `Mientras saldo <> 0` que no termina.
4. **Para el banco:** ningún cloze cuenta vueltas de un ciclo controlado por
   saldo, o el sorteo decide la clave. Va como regla en `verificar_cloze.R`.

### H4 · `Para` no significa lo mismo en los cuatro lenguajes, y la trampa más cara es la de R

La regla 4 de `verificar.py` exige los cuatro lenguajes en cada `CodeTabs`. Con
`Para` no basta con traducir, porque cada lenguaje lo interpreta distinto:

| Lenguaje | Forma | Límite superior | Con *n* = 0 | Si el cuerpo cambia el contador |
|---|---|---|---|---|
| Pseudocódigo | `Para i <- 1 Hasta n` | incluido | 0 vueltas | no se hace, por convención |
| Python | `for i in range(1, n + 1)` | **excluido**: `range(1, n)` da *n* − 1 vueltas | 0 vueltas | no afecta: la vuelta siguiente toma el valor que sigue en el rango |
| R | `for (i in 1:n)` | incluido | **2 vueltas, con i = 1 y luego i = 0** (medido); `seq_len(n)` da 0 | no afecta |
| VBA | `For i = 1 To n` | incluido | 0 vueltas | **sí afecta**: `Next` suma el paso al valor ya cambiado |

La fila de R es la importante. Un crédito que ya no tiene cuotas pendientes
(*n* = 0) entra dos veces en el ciclo de cobro, y una de ellas con la cuota
número cero. No da ningún error.

Consecuencias:

1. **Es el contenido de la sección 4**, igual que el `Segun` en los cuatro
   lenguajes fue el de la 5 del capítulo 4. Las diferencias se explican en un
   `Box`, no se omiten.
2. **El E3 de alto valor —la cuota de más o de menos— se escribe con un
   `Mientras k < n`**, que falla igual en los cuatro lenguajes. Si se escribiera
   con `range`, el defecto solo existiría en Python. La línea sigue cambiando con
   el lenguaje, así que `lineaCorrecta` y `explicacion` van por lenguaje
   (trampa 4 de la skill).
3. **El cloze sobre mover la actualización del contador solo existe en
   pseudocódigo y con `Mientras`.** Con `Para`, la respuesta depende del
   lenguaje.

### H5 · `Repita…Hasta` no existe en Python, y su condición es la de `Mientras` negada

| Lenguaje | Forma | Cómo sale |
|---|---|---|
| Pseudocódigo | `Repita … Hasta saldo <= 0` | cuando la condición es **verdadera** |
| Python | `while True:` … `if saldo <= 0: break` | no hay estructura propia; se construye con `break` |
| R | `repeat {` … `if (saldo <= 0) break }` | existe `repeat`; la salida es `break` |
| VBA | `Do` … `Loop Until saldo <= 0` | existe tal cual, y también `Loop While`, con la condición al revés |

Pasar de `Mientras saldo > 0` a `Repita … Hasta saldo <= 0` obliga a **negar la
condición**. Con una condición compuesta, eso es De Morgan, de la sección 1 del
capítulo 4. El E4 de la sección 3 lo aprovecha: dos versiones que parecen
equivalentes y solo difieren cuando la condición es falsa desde el principio.
El caso financiero es un crédito ya pagado al que `Repita` le cobra igual una
cuota.

### H6 · `Salir` no está en la gramática del pseudocódigo *(encontrado al medir)*

`Prism.languages.pseudo` (`lp-base.html:997`) no incluye `Salir`, y el capítulo 2
lo usa cuatro veces en su búsqueda (`02:3543`, `:3553`, `:3648`, `:3684`), donde
se pinta como un identificador cualquiera. Es un defecto pequeño, y es de
LP-CORE: arreglarlo obliga a reestampar los cuatro capítulos.

**Para este capítulo:** el pseudocódigo **no usa `Salir`**. La salida de un
ciclo está en su condición, que es además lo que el capítulo enseña: un ciclo con
la salida en medio del cuerpo esconde cuándo para. Python y R usan `break` solo
para construir el `Repita` que no tienen (H5), y eso se dice en el texto.

Con esta ya son **tres deudas pendientes de LP-CORE**: no plegar tildes en
`normalizarCelda` (P2 del capítulo 4), que `MCQ` solo muestre la justificación
de la opción correcta (H9 del capítulo 4) y `Salir`. → **P3.**

### H7 · El E1 anidado del plan maestro se mete en el capítulo 7

El plan maestro pide una «traza de un ciclo anidado que **llena una matriz** de
amortización de 3 créditos × 4 cuotas». Llenar una matriz exige arreglos
bidimensionales, que son el capítulo 7. El capítulo 2 ya usó `cartera[i]` de
pasada, pero trazar escrituras en una matriz es enseñar arreglos.

**Propuesta:** el ciclo anidado **acumula sin guardar**. El ciclo de fuera
recorre los créditos y el de dentro las cuotas; se lleva un subtotal de
intereses por crédito y un total de la cartera. Con eso, la traza tiene lo que
un ciclo anidado enseña de verdad: que el de dentro vuelve a empezar en cada
vuelta del de fuera. Y aparece el error típico, el subtotal que no se reinicia,
que es el E5 de la sección 5: ordenar las líneas de modo que `subtotal <- 0`
quede **dentro** del ciclo de fuera. → **P2.**

### H8 · El E4 del plan maestro pide reescribir, y la taxonomía lo excluye

Dice: «equivalencia `Para` ↔ `Mientras`: **reescribir** y verificar que el número
de iteraciones coincide». Escribir código es lo que el §4 excluye por diseño; eso
va en la tarea del syllabus. El E4 se hace con `Comparador`: se dan las dos
versiones escritas y el estudiante decide si son equivalentes y, si no lo son,
**con qué entrada difieren**.

### H9 · Esta tarea tampoco toca la librería, pero el `Trazador` tiene un techo

Igual que en el capítulo 4 (H4 de su plan):

- `Trazador` **ya maneja ciclos**. Marca lo ejecutado según los pasos dados y no
  según las líneas que quedan más arriba, y su comentario (`lp-base.html:1950`)
  dice que es para esto: «los capítulos 4 y 5 heredan el componente y allí el
  flujo salta y se repite».
- Los tres artefactos son **componentes de este capítulo** (trampa 5).
- Plotly ya está en la plantilla, y el §7 del plan maestro (R5) cuenta el
  capítulo 5 entre los que lo usan.

**El techo:** el `Trazador` pinta un botón por paso y una fila de historial por
paso. Tres vueltas de un cuerpo de cuatro líneas dan entre quince y veinte
pasos, y caben.
Cuarenta ya no caben en 375 px. Por eso la tabla de 240 filas (H2.1) es un
componente propio y no un `Trazador` largo. Las trazas guiadas se limitan a
**tres vueltas**.

**Consecuencia:** la comprobación 1 sigue en verde de principio a fin. Si falla,
alguien editó la librería a mano, y hay que deshacerlo.

*Medido en la Tarea 2.5:* la traza de la sección 5 tiene **33 pasos**: dos
créditos por tres cuotas, con un cuerpo de dos líneas. A 375 px no saca nada
fuera, y los botones de paso caben en cuatro filas. Lo que crece es el alto: con
el historial completo mide de 3 115 px (R) a 4 171 (pseudocódigo), frente a
1 956–2 140 de la traza de 14 pasos de la sección 2, porque cada fila del
historial parte la instrucción en dos o tres líneas. El código, los botones y la
nota del paso quedan arriba, así que avanzar no obliga a bajar. Las dos salidas que lo bajan son dos cuotas por crédito, con 27 pasos, o
quitar la columna de `tasa`, que no cambia. Las dos quedan a decisión del
docente.

### H10 · Siete secciones y siete iconos, sin repetir ninguno

Quedan 13 iconos, sin contar `BookOpen` (portada) ni `Award` (evaluación).

| Sección | Icono | Por qué |
|---|---|---|
| 1 · Contar y acumular | `Calculator` | el acumulador |
| 2 · `Mientras` | `Repeat` | la repetición *(el borrador decía que ningún capítulo lo usaba; es falso, el 2 lo usa en su sección 5. No importa: la regla es no repetir icono dentro de un capítulo)* |
| 3 · `Repita…Hasta` | `ArrowDownUp` | se baja y después se vuelve a subir |
| 4 · `Para` | `Table` | una fila por valor del contador, la tabla de amortización |
| 5 · Anidados | `Layers` | literal: un ciclo dentro de otro |
| 6 · Cuándo para | `Bug` | el ciclo infinito es un defecto |
| 7 · Casos financieros | `Grid` | el mismo que la sección de casos de los capítulos 3 y 4 |

`FunctionSquare` queda libre para el capítulo 8.

### H11 · El juego «Millonario» se alimenta de cloze *(corregido en el PC0)*

La fila 35 pide un juego «Millonario» en Moodle. El borrador suponía que el
módulo *Game* solo acepta preguntas de **opción múltiple**, y que por tanto los
cloze no servirían. **Era falso para este curso:** el docente tiene el juego
montado con preguntas cloze (respuesta a P4). Los diez cloze de la Fase 4 son,
por tanto, a la vez banco del docente y preguntas del juego, y no hace falta
exportar nada más. Cierra también la pregunta abierta 5 del plan maestro.

### H12 · El banco del capítulo 4 no existe, y el punto de control D lo necesita

`Banco Moodle/rmd/` tiene `cap01` (7), `cap02` (6) y `cap03` (8): **21 cloze**. El
plan del capítulo 4 dejó sin marcar su Fase 4 y su PC final. El PC D pide «~40
cloze compilando»: con los 10 de este capítulo se llega a 31, y los 9 del
capítulo 4 son los que faltan.

Además, la última compilación del banco es del 2026-08-31 (fecha de `xml/`), y
desde entonces no ha entrado ningún cloze nuevo. Conviene compilar con
`--reps 1000` desde el primer cloze de esta tarea, por la trampa 9 (notación
científica intermitente a partir de 10⁴).

### H13 · Lo que las auditorías del capítulo 4 enseñaron, aplicado desde el principio

En el capítulo 4 todo esto se arregló después de escribir. Aquí entra antes:

- **Regla 17:** los distractores se escriben con la longitud de la clave desde el
  primer borrador. Hoy hay 15 avisos en los capítulos 1 a 4.
- **Regla 18:** el cuestionario no repite ejercicios de sección. Si una pregunta
  está repetida, se cambia la pregunta; no se reescribe.
- **Regla 19:** cada pregunta del `Quiz` declara `seccion:`. El capítulo 3 no lo
  hizo, y la regla se lo saltó en silencio.
- **`MCQ`:** la justificación de la opción correcta explica también por qué las
  otras no lo son, porque es el único texto que se lee (H9 del capítulo 4).
- **`exigeRespuesta`** en toda `TablaTraza` donde la raya sea una respuesta. En
  un ciclo, la fila anterior a la primera vuelta suele serlo.
- **Flujogramas:** los tres de este capítulo llevan una flecha de retorno, que es
  justo lo que ensancha un SVG. Desde el primero se hacen con las dos lecciones
  del capítulo 4: dos versiones alternadas con `hidden sm:block` / `sm:hidden`,
  y la leyenda en HTML, no en `<text>`.
- **JSX y espacios:** un salto de línea entre un texto y un elemento se come el
  espacio. Se revisa en el DOM, no en el fuente.
- **Huecos del verificador que este capítulo va a tocar:** números en prosa
  junto a un bloque multilingüe (decir «da 12 vueltas» vale en los cuatro
  lenguajes; decir «la línea 4», no), afirmaciones que otro capítulo desmiente
  (H1) y `TablaTraza` donde la raya sea la mayoría de las celdas ocultas. Ninguno
  tiene regla. Se comprueban a mano en la Fase 3.

### H14 · La cuota fija nunca se presentó *(encontrado en la Fase 1)*

La tabla de amortización necesita la cuota de la amortización francesa, y
ningún capítulo anterior la da. La «cuota fija» del capítulo 2 (`02:2611`) es
`(capital + interes + seguro) / plazo`, con interés simple. El capítulo 3 usa
`(1 + periodica) ^ m - 1` para las tasas, pero nunca la anualidad. Y el plan
maestro deja la cuota fija (`PMT`) para el capítulo 8, como función.

**Decisión provisional de la Fase 1:** la fórmula aparece como un dato, en una
sola línea, `cuota <- capital * tasa / (1 - (1 + tasa) ^ (-n))`, con un
comentario que dice de dónde sale y que el capítulo 8 la convierte en función.
No se deduce ni se ejercita. Así se conserva H3, que se midió con la cuota sin
redondear. La otra salida sería dar la cuota como un número ya redondeado
(916 799,93); pero entonces el residuo final pasa a ser de centavos y la tabla
de H3 deja de valer. → **P6**, aprobada en el PC1.

### H15 · La medida de 375 px de la skill no puede fallar en este formato *(encontrado en la Fase 2)*

La puerta de la skill pide dos cosas a 375 px: `document.documentElement.scrollWidth`
igual al viewport, y ningún elemento fuera de él «que no esté dentro de su propio
contenedor con `overflow-x`». Medido en este capítulo, **la primera no puede
fallar**: el `<main>` del `App` tiene `overflow-x: hidden`, así que lo que se sale
queda recortado y el documento no se ensancha. Se probó con un bloque de 600 px
metido a propósito: `scrollWidth` siguió en 375.

La segunda solo funciona si «su propio contenedor» significa uno que **desplaza**
(`auto` o `scroll`). Un guion que acepte también `hidden` se detiene en el `<main>`
y da por bueno cualquier desborde. Con el criterio corregido, el mismo bloque de
600 px sale señalado, y las nueve entradas del capítulo vuelven a dar cero, con la
tabla completa, los cuatro paneles y la bisección terminada. La conclusión del
PC1 se mantiene, pero ahora está medida con un instrumento que puede fallar.

**Para la skill:** la puerta debe decir que `scrollWidth` es ciego aquí, y que el
contenedor válido es el que desplaza, con la prueba negativa del bloque de 600 px.

*Corregido en la Tarea 2.4:* tal como quedó escrito, el criterio vuelve a ser
ciego. El panel que desplaza la lección (`div.flex-1.overflow-y-auto`, padre de
`.max-w-4xl`) solo declara `overflow-y: auto`, pero el navegador calcula su
`overflow-x` como `auto`: cuando un eje no es `visible`, el otro deja de poder
serlo. Un guion que sube por los ancestros buscando `auto` o `scroll` se detiene
en ese panel y da por bueno el bloque de 600 px. Se comprobó: la prueba negativa
no saltó. Hay que **detener la subida en ese panel**, sin contarlo, y medir además
su `scrollWidth` contra su `clientWidth`, que es la medida de página que
`document.documentElement.scrollWidth` ya no da. Con las dos correcciones, el
bloque de 600 px sale señalado (24 elementos, y el panel pasa de 367 a 624 px). Lo
real da cero. Queda una salvedad: un `CodeBlock` largo arranca **plegado**, y
en ese estado su `pre` recorta con `overflow: hidden` lo que pasa del borde,
sin barra. Es así por diseño, porque es una vista previa, y al desplegarlo
vuelve a desplazar.

*Remedido en la Tarea 2.5:* las medidas del PC2 (portada y secciones 1 a 3) se
habían hecho con el criterio todavía ciego. Repetidas con el corregido, después
de su prueba negativa, dan **cero** en la portada y en las secciones 1 a 5, en
los cuatro lenguajes, con los bloques desplegados, las trazas al final y los
términos y las explicaciones abiertos. Con los bloques plegados, todo lo que
sale está dentro de un `pre` plegado: 57 de 57 en la sección 1, 3 de 3 en la 2,
61 de 61 en la 4 y 74 de 74 en la 5. La conclusión del PC2 se mantiene.

### H16 · Sin `localStorage`, el capítulo se queda en blanco *(encontrado en la Tarea 2.4)*

El `App` lee la lección guardada con `localStorage.getItem` dentro del
inicializador de `useState` (`lp-demo.jsx:762`), y `CodeTabs` lee y escribe la
preferencia de lenguaje igual (`lp-core-extra.jsx:229` y `:303`). Ninguna de las
dos lecturas va en `try/catch`. Si el navegador no da almacenamiento, la primera
lectura lanza un `SecurityError`, React desmonta el árbol y la página queda en
blanco, con la consola como única pista. Se vio en el panel de vista previa, que
abre los `file://` como URL `data:`. Pero el mismo fallo puede aparecer en una
ventana privada, o con el almacenamiento bloqueado por política. Es de la
plantilla, así que afecta a los cinco capítulos, y arreglarlo obliga a
reestampar. → **cuarta deuda de P3.**

### H17 · `OrdenaPasos` no muestra la sangría *(encontrado en la Tarea 2.5)*

Los pasos llevan su sangría en el texto (`'    subtotal = 0'`), pero el `span`
que los pinta tiene `white-space: normal`: los espacios del principio se
colapsan y las tres líneas de la sección 5 —a 0, 4 y 8 espacios— empiezan en
el mismo píxel (medido en el DOM). Lo mismo pasa en el recuadro «Orden
correcto». En pseudocódigo es una pista que se pierde. En Python es la
estructura misma: la sangría dice a qué ciclo pertenece cada línea, y con dos
ciclos el estudiante ordena sin verla. El ejercicio sigue teniendo una sola
respuesta, porque se califica por posición, pero la solución que se muestra no
dice qué va dentro de qué. El arreglo es `whitespace-pre` en ese `span` y en el
de la solución, en `lp-core-extra.jsx:763`, y obliga a
reestampar. → **quinta deuda de P3.**

### H18 · La revisión de contenido de los capítulos 4 y 5 *(2026-10-20)*

El docente pidió revisar la redacción, la coherencia, los gráficos y los
ejercicios de los capítulos 4 y 5, y después arreglar los graves y los medios.
- El informe completo está en `REVISION_CAPITULOS_04_05.md`. Lo hicieron cinco
  revisores, y cada grave se volvió a comprobar antes de anotarlo.
- Las correcciones del capítulo 4 van en su propia rama, `cap04/revision-contenido`,
  salida de `main` y fundida en esta. Están anotadas en la §10 de
  `PLAN_TAREA9_CAPITULO_04.md`.

**Graves del capítulo 5:**
1. **Una cifra mía, mal atribuida.** El recuadro «El espejo de la sección 1» daba
   −2 313 243,65 para un caso que en realidad informa −1 311 644,50.
   - La cifra es la de sacar solo `saldo <- capital` del simulador bien escrito,
     y así lo dice ahora el recuadro.
   - Las cuatro variantes están ejecutadas (`g1_espejo.py`).
2. **El E5 de la sección 1 admitía tres órdenes y aceptaba uno.** `Leer n`
   conmutaba con las inicializaciones, e inicializar primero sacaba 8 de 11.
   - Se resolvió con una tercera convención, la misma del E5 de la sección 5: la
     lectura va antes.
3. **La definición de contador y acumulador chocaba con los ejemplos del propio
   capítulo:** el saldo baja, y `cobrado + cuota` suma siempre lo mismo.
   - Ahora manda la pregunta a la que responde cada variable.
   - El E2 de la sección 1, que se acertaba emparejando «suma 1», pasó a ser una
     predicción de salida de verdad: 2 créditos en mora por 1 500 000, ejecutado
     en Python y R.

**Medios del capítulo 5:**
- **Traza nueva en la sección 1, `TZ_AHORRO_MAL`.** El defecto de la motivación,
  con la meta en 900 000 para que el ciclo dé tres vueltas.
  - Se ve el acumulador volver a cero, y la separación en la tercera vuelta:
    5 424,30 frente a 8 124,30.
  - Tiene 22 pasos y es correcta en los cuatro lenguajes, medida en el navegador.
- **Traza de la sección 2.** La columna «saldo > 0» arrastraba «Verdadero» a los
  pasos del cuerpo, con el saldo ya en −200 000. Ahora muestra «—» donde no se
  pregunta nada; el arreglo de fondo es la deuda L5.
- **Nota de la traza de la sección 5.** Su desglose no sumaba 33. Ahora suma
  3 + 12 + 6 + 12 = 33, contado contra los pasos.
- **E4 de la sección 3, rehecho con una condición compuesta.** Ahora es
  `saldo > 0 Y k < n` frente a `Hasta saldo <= 0 O k >= n`. Antes se acertaba
  recordando la motivación; ahora ejercita De Morgan. Está ejecutado sobre seis
  saldos y cinco valores de n.
- **E2 nuevo en la sección 4.** Pregunta qué ciclos no dan ninguna vuelta con
  n = 1. Es lo único que califica el contenido central de la sección: qué
  significa `Para` en cada lenguaje.
- **La frase de fondo de la sección 4.** El `for` de Python y R recorre una
  secuencia; no compara ni suma. Está en el texto y en el término «variable de
  control».
- **`TresCiclosComparados` gana un panel: el `for` de Python con `range(1, n)`.**
  La pregunta por n = 0 ya estaba respondida seis veces en la sección; ahora el
  panel deja algo por descubrir. Además, el recuadro de la sección 3 ya no
  adelanta la respuesta.
- **`FlujogramaAnidado`, nuevo en la sección 5.** Dos retornos concéntricos, con
  `subtotal ← 0` entre los dos.
- **Correcciones de texto:**
  - «Las tres piezas de un ciclo», que decía tres y después dos;
  - «el único uso de break», que olvidaba el `Salir` del capítulo 2;
  - un comentario que explica el `Double` de VBA en las secciones 4 y 5.

**Cuota.** El E2 nuevo agota el margen que la §5 reservaba para la auditoría. Si
la sección 6 trae su E2, el capítulo queda en 19 ejercicios, con E2 en 4, el
máximo de su cuota.

**Hueco del verificador (para la tarea de deudas).** La regla 11 tomó «¿Qué
escribe el programa?» —la pregunta por lo que imprime— como un encargo de
escribir un programa. Se redactó de otro modo, pero la regla confunde los dos
sentidos de «escribir».

---

## 3. Grafo de dependencias

```
Fase 0 (este plan) ─► ⏸ PC0 ─► rama ─► Fase 1 (archivo + 3 artefactos + flujogramas)
                                          └─► ⏸ PC1 ─► Fase 2 (contenido, 8 tareas)
                                                          ├─► ⏸ PC2 (tras la sección 3)
                                                          └─► ⏸ PC3 (contenido completo)
                                                                 └─► Fase 3 (auditoría) ─► ⏸ PC4
                                                                        └─► Fase 4 (banco + cierre) ─► ⏸ PC final
```

Por encima del grafo, aunque fuera de él: **las revisiones pendientes de los
capítulos 3 y 4** (R1). Y en paralelo, sin bloquear: **el banco del capítulo 4**
(H12), que el PC D necesita.

---

## 4. Tareas

### Fase 0 — Plan y rama

#### Tarea 0.1 · Este documento · ✅
Estado medido, trece hallazgos, cuota repartida y preguntas abiertas.

#### Tarea 0.2 · Rama nueva · ✅
`cap05/control-repetitivo`, desde `main` en b4712a2, en el *worktree*
`.claude/worktrees/cap05`: la sesión «Revisión capítulo 4» seguía trabajando en
la carpeta (R9).

El borrador de este plan **ya estaba en `main`**: el commit b4712a2 de esa
sesión lo incluyó sin querer junto a sus cambios del capítulo 1. No se reescribe
un historial ajeno. La versión aprobada entra con el primer commit de la rama.

### ⏸ Punto de control 0 — El plan · ✅ 2026-09-28
- [x] **P1:** `AmortizacionPasoAPaso` va en la sección 4. *Aprobado.*
- [x] **P2:** el ciclo anidado acumula en vez de llenar una matriz (H7).
      *Aprobado.*
- [x] **P3:** las tres deudas de LP-CORE esperan a una tarea corta propia antes
      del capítulo 6. *Aprobado.*
- [x] **P4:** el «Millonario» usa preguntas cloze (H11, corregido). *Respondido.*
- [ ] El corte en siete secciones y el reparto de iconos (H10) **no recibieron
      objeción**. Se confirman en el PC1, antes de escribir contenido: hasta
      entonces solo tocan el `curriculum`.

---

### Fase 1 — El archivo, los tres artefactos y los flujogramas

#### Tarea 1.1 · Crear el capítulo y retirar la demostración en el mismo paso · ✅
`cp` de `lp-base.html`, `migrar.py --dry-run` y luego en firme. La demostración
(unas 2 800 líneas, con un ejercicio de cada tipo) se retira **en el mismo
paso** en que se sustituye la región entre `LP-CORE FIN` y `const App`.
**Cierre:** `grep` de `Seccion1`, `EJ_INTERES`, `TRAZA_CODIGO`, `ORDENA_PASOS`,
`EMPAREJA_IZQ`, `chart-demo-saldo` y `Plantilla base`, con cero apariciones. Y
`verificar.py --sin-cuota` debe dar **0 ejercicios**: si la demostración hubiera
quedado, saldría exactamente uno de cada tipo.

*Hecho.* `migrar.py` dejó el archivo sin cambios, porque era la plantilla misma.
El `grep` da cero y el verificador, 0 ejercicios. Las secciones son **andamio**:
cada una lleva solo su `Motivacion` de borrador y los artefactos que le tocan,
para verlos en su sitio. El andamio lleva la marca `BORRADOR-FASE1`, y la Fase 2
cierra cuando `grep -n BORRADOR-FASE1` dé cero.

#### Tarea 1.2 · `CONFIG` y `curriculum` contra la fila 35 · ✅
El `CONFIG` de la plantilla no trae ningún `TODO`, así que se reescribe a mano.
Entregable: la tarea en Moodle (S1), con el juego mencionado como actividad. El
nombre del capítulo se escribe igual en los cuatro sitios que viven en el
archivo (tabla del `README.md`).

*Hecho:* `<title>`, `<meta name="description">` y `CONFIG.titulo`. El cuarto
sitio, el título del `Quiz` final, llega con la Tarea 2.8. La fila «Evaluación
asociada» de la portada nombra la tarea, el formato y el juego.

#### Tarea 1.3 · `AmortizacionPasoAPaso` · ✅
Construye la tabla de amortización **una fila por clic**. Muestran su estado a
la vista el contador de la cuota, el saldo y los intereses acumulados. Un botón
completa la tabla hasta el final: **240 filas** (H2.1), dentro de su propio
contenedor con `overflow-x`. Se controla **por contador**, no por saldo (H3). Es
lo que convierte en visible que una tabla de amortización *es* un ciclo.

*Hecho, con tres créditos a elegir:* vivienda, 150 000 000 al 1,1 % en 240 (el que
abre por defecto, porque es el de la promesa); vehículo, 30 000 000 al 1,45 % en
60; y libre inversión, 10 000 000 al 1,5 % en 12, que es el hilo del curso (S2).
Un crédito a 240 meses no existe en libre inversión, y por eso el de la promesa es
de vivienda. Botones: una vuelta, doce vueltas y hasta el final. El pseudocódigo
del ciclo va encima, y el estado se ve en las cuatro variables. Al terminar se
muestra el residuo real del saldo (−3,6 × 10⁻⁶), que es el gancho de la sección 6.

#### Tarea 1.4 · `TIRBiseccion` · ✅
Busca la TIR por bisección, una vuelta por clic, sobre una gráfica de Plotly del
VPN en función de la tasa. El intervalo se va estrechando a la vista, y el
criterio de parada (ancho < tolerancia) va escrito con su contador de vueltas.
Medido para el caso previsto (10 000 000 al 1,5 % mensual en 12 cuotas, con
300 000 de comisión descontados al desembolso): **TIR mensual del 1,9924 % en 17
vueltas**, con el intervalo [0 %, 10 %] y tolerancia 10⁻⁶. Es la misma idea que la
búsqueda binaria del capítulo 2, que parte 40 000 créditos en 16 pasos, aplicada
a una función. Se cita, no se repite.

*Hecho.* El VPN se calcula con un `Para` **dentro** del `Mientras` de la
bisección, así que el pseudocódigo no llama a ninguna función (son del
capítulo 6) y la sección 7 reutiliza el anidamiento de la 5. La casilla «Acercar
la gráfica al intervalo» hace visible la franja después de la vuelta 6, cuando
a escala completa ya no se distingue. El artefacto da la TIR y la tasa pactada,
pero **no las interpreta**, porque eso es el E7 de la sección 7.

#### Tarea 1.5 · `TresCiclosComparados` · ✅
El mismo problema resuelto con `Mientras`, `Para` y `Repita`, cada uno con su
contador de vueltas, y una entrada que se puede cambiar. Tiene que incluir el
caso en que difieren: con cero cuotas pendientes, `Repita` cobra una (H5).

*Hecho, con un añadido:* una casilla agrega un cuarto panel, el `for (k in 1:n)`
de R, que con *n* = 0 cobra **dos** cuotas (H4, medido otra vez en R: `k = 1`,
`k = 0`). Es la diferencia más cara del capítulo, y aquí se ve sin ejecutar R.
→ **P7.**

#### Tarea 1.6 · Los tres flujogramas · ✅
`Mientras`, `Repita` y `Para`, hechos en SVG con las lecciones del capítulo 4
(H13): versión estrecha para móvil y leyenda en HTML. La letra se mide a 375 px:
**nunca por debajo de 14 px CSS**.

*Hecho, con una desviación:* **una sola versión** por flujograma, estrecha
(248 unidades), en lugar de las dos del capítulo 4. Allí la versión ancha hacía
falta porque las ramas de la cascada salen hacia el costado. En un ciclo no sale
nada hacia el costado: el retorno va por un carril a la izquierda y la salida por
uno a la derecha, y los dos caben en la versión estrecha. Con un ancho máximo de
340 px, la letra mide **entre 14,8 y 16,7 px a 375 px** y unos 16 px en escritorio.

El retorno va en el color secundario, y es la única forma nueva de la simbología,
que va en HTML. En el de `Para`, las tres piezas que el ciclo hace por su cuenta
(iniciar, comparar y aumentar el contador) van con borde discontinuo. En el de
`Repita`, el retorno sale por el «No», al revés que en el de `Mientras`: es H5
dibujado.

### ⏸ Punto de control 1 — Los artefactos · ✅ 2026-09-28
- [x] Los tres funcionan, **medidos por DOM**. La tabla llega a 240 filas; la
      última es `240 | 19.353,68 | 1.759.425,20 | 0,00 | 276.906.929,57`, y los
      intereses coinciden con Python al centavo. Con 12 cuotas, el último abono
      es 903.251,16 (el E3 de H4). La bisección da **1,9924 % en 17 vueltas**,
      y sus tres primeras filas son [0; 10] −, [0; 5] − y [0; 2,5] +. Con
      *n* = 0, `Repita` cobra 916.799,93 y el `for` de R, 1.833.599,86
- [x] 375 px en las nueve entradas: `scrollWidth` = 375 en todas, con el menú
      cerrado, y también con la tabla completa, los cuatro paneles y la gráfica
      acercada. El único elemento «fuera» es el SVG de medición de Plotly
      (`left: −10000`), que no es contenido
- [x] Letra de los flujogramas a 375 px: **14,8 a 16,7 px**
- [x] Font Awesome: los trece iconos nuevos dan un glifo real
- [x] Consola limpia: solo los dos avisos de siempre
- [x] Comprobación 1 en verde; `verificar.py --sin-cuota --con-salidas` en verde
      sobre los cinco capítulos; ningún residuo de la demostración
- [x] **Revisión del docente** (2026-09-28): aprobados **P6** y **P7**, el corte
      en siete secciones y los iconos. P5 sigue sin respuesta, y el docente
      pidió seguir con la Fase 2
- [x] *Remedido en la Fase 2 (H15):* la medida de 375 px de este punto de
      control podía estar ciega. Repetida con un instrumento que sí falla, da
      cero en las nueve entradas

---

### Fase 2 — Contenido, sección por sección

Una tarea es una sección terminada: motivación, código en los cuatro lenguajes y
sus ejercicios.

#### Tarea 2.1 · Portada + Sección 1 — «Contar y acumular: lo que ya trazó sin nombrarlo» · ✅
La portada abre con las 240 filas (H2.1). La sección 1 cita los siete sitios de
H1 sin repetirlos, y nombra el contador y el acumulador, que el capítulo 3 ya
presentó sin ciclo. **E2:** ¿contador o acumulador? **E5:** ordenar los pasos
para que la inicialización quede **fuera** del ciclo.

*Hecho.* La portada abre con el crédito de vivienda de 240 filas: una vuelta de
menos deja 1 759 425,20 sin cobrar (ejecutado). Cita las promesas de los
capítulos 3 y 4 con sus palabras. La sección 1 abre con un extracto de ahorro
programado que informa 34 053 de intereses cuando se ganaron 217 709: es la
inicialización del acumulador escrita dentro del ciclo. Los dos programas se
ejecutan, y las dos versiones **coinciden en las dos primeras vueltas**, porque
el interés del mes 1 es cero. El texto lo dice: una traza corta no lo delata. La
sección nombra también el acumulador de producto, que arranca en 1. **E2**
(selección múltiple): el contador que no aumenta en todas las vueltas y el dato
leído que cambia sin ser acumulador. **E5:** el cierre de recaudo. `OrdenaPasos`
califica por posición, así que el enunciado fija dos convenciones que no cambian
el resultado: las inicializaciones en el orden de sus actualizaciones, y la
vuelta contada al final.

#### Tarea 2.2 · Sección 2 — «`Mientras`: preguntar antes de entrar» · ✅
Un `Trazador` de tres vueltas, donde la línea del `Mientras` vuelve a iluminarse
en cada una (H9). **E1:** traza de un saldo insoluto con abonos. **E2:** cero
vueltas, porque la condición es falsa de entrada.

*Hecho.* Un acuerdo de pago: 2 350 000 en abonos de 400 000 da seis meses, y el
sexto abono cobra 400 000 cuando se debían 350 000. El arreglo se describe, no
se escribe: es una selectiva dentro del cuerpo. El `Trazador` tiene 14 pasos. El
**E1 va por evaluación de la condición**, no por vuelta: cinco filas para cuatro
vueltas. Es lo que lo separa de la traza de la meta de ahorro del capítulo 1, que
iba por vueltas. El **E2** es de selección múltiple: el saldo 0 y el saldo a favor
dan cero vueltas, y los distractores son el abono justo (una vuelta) y el abono 0
(no termina, anticipa la sección 6).

#### Tarea 2.3 · Sección 3 — «`Repita…Hasta`: entrar antes de preguntar» · ✅
Los cuatro lenguajes con sus diferencias (H5). **E8:** validar un monto, del plan
maestro. **E4:** `Mientras` contra `Repita` con la condición negada, que solo
difieren en el crédito ya pagado.

*Hecho.* La motivación junta las dos rutinas: la validación que funciona y el
cobro copiado de ella, que le cobra 916 799,93 a quien está a paz y salvo.
Incluye la tabla de H5, el `break` como único del capítulo (H6) y las cuatro
combinaciones de `Do…Loop` en VBA. Para negar la condición se usa De Morgan. El
**E8** compara tres validaciones: con `Repita`, con `Mientras` y dos lecturas, y
con `Mientras` y un `−1` inicial. El **E4** tiene de distractores las dos
creencias reales: «la negación es exacta, luego son iguales» y «B da siempre una
vuelta más».

### ⏸ Punto de control 2 — Tono, densidad y primer tercio · ✅ 2026-10-18
- [x] Seis ejercicios: E1:1 · E2:2 · E4:1 · E5:1 · E8:1, y ningún aviso de la
      regla 17
- [x] Cada ejercicio que califica, llevado hasta el veredicto por DOM, con una
      respuesta mala incluida. Los dos E2 y el E4 dan «Correcto» con la clave y
      «Revisa la explicación» con una de más, una de menos y un distractor. El
      E5 da la secuencia correcta en los cuatro lenguajes, y 8 de 11 con el
      total inicializado dentro del ciclo. El E1 da 15/15 también con puntos de
      miles y mayúsculas, y 3/15 con la tabla hecha por vueltas. El `Trazador`
      recorre sus 14 pasos en los cuatro lenguajes con la línea activa
      correcta, y el E8 muestra su solución
- [x] `verificar.py --sin-cuota --con-salidas` en verde sobre los cinco
      capítulos. Seis bloques de Python y R ejecutados; cada cifra en prosa
      (las 34 053 del mes 13, la coincidencia de las dos primeras vueltas, las
      evaluaciones de cada acuerdo, el cobro con saldo 0, −5, 100, 250 y 300)
      ejecutada aparte
- [x] La sección 1, leída junto a los capítulos 1 y 2: **ninguna repetición**
      (R4). El ahorro programado se parece a la meta de ahorro del capítulo 1, y
      el texto lo dice en vez de esconderlo
- [x] 375 px en las nueve entradas, con el instrumento corregido (H15) *(que
      todavía era ciego: remedido en la Tarea 2.5, da cero)*;
      consola limpia; los cuatro iconos nuevos de las motivaciones dan glifo;
      ningún espacio comido entre texto y elemento, comprobado en el DOM con un
      guion que también se probó en negativo
- [x] **Revisión del docente** (2026-10-18): PC2 aprobado. ¿Las motivaciones
      son ganchos o índices? ¿La densidad es la del capítulo 4? Sin
      observaciones

#### Tarea 2.4 · Sección 4 — «`Para`: cuando se sabe cuántas veces» ← **núcleo** · ✅
La tabla de H4 y `AmortizacionPasoAPaso` (P1). **E3 de alto valor:** el
`Mientras k < n` que deja una cuota sin cobrar. Medido: 10 000 000 al 1,5 % en 12
cuotas de 916 799,93, y con una vuelta de menos quedan **903 251,16** sin cobrar.
El estudiante tiene que **nombrar** el defecto y estimar el impacto. La
`lineaCorrecta` y la `explicacion` van por lenguaje. **E1:** traza de las
primeras cuatro filas. **E4:** `Para` contra `Mientras`, con `Comparador` (H8).
`TresCiclosComparados` cierra la sección.

*Hecho el 2026-10-19, después de traer `main`.* La motivación es el plan de pagos
migrado de VBA a Python con `range(1, 12)`: once cuotas, y el banco deja de
recaudar la doce, 916 799,93. La cuota va como dato de una línea, con el
comentario que remite al capítulo 8 y sin redondear (P6). El plan de doce cuotas
se imprime entero, y su última fila sale con −0.00, porque el residuo es
−7,5 × 10⁻⁸; la nota del bloque lo deja para la sección 6. Un `Box` dice que los
bancos redondean al peso y ajustan la última (S3). La tabla de H4 va entera,
con un `Box` para las tres diferencias —la del contador de VBA, con la
referencia de Microsoft Learn, «Instrucción For...Next (VBA)»— y un bloque del
crédito al día: con *n* = 0, R cobra la cuota 1 y la cuota 0, y `seq_len(n)`
ninguna.

- **E1** (`TablaTraza`): las cuatro primeras cuotas de **otro** crédito, 4 000 000
  al 2 % en 12, para que no se copien de `AmortizacionPasoAPaso`. La fila de
  antes del ciclo tiene tres rayas que son respuesta (`k`, `interes` y `abono`),
  y lleva `exigeRespuesta`. El VBA de la traza va como fragmento, sin `Dim`: un
  `Dim interes As Double` le daría 0 antes del ciclo, y la fila dejaría de ser la
  misma en los cuatro lenguajes.
- **E3** (`DetectaError`): el `Mientras k < n`. Los tipos combinan el nombre del
  defecto con su magnitud. El distractor fuerte es la cuota completa
  (916 799,93) contra el saldo que de verdad queda, el abono de la cuota 12
  (903 251,16). Clave en la «d».
- **E4** (`Comparador`): un `Mientras` que no se parece a un `Para` —nace en 0,
  aumenta arriba y compara con `<`— y es equivalente con cualquier *n*, también
  0 y negativos. Va después del E3 para que no se resuelva por patrón («el `<`
  es el defecto»). En R, la versión A usa `seq_len(n)`: con `1:n` la clave
  dependería de la pestaña. Clave en la «b».
- La cierran una tabla de las tres formas y `TresCiclosComparados`.

*Medido:* `verificar.py --sin-cuota --con-salidas` en verde en los cinco
capítulos: 9 ejercicios (E1:2 E2:2 E3:1 E4:2 E5:1 E8:1) y 10 bloques de Python y
R ejecutados. Cada cifra en prosa se ejecutó aparte, en Python y en R: once
vueltas, 903 251,16, 13 548,77, el 9 % del capital, −7,5 × 10⁻⁸, `1:0` = `c(1, 0)`,
`range(1, 12)` con once vueltas y la equivalencia del E4 con *n* = 0, 1, 2, 12 y
−3. Regla 17 sin avisos, con su prueba negativa: la clave del E4 alargada sale
señalada. Claves del capítulo: a, b, c, d, b. Por DOM, el E1 da 20/20 con la
clave, y también redondeando al centavo en cada paso; con las rayas en blanco y
un saldo malo da 16/20 y avisa de las tres sin responder. El E3 da «¡Diagnóstico
correcto!» en los cuatro lenguajes (líneas 9, 8, 8 y 12), y da error con la cuota
completa y con la inicialización. El E4 da «¡Correcto!» con la «b» y «Revisa la
explicación» con las otras tres. A 375 px, con la barra lateral cerrada, no queda
ningún elemento fuera en ningún estado: bloque desplegado, tabla de 240 filas,
cuarto panel de R, explicaciones abiertas y el E3 en los cuatro lenguajes. Y no
hay ningún espacio comido en los 104 elementos en línea. Las dos pruebas se
hicieron antes en negativo. *Sin cotejar:* el −0.00 de la última fila en VBA
(R10), y si `Format` lo imprime con signo.

*Cómo se probó en el navegador:* el servidor «portal» no se pudo arrancar,
porque la tarea corrió programada y el arranque se rechazó. El archivo se abrió
desde `file://`, que el panel convierte en una URL `data:`, y ahí no hay
`localStorage` (H16). Se le dio a la pestaña un `localStorage` en memoria y se
volvió a montar el `App`, sin tocar el archivo.

#### Tarea 2.5 · Sección 5 — «Ciclos anidados» · ✅
Sin arreglos (H7, P2). Un `Trazador` de dos créditos con tres cuotas cada uno,
donde el ciclo de dentro vuelve a empezar. **E1:** subtotales y total. **E5:**
el subtotal que no se reinicia.

*Hecho el 2026-10-19.* La motivación es un simulador que compara el crédito de la
sección 4 a uno, dos y tres años: el plan de pagos dentro de otro ciclo. Su
acumulador de intereses nace antes de los dos ciclos, así que cada plazo arrastra
los anteriores. A tres años informa 5 998 246,01, la suma de los tres plazos,
cuando son 3 014 862,39. Es el espejo del defecto de la sección 1, y el texto lo
dice: allí la inicialización estaba un nivel demasiado adentro, y aquí uno
demasiado afuera. Los dos simuladores, el bueno y el de la motivación, se
imprimen. El de dentro da 12 + 24 + 36 = 72 vueltas, porque su tope lo calcula el
de fuera. Una tabla da los tres niveles de ejecución: una vez, una por vuelta
del de fuera y una por vuelta del de dentro. Un `Box` añade el segundo
acumulador fuera de sitio, el saldo: con `saldo <- capital` antes de los dos
ciclos, el plazo de dos años informa −2 313 243,65 de intereses.

- **Traza guiada** (`Trazador`): dos créditos de abono constante a capital y un
  trimestre, al 2 %. Los topes van escritos (2 y 3) para no gastar pasos. Cada
  paso que avanza un contador apunta a la línea donde ocurre en cada lenguaje:
  el `Para` o el `for`, y en VBA el `Next`. No hay paso para la última
  comparación de cada ciclo. Python y R dejan el contador en el último valor, 3
  (ejecutado), y VBA en uno más, así que los valores ya no serían los mismos en
  las cuatro pestañas. **Son 33 pasos**, más que los 14 a 20 que H9 daba por
  cómodos (ver H9).
- **E1** (`TablaTraza`): otra cartera, al 1,5 %, con saldos que no coinciden con
  los de la traza. Una fila por vuelta del de dentro y una al final: 21 celdas,
  todas enteras.
- **E5** (`OrdenaPasos`): el cierre de recaudo de la sección 1, ahora por
  oficina. Tres pares de líneas conmutan. El enunciado fija dos convenciones: la
  lectura antes que la inicialización, en cada nivel, y el subtotal escrito antes
  de sumarse al total. Los dos cierres de ciclo del pseudocódigo y de R llevan un
  comentario (`// pagos`, `# oficinas`), porque dos `FinPara` iguales serían
  indistinguibles.
- Cierra un `Box` que remite los subtotales guardados al capítulo 7 y la
  terminación a la sección 6.

*Medido:* `verificar.py --sin-cuota --con-salidas` en verde sobre los cinco
capítulos: 11 ejercicios (E1:3 E2:2 E3:1 E4:2 E5:2 E8:1) y 14 bloques de Python y
R ejecutados; los cuatro nuevos son los dos simuladores. Los programas que leen
datos no los puede ejecutar el verificador, así que se ejecutaron aparte, en
Python y en R, con las entradas de los enunciados:
- la traza da 120 000, 90 000 y 210 000;
- el E1 da 72 000, 81 000 y 153 000;
- el E5 da 720 bien ordenado y 1 320 con el subtotal fuera.

Por DOM:
- la traza recorre sus 33 pasos en los cuatro lenguajes con la línea activa
  esperada en cada uno;
- el E1 da 21/21 con la clave y con puntos de miles, y 16/21 con el subtotal sin
  reiniciar;
- el E5 da «¡Secuencia correcta!» en los cuatro lenguajes, y con el subtotal
  antes del ciclo de fuera deja tres pasos fuera de sitio en cada uno.

Ningún espacio comido en los 24 elementos en línea, y la consola está limpia. A
375 px, con la barra cerrada y el criterio de H15 —primero en negativo: el
bloque de 600 px lleva el panel de 367 a 624 px—, la sección no saca nada fuera
en los cuatro lenguajes, con los bloques desplegados, la traza en el paso 33 y
los dos ejercicios comprobados. Con los bloques plegados salen 74 elementos, y
los 74 están dentro de su `pre` plegado (salvedad de H15).

#### Tarea 2.6 · Sección 6 — «Cuándo para: terminación, ciclos infinitos y centinelas»
Cita la finitud del capítulo 2. La tabla de H3 va entera. **E3:** el `Mientras
saldo <> 0` que no termina. **E8:** ¿por qué la tabla se controla con el
contador y no con el saldo? **E2:** el centinela que se suma como si fuera un
monto.

#### Tarea 2.7 · Sección 7 — «Casos financieros»
Saldo insoluto, capitalización y la TIR con `TIRBiseccion`. **E1:** tres vueltas
de la bisección. En las celdas van los extremos del intervalo y el signo, **no
el VPN con decimales**, que haría fallar la comparación con tolerancia. **E7:**
qué significan para el cliente 1 001 599 de intereses sobre 10 000 000. **E7:**
qué significa una TIR del 1,99 % frente a una tasa pactada del 1,5 %.

#### Tarea 2.8 · Evaluación y glosario
Diez preguntas, cada una con `seccion:` (regla 19), con `multiple: true` donde
haya dos claves (regla 12), sin repetir ejercicios de sección (regla 18) y con
distractores tan largos como la clave (regla 17). El E6 (`Emparejamiento`) cruza
las siete secciones: forma del ciclo ↔ situación financiera. El recuadro «Lo que
viene» anuncia el capítulo 6.

### ⏸ Punto de control 3 — Contenido completo
- [ ] Las siete secciones, la portada y la evaluación
- [ ] **Cuota:** 18 ejercicios · E1:4 E2:3 E3:2 E4:2 E5:2 E6:1 E7:2 E8:2 (§5)
- [ ] **Las promesas de H2, cumplidas:** 240 filas a la vista, las dos
      preguntas del capítulo (*cuántas veces* y *cuándo para*) y la traza de
      muchas vueltas

---

### Fase 3 — Auditoría

#### Tarea 3.1 · `verificar.py --con-salidas`
Todas las comprobaciones, con las salidas de Python y R **ejecutadas**, y la
regla 17 sin ningún aviso en este capítulo.

#### Tarea 3.2 · Auditoría por DOM
Cada ejercicio que califica, llevado hasta el veredicto en los cuatro lenguajes y
con una respuesta mala incluida. El cuestionario final, respondido entero y con
las diez acertadas.

#### Tarea 3.3 · Las vueltas, contadas
Es la auditoría propia de este capítulo. `ejecutar_salidas.py` solo comprueba
lo que va tras `#>`. Un número de vueltas dicho en prosa, o escrito en la clave
de un ejercicio, no lo mira nadie. Por eso, cada cifra de vueltas y cada saldo
del texto se ejecutan en Python y R con los datos exactos, incluidos el caso
*n* = 0 de R (H4) y los ciclos controlados por saldo (H3).

#### Tarea 3.4 · 375 px, sección por sección
Con la barra lateral **cerrada**.

#### Tarea 3.5 · Contraste
Medido en el navegador, también en los `fill` de los `<text>` de los
flujogramas. El gold nunca va como texto sobre fondo claro.

#### Tarea 3.6 · Lo que otros capítulos dicen
Búsqueda manual de frases como «primera vez», «único» y «nunca antes», cotejadas
contra los capítulos 1 a 4 (H1). Y al revés: que nada de lo que el capítulo 4
anuncia en «Lo que viene» quede sin cumplir.

### ⏸ Punto de control 4 — Auditoría
- [ ] `verificar.py --con-salidas` en verde sobre los **cinco** capítulos
- [ ] Consola limpia
- [ ] 375 px, las nueve entradas de la barra lateral
- [ ] Contraste medido, con la razón escrita
- [ ] Todos los ejercicios que califican, por DOM, con una respuesta mala cada uno
- [ ] Cuestionario: 10/10
- [ ] Las vueltas contadas (Tarea 3.3) y las afirmaciones cotejadas (Tarea 3.6)
- [ ] Si salió una comprobación nueva, su **prueba negativa** registrada

---

### Fase 4 — Banco de Moodle y cierre

#### Tarea 4.1 · Diez cloze
Los del plan maestro: iteraciones ejecutadas (num), valor final del acumulador
(num), traza de 3 iteraciones (num ×3), identificar un ciclo infinito (schoice),
saldo tras *N* cuotas (num, `extol` 0.01), total de intereses pagados (num),
efecto de mover la actualización del contador (schoice) y condición de parada de
la bisección (schoice). Todo número impreso pasa por `num()` (trampa 9).

#### Tarea 4.2 · Sus diez reglas de contenido
En `verificar_cloze.R`, en el mismo commit que cada cloze. Tres son propias de
este capítulo:
- ningún cloze cuenta vueltas de un ciclo controlado por saldo (H3);
- los ciclos con `Para` se enuncian en pseudocódigo (H4);
- el sorteo de «mover la actualización del contador» cae siempre donde el cambio
  **se nota**. Es la trampa 8: un cloze válido que no enseña nada.

#### Tarea 4.3 · Compilar y verificar
`compilar_banco.R --cap 05` y `verificar_cloze.R --reps 1000`.

#### Tarea 4.4 · Portal
La tarjeta 05 de `index.html` deja de ser `pendiente` y pasa a ser un enlace. Su
`<h3>` debe coincidir con los otros cuatro sitios del nombre.

#### Tarea 4.5 · Cierre
Bitácora en la §11 del plan maestro, y los hallazgos sobre las herramientas
llevados a la skill y al `README`. Como mínimo: el techo del `Trazador` (H9),
`Salir` (H6) y la auditoría de vueltas en prosa (Tarea 3.3), que es candidata a
regla.

### ⏸ Punto de control final
- [ ] `verificar.py --con-salidas` en verde sobre los **cinco** capítulos
- [ ] Banco compilado y verificado con `--reps 1000`
- [ ] El capítulo abre desde `file://` sin errores de consola
- [ ] **Revisión del docente:** leído completo y con la dificultad aprobada

---

## 5. Cuota de ejercicios — distribución objetivo

18 ejercicios. Queda uno de margen bajo el máximo, reservado para lo que
encuentre la auditoría, como pasó en el capítulo 4. Ninguna sección se queda con
un solo ejercicio.

| Sección | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 | Total |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| 1 · Contar y acumular | | 1 | | | 1 | | | | 2 |
| 2 · `Mientras` | 1 | 1 | | | | | | | 2 |
| 3 · `Repita…Hasta` | | | | 1 | | | | 1 | 2 |
| 4 · `Para` | 1 | 1 *(H18)* | **1** | 1 | | | | | 4 |
| 5 · Anidados | 1 | | | | 1 | | | | 2 |
| 6 · Cuándo para | | 1 | 1 | | | | | 1 | 3 |
| 7 · Casos financieros | 1 | | | | | | 2 | | 3 |
| Evaluación | | | | | | 1 | | | 1 |
| **Total** | **4** | **4** | **2** | **2** | **2** | **1** | **2** | **2** | **19** |
| Cuota | 3–4 | 2–4 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 | |

Los dos E3 son las dos preguntas del capítulo: el de la sección 4 falla en
**cuántas veces** (una cuota de menos) y el de la 6 en **cuándo para** (un ciclo
que no para).

---

## 6. Riesgos

| # | Riesgo | Impacto | Mitigación |
|---|---|---|---|
| R1 | **Las revisiones de los capítulos 3 y 4 llegan tarde** y obligan a rehacer secciones ya escritas | Alto | Pedirlas antes del PC1. Cuanto más avance el 5, más caro sale |
| R2 | **Un ciclo controlado por saldo da una vuelta de más por azar del punto flotante** | Alto, y silencioso | Tabla por contador (H3), Tarea 3.3 y la regla del banco |
| R3 | **La sección 4 enseña `Para` como si fuera igual en los cuatro lenguajes** | Alto | La tabla de H4 va en el capítulo; el caso *n* = 0 de R se ejecuta |
| R4 | **Se repite lo que ya trazaron los capítulos 1 y 2** | Medio | H1 fija qué se cita; el PC2 lo revisa leyendo los tres seguidos |
| R5 | **Trazas demasiado largas** para el `Trazador` en móvil | Medio | Tres vueltas como máximo (H9); la tabla larga es un componente aparte |
| R6 | **La tabla de 240 filas o la gráfica desbordan a 375 px** | Medio | Su propio contenedor con `overflow-x`; medido en el PC1 |
| R7 | **Cloze intermitentes**, por la notación científica o por sorteos que no distinguen | Medio | `num()` desde el primer `.Rmd`, reglas de H3 y H4, y `--reps 1000` |
| R8 | **Una pregunta imposible de acertar** en la evaluación | Alto | `multiple: true`, regla 12, y responder las diez |
| R9 | **Choque con la sesión que revisa el capítulo 4** en la misma carpeta | Medio | Rama en un *worktree*; esta tarea no toca el capítulo 4 |
| R10 | **El VBA no se puede ejecutar** en esta máquina (R2 del plan maestro) | Medio | `Do…Loop Until` y `For…Next` se escriben y se cotejan con la referencia; lo que el texto afirme del contador en VBA (H4) va con su fuente |

---

## 7. Supuestos declarados

- **S1 · El entregable es la tarea en Moodle, no un cuestionario.** Sale de la col
  47 de la fila 35. Los 10 cloze son autoevaluación y banco del docente.
- **S2 · El hilo financiero sigue siendo la cartera de crédito de libre
  inversión.**
- **S3 · Amortización francesa, sin redondear la cuota.** Los bancos redondean
  la cuota al peso y ajustan la última. Aquí se menciona en un `Box` y no se
  modela, porque añade una selectiva dentro del ciclo que distrae de lo que
  enseña la sección. Si se prefiere modelarla, cambia la Tarea 1.3.
- **S4 · 18 ejercicios**, con uno de margen.
- **S5 · Sin arreglos.** Son del capítulo 7 (H7).
- **S6 · Plotly solo en `TIRBiseccion`.**

---

## 8. Comandos

```bash
cd "…/Logica de programacion"

cp "Material html/_plantilla/lp-base.html" "Material html/05_LPF_Control_Repetitivo.html"
python3 "Material html/_plantilla/migrar.py" --dry-run "Material html/05_LPF_Control_Repetitivo.html"
python3 "Material html/_plantilla/migrar.py"           "Material html/05_LPF_Control_Repetitivo.html"

python3 "Material html/_plantilla/verificar.py" --sin-cuota    # capítulo a medias
python3 "Material html/_plantilla/verificar.py" --con-salidas  # el completo

Rscript "Banco Moodle/compilar_banco.R" --cap 05
Rscript "Banco Moodle/verificar_cloze.R" --reps 1000

python3 -m http.server 8777 --directory "Material html"
```

---

## 9. Preguntas abiertas

- **P1 · ¿`AmortizacionPasoAPaso` va en la sección 4 (`Para`) y no en la 7?** El
  plan maestro la pone entre los casos financieros. Pero la tabla de
  amortización es *el* ejemplo de ciclo con número de vueltas conocido, y es
  donde tiene que aparecer para responder «cuántas veces». La sección 7 la
  reutiliza para el saldo insoluto y los intereses totales. **Aprobada en el
  PC0: sí.**
- **P2 · ¿El ciclo anidado acumula en lugar de llenar una matriz?** (H7)
  **Aprobada en el PC0: sí**, para no adelantar el capítulo 7.
- **P3 · ¿Se reestampa LP-CORE ahora, con las tres deudas juntas?** Son el
  plegado de tildes, la justificación de `MCQ` y `Salir` (H6). Cada una sola no
  justificaba reestampar cuatro capítulos, pero ya van tres, y a partir de aquí
  cada capítulo sube el costo. **Aprobada en el PC0:** no en esta tarea; se
  hace como tarea corta propia antes del capítulo 6, cuando LP-CORE ya no tenga
  a nadie editándolo.
- **P4 · ¿El juego «Millonario» necesita preguntas del banco?** (H11)
  **Respondida en el PC0:** el juego está montado con cloze, así que toma los
  del banco tal como salen.
- **P6 · ¿La cuota fija se da como una fórmula de una línea?** (H14) La
  alternativa es darla como un número redondeado, pero entonces el residuo final
  sería de centavos y la tabla de H3 dejaría de valer. **Aprobada en el PC1:** la
  fórmula, sin deducirla y con la cita al capítulo 8.
- **P7 · ¿Se queda el cuarto panel de `TresCiclosComparados`?** Es el
  `for (k in 1:n)` de R, que está apagado por defecto. **Aprobada en el PC1:
  sí.** Es H4 hecho visible, y sin él la sección 4 solo podría contarlo.
- **P5 · ¿Las revisiones de los capítulos 3 y 4, antes o después del PC1?** Antes
  abarata el R1; después no bloquea el arranque. *Sin respuesta en el PC1: el
  docente pidió seguir con la Fase 2, así que en la práctica quedan para
  después, y el R1 sigue abierto.*
