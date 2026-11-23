# Plan · Tarea 16 — Capítulo 6, «Entorno de programación VBA»

**Fecha:** 2026-11-23. **Estado:** borrador para el punto de control 0. Nada de lo que
sigue está aprobado.

**Archivo:** `Material html/06_LPF_Entorno_VBA.html`. **No existe.** Es el primer capítulo
que se escribe con la gestión documental ya montada: los cinco anteriores se escribieron
primero y se les buscaron las fuentes después.

**Nombre del plan.** Los archivos de plan van numerados en serie (del 6 al 15); este es
el 16. El plan maestro llama «Tarea 11» a este capítulo, y ese número ya lo usa el plan
de contenido del capítulo 1; aquí se dice «capítulo 6» y no «Tarea 11».

**Modelos:** `PLAN_TAREA10_CAPITULO_05.md` para escribir un capítulo desde la plantilla y
`PLAN_TAREA15_CAPITULO_05_CONTENIDO.md` para las fuentes. Este plan funde los dos: cada
sección se escribe una sola vez, ya con sus citas.

---

## 0. Qué se decidió antes de planificar

No se reabren: Zotero como autoridad, APA 7 generado, solo se cita lo leído, las seis
clases de afirmación, los ejercicios de interpretación E1–E8, la librería LP-CORE
estampada y la paleta institucional.

Sí se reabre, porque este capítulo lo obliga (decisión 1 de §3): «todo el código en
cuatro lenguajes en paralelo».

### Datos del syllabus, textuales

Fila «Entorno de programación VBA» de `Syllabus Logica de Programacion Financiera.xlsx`:

| Campo | Texto |
|---|---|
| Contenido | Entorno de programación VBA |
| Estrategia | Charla tutorial "Entorno de programación VBA" |
| Horas | 12 horas |
| Evaluación | Plataforma Moodle Entorno de Programación VBA juego en Moodle. |
| Recurso | URL del video "Entorno de programación" |

El syllabus pone Arrays antes que Entorno VBA. El plan maestro los invierte (decisión D6)
y pide declararlo en la portada del capítulo 6 (riesgo R6).

### Lo que dice el plan maestro (§5, capítulo 6)

Siete secciones: (1) por qué VBA en finanzas, (2) el editor VBE, (3) `Sub`, declaración y
`Option Explicit`, (4) tipos de datos y `Currency`, (5) `Range`, `Cells`, `ActiveSheet` y
por qué es lento, (6) depuración con puntos de interrupción, F8 y Locales, (7) errores,
seguridad de macros y buenas prácticas. Tres artefactos: `SimuladorVBE`,
`MapaObjetosExcel`, `RendimientoRangeVsArray`. Ocho cloze de Moodle. Y una nota: declarar
Excel 365 para Windows como referencia y avisar dónde Mac difiere.

## 1. Estado medido (2026-11-23, `main` en `1e1d37e`)

| Qué | Medida |
|---|---|
| Archivo del capítulo | no existe; `lp-base.html` tiene 3 831 líneas y trae la demostración entera |
| Fuentes de VBA en Zotero, leídas | 9 páginas de Microsoft (`Dim`, `For...Next`, `Integer`, `Double`, `Currency`, desbordamiento, `And`, `Hex`, prioridad de operadores) |
| Especificación MS-VBAL | leída en parte (5.6.9), **sin importar a Zotero** todavía |
| Los tres libros de VBA del syllabus (Amelot 2007, Roman 2002, Walkenbach 2010) | en Zotero **solo con metadatos**: nadie los ha leído y no hay PDF |
| Excel disponible para ejecutar | Excel para Mac 16.115, el del docente |
| Notas del vault para el capítulo | ninguna; no hay `Cap 06` en `Vault/Capítulos/` |
| Banco Moodle del capítulo | no existe `rmd/cap06` |

Cuánto de este capítulo ya escribió el estudiante en los cinco anteriores (apariciones en
el contenido, fuera de LP-CORE):

| | Cap. 1 | Cap. 2 | Cap. 3 | Cap. 4 | Cap. 5 |
|---|:-:|:-:|:-:|:-:|:-:|
| `Currency` | 23 | 17 | 48 | 25 | 42 |
| `Debug.Print` | 25 | 18 | 44 | 18 | 42 |
| `Option Explicit` | 0 | 5 | 0 | 12 | 18 |
| `MsgBox` / `InputBox` | 0 | 7 | 2 | 2 | 25 |
| `Range(` | 3 | 4 | 6 | 4 | 0 |
| `Select Case` | 0 | 0 | 0 | 11 | 0 |

