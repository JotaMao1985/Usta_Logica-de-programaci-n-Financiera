# Material HTML — Lógica de Programación Financiera

Cada capítulo es **un archivo HTML autocontenido**: se abre con doble clic, sin
servidor, sin `npm`, sin build. El portal que los enlaza es el `index.html` de la
**raíz del repositorio**, y es lo que publica GitHub Pages; no vive en esta
carpeta para que Pages lo sirva sin rutas con espacios. React, Tailwind, Plotly y MathJax se cargan desde
CDN, de modo que **hace falta conexión a internet** la primera vez (después el
navegador los cachea). Si se necesitara uso sin conexión, habría que descargar
esas seis librerías al disco; hoy no está hecho.

## Estructura

```
Material html/
├── 01_LPF_Introduccion.html      … 08_LPF_Funciones.html
└── _plantilla/
    ├── lp-base.html              PLANTILLA GENERADA — no se edita a mano
    ├── lp-core-extra.jsx         componentes nuevos (fuente)
    ├── lp-demo.jsx               capítulo de demostración + App (fuente)
    ├── ensamblar.py              genera lp-base.html
    ├── migrar.py                 estampa la librería y el App en un capítulo
    ├── verificar.py              comprueba los capítulos
    ├── ejecutar_salidas.py       ejecuta el código y contrasta lo que declara
    ├── ejecutar_vba.py           lo mismo para VBA, en Excel
    └── sonda_navegador.mjs       lo que el panel de vista previa no puede medir
```

## Flujo de trabajo

**Para crear un capítulo:** copiar `_plantilla/lp-base.html`, cambiar el objeto
`CONFIG` de la cabecera del script, y reemplazar las secciones de demostración
por el contenido real. El bloque delimitado por
`/* === LP-CORE INICIO === */` … `/* === LP-CORE FIN === */` **no se toca**.

**Para cambiar un componente compartido:** editar `_plantilla/lp-core-extra.jsx`,
regenerar, y volver a estampar el bloque en los capítulos ya escritos con
`migrar.py`. Estampar a mano es justo lo que la comprobación 1 existe para
detectar.

```bash
python3 "Material html/_plantilla/ensamblar.py"     # fuentes  → lp-base.html
python3 "Material html/_plantilla/migrar.py"        # plantilla → capítulos
python3 "Material html/_plantilla/verificar.py"     # comprueba
node "Material html/_plantilla/sonda_navegador.mjs" # y en un Chrome de verdad
```

`migrar.py` no acepta opciones que no conoce: sale con 2 sin escribir nada.
Hasta el 2026-10-27 las ignoraba, y un `--help` estampaba los cinco capítulos.

**`sonda_navegador.mjs`** abre cada capítulo como `file://` en un Chrome sin
ventana y recorre todas sus lecciones. Tiene cuatro modos: `file` (el de
omisión: monta, guarda y no da errores de JavaScript), `375` (nada se sale a
375 px), `sin-almacen` (con `localStorage` lanzando, como en una ventana
privada) y `sin-cdnjs`. Existe porque el panel de vista previa no sirve para
eso: abre los `file://` como URL `data:`, congela las animaciones, y en él
`requestAnimationFrame` no corre y `ResizeObserver` no notifica. Cualquier
componente que se mida a sí mismo da allí una medida vieja sin ningún error.

`migrar.py` estampa dos regiones: el bloque `LP-CORE` y el `App`. El `App`
también, porque es plantilla: todo lo que varía de un capítulo a otro vive en
`CONFIG` y en `curriculum`. Un capítulo heredado se reconoce por no traer
centinelas y se migra; uno ya migrado se reestampa de centinela a centinela.
Acepta `--dry-run` y deja `.bak`. Las dos regiones se vigilan: LP-CORE con la
regla 1 de `verificar.py` y el `App` con la 23. Un cambio en cualquiera de ellas
se hace en su fuente (`lp-core-extra.jsx`, `lp-demo.jsx`), no en el capítulo:
la siguiente reestampada lo desharía.

