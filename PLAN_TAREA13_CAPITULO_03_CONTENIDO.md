# Plan · Tarea 13 — Mejora de contenido del capítulo 3

**Fecha:** 2026-11-16. **Estado:** propuesto; espera la aprobación del docente y sus
decisiones A–J (§3). No se ha tocado el capítulo.

**Archivo:** `Material html/03_LPF_Control_Secuencial.html` (5 434 líneas en `main`,
commit `54e423d`; el contenido del capítulo va de la 2 752 a la 5 200). Todos los
números de línea de este plan son de ese commit.

**Modelo:** `PLAN_TAREA12_CAPITULO_02_CONTENIDO.md`. Igual que allí, la lectura crítica
independiente se hizo **antes** de planear (es la línea base de §2) y se repite **antes**
de la fusión.

---

## 0. Qué se decidió antes de planificar

Esta tarea no adapta el formato del capítulo —eso fue la Tarea 6—, sino su contenido: de
dónde sale lo que afirma, si es cierto, si no se contradice y si cumple lo que los
capítulos 4 y 5 dan por hecho.

No se reabren: Zotero como autoridad, APA 7 generado, solo se cita lo leído, las seis
clases de afirmación, los cuatro lenguajes en paralelo con el pseudocódigo como
normativo, y los ejercicios de interpretación E1–E8 (`CLAUDE.md`,
`Material html/_fuentes/POLITICA_DE_FUENTES.md`).

Restricciones que salen de medir:

- **La numeración de las cinco secciones no cambia.** Los capítulos 4 y 5 remiten al 3
  más de una docena de veces: la tabla de precedencia y su quinta fila «al capítulo 4»,
  el acumulador «con el que el capítulo 5 construirá tablas de 240 filas», la tasa
  efectiva anual y la comparación de dos ofertas de la sección 5.
- **Las cifras que otros capítulos repiten no se mueven sin tocarlos a ellos:** el
  19,56 % y el 26,71 % del capítulo 5 salen de la conversión de tasas de este.
- **Los cambios de LP-CORE se propagan a los cinco capítulos.** Este plan solo los toca
  en la fase 8, y lo dice.
- El banco Moodle tiene ocho preguntas del capítulo (`Banco Moodle/rmd/cap03`), en un
  repositorio privado aparte. El docente decidió el 2026-11-15 no copiar nada al banco
  por ahora.
- El capítulo 2 también usa un descuento por pronto pago sobre una factura, sin IVA. Lo
  que se decida aquí sobre ese descuento (decisión A) no puede contradecirlo.

## 1. Estado medido

| Qué | Cuánto | Cómo está |
|---|---|---|
| Citas en el cuerpo del capítulo | 0 | el capítulo 1 tiene 54 y el 2, 10 |
| «Referencias», `<Fuente>`, `<Ilustrativo>` | 0 | no hay ninguno |
| Figuras y tablas sin fuente (regla 30) | 7 | 1 figura y 6 tablas |
| Entidad o norma sin cita (regla 32) | 0 avisos | el verificador no ve «la regulación colombiana obliga» (`:4897`, `:4970`), ni el IVA, la retención o los aportes |
| Ejercicios con tipo E1–E8 | 18 | cumple la cuota |
| Salidas declaradas de Python y R | 22 de 22 coinciden | ejecutadas por el lector independiente; las de VBA, sin ejecutar |
| Trazas que aprueban en blanco | 4 de 4 | ninguna lleva `exigeRespuesta` |
| Notas del vault para el capítulo | 0 afirmaciones | `Cap 03 Control secuencial.md` dice `estado_contenido: sin-auditar` |
| Normas tributarias o financieras en Zotero | 0 | hay 37 referencias; ninguna sirve a las cifras legales del capítulo |
| Sonda de navegador | pasa | a 320, a 375 y en escritorio, con recarga en cada lección |