## 2. Hallazgos

### H1 · El estudiante lleva cinco capítulos escribiendo VBA que nadie le explicó

No llega en blanco. Ha leído `Dim cuota As Currency` unas 155 veces y `Debug.Print` unas
147, y nunca vio dónde se escribe eso ni por qué va así. El capítulo no presenta VBA:
explica lo que ya se usó. Eso cambia el tono de las secciones 3 y 4 y da los ejemplos:
salen de los capítulos anteriores, con remisión, y no de casos nuevos.

### H2 · Las promesas hechas al capítulo 6 son contrato

Localizadas hasta ahora, por mención expresa:

| De dónde | Qué promete | Sección que la cumple |
|---|---|---|
| Cap. 1, sección 4 (cinco lugares: caso, tabla, recuadro «Por qué el capítulo 6 usará Currency», pregunta del cuestionario) | Por qué el dinero va en `Currency` y no en `Double`; punto fijo de 4 decimales | 4 |
| Cap. 1, sección 2 | La macro que llega de fuera es un programa: «el capítulo 6 lo mira de cerca» | 7 |
| Cap. 1, convenciones | El VBA «vivirá» en el editor de Excel a partir del capítulo 6 | 2 |
| Cap. 4, sección 5 | `Select Case` con `To` e `Is`: «el capítulo 6 vuelve sobre esto» | por decidir (ninguna sección del plan maestro lo recoge) |
| Cap. 5, «Lo que viene» | F8 y la ventana Locales hacen las trazas; por qué `Dim` deja 0; `Currency` | 6, 3 y 4 |
| Plan maestro (cierre del cap. 5) | Las dos rarezas de `Debug.Print`: el espacio del signo y las zonas de 14 columnas | 2 |

El inventario completo es la primera tarea de la fase 1: además de las menciones
expresas, hay que barrer las que no dicen «capítulo 6» («más adelante», «se verá»). En el
vault hay tres hilos abiertos y uno colgante que se cierran al escribir cada sección.

Una promesa no tiene sección: la de `Select Case`. O se le da un lugar (cabe en la 3,
como ejemplo de «del algoritmo al código») o se corrige la frase del capítulo 4.

### H3 · El formato de cuatro lenguajes no cabe en cinco de las siete secciones

La regla 4 de `verificar.py` exige que cada `CodeTabs` traiga pseudocódigo, Python, R y
VBA. Un `Range("B2").Value = cuota`, un punto de interrupción o un `On Error GoTo` no
tienen equivalente en pseudocódigo ni en R. El propio capítulo 5 ya lo anuncia: «pone a
VBA al frente y deja el pseudocódigo en segundo plano». Es la decisión 1.

Consecuencia para las herramientas, sea cual sea la decisión: `ejecutar_salidas.py` solo
audita bloques multilingües, y `ejecutar_vba.py` arma su módulo desde ellos. Un bloque de
solo VBA con `'>` hoy no lo comprueba nadie (trampa 7 de la skill). Hay que medir qué
hace `ejecutar_vba.py` con un bloque de un solo lenguaje y, si no lo ve, enseñárselo, con
su prueba negativa.

### H4 · La referencia es Windows y el único Excel para ejecutar es de Mac

El plan maestro declara Excel 365 para Windows. Todo el VBA de los capítulos 1 a 5 se
ejecutó en el Excel para Mac del docente. En un capítulo sobre el *entorno* la diferencia
pesa más que en los anteriores: atajos de teclado, menús, el Centro de confianza, y lo
que el editor de Mac trae o no trae. Lo que no se pueda ejecutar ni ver en un Excel real
no se puede afirmar como «ejecutado». Es la decisión 2.

### H5 · Las fuentes citables son, hoy, solo las páginas de Microsoft

Los tres libros del syllabus dedicados a VBA están sin leer. Sin un PDF o un ejemplar, no
se citan: van a «Para profundizar». Lo que sostiene el capítulo es la documentación de
Microsoft Learn (abierta, se puede leer) y MS-VBAL. Faltan por leer e importar, a ojo,
entre 15 y 20 páginas: `Option Explicit`, resumen de tipos de datos, `Variant`, `Sub`,
alcance y visibilidad, `Range`, `Cells`, `Worksheet`, modelo de objetos, ventana
Inmediato y `Debug.Print`, ventana Locales, puntos de interrupción y paso a paso,
`On Error`, objeto `Err`, seguridad de macros, `ScreenUpdating`, `Select Case` y las
diferencias de Office para Mac. Importar a Zotero pide su aprobación (decisión 3).