**Para cambiar el `head`** (CSS, librerías, configuración de Tailwind):
editarlo en `01_LPF_Introduccion.html`, que es la fuente de `ensamblar.py`,
regenerar, y copiar el mismo cambio al `head` de los demás capítulos: `migrar.py`
no lo estampa. La comprobación 20 de `verificar.py` exige que todos los `head`
sean el del 1 salvo el `<title>` y la descripción.

`verificar.py` comprueba veinticinco cosas —la 13 sobre la plantilla, las demás
sobre cada capítulo— y devuelve ≠ 0 si algo falla. Aquí van las doce primeras;
la lista completa, con el porqué de cada una, es el docstring del guion:

1. **Deriva** — el bloque LP-CORE de cada capítulo debe coincidir byte a byte
   con el de `lp-base.html` (comparación SHA-256).
2. **Cuota de ejercicios** — la taxonomía E1…E8; E1, E3 y E7 son obligatorios.
   Use `--sin-cuota` mientras un capítulo está a medias.
3. **Componentes sin definir** — todo `<Componente>` usado debe existir.
4. **CodeTabs completos** — cada bloque de código debe traer los cuatro
   lenguajes: `pseudo`, `python`, `r`, `vba`.
5. **Motivación** — cada sección del `curriculum` debe abrir con `<Motivacion>`.
6. **Ejercicios multilingües** — si un ejercicio se presenta en varios lenguajes, debe traerlos los cuatro; y `DetectaError` no puede usar una `lineaCorrecta` fija cuando sus líneas cambian con el lenguaje.
7. **Salida** — dentro del bloque y con el prefijo de su lenguaje; sin propiedades `salidas={...}` sobrevivientes.
8. **Texto por lenguaje** — un `DetectaError` con `lineas` multilingüe no puede citar «la línea N» en un `enunciado` o una `explicacion` fijos. Es la 6 aplicada a la prosa: se arregla la clave y se deja el texto.
9. **Salidas ejecutadas** — la salida declarada tras `#>` es la que el código produce de verdad. Vive en `ejecutar_salidas.py`, que corre procesos y tarda; se pide con `--con-salidas`.
10. **Contraste** — ningún color por debajo de 3,0:1 sobre el fondo de la página se usa como texto sin confirmar. Sale como **aviso**, no como falla, y a propósito: ver más abajo.
11. **Enunciados** — ningún ejercicio pide escribir un programa desde cero.
12. **Preguntas imposibles** — ninguna pregunta con más de una opción
    `correcta: true` olvida `multiple: true`. Ver abajo: es un defecto que no se
    ve en pantalla y que hace la pregunta inacertable.

```bash
python3 "Material html/_plantilla/verificar.py" --con-salidas
```

La 9 solo ejecuta **Python y R**, y solo los bloques que **declaran** salida: uno
sin `#>` no afirma nada que comprobar, y muchos bloques del material no son
programas —`TRAZA_CODIGO` lleva los números de línea incorporados, otros traen un
error deliberado—, así que ejecutarlos produciría fallos que no son fallos. El
pseudocódigo no es ejecutable y VBA se verifica en Excel real; ambos se declaran
omitidos en el informe en vez de darse por buenos en silencio.

VBA se ejecuta aparte, con `ejecutar_vba.py`, porque necesita Excel (sirve Excel
para Mac). El guion arma con los bloques que declaran `'>` un módulo de arnés y
lo deja en el portapapeles. Se pega una vez en el editor de VBA, en un libro
nuevo: Herramientas › Macro › Editor de Visual Basic, Insertar › Módulo, ⌘V.
Después el guion lo corre por AppleScript y compara, igual que la regla 9:

```bash
python3 "Material html/_plantilla/ejecutar_vba.py" preparar 05_LPF_*.html
python3 "Material html/_plantilla/ejecutar_vba.py" comparar
```

El módulo solo se vuelve a pegar si cambia el código VBA. El arnés se identifica
por la huella de lo que se pega, así que corregir una salida declarada pide
`preparar` otra vez, no pegar; `preparar` avisa cuando el código no cambió.

