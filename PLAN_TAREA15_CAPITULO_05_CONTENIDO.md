# Plan · Tarea 15 — Mejora de contenido del capítulo 5

**Fecha:** 2026-11-19. **Estado:** aprobado por el docente el 2026-11-19 con la opción
recomendada en las ocho decisiones (§3).

**Archivo:** `Material html/05_LPF_Control_Repetitivo.html` (8 182 líneas en `main`,
commit `f674118`; el contenido del capítulo va de la 2 739 a la 7 968). Todos los números
de línea de este plan son de ese commit.

**Modelo:** `PLAN_TAREA14_CAPITULO_04_CONTENIDO.md`. Igual que allí, la lectura crítica
independiente se hizo **antes** de planear (es la línea base de §2) y se repite **antes**
de la fusión.

---

## 0. Qué se decidió antes de planificar

Esta tarea no adapta el formato del capítulo —eso fue la Tarea 10—, sino su contenido: de
dónde sale lo que afirma, si es cierto, si no se contradice y si cumple lo que los
capítulos 1 a 4 dan por hecho.

No se reabren: Zotero como autoridad, APA 7 generado, solo se cita lo leído, las seis
clases de afirmación, los cuatro lenguajes en paralelo con el pseudocódigo como
normativo, y los ejercicios de interpretación E1–E8.

Restricciones que salen de medir:

- **La numeración de las siete secciones no cambia.** Los capítulos 2, 3 y 4 remiten al 5
  seis veces (dos, tres y una), y el banco y el cuestionario de Moodle del capítulo
  están organizados por ellas.
- **El capítulo 5 remite 39 veces a los cuatro anteriores** (trece al 4, doce al 1, diez
  al 2 y cuatro al 3), ya revisados. Se cotejan contra los capítulos publicados hoy, no
  contra los de antes: una de esas remisiones ya está rota (H1).
- **Promete cosas a tres capítulos que no existen:** al 6 (F8 y la ventana Locales, por
  qué `Dim` deja 0, por qué `Currency`), al 7 (los arreglos) y al 8 (la cuota como
  función, en la prosa y en cuatro comentarios de código). Se registran como promesas
  para cuando se escriban.
- **Los cambios de LP-CORE se propagan a los cinco capítulos.** Este plan solo los toca
  en la fase 10, y lo dice.
- **El capítulo tiene un cuestionario vivo en Moodle**, con ocho ranuras por categoría, y
  ocho preguntas en `Banco Moodle/rmd/cap05`. Nada del banco se copia ni se reimporta
  sin orden expresa del docente.
- Es el capítulo más largo y el que más código trae: 16 bloques en cuatro lenguajes, dos
  detectores de error, cuatro tablas de traza y varios simuladores. Las cuentas se
  rehacen ejecutando, no leyendo.

## 1. Estado medido

| Qué | Cuánto | Cómo está |
|---|---|---|
| Citas en el cuerpo del capítulo | 0 | el capítulo 4 quedó con 15 |
| «Referencias», `<Fuente>`, `<Ilustrativo>` | 0 | no hay ninguno; un recuadro declara ilustrativas dos tasas de siete |
| Figuras y tablas sin fuente (regla 30) | 23 | 1 gráfica, 5 figuras y 17 tablas |
| Entidad o norma sin cita (regla 32) | 2 avisos | «Superintendencia Financiera» y «tasa de usura», los dos en `:4336` |
| Una fuente citada por enlace, fuera de Zotero | 1 | la página de `For...Next` de Microsoft Learn (`:5733-5735`) |
| Ejercicios con tipo E1–E8 | 19 | cumple la cuota |
| Salidas declaradas de Python y R | 22 de 22 coinciden | ejecutadas por el lector independiente |
| Salidas declaradas de VBA | parte sin ejecutar | las del 2026-10-27 se ejecutaron en Excel; las añadidas después (la cuota 37, los dos simuladores y la sección 7) llevan un comentario que dice que no |
| Tablas de traza con `exigeRespuesta` | 3 de 4 | falta mirar si la cuarta debe llevarlo |
| Notas del vault para el capítulo | 0 afirmaciones | `Cap 05 Control repetitivo.md` dice `estado_contenido: sin-auditar` |
| Registro `afirmaciones/05.yaml` | no existe | se crea con la primera cita |
| Sonda de navegador | pasa | a 320 px, 9 de 9 lecciones |

