# Plan · Primer parcial servido por app propia (Shiny)

**Rama:** `parcial/app-examen` · **Base:** `cap03/control-secuencial` (ver H15) · **Fecha:** 2026-08-28
**Encargo:** desplegar el primer parcial fuera del LMS, con doble credencial
(cédula + código del día), aprovechando lo que Brightspace y Moodle no dan.
**Estado:** D1 a D7 ejecutados (2026-08-30). Compuertas G1 y G2 abiertas.
**Para retomar en otra sesión:** `TRASPASO_PARCIAL_APP.md` — estado, trampas ya
descubiertas, decisiones abiertas y lo que no hay que hacer.
**Siguiente:** **D8, el simulacro** — el material está preparado
(`parcial/SIMULACRO.md`); falta provisionar el VPS y ejecutarlo con el curso.
**El parcial está construido**: aguanta un tropiezo, se opera desde el panel, y el
respaldo en papel sigue siendo el mismo examen, trazas incluidas.

---

## 0. Decisiones y veredicto

### 0.1 Lo decidido (2026-08-28)

| Pregunta | Respuesta | Consecuencia |
|---|---|---|
| Calendario | **menos de 10 días** | obliga a recortar alcance y a fijar criterios de aborto |
| Modalidad | **presencial, sala de cómputo** | abarata la vigilancia y habilita el respaldo por LAN |
| Alojamiento | **VPS propio** | ~1 día de trabajo; LAN queda como respaldo caliente |
| Ventajas buscadas | **las cuatro**: Trazador, variantes barajadas, monitoreo en vivo, cuatro lenguajes | tres caben; la cuarta se recorta (§0.4) |

### 0.2 Veredicto

**Es viable y vale la pena, porque no hay que construir casi nada de contenido.**
Existen ya: 21 cloze validados de los capítulos 1–3 con variantes por estudiante,
y —el hallazgo que cambia las cuentas— **`TablaTraza` y `CodeTabs` ya están
escritos** en `Material html/_plantilla/lp-core-extra.jsx`. El Trazador
interactivo y las pestañas de cuatro lenguajes no son desarrollo nuevo: son una
adaptación acotada de componentes que llevan meses en producción en el material.

Lo que no existe es la plomería: autenticación, autoguardado, reanudación,
cronómetro, calificación, exportación, panel docente y despliegue. Eso es el
trabajo, y en menos de 10 días **cabe solo si se recorta y si el simulacro no se
sacrifica**.

### 0.3 Las dos compuertas — se resuelven en 48 h

Ninguna depende de programar, y las dos pueden matar el proyecto. Por eso van
primero.

- **G1 · Aval.** ¿Puede un parcial calificado servirse fuera de Brightspace/Moodle,
  y qué evidencia exige la facultad para el registro? Si la respuesta tarda más de
  lo que queda, la respuesta es no.
- **G2 · Sesión de clase para el simulacro.** ¿Hay una sesión con el curso completo,
  en la misma sala, antes del parcial? **Si no la hay, el parcial va por Moodle.**
  No es negociable: sin simulacro, el día del parcial es la primera vez que treinta
  personas usan la app a la vez, y el primer fallo se descubre cuando ya no tiene
  arreglo. Un examen calificado no admite ensayo general el mismo día.

### 0.4 El recorte, explícito

**Entra:** los 21 cloze existentes con variantes y opciones barajadas ·
`TablaTraza` en modo examen (1–2 ítems) · `CodeTabs` en los enunciados ·
panel docente con monitoreo y tiempo extra por persona · un ítem abierto para la
rúbrica (H5) · exportación al LMS.

**No entra, y se dice ahora para no discutirlo el día 6:** ejecución de código del
estudiante (H7) · los demás componentes de LP-CORE en modo examen —`DetectaError`,
`Comparador`, `OrdenaPasos`, `Emparejamiento`— · preguntas nuevas (se usa el banco
tal cual) · versión móvil · cualquier pulido visual que no afecte a responder.

---

## 1. Estado medido (2026-08-28)

```
Banco Moodle/rmd/cap01/   7 ejercicios   (16 sub-ítems)
Banco Moodle/rmd/cap02/   6 ejercicios   (11 sub-ítems)
Banco Moodle/rmd/cap03/   8 ejercicios   (14 sub-ítems)
                         ──                ──
                         21                41
```

| Herramienta | Estado |
|---|---|
| R 4.6.0 · `exams` 2.4.3 · `jsonlite` · `digest` · `bslib` · `DBI` | ✅ |
| `shiny`, `RSQLite`, `sodium` | ❌ hay que instalarlos |
| Python 3.10.14 + `streamlit` 1.62.0 | ✅ (no se usa — ver H3) |
| `TablaTraza` (E1), `CodeTabs`, `SelectorLenguaje` en LP-CORE | ✅ escritos |

Del syllabus: existe una **«RÚBRICA PARA UNA PRUEBA ESCRITA TIPO PARCIAL CORTO»**
con dimensiones de modelación, resolución de problemas y dominio de algoritmos.
Ver H5.

---

## 2. Hallazgos

### H1 · La app no debe compilar R/exams en vivo

Treinta compilaciones simultáneas convierten el minuto 0 del parcial en un cuello
de botella, y un fallo intermitente —como el de notación científica ya documentado
en `compilar_banco.R`— aparecería **durante** el examen en vez de en su escritorio.

**Consecuencia:** el examen se genera la noche anterior, en frío, como archivos.
La app solo lee, muestra, guarda y califica.

### H2 · El contrato entre generación y entrega es un archivo, no una función

Un **JSON por estudiante**, en dos piezas que nunca se juntan:

- `examenes/<sid>.json` — enunciados en HTML, tipos de ítem, opciones. **Sin clave.**
- `claves/<sid>.json` — `exsolution`, `extol`, `exclozetype`, permutaciones. Nunca sale del servidor.

Además el JSON es la evidencia: es literalmente el examen que esa persona vio,
archivable y auditable meses después.

### H3 · Calificar fuera de R sería reimplementar R/exams, y reimplementarlo mal

Tolerancia `extol` en los `num`, crédito parcial en los `mchoice` con la regla
`false2` y sin negativos —lo que `exams2moodle` aplica por defecto—. Reescribir
eso produce discrepancias entre la nota de la app y la que habría dado Moodle, y
esas se reclaman.

