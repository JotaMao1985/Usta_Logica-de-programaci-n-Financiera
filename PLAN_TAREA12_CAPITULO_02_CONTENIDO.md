# Plan · Tarea 12 — Mejora de contenido del capítulo 2

**Fecha:** 2026-11-14. **Estado:** propuesto; espera la aprobación del docente y sus
decisiones A–H (§3). No se ha tocado el capítulo.

**Archivo:** `Material html/02_LPF_Algoritmos.html` (4 758 líneas en `main`, commit
`c82fc71`). Todos los números de línea de este plan son de ese commit.

**Modelo:** `PLAN_TAREA11_CAPITULO_01_CONTENIDO.md`. Cambia una cosa respecto de ese
plan: la lectura crítica independiente se hizo **antes** de planear (es la línea base de
§2) y se repite **antes** de la fusión, no después.

---

## 0. Qué se decidió antes de planificar

Esta tarea no adapta el formato del capítulo —eso fue la Tarea 8—, sino su contenido: de
dónde sale lo que afirma, si es cierto, si no se contradice y si cumple lo que los
capítulos 3 y 5 dan por hecho.

No se reabren: Zotero como autoridad, APA 7 generado, solo se cita lo leído, las cinco
clases de afirmación, los cuatro lenguajes en paralelo con el pseudocódigo como
normativo, y los ejercicios de interpretación E1–E8 (`CLAUDE.md`,
`Material html/_fuentes/POLITICA_DE_FUENTES.md`).

Restricciones que salen de medir:

- **La numeración de las cinco secciones no cambia.** El capítulo 3 toma de aquí el
  análisis de entrada, proceso y salida y la traza.
- **Los cambios de LP-CORE se propagan a los cinco capítulos.** Este plan solo los toca
  en la fase 8, y lo dice.
- El banco Moodle tiene seis preguntas del capítulo (`Banco Moodle/rmd/cap02`), en un
  repositorio privado aparte. Lo que cambie puede dejarlas desfasadas.

## 1. Estado medido

| Qué | Cuánto | Cómo está |
|---|---|---|
| Citas en el cuerpo del capítulo | 0 | el capítulo 1 tiene 54 |
| «Referencias», «Para profundizar», `<Fuente>`, `<Ilustrativo>` | 0 | no hay ninguno |
| Figuras y tablas sin fuente (regla 30) | 8 | 2 diagramas, 6 tablas |
| Entidad o norma sin cita (regla 32) | 1 | «Superintendencia» (`:2864`); el verificador no ve «la norma de transparencia» (`:3194`) ni «el estándar ANSI» (5 menciones) |
| Ejercicios con tipo E1–E8 | 13 | cumple la cuota |
| Salidas declaradas | todas coinciden | ejecutadas en Python y R por el lector independiente; VBA, sin ejecutar |
| Notas del vault para el capítulo | 0 afirmaciones | `Cap 02 Algoritmos.md` dice `estado_contenido: sin-auditar` |
| Fuentes leídas que sirvan al capítulo | 0 | los libros del syllabus están en Zotero solo con metadatos; ISO 5807, sin acceso |

Lectura crítica independiente (Opus, sin contexto, 2026-11-14): **3 hallazgos altos, 19
medios y unos 27 bajos.** Ejecutó todas las cuentas; las salidas cuadran.

## 2. Hallazgos

### H1 · El caso central del capítulo enseña una cuota que no es la que dice
La sección 2 dice que el banco «cobra 1,8 % mensual» y pide «la cuota fija», pero calcula
el interés sobre el capital inicial durante todo el plazo (`capital * tasa * plazo`).
Una cuota fija al 1,8 % sobre saldo sería de unos 620 170 pesos, no de 730 400. El caso
no se declara simplificado ni inventado. Y la clave del ejercicio de interpretación de la
evaluación (`:4404`) llama «uso del dinero» a una cifra que incluye el seguro.

### H2 · Ni una fuente
Las cinco propiedades del algoritmo (`:2855-2904`) son una definición citable y van sin
cita; además separan «precisión» de «definición», lo que habría que cotejar con la
fuente. «El estándar ANSI» respalda cinco frases y la clave de una pregunta (`:4467`,
«exactamente dos salidas»). «La norma de transparencia» (`:3194`) y «ante la
Superintendencia» (`:2864`) nombran normas y entidades sin decir cuáles.