`Debug.Print` se cambia por `Print #`, que imprime con las mismas reglas, y
`MsgBox` e `InputBox` por versiones que escriben en el mismo canal o leen de una
cola (`--incluir NOMBRE=250000,-1` corre un bloque que lee datos). La única
diferencia que se perdona, y se informa, es el separador decimal: lo pone la
configuración regional, y un Excel en español de Colombia escribe `916799,93`
donde el material declara `916799.93`.

**Las salidas del pseudocódigo se cotejan con las de Python** (regla 25, desde el
2026-11-02). Las `//>` no las ejecuta nada; las `#>` de Python del mismo bloque sí,
con la regla 9. La regla compara las dos listas después de quitar tres
diferencias legítimas, y ninguna otra:
- la coma de miles de Python;
- los espacios de más, que esa coma y `print(a, b)` cambian;
- `True` y `False` frente a `Verdadero` y `Falso`.

Es un **aviso**. Un bloque que escribe otra cosa a propósito va en
`COTEJO_DISTINTO`, con lo que declara su pseudocódigo: si eso cambia, vuelve a
avisar. VBA queda fuera, porque imprime distinto a propósito (el espacio del
signo y las zonas de 14 columnas de `Debug.Print`), y lo coteja
`ejecutar_vba.py` en Excel.

**Lo que ninguna regla mira: las cifras fuera de los bloques.** Las reglas 9 y 25 y
`ejecutar_vba.py` comprueban lo que va tras `#>`, `//>` y `'>`. Nadie mira el número de
vueltas que se dice en la prosa, el saldo de un distractor o la cifra de una
justificación. En la auditoría del capítulo 5 se ejecutaron unas 240 de esas
cifras en Python y en R, y salieron:
- un distractor cuya multiplicación no daba lo que decía;
- cuatro cifras calculadas con un valor distinto del que muestra el enunciado.

Hasta que haya una regla, al cerrar cada capítulo se hace esa auditoría a mano
(Tarea 3.3 de su plan).

`ensamblar.py` además **falla si Font Awesome es anterior a 6.5**: varios iconos
del material (`fa-clipboard-question`, `fa-money-bill-trend-up`,
`fa-magnifying-glass-chart`) no existen en versiones previas y aparecen como
huecos en blanco, sin ningún error en consola.

**Para ver un capítulo con la interactividad funcionando**, basta abrirlo con
doble clic. Para servirlo (útil al depurar):

```bash
python3 -m http.server 8777 --directory "Material html"
```

## Convenciones de autoría

### Toda sección abre con una motivación

Es obligatorio y lo comprueba `verificar.py`. La motivación **no resume lo que
viene**: da una razón para seguir leyendo. Receta, en un máximo de ~80 palabras:

1. una **escena concreta** del sector financiero (personas, cifras, un plazo);
2. la **tensión o el costo** que esa escena revela;
3. el **`gancho`**: la pregunta que la sección viene a responder.

```jsx
<Motivacion icon="fa-money-bill-trend-up"
    gancho="La diferencia no es saber más Excel: es saber descomponer el problema en pasos.">
    Son las 8 de la mañana y a dos analistas les entregan el mismo archivo…
</Motivacion>
```

Lo que hay que evitar: abrir con «En esta sección estudiaremos…». Eso es un
índice, no una motivación, y el estudiante ya lo tiene en la barra lateral.

### El nombre del capítulo se escribe igual en cinco sitios

El mismo capítulo aparecía con cuatro nombres distintos —«Capítulo 4: Control
selectivo» en la pestaña, «Control selectivo» en la barra lateral, «Evaluación
final · Unidad 1» en el cuestionario del 1— porque cada uno se escribió por
separado y nada los comparaba. Se unificaron el 2026-09-22.

El nombre va en **minúscula de oración**: mayúscula solo en la primera palabra
y en los nombres propios. «Introducción a algoritmos», no «a Algoritmos»; las
siglas se respetan, «Entorno de programación VBA».

