# Revisión de contenido de los capítulos 4 y 5

**Fecha:** 2026-10-19.

> **Estado al 2026-10-20.**
>
> **Corregidos todos los graves y medios de los capítulos 4 (§2) y 5 (§3).**
> - Capítulo 4: rama `cap04/revision-contenido`, fundida en
>   `cap05/control-repetitivo`. Detalle en la §10 de `PLAN_TAREA9_CAPITULO_04.md`.
> - Capítulo 5: H18 de `PLAN_TAREA10_CAPITULO_05.md`.
> - Las cifras y claves nuevas se ejecutaron en Python y R.
> - Cada ejercicio que cambió se llevó hasta el veredicto en el navegador, con una
>   respuesta buena y una mala.
> - El cuestionario del 4 da 10/10.
> - A 375 px nada se sale en ninguno de los dos capítulos.
>
> **Un cambio de diseño respecto de lo propuesto aquí.** Las tablas de traza del 4
> no llevan dos columnas («¿se ejecuta?» y «condición») sino una sola, «flujo», que
> es la que prometió el capítulo 3. En ella se escribe `verdadero` o `falso` en una
> condición evaluada, `salta` en una que no se evalúa, y `ejecuta` o `salta` en las
> demás líneas.
>
> **Sin tocar:**
> - la librería (§1: L1 a L6), que espera a la tarea de deudas P3;
> - los menores, salvo los que estaban en la misma frase que un medio.

**Alcance:**
- capítulo 4 completo, que está publicado en `main` y entra en el parcial de hoy;
- capítulo 5, secciones 1 a 5. La 6, la 7, la evaluación y el glosario son todavía andamio y no se revisaron.

**Qué se miró:**
- la redacción;
- la coherencia narrativa y explicativa;
- la pertinencia y la calidad de los gráficos y las simulaciones;
- el planteamiento de las preguntas y los ejemplos;
- el barajado de las respuestas;
- si cada ejercicio evalúa lo que dice evaluar.

**Cómo:** cinco revisores en paralelo:
- prosa del capítulo 4;
- prosa del capítulo 5;
- ejercicios del capítulo 4;
- ejercicios del capítulo 5;
- gráficos y simulaciones de los dos.

Además se hizo una pasada propia de barajado y otra visual en el navegador. Todos los hallazgos graves los comprobé yo de nuevo antes de escribirlos aquí. Python y R se ejecutaron siempre; VBA se razonó con la documentación de Microsoft y no se ejecutó.

Las líneas se citan como `04:NNNN` y `05:NNNN`, que corresponden a `Material html/04_LPF_Control_Selectivo.html` y `Material html/05_LPF_Control_Repetitivo.html`.

---

## 0. Lo que está bien, y que no hay que volver a revisar

- **Todas las claves son correctas.** Son 19 ejercicios y 10 preguntas del cuestionario en el capítulo 4, y 11 ejercicios en el 5. Cada `TablaTraza`, `Comparador` y pregunta de salida se ejecutó en Python y en R. La cascada y la versión anidada del capítulo 4 se compararon en 1,2 millones de combinaciones.
- **Las trazas son exactas.**
  - Los tres `Trazador` (6 pasos en el capítulo 4; 14 y 33 en el 5) señalan la línea correcta en los cuatro lenguajes en todos los pasos.
  - Su estado coincide con una ejecución instrumentada en Python.
  - El `lineaCorrecta` de los tres `DetectaError` es correcto en los cuatro lenguajes.
- **Las cifras cuadran.** Se comprobaron:
  - las tres amortizaciones de `AmortizacionPasoAPaso`, con sus residuos;
  - la bisección de la TIR: 17 filas, 1,9924 %;
  - los tres simuladores y las carteras de la sección 5;
  - el recargo, la retención y los «diez desembolsos» del capítulo 4.
- **Los flujogramas son fieles a su estructura.** El retorno llega antes del rombo en `Mientras` y `Para`, y antes del cuerpo en `Repita`. No hay cruces. La tabla de verdad del `EvaluadorLogico` es correcta en las 8 filas, y `SelectivasComparadas` es correcto en los 8 montos.
- **La posición de las claves está bien barajada.**
  - En el capítulo 4 quedan a:6, b:4, c:4, d:5, sin rachas de más de dos.
  - La clave es la opción más larga en 6 de 15 ítems, un poco por encima del 25 % que daría el azar, y ninguna se delata (regla 17).
  - En el capítulo 5 son 5 ítems: a:1, b:2, c:1, d:1.