**Consecuencia:** califica R con `exams_eval()`. Decide **Shiny sobre Streamlit**,
aunque Streamlit esté instalado y Shiny no.
*(A verificar en D2: firma y valores por defecto de `exams_eval()` en 2.4.3.)*

### H4 · La cédula es dato personal y no tiene por qué vivir en el servidor

Ley 1581 de 2012. La app no necesita la cédula: necesita saber si quien la escribe
está en la lista. `sid = HMAC(pepper, cédula)[1:16]`, con el *pepper* en variable
de entorno. El servidor guarda `sid`, nunca la cédula; la tabla `sid → nombre` se
queda offline en su máquina y solo se usa al pasar notas.

Nunca en la URL, ni en logs, ni en el JSON.

### H5 · Un parcial 100 % autocalificado no es la prueba que declara el syllabus

La rúbrica institucional evalúa modelación y sustentación; un examen que solo
recoge números y letras no produce evidencia para esas dimensiones. Se resuelve
barato: **un ítem abierto** —escribir un fragmento de pseudocódigo o justificar una
decisión— que se guarda como texto y se califica a mano en el panel docente. Lo
que no debe hacerse es intentar autocalificar prosa.

### H6 · Barajar opciones por estudiante cierra el H10 del capítulo 3

`PLAN_TAREA6_CAPITULO_03.md` §H10 registra que «la clave estaba siempre en la misma
letra». Con examen generado por persona, el orden se baraja con la misma semilla y
el problema desaparece por construcción, no por disciplina al escribir.

### H7 · Ejecutar código del estudiante queda fuera

Es la ventaja más golosa y la más peligrosa: ejecutar Python arbitrario en su
servidor es abrir una shell al curso. Exige sandbox y límites de recursos, y no
cabe en el calendario. Los ítems de *predecir la salida* y el Trazador evalúan lo
mismo sin ejecutar nada.

### H8 · El autoguardado no es una mejora: es lo que hace viable todo lo demás

Si las respuestas solo se escriben al pulsar «Enviar», cualquier caída borra el
parcial de esa persona sin reconstrucción posible. Con autoguardado por ítem, la
misma caída cuesta treinta segundos y un `F5`. Es la línea entre «app de examen» y
«formulario bonito».

### H9 · `TablaTraza` lleva la clave en las props · **el hallazgo que obliga a un modo examen**

En `lp-core-extra.jsx:439`, las celdas ocultas se validan contra `filas[i][clave]`:
los valores correctos **están en el navegador**. En material de estudio es lo
correcto —comprobar sin servidor es la gracia—. En un examen significa que
cualquiera que abra las herramientas del navegador ve la respuesta.

La adaptación es acotada, no un componente nuevo:

1. Las props llegan con las celdas ocultas **vacías**; la clave se queda en el servidor.
2. Sin botón «Comprobar traza», sin «Ver pista», sin el `→ valor` de la retroalimentación.
3. El estado se reporta con `Shiny.setInputValue('traza_<id>', valores)` en cada cambio.
4. La calificación es del servidor, con la misma función que califica los cloze.

**No se toca `TablaTraza`.** Se añade un `TablaTrazaExamen` al lado: el material en
producción no puede romperse por una necesidad del parcial.

### H10 · La página depende de 40 archivos externos de 7 dominios distintos

`lp-base.html` referencia **20 archivos** —React, Babel, Tailwind, Prism (10),
MathJax, Plotly, Font Awesome y dos hojas de Google Fonts— desde `unpkg`,
`cdn.jsdelivr.net`, `cdn.tailwindcss.com`, `cdnjs.cloudflare.com`, `cdn.plot.ly` y
`fonts.googleapis.com`.

Pero esos 20 no son todos: **dentro** de las hojas de estilo hay otros 20
archivos —los iconos de Font Awesome y las 12 tipografías en `fonts.gstatic.com`—
que solo se descubren leyendo el CSS. En total, 40 archivos y siete dominios.
Descargar solo los 20 visibles produce una página que carga, se ve mal y sigue
saliendo a internet.

*(Corrección: los planes anteriores decían «23 recursos». La cifra salía de
contar también los dos `preconnect`, que son pistas y no archivos.)*

### H11 · Babel en el navegador hace innecesario un empaquetador

La librería ya se transpila en el cliente con `@babel/standalone`, sin `npm` ni
build. Eso permite servir los `.jsx` de LP-CORE tal cual desde Shiny y devolver
valores con `Shiny.setInputValue()`, que funciona desde cualquier JS de la página.
Los componentes de Streamlit, en cambio, viven en un iframe y exigen empaquetado y
un protocolo propio. Refuerza H3: **Shiny**.


### H12 · R arranca en locale «C» y rompe todos los acentos *(hallado al ejecutar, 2026-08-29)*

`LANG` no está definido en el entorno, así que `Rscript` arranca con
`LC_CTYPE=C` y `readLines()` falla ante la primera tilde: el blueprint no se
podía ni leer. Un examen entero en español se habría generado con la
codificación rota, y no se vería hasta abrir el JSON.

`generar.R` lo corrige **dentro del guion**, no en la terminal: fija un locale
UTF-8 al arrancar y aborta con un mensaje explícito si no encuentra ninguno.
Depender de cómo tenga configurada la terminal quien lo ejecute es exactamente
el tipo de fallo que aparece la noche antes del parcial.

**H12b · el arreglo estaba en un guion y faltaba en el otro** *(2026-08-30)*.
`calificar.R` era el único guion de entrada sin ese bloque. No es cosmético
allí: la normalización de las celdas de traza unifica los guiones «— – -» con
los que el estudiante escribe que la variable todavía no tiene valor, y la de
texto pasa por `tolower()`. En locale «C» la primera respuesta con una tilde o
un guión largo **aborta la calificación** —«input string 1 is invalid»— en vez
de calificarla mal: no califica mal, deja de calificar, y con el salón
entregando. Corregido; las 57 pruebas pasan con `LANG` y sin él. Revisados los
demás guiones de entrada: `generar.R`, `comprobar.R`, `informe_simulacro.R`,
`vendorizar.R` y las dos apps lo tienen; `esquema.R` y `trazas.R` no lo
necesitan porque solo se cargan desde un guion que ya lo fijó.