| Sitio | Forma |
|---|---|
| `<title>` del capítulo | `Lógica de Programación Financiera — NN · Nombre` |
| `<meta name="description">` | `Capítulo N del material de Lógica de Programación Financiera: …. Universidad Santo Tomás.` |
| `CONFIG.titulo` | `Nombre` a secas — el `App` le antepone `Capítulo NN · ` |
| Título del `Quiz` final | `Evaluación · Capítulo NN — Nombre` |
| `<h3>` de la tarjeta en `index.html` | `Nombre` a secas |

Las cuatro primeras filas viven en el capítulo; la quinta, en el portal. Al
publicar un capítulo hay que tocar las cinco, y `verificar.py` **no** lo
comprueba: no lee `index.html`.

### Paleta institucional USTA

Idéntica a la del material de referencia. **No se inventan colores de marca.**

| Rol | Hex | Uso |
|---|---|---|
| `primary` | `#3D008D` | Color de marca, degradados, texto destacado |
| `secondary` | `#ED1E79` | Títulos `h3`, foco, acentos |
| `navy` | `#001A4D` | Cabecera lateral, títulos `h4`, cuerpo oscuro |
| `gold` | `#FDB913` | **Solo acento sobre fondo oscuro** — ver abajo |
| `teal` | `#0E7490` | Acento secundario |

⚠️ **El gold nunca va como texto sobre fondo claro:** da 1,66:1 de contraste, muy por debajo del mínimo WCAG AA (3,0:1 para texto grande). Su lugar es la barra lateral navy y los iconos. El material tuvo justo ese defecto —títulos de sección en gold a 1,99:1— hasta el 2026-08-04.

Antes de introducir un color nuevo, medir su contraste sobre `#F8FAFC`. Lo mide
la comprobación 10, que avisa de cada uso `text-<color>` de un color por debajo
del mínimo, y también de los hexadecimales escritos a mano en `text-[#…]` o en un
`color:` en línea.

Sale como **aviso** y no como falla porque el mismo color puede ser correcto o
incorrecto según lo que lo envuelva: `text-gold` está bien dentro del navy de la
barra lateral y mal sobre el fondo claro. Distinguirlos exige saber qué elemento
contiene a cuál, y el análisis estático no lo resuelve de forma fiable; un
veredicto automático daría confianza falsa.

Los **iconos** quedan fuera de la regla —un `<i>` no es texto, y la convención ya
dice que el lugar del gold son la barra lateral y los iconos—, así que el
`fa-dumbbell` de `Reto` no avisa. Se auditan la librería y el capítulo por igual:
la zona examinada empieza donde empieza el JSX, no en `LP-CORE FIN`, para que
nadie deje de mirar los componentes compartidos.

Un uso ya revisado se calla escribiendo `contraste-ok` en su línea o en la
anterior, con el motivo:

```jsx
{/* contraste-ok: el gold va sobre el navy de `lp-header`, no sobre el fondo claro */}
<p className="text-[0.65rem] uppercase tracking-widest text-gold font-bold">Universidad Santo Tomás</p>
```

Sin esa válvula el aviso saldría en cada ejecución para siempre, y un aviso que
siempre está ahí deja de leerse.

### La salida va DENTRO del bloque

Nada de paneles «Salida» aparte: la salida se escribe como comentario, pegada a
la instrucción que la produce. Así se lee sin saltar la vista, caben varias
salidas en un bloque, y **copiar el bloque entrega un guion ejecutable**.

| Lenguaje | Prefijo |
|---|---|
| Pseudocódigo | `//>` |
| Python · R | `#>` |
| VBA | `'>` |

```python
print(f"Interes: {interes:,.0f}")
#> Interes: 2,160,000
```

Esas líneas se pintan en cian con un fondo tenue, para separar *lo que escribió
el docente* de *lo que respondió la máquina*.

⚠️ **Toda salida declarada debe haberse ejecutado.** De eso se encarga
`ejecutar_salidas.py` (comprobación 9): extrae los bloques de Python y R, los
corre y compara su salida real con la declarada. Es la única defensa contra una
salida que envejece mal —una cifra equivocada no se ve en pantalla, se lee como
cualquier otra— y ya cazó un caso en que un `#> 600000` copiado por descuido
contradecía la clave del propio ejercicio.