### H6 · La sección 1 no tiene fuente posible en Zotero

«Excel como plataforma de cálculo del sector» es una afirmación sobre el sector
financiero. No hay en Zotero nada que la respalde, y no se rellena. Dos salidas que sí
caben en la política: redactarla como remisión al syllabus (el resultado de aprendizaje
habla del «lenguaje de programación utilizado por las empresas del sector financiero») y
como criterio del docente. Si usted tiene una fuente del sector, se lee y se cita.

### H7 · `RendimientoRangeVsArray` necesita tiempos medidos, y adelanta el capítulo 7

La gráfica compara escribir celda por celda con escribir en bloque. Los tiempos tienen
que salir de una ejecución real, declarada como tal (en qué equipo, qué Excel, cuántas
celdas), o la gráfica es ilustrativa y lo dice. Además, leer un rango a un arreglo es la
sección 6 del capítulo 7: aquí solo se muestra la diferencia y se remite.

### H8 · El `SimuladorVBE` es la pieza más cara y la más arriesgada

Reproducir el editor con ventana de código, Locales y F8 es un componente local grande.
El plan maestro dice que «cierra el círculo con el `Trazador`» de LP-CORE. Hay que medir
en la fase 1 si el `Trazador` da el motor tal cual (recibe `codigo`, `variables` y
`pasos`) o si hace falta tocar la librería; si hay que tocarla, se propaga a los cinco
capítulos publicados y eso se decide aparte. Cada paso que el simulador muestre se
obtiene ejecutando la rutina con F8 en Excel, no escribiéndolo.

### H9 · La evaluación del syllabus es un juego, no un cuestionario

El syllabus dice «juego en Moodle»; el plan maestro, ocho cloze. En el capítulo 5 el
juego se alimentó de cloze. El banco no se toca sin su orden: la fase del banco deja
borradores en el vault, como en los capítulos anteriores, salvo que usted diga otra cosa.

### H10 · Lo aprendido en cinco capítulos se aplica desde la primera línea

Sin esperar a una auditoría: espacio duro en las cifras, fuente en cada figura y tabla
(regla 30), nota en el vault antes de cada `<Cita>` (regla 31), `<Ilustrativo>` en lo
inventado, verificador sin contexto antes de registrar una cita, y cada cifra de la prosa
ejecutada.

## 3. Decisiones que le pido

1. **Los cuatro lenguajes en este capítulo.** Recomiendo: cuatro lenguajes donde hay un
   algoritmo (secciones 3 y 4, y los ejemplos que vienen de capítulos anteriores), y
   bloques de solo VBA donde el código habla con Excel (secciones 2, 5, 6 y 7), con una
   frase en la portada que lo diga. Alternativa: mantener los cuatro en todo, con
   Python y R haciendo «lo equivalente» sobre un archivo; alarga el capítulo y enseña
   otra cosa.
2. **La plataforma de referencia.** Recomiendo: escribir contra lo que se puede ejecutar
   y ver (Excel para Mac 16.115) y marcar con un aviso cada punto donde Windows difiere,
   citando la documentación de Microsoft. Alternativa: mantener Windows como referencia
   si usted puede darme acceso a un Excel de Windows o hacer usted esas capturas y
   ejecuciones. Necesito saber qué usan sus estudiantes en la sala.
3. **Importar a Zotero las páginas de Microsoft** que se lean en la fase 1 (la lista
   exacta se la presento antes de importar).
4. **Los tres libros de VBA del syllabus.** ¿Tiene alguno en PDF o en físico? Si no,
   van a «Para profundizar» sin citarse.
5. **La promesa de `Select Case`** del capítulo 4: darle un lugar en la sección 3
   (recomendado) o corregir la frase del capítulo 4.
6. **La sección 1**: remisión al syllabus y criterio del docente (recomendado), o una
   fuente del sector que usted aporte.
7. **Las siete secciones del plan maestro**, ¿se mantienen tal cual? Recomiendo
   mantenerlas; el único ajuste que veo es llevar la seguridad de macros al principio de
   la sección 2 como aviso corto (el estudiante la encuentra al abrir su primer archivo
   `.xlsm`) y desarrollarla en la 7.
8. **El banco de Moodle**: borradores en el vault, sin copiar (recomendado, como en el
   capítulo 5), o escribir directamente en `Banco Moodle/rmd/cap06`.

## 4. Fases