### H13 · Seis ejercicios del banco no compilan a PDF *(hallado al ejecutar, 2026-08-29)*

Los seis que llevan tabla en Markdown —`mascara_bits`, `secuencia_asignaciones`,
`simbolo_ansi`, `liquidacion_nomina`, `salida_secuencia`, `traza_filas`— abortan
con `LaTeX Error: No counter 'none' defined`.

La causa no es de pandoc sino de **R/exams**: antepone `\def\LTcaptype{none}` a
las tablas sin título para no incrementar el contador, y `longtable` acaba
llamando `\addtocounter{none}`, que en las distribuciones de TeX actuales no
existe. Es una incompatibilidad de versiones, no un error del banco.

La cura es una línea —`\newcounter{none}`— y vive en `parcial/plantilla_papel.tex`.

**Esto excede el parcial:** mientras el banco solo se exportaba a Moodle el
defecto era invisible, porque el driver de Moodle no pasa por LaTeX. Cualquier
intento futuro de sacar un PDF del banco —un taller impreso, un supletorio— se
habría topado con lo mismo sin explicación a la vista.

### H14 · `babel` con `spanish` es incompatible con la matemática del banco *(hallado al ejecutar, 2026-08-29)*

Añadir `\usepackage[spanish]{babel}` a la plantilla del papel —lo natural para
partir bien las palabras— revienta con `Incompatible glue units`: el estilo
español redefine el espaciado del signo de porcentaje y choca con expresiones
como `64.8\,\%` en modo matemático, que aparecen en `tasa_efectiva_anual`,
`traza_interes_simple` y otras. La opción `es-noshorthands` **no** lo evita; se
probó. La plantilla va sin `babel` y con los rótulos traducidos a mano, y lleva
el aviso escrito para que nadie lo vuelva a añadir.

### H15 · El banco no está en `main` *(hallado al ejecutar, 2026-08-29)*

`Banco Moodle/` completo —los 21 `.Rmd`, el compilador y los XML— vive
únicamente en `cap03/control-secuencial`, sin mergear. `main` no tiene ni un
ejercicio. La rama del parcial sale por tanto de `cap03/control-secuencial`, y
**todo el parcial depende de trabajo sin integrar**: mientras esa rama no se
funda con `main`, el banco tiene un solo punto de fallo.

**Corrección del 2026-09-19: el diagnóstico estaba mal, por partida doble.**

Primero, `cap03/control-secuencial` **ya estaba fundida** cuando se escribió
esto: es el PR #3, commit `dc59c76`, que es `origin/main`. Lo que estaba once
commits atrasado era el `main` **local**. Adelantarlo fue todo lo que hacía
falta por ese lado.

Segundo, y más importante: **el banco nunca estuvo en git, en ninguna rama.**
`Banco Moodle/` está en `.gitignore` desde el primer commit —`37407a0`— y a
propósito, porque los `.Rmd` llevan la respuesta correcta y el repositorio es
público. Ningún merge lo habría protegido: no había nada que fundir.

El riesgo es real, pero es otro, y **sigue abierto**: el banco existe solo como
archivos sin versionar en la máquina del docente. Ni rama, ni remoto, ni copia.
Un `git clean -xdf` mal apuntado, o el disco, y se van los 21 ejercicios y los
XML compilados —y con ellos la capacidad de generar el parcial, que depende de
ellos—. La salida no es fundir ramas: es un repositorio **privado** aparte, o
una copia cifrada fuera de la máquina. Es §8 P7.


### H16 · Un solo número puede valer 15 de los 100 puntos *(hallado al calificar, 2026-08-30)*

Al calificar un examen real apareció esto: `salida_secuencia` es un ejercicio de
**un solo sub-ítem**, y como el blueprint reparte los puntos *por ejercicio*, ese
número aislado vale los 15 puntos completos del ejercicio de capítulo 3. En el
mismo examen, cada casilla de `precedencia_operadores` vale 3,33.

| | |
|---|---|
| Ejercicios de un solo sub-ítem | **9 de 21** |
| Lo que vale un dato suelto | entre **3,33 y 15 puntos** |
| Factor entre el más caro y el más barato | **4,5×** |

Los nueve están concentrados donde más pesa: cinco de los ocho de capítulo 3 y
cuatro de los seis de capítulo 2. Un estudiante que se equivoca en una tecla
pierde el 15 % del parcial; otro que se equivoca en un ejercicio con tres
casillas pierde el 5 %. **No es un defecto del código: es una consecuencia del
blueprint que solo se ve al calificar**, y la decisión es suya (§8 P6).

**Resuelto el 2026-08-30.** Los cinco de capítulo 3 con un solo sub-ítem
—`tasa_efectiva_anual`, `precedencia_liquidacion`, `salida_secuencia`,
`credito_conviene`, `intercambio_lineas`— salen del blueprint. El pool de cap03
queda en tres, todos de tres sub-ítems: ningún dato suelto de ese capítulo pasa
de 5 puntos. El capítulo no queda peor cubierto, porque además de sus dos
ejercicios todo el mundo hace la prueba de escritorio, que son otros 15 puntos
del mismo capítulo. Los cuatro de capítulo 2 con un solo sub-ítem **se
quedaron**, a 10 puntos. Los cinco siguen compilados en el banco de Moodle:
esto los saca del parcial, no del curso.


### H17 · `radioButtons` deja marcada la primera opción · **el fallo más caro que no se ve**

Shiny preselecciona la primera opción de un grupo de radios salvo que se pase
`selected = character(0)`. En un examen eso significa que **quien no responde
una pregunta entrega la opción A marcada**, sin haberla tocado: no aparece como
«sin responder» sino como respuesta incorrecta —o, peor, como correcta por azar
una vez de cada cuatro—.

No hay error, no hay aviso y el estudiante ve exactamente lo que esperaba ver.
Se habría descubierto reclamando notas.

Está corregido en `control_item()` y comprobado en el navegador: con el examen
recién abierto, 21 radios y 4 casillas, **cero marcados**.

### H18 · La comprobación automática mintió durante una hora *(2026-08-30)*

Al verificar el examen en el navegador, la página parecía **no desplazarse**:
`scrollTo(0, 3000)` dejaba `scrollY` en 0 con 5301 px de contenido. Una página
estática de control en la misma pestaña sí bajaba, lo que apuntaba a un fallo
propio y grave —si el examen no baja, nadie llega a la pregunta 2—.