Solo se auditan los bloques que están dentro de un objeto por lenguaje. Un bloque
suelto de un solo lenguaje no se puede comprobar —`#>` es el prefijo de Python y
de R a la vez, y nada dice cuál es—; el informe los lista como no auditados en
vez de callarlos. Convertirlo a `CodeTabs` lo vuelve auditable.

El resaltado es **Prism.js 1.29** (`r`, `python`, `visual-basic`); el
pseudocódigo usa una gramática propia registrada en LP-CORE.

### Los ejercicios también van en los cuatro lenguajes

No basta con que la **exposición** tenga `CodeTabs`: si el estudiante lee en VBA
y el ejercicio sigue en pseudocódigo, el material cambia de idioma justo al pasar
de la teoría a la práctica. Los cinco componentes de ejercicio siguen la misma
regla que `CodeTabs` (D4-bis): **cada uno cambia por separado** y todos abren en
la última preferencia guardada, de modo que quien lee en VBA encuentra el
ejercicio en VBA sin volver a elegirlo.

Toda propiedad que contenga **código** admite un objeto `{pseudo, python, r, vba}`:

| Componente | Propiedades por lenguaje |
|---|---|
| `TablaTraza` | `codigo` · y la columna `instruccion` de cada fila |
| `DetectaError` | `lineas`, **`lineaCorrecta`** y, si citan números de línea, **`enunciado` y `explicacion`** |
| `Comparador` | `a.codigo` y `b.codigo` |
| `OrdenaPasos` | `pasos` |
| `Emparejamiento` | `izquierda` (el lado derecho son significados: no cambia) |

Lo que **no** va por lenguaje son los **valores de las variables** en la tabla de
traza: son idénticos en los cuatro, y hacérselo ver al estudiante es justamente
el objetivo del ejercicio.

⚠️ **`lineaCorrecta` debe ser un objeto por lenguaje.** El mismo fallo no está en
la misma línea en los cuatro (VBA añade `Sub` y `Dim`; Python no lleva
declaraciones). En el ejemplo de la plantilla está en la línea 5, 4, 4 y 7
respectivamente. Fijar un número único hace que el ejercicio califique mal al
cambiar de pestaña, y **en silencio**. La comprobación 6 de `verificar.py` existe
por eso.

⚠️ **Y con la clave va el texto.** `enunciado` y `explicacion` admiten el mismo
objeto, y lo necesitan en cuanto citan un número de línea: «el comentario de la
línea 4» es cierto en pseudocódigo y falso en Python, donde la 4 es justamente la
respuesta —el enunciado la regala mientras afirma otra cosa—.

- **Enunciados:** redactarlos **sin citar ningún número**. «El comentario que
  acompaña a la asignación de `tasa`» es cierto en los cuatro y no envejece si
  mañana se retoca el código.
- **Explicaciones:** si deben señalar la línea exacta, van por lenguaje. Ojo
  también con la **sintaxis** que citan: la asignación es `<-` en pseudocódigo y
  R, y `=` en Python y VBA.

La comprobación 8 de `verificar.py` avisa cuando un `DetectaError` multilingüe
tiene un `enunciado` o una `explicacion` fijos que citan «línea N».

**El Paso 3: anticipar la consecuencia.** La taxonomía pide al E3 nombrar el
error y anticipar lo que cuesta. `consecuencias` (cuatro cadenas) y
`consecuenciaCorrecta` (el índice) funcionan como `tipos` y `tipoCorrecto`, y
no van por lenguaje: si la consecuencia cambia de un lenguaje a otro, la opción
correcta lo dice («Python y R se detienen en la primera prueba; VBA informa un
interés de cero sin avisar»). El `impacto` sale al comprobar y hace de
explicación del paso.
- La correcta sale del `impacto`, en pesos cuando el daño es monetario.
- Los distractores salen de confusiones reales —se detiene o sigue en silencio,
  una cifra sacada de leer mal el código, el sentido contrario— y **no
  contradicen el enunciado**: si dice que el programa aprobó, ninguno dice que
  se detuvo.