- **El parcial no está afectado por el hallazgo G4.1.** El banco no repite ese error: se comprobó en su repositorio privado, y el detalle no se copia aquí porque este repositorio es público.

---

## 1. Librería compartida (afecta a los cinco capítulos)

Todos estos se arreglan en `lp-core-extra.jsx` y obligan a volver a estampar los capítulos. Conviene sumarlos a las deudas P3, que ya tienen su tarea antes del capítulo 6.

| # | Gravedad | Defecto | Comprobado |
|---|---|---|---|
| L1 | **grave** | **El desorden de `OrdenaPasos` es siempre el mismo patrón** (ver más abajo). | Ningún capítulo pasa `mezcla`. Calculé el orden que se ve en los 4 ejercicios de los capítulos 4 y 5. |
| L2 | media | **H17: `OrdenaPasos` colapsa la sangría.** En Python no se distingue una línea dentro del `if` o del `for` de una fuera. Afecta también a los dos del capítulo 4 (04:3508 y 04:4779). | Registrado en el plan. |
| L3 | media | **`TablaTraza` lee mal la coma de miles.** «30,000» se normaliza a 30. «1,350,000» y «2,770,778.28» no casan. Python imprime con esa coma en el material (`f"{x:,.2f}"`). | `normalizarCelda`, 05:1334–1342. Se ejecutó en Node. |
| L4 | media | **`not-prose` no hace nada** (es del plugin Typography, que no se carga), y por eso `.prose-lp` invade los componentes. Pasa en la tabla de `AmortizacionPasoAPaso`, la de la TIR y la del `EvaluadorLogico`, y en los títulos y márgenes de los componentes. | En el navegador: el `th` con `text-right` sale `left`, el relleno es 9,6 px en vez de 6 px y el `h4` con `text-primary` sale navy. |
| L5 | media | **`Trazador` arrastra el último valor de cada columna.** Para una condición evaluada eso está mal (ver G5.4). | Propuesta: una propiedad `efimera: true` en `variables`. |
| L6 | menor | Hay cuatro defectos más. | Ver la lista de abajo. |

> **Estado al 2026-10-27** (rama `lpcore/deudas-p3`):
> - **Resueltos:** L1, L2, L3 y L5. De L6, tres de cuatro: `Pipeline`,
>   `ChartFrame` y los `id` de los marcadores del 4.
> - **L4, a medias y a propósito:** `not-prose` vale ahora en títulos y tablas.
>   Hacerlo valer en párrafos y listas cambiaba cientos de medidas en los cinco
>   capítulos, entre ellas las viñetas de los `CalloutPro`.
> - **Pendiente, a decisión del docente:** que `DetectaError` pida anticipar el
>   `impacto` cambia cómo se resuelven los E3 de todo el curso.
> - **Sin probar:** Safari y Firefox.

Los defectos menores de L6 son estos:
- `Pipeline` deja flechas sueltas cuando las etapas pasan a otra fila. En el capítulo 4, la sexta etapa queda sola.
- `ChartFrame` (Plotly) no tiene descripción accesible.
- Los marcadores `lp-flecha4` y `lp-flecha5` tienen el mismo id en cada SVG. Conviene comprobar a 375 px en Safari y Firefox que la cascada estrecha muestra las puntas de flecha.
- `DetectaError` muestra el `impacto` pero nunca pide anticiparlo, que es lo que la taxonomía E3 pide.

**L1 en detalle.** `mezclaPorDefecto(n)` produce `[n−1, 0, n−2, 1, n−3, 2, …]`.
- Las tarjetas pares, leídas de arriba abajo, dan la primera mitad del programa en orden.
- Las impares, leídas de abajo arriba, dan la segunda mitad.
- La tarjeta 2 es siempre el primer paso y la tarjeta 1 el último.

Quien note el patrón resuelve los ocho `OrdenaPasos` del curso sin leer el código. Este es el `ORDENA_OFICINAS` en pseudocódigo, tal como se ve:

```
tarjeta  1 -> paso 15  Fin
tarjeta  2 -> paso  1  Inicio
tarjeta  3 -> paso 14  Escribir total
tarjeta  4 -> paso  2  Leer oficinas
tarjeta  5 -> paso 13  FinPara    // oficinas
tarjeta  6 -> paso  3  total <- 0
...
```