No lo era. Bootstrap 5.3 activa `scroll-behavior: smooth` en `:root`, y un
desplazamiento suave es una animación por fotogramas: con el navegador en
segundo plano los fotogramas no se sirven y la página nunca llega a moverse.
La página de control no cargaba Bootstrap, así que el experimento comparaba dos
cosas a la vez. Para una persona frente a la pantalla no hay ningún problema.

Queda `scroll-behavior: auto` en `examen.css` con el porqué escrito: en un
examen la animación no aporta nada y su coste es que las comprobaciones
automáticas del D6 y del D8 dejen de ser fiables.


### H19 · `allowReconnect(TRUE)` no hace nada bajo `runApp()` *(hallado al ejecutar, 2026-08-30)*

Una caída de red de treinta segundos en el aula no puede costar un examen. Shiny
trae `session$allowReconnect(TRUE)` justo para eso, pero **solo surte efecto
cuando la app la sirve Shiny Server o Posit Connect**. Bajo `runApp()` —que es
como se va a desplegar en el VPS— no hace absolutamente nada.

Comprobado cortando el socket a propósito: con `TRUE`, doce segundos después la
app seguía desconectada y el reloj congelado. Con `"force"`, el aviso desaparece
sola y el reloj retoma **descontando el tiempo del corte**, que es lo correcto.

`"force"` es una opción pensada para pruebas y aquí se usa en producción a
sabiendas; queda escrito en el código. **Restricción de despliegue que se deriva
de esto:** un solo proceso de R, o sesiones pegajosas en el proxy. Con varios
trabajadores la reconexión caería en un proceso que no conoce la sesión.

### H20 · Sin `local()`, todo el examen se guarda en un solo campo

El autoguardado crea un observador por ítem dentro de un bucle. En R, los
observadores capturan la *variable*, no su valor: sin envolver cada vuelta en
`local()`, los quince observadores comparten la última iteración y cada tecla de
cualquier campo escribe sobre el mismo ítem. No da error: da un examen con una
sola respuesta y catorce vacías.

### Principio de diseño · se califica lo guardado, no la pantalla

`entregar()` vuelca los campos a la base de datos y **luego lee de la base de
datos** para calificar. Parece un rodeo y es lo que hace posible que el examen se
cierre correctamente cuando el tiempo vence con el navegador ya cerrado: no hay
pantalla que consultar, y la nota sale igual de lo que alcanzó a guardarse.


### H21 · Dos apps con dos ideas del esquema · **el panel se quedó en blanco**

El panel consultaba `respuestas.ts_epoch`, una columna que solo creaba la app del
examen. Al arrancar el panel contra una base donde la otra app aún no había
corrido, cada consulta reventaba y **el panel se quedaba en blanco**, sin decir
por qué.

El esquema vive ahora en `parcial/esquema.R` y lo cargan las dos. Dos programas
que se hablan por una base de datos no pueden tener dos ideas de cómo es.

De paso, el panel también dejó de poder quedarse en blanco: sus dos bloques
atrapan el error y muestran un mensaje.

### H22 · Todo bien y nadie entra: la huella del pepper

Si la app arranca con un pepper distinto del que generó los exámenes, calcula
identificadores distintos y **no entra nadie** — mientras todo lo demás se ve
perfectamente normal: los archivos están, la app responde, el código del día
funciona. Es el fallo más difícil de diagnosticar con el salón lleno.

`generar.R` deja ahora el `sha256` del pepper en `salida/huella_pepper.txt` y
`comprobar.R` lo coteja antes de abrir. Se probó con un pepper equivocado: lo
detecta. Sin esa comprobación, el guion previo daba «todo en orden» con un pepper
aleatorio.

### H23 · Un `renderUI` sin dependencias no se entera de nada

La lista de estudiantes a los que calificar la sustentación se pintaba una sola
vez: como no dependía de nada reactivo, **no habría crecido durante el parcial** a
medida que la gente entregaba. Ahora la mantiene un observador con
`updateSelectInput`, que además conserva la selección y no le borra al docente la
nota que está escribiendo.

*(Al diagnosticarlo me equivoqué dos veces leyendo el DOM: `selectize` vacía el
`<select>` original y guarda las opciones en JavaScript, así que la lista sí
tenía a los dos estudiantes. El defecto de fondo era real; el síntoma que creí
ver, no.)*


### H24 · El componente de React se descartó, y la razón es la reanudación

El §H9 daba por hecho adaptar `TablaTraza` de LP-CORE y devolver el estado con
`Shiny.setInputValue`. Al construirlo se impuso otra cosa: **la tabla se arma en
el servidor con campos de Shiny corrientes**.

El argumento decisivo no es el peso —aunque quitar React, ReactDOM y Babel son
3,1 MB menos por estudiante en el peor momento— sino la **reanudación**. Con el
estado dentro de un componente de React hay que serializarlo, mandarlo al
servidor y volver a inyectarlo al montar; con campos de Shiny, el autoguardado,
la reanudación y la calificación del D6 funcionan **sin escribir una línea más**,
y son justamente la parte que no puede fallar.

Lo que se pierde es tener dos implementaciones de «tabla de traza»: la del
material y la del examen. Lo que se gana es que la del examen no tiene estado
propio que se pueda perder.

Las pestañas de los cuatro lenguajes tampoco necesitaron React: cambiar de
pestaña es mostrar un bloque y ocultar otro, y son quince líneas de JavaScript
que además recuerdan el lenguaje elegido para todo el examen.

### H25 · El banco solo tiene un lenguaje

Los 21 ejercicios cloze tienen bloques de código, pero **todos en pseudocódigo y
sin declarar lenguaje**: no hay versión en Python, R ni VBA. Las pestañas de
cuatro lenguajes no se pueden retroajustar al banco sin reescribir los 21
ejercicios, y eso es trabajo de contenido, no de plomería.

Por eso las pestañas viven en las trazas, donde las cuatro versiones se escriben
a mano en `parcial/trazas.R`. Si se quiere el paralelo en todo el parcial, hay
que presupuestar la reescritura del banco aparte.

### H26 · Ocultar una celda no basta: hay que ocultar el arrastre