Lectura crítica independiente (sin contexto, 2026-11-19): **ningún hallazgo alto, 7
medios y 9 bajos.** Ejecutó los 22 bloques de Python y R, rehízo las cuentas del texto,
las trazas, las claves de los 19 ejercicios y las 10 preguntas del cuestionario —entre
ellas las doce filas del plan de pagos, los residuos de la tabla de seis créditos y la
TIR de 1,9924 % en 17 vueltas—, y cotejó 31 remisiones: todo cuadra salvo lo que sigue.
Lo que comprobé después por mi cuenta: H1, H2, H3 y H4, con sus líneas, y la cuenta del
crédito de 20 millones. El informe completo va al vault
(`Capítulos/Cap 05 - Lectura crítica de línea base (2026-11-19).md`).

## 2. Hallazgos

### H1 · Cita entre comillas una frase del capítulo 1 que ya no existe (medio)
`:5762-5763`: «El capítulo 1 ya advirtió, con la meta de ahorro, que el signo de la
condición produce "los errores de un mes de diferencia en las proyecciones"». La mejora
del capítulo 1 reescribió esa frase; hoy dice «…que en una proyección es un mes». Es la
única de las 31 remisiones cotejadas que falla; otra (`:6682`, la regla de la igualdad
exacta) ensancha lo que el capítulo 1 dice.

### H2 · El trazador contradice lo que el capítulo enseña del `for` (medio)
`:6150`: «En pseudocódigo, Python y R, quien aumenta k es la cabecera del Para». El propio
capítulo dice en `:5691-5694` que en Python y en R el `for` «no compara ni suma nada:
recorre una secuencia ya hecha», y lo repite en la evaluación.

### H3 · La usura y la Superintendencia, sin fuente (medio)
`:4335-4337`: «En Colombia, la Superintendencia Financiera certifica la tasa de usura, el
tope legal del interés de un crédito». **Nadie ha leído la norma.** El capítulo 4 ya
citó el artículo 884 del Código de Comercio, que habla del interés bancario corriente y
de un certificado de la Superintendencia Bancaria; no dice «usura» ni «tope legal».

### H4 · «Lo que hace un banco de verdad», sin fuente y en tensión con la sección 6 (medio)
`:5643-5646`: «Un banco redondea la cuota al peso —aquí serían 916 800— y ajusta la
última para que el saldo cierre en cero». Es una afirmación sobre la práctica bancaria
sin respaldo. Además, la sección 6 enseña que el crédito de 20 millones cobra una cuota
37 por un residuo de punto flotante; con la cuota redondeada al peso (759 677) el saldo
queda en −18,17 tras la cuota 36 y esa vuelta no existe. El capítulo no dice que el
redondeo que atribuye a los bancos desactiva su propio caso.

### H5 · Casos y tasas inventados que no se declaran (medio)
Nueve motivaciones se narran como hechos (`:3720`, `:4250`, `:4638`, `:4940`, `:5586`,
`:6303`, `:6831`, `:7534`, `:7786`): la pareja y su crédito de vivienda, el extracto que
informó 34 053, el banco que «dejó de recaudar la cuota doce», las «cuarenta rutinas
nocturnas». El recuadro de `:4331` declara ilustrativas dos tasas (0,9 % y 2 %) y deja
fuera las otras cinco, entre ellas el 1,5 % del hilo principal.

### H6 · Hechos de VBA sin cita, y una paráfrasis que dice más que su fuente (medio)
- La página de `For...Next` va por enlace suelto, no está en Zotero y el capítulo dice
  que «desaconseja» cambiar el contador; lo que trae es una sugerencia de que hacerlo
  puede dificultar leer y depurar el código.
- Sin cita ni ejecución declarada: que `Dim` deja la variable en 0 (`:4694`, `:7842`), el
  error 6 de `Integer` (`:6696`), los cuatro decimales de `Currency` (`:5231`) y que
  `While…Wend` es «más antigua» (`:4682`).
- El 0 de `Dim` ya se ejecutó en Excel para el capítulo 4 y la especificación del
  lenguaje ya está en Zotero: parte de esto se resuelve sin importar nada.

### H7 · Salidas de VBA declaradas sin ejecutar, y lo que se dice de «los cuatro» (medio)
La cuota 37 en VBA (`:6571-6576`) es la más frágil: el propio capítulo dice que el signo
del residuo depende del último bit, y su comentario admite que nadie la corrió en Excel.
Tampoco se ejecutaron el simulador bien y mal escrito (`:5939`, `:6037`) ni los tres
bloques de la sección 7. «VBA guarda el mismo residuo» (`:5641`) y la tabla de los seis
créditos, presentada como «el mismo programa» (`:6939`), se midieron solo en Python, R y
JavaScript.

