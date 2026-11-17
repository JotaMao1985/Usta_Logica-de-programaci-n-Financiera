# Plan · Tarea 14 — Mejora de contenido del capítulo 4

**Fecha:** 2026-11-16. **Estado:** propuesto; espera la aprobación del docente y sus
decisiones A–I (§3). No se ha tocado el capítulo.

**Archivo:** `Material html/04_LPF_Control_Selectivo.html` (6 457 líneas en `main`,
commit `b3e13e3`; el contenido del capítulo va de la 2 739 al final). Todos los números
de línea de este plan son de ese commit.

**Modelo:** `PLAN_TAREA13_CAPITULO_03_CONTENIDO.md`. Igual que allí, la lectura crítica
independiente se hizo **antes** de planear (es la línea base de §2) y se repite **antes**
de la fusión.

---

## 0. Qué se decidió antes de planificar

Esta tarea no adapta el formato del capítulo —eso fue la Tarea 9—, sino su contenido: de
dónde sale lo que afirma, si es cierto, si no se contradice y si cumple lo que los
capítulos 1, 3 y 5 dan por hecho.

No se reabren: Zotero como autoridad, APA 7 generado, solo se cita lo leído, las seis
clases de afirmación, los cuatro lenguajes en paralelo con el pseudocódigo como
normativo, y los ejercicios de interpretación E1–E8.

Restricciones que salen de medir:

- **La numeración de las seis secciones no cambia.** El capítulo 5 remite al 4 trece
  veces (entre ellas «sección 1 del capítulo 4: al negar, el conector también cambia» y
  el ajuste del último abono como «una selectiva dentro del ciclo»); el 3 lo hace tres
  veces y el 1, una.
- **El capítulo 4 remite doce veces al 3**, ya revisado: la quinta fila de la tabla de
  precedencia, la prueba de escritorio y «cada instrucción se ejecutaba exactamente una
  vez». Se cotejan contra el capítulo 3 publicado, no contra el de antes.
- **Los cambios de LP-CORE se propagan a los cinco capítulos.** Este plan solo los toca
  en la fase 9, y lo dice.
- El banco Moodle tiene cinco preguntas del capítulo (`Banco Moodle/rmd/cap04`), en un
  repositorio privado aparte. Sigue vigente la orden del docente de no copiar nada al
  banco.
- El Decreto 1625 de 2016 y el Estatuto Tributario ya están en Zotero (tandas 04 y 05),
  pero de ellos solo se leyeron los artículos que usa el capítulo 3. Los que necesita
  este capítulo hay que leerlos.

## 1. Estado medido

| Qué | Cuánto | Cómo está |
|---|---|---|
| Citas en el cuerpo del capítulo | 0 | el capítulo 3 quedó con 13 |
| «Referencias», `<Fuente>`, `<Ilustrativo>` | 0 | no hay ninguno |
| Figuras y tablas sin fuente (regla 30) | 13 | 3 figuras, 2 diagramas y 8 tablas |
| Entidad o norma sin cita (regla 32) | 2 avisos | «tasa de usura» (`:4146`) y «DIAN» (`:5936`); no ve la retención por servicios ni «la norma llama fraccionamiento» |
| Ejercicios con tipo E1–E8 | 19 | cumple la cuota |
| Salidas declaradas de Python y R | 22 de 22 coinciden | ejecutadas por el lector independiente; las de VBA, sin ejecutar |
| Trazas con `exigeRespuesta` | 4 de 4 | ya lo traían |
| Notas del vault para el capítulo | 0 afirmaciones | `Cap 04 Control selectivo.md` dice `estado_contenido: sin-auditar` |
| Sonda de navegador | pasa | a 320 px, 8 de 8 lecciones |

Lectura crítica independiente (sin contexto, 2026-11-16): **ningún hallazgo alto, 12
medios y 24 bajos.** Ejecutó los bloques de Python y R, rehízo las cuentas, las tablas de
verdad, las cinco trazas y las claves de los 19 ejercicios y de las 10 preguntas del
cuestionario: todo cuadra. Lo que comprobé después por mi cuenta: la justificación de
`:6168` y los pasajes de norma sin cita. El informe completo está en el vault
(`Capítulos/Cap 04 - Lectura crítica de línea base (2026-11-16).md`).

## 2. Hallazgos

### H1 · Normas tributarias y financieras presentadas como hechos, sin fuente (medio)
- **Retención por servicios:** 4 % para el declarante, 6 % para el no declarante y base
  mínima de 4 UVT (`:5753-5839`, `:5924-5926`, cuestionario `:6183`). Solo la UVT de
  50 000 se declara redondeada; las tarifas y la base se dan por ciertas.