La primera versión ocultaba una celda por variable. La fila siguiente mostraba
ese mismo valor —una columna de traza arrastra el número hacia abajo—, así que el
ejercicio se resolvía **copiando de la fila de abajo**, sin trazar nada.

Ahora se oculta la columna entera desde la fila en que la variable recibe su
primer valor. Eso trae el problema opuesto: un error en la primera celda se
hereda y un solo desliz costaría los quince puntos. La clave marca cada celda
heredada con el `id` de la que la origina, y el calificador **da por buena la
celda coherente con la respuesta que el propio estudiante dio antes**. Es lo que
hace un corrector humano.

Medido sobre un caso real: un estudiante que se equivoca en `devengado` y arrastra
su error con coherencia saca **9 de 15** en vez de 0. El arrastre rescata dentro de
cada columna; no rescata entre columnas —quien deriva `salud` de un `devengado`
equivocado pierde también el origen de `salud`—, y eso queda dicho a propósito.

### H27 · Tres fallos propios que no daban ningún error

- **`i` reutilizada.** El bucle de celdas ocultas usaba la misma variable que el
  bucle de estudiantes. Todos escribían en la misma fila del manifiesto y solo
  sobrevivía el último. El generador ahora comprueba que el manifiesto tenga una
  fila por examen y aborta si no.
- **`shiny-bound-input` puesta a mano.** Esa clase la añade Shiny a lo que *ya*
  enlazó; ponerla hizo que se saltara las diez celdas de la traza, que se
  guardaban vacías sin queja alguna.
- **`as.numeric()` en la comparación del arrastre.** Devuelve `NA` ante
  «1.000.000», de modo que el arrastre fallaba justo cuando el estudiante
  escribía bien los miles. Se unificó con las reglas de lectura del resto del
  calificador.

### H28 · La traza no salía en el PDF de respaldo

`exams2pdf` solo conoce el banco `.Rmd`, así que el papel se quedaba quince
puntos corto: el plan B habría dejado de ser el mismo examen justo cuando más
falta hace. El generador inyecta ahora la traza en el `.tex` que deja R/exams y
lo recompila; el PDF lleva el enunciado, el pseudocódigo y la tabla con las
casillas en blanco.


### H29 · Sin distinguir la edición, el simulacro le enseña el parcial

Las semillas se derivan del `sid` y del nombre de la etiqueta —`ejercicio1`,
`baraja2_1`—. Nada más. De modo que el mismo estudiante, en el mismo ejercicio y
en la misma posición, recibe **exactamente las mismas cifras** en el simulacro y
en el parcial. Comprobado: la semilla del primer ejercicio era idéntica en
ambos.

Un ensayo general que reparte las respuestas del examen no es un ensayo: es una
filtración con buena intención, y no habría dado señal alguna.

Cada blueprint declara ahora una `edicion` que entra en la derivación de todas
las semillas, y `generar.R` **se niega a generar** si falta. Verificado: donde el
mismo ejercicio le toca a la misma persona en las dos ediciones, las cifras
difieren.

### H30 · Arreglar el reparto de puntos concentró la evaluación en un solo caso *(2026-08-30)*

Efecto de segundo orden del H16, y no se veía en el blueprint: con el pool de
capítulo 3 reducido a tres ejercicios, el sorteo de la prueba de escritorio
empezó a repetir el escenario del cloze. `liquidacion_nomina` y
`traza_interes_simple` del banco plantean **la misma nómina y el mismo crédito**
que las dos trazas.

Que a alguien le toquen los dos no es media evaluación repetida —el cloze pide
el valor final y la traza pide el estado paso a paso—, pero concentra **30 de
sus 45 puntos de capítulo 3 en un único caso** y deja el otro sin evaluar.
Medido sobre 40 estudiantes: pasó del 28 % al 70 % del curso.

`generar.R` sortea ahora la traza **descartando la gemela** de lo que ya salió
en los cloze (`GEMELO_TRAZA`, en `trazas.R`). El descarte es *best-effort* a
propósito: cuando el sorteo de capítulo 3 se lleva las gemelas de todas las
trazas disponibles, no hay ninguna que ofrecer y se sortea sobre el pool
completo. Preferir eso a dejar a alguien sin prueba de escritorio.

Queda en **30 %**, que es el suelo aritmético con este blueprint: es exactamente
la probabilidad de que a alguien le toquen a la vez los cloze de nómina y de
crédito, y entonces las dos trazas están vetadas. Bajarlo más no es cuestión de
código: exige una tercera traza sobre un caso que el banco no cuente, o sacar
del pool uno de los dos cloze gemelos.

---

## 3. Arquitectura

```
  SU MÁQUINA (offline, la noche anterior)          VPS (día del parcial)
  ─────────────────────────────────────            ─────────────────────
  roster.csv  (cédula, nombre, grupo)
        │  HMAC(pepper)                             app Shiny
        ▼                                             ├─ login: cédula + código del día
  parcial/generar.R                                   ├─ lee examenes/<sid>.json
    ├─ semilla = f(sid)                               ├─ LP-CORE servido local (H10)
    ├─ xexams() sobre el banco existente              │    CodeTabs · TablaTrazaExamen
    ├─ examenes/<sid>.json  (enunciados) ───────────► ├─ autoguarda cada respuesta
    ├─ claves/<sid>.json    (clave)      ───────────► ├─ cronómetro del servidor
    └─ papel/<sid>.pdf      (plan B impreso)          ├─ calificar.R  (exams_eval)
                                                      ├─ panel docente
                                                      └─ SQLite (WAL) + eventos.jsonl
                                                              │
       LAN en el aula (respaldo caliente) ◄───── misma app ────┤
                                                              ▼
                                                      resultados.csv → LMS
```

Un solo examen, tres caminos de entrega —VPS, LAN, papel— que salen de la misma
generación. Cambiar de camino no cambia el examen.

---

## 4. Calendario de 9 días

Las fases están fechadas relativas: **D1 es el primer día de trabajo, D+ el parcial.**
Cada día declara qué deja terminado; lo que no quepa se recorta del día siguiente,
nunca del simulacro.

### D1 · Compuertas y terreno · ✅ PARCIALMENTE (2026-08-29)
- [x] G1 y G2 (§0.3) — **ambas abiertas**: hay aval y hay sesión para el simulacro.
- [ ] Visitar la sala: nº de equipos, navegador, si el proxy deja salir a internet,
      si los equipos se ven entre sí (respaldo LAN).
