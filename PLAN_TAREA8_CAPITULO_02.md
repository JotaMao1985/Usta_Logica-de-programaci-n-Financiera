# Plan · Tarea 8 — Capítulo 2, «Introducción a Algoritmos»

**Rama:** `cap02/algoritmos` · **Alcance:** M · **Estado:** pendiente de aprobación

Corresponde a la Tarea 8 del plan maestro (§6, Fase 2) y desarrolla su §5,
«Capítulo 2 — Introducción a Algoritmos». Es el **primer capítulo escrito desde
cero** con la skill `lpf-capitulo`: el capítulo 1 se adaptó de material previo y
el 3 todavía no existe.

---

## 0. Qué se decidió antes de planificar

| Decisión | Valor | De dónde sale |
|---|---|---|
| Base de la rama | `lp-core/gramaticas-de-resaltado`, no `main` | El capítulo necesita los tres campos nuevos de `CONFIG` (`asignatura`, `lema`, `notaPie`) que `migrar.py` inserta en el andamio, y esos commits todavía no están en `main` (PR #1). Ramificar de `main` obligaría a rellenarlos a mano y a rehacerlo al fusionar |
| Nombre del archivo | `Material html/02_LPF_Algoritmos.html` | La convención `NN_LPF_Nombre.html` que `migrar.py` sabe leer (`config_para`) |
| `storageKey` | `lpf_cap02_algoritmos` | Lo deriva `migrar.py` del nombre del archivo |
| Pestaña por defecto | `pseudo` | §2 bis, regla 2: capítulos 1–5 |
| Énfasis | Pseudo ●●● · Python ● · R ● · VBA ● | §2 bis, «Énfasis por capítulo». Es el capítulo del **flujograma**: los otros tres lenguajes acompañan, no compiten |
| El banco cloze **no** se versiona | `Banco Moodle/` está en `.gitignore` | Contiene las claves de los cuestionarios evaluables. El trabajo se hace y se verifica, pero no entra en el commit |

### Datos del syllabus, textuales

Extraídos de `Syllabus Logica de Programacion Financiera.xlsx`, fila 32:

| Campo | Valor |
|---|---|
| `contenidoSyllabus` | `INTRODUCCIÓN A ALGORITMOS` |
| `horas` | 4 |
| `ra` | RA1 — «Construye un algoritmo computacional incorporando variables de tipo financiero cuya solución lo pueda hacer una calculadora o una computadora» |
| Entregable | Cuestionario «Algoritmos» en Moodle |
| Recursos | «Designing an algorithm» y la lectura «Introducción a Algoritmos 1 (TI)» |

⚠️ El plan maestro dice que la sección 2 «corresponde al *Formato Definición y
Análisis* que el syllabus exige como entregable». **Ese entregable es de la fila
33 (Control secuencial), no de la 32.** La sección 2 de este capítulo *prepara*
ese formato; no lo entrega. Se redacta con esa precisión.

---

## 1. Estado medido

```
git rev-parse HEAD                 51712c7 (cap02/algoritmos, nace de lp-core/…)
verificar.py --con-salidas         OK · 1 capítulo · 13 ejercicios
ensamblar.py                       idempotente (SHA df53a57b… antes y después)
LP-CORE de referencia              9cc19ee3e3e1ce33…
capítulos en Material html/        1  (01_LPF_Introduccion.html)
Icons disponibles                  15 de sección + 2 de navegación
Rscript / exams                    /opt/homebrew/bin/Rscript · exams 2.4.3
```

---

## 2. Hallazgos

### H1 · El ciclo de la skill no cubre el paso 0: crear el archivo

El ciclo de `lpf-capitulo` arranca en `migrar.py --dry-run 0N_LPF_Nombre.html`,
pero `migrar.py` **localiza anclas sobre un archivo que ya existe** (`const {
useState… }`, `const App = () => {`, `root.render(<App />)`). Sobre un archivo
inexistente no hace nada: no es un generador.

El paso que falta está en `Material html/README.md` («copiar
`_plantilla/lp-base.html`, cambiar el objeto `CONFIG`…») pero no en la skill, que
es justamente la que se consulta para escribir un capítulo nuevo.

**Consecuencia para este plan:** la Tarea 1 es `cp lp-base.html
02_LPF_Algoritmos.html`. **Consecuencia para la skill:** le falta ese paso.

### H2 · Copiar `lp-base.html` trae el capítulo de demostración entero

`lp-base.html` no es un esqueleto vacío: son 2812 líneas que incluyen el
`CONFIG` de la plantilla (`numero: '00'`, `titulo: 'Plantilla base'`), los
ejemplos `EJ_INTERES` y `EJ_ACUMULADOR`, las tres secciones de demostración con
un ejercicio de cada tipo, la evaluación y el glosario.

Escribir el capítulo 2 es, entonces, **sustituir** ese contenido, no partir de
una página en blanco. Es una ventaja —el andamio de cada componente ya está
puesto y correctamente formado— pero exige una comprobación explícita al
cerrar: que no sobreviva ni una línea de la demostración. Se añade a las puertas
(«Tarea 12 · Barrido de residuos de la plantilla»).

Ojo también con la **cuota**: la plantilla trae exactamente un ejercicio de cada
tipo E1–E8, de modo que `verificar.py` puede dar **verde con contenido ajeno**.
Un verde temprano no significa nada hasta que se haya hecho ese barrido.

### H3 · `migrar.py` no toca `CONFIG` si ya existe — y aquí existirá

`estampar()` inserta el andamio de `CONFIG` **solo si no encuentra** `const
CONFIG = {`. Como la copia de `lp-base.html` lo trae, `migrar.py` lo respetará y
lo dejará diciendo «Plantilla base, capítulo 00, 0 horas». No habrá ningún
`TODO` que `grep` encuentre.

El paso 3 del ciclo de la skill (`grep -n TODO`) **no sirve en este camino**. El
`CONFIG` hay que reescribirlo a mano, contra la fila 32 del syllabus, y
verificarlo leyéndolo. Se registra como Tarea 2 con criterio de aceptación
propio.

### H4 · La trampa 6 de la skill está desactualizada

Dice «Solo hay siete iconos y añadir uno exige tocar la librería». Hoy hay
**diecisiete**: siete en el `Icons` base (`BookOpen`, `Binary`, `Cpu`,
`Calculator`, `Award`, `ChevronLeft`, `ChevronRight`) y diez más que
`lp-core-extra.jsx` fusiona con `Object.assign` (`Workflow`, `ArrowDownUp`,
`GitBranch`, `Repeat`, `FileCode`, `Grid`, `FunctionSquare`, `Bug`, `Table`,
`Layers`).

La consecuencia práctica se invierte: el capítulo 2 **no necesita reutilizar
ningún icono**, y el comentario justificativo que el capítulo 1 dejó junto a su
`Binary` repetido no hace falta aquí. El fondo de la trampa —no ampliar la
librería por un capítulo— sigue siendo válido.

### H5 · La puerta de los «~367 px» no es reproducible

La skill pide, entre las puertas: «A 375 px: ~367 px de contenido, sin desborde
horizontal». Medido hoy sobre el capítulo 1 —que es la referencia— a 375 px:

```
aside      0 px   (colapsada, correcto: solo abre desde lg)
main     375 px
.prose-lp 319 px
scrollWidth del documento 375 px → sin desborde
```

Ni 367 ni nada cercano. El criterio útil —**sin desborde horizontal**— sí se
sostiene y es el que se comprueba; la cifra concreta no corresponde a ninguna
medida actual y confunde más de lo que ayuda. Se propone sustituirla en la skill
por «`document.documentElement.scrollWidth` igual al viewport».

El capítulo 2 mide exactamente lo mismo que el 1 en las tres cifras.

### H6 · Una pregunta con dos respuestas correctas es inacertable sin `multiple: true`

Descubierto **respondiendo** el cuestionario del capítulo con las diez respuestas
buenas y obteniendo **9 de 10**.

`Quiz` decide con `toggle(qi, oi, q.multiple)` cómo se comporta la selección: sin
la bandera, la segunda elección **reemplaza** a la primera, mientras `esCorrecta`
sigue exigiendo `sel.length === correctSet.length`. Una pregunta con dos
`correcta: true` y sin bandera no se puede acertar. Se pinta bien, se responde, y
el veredicto es «incorrecto» sin explicar nada.

No lo veía ninguna comprobación. Ahora sí: **regla 12 de `verificar.py`**, con su
prueba negativa (falla con código 1 al reintroducir el defecto, pasa con 0 al
quitarlo). El capítulo 1 se revisó y está limpio.

De propina, un hallazgo dentro del hallazgo: la primera versión de la regla **no
encontraba nada**, porque el comentario que escribí para explicar la bandera
contiene literalmente `multiple: true` y eso bastaba para darla por satisfecha.
Lo cazó su propia prueba negativa. La regla ahora sustituye los comentarios por
espacios —no los borra— antes de mirar, para no falsear el número de línea.

### H7 · No se puede medir el foco de teclado en este panel

Al probar `CuatroRepresentaciones` con teclado, `.focus()` movía
`document.activeElement` pero **no se disparaba ningún evento de foco**. La
primera lectura fue que un `<g>` de SVG no los emite; es falsa. La causa real es
que `document.hasFocus()` es `false` —el panel no tiene el foco del sistema— y
entonces Chrome no despacha eventos de foco **para ningún elemento**, ni HTML ni
SVG.

Consecuencia práctica: el camino de teclado se verifica despachando
`focusin`/`focusout` con `bubbles: true`, que es lo que el navegador emitiría y
lo que React escucha. Verificado así: resalta los tres paneles y los limpia.

### H8 · El artefacto más caro es `CuatroRepresentaciones`

De los tres artefactos que pide el plan maestro, dos son estáticos
(`SimbologiaANSI` es una tabla SVG; `AsignacionPasoAPaso` es un `useState` sobre
cuatro casilleros). El tercero pide **resaltado sincronizado**: al pasar el
cursor por una línea del pseudocódigo se ilumina el bloque correspondiente del
flujograma.

Es lo único del capítulo que no tiene precedente en el material. Va **primero**
y **aislado** (Tarea 6), antes de escribir la sección que lo usa, para que un
tropiezo ahí no deje media sección escrita alrededor de un componente que hay
que rehacer.

---

## 3. Grafo de dependencias

```
T1 archivo copiado
 └── T2 CONFIG + curriculum (7 secciones, iconos)
      ├── T3 §1 Qué es un algoritmo          ── E8·1  E2·1
      ├── T4 §2 Entrada–Proceso–Salida       ── E1·1  E5·1
      │
      ├── T5 SimbologiaANSI  ─┐
      ├── T6 CuatroRepresentaciones ─┴── T7 §3 Cuatro representaciones ── E6·1  E3·1
      │
      ├── T8 AsignacionPasoAPaso ── T9 §4 Variables y asignación ── E1·2  E1·3  E2·2  E3·2
      ├── T10 §5 Nociones de eficiencia      ── E4·1  E7·1
      └── T11 Portada y evaluación           ── E7·2  Quiz 10
           └── T12 Barrido de residuos de la plantilla
                └── T13 Auditoría: verificar.py --con-salidas + navegador + 375 px
                     └── T14 Banco cloze (6) — NO se versiona
                          └── T15 Bitácora §11 y cierre
```

Las secciones (T3, T4, T7, T9, T10, T11) son **independientes entre sí**: cada
una es una rebanada vertical completa —motivación + código en los cuatro
lenguajes + sus ejercicios— y se termina antes de abrir la siguiente. Es el
reparto que la skill recomienda («una tarea = una sección terminada») y el que
evita recorrer el capítulo tres veces.

---

## 4. Tareas

### Fase 1 — Andamio · ✅ COMPLETADA (2026-08-09)

#### Tarea 1 · Crear el archivo del capítulo

**Descripción:** copiar la plantilla y comprobar que el LP-CORE queda idéntico.

**Criterios de aceptación**
- [ ] Existe `Material html/02_LPF_Algoritmos.html`
- [ ] `migrar.py --dry-run` sobre él informa «ya estaba al día — no hubo cambios»
- [ ] El SHA-256 de su bloque LP-CORE coincide con el de `lp-base.html`

**Verificación:** `python3 "Material html/_plantilla/migrar.py" --dry-run "Material html/02_LPF_Algoritmos.html"`

**Dependencias:** ninguna · **Alcance:** XS (1 archivo)

---

#### Tarea 2 · `CONFIG` y `curriculum`

**Descripción:** reescribir el `CONFIG` de la plantilla con la fila 32 del
syllabus y declarar las siete secciones del capítulo con sus iconos.

`curriculum` objetivo:

| id | Título | Icono |
|---|---|---|
| `portada` | Portada y objetivos | `BookOpen` |
| `cap1` | 1. Qué es un algoritmo | `Workflow` |
| `cap2` | 2. Entrada, proceso y salida | `ArrowDownUp` |
| `cap3` | 3. Cuatro representaciones | `FileCode` |
| `cap4` | 4. Variables y asignación | `Layers` |
| `cap5` | 5. Dos algoritmos correctos | `Repeat` |
| `eval` | Evaluación y glosario | `Award` |

**Criterios de aceptación**
- [ ] `CONFIG` no contiene ni «Plantilla base», ni `numero: '00'`, ni `horas: 0`
- [ ] `contenidoSyllabus` es textual: `INTRODUCCIÓN A ALGORITMOS`
- [ ] Los siete iconos existen en el catálogo (ninguno se reutiliza — H4)
- [ ] La barra lateral pinta las siete secciones y navega entre ellas

**Verificación:** abrir el capítulo servido y recorrer las siete secciones con
*Siguiente*; consola limpia.

**Dependencias:** T1 · **Alcance:** S

---

### ✅ Punto de control 1 — Andamio · superado el 2026-08-09

- [x] El capítulo abre, navega y no dice ser la plantilla
- [x] `verificar.py --sin-cuota` en verde sobre los dos capítulos
- [ ] **Se revisa con el docente antes de escribir contenido** ← pendiente

**Medido**

```
migrar.py --dry-run 02_LPF_Algoritmos.html   «ya estaba al día» → LP-CORE intacto
verificar.py --sin-cuota                     OK 01 (13 ejercicios) · OK 02 (0)
residuos de la plantilla                     0 de 15 términos buscados
secciones en la barra lateral                7, cada una con su icono propio
consola del navegador                        limpia (solo los 2 avisos de CDN)
a 375 px                                     aside 0 · main 375 · prose 319 · sin desborde
```

**Decisión tomada dentro de la tarea 2:** al reemplazar la región de contenido
se eliminó de una vez el capítulo de demostración completo (745 líneas), en vez
de dejarlo para la tarea 12. Sale más barato —era el mismo tramo de texto— y
retira antes el riesgo alto de H2. La tarea 12 pasa de *retirar* a *confirmar*.

**Estado de las secciones:** las siete llevan su `<Motivacion>` con el **gancho
definitivo** —que es la decisión editorial que se revisa aquí— y el cuerpo
marcado con `PENDIENTE-FASE2`. Son 14 marcadores; ninguno debe sobrevivir a la
tarea 12, y por eso el barrido busca además `<Pendiente` y `const Pendiente`.

---

### Fase 2 — Contenido, sección por sección · ✅ COMPLETADA (2026-08-09)

#### Tarea 3 · §1 · Qué es (y qué no es) un algoritmo

**Descripción:** las cinco propiedades —precisión, finitud, definición, entrada
y salida— presentadas por contraste: qué le falta a una receta de cocina, a una
instrucción de un manual, a un procedimiento bancario mal escrito. El
`CodeTabs` de la sección es el mismo algoritmo elemental en los cuatro
lenguajes, para fijar de entrada que la lógica es una y las notaciones cuatro.

**Ejercicios:** **E8·1** (el de bandera del plan maestro: «esta receta dice *sal
al gusto*, ¿es un algoritmo?») y **E2·1**.

**Criterios de aceptación**
- [ ] Abre con `<Motivacion>` de ≤80 palabras: escena + tensión + gancho
- [ ] El gancho es el previsto en §4 bis: «Dos algoritmos correctos para el mismo
      problema, y uno tarda mil veces más»
- [ ] Un `CodeTabs` con los cuatro lenguajes, salidas `//>` `#>` `#>` `'>`
- [ ] El E8 exige nombrar **cuál** de las cinco propiedades se viola, no solo
      responder sí/no

**Verificación:** `verificar.py --sin-cuota`; conducir el E8 en el navegador
hasta revelar la solución.

**Dependencias:** T2 · **Alcance:** M

---

#### Tarea 4 · §2 · Entrada, proceso y salida

**Descripción:** el análisis EPS como método para pasar del enunciado al
algoritmo. Caso: liquidación de la cuota de un crédito de libre inversión.
Prepara —no entrega— el *Formato Definición y Análisis* del capítulo 3.

**Ejercicios:** **E1·1** (traza del algoritmo de liquidación) y **E5·1**
(reconstruir el algoritmo de liquidación desordenado — el que pide el plan
maestro).

**Criterios de aceptación**
- [ ] `<Motivacion>` propia
- [ ] La tabla EPS distingue **dato de entrada** de **constante del negocio**
- [ ] `TablaTraza` con los valores ejecutados, no supuestos
- [ ] `OrdenaPasos` con los cuatro lenguajes en `pasos`

**Verificación:** `verificar.py --sin-cuota`; resolver el E1 y el E5 en el
navegador, **incluida una respuesta incorrecta** en cada uno.

**Dependencias:** T2 · **Alcance:** M

---

#### Tarea 5 · Artefacto `SimbologiaANSI`

**Descripción:** tabla SVG de los seis símbolos ANSI del flujograma (terminal,
entrada/salida, proceso, decisión, conector, línea de flujo). Cada símbolo es
clickeable y despliega su función y un fragmento de pseudocódigo equivalente.

**Criterios de aceptación**
- [ ] Vive en el capítulo, no en LP-CORE (trampa 5)
- [ ] `role="img"` y `<title>` descriptivo en el SVG
- [ ] Legible a 375 px sin desborde horizontal
- [ ] Ningún color nuevo sin medir contraste sobre `#F8FAFC`

**Verificación:** `verificar.py` (reglas 3 y 10); inspección a 375 px.

**Dependencias:** T2 · **Alcance:** S

---

#### Tarea 6 · Artefacto `CuatroRepresentaciones` ← **el de riesgo**

**Descripción:** el mismo algoritmo —interés simple— en las cuatro formas:
lenguaje natural, pseudocódigo, flujograma SVG y código. Al pasar el cursor por
una línea del pseudocódigo se ilumina el bloque correspondiente del flujograma,
y a la inversa.

**Decisiones de diseño**
- El estado sincronizado es **un solo** `useState` con el id del paso resaltado;
  ambos lados leen de ahí. No hay dos fuentes de verdad.
- El resaltado se activa con `onMouseEnter` **y** con `onFocus`, y los bloques
  del flujograma son `<g tabIndex={0}>`: sin eso el artefacto no existe para
  quien navega con teclado, ni en táctil.
- La pata «código» es un `CodeTabs` normal de cuatro lenguajes. No se le añade
  sincronización: sería un cuarto eje de estado por una ganancia marginal.

**Criterios de aceptación**
- [ ] Resaltar en un lado ilumina el otro, en ambos sentidos
- [ ] Funciona con teclado (`Tab` recorre los bloques) y en táctil
- [ ] A 375 px las cuatro representaciones se apilan sin desborde
- [ ] Consola limpia al recorrer los seis pasos

**Verificación:** en el navegador, recorrer los pasos con ratón y con `Tab`;
`read_console_messages` sin errores; medida del ancho del contenido a 375 px.

**Dependencias:** T2 · **Alcance:** M

---

#### Tarea 7 · §3 · Cuatro formas de representar el mismo algoritmo

**Descripción:** la sección que usa T5 y T6. Cierra con el criterio profesional:
cuándo conviene cada representación (el flujograma para acordar la lógica con
quien no programa; el pseudocódigo para evaluarla; el código para ejecutarla).

**Ejercicios:** **E6·1** (emparejar los seis símbolos ANSI con su función — el
que pide el plan maestro) y **E3·1**.

**Criterios de aceptación**
- [ ] `<Motivacion>` propia
- [ ] `Emparejamiento` con `izquierda` por lenguaje y `derecha` sin traducir
- [ ] `DetectaError` con `lineas`, `lineaCorrecta` y `explicacion` **por
      lenguaje**, y `enunciado` **sin citar ningún número de línea**
- [ ] `impacto` redactado en pesos, no en abstracto

**Verificación:** `verificar.py --sin-cuota` (reglas 6 y 8); conducir el E3 en
los cuatro lenguajes y comprobar que la clave cambia con la pestaña —**es el
defecto que la regla 6 existe para cazar y hay que verlo pasar**—.

**Dependencias:** T5, T6 · **Alcance:** M

---

#### Tarea 8 · Artefacto `AsignacionPasoAPaso`

**Descripción:** la memoria como casilleros con nombre. Botones *Paso
siguiente* que ejecutan una secuencia corta de asignaciones —incluido el
intercambio de dos variables con auxiliar— mostrando qué casillero cambia y
cuál conserva su valor. Es el artefacto que hace visible por qué `x <- x + 1`
tiene sentido y `x = x + 1` es falso como ecuación.

**Criterios de aceptación**
- [ ] Avanza, retrocede y reinicia sin quedar en estado inconsistente
- [ ] El casillero que cambia en cada paso se distingue del que no
- [ ] Los valores mostrados coinciden con los de la traza de T9

**Verificación:** recorrer la secuencia completa en el navegador, adelante y
atrás.

**Dependencias:** T2 · **Alcance:** S

---

#### Tarea 9 · §4 · Variables, constantes, tipos y asignación

**Descripción:** el núcleo conceptual del capítulo. Tipos de datos con criterio
financiero: por qué el dinero no es `Double` (anticipa el `Currency` del cap. 6
y retoma el error de redondeo del cap. 1), por qué un plazo es entero, por qué
un identificador de cliente es texto aunque parezca número.

**Ejercicios:** **E1·2** (traza del intercambio con auxiliar), **E1·3** (traza
de un acumulador de comisiones), **E2·2** y **E3·2**.

**Criterios de aceptación**
- [ ] `<Motivacion>` propia
- [ ] La tabla de tipos incluye la columna «qué pasa si se elige mal», con un
      caso monetario concreto
- [ ] Las dos `TablaTraza` tienen valores **ejecutados**
- [ ] El E3 diagnostica un error de **tipo**, no de unidades (ese ya es el del
      capítulo 1: repetirlo desperdicia el ejercicio)

**Verificación:** `verificar.py --sin-cuota`; los dos E1 y el E3 conducidos en
el navegador con una respuesta mala incluida.

**Dependencias:** T8 · **Alcance:** M

---

#### Tarea 10 · §5 · Dos algoritmos correctos no son igual de buenos

**Descripción:** nociones de eficiencia sin notación asintótica —no
corresponde a este curso—: contar operaciones. Caso: buscar un crédito en una
cartera de 40 000 registros recorriéndola entera frente a aprovechar que está
ordenada. La escena que da el gancho del capítulo.

**Ejercicios:** **E4·1** (los dos algoritmos lado a lado) y **E7·1**
(interpretación: qué significa «mil veces más rápido» para un cierre diario).

**Criterios de aceptación**
- [ ] `<Motivacion>` propia
- [ ] El conteo de operaciones se **ejecuta**, no se estima: el `CodeTabs` de
      Python y R imprime el contador y esa salida la comprueba la regla 9
- [ ] `Comparador` con `a.codigo` y `b.codigo` en los cuatro lenguajes
- [ ] El E7 pide una afirmación sobre el negocio, no un recálculo

**Verificación:** `verificar.py --con-salidas` (la regla 9 comprueba el
contador); E4 y E7 conducidos en el navegador.

**Dependencias:** T2 · **Alcance:** M

---

#### Tarea 11 · Portada y evaluación

**Descripción:** portada con la identificación del syllabus y la ruta del
capítulo; evaluación con el cuestionario integrador de 10 preguntas que cruza
las cinco secciones, más el segundo E7 y el glosario.

**Ejercicios:** **E7·2** y el `Quiz` de 10 preguntas.

**Criterios de aceptación**
- [ ] Las dos secciones abren con `<Motivacion>` (también son secciones)
- [ ] La tabla de identificación lee de `CONFIG`, no de literales
- [ ] Las 10 preguntas del `Quiz` cubren las cinco secciones — ninguna queda sin
      representación
- [ ] El glosario define, como mínimo: algoritmo, pseudocódigo, flujograma,
      variable, constante, asignación, entrada/proceso/salida, traza

**Verificación:** responder el `Quiz` entero en el navegador, con aciertos y
fallos, y comprobar el puntaje.

**Dependencias:** T3, T4, T7, T9, T10 · **Alcance:** M

---

### ✅ Punto de control 2 — Contenido completo · superado el 2026-08-09

- [x] Las siete secciones escritas y navegables
- [x] `verificar.py --con-salidas` en verde **con cuota**
- [x] Consola del navegador limpia en las siete

**Medido**

```
verificar.py --con-salidas   OK 01 (13 ejercicios) · OK 02 (13 ejercicios)
cuota del capítulo 02        E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1  ← la planeada
salidas ejecutadas           todas las de Python y R coinciden con lo declarado
residuos de la plantilla     0 de 16 términos · andamio de la fase 1: 0
a 375 px, las 7 secciones    scrollWidth 375 · 0 elementos fuera del viewport
consola                      sin errores
```

**Ejercicios conducidos por DOM** — los trece, con respuesta incorrecta incluida:

| Ejercicio | Comprobado |
|---|---|
| E1·1 traza de la liquidación | 18/18 · y 12/18 con las celdas vacías |
| E1·2 traza del intercambio | 15/15 |
| E1·3 traza de comisiones | 10/10 |
| E2·1 el 3 % escrito como 0.03 | correcta ✓ · incorrecta rechazada ✓ |
| E2·2 intercambio sin auxiliar | correcta ✓ · incorrecta rechazada ✓ |
| E3·1 orden (salida antes del cálculo) | pseudo 4 ✓ · Python 5 ✓ · R 5 ✓ · VBA 8 ✓ · **VBA 4 rechazada** |
| E3·2 tipo (dinero en un entero) | pseudo 4 ✓ · Python 3 ✓ · R 3 ✓ · VBA 4 ✓ · **Python 4 rechazada** |
| E4·1 secuencial contra binaria | correcta ✓ · incorrecta rechazada ✓ |
| E5·1 ordenar la liquidación | «¡Secuencia correcta!» 8/8 |
| E6·1 instrucción ↔ símbolo ANSI | 4 de 4 ✓ · **2 de 4** al intercambiar entrada y salida |
| E7·1 199 millones frente a 60 000 | correcta ✓ |
| E7·2 costo total del crédito | correcta ✓ |
| E8·1 «sal al gusto» | la solución se revela y se oculta ✓ |
| Quiz integrador | **10/10** tras corregir H6 (antes 9/10, inacertable) |

Los dos `DetectaError` son la prueba de que la regla 6 hace falta: la línea 4 es
la clave en pseudocódigo y el ejercicio **la rechaza** en VBA.

---

### Fase 3 — Auditoría · ✅ COMPLETADA (2026-08-09)

#### Tarea 12 · Barrido de residuos de la plantilla · ✅

**Descripción:** comprobar que no sobrevive nada del capítulo de demostración
(H2). Es la tarea que existe porque el verde de `verificar.py` puede venir de
contenido ajeno.

**Criterios de aceptación**
- [ ] `grep` sin resultados para: `Plantilla base`, `cap00`, `Seccion1`,
      `Seccion2`, `Seccion3`, `EJ_ACUMULADOR`, `EJ_INTERES`, `chart-demo-saldo`,
      `TRAZA_CODIGO`, `ERROR_LINEAS`, `CMP_PARA`, `ORDENA_PASOS`,
      `EMPAREJA_IZQ`, `GLOSARIO`, `SaldoChart` — **ya en cero desde la fase 1**,
      aquí solo se confirma que no volvieron
- [ ] `grep` sin resultados para `PENDIENTE-FASE2`, `<Pendiente` y
      `const Pendiente`: el andamio de la fase 1 desaparece por completo
- [ ] Ningún ejercicio del capítulo coincide, ni en enunciado ni en clave, con
      uno de `lp-demo.jsx`
- [ ] El glosario es propio

**Verificación:** el `grep` anterior, y una lectura de los 13 ejercicios contra
los 8 de la plantilla.

**Dependencias:** T11 · **Alcance:** S

---

#### Tarea 13 · Auditoría del capítulo · ✅

**Criterios de aceptación**
- [ ] `verificar.py --con-salidas` en verde, cuota incluida
- [ ] Cada `<CodeBlock>` de un solo lenguaje declara `lang` **explícito**
      (trampa 3: sin él pinta Python con la gramática de pseudocódigo, y no lo
      detecta ninguna regla)
- [ ] Los avisos de contraste están resueltos o indultados con `contraste-ok`
      **y la razón medida en el navegador** (trampa 10)
- [ ] A 375 px: ~367 px de contenido, sin desborde horizontal
- [ ] Los 13 ejercicios que califican, conducidos por DOM hasta el veredicto,
      **con una respuesta incorrecta cada uno**

**Verificación:** los comandos de §8 más la sesión de navegador.

**Dependencias:** T12 · **Alcance:** M

---

### Fase 4 — Banco y cierre

#### Tarea 14 · Los 6 cloze del capítulo 2

**Descripción:** los seis que pide el plan maestro. **No se versionan**
(`.gitignore`), pero se escriben y se verifican.

| Archivo | Tipos | Qué mide |
|---|---|---|
| `propiedades_algoritmo` | mchoice | Cuál de las cinco propiedades viola cada enunciado |
| `entrada_proceso_salida` | schoice ×3 | Clasificar tres elementos de un caso como entrada, proceso o salida |
| `simbolo_ansi` | schoice | Qué símbolo corresponde a una instrucción dada |
| `secuencia_asignaciones` | num | Valor final tras una secuencia con intercambio |
| `contar_operaciones` | num + schoice | Cuántas operaciones hace cada algoritmo y cuál conviene |
| `variable_o_constante` | mchoice | Clasificar seis elementos de un caso financiero |

⚠️ El plan maestro pide `string ×3` para el segundo. **Se propone `schoice ×3`**:
en Moodle un `string` se califica por coincidencia exacta, y «entrada», «Entrada»
y «dato de entrada» son la misma respuesta para un humano y tres distintas para
el motor. Es una desviación del plan y necesita el visto bueno del docente
(§9, pregunta abierta 1).

**Criterios de aceptación**
- [ ] Los seis compilan y validan
- [ ] Todo número que se imprima pasa por `num <- function(x) format(x,
      scientific = FALSE, trim = TRUE)` — trampa 9: sin eso, `exams2moodle`
      aborta de forma **intermitente** cuando el sorteo da ≥ 10⁴, y no dice cuál
      es el ejercicio
- [ ] Cada uno tiene su regla de contenido en `verificar_cloze.R`, comprobada
      **por un camino distinto del que calculó la respuesta**
- [ ] `verificar_cloze.R --reps 1000` en verde
- [ ] Toda regla nueva tiene su **prueba negativa** registrada: se rompe el
      ejercicio a propósito, se ve fallar la regla, se restaura

**Verificación:** `compilar_banco.R --cap 02` y `verificar_cloze.R --reps 1000`.

**Dependencias:** T13 · **Alcance:** M

---

#### Tarea 15 · Bitácora y cierre

**Criterios de aceptación**
- [ ] Entrada nueva en §11 del plan maestro
- [ ] Tarea 8 marcada como completada en §6
- [ ] Los hallazgos H1–H4 llevados a la skill `lpf-capitulo` (paso 0 del ciclo,
      trampa 6 corregida, trampa nueva sobre los residuos de la plantilla)
- [ ] `index.html` de la raíz enlaza el capítulo 2
- [ ] PR a `main`

**Dependencias:** T14 · **Alcance:** S

---

### ✅ Punto de control final

- [ ] Las cinco puertas de la skill, en verde
- [ ] El capítulo publicado en Pages y abierto desde el portal

---

## 5. Cuota de ejercicios — distribución objetivo

| Sección | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 |
|---|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| §1 Qué es un algoritmo | | 1 | | | | | | **1** |
| §2 Entrada–proceso–salida | 1 | | | | 1 | | | |
| §3 Cuatro representaciones | | | 1 | | | **1** | | |
| §4 Variables y asignación | 2 | 1 | 1 | | | | | |
| §5 Dos algoritmos correctos | | | | 1 | | | 1 | |
| Evaluación | | | | | | | 1 | |
| **Total** | **3** | **2** | **2** | **1** | **1** | **1** | **2** | **1** |
| Cuota `verificar.py` | 3–4 | 2–3 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 |

**13 ejercicios + 1 cuestionario integrador.** Cumple la cuota por el mínimo en
seis de los ocho tipos, que es donde quedó el capítulo 1: deja margen para
añadir sin rehacer.

El **E6 va en §3** y no en la evaluación —al revés de lo que sugiere la skill—
porque aquí el emparejamiento es de símbolos ANSI, que es contenido de esa
sección y no un cruce entre secciones.

---

## 6. Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| El resaltado sincronizado de `CuatroRepresentaciones` resulta más caro de lo previsto | Medio | Se construye **aislado y primero** (T6). Si se atasca: degradar a resaltado por clic en vez de por cursor, que es más simple y además funciona en táctil |
| Sobrevive contenido de la plantilla y `verificar.py` da verde con él | **Alto** | T12 es una tarea propia con `grep` explícito, y no una casilla dentro de otra |
| La salida de VBA no se puede ejecutar (riesgo R2 del plan maestro) | Medio | Se declara omitida en el informe, como en el capítulo 1. No se documenta ninguna salida de VBA supuesta |
| Un cloze compila, valida y no enseña nada (trampa 8) | Medio | Regla de contenido propia en `verificar_cloze.R` para cada uno, con prueba negativa |
| `exams2moodle` falla de forma intermitente por notación científica (trampa 9) | Medio | `num()` obligatorio desde el primer ejercicio, no como corrección posterior |
| El capítulo crece hasta hacer la página lenta | Bajo | El capítulo 1 son 4314 líneas y responde bien. Si el 2 pasa de ~4500, medir antes de seguir |

---

## 7. Supuestos declarados

1. **La rama nace de `lp-core/gramaticas-de-resaltado`.** Si el PR #1 se fusiona
   con *squash*, esta rama habrá que rebasarla sobre `main` antes de abrir su
   propio PR. Se hace en T15.
2. **El pseudocódigo sigue a Joyanes/Cairo**, como en el capítulo 1.
3. **El hilo financiero es el mismo del curso**: crédito de libre inversión de
   un banco colombiano, cifras en COP.
4. **Los símbolos del flujograma son los seis del estándar ANSI** que usa la
   bibliografía del syllabus, no los de UML ni los de BPMN.
5. **No se añade ningún componente a LP-CORE.** Los tres artefactos viven en el
   capítulo (trampa 5).

---

## 8. Comandos

```bash
cd "…/Logica de programacion"

cp "Material html/_plantilla/lp-base.html" "Material html/02_LPF_Algoritmos.html"
python3 "Material html/_plantilla/migrar.py" --dry-run "Material html/02_LPF_Algoritmos.html"

python3 "Material html/_plantilla/verificar.py" --sin-cuota     # mientras se escribe
python3 "Material html/_plantilla/verificar.py" --con-salidas   # al cerrar

Rscript "Banco Moodle/compilar_banco.R" --cap 02
Rscript "Banco Moodle/verificar_cloze.R" --reps 1000

python3 -m http.server 8777 --directory "Material html"
```

---

## 9. Preguntas abiertas

1. **`entrada_proceso_salida`: ¿`string ×3` o `schoice ×3`?** El plan maestro
   dice `string`; se propone `schoice` porque el `string` de Moodle califica por
   coincidencia exacta y castigaría una respuesta correcta mal tipeada. **No
   bloquea:** se escribe en `schoice` y se cambia si el docente prefiere lo otro.
2. **¿El capítulo 2 puede citar el capítulo 6 (`Currency`) y el 1 (redondeo)?**
   Se asume que sí —el material se estudia en orden y el capítulo 1 ya anticipa
   el 6—. **No bloquea.**
3. **¿Cuántas preguntas del `Quiz` deben ser de selección múltiple frente a
   verdadero/falso?** El capítulo 1 no fijó proporción. Se asume libre. **No
   bloquea.**