Lectura crítica independiente (Opus, sin contexto, 2026-11-16): **4 hallazgos altos, 19
medios y 15 bajos.** Ejecutó todos los bloques de Python y R y rehízo las cuentas. Los
cuatro altos los comprobé después por mi cuenta, salvo lo que es de norma tributaria,
que nadie ha leído todavía.

## 2. Hallazgos

### H1 · La potencia que en Python no es potencia (alto)
El aviso de `:3570-3572` dice que `2 ^ 3 ^ 2` «vale 512 en pseudocódigo, Python y R». En
Python `^` es otra operación y da **3**, sin ningún error; la potencia de Python es `**`,
y `2 ** 3 ** 2` sí da 512. La tabla de precedencia (`:3561`) pone «`^` · `**`» sin decir
qué lenguaje usa cuál. Es el fallo silencioso que el capítulo enseña a temer, escrito en
el propio aviso.

### H2 · Lo que se dice del depurador es falso, y el cuestionario lo premia (alto)
«Es la única herramienta que sirve cuando el programa no falla» (`:4105-4108`). Un
depurador se detiene donde se le diga y deja ver las variables paso a paso, falle o no el
programa. El cuestionario marca como **correcta** la opción «cuando un depurador no tiene
dónde detenerse» (`:5149`): castiga a quien la descarta con razón.

### H3 · Los 590 000 pesos del ejercicio de las dos ofertas (alto)
La clave de `:4866` dice que la oferta A ahorra «unos 590 000 pesos» en un año sobre
20 000 000, «el equivalente a casi media cuota». La cifra (2,95 puntos × 20 000 000 =
590 425) solo vale si todo el capital se debe el año entero y se paga de una vez. En doce
cuotas la diferencia de intereses es de 277 829. Y con cualquiera de las dos lecturas,
590 000 es el 32 % de una cuota de 1 868 040, no «casi media». La clave no dice qué
supone.

### H4 · El caso central de la sección 1 puede enseñar una regla tributaria que no es (alto, sin verificar)
El capítulo dice en cinco sitios que el IVA se calcula sobre el valor de la factura menos
el **descuento por pronto pago**, y lo llama «regla del negocio» (`:3089-3093`, `:3065`,
`:3145`, `:4966`). El lector señala que el Estatuto Tributario trata distinto los
descuentos condicionados, y que el pronto pago es el ejemplo típico de descuento
condicionado. **Nadie ha leído la norma todavía**: esto se resuelve leyéndola en su
fuente oficial (fase 1), no de memoria. Si se confirma, el caso se cambia a un descuento
que sí reduzca la base, o se declara inventado sin afirmar ninguna regla.

### H5 · Ni una fuente, y cifras legales presentadas como hechos
IVA del 19 %; retención del 2,5 % «nunca sobre el total con IVA» (`:4312`); retención del
7 % en un CDT (`:4347`); 4 % de salud y 4 % de pensión (`:4799-4801`); el ingreso base de
cotización y la EPS (`:4814-4816`); «la regulación colombiana obliga a informar» la tasa
efectiva anual (`:4897`, `:4970`). Ninguna lleva fuente. Además, las tasas de mora de los
casos (2,5 % y 2,2 % mensual) equivalen a 34,49 % y 29,84 % efectivo anual, sin que el
texto diga que son inventadas.

### H6 · Anécdotas contadas como hechos, y un hilo que no coincide consigo mismo
La nómina de 1 400 empleados, once segundos y veintiséis reclamos (portada); la analista
que la encontró en once minutos (`:4094-4098`); el recuadro «Lo que pasó de verdad el
viernes» (`:4810`). Ninguna se declara inventada. Y los detalles no cuadran: la sección 4
habla de «una tabla de cuatro columnas» y de «la fila siete»; la traza de la sección 5
tiene seis columnas, seis filas y el error en el paso 3. «Tardó dos días en aparecer»,
de viernes a lunes.