Los nueve bajos (la salvedad n ≥ 1 de `range(1, n)`, una definición de contador que
también describe al acumulador, dos absolutos sin marcar, una pista incompleta, un conteo
del trazador que no cuadra con la pestaña de VBA, formato numérico desigual entre los
interactivos y la prosa, «paz y salvo» sin definir) están en la nota del vault y se
corrigen en la fase de su sección.

**Sin comprobar por nadie:** las salidas de VBA de H7; las normas de H3; los interactivos
en el navegador, cuya aritmética sí se comprobó aparte.

## 3. Decisiones que necesito del docente antes de empezar

| # | Decisión | Opciones | Recomendación |
|---|---|---|---|
| A | **La usura y la Superintendencia** (H3) | (1) Leo en su fuente oficial la norma que define la usura y la que encarga la certificación, y la frase queda con cita y con el alcance que tengan. (2) Se quita la frase y el recuadro solo declara las tasas como inventadas. | (1) si la fuente oficial se deja leer; si no, (2). |
| B | **«Lo que hace un banco de verdad»** (H4) | (1) Pasa a ser una forma de cerrar el saldo en cero, dicha como criterio del curso y sin atribuirla a los bancos, y el recuadro dice que con la cuota redondeada la cuota 37 de la sección 6 no aparece. (2) Busco una fuente que documente la práctica; si no la hay, (1). | (1). La práctica varía por entidad y el capítulo no la necesita como hecho. |
| C | **Los casos y las tasas** (H5) | (1) Se declaran inventados con `<Ilustrativo>` en cada sección, y el recuadro de tasas las nombra todas. (2) Usted aporta casos reales documentados. | (1), como en los capítulos 2 a 4. |
| D | **Los hechos de VBA** (H6) | (1) Cada uno queda citado con la documentación de Microsoft leída o ejecutado en Excel; la página de `For...Next` entra a Zotero (**la importación espera su aprobación**) y «desaconseja» se ajusta a lo que dice. (2) Solo se ejecutan en Excel, sin citas nuevas, y el enlace suelto se quita. | (1). |
| E | **La cuota 37 en VBA** (H7) | (1) Se ejecuta en Excel en la fase 11: si da 37, queda como está, con fecha; si no, el texto dice qué hace cada lenguaje. (2) Se ejecuta ya, en la fase 1, porque de ella depende cómo se reescribe la sección 6. | (2). Es el caso central de la sección y conviene saberlo antes de tocarla. |
| F | **Banco Moodle del capítulo 5** | (1) Al final reviso las ocho preguntas contra el capítulo corregido y dejo borradores en el vault, sin copiar al banco ni tocar el cuestionario de Moodle. (2) No se revisan ahora. | (1). |
| G | **Prueba en el teléfono y publicación** | (1) Una sola fusión al cerrar el capítulo; antes de subir, dejo el servidor local encendido y usted lo recorre en el iPhone. (2) Una sola fusión y solo la sonda. | (1). |
| H | **El orden de las fases** | (1) Sección por sección, de la 1 a la 7, doce fases. (2) Se juntan las secciones cortas (2 con 3, y 5 con 7) y quedan diez fases. | (1). El capítulo es el más largo; fases pequeñas se revisan mejor. |

## 4. Fases

Cada fase va en su rama, una sobre otra, y termina en un punto de control: informe,
verificador y sonda en verde, y espera de su visto bueno. Las frases citadas pasan por un
verificador sin contexto antes de registrar la nota, con la oración anterior y la
posterior; si sale «parcial», se adopta su redacción.

### Fase 1 — Línea base y fuentes
- Vault: una nota por afirmación del capítulo (clase y estado), por figura, por concepto
  y por hilo narrativo. La nota del capítulo recibe los 16 hallazgos.
- Buscar y leer, en sus páginas oficiales, las normas de A y la documentación de D.
  Preparar la tanda de importación a Zotero de lo que falte; **la importación espera su
  aprobación**.
- Según E, ejecutar en Excel la cuota 37.
- Entregable: cuántas afirmaciones hay, de qué clase y con qué fuente cuenta cada una; qué
  dicen las normas sobre la usura y su certificación; y qué da Excel con la cuota 37.

### Fase 2 — Sección 1, Contar y acumular
La definición de contador frente al acumulador; el caso de la pareja según C; lo que el
syllabus dice de la sección, ya cotejado.

### Fase 3 — Sección 2, Mientras
El extracto de 34 053 según C; el recuadro de tasas completo y la usura según A; la
pista de «dos líneas»; `Dim` y `While…Wend` según D.