### H3 · Dos ejercicios califican mal
`OrdenaPasos` (`:3103-3119`) compara posición por posición y admite varios órdenes
válidos: es el mismo defecto que se encontró en el capítulo 1. En VBA, además, ese
ejercicio no lee ni declara las entradas. La traza de `:3200` aprueba en blanco con 67 %.

### H4 · La sección 5 cuenta una cosa y la llama otra
Lo que llama «comparaciones» de la búsqueda por mitades son vueltas: doce vueltas hacen
hasta 23 comparaciones. Dice que el número de operaciones «depende solo del algoritmo»
(`:4301`) y después que «depende de dónde esté el dato» (`:4516`). El ejercicio de las
5 000 búsquedas usa el peor caso donde el capítulo habla de promedios.

### H5 · Lo que se dice de «los lenguajes» y solo vale para uno
«Se declara constante… para que el lenguaje avise» (`:3960`): Python y R no avisan.
«Moneda» se presenta como tipo general y solo existe en VBA. La tabla de tipos dice que
guardar dinero como real arrastra error, y todo el código de Python y R del capítulo lo
guarda así. El arreglo que se propone para el reparto (`:3940`) no cuadra en VBA.

### H6 · Casos y cifras inventados sin declarar, y opiniones como hechos
La factura, el seguro «política del banco», el 1,8 %, el cierre que pasa de ocho a
cuarenta minutos, «tres frases que aparecen en manuales reales». Superlativos sin
respaldo: «el lenguaje que más se usa en el sector financiero», «la causa más común de
descuadres de un peso». La pregunta de la cédula depende de un hecho sin comprobar.

### H7 · Contradicciones menores y restos
La receta «termina» en un sitio y una condición no medible «puede no terminar nunca» en
otro; el artefacto de las cuatro representaciones dice sincronizar lo que no sincroniza;
«EPS» nunca se desarrolla y el capítulo 3 usa la sigla en otro sentido; tres ejercicios
tienen la respuesta en el recuadro de encima.

## 3. Decisiones que necesito del docente antes de empezar

| # | Decisión | Opciones | Recomendación |
|---|---|---|---|
| A | **El caso de la cuota** | (1) Conservar la cuenta y decir lo que es: interés simple sobre el capital inicial, un caso inventado para practicar, no una cuota de amortización. (2) Cambiarlo a cuota fija sobre saldo. | (1). La fórmula de la cuota fija necesita potencias y no cabe en un capítulo anterior a los operadores aplicados; (2) rehace trazas, ejercicios y preguntas del banco. |
| B | **Fuente de las cinco propiedades** | (1) Usted aporta el pasaje de uno de los libros impresos del syllabus (Joyanes, Cairó, Oviedo o López Román): foto o PDF de las páginas. (2) Busco y verifico una fuente de acceso abierto. (3) Quedan como definición del curso, redactada como criterio. | (1), y (2) en paralelo. Son los libros de su syllabus y el capítulo es el que más los necesita. |
| C | **«El estándar ANSI»** | (1) Usted consigue la norma (ISO 5807). (2) Se cita una fuente abierta leída que describa los símbolos, y lo que no esté en ella pasa a «convención del curso». (3) Se quita «estándar ANSI» y todo queda como convención del curso. | (2) si aparece la fuente; si no, (3). La pregunta de «exactamente dos salidas» se ajusta a lo que la fuente diga. |
| D | **«La norma de transparencia»** | (1) Busco la norma colombiana en su página oficial y la cito con fecha de consulta. (2) Se quita la mención. | (1); (2) si no se puede verificar. |
| E | **Cómo se cuenta en la sección 5** | (1) Se cuentan vueltas y se llaman vueltas: 39 814 frente a 12 se conservan. (2) Se cuentan comparaciones de verdad: 39 814 frente a 23. | (1). Conserva las cifras de la portada y del cuestionario, y es lo que el código cuenta. |
| F | **`OrdenaPasos`** | (1) Cada enunciado fija el orden, como se hizo en el capítulo 1. (2) El componente aprende a aceptar cualquier orden válido; es un cambio de LP-CORE que se estampa en los cinco capítulos. | (2). Ya son dos capítulos con el mismo defecto y es probable que el 3, el 4 y el 5 lo tengan. |
| G | **Banco Moodle del capítulo 2** | (1) Al final reviso las seis preguntas y dejo borradores en el vault, sin copiar al banco. (2) No se revisan ahora. | (1), igual que en el capítulo 1. |
| H | **Publicación** | (1) Una sola fusión al cerrar el capítulo. (2) Fase por fase. | (1), con la lectura crítica final antes de fusionar. |