### H7 · Lo que se dice de «los lenguajes» y solo vale para alguno
- Leer una variable sin valor «sin avisar» (`:3113`, `:3731`): Python y R se detienen con
  un error; solo VBA sigue en silencio.
- «Se escribe —, no 0» antes de la primera asignación, y la opción del cuestionario «las
  variables valen cero», marcada falsa (`:5147`): en VBA valen 0. Es una convención del
  método y no lo dice.
- «Intercambiar dos valores no se puede hacer en dos líneas» (`:3370`, glosario,
  cuestionario): Python lo hace en una.
- R imprime con `cat()` en notación científica (`1.3e+07`, `8.5e+07 3.4e+08`) y, sin
  salto de línea, todo pegado. Cuatro ejercicios preguntan «¿qué imprime?» con opciones
  que R no imprime así.
- Dos bloques de VBA declaran salidas con punto decimal que en una configuración regional
  colombiana salen con coma (`:4587`, `:4605`).

### H8 · La regla de dependencia se contradice con los ejemplos del capítulo
«Si la segunda lee lo que la primera escribe, el orden es obligatorio y cambiarlo altera
el resultado» (`:3111-3113`, glosario, pregunta 1 del cuestionario). En la conciliación
del propio capítulo, dos restas sobre `saldo` se pueden intercambiar y el resultado no
cambia: la condición es suficiente, no necesaria. `:4203` dice que esa conciliación
mostró un «orden obligado por el código», y no es así. `:4218` dice que dos líneas «se
pueden escribir en cualquier orden» cuando la regla de `:3111` lo prohíbe.

### H9 · Ejercicios que califican mal o que traen la respuesta encima
- Las cuatro trazas aprueban celdas en blanco (3 de 18, 6 de 20, 9 de 24 y 8 de 24),
  aunque sus enunciados piden escribir la raya.
- El ejercicio de detectar el error del abono (`:4315-4335`) admite dos líneas
  defendibles.
- Cinco frases dan la respuesta antes del ejercicio (`:3067`, `:3321`, `:3599`, `:3877` y
  `:4230`, `:4811`).

### H10 · Cuentas y remisiones internas inexactas
«Un 1,55 % mensual» (`:4761`, `:4875`, clave de `:5161`) es interés simple, justo en la
sección que enseña a componer: el equivalente compuesto es 1,53 %. «Tres asignaciones»
donde hay cinco (`:4756`). «La segunda regla de la traza» remite a otra cosa (`:4789`).
El flujograma usa `tasaIva` sin haberla leído (`:2887-2893`). «57 000 se repiten
idénticos en cada factura» (`:5080`). Productos reales con mecánica simplificada sin
decirlo: un crédito de libre inversión a interés simple pagado al final, un CDT con tasa
mensual simple, un «saldo promedio» de dos datos.

Los quince bajos (redondeos, conteos de operaciones, fragmentos de VBA fuera de un `Sub`,
tildes) están en la nota del capítulo en el vault y se corrigen en la fase de su sección.

## 3. Decisiones que necesito del docente antes de empezar