No se puede arreglar desde cada capítulo. `mezcla` es un único arreglo y solo se aplica si su largo coincide con el del lenguaje activo, y cada lenguaje tiene un número de pasos distinto: el E5 de la sección 5 tiene 15 en pseudocódigo, 11 en Python, 13 en R y 16 en VBA.

Arreglo propuesto, en dos partes:
- **En la librería:** `mezcla` debe aceptar `{pseudo, python, r, vba}` mediante `porLenguaje`. Y la mezcla por defecto debe ser una permutación pseudoaleatoria determinista, sembrada con el contenido de los pasos, sin tramos ordenados largos.
- **En `verificar.py`:** una regla que mida la subsecuencia creciente más larga del orden que se ve y avise si pasa de la mitad.

---

## 2. Capítulo 4 (publicado, en `main`)

Los arreglos de este capítulo van en `main` o en una rama propia, no en `cap05/control-repetitivo`.

### Graves

**G4.1 · «Ninguna de las cuatro respuestas es un error visible» es falso en Python y en la cascada de R.**
- **Dónde:**
  - prosa, 04:4927–4930;
  - texto de `SelectivasComparadas`, 04:2689–2690: «No hay error, no hay mensaje»;
  - clave y justificación de la pregunta 2 del cuestionario, 04:5372–5374: «la cuota queda como estuviera, y nadie se entera» y «Ninguno de los cuatro lenguajes avisa».
- **Por qué es falso:**
  - en Python, sin `case _`, la variable queda sin definir y la línea que la usa se detiene con `NameError`. En el propio `ORDENA_SEGUN`, `print(cuota)` falla;
  - en R, la cascada sin `else` da «object not found»;
  - solo callan VBA (con `Dim` deja 0) y el `switch` de R (NULL invisible);
  - además, en R la `cuota` no «queda como estuviera»: el `switch` la pisa con NULL.
- **Texto propuesto:** «Lo que pasa después depende del lenguaje. En VBA la variable conserva su valor —0 si solo se declaró— y la transacción sale gratis, sin aviso. En R, `switch` devuelve NULL sin decir nada. En Python, y en la cascada de R, la variable no existe y el programa se detiene más adelante, en la primera línea que la usa: hay error, pero aparece lejos del defecto y no dice cuál es.»
- **Clave de la pregunta 2:** «…la cuota no recibe valor de ese Segun, y el Segun no avisa».

**G4.2 · Las cuatro `TablaTraza` delatan por dónde pasó el flujo.**
- **Dónde:** 04:3567 (sección 2), 04:3855 (sección 3), 04:4550 (sección 4) y 04:5203 (sección 6).
- **Qué pasa:** la columna `instruccion` es visible y sus filas son exactamente las instrucciones que se ejecutaron. En un capítulo de selectivas, esa lista es la respuesta:
  - en la sección 4 las filas llegan al `Sino` y a `decision <- "APROBADO ESTANDAR"`, así que las cuatro condiciones tienen que ser `falso` y el 12/12 sale sin mirar los datos;
  - en la sección 2 falta la fila del recargo, así que 30 > 30 se responde sin evaluarlo, y eso es justo lo que enseña la motivación;
  - las pistas de 04:3875, 04:4570 y 04:5225 dicen la respuesta.
- **Arreglo:**
  - poner como filas todas las líneas de la selectiva, también las que no se ejecutan;
  - registrar en columnas ocultas `ejecuta` / `salta` y, en las condiciones, `verdadero` / `falso` / `no evaluada`;
  - en la sección 4, usar otro solicitante (5 000 000, score 600, 30 %), que cae en el borde `>=`, sale APROBADO PREFERENCIAL y deja una condición `no evaluada` (ejecutado).

**G4.3 · En el E7 de la sección 6, la justificación contradice la clave y avala un distractor.**
- **Dónde:** 04:5174–5182.
- **Qué pasa:** la justificación dice que «la respuesta completa nombra la condición que decidió y además advierte de la siguiente».
  - La clave («d») no advierte de nada.
  - El distractor «a» («mejore el score y baje el endeudamiento») sí lo hace.
  - Además, «tres de ellas ni siquiera le aplican» es falso: para 6,5 M, score 480 y 68 %, `endeudamiento > 60` e `ingreso >= 5000000` serían verdaderas.
  - Por último, los datos son los mismos de la portada, la sección 1, la sección 4 y el `Trazador`, así que se acierta por reconocimiento.