- **UVT:** «el valor vigente lo publica la DIAN cada año… cambia todos los eneros»
  (`:5934-5938`).
- **Mora:** «en Colombia, el cobro por mora está topado por la tasa de usura y se liquida
  sobre lo vencido» (`:4146`).
- **Fraccionamiento:** «es exactamente lo que la norma llama fraccionamiento de pagos y
  lo que la base mínima existe para detectar» (`:5993-5994`). No se nombra la norma y se
  le atribuye un propósito.

**Nadie ha leído estas normas todavía.** Se resuelve leyéndolas en su fuente oficial
(fase 1), no de memoria.

### H2 · Casos y cifras inventados que no se declaran (medio)
La cartera de 40 millones y las cinco reglas de la portada; «doscientos créditos
después»; «catorce meses»; «cuatrocientas transacciones»; «mil solicitudes, 8 % y 12 %»;
«doce tramos»; «ocho años»; el puntaje de 550, el endeudamiento del 60 % y las tarifas
del 0,2 % y el 0,5 %. `:4837-4840` llama «una política real del banco» a una política
inventada.

### H3 · Una justificación del cuestionario es falsa en VBA (medio)
`:6168`: «Invertir los operandos empeora las cosas, porque entonces la división se evalúa
seguro». En VBA `And` evalúa siempre los dos lados —lo dice el propio capítulo en
`:3946`—, así que invertir no cambia nada. La clave (dos `If` anidados) es correcta; la
razón dada para descartar el distractor, no.

### H4 · Tres preguntas donde dos opciones aciertan la cifra (medio)
- Retención (`:6183-6190`): «Nada: no llega a la base» y «Nada, pero porque no es
  declarante». La pregunta es solo «¿cuánto se le retiene?».
- Recargo (`:6116-6123`): dos opciones dan 2 700 000.
- `switch` (`:6172-6179`): descarta los tramos de monto, pero el capítulo menciona
  `findInterval()` en `:5462`, con el que sí se pueden escribir.

### H5 · La misma política de cinco reglas, contada de tres maneras (medio)
«Cuatro de las cinco no llegaron a mirarse nunca» (portada, `:3591`); «tres de ellas no
llegan a evaluársele» (`:5142`); «cuatro de ellas ni se evaluaron» (`:5898`); «las tres
condiciones que quedaban» (`:5202`). La quinta regla es el caso por defecto, no una
condición.

### H6 · La «tarifa plena» tiene tres definiciones (medio)
Es para «transacciones de más de un millón» (`:4395-4397`), pero el `Sino` del bloque la
cobra a todo cliente no preferencial, sin mirar el monto. El cliente de 800 000 al que
los dos `Si` le cobran 0 es «un fallo» (`:4497`) con «datos perfectamente normales»
(`:4498`), y a la vez «para casi todos los clientes daba igual» (`:4398`).

### H7 · El caso por defecto de los tramos cobra la tarifa más alta a lo inválido (medio)
En `EJ_SEGUN_RANGOS` (`:5420-5456`) un monto negativo, cero o con centavos entre dos
tramos cae en el caso por defecto y paga 25 000. Comprobado en Python con 100 000,5. La
nota solo menciona los centavos. La versión en cascada del comparador cobra 2 500 a un
negativo: un tercer comportamiento que el capítulo no discute, justo en la sección que
dice que «el caso por defecto no es opcional».

### H8 · El reto de la retención afirma algo que depende de un supuesto (medio)
«Los tres pagos de 150 000 pasan a retener» (`:5995-5996`) solo es cierto si el acumulado
se mira al cierre del mes; pago a pago, el primero sigue sin retención. Y en la traza que
cita, ese pago queda bajo la base: no «le habría correspondido el 4 %».

### H9 · Afirmaciones sobre otros capítulos y sobre la historia (medio)
«Es de los pocos puntos del curso donde la estructura que conviene depende de en qué se
va a escribir» (`:5721`) habla de capítulos que no existen todavía. «Es el primero donde
esas diferencias deciden el resultado» (`:3660`) contradice al capítulo 3 ya publicado,
donde `^` da otro resultado en Python y `2 ^ 3 ^ 2` da 64 en VBA. De Morgan con sus
fechas (`:3875`) y «lo hereda de la familia BASIC» (`:5645`) van sin fuente.

### H10 · Absolutos y opiniones sin marcar (medio)
«La forma de conseguir el mismo efecto en VBA es anidar dos `Si`»; «una sola forma y no
admite variantes»; «el caso por defecto se escribe siempre»; «el orden de las ramas no
es negociable»; «el defecto más caro de esta estructura»; «la mayoría de los casos
dudosos»; «de las pocas cosas que VBA hace mejor».