| # | Decisión | Opciones | Recomendación |
|---|---|---|---|
| A | **El descuento de la factura y el IVA** | (1) Leo la norma en su fuente oficial y el caso se ajusta a lo que diga: si el pronto pago no reduce la base, pasa a ser un descuento comercial concedido en la factura, con las mismas cifras. (2) El caso se declara inventado y se quita toda afirmación sobre cómo se calcula el IVA. | (1). Las cifras (8 000 000, 200 000, 19 %) y el orden de las tres operaciones se conservan; solo cambia el nombre del descuento y entra una cita. |
| B | **Las cifras legales** (IVA, retenciones, salud y pensión, tasa efectiva anual) | (1) Cada una se cita con la norma leída en su página oficial, con fecha de consulta; lo que no se pueda verificar se declara ilustrativo. (2) Todas se declaran ilustrativas, sin citar ninguna norma. | (1). Son las cifras que un estudiante de finanzas va a repetir; con fecha de consulta no envejecen en silencio. |
| C | **La nómina de la portada** | (1) Se declara caso inventado y se hacen coincidir sus detalles con la traza de la sección 5. (2) Usted aporta un caso real documentado. | (1), como el caso de la cuota del capítulo 2. |
| D | **El depurador** | (1) Se reescribe: la traza es el método de este capítulo, y un depurador hace lo mismo paso a paso sobre la máquina; se corrige la clave del cuestionario. (2) Se quita la comparación con el depurador. | (1). El capítulo 6, de VBA, es donde el estudiante verá un depurador; la remisión se anota para entonces. |
| E | **Los 590 000 pesos** | (1) El ejercicio dice su supuesto —un solo pago al cabo del año— y se quita «casi media cuota». (2) Se rehace con doce cuotas: 277 829. | (1). El capítulo no enseña amortización, y la cuenta sigue cabiendo en una línea. |
| F | **Lo que es de un solo lenguaje** | (1) Se dice lenguaje por lenguaje, y los bloques de R formatean su salida para que no salga en notación científica. (2) Se dice lenguaje por lenguaje y las salidas de R se dejan como son, con las opciones de los ejercicios ajustadas. | (1). Cambia código y salidas de R en cuatro bloques, que se vuelven a ejecutar. |
| G | **Los productos simplificados** (crédito a interés simple, CDT con tasa mensual, saldo promedio) | (1) Se declaran casos inventados para practicar, como en el capítulo 2. (2) Se rehacen con la mecánica real de cada producto. | (1). |
| H | **Banco Moodle del capítulo 3** | (1) Al final reviso las ocho preguntas y dejo borradores en el vault, sin copiar al banco. (2) No se revisan ahora. | (1). No contradice su decisión de no copiar. |
| I | **Prueba en el teléfono** | (1) Antes de publicar, el capítulo se prueba en el iPhone por la red local, con el zoom al 100 % y al 125 %. (2) Solo la sonda. | (1). Tres de los defectos de la semana pasada solo se vieron en el aparato. |
| J | **Publicación** | (1) Una sola fusión al cerrar el capítulo. (2) Fase por fase. | (1), con la lectura crítica final antes de fusionar. |

## 4. Fases

Cada fase va en su rama, una sobre otra, y termina en un punto de control: informe,
verificador y sonda en verde, y espera de su visto bueno. Las frases citadas pasan por un
verificador sin contexto antes de registrar la nota.

### Fase 1 — Línea base y fuentes
- Vault: una nota por afirmación del capítulo (clase y estado), por figura, por concepto
  y por hilo narrativo. La nota del capítulo recibe los 38 hallazgos.
- Buscar y leer, en sus páginas oficiales, las normas de A y B. Preparar la tanda de
  importación a Zotero; **la importación espera su aprobación**.
- Entregable: cuántas afirmaciones hay, de qué clase, y con qué fuente cuenta cada una; y
  qué dice la norma sobre el descuento y la base del IVA.

### Fase 2 — Sección 1, La secuencia: el orden importa
El caso de la factura según A; la regla de dependencia (H8); el flujograma y `tasaIva`;
«compila, corre y no advierte nada»; la frase que regala la respuesta.

### Fase 3 — Sección 3, Expresiones y precedencia
La potencia en Python (H1) y la tabla de precedencia; el saldo promedio según G; la
división entera en los cuatro lenguajes; la salida de R según F.

### Fase 4 — Sección 2, Leer, asignar, escribir
El intercambio en Python; la lectura por teclado y por celda como convención del curso;
la variable sin valor, lenguaje por lenguaje; las salidas de R del intercambio.