- Cada cifra se ejecuta contra el código del ejercicio, también las de los
  distractores: ninguno puede resultar cierto en algún lenguaje.

Lo vigilan tres reglas: la 24 exige que todo E3 las traiga, la 17 que la clave
no se delate por el tamaño —también en los `tipos`— y la 16 reparte sus claves
junto con las de los demás ítems.

Usar el ayudante `ins(pseudo, python, r, vba)` para las instrucciones cortas:

```jsx
{ paso: 1, instruccion: ins('capital <- 1000000', 'capital = 1000000',
                            'capital <- 1000000', 'capital = 1000000'),
  capital: '1000000', tasa: '—' }
```

### Resto de convenciones

- **Pseudocódigo** según Joyanes/Cairo: `Inicio/Fin`, `Leer`, `Escribir`,
  `Si…Entonces…Sino…FinSi`, `Segun…FinSegun`, `Mientras…FinMientras`,
  `Para…FinPara`, `Repita…Hasta`. Asignación con `<-`.
- **Orden de pestañas fijo:** Pseudocódigo → Python → R → VBA. Pestaña por
  defecto: `pseudo` en los capítulos 1–5, `vba` en los capítulos 6–8.
- **Toda salida documentada debe haberse ejecutado**, no
  supuesto. Python y R se ejecutan; VBA se verifica en Excel real, con
  `ejecutar_vba.py`.
- **Las cifras no se parten entre renglones.** En la prosa, el separador de
  miles es un espacio duro (U+00A0), no uno normal: «1 150 000» no puede quedar
  como «1 150» al final de un renglón y «000» al principio del siguiente. Lo
  mismo el espacio antes del % («1,8 %») y los del producto de la notación
  científica («7,5 × 10⁻⁸»). En el código no: allí sobra, y en una línea que el
  estudiante copia es un error de sintaxis. No hace falta escribirlo a mano. La
  regla 21 avisa, y `node _plantilla/comprobar_cifras.js --corregir <capítulo>`
  pone los espacios solo en la prosa. Si la cifra está en el `App`, el espacio
  va en `lp-demo.jsx`: corregido solo en el capítulo, lo quita la siguiente
  reestampada, y la regla 23 no lo deja pasar. Se probó el espacio fino
  (U+202F), que es el que recomiendan la RAE y el SI, pero en Montserrat queda
  tan angosto que «20 000 000» se lee «20000000».
- Los ejercicios **no piden escribir programas desde cero**: eso es de los
  talleres. Aquí se lee, se traza, se diagnostica, se compara y se interpreta.
  Lo comprueba la regla 11, que mira **solo los enunciados** —las propiedades
  `enunciado`, `pregunta` y `titulo`, y el cuerpo de `<Reto>`— y no la prosa de
  la exposición: ahí la frase es legítima («en el taller se le pedirá escribir un
  programa que…») y marcarla haría que el verificador mintiera.
- E2, E7 y E8 se construyen con `MCQ` o `Reto` envueltos en
  `<Ejercicio tipo="E7">`, para que el tipo sea visible y contable. Si lo que se
  envuelve es un componente que ya se etiqueta solo (`TablaTraza`,
  `DetectaError`, `Comparador`, `OrdenaPasos`, `Emparejamiento`), la etiqueta
  sale una vez, en su sitio, y dice el tipo del envoltorio.
- En `MCQ`, cada opción puede llevar su `justificacion`. Al comprobar se muestra
  la de cada opción mal elegida y después la de las correctas. Hasta el
  2026-10-27 solo se veía la de la correcta (H9 del capítulo 4), y por eso las
  de los capítulos 1 a 5 absorben los distractores; ahora ya no hace falta.

### Una pregunta con dos respuestas correctas necesita `multiple: true`

⚠️ En `Quiz` y `MCQ`, la selección es de **opción única salvo que la pregunta
declare `multiple: true`**. Sin esa bandera, elegir una segunda opción
**reemplaza** a la primera, mientras que la calificación sigue exigiendo el
conjunto completo de correctas. El resultado es una pregunta que **no se puede
acertar**: se pinta bien, se responde, y el veredicto es «incorrecto» sin decir
por qué.