- **Arreglo:**
  - clave: «Que lo decidió el score de 480, por debajo del mínimo de 550; el endeudamiento ni se llegó a evaluar»;
  - en la justificación, quitar la frase que exige advertir;
  - cambiar «tres… no le aplican» por «dos —endeudamiento e ingreso preferencial— se cumplirían, pero nadie las miró».

### Media: prosa

| Dónde | Qué falla | Propuesta |
|---|---|---|
| 04:3248–3249, 3258, 5363 | «El orden… es el mismo en los cuatro lenguajes» incluye los aritméticos, y no lo es: `2 * 5 %% 3` da 4 en R y `2 * 5 % 3` da 1 en Python. En VBA, `\` y `Mod` van debajo de `*` y `/`. | «Para relacionales y lógicos, el orden es el mismo en los cuatro lenguajes». |
| 04:4720, 4801, 4904 | `1 <= m <= 100_000` es una comparación encadenada, propia de Python, y no se explica. En R da error de sintaxis; en VBA compila y da siempre Verdadero. | Una nota: «equivale a `1 <= m and m <= 100_000`; no la traslade». |
| 04:4469 y glosario 5318 | «Anidar: la condición interior solo se plantea si la exterior se cumplió». `CMP_ANIDADA` anida en el `Sino`. Antes del E4 no hay ningún `Si` anidado salvo en la pestaña VBA. No se dice que `Sino Si` es un `Si` dentro del `Sino`. | Cambiar la definición, añadir un ejemplo anidado de dos niveles y una frase sobre `Sino Si`. |
| 04:3550–3555 | «Sin `recargo <- 0`… sumaría una variable sin valor». En VBA, `Dim` ya la deja en 0. | Decir qué pasa en cada lenguaje, y por qué se escribe igual. |
| 04:3170–3173 | Comentario de R: «es peor que el error de VBA… se cuela sin dejar rastro». Con `&` el resultado es FALSE, que es la respuesta correcta. | «Con & el resultado sale bien, pero por suerte: la división se hizo igual y nadie lo dijo». |
| 04:4457, 2500 | «Tres condiciones no se evalúan **nunca**». Sí se evalúan para los solicitantes de menos de 5 millones; el recuadro de 04:4502 lo dice bien. | «…a un solicitante de altos ingresos, tres no llegan a evaluársele». |
| 04:4573–4587 | El título promete «dentro de una cascada», pero el ejemplo es un `Si` simple. | «El otro defecto: la negación mal distribuida». |
| 04:4893, 4983 | «Primera vez…» y «único punto del curso…». Lo desmiente la guardia de VBA de la sección 2. | «Como ya pasó con la guardia de la sección 2…». |
| 04:4916–4919 | «VBA nació para hojas de cálculo» como causa de `Case 1 To 5`. Viene de la familia BASIC, de antes de VBA. | Atribuirlo a BASIC. |
| 04:4733–4735 | «No es una limitación que se pueda rodear». R tiene `cut()` y `findInterval()`. | «`switch` resuelve otro problema; R tiene `cut()` para tramos, pero no es una selectiva». |
| 04:3028, 3222 | «Negar una condición sin invertir su sentido» es contradictorio: negar es invertir el sentido. | «Negar bien una condición compuesta, cambiando también el conector». |
| 04:3792–3793 | La motivación de la sección 3 habla de «otra tarifa para el resto», pero el código usa `monto > 1000000`, que nadie presenta. | Decir de dónde sale el millón. |
| 04:3195–3196 | «No pase del 40 %» incluye el 40, y el código usa `< 40`. Es el mismo tipo de frontera que enseña la sección 2. | «Esté por debajo del 40 %». |
| 04:3381 y siguientes | Un recargo del 5 % sobre todo el saldo por un mes de mora equivale a un 79,6 % EA. En Colombia, la mora está topada por la usura (28,59 % EA en octubre de 2026) y se cobra sobre lo vencido. | Una nota: «el 5 % es ilustrativo». |

### Media: ejercicios y cuestionario

| Dónde | Qué falla | Propuesta |
|---|---|---|
| 04:4933 (E2 del `switch`) | La clave es NULL, que no aparece en ningún capítulo. El párrafo anterior elimina el distractor del error, así que el ítem se acierta por eliminación. | Preguntar por `cuota <- switch(…)` con la clave «se queda sin valor numérico, sin aviso», y mover el párrafo de 04:4929 detrás del ejercicio. |
| 04:4581 (E3 de la negación) | `marcarRevisionManual` solo se asigna dentro del `Si`, así que hay un segundo defecto según la regla del propio capítulo. «Dos líneas evalúan condiciones y solo una está mal» deja el paso 1 en una elección binaria. El párrafo 04:4574 describe el defecto exacto. Los tipos a y b se descartan sin saber nada. | Valor por defecto antes del `Si` (cambian las `lineaCorrecta`), enunciado sin pista, tipos verosímiles y el párrafo después del ejercicio. |
| 04:4527 (E3 de la cascada) | «Señale la línea que hay que mover» y «las tres condiciones son correctas» eliminan tres de los cuatro tipos. El comentario «del comite» contradice «tal como quedó en producción». | «Señale la línea donde está el defecto y clasifíquelo», con un tipo «asignación pisada». |
| 04:3325 (MCQ de De Morgan) | Las opciones b y c son literalmente las del párrafo de 04:3300: se responde copiando. | La misma idea con otra condición, `antiguedad >= 24 Y diasMora = 0`, y un distractor de borde (`<= 24`). |
| 04:3612 (E5 de la mora) | En Python y R, las dos lecturas conmutan sin convención que las ordene, así que hay dos órdenes válidos y se acepta uno. El enunciado regala dónde va `recargo <- 0`. | Convención: «lecturas primero, el saldo antes que los días». |
| 04:4957 (E5 del `Segun`) | No dice qué cuota corresponde a cada tipo de cuenta, así que intercambiar 8 500 y 21 000 es válido y se califica mal. | Dar las tres cuotas en el enunciado. |
| 04:4943 (E4 del `Segun`) | «La de la derecha tiene caso por defecto y la de la izquierda no» anuncia la respuesta. En el móvil los paneles se apilan. El artefacto de 04:4922 ya mostró el veredicto. | «Decida si son equivalentes», y llamarlas «A» y «B». |
| Cuestionario | Hay cuatro problemas, detallados abajo. | Hay una pregunta nueva para cada caso, verificada por ejecución. Una de ellas cubre De Morgan. Se aplican si las aprueba. |
| 04:2270 (`EvaluadorLogico`) | Muestra el cortocircuito (operandos tachados) antes de que el capítulo diga que VBA no lo tiene. | Una línea: «Así evalúan pseudocódigo, Python y R (`&&`, `||`). En VBA, `And` y `Or` miran siempre los tres operandos». |

Los cuatro problemas del cuestionario:
- Q3 repite el E1 de la sección 2: el mismo programa, el mismo saldo y los mismos días. La regla 18 no lo ve, porque la `TablaTraza` no tiene opciones.
- Q10 se resuelve por eliminación.
- Q8 es trivial: la clave es el ejemplo literal de la sección 5.
- Q1 es recuerdo literal, y **De Morgan no aparece en el cuestionario**.

### Menores

- **Tildes.**
  - En los comentarios de 04:4103, 4116, 4127 y 4140 dice «Politica de originacion… del comite», y en 04:4165–4195 «revision», «politica» y «automatico».
  - «APROBADO ESTANDAR» en el código convive con «ESTÁNDAR» en el cuestionario (04:5401): hay que unificar.
- **Erratas.**
  - 04:3563: «menos filas que instrucciones el programa» → «…que instrucciones tiene el programa».
  - 04:3594: «de capítulo 3» → «del capítulo 3».
  - 04:3351: dos puntos encadenados.
  - 04:4447: nota ambigua, «no van a dar falso — es que nadie las va a mirar».
  - 04:2312: «cambia el árbol, no el texto» → «…no las condiciones».
- **Referencias espaciales falsas.** «El programa de la izquierda» (04:4525) debe ser «de arriba». «Derecha/izquierda» en el `Comparador` (04:4945).
- **Afirmaciones absolutas pequeñas.**
  - 04:4913: «solo VBA escribe el rango», pero el pseudocódigo también.
  - 04:4870: «doce líneas», pero son 24.
  - 04:5160: «cuatro de ellas ni se evaluaron» solo vale si decidió la primera regla.
  - 04:3058: cita no literal del capítulo 3.
- **Python 3.10.** `match` lo exige y solo lo dice un comentario interno (04:4625).
- **Jerga interna en la portada:** «la fila 34 del syllabus» (04:3075). El `Pipeline` promete «tarifas» en la sección 6 (04:3040), que no las tiene.
- **Vocabulario financiero sin definir:** «originación», «endeudamiento» (¿cuotas sobre ingreso?), «UVT», «declarante» y «score». Basta con un `Termino` en su primera aparición.
- **Orden de presentación.** `EJ_CONDICION` y el `EvaluadorLogico` usan «Y liga más fuerte que O» antes de la tabla de precedencia (04:3245). El cortocircuito del pseudocódigo es una convención que nunca se declara, y en R solo existe con `&&` y `||`.
- **Ejercicios.**
  - El MCQ de 04:3358 no fija el lenguaje, y en VBA la opción «d» sería cierta.
  - La clave de Q9 aporta un dato que el enunciado no da.
  - El `Emparejamiento` se resuelve por palabra clave y usa una sintaxis de VBA (`If … Then: If`) que el capítulo nunca mostró.
  - El reto de 04:5267 es confuso.
  - El `Trazador` `TZ_CASCADA_MAL` es un extracto sin la regla del codeudor y no lo dice.
- **Gráficos.**
  - La selectiva simple de la sección 2 no tiene flujograma, y sería el lugar natural para «la fila que no está».
  - Las versiones estrechas de los flujogramas no tienen `maxWidth`: la cascada llega a unos 2 100 px de alto con 550 px de ancho.
  - El `EvaluadorLogico` arranca en un caso donde las dos expresiones ya difieren.

---

## 3. Capítulo 5, secciones 1 a 5 (rama `cap05/control-repetitivo`)

### Graves

**G5.1 · El −2 313 243,65 del recuadro «El espejo de la sección 1» no corresponde al caso que describe.**
- **Dónde:** 05:5442–5444, y el comentario de `EJ_SIMULADOR_MAL`, 05:5016–5020.
- **Qué falla:** «Si `saldo <- capital` **también** sale del ciclo» se lee como «además de `intereses`». En ese caso, el plazo de dos años informa **−1 311 644,50**. El −2 313 243,65 sale solo si se saca únicamente el saldo. Además, «el saldo en cero» choca con la sección 4, que insiste en que es −7,5 × 10⁻⁸.

  Las cuatro variantes, ejecutadas:

  | Variante | Intereses a 2 años | Intereses a 3 años |
  |---|---|---|
  | todo en su sitio | 1 981 784,47 | 3 014 862,39 |
  | solo `intereses` fuera | 2 983 383,62 | 5 998 246,01 |
  | solo `saldo` fuera | −2 313 243,65 | −14 213 702,63 |
  | los dos fuera | −1 311 644,50 | −15 525 347,12 |
- **Arreglo:** dar −1 311 644,50, o redactar el caso como «si en el simulador **bien escrito** se saca `saldo <- capital`…». En los dos casos, «el residuo que dejó el de un año» en vez de «el saldo en cero».

**G5.2 · El E5 de la sección 1 tiene tres órdenes válidos y solo acepta uno.**
- **Dónde:** 05:3560 (enunciado) y `ORDENA_RECAUDO`, 05:3388.
- **Qué falla:**
  - `Leer n` conmuta con las dos inicializaciones, y ninguna de las dos convenciones lo fija.
  - Inicializar y después leer es un programa correcto y un estilo habitual, y recibe 8 de 11: la misma nota que el defecto que el ejercicio persigue.
  - El recuadro «Orden correcto» le enseña que estaba mal.
- **Arreglo:** una tercera convención, la misma que ya usa el E5 de la sección 5: «la cantidad de pagos se lee antes de las inicializaciones».

**G5.3 · La definición de contador y acumulador no encaja con los ejemplos del propio capítulo.**
- **Dónde:** 05:3465, 05:3470, la tabla de 05:3500 y la justificación del E2 en 05:3544.
- **Qué falla:**
  - El acumulador «aumenta», pero su propio ejemplo, el saldo, disminuye.
  - Con el criterio «cantidad fija o variable», `cobrado <- cobrado + cuota` (secciones 3 y 4) sería un contador, y el saldo con abono fijo de las secciones 2 y 5 también.
  - El capítulo 2 definió el acumulador de otra manera: «se actualiza sumándose a sí misma».
  - Además, en el E2 de 05:3540 las dos claves son las únicas opciones que dicen «suma 1», que es la definición literal del `Termino`, así que se acierta emparejando palabras.
  - Y clasificar variables no es un E2 («predecir la salida»).
- **Arreglo:**
  - Que mande la pregunta a la que responde cada variable. Contador: «cuenta cuántas veces». Acumulador: «lleva un total calculado a partir del que ya tenía; puede subir o bajar, en cantidades iguales o distintas».
  - Añadir la frase «`cobrado <- cobrado + cuota` suma siempre lo mismo y aun así es un acumulador».
  - Reescribir las opciones del E2 con un diseño 2 × 2: cambia en todas las vueltas o solo en algunas, por contador o acumulador. O convertirlo en un E2 de verdad: «con estos tres créditos, ¿qué escribe?».

### Media

| Dónde | Qué falla | Propuesta |
|---|---|---|
| 05:3709–3712 (G5.4) | En el `Trazador` de la sección 2, la columna «saldo > 0» sigue diciendo «Verdadero» en las filas donde el saldo ya es −200 000, porque arrastra el valor de la evaluación anterior. | Ahora: `cond: '—'` en los pasos del cuerpo. Después: L5. |
| 05:5471 | La nota del `Trazador` de la sección 5 anuncia 33 pasos y su desglose no suma 33: omite la cabecera del ciclo de dentro, que se ejecuta seis veces. Lo marcaron tres revisores. | Desglose 3 + 12 + 6 + 12 = 33, con la línea del `Para` de dentro contada aparte. |
| 05:4902–4905 | La predicción que pide `TresCiclosComparados` (con n = 0, el `Repita` cobra una cuota y el `for` de R, dos) ya está respondida seis veces antes: 4209, 4800, 4814, 4835, 4878 y la portada. Es un reto que ya se resolvió. | Quitar los anticipos, o añadir un cuarto panel con `range(1, n)`, que difiere con todo n ≥ 1. |
| 05:4192 (E4 de la sección 3) | La clave repite la escena de la motivación (el cliente a paz y salvo al que se le cobra), así que se acierta de memoria. «La negación exacta» viene dada, y la tabla de De Morgan que se acaba de enseñar no se evalúa. | Una condición compuesta (`saldo > 0 Y k < n` frente a `Hasta saldo <= 0 O k >= n`). Las opciones y la justificación ya están redactadas y ejecutadas en Python y R. |
| Sección 4 | El contenido central (qué significa `Para` en cada lenguaje: el tope de `range`, `1:0`, el contador de VBA) no tiene ningún ejercicio que lo califique. | Un E2 multilingüe con n = 1: «¿cuáles no dan ninguna vuelta?». Sube la cuota. |
| 05:4699, 4702, 4806–4829 | No se dice que el `for` de Python y R **recorre una secuencia** y no compara ni suma. Esa sola idea explica las tres «diferencias sin error» y el 3 frente al 4 de la sección 5. | Una frase antes del recuadro. |
| 05:3814–3824 | «Tres piezas que el Mientras no pone»: el párrafo dice que son dos, y la lista enumera tres, una de ellas la que sí pone. | Título: «Las tres piezas de un ciclo». |
| 05:4094–4100 | «El único break del capítulo»: hay cuatro (Python y R de dos programas). «El pseudocódigo no lo tiene», pero la búsqueda del capítulo 2 usaba `Salir`. | Título: «El único uso de break…», y nombrar el capítulo 2. |
| 05:4336, 4985 | El VBA pasa de `Currency` (secciones 1–3 y 5) a `Double` sin explicarlo. La nota del residuo −7,5 × 10⁻⁸ solo es cierta en VBA por eso: con `Currency` el saldo final sería −0,0005. | Un comentario en el VBA de `EJ_PLAN_PAGOS`. |
| Sección 1 | No hay ningún gráfico ni traza. El texto dice que las dos versiones «coinciden en las dos primeras vueltas» y que se separan en la tercera, y el estudiante no lo ve. | Un `Trazador` corto de `EJ_AHORRO_MAL`, o un Plotly de dos líneas. |
| Sección 5 | Es la única sección de ciclos sin flujograma, y es donde más ayudaría ver «el de dentro vuelve a empezar». | Un `FlujogramaAnidado` con dos retornos concéntricos. |

### Menores

- **Prosa.**
  - «Un renglón más abajo» no es literal (05:3411, 3508 y comentarios): son tres renglones.
  - «En ninguno se detuvo a decir cómo se llamaban» (05:3418): el capítulo 2 sí los nombró.
  - «La frontera entre < y <= no se repite» (05:3438): el E3 de la sección 4 la retoma.
  - La portada dice «fuera del ciclo y no dentro» (05:3026), y la sección 5 enseña que `intereses <- 0` va dentro del ciclo de fuera.
  - «El ciclo no tiene un error» (05:3789).
  - «El paso» se usa sin presentarlo (05:4823).
  - La tabla dice «¿Incluye el tope? No» al lado de `range(1, n + 1)` (05:4799).
  - La motivación de la sección 5 tiene 108 palabras, y la receta pide unas 80.
  - «Cobranza ofrece» (05:3766), «Al migrarlo de Excel» (05:4686).
- **Erratas.**
  - 05:3544: «saldoMora es un acumulador: también se lee a sí misma» → «a sí mismo».
  - 05:4201: «residuo» con otro sentido del que tiene en el capítulo.
  - 05:4842: el `Termino` define un error como «un ciclo».
  - 05:5499: «el ciclo que recorre su variable».
  - 05:3896: «abono 0: el cliente no alcanza a abonar este mes», cuando el abono es fijo.
- **Ejercicios.**
  - La glosa de la opción a del E2 de la sección 2 delata la respuesta (05:3894).
  - El E4 de la sección 4: la clave «escribe las cuotas 1 a n, también con n igual a 0» no se entiende, y con n = 0 la fórmula de la cuota divide entre cero (05:4872, 4878).
  - El comentario del E4 y el plan (05:4608; plan, 731) afirman la equivalencia «con negativos», y en R `seq_len(-3)` da error.
  - En VBA, «Fin de la vuelta n» es ambiguo para `k` (05:4777).
  - El E8 cita `monto <- -1` solo con la sintaxis de pseudocódigo y R.
  - Las opciones del E2 usan camelCase, mientras Python y R usan snake_case.
- **Gráficos.**
  - `AmortizacionPasoAPaso` muestra 0,00 donde el bloque de código muestra −0.00 (05:2209).
  - `TresCiclosComparados`: le faltan artículos, usa punto de miles mientras la prosa usa espacio, y a 375 px el botón «6» queda solo en una segunda fila (05:2466).
  - Los flujogramas no coinciden del todo con su código. `FlujogramaMientras` dice «Leer» cuando el código asigna. `FlujogramaPara` dibuja el cobro y no el plan de pagos que tiene al lado.
  - Las piezas implícitas del `Para` usan el color de Entrada/Salida.
  - La simbología no explica el punto de unión.
  - El terminal es una píldora en el capítulo 2 y una elipse en el 4 y el 5, y los «¿…?» de los rombos no son uniformes.
  - En pseudocódigo, el aumento de `k` en el `Trazador` cae en la cabecera, y el flujograma lo dibuja al final.
  - Los `Trazador` de VBA muestran «—» para variables que con `Dim` ya valen 0.
- **Verosimilitud.** El 2 % mensual del E1 de la sección 4 y de la traza de la sección 5 roza la tasa de usura. El 0,9 % mensual del ahorro programado es alto para un producto de ahorro.

---

## 4. Decisiones que necesitan al docente

1. **¿Cuándo se arregla el capítulo 4?** Está publicado y es materia del parcial de hoy. Sus tres graves no afectan al banco, pero G4.1 enseña algo falso sobre Python. Arreglarlo en `main` hoy o después del parcial es decisión suya.
2. **¿Se añade contenido nuevo al capítulo 5?** Hay cuatro propuestas:
   - un E2 sobre `Para` por lenguaje en la sección 4;
   - un flujograma anidado en la sección 5;
   - un gráfico o traza del acumulador en la sección 1;
   - rehacer el E4 de la sección 3 con una condición compuesta.

   Cambian la cuota y el plan, así que no las hago sin su visto bueno.
3. **¿Entran L1, L3, L4 y L5 en la tarea de deudas P3?** Son de la librería: barajado, coma de miles, `not-prose` y variables efímeras. Con H17 serían nueve deudas.
4. **Las tasas.** ¿Se ajustan el recargo del 5 % del capítulo 4 y los dos tipos del capítulo 5, o se declaran ilustrativos con una nota?