Una rama por fase, cada una sobre la anterior. Nada se fusiona a `main` hasta el cierre.

### Fase 0 — Plan · ⏸ punto de control 0 (este documento)

### Fase 1 — Inventario, fuentes y archivo

- Inventario completo de promesas al capítulo 6 en los capítulos 1 a 5, con línea, y
  nota de hilo por cada una.
- Lectura de las páginas de Microsoft de H5; pasajes copiados al vault con su
  localizador; lista para importar a Zotero.
- Ficha `Cap 06` en el vault y conceptos que el capítulo define o hereda.
- Crear el archivo desde `lp-base.html`, retirar la demostración de una vez, `CONFIG`
  contra la fila del syllabus, `curriculum` con las siete secciones y sus iconos.
- Medir H3 (qué hace `ejecutar_vba.py` con un bloque de solo VBA) y H8 (si el `Trazador`
  sirve de motor).

⏸ **Punto de control 1:** inventario, lista de fuentes para importar, esqueleto del
archivo en verde y resultado de las dos medidas.

### Fase 2 — Los tres artefactos

`SimuladorVBE`, `MapaObjetosExcel`, `RendimientoRangeVsArray`, locales del capítulo, con
datos ejecutados en Excel. Sonda de navegador a 320 y 375 px.

⏸ **Punto de control 2:** los tres funcionando en el navegador.

### Fases 3 a 9 — Una sección por fase

Sección 1 a sección 7, en orden. Cada fase entrega la sección terminada: motivación,
texto con sus citas ya verificadas, código ejecutado en Excel, ejercicios probados hasta
el veredicto, figuras con fuente, notas del vault y registro de afirmaciones.

⏸ **Punto de control tras la sección 2** (tono y densidad, antes de escribir el resto) y
⏸ **uno por sección** a partir de ahí, como en el capítulo 5.

### Fase 10 — Portada, evaluación, glosario y cierre

Portada con la desviación del syllabus declarada (R6), cuestionario final de diez
respondido entero, glosario, «Lo que viene» cotejado con el plan del capítulo 7.

### Fase 11 — Coherencia hacia atrás, banco y teléfono

- Cada promesa de H2 cotejada con lo escrito; las frases de los capítulos 1 a 5 que ya
  no casen se corrigen (el capítulo 5 dice hoy que el 6 «todavía no está escrito»).
- Borradores del banco (decisión 8).
- Todo el VBA ejecutado en Excel; sondas en los cinco modos; recorrido en el iPhone,
  esta vez de las nueve lecciones.
- `index.html` enlaza el capítulo 6.

### Fase 12 — Lectura crítica final y fusión

Lectura independiente del capítulo entero y verificación independiente de todas las
citas, corrección de lo que salga, bitácora, y ⏸ **punto de control final**: su lectura,
la fusión a `main` y cuándo se sube.

## 5. Cuota de ejercicios — distribución tentativa

| | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| Cuota del curso | 3–4 | 2–3 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 |

Fijos por el plan maestro: E3 del nombre mal digitado sin `Option Explicit` (sección 3),
E8 de `Currency` frente a `Double` (sección 4) y E6 objeto–propiedad–método (sección 5 o
evaluación). Los E1 salen de la depuración con F8 (sección 6). El reparto fino se fija en
el punto de control 1.

## 6. Riesgos

| | Riesgo | Qué se hace |
|---|---|---|
| R1 | Afirmar del entorno de Windows algo que no se vio | Decisión 2; lo no visto se cita a Microsoft o no se dice |
| R2 | Capítulo sin fuentes bibliográficas, solo documentación del fabricante | Decisión 4; se declara en la ficha del capítulo |
| R3 | El `SimuladorVBE` obliga a tocar LP-CORE | Se mide en la fase 1 y se decide en el punto de control 1 |
| R4 | Bloques de solo VBA sin auditar | H3: la herramienta se amplía antes de escribir el primero |
| R5 | El control de pantalla de Excel exige que usted esté presente | Las ejecuciones en Excel se agrupan al final de cada fase y se le piden de una vez |
| R6 | Otras sesiones trabajan en el repositorio | `git add` con rutas explícitas; rama propia |

## 7. Lo que este plan no hace

- No toca el banco de Moodle ni Moodle sin su orden.
- No cambia LP-CORE sin decidirlo en un punto de control.
- No escribe los capítulos 7 ni 8; registra lo que el 6 les promete.
- No resuelve la decisión D09 (índice de los arreglos), que es del capítulo 7.
