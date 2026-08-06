# Material HTML — Lógica de Programación Financiera

Cada capítulo es **un archivo HTML autocontenido**: se abre con doble clic, sin
servidor, sin `npm`, sin build. React, Tailwind, Plotly y MathJax se cargan desde
CDN, de modo que **hace falta conexión a internet** la primera vez (después el
navegador los cachea). Si se necesitara uso sin conexión, habría que descargar
esas seis librerías al disco; hoy no está hecho.

## Estructura

```
Material html/
├── index.html                    portal índice (pendiente — Tarea 14)
├── 01_LPF_Introduccion.html      … 08_LPF_Funciones.html
└── _plantilla/
    ├── lp-base.html              PLANTILLA GENERADA — no se edita a mano
    ├── lp-core-extra.jsx         componentes nuevos (fuente)
    ├── lp-demo.jsx               capítulo de demostración + App (fuente)
    ├── ensamblar.py              genera lp-base.html
    ├── migrar.py                 estampa la librería y el App en un capítulo
    ├── verificar.py              comprueba los capítulos
    └── ejecutar_salidas.py       ejecuta el código y contrasta lo que declara
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
```

`migrar.py` estampa dos regiones: el bloque `LP-CORE` y el `App`. El `App`
también, porque es plantilla: todo lo que varía de un capítulo a otro vive en
`CONFIG` y en `curriculum`. Un capítulo heredado se reconoce por no traer
centinelas y se migra; uno ya migrado se reestampa de centinela a centinela.
Acepta `--dry-run` y deja `.bak`.

`verificar.py` comprueba once cosas y devuelve ≠ 0 si algo falla:

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

```bash
python3 "Material html/_plantilla/verificar.py" --con-salidas
```

La 9 solo ejecuta **Python y R**, y solo los bloques que **declaran** salida: uno
sin `#>` no afirma nada que comprobar, y muchos bloques del material no son
programas —`TRAZA_CODIGO` lleva los números de línea incorporados, otros traen un
error deliberado—, así que ejecutarlos produciría fallos que no son fallos. El
pseudocódigo no es ejecutable y VBA se verifica en Excel real; ambos se declaran
omitidos en el informe en vez de darse por buenos en silencio.

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
  supuesto. Python y R se ejecutan; VBA se verifica en Excel real.
- Los ejercicios **no piden escribir programas desde cero**: eso es de los
  talleres. Aquí se lee, se traza, se diagnostica, se compara y se interpreta.
  Lo comprueba la regla 11, que mira **solo los enunciados** —las propiedades
  `enunciado`, `pregunta` y `titulo`, y el cuerpo de `<Reto>`— y no la prosa de
  la exposición: ahí la frase es legítima («en el taller se le pedirá escribir un
  programa que…») y marcarla haría que el verificador mintiera.
- E2, E7 y E8 se construyen con `MCQ` o `Reto` envueltos en
  `<Ejercicio tipo="E7">`, para que el tipo sea visible y contable.

## Catálogo de componentes

| Componente | Uso |
|---|---|
| `Motivacion` | **Apertura obligatoria de cada sección** (escena + gancho) |
| `CodeBlock` | Bloque de un lenguaje. `plegable={false}` dentro de ejercicios |
| `CodeTabs` | Código en 4 lenguajes; pestaña **propia de cada bloque**, con la última preferencia recordada |
| `Box` · `CalloutPro` | Avisos (`info`, `tip`, `warn`, `danger`) y destacados |
| `Eq` · `Termino` | Fórmula destacada · término con definición emergente |
| `Pipeline` · `Timeline` · `Tabs` · `Accordion` | Estructuras de contenido |
| `ChartFrame` + `usePlotly` | Gráficas interactivas |
| `TablaTraza` | **E1** prueba de escritorio |
| `DetectaError` | **E3** ubicar la línea + clasificar el error |
| `Comparador` | **E4** dos versiones lado a lado + veredicto |
| `OrdenaPasos` | **E5** reconstruir la secuencia |
| `Emparejamiento` | **E6** relacionar representaciones |
| `MCQ` · `Quiz` · `Reto` | **E2/E7/E8** y cuestionario integrador |

`TablaTraza` compara con tolerancia: acepta `—`, `-` o vacío como «sin valor», y
normaliza separador de miles y coma decimal (`20.000`, `20000` y `20000,00` se
consideran iguales).