```jsx
{
    pregunta: '¿Cuáles de estas afirmaciones son ciertas?',
    multiple: true,                       // ← sin esto, es inacertable
    opciones: [
        { texto: '…', correcta: true },
        { texto: '…', correcta: true },
        …
    ],
}
```

La etiqueta «(selección múltiple)» **la pinta el componente** a partir de la
bandera. Escribirla a mano en el enunciado no arregla nada y la duplica.

Lo comprueba la regla 12, que apareció al responder el cuestionario del capítulo
2 con las diez respuestas buenas y obtener 9. Ninguna comprobación estructural lo
veía, y a simple vista tampoco.

### Una pregunta que se contesta sin leer el capítulo no evalúa nada

Tres formas de regalar la respuesta. Las tres se vieron en este material, y las
tres pasaban en verde antes del 2026-09-28.

**El enunciado la contiene.** Si el enunciado dice «las cinco reglas *son
correctas*, pero una está mal colocada» y tres distractores afirman que hay una
regla defectuosa, solo queda una opción compatible con su propio enunciado. Se
acierta por concordancia gramatical, sin saber qué es una cascada. Léase cada
distractor preguntando *¿lo descarta el enunciado por sí solo?*: si la respuesta
es sí en todos menos uno, la pregunta no mide nada.

**La clave es la más larga.** Sale del oficio —se redacta primero la buena, con
sus matices, y después tres frases cortas—. Lo vigila la regla 17, con dos
varas. El arreglo es **alargar los distractores**, no acortar la clave: la clave
necesita sus matices.

**Ya se respondió antes.** El cuestionario final es integrador, no un repaso:
repetir un ejercicio de sección mide memoria de la respuesta. Lo vigila la
regla 18. Ojo con el arreglo fácil: la primera vez que apareció se «resolvió»
reescribiendo la clave, lo justo para que la comparación de cadenas dejara de
verlo —y las otras tres opciones siguieron siendo las mismas, y la clave nueva
pasó a repetir el enunciado—. Si una pregunta está repetida, se **cambia la
pregunta**; reescribirla no la vuelve nueva.

Y una cuarta, que no vigila nadie: **un distractor que nadie marca** deja el
ítem en tres opciones útiles. «Es ambigua y produce un error de sintaxis» no la
elige ni quien no sabe. Un buen distractor es una creencia que alguien tiene de
verdad —«las dos agrupaciones dan lo mismo», «`AndAlso` existe en VBA»—, y por
eso enseña algo cuando se descarta.

Y una quinta: **la clave trae su propia cuenta.**
`'13 (8 + 4 + 0 + 1 = 13)'` contra un `'11'` pelado se acierta sin saber binario:
es la única opción que muestra su razonamiento, y la aritmética cuadra. No se
arregla quitándole la cuenta a la clave sino dándole a cada distractor **la suya,
la equivocada**: `'11 (1 + 2 + 0 + 8 = 11)'` son los pesos leídos al revés, y
descartarlo obliga a saber por qué lado empiezan. La regla 17 lo ve casi
siempre, porque la cuenta hace de la clave la más larga: entre opciones cortas
avisa cuando la clave le saca 8 caracteres al distractor más largo. No lo ve si
un distractor mide lo mismo sin cuenta —`'1101 (es el mismo número)'`—: ahí no
delata el tamaño sino que solo la clave razona, y eso hay que mirarlo leyendo.

Y cada pregunta del cuestionario final **dice de qué sección es**, con
`seccion: 'capN'`. Es lo que deja a la regla 19 comprobar que ninguna sección se
quede sin preguntar. Sin etiquetas la regla no puede comprobar nada, y lo dice
con un aviso, no con un fallo: no es que esté mal, es que no se miró. Hasta el
2026-09-28 callaba, y así estuvieron el 1, el 2 y el 3 sin que nada lo dijera;
al declararlo, el 1 resultó no tener ninguna pregunta de su sección 4. Solo el
cuestionario final: los minicuestionarios de sección no se etiquetan.