## 4. Fases

Cada fase va en su rama, una sobre otra, y termina en un punto de control: informe,
verificador en verde y espera de su visto bueno. Las frases citadas pasan por un
verificador sin contexto antes de registrar la nota.

### Fase 1 — Línea base y fuentes
- Vault: una nota por afirmación del capítulo (clase y estado), por figura, por concepto
  y por hilo narrativo.
- Buscar y leer las fuentes de B, C y D. Preparar la tanda de importación a Zotero; **la
  importación espera su aprobación**.
- Entregable: cuántas afirmaciones hay, de qué clase, y con qué fuente cuenta cada una.

### Fase 2 — Sección 2, Entrada, proceso y salida
El caso de la cuota según A; la clave del ejercicio de interpretación; la norma según D;
el ejercicio de ordenar en VBA; la traza que aprueba en blanco.

### Fase 3 — Sección 5, Eficiencia
El conteo según E; «depende solo del algoritmo»; el ejercicio de las 5 000 búsquedas; lo
que la búsqueda por mitades hace sobre una lista desordenada.

### Fase 4 — Sección 1, Qué es un algoritmo
Las cinco propiedades según B; la receta y la finitud; «manuales reales»; los casos
inventados, declarados.

### Fase 5 — Sección 3, Representaciones
Los símbolos según C; el texto del artefacto de las cuatro representaciones; el ejercicio
de detectar el error que regala la respuesta; «el lenguaje que más se usa».

### Fase 6 — Sección 4, Variables, tipos y asignación
Constante y moneda, lenguaje por lenguaje; el dinero en coma flotante frente a la tabla
de tipos (con remisión a la sección 4 del capítulo 1); el arreglo del reparto; la cédula.

### Fase 7 — Portada, evaluación, glosario y cierre
«Referencias» y «Para profundizar» generadas; cuestionario integrador; glosario
(«prueba de escritorio» frente a «traza», «EPS»); «Lo que viene».

### Fase 8 — Figuras y LP-CORE
Las ocho figuras y tablas sin fuente. `OrdenaPasos` según F y `TablaTraza` con respuesta
obligatoria, si cambia el componente: se estampa en los cinco capítulos y se prueba en
cada uno.

### Fase 9 — Coherencia con los demás capítulos y banco
Lo que los capítulos 1, 3 y 5 dicen del 2, y lo que el 2 dice de ellos. Las seis
preguntas del banco según G. Salidas de VBA ejecutadas en Excel.

### Fase 10 — Lectura crítica final y cierre
Un lector sin contexto lee el capítulo entero y un verificador lee todas las citas contra
sus pasajes. Se corrige lo que salga. Bitácora, vault, y fusión con su aprobación.

## 5. Criterios de aceptación del capítulo

1. Toda afirmación fáctica cae en una de las cinco clases; ninguna queda sin clasificar.
2. Toda cita tiene su nota en el vault con el pasaje completo y literal, y su fila en
   `afirmaciones/02.yaml`.
3. `verificar.py --con-salidas --con-pandoc` pasa, y el capítulo 2 queda sin avisos.
4. Las salidas de los cuatro lenguajes están ejecutadas; las de VBA, en Excel.
5. Ningún ejercicio califica mal una respuesta correcta ni aprueba una en blanco.
6. Los casos inventados están declarados y ninguno contradice su propia cuenta.
7. Las remisiones entre capítulos son ciertas en los dos sentidos.
8. La lectura crítica final no deja hallazgos altos, y los medios quedan corregidos o
   anotados con su razón.
9. Sonda de navegador en verde, en escritorio y a 375 px.

## 6. Riesgos

- **No aparece fuente abierta para las propiedades o los símbolos.** Entonces esas
  partes se redactan como convención del curso, o esperan sus libros impresos.
- **La norma de transparencia no se puede verificar** o no dice lo que el capítulo le
  atribuye: se quita la mención.
- **El cambio de `OrdenaPasos` rompe un ejercicio de otro capítulo.** Por eso va en su
  propia fase, con sonda en los cinco.
- **El capítulo 3 depende del caso de la cuota** o de la traza: se revisa en la fase 9
  antes de fusionar.

## 7. Qué queda fuera

- Rediseñar el capítulo o cambiar el número de secciones.
- Los capítulos 3, 4 y 5, salvo las frases que hablen del 2.
- Copiar nada al banco Moodle.
- Safari de iPhone: sigue pendiente de Xcode o de un modo WebKit en la sonda.