### Fase 4 — Sección 3, Repita…Hasta
El caso de cobranza según C; lo que es de un solo lenguaje.

### Fase 5 — Sección 4, Para
El recuadro del banco según B; `range(1, n)` y su salvedad; la remisión rota al capítulo 1
(H1); la página de `For...Next` según D; el −0.00 y lo que VBA guarda; `Currency`.

### Fase 6 — Sección 5, Ciclos anidados
La nota del trazador (H2); el conteo que no cuadra con la pestaña de VBA; la promesa al
capítulo 7.

### Fase 7 — Sección 6, Cuándo para
La cuota 37 según E y B; la tabla de los seis créditos y en qué lenguajes se midió;
`Integer` y el error 6; la paráfrasis de la igualdad exacta del capítulo 1; los absolutos.

### Fase 8 — Sección 7, Casos financieros
Los tres bloques sin ejecutar en VBA; la TIR y la bisección, con sus cuentas rehechas;
el caso de la comisión según C.

### Fase 9 — Portada, evaluación, glosario y cierre
«Referencias» generada; la portada y el caso de auditoría según C; el cuestionario y el
emparejamiento; el glosario («paz y salvo»); «Lo que viene» y las promesas a los
capítulos 6, 7 y 8, registradas.

### Fase 10 — Figuras y LP-CORE
Las 23 figuras y tablas sin fuente. Si alguna corrección pide tocar la librería, va
aquí: se estampa en los cinco capítulos y se prueba en cada uno.

### Fase 11 — Coherencia con los demás capítulos, banco, VBA y teléfono
Lo que los capítulos 2, 3 y 4 dicen del 5, y lo que el 5 dice de ellos y del syllabus,
cotejado en los dos sentidos y registrado como remisión. Las ocho preguntas del banco
según F. Todas las salidas de VBA ejecutadas en Excel. La prueba en el iPhone según G.

### Fase 12 — Lectura crítica final y cierre
Un lector sin contexto lee el capítulo entero y un verificador lee todas las citas contra
sus pasajes. Se corrige lo que salga. Bitácora, vault, y fusión con su aprobación.

## 5. Criterios de aceptación del capítulo

1. Toda afirmación fáctica cae en una de las seis clases; ninguna queda sin clasificar,
   ni como `citada` sin fuente.
2. Toda cita tiene su nota en el vault con el pasaje completo y literal, y su fila en
   `afirmaciones/05.yaml`.
3. `verificar.py --con-salidas --con-pandoc` pasa, y el capítulo 5 queda sin avisos.
4. Las salidas de los cuatro lenguajes están ejecutadas; las de VBA, en Excel.
5. Ningún ejercicio califica mal una respuesta correcta, y ninguna pregunta tiene dos
   opciones que respondan lo que se pregunta.
6. Los casos inventados están declarados y ninguno contradice su propia cuenta.
7. Lo que se dice de un lenguaje es cierto en ese lenguaje, y lo que se dice de los
   cuatro, en los cuatro.
8. Las remisiones entre capítulos son ciertas en los dos sentidos, y las promesas a los
   capítulos 6, 7 y 8 quedan registradas.
9. La lectura crítica final no deja hallazgos altos, y los medios quedan corregidos o
   anotados con su razón.
10. Sonda de navegador en verde a 320 px, a 375 px y en escritorio; y el capítulo visto
    en el iPhone antes de publicar.

## 6. Riesgos

- **Excel no da la cuota 37.** Es lo que E prevé: la sección 6 dice entonces qué hace cada
  lenguaje, y la pregunta del banco `ciclo_infinito` o la que dependa de ello se mira en
  la fase 11.
- **La norma no dice lo que el capítulo le atribuye sobre la usura.** La frase se ajusta
  o se quita, como con la mora en el capítulo 4.
- **Una corrección mueve algo que el cuestionario de Moodle ya pregunta.** El banco y el
  cuestionario no se tocan en esta tarea; la diferencia queda anotada en los borradores.
- **Declarar los casos como inventados obliga a tocar LP-CORE** (si `<Ilustrativo>` no
  cabe donde va una motivación). Se sabrá en la fase 2; si pasa, el cambio va a la fase
  10 y se dice.
- **Una corrección mueve una cifra que el capítulo 3 comparte** (el 19,56 % y el 26,71 %
  salen de su conversión de tasas). Se revisa en la fase 11 antes de fusionar.

## 7. Qué queda fuera

- Rediseñar el capítulo o cambiar el número de secciones.
- Copiar al banco Moodle o tocar el cuestionario del capítulo en Moodle.
- Escribir los capítulos 6, 7 y 8: sus promesas solo se registran.