Los 24 bajos (el lema de la portada, «cambie el 30 por un 31» con dos treintas, «una
fila por cada línea del programa», la traza de VBA que marca «—» donde `Dim` deja 0, los
flujogramas que leen lo que el código asigna, términos sin definir como «declarante» u
«originación», formato numérico desigual, `cat(decision, "\n")` que deja un espacio
antes del salto) están en la nota del vault y se corrigen en la fase de su sección.

**Sin comprobar por nadie:** las salidas de VBA —en particular que 0 entre 0 dé el error
6 y un divisor cero el 11—, que se ejecutan en Excel en la fase 10.

## 3. Decisiones que necesito del docente antes de empezar

| # | Decisión | Opciones | Recomendación |
|---|---|---|---|
| A | **La retención por servicios** (4 %, 6 %, base de 4 UVT) | (1) Leo la norma en su fuente oficial y el caso se ajusta a lo que diga, con cita; lo que no se pueda verificar se declara ilustrativo. (2) Todo el caso se declara inventado, sin citar ninguna norma. | (1). Es el caso central de la sección 6 y son cifras que el estudiante va a repetir. |
| B | **La UVT** | (1) Se conserva el 50 000 redondeado y declarado, y se cita la norma que define la UVT y dice quién la fija. (2) Se usa el valor real de un año, con cita y fecha. | (1). Un valor real envejece cada enero y obliga a rehacer todas las cuentas. |
| C | **La mora y la tasa de usura** (`:4146`) | (1) Se lee la norma y la frase queda con cita y con el alcance que la norma tenga. (2) Se quita la frase y el 5 % queda solo como caso inventado. | (1) si la fuente oficial se deja leer; si no, (2). |
| D | **«Lo que la norma llama fraccionamiento de pagos»** | (1) Busco la norma: si existe y dice eso, se cita; si no, la frase pasa a criterio del docente sin atribuirla a ninguna norma. (2) Se quita. | (1). |
| E | **Los casos del banco** (portada, cartera, política de cinco reglas, tarifas) | (1) Se declaran inventados con `<Ilustrativo>` en cada sección y se unifican sus conteos (H5). (2) Usted aporta un caso real documentado. | (1), como en los capítulos 2 y 3. |
| F | **La tarifa plena** (H6) | (1) Una sola regla: plena para todo cliente no preferencial, como ya hace el código; se reescribe la anécdota. (2) Plena solo sobre un millón: cambia el código en los cuatro lenguajes, sus salidas y la traza. | (1). No toca código ni salidas. |
| G | **El caso por defecto de los tramos** (H7) | (1) El bloque se cambia para que el caso por defecto informe «monto inválido» y el último tramo quede explícito; se vuelven a ejecutar los cuatro lenguajes. (2) El código se deja y el texto advierte lo que pasa con negativos y centavos. | (1). La sección enseña que el caso por defecto importa; su propio ejemplo debería hacerlo bien. |
| H | **Banco Moodle del capítulo 4** | (1) Al final reviso las cinco preguntas y dejo borradores en el vault, sin copiar al banco. (2) No se revisan ahora. | (1). |
| I | **Prueba en el teléfono y publicación** | (1) Una sola fusión al cerrar el capítulo; antes de subir, dejo el servidor local encendido y usted lo recorre con el dedo en el iPhone. (2) Una sola fusión y solo la sonda. | (1). La ventana reflejada no deja desplazar la página: la prueba automática del capítulo 3 quedó a medias. |

## 4. Fases

Cada fase va en su rama, una sobre otra, y termina en un punto de control: informe,
verificador y sonda en verde, y espera de su visto bueno. Las frases citadas pasan por un
verificador sin contexto antes de registrar la nota, con la oración anterior y la
posterior.

### Fase 1 — Línea base y fuentes
- Vault: una nota por afirmación del capítulo (clase y estado), por figura, por concepto
  y por hilo narrativo. La nota del capítulo recibe los 36 hallazgos.
- Buscar y leer, en sus páginas oficiales, las normas de A, B, C y D. Preparar la tanda
  de importación a Zotero de lo que falte; **la importación espera su aprobación**.
- Entregable: cuántas afirmaciones hay, de qué clase y con qué fuente cuenta cada una; y
  qué dicen las normas sobre la retención por servicios, la UVT, la mora y el
  fraccionamiento.

### Fase 2 — Sección 1, La condición
La remisión a la tabla de precedencia del capítulo 3; De Morgan y sus fechas; lo que
VBA hace con `And` y `Or` y «la forma de conseguir el mismo efecto»; el ejercicio que
dice «es el caso de la portada» y trata otro mecanismo; «muy endeudado».