## Catálogo de componentes

| Componente | Uso |
|---|---|
| `Motivacion` | **Apertura obligatoria de cada sección** (escena + gancho) |
| `CodeBlock` | Bloque de un lenguaje. `plegable={false}` dentro de ejercicios |
| `CodeTabs` | Código en 4 lenguajes; pestaña **propia de cada bloque**, con la última preferencia recordada |
| `Box` · `CalloutPro` | Avisos (`info`, `tip`, `warn`, `danger`) y destacados |
| `Eq` · `Termino` | Fórmula destacada · término con definición emergente |
| `Pipeline` · `Timeline` · `Tabs` · `Accordion` | Estructuras de contenido |
| `ChartFrame` + `usePlotly` | Gráficas interactivas. `descripcion` es lo que oye un lector de pantalla (sin ella, el pie) |
| `Trazador` | Traza guiada, instrucción por instrucción. Es exposición: no califica y no cuenta en la cuota |
| `TablaTraza` | **E1** prueba de escritorio |
| `DetectaError` | **E3** ubicar la línea + clasificar el error + anticipar la consecuencia |
| `Comparador` | **E4** dos versiones lado a lado + veredicto |
| `OrdenaPasos` | **E5** reconstruir la secuencia |
| `Emparejamiento` | **E6** relacionar representaciones |
| `MCQ` · `Quiz` · `Reto` | **E2/E7/E8** y cuestionario integrador |

`TablaTraza` compara con tolerancia: acepta `—`, `-` o vacío como «sin valor»,
ignora las tildes (`sí` y `si` son la misma respuesta; la ñ cuenta), y normaliza
separador de miles y coma decimal (`20.000`, `20000` y `20000,00` se consideran
iguales). Desde el 2026-10-27 lee también la coma de miles de Python
(`1,350,000`), y una respuesta ambigua como `1.250` vale por cualquiera de sus
dos lecturas; la clave tiene siempre una sola.

`OrdenaPasos` desordena cada ejercicio, y cada lenguaje, con una permutación
sembrada con el texto de sus pasos: no cambia entre visitas, no deja ningún paso
en su sitio ni dos seguidos en orden. La de antes era el mismo patrón en todos
(L1). Los pasos conservan su sangría, y se califica por texto: dos pasos
idénticos intercambiados cuentan como bien.

Una variable del `Trazador` con `efimera: true` vale solo en el paso que la
escribe, sin arrastrarse a los siguientes. Es para las condiciones evaluadas:
`{ clave: 'cond', titulo: 'saldo > 0', efimera: true }`.

**`localStorage`, nunca directo.** El contenido de un capítulo guarda y lee con
`leerGuardado(clave)` y `guardar(clave, valor)` de LP-CORE, que no lanzan cuando
el navegador no da almacenamiento. Lo vigila la regla 22.

**`not-prose` solo vale a medias.** Es del plugin Typography, que no se carga. El
CSS del `head` lo respeta en títulos y tablas, y nada más: los componentes que
lo declaran se ajustaron con los márgenes, el interlineado y las viñetas de
`.prose-lp`, y hacerlo valer del todo cambiaba cientos de medidas en los cinco
capítulos (se midió el 2026-10-27).

**El techo del `Trazador`.** Pinta un botón y una fila de historial por paso.
Medido en el capítulo 5, 33 pasos aún caben a 375 px: los botones ocupan cuatro
filas y no sale nada de la pantalla. Lo que crece es el alto, que con el
historial completo llega a unos 4 000 px. Una traza guiada da **tres vueltas
como mucho**. Una tabla de cientos de filas no es un `Trazador` largo: es un
componente propio del capítulo, como `AmortizacionPasoAPaso`.

**`Salir` se pinta como palabra clave** desde el 2026-10-27. El capítulo 2 lo
usa; del 5 en adelante no se usa. La salida de un ciclo va en su condición, que
es además lo que se enseña: un ciclo que sale a mitad del cuerpo esconde cuándo
para.