### Fase 5 — Sección 4, La prueba de escritorio
El depurador según D; las cuatro reglas y lo que es convención del método; la traza de
mora y sus tasas; el ejercicio del abono con dos respuestas; `exigeRespuesta` en las
cuatro trazas; el CDT según G.

### Fase 6 — Sección 5, Casos financieros
La nómina según C, con sus cifras legales según B; el 1,55 %; el ejercicio de las dos
ofertas según E; el crédito a interés simple según G; la tasa efectiva anual y la norma
que la exige; los separadores decimales de VBA.

### Fase 7 — Portada, evaluación, glosario y cierre
«Referencias» generada; la portada según C; el cuestionario integrador con las claves
que cambian (depurador, variables en cero, intercambio, regla de dependencia); la
entrevista; el glosario; «Lo que viene».

### Fase 8 — Figuras y LP-CORE
Las siete figuras y tablas sin fuente. Si alguna corrección pide tocar la librería, va
aquí: se estampa en los cinco capítulos y se prueba en cada uno.

### Fase 9 — Coherencia con los demás capítulos, banco, VBA y teléfono
Lo que los capítulos 1, 2, 4 y 5 dicen del 3, y lo que el 3 dice de ellos, cotejado en
los dos sentidos y registrado como remisión. Las ocho preguntas del banco según H. Las
salidas de VBA ejecutadas en Excel. La prueba en el iPhone según I.

### Fase 10 — Lectura crítica final y cierre
Un lector sin contexto lee el capítulo entero y un verificador lee todas las citas contra
sus pasajes. Se corrige lo que salga. Bitácora, vault, y fusión con su aprobación.

## 5. Criterios de aceptación del capítulo

1. Toda afirmación fáctica cae en una de las seis clases; ninguna queda sin clasificar.
2. Toda cita tiene su nota en el vault con el pasaje completo y literal, y su fila en
   `afirmaciones/03.yaml`.
3. `verificar.py --con-salidas --con-pandoc` pasa, y el capítulo 3 queda sin avisos.
4. Las salidas de los cuatro lenguajes están ejecutadas; las de VBA, en Excel.
5. Ningún ejercicio califica mal una respuesta correcta ni aprueba una en blanco.
6. Los casos inventados están declarados y ninguno contradice su propia cuenta.
7. Lo que se dice de un lenguaje es cierto en ese lenguaje, y lo que se dice de los
   cuatro, en los cuatro.
8. Las remisiones entre capítulos son ciertas en los dos sentidos.
9. La lectura crítica final no deja hallazgos altos, y los medios quedan corregidos o
   anotados con su razón.
10. Sonda de navegador en verde a 320 px, a 375 px y en escritorio, con recarga en cada
    lección; y el capítulo visto en el iPhone antes de publicar.

## 6. Riesgos

- **La norma no dice lo que el capítulo le atribuye.** Es el riesgo que la decisión A ya
  prevé: el caso se ajusta, con las mismas cifras.
- **Una cifra legal cambió o no se puede verificar en una fuente oficial.** Se declara
  ilustrativa y se dice que es de un año concreto; no se rellena.
- **Las tasas de mora de los casos superan la usura vigente.** No se compara de memoria:
  o se lee la certificación vigente y se cita, o se declara el caso inventado sin
  compararlo, como se hizo con la cuota del capítulo 2.
- **Cambiar las salidas de R rompe un ejercicio.** Los cuatro bloques se vuelven a
  ejecutar y sus ejercicios se revisan en la misma fase.
- **Una corrección mueve una cifra que el capítulo 4 o el 5 repiten.** Se revisa en la
  fase 9 antes de fusionar, y ese capítulo se toca en la misma rama.

## 7. Qué queda fuera

- Rediseñar el capítulo o cambiar el número de secciones.
- Los capítulos 4 y 5, salvo las frases que hablen del 3.
- Copiar nada al banco Moodle.
- El capítulo 6: la remisión al depurador se anota para cuando se escriba.