### Fase 3 — Sección 2, Si…Entonces
La mora según C; «cambie el 30 por un 31»; «una fila por cada línea del programa»; la
traza de VBA y el 0 de `Dim`; `Range("B2")` sin explicar.

### Fase 4 — Sección 3, Si…Sino
La tarifa plena según F; el flujograma que lee lo que el código asigna; las cuatrocientas
transacciones según E.

### Fase 5 — Sección 4, La cascada
Los conteos de reglas evaluadas (H5); «una política real del banco»; `cat(decision,
"\n")`; el comentario de las 36 456 combinaciones.

### Fase 6 — Sección 5, Segun
El caso por defecto de los tramos según G; la definición de selectiva múltiple frente a
lo que la sección enseña; «doce líneas legibles»; BASIC y «lo que VBA hace mejor»; la
remisión al capítulo 6.

### Fase 7 — Sección 6, El oficio
La retención por servicios según A y la UVT según B; el borde de los 200 000, que el
código define y el texto no; el reto del fraccionamiento según D y H8; los términos sin
definir.

### Fase 8 — Portada, evaluación, glosario y cierre
«Referencias» generada; la portada según E y su lema; las cuatro preguntas del
cuestionario de H3 y H4; el glosario; «Lo que viene» frente al capítulo 5.

### Fase 9 — Figuras y LP-CORE
Las trece figuras y tablas sin fuente. Si alguna corrección pide tocar la librería, va
aquí: se estampa en los cinco capítulos y se prueba en cada uno.

### Fase 10 — Coherencia con los demás capítulos, banco, VBA y teléfono
Lo que los capítulos 1, 3 y 5 dicen del 4, y lo que el 4 dice de ellos y del syllabus,
cotejado en los dos sentidos y registrado como remisión. Las cinco preguntas del banco
según H. Las salidas de VBA ejecutadas en Excel, con los errores 6 y 11. La prueba en el
iPhone según I.

### Fase 11 — Lectura crítica final y cierre
Un lector sin contexto lee el capítulo entero y un verificador lee todas las citas contra
sus pasajes. Se corrige lo que salga. Bitácora, vault, y fusión con su aprobación.

## 5. Criterios de aceptación del capítulo

1. Toda afirmación fáctica cae en una de las seis clases; ninguna queda sin clasificar,
   ni como `citada` sin fuente.
2. Toda cita tiene su nota en el vault con el pasaje completo y literal, y su fila en
   `afirmaciones/04.yaml`.
3. `verificar.py --con-salidas --con-pandoc` pasa, y el capítulo 4 queda sin avisos.
4. Las salidas de los cuatro lenguajes están ejecutadas; las de VBA, en Excel.
5. Ningún ejercicio califica mal una respuesta correcta, y ninguna pregunta tiene dos
   opciones que respondan lo que se pregunta.
6. Los casos inventados están declarados y ninguno contradice su propia cuenta.
7. Lo que se dice de un lenguaje es cierto en ese lenguaje, y lo que se dice de los
   cuatro, en los cuatro.
8. Las remisiones entre capítulos son ciertas en los dos sentidos.
9. La lectura crítica final no deja hallazgos altos, y los medios quedan corregidos o
   anotados con su razón.
10. Sonda de navegador en verde a 320 px, a 375 px y en escritorio; y el capítulo visto
    en el iPhone antes de publicar.

## 6. Riesgos

- **La norma no dice lo que el capítulo le atribuye** (tarifas, base mínima, usura,
  fraccionamiento). Es lo que A, C y D ya prevén: el caso se ajusta o la frase se quita.
- **Una tarifa cambió o depende de condiciones que el caso no declara.** Se declaran como
  supuestos, como se hizo con la retención del 2,5 % en el capítulo 3.
- **Cambiar el bloque de los tramos (G) rompe un ejercicio o una pregunta del banco.**
  Los cuatro bloques se vuelven a ejecutar y sus ejercicios se revisan en la misma fase;
  la pregunta `segun_sin_defecto` del banco se mira en la fase 10.
- **Una corrección mueve algo que el capítulo 5 repite** (el ajuste del último abono, la
  negación de una condición compuesta). Se revisa en la fase 10 antes de fusionar, y ese
  capítulo se toca en la misma rama si hace falta.
- **VBA no da los errores que el capítulo dice.** Se sabrá en Excel en la fase 10; si
  difiere, se corrige el texto y el cuestionario.

## 7. Qué queda fuera

- Rediseñar el capítulo o cambiar el número de secciones.
- Copiar al banco Moodle.
- El capítulo 5, salvo las frases que una corrección de este obligue a tocar.