- [ ] Blueprint: qué ejercicios de cada capítulo, puntos, minutos, ítem abierto.
- [x] Rama `parcial/app-examen`, creada desde `cap03/control-secuencial` (H15).
- [x] `shiny` 1.14.0 y `RSQLite` 3.53.3 instalados. `sodium` **no** compiló —le falta
      la librería del sistema— y no hace falta: `digest::hmac()` cubre el HMAC.
- [ ] Blueprint revisado por usted: `parcial/blueprint.yml` está escrito con una
      propuesta (2+2+3 ejercicios, 85 puntos de cloze + 15 del ítem abierto, 90 min),
      pero los pesos y el reparto son decisión suya.
- [ ] Provisionar el VPS (Docker + HTTPS). Sin la app todavía.
- [ ] Visita a la sala (sigue pendiente: es lo único del D1 que no se puede hacer desde aquí).

### D2 · El generador · ✅ COMPLETADA (2026-08-29)
- [x] `parcial/generar.R` (351 líneas): roster → `sid` por HMAC → semillas → `xexams()`.
- [x] `examenes/` y `claves/` separados (H2), **comprobado**: ningún examen contiene
      los campos `sol`, `tol`, `retro`, `perm`, `rubrica` ni `solucion`.
- [x] Barajado de opciones por estudiante (H6), con texto, clave y retroalimentación
      permutados juntos.
- [x] `papel/<sid>.pdf` desde el **mismo sorteo**: `xexams()` acepta una matriz de
      semillas *por ejercicio*, así que las dos pasadas no coinciden por suerte sino
      por construcción. El generador compara las soluciones de ambas y lo reporta.
- [x] `.gitignore`: `parcial/salida/`, `roster.csv`, `*.sqlite`. Verificado con
      `git check-ignore`: solo se versionan los tres archivos fuente.
- [x] Un fallo propio corregido: el resumen cantaba «✓ el PDF coincide» cuando la
      comparación no había llegado a correr. «No hubo divergencias» y «se comprobó
      que coinciden» no son la misma afirmación.

### D3 · El calificador y los assets · ✅ COMPLETADA (2026-08-30)
- [x] `parcial/calificar.R` sobre `exams_eval()` (H3). **41 pruebas, todas en verde**:
      exacto, dentro y fuera de tolerancia, vacío, ilegible, fuera de rango,
      `mchoice` parcial con la regla de Moodle (una de dos → mitad; una bien y una
      mal → cero; marcarlo todo → cero), examen en blanco y examen completo.
- [x] Lectura de números a la colombiana: `10.368.000`, `10,5`, `1.234,56`,
      `$ 24.000.000` y `64,8 %` se leen todos bien. Cuando la escritura es
      genuinamente ambigua —`1.500` puede ser mil quinientos o uno coma cinco— se
      evalúan **las dos lecturas** y se acepta si alguna cae en la tolerancia,
      dejando constancia de cuál se usó. Es una permisividad deliberada: sin ella,
      una respuesta correcta escrita con separadores se marcaría mal.
- [x] Los ítems abiertos no se autocalifican: salen como pendientes y la nota se
      marca **provisional** en vez de dar por bueno un total incompleto.
- [x] Prueba de extremo a extremo contra un examen y una clave reales: perfecto
      85/85 → 4,25 provisional; en blanco → 0; mixto con el abierto en 9/15 → 3,2.
- [x] `parcial/vendorizar.R`: 40 archivos, 7 dominios, incluidas las referencias
      internas de los CSS. Comprobado en el navegador: **ni una sola petición sale
      de `localhost`**, sin errores de consola, con React, Babel, Tailwind, Prism,
      MathJax y Font Awesome funcionando.
- [x] La página del examen carga **5,5 MB** y no 9,9: se dejan fuera Plotly (4,4 MB,
      que el examen no usa) y los Prism de lenguajes que no aparecen. Con 30
      estudiantes conectándose a la vez, son 132 MB que no se piden en el peor momento.
- [x] Dos fallos propios corregidos sobre la marcha: los dos CSS de Google Fonts
      se guardaban con el mismo nombre —al recortar la cadena de consulta— y el
      segundo se daba por descargado, de modo que la tipografía del código no
      habría cargado sin dar ningún error; y las hojas de Google Fonts no se
      reconocían como CSS por no acabar en `.css`, así que sus 12 tipografías
      seguían apuntando a internet.

> ### ⏸ Punto de control 1 — El examen existe como dato
> Tres estudiantes de prueba generados. Se abren los JSON, se leen los enunciados,
> se contrastan con el PDF y se corre `calificar()` a mano. **Si esto pasa, el
> examen ya está hecho aunque la app no exista** — y el camino Moodle sigue abierto
> sin pérdida.

### D4 · Rebanada vertical · ✅ COMPLETADA (2026-08-30)
- [x] `parcial/app/app.R` (339 líneas) y `parcial/app/www/examen.css`, con la paleta
      del material (#3D008D → #ED1E79, Montserrat y Fira Code servidas en local).
- [x] Acceso con cédula + código del día, aviso de tratamiento de datos en la misma
      pantalla. Comprobado en el navegador: código errado → rechaza; documento sin
      examen → rechaza; `1.000.000.001` con puntos → **entra**, porque la
      normalización de la cédula es la misma que la del generador.
- [x] Examen completo en pantalla: 8 bloques, 8 campos numéricos, 21 radios en 5
      grupos, 4 casillas, 1 área de texto, con tablas y bloques de código del
      enunciado bien formados.
- [x] Esquema SQLite en modo WAL: `sesiones`, `respuestas`, `eventos`, `notas`.
      La primitiva de guardado es **por ítem**, no por examen, para que el D6 pueda
      llamarla en cada cambio sin reescribir nada.
- [x] Entrega verificada de extremo a extremo: 15 respuestas guardadas, nota
      85/100 = 4,25 marcada provisional, y la bitácora con los dos intentos
      fallidos de acceso.
- [x] Un examen ya entregado **no se puede volver a abrir**.
- [x] Dos defectos de uso corregidos al probarla: la cédula se borraba del campo
      tras cada error —volver a teclearla bajo presión es fricción gratuita— y el
      texto sobre el degradado era ilegible justo donde van los puntos y los minutos.

**Lo que todavía NO tiene, y por eso no puede usarse en un parcial real:**
autoguardado, reanudación, cronómetro, sesión única y panel docente. Está escrito
en la cabecera de `app.R` para que nadie lo despliegue por error.

### D5 · Los componentes de LP-CORE · ✅ COMPLETADA (2026-08-30)
- [x] `parcial/trazas.R` — dos pruebas de escritorio (liquidación de nómina e
      interés simple), cada una función de una semilla, con las cifras elegidas
      para que la traza dé números exactos: un desk-check con decimales
      periódicos evalúa la calculadora, no el razonamiento.
- [x] La tabla se arma **en el servidor**, no con el componente de React (H24).
      La respuesta nunca viaja al navegador, y autoguardado, reanudación y
      calificación funcionan sin plomería nueva. Verificado: diez celdas
      recuperadas tras recargar, incluido el «—», con el reloj continuando.
- [x] Pestañas de los cuatro lenguajes, con Prism resaltando y el lenguaje
      elegido recordado para todo el examen.
- [x] Calificación de celdas con el mismo calificador, tipo `celda`: acepta el
      guion en sus tres escrituras, lee los miles a la colombiana y aplica
      **error de arrastre** (H26). 57 pruebas en verde.
- [x] La traza va también al **PDF de respaldo** (H28).
- [x] El blueprint cambia: cap03 baja de 3 a 2 cloze y la traza ocupa su lugar
      por 15 puntos. El total sigue en 100, y el capítulo del parcial se evalúa
      ahora con su propio método.
- [x] Ítem abierto: ya estaba desde el D4.

> ### ⏸ Punto de control 2 — Un examen completo, un usuario · **segundo criterio de aborto**
> Usted presenta el parcial entero en local, de principio a fin, y la nota de la app
> coincide con la de consola. **Si al terminar el D5 esto no funciona, se va por
> Moodle**: quedan tres días y hay que gastarlos en robustez y simulacro, no en
> terminar funcionalidad.

### D6 · Robustez · ✅ COMPLETADA (2026-08-30)
- [x] **Autoguardado por tres vías independientes**, y las tres verificadas por
      separado en la bitácora: rebote de 0,9 s tras la última tecla (0,25 s al
      marcar una opción), guardado inmediato al salir del campo, e instantánea
      completa cada 20 s como red de seguridad. Se comprobó que el rebote dispara
      **solo** —un evento suelto para un ítem— y no gracias a la instantánea.
- [x] **Reanudación**: al volver a entrar se recuperan los valores, se marca el
      banner y **el reloj continúa donde iba** —88:36, no 90:00—. Volver a entrar
      no regala minutos.
- [x] **Cronómetro del servidor**: el inicio se sella en la base de datos y el
      reloj del cliente no se consulta nunca. Al vencer, el examen se cierra solo,
      se califica y se marca `motivo_cierre = 'tiempo'`. Verificado retrasando el
      inicio en la BD: cerró con «Se acabó el tiempo» y calificó 5/100 sobre lo
      guardado. Entrar cuando el tiempo ya venció tampoco abre el examen.
- [x] **Sesión única con relevo** por token en la base de datos —no en memoria, para
      que funcione aunque el proceso se reinicie—. Verificado con dos ventanas: la
      segunda entra y la primera pasa a «Sesión abierta en otro lugar» en 5 s.
- [x] **`eventos.jsonl` append-only** con los valores de cada respuesta, no solo
      el hecho de que cambió: es lo que permite reconstruir el parcial si la base
      de datos se pierde.
- [x] **Ningún camino termina en blanco.** Tres errores, tres mensajes distintos y
      accionables: documento sin examen, examen ya entregado, y —nuevo— archivo
      **corrupto**, que antes se confundía con «no tiene examen asignado» y habría
      mandado al docente a buscar donde no era.
- [x] **Caída de red** (estaba en el guion del D8, se adelantó): aviso propio en vez
      del velo gris de Shiny, y reconexión automática (H19).
- [x] **Matar el servidor a mitad de examen** (también del D8): proceso muerto,
      levantado de nuevo, el estudiante vuelve a entrar y recupera su respuesta con
      el reloj en 88:46. Es la prueba que valida el §H8 entero.

### D7 · Panel docente y despliegue · ✅ COMPLETADA salvo el VPS (2026-08-30)
- [ ] Panel con contraseña propia, distinta del código del día: quién entró, por dónde
      va, cuánto le queda, **+N minutos por persona**, exportación de emergencia.
- [ ] Desplegar en el VPS con el *pepper* en variable de entorno.
- [ ] Respaldo LAN arrancable en menos de dos minutos, con el procedimiento escrito.
- [ ] Imprimir los `papel/<sid>.pdf` y meterlos en el maletín.

### D8 · Simulacro · **el día que decide**
- [ ] Prueba de carga sintética con nº de estudiantes + 50 %.
- [x] **Quiz del simulacro preparado**: `parcial/blueprint_simulacro.yml`, 20 minutos,
      50 puntos, sin peso en la nota. Los grupos son pequeños y elegidos para
      **garantizar que aparezcan los cinco tipos de ítem** —numérico, opción única,
      opción múltiple, traza y abierto—: un camino que no se ejercite en el ensayo
      será el que falle en el parcial. Verificado en el navegador: 1 numérico,
      2 grupos de radio, 2 de casillas, 6 celdas de traza y el área de texto.
- [x] Traza propia del simulacro (`intercambio_variables`, capítulo 2, seis casillas)
      para no gastar ninguna de las dos del parcial.
- [x] El ítem abierto del simulacro pide **reportar incidentes**: es la información
      que la app no puede ver y la que más vale ese día.
- [x] `parcial/despliegue/simulacro.sh` — carpeta, base de datos, bitácora y código
      del día **aparte**. Si el ensayo escribiera en la base del parcial, el día del
      examen el curso entero aparecería como «ya entregó».
- [x] `parcial/despliegue/informe_simulacro.R` — el veredicto sale de los datos y
      devuelve código de salida 1 si supera el umbral. Probado contra un escenario
      malo a propósito: 3 afectados de 4 → **NO APTO**.
- [x] `parcial/SIMULACRO.md` — protocolo de 40 minutos, guion de sabotaje con
      voluntarios, hoja de observación a mano y el criterio de aborto.
- [ ] **Ejecutarlo en la sala real, con el curso completo.** Es lo que falta.
- [ ] Guion de sabotaje deliberado. **Cuatro de los cinco casos ya pasaron en el D6**
      —recargar, entrar desde otro equipo, cortar la red y matar el servidor—; en el
      simulacro se repiten sobre el despliegue real y con el curso conectado, que es
      donde aparecen los problemas de concurrencia que una sola persona no ve.

> ### ⏸ Punto de control 3 — Luz verde o luz roja
> **Criterio de aborto, fijado por escrito antes del simulacro:** si más del 10 %
> del curso no pudo entrar o perdió respuestas, **el parcial va por Moodle**. Se
> escribe ahora precisamente para no negociarlo bajo presión el mismo día.

### D9 · Cierre de obra
- [ ] Corregir lo que rompió el simulacro. Solo eso: nada nuevo.
- [ ] Runbook de una página: URL, código del día, contraseña del panel, y qué hacer si
      (a) alguien no entra, (b) se cae el servidor, (c) se cae la red.
- [ ] Generar los exámenes definitivos y **verificar tres al azar**.

### D+ · El parcial
- [ ] Código del día en el tablero, no por chat.
- [ ] Exportar en cuanto termine el último. Copia a dos lugares.

### Después
- [ ] Calificar los ítems abiertos en el panel.
- [ ] Cruzar `sid → nombre` offline y subir notas al LMS.
- [ ] Devolución: cada quien recibe su examen con la solución que ya está escrita en el `.Rmd`.
- [ ] Archivar JSON, clave, respuestas y bitácora — es la evidencia ante un reclamo.
- [ ] **Borrar del VPS los datos personales** y apagarlo.
- [ ] Post-mortem en este archivo.

---

## 5. Riesgos

| # | Riesgo | Prob. | Impacto | Mitigación |
|---|---|---|---|---|
| R1 | Fallo del servidor o de la red en pleno parcial | media | **crítico** | D6 completo + LAN caliente + PDF impreso |
| R2 | G1 o G2 no se resuelven a tiempo | media | alto | se deciden el D1, antes de escribir código |
| R3 | El proxy de la sala bloquea un CDN | media | alto | H10: assets vendorizados el D3 |
| R4 | El calendario se come el simulacro | **alta** | **crítico** | el D8 no se recorta; se recorta funcionalidad |
| R5 | La clave se filtra por el navegador | alta si no se atiende | alto | H9: modo examen sin respuestas en las props |
| R6 | Suplantación (cédula + código circulan) | baja, es presencial | alto | vigilancia + variantes por persona + restringir a la red de la sala |
| R7 | Discrepancia entre la nota de la app y la clave | baja | alto | H3: un solo calificador, con pruebas |
| R8 | El PDF de respaldo no coincide con la pantalla | media | alto | verificado explícitamente el D2 |
| R9 | Equipos de la sala con navegador viejo | media | medio | probar el D1 en un equipo real, no en su Mac |

---

## 6. Supuestos declarados

1. Presencial y vigilado en sala de cómputo. Si cambiara a remoto, cédula + código
   no impiden que alguien presente por otro y el modelo de integridad se cae entero.
2. Temario: capítulos 1–3, que es lo que cubre el banco.
3. Curso entre 20 y 45 personas. Por encima de 60 cambian las cuentas.
4. Los equipos de la sala tienen navegador moderno y salida a internet — a confirmar el D1.
5. La nota oficial termina en el LMS pase lo que pase. La app es instrumento, no registro.

---

## 7. Comandos

```bash
export LPF_PEPPER="$(openssl rand -hex 32)"   # guárdelo: sin el mismo pepper nadie entra
Rscript parcial/generar.R --demo 6            # seis estudiantes ficticios
Rscript parcial/generar.R --roster roster.csv # el curso real
Rscript parcial/generar.R --solo 1020304050   # regenerar a una sola persona
Rscript parcial/generar.R --roster roster.csv --sin-pdf
```

El generador no depende de `LANG` (H12) y aborta si algo no cuadra: cédulas
repetidas, ejercicios del blueprint que no están en el banco, o un PDF que no
coincide con el JSON.

```bash
Rscript parcial/despliegue/comprobar.R    # once comprobaciones; si falla, no se abre
./parcial/despliegue/arrancar.sh          # comprueba y arranca examen + panel
ssh -N -L 8899:127.0.0.1:8899 usuario@servidor   # para llegar al panel
Rscript parcial/calificar.R --pruebas     # 41 pruebas del calificador
Rscript parcial/vendorizar.R              # descarga los 40 archivos externos
Rscript parcial/vendorizar.R --verificar  # no descarga: solo comprueba que estén
```

Pendiente de escribir: la app (D4-D7) y `parcial/exportar.R` (cierre).

---

## 8. Preguntas abiertas

- **P1 · G1: ¿hay aval?** (§0.3)
- **P2 · G2: ¿hay sesión de clase para el simulacro antes del parcial?** (§0.3)
- **P3 · ¿Cuántos estudiantes y cuántos equipos tiene la sala?** Define la prueba de carga.
- **P4 · ¿El código del día es uno para todos o uno por grupo?** Uno por grupo hace
  rastreable una filtración.
- **P5 · ¿Cuántos ítems de traza?** Uno es suficiente para probar el componente; dos o
  tres si es el corazón del parcial. Cada uno cuesta redacción, no programación.
- **P6 · ¿Se reparten los puntos por ejercicio o por sub-ítem?** (§H16)
  **Resuelta el 2026-08-30:** siguen repartiéndose por ejercicio, y en su lugar
  se sacaron del blueprint los cinco ejercicios de capítulo 3 que tenían un solo
  sub-ítem. Ver H16 y, por el efecto que trajo, H30.
- **P7 · ¿Dónde vive el banco de Moodle?** (§H15) Hoy, solo en el disco de la
  máquina del docente: `.gitignore` lo excluye a propósito de este repositorio,
  que es público. Sin versionar y sin respaldo, es el único punto de fallo que
  queda en pie. Un repositorio privado aparte o una copia cifrada; **la decisión
  es suya**, y no la resuelve ningún merge.
