# Plan · Tarea 7 — Adaptar el capítulo 1 y empaquetar el proceso

> Contexto: `PLAN_MATERIAL_LOGICA_PROGRAMACION_FINANCIERA.md` (§4, §4 bis, §5, §6)
> y `Material html/README.md`. Auditoría previa cerrada en
> `TRASPASO_AUDITORIA_FORMATO.md` el 2026-08-05.
> Plan redactado el 2026-08-05 · Autor del material: Javier Mauricio Sierra.

---

## 0. Qué se decidió antes de planificar

| Decisión | Elegido |
|---|---|
| Alcance de esta pasada | **Tarea 7 completa** — mecánica + editorial + sección 4 (punto flotante) + `FlotanteVisualizer` + 7 cloze |
| Reparto de herramientas | **Script determinista + skill editorial + auditoría ampliada** |
| Comprobaciones nuevas | **9** salidas ejecutadas · **10** contraste de color · **11** prohibición «escriba un programa» |

La comprobación de calidad de la motivación (≤80 palabras, antipatrón) queda
**fuera** por decisión explícita.

---

## 1. Estado medido

No supuesto: medido sobre los archivos.

| Aspecto | Estado |
|---|---|
| `head` del capítulo vs. plantilla | **Idéntico** salvo `<title>` y `description`. La paleta, el CSS y las seis librerías ya están migrados |
| Bloque `LP-CORE` | **Ausente.** El capítulo tiene el `CodeBlock` viejo (95 líneas) y le faltan `CodeTabs`, `Motivacion`, `Ejercicio` y los 5 componentes de ejercicio |
| Región a reemplazar | Líneas **411–977** (567 líneas: `partA` + `CodeBlock` viejo + `partB`) |
| Contenido propio a conservar | Líneas **978–2359** (1 382 líneas) |
| Ejercicios de la taxonomía | **0** de 13 mínimos. Hoy: 6 `MCQ` + 4 `Reto` + 4 `Quiz`, ninguno envuelto en `<Ejercicio tipo="…">` |
| Motivaciones | **0** de 5. Las cinco secciones abren con `<Box>` o `<p>` |
| Bloques de código | 3 `CodeBlock`, **solo Python** |
| `CONFIG` | No existe. `STORAGE_KEY = 'lp_financiera_leccion'` y textos de portada/pie escritos a mano |
| Runtimes | Python 3.10.14 · R 4.6.0 — la comprobación 9 es viable |

---

## 2. Hallazgos

### H1 · Dependencia circular entre el capítulo 01 y la plantilla

`ensamblar.py:33` toma el `head`, `partA` y `partB` **desde
`01_LPF_Introduccion.html`**. Al estampar LP-CORE en ese archivo, el capítulo 01
pasa a ser fuente y destino a la vez.

**Comprobado analíticamente:** tras el estampado, `partA` y `partB` quedan
adyacentes dentro del bloque (0 líneas entre ellas, frente a las 95 del
`CodeBlock` viejo que hoy las separa). `ensamblar.py` reextrae exactamente los
mismos tramos y vuelve a anexar el mismo `lp-core-extra.jsx`: la regeneración es
idempotente. **Falta confirmarlo midiendo** — es la Tarea 5.

### H2 · El guion que ejecuta las salidas no existe en disco

`README.md:121` lo da por existente y `TRASPASO_AUDITORIA_FORMATO.md:273` dice
«conviene conservarlo y correrlo en cada capítulo». Solo hay `ensamblar.py` y
`verificar.py`. Se perdió al cerrar aquella sesión.

Es el único control que caza una salida falsa: encontró un `#> 600000` cuyo
resultado real era 2 400 000 —**el código contradecía la clave de su propio
ejercicio**— y eso no se ve en pantalla. Reconstruirlo es la Tarea 2.

### H3 · El capítulo 01 arrastra el defecto B1

`01_LPF_Introduccion.html:2225` tiene `useState(true)` en `sidebarOpen`. La
corrección (`window.innerWidth >= 1024`) se aplicó a `lp-demo.jsx` el 2026-08-05
y nunca se propagó al capítulo. A 375 px el contenido arranca en **79 px**.

Es el patrón que el propio traspaso describe: *se arregló el mecanismo y se dejó
sin arreglar lo que lo acompaña*. Por eso `migrar.py` reemplaza también el `App`,
no solo el bloque LP-CORE.

### H4 · Orden respecto del plan maestro

La Tarea 7 depende de la T6 (capítulo 3 piloto), que no está hecha. Hacer el 1
primero es defendible —el formato quedó congelado y auditado el 2026-08-05— pero
si el piloto mueve el formato, el capítulo 1 se retoca. Con `migrar.py` eso
cuesta un comando.

---

## 3. Grafo de dependencias

```
migrar.py ──────────┬──→ T4 estampar cap 01 ──→ T5 idempotencia
                    │              │
ejecutar_salidas.py ─┤              ├──→ T6  portada + evaluación
                    │              ├──→ T7  §1 numeración
verificar.py 10 y 11 ┘              ├──→ T8  §2 Von Neumann
                                   ├──→ T9  §3 operadores
                                   └──→ T10 FlotanteVisualizer ──→ T11 §4 flotante ──→ T12 cablear
                                                                            │
                                                                            └──→ T13 cloze ──→ T14 skill
```

Las herramientas van primero porque las usan las ocho migraciones, no solo esta.
La **skill va al final**: codifica lo aprendido recorriendo el capítulo 01, no lo
que suponemos antes de empezar.

---

## 4. Tareas

### Fase 1 — Herramientas · ✅ COMPLETADA (2026-08-05)

Dos cosas se decidieron al construir, y no estaban en el plan:

- **La comprobación 9 solo ejecuta lo que declara salida.** La primera versión
  corría todo bloque de Python y R «por si acaso» y marcaba `TRAZA_CODIGO` como
  error de sintaxis. Y tenía razón sintácticamente: ese bloque lleva los números
  de línea incorporados porque es material para `TablaTraza`, no un programa. Un
  bloque sin `#>` no afirma nada, así que no hay nada que comprobar.
- **La comprobación 10 exime los iconos y sí mira dentro de LP-CORE.** Un `<i>`
  no es texto, y la convención ya permite el gold en iconos. Sin la exención, el
  `fa-dumbbell` de `Reto` avisaría en los ocho capítulos por un uso permitido.
  A cambio, la zona examinada empieza donde empieza el JSX y no en `LP-CORE FIN`,
  de modo que la librería compartida también se audita.

Ambas se descubrieron ejecutando, no leyendo — que es la nota que dejó la
auditoría anterior.

#### Tarea 1 · `migrar.py`

Estampa mecánicamente lo que no debe escribir un modelo a mano.

**Qué hace.** Localiza los tramos **por contenido**, nunca por número de línea
—mismo criterio que `ensamblar.py`— y reemplaza dos regiones tomándolas de
`lp-base.html`:

| Región | Desde | Hasta | Se reemplaza por |
|---|---|---|---|
| Librería | `const { useState, useEffect, useRef } = React;` | cierre de `const Termino =` | Bloque `LP-CORE` completo, con centinelas |
| Aplicación | `const App = () => {` | `root.render(<App />);` | `App` de `lp-base.html` literal |

Además inserta el esqueleto de `CONFIG` tras `LP-CORE FIN` si no existe. **No
toca nada** entre `LP-CORE FIN` y `const App`: ahí vive el contenido del
capítulo. Guarda `.bak` antes de escribir y acepta `--dry-run`.

**Criterios de aceptación**
- [ ] Tras correrlo, el SHA-256 del bloque LP-CORE del capítulo coincide con el de `lp-base.html`
- [ ] Es idempotente: la segunda ejecución no cambia un byte
- [ ] El contenido propio del capítulo (1 382 líneas) sobrevive intacto
- [ ] `--dry-run` informa y no escribe
- [ ] Falla con mensaje claro si no encuentra un ancla, en vez de escribir a medias

**Verificación:** `--dry-run`, luego real, luego `verificar.py --sin-cuota` con la
comprobación 1 en verde; `diff` del tramo conservado contra el `.bak`.

**Dependencias:** ninguna · **Archivos:** `Material html/_plantilla/migrar.py` · **Alcance:** S

---

#### Tarea 2 · `ejecutar_salidas.py` — comprobación 9

Reconstruye el guion perdido (H2).

**Qué hace.** Extrae los objetos `const X = { pseudo: …, python: …, r: …, vba: … }`
del HTML, y para **Python y R**: separa las líneas `#>` (lo declarado) del código
(lo ejecutable), corre el código en un subproceso con timeout y compara la salida
real con la declarada, en orden.

Pseudocódigo y VBA **se omiten declarándolo**, no se dan por buenos en silencio:
el pseudocódigo no es ejecutable y VBA se verifica en Excel real, como dice el
README.

La comparación es **por lenguaje y exacta**, sin normalizar: Python imprime
`2,160,000` con `:,.0f` y R imprime `2160000`. Normalizar escondería justo el
tipo de discrepancia que interesa. (La plantilla ya usa `cat(sprintf(...))` en
lugar de `print()` precisamente porque R mostraría `6e+05`.)

Se invoca desde `verificar.py --con-salidas`, de modo que la auditoría rápida
siga siendo estática y la lenta sea opt-in.

**Criterios de aceptación**
- [ ] Sobre `lp-base.html` pasa en verde (`EJ_INTERES` y `EJ_ACUMULADOR` ya están verificados)
- [ ] **Prueba negativa:** alterar un `#>` a mano lo detecta y señala el bloque
- [ ] Los bloques omitidos se listan como omitidos, con el motivo
- [ ] Un bloque que no termina se corta por timeout y se reporta, no cuelga la auditoría

**Dependencias:** ninguna · **Archivos:** `Material html/_plantilla/ejecutar_salidas.py`, `verificar.py` · **Alcance:** M

---

#### Tarea 3 · Comprobaciones 10 y 11 en `verificar.py`

**10 · Contraste.** Calcula la razón WCAG de cada color declarado en la
configuración de Tailwind del `head` sobre `#F8FAFC`, y lista los que bajan de
3,0:1. Después señala cada uso `text-<color>` de esos colores con su línea, para
que el autor confirme que está sobre fondo oscuro.

> Se emite como **aviso**, no como falla, y esto es deliberado: `text-gold` es
> legítimo dentro de la barra lateral navy (`lp-base.html:2647`) e ilegítimo
> sobre `#F8FAFC`. Distinguirlos exige resolver la ascendencia en el DOM, que el
> análisis estático no hace de forma fiable. Un veredicto automático aquí daría
> confianza falsa; una lista corta de sitios a confirmar, no.

**11 · «Escriba un programa».** Falla si un enunciado pide escribir código desde
cero: `escrib\w+ (un|una) (programa|función|algoritmo|script|macro)`,
`implemente (un|una)`, `desarrolle (un|una)`, `cree (un|una) (programa|función)`.
Patrón deliberadamente estrecho — «escriba el valor en la tabla» es un enunciado
válido de `TablaTraza` y no debe disparar.

**Criterios de aceptación**
- [ ] Cada comprobación tiene su **prueba negativa** (regla de la casa: una comprobación que nunca ha fallado no comprueba nada)
- [ ] La 10 no marca el `text-gold` de la barra lateral como falla
- [ ] La 11 no marca «escriba el valor de `saldo` en la fila 3»
- [ ] Las 8 comprobaciones actuales siguen en verde sobre `lp-base.html`

**Dependencias:** ninguna · **Archivos:** `verificar.py` · **Alcance:** S–M

---

#### ✅ Punto de control 1 — Herramientas · superado el 2026-08-05

- [x] `migrar.py`, `ejecutar_salidas.py` y las comprobaciones 10 y 11 funcionan
- [x] Cada comprobación nueva tiene prueba negativa registrada
- [x] La plantilla pasa las **once** comprobaciones, cuota incluida
- [x] `ensamblar.py` regenera sin cambiar un byte
- [x] La plantilla renderiza en el navegador: 590 nodos, 5 secciones, consola limpia

**Pruebas negativas registradas**

| Comprobación | Prueba | Resultado |
|---|---|---|
| 9 | `#> 600000` → `#> 2400000` (el caso histórico) | caza la discrepancia en Python y R |
| 9 | salida declarada de más | señala «declara «Linea inventada» · produce «(nada)»» |
| 10 | `text-gold` nuevo sobre fondo claro | avisa, con la línea |
| 10 | el mismo uso con `contraste-ok` | callado |
| 10 | `text-[#D4B106]` a mano | avisa: 1,99:1 — el mismo valor del defecto de 2026-08-04 |
| 10 | `text-gold` en un `<i>` | callado: un icono no es texto |
| 11 | `pregunta="Escriba un programa que…"` | falla |
| 11 | «Escriba el valor de saldo», «Trace el algoritmo», y la prosa «en el taller se le pedirá escribir un programa» | ninguna dispara |

**Verificado además por medición, no por afirmación:** en el navegador, el
`text-gold` de la barra lateral está sobre `linear-gradient(rgb(0,26,77)…)` —el
navy de `lp-header`—, que es justo lo que su marca `contraste-ok` declara.

---

### Fase 2 — Migración mecánica del capítulo 01 · ✅ COMPLETADA (2026-08-05)

**Una regresión que introdujo el propio estampado.** `CodeBlock` cambió de firma
al pasar a la librería canónica: el `lang` por defecto era `'python'` y ahora es
`'pseudo'`. Los tres bloques del capítulo no lo declaraban, así que quedaron
mostrando código de Python resaltado con la gramática de pseudocódigo —sin
`comment`, sin `keyword`, sin `builtin`—. No lo detecta ninguna comprobación
—el JSX es válido y el bloque se pinta— y en el navegador se ve como un bloque
de código normal, solo que gris de más.

Se corrigió añadiendo `lang="python"` a los tres. Desaparecerán en la Fase 3 al
convertirse en `CodeTabs`, pero dejar un capítulo mal renderizado «porque luego
se cambia» es exactamente cómo se pierde un defecto.

#### Tarea 4 · Estampar el capítulo 01

Correr `migrar.py` y rellenar el `CONFIG` con los datos del syllabus (fila 1):
`numero: '01'`, `horas: 4`, `ra: 'RA1'`, `storageKey: 'lpf_cap01_introduccion'`,
temas y subtítulo.

> El `storageKey` cambia respecto de `lp_financiera_leccion`: quien ya hubiera
> abierto el archivo pierde la posición guardada. Hoy es irrelevante —no se ha
> distribuido— pero conviene que conste.

**Criterios de aceptación**
- [ ] Comprobación 1 (deriva) y 3 (componentes definidos) en verde
- [ ] El capítulo abre sin errores de consola
- [ ] A 375 px la barra lateral arranca cerrada y el contenido mide ~367 px (**defecto H3 corregido**)
- [ ] Portada y pie leen de `CONFIG`, sin textos duplicados a mano

**Verificación:** servir en 8777, consola limpia, `resize_window` a mobile y medir
`#contenido-scroll.clientWidth`.

**Dependencias:** T1 · **Alcance:** S

---

#### Tarea 5 · Confirmar la idempotencia de `ensamblar.py`

SHA-256 de `lp-base.html` → correr `ensamblar.py` → SHA-256 otra vez.

**Criterios de aceptación**
- [ ] `lp-base.html` no cambia ni un byte
- [ ] Si cambia: se corrige el ancla antes de seguir, y se anota qué la rompió

**Dependencias:** T4 · **Alcance:** XS

---

#### ✅ Punto de control 2 — Formato aplicado · superado el 2026-08-05

- [x] El capítulo está en la librería canónica; solo quedan fallos editoriales
      (5 motivaciones y la cuota de ejercicios)
- [x] **H1 confirmado por medición:** con el capítulo 01 ya estampado,
      `ensamblar.py` regenera `lp-base.html` sin cambiar un byte
      (`6662f394cdfa2369` antes y después). El riesgo alto del plan queda cerrado
- [x] `CONFIG` alimenta portada, chips y pie lateral: «Capítulo 01 · 4 horas ·
      RA1», con el contenido textual de la fila 31 del syllabus
- [x] **Defecto B1 corregido:** a 375 px el contenido mide **367 px**, sin
      desborde horizontal — el número exacto que pedía el traspaso
- [x] El aviso de contraste desapareció solo: el `App` estampado trae su marca
      `contraste-ok`
- [x] Consola limpia; las cinco secciones renderizan distinto y conservan lo
      suyo (22 SVG y el `ConversorBases` en la §1, `VonNeumannSVG` en la §2,
      `InteresCompuestoChart` en la §3)
- [x] Los tres bloques vuelven a resaltarse como Python (`comment`, `keyword`,
      `builtin`, `string-interpolation`)

**Copia de seguridad:** `01_LPF_Introduccion.html.bak`, que dejó `migrar.py`.
Conviene conservarla hasta cerrar la Fase 3: el proyecto no está bajo control de
versiones, así que es el único punto de retorno.

---

### Fase 3 — Adaptación editorial · ✅ COMPLETADA (2026-08-05)

**El E6 se movió a la evaluación.** La «Parte 1» ya era un emparejamiento
conceptual que cruza las tres secciones —mejor sitio para un E6 que cualquier
cosa inventada para la §1, y ya estaba redactado—. Se reescribió el lado derecho:
en vez de definiciones de diccionario, dónde aparece cada concepto en el trabajo
con dinero, que es lo que la taxonomía pide de un E6.

**Cuatro cosas que se corrigieron de paso**, todas del mismo patrón —el material
cambió y el texto que hablaba de él se quedó igual—:

- **Colisión de nombres en la portada.** Llamaba «RA1/RA2/RA3» a tres objetivos
  propios del capítulo, mientras `CONFIG.ra` rotula «RA1» con el RA del syllabus,
  que dice otra cosa. La misma etiqueta significaba dos cosas en la misma página.
  Pasaron a numerarse 1-2-3 bajo «Al terminar el capítulo, usted podrá», con el
  RA del syllabus citado textualmente encima.
- **Prosa que suponía un solo lenguaje.** «Los ejemplos en Python son
  autocontenidos» en los prerrequisitos, y «Python como calculadora de bases»
  como título de sección.
- **Un error técnico que el cambio a cuatro lenguajes destapó.** Los puntos clave
  decían «Python usa evaluación de cortocircuito». En un capítulo de cuatro
  lenguajes eso engaña, y engaña en algo real: **VBA no hace cortocircuito**.
  `cuenta <> 0 And saldo / cuenta > 1` funciona en Python y revienta en VBA con
  división por cero. Ahora lo dice.
- **Código muerto.** `operadoresSnippet` (39 líneas, solo Python) quedó huérfano
  al sustituirlo por `EVALUA_CREDITO` y se retiró.

**Nota sobre la cuota.** Tras esta fase hay **10 de 13** ejercicios. Faltan un
E1, un E3 y un E7, que son exactamente los que la §4 aporta en la Fase 4: por eso
el punto de control 3 se pasa con `--sin-cuota` y la cuota completa se cierra en
el punto de control 4. No es un descuadre, es el reparto previsto en §5.


Rebanadas **verticales**: cada tarea deja una sección entera terminada
—motivación + código en cuatro lenguajes + sus ejercicios— en vez de pasar por
todo el capítulo una vez por tipo de cambio.

#### Tarea 6 · Portada y evaluación

`<Motivacion>` en ambas. Envolver los `MCQ`/`Reto` existentes en
`<Ejercicio tipo="E7">` / `"E8"` donde midan interpretación, y retirar los de
puro recuerdo.

**Dependencias:** T4 · **Alcance:** S

#### Tarea 7 · Sección 1 · Sistemas de numeración

Motivación · `conversionSnippet` → `CodeTabs` ×4 · **E1** `TablaTraza`
(decimal→binario por divisiones sucesivas) · **E2** `MCQ` · **E6**
`Emparejamiento` (base ↔ representación ↔ uso financiero).

Conserva `TablaPosicionesSVG`, `ConversionSVG` y `ConversorBases`.

**Dependencias:** T2, T4 · **Alcance:** M

#### Tarea 8 · Sección 2 · Estructura del computador

Motivación · `hardwareSnippet` → `CodeTabs` ×4 · **E5** `OrdenaPasos` (ciclo
captar–decodificar–ejecutar) · **E4** `Comparador` · **E8** `Reto`.

Conserva `VonNeumannSVG`.

**Dependencias:** T2, T4 · **Alcance:** M

#### Tarea 9 · Sección 3 · Operadores

Motivación · `operadoresSnippet` → `CodeTabs` ×4 · **E1** `TablaTraza` (interés
compuesto) · **E2** `MCQ` · **E3** `DetectaError` (precedencia) · **E7** `Reto`.

Conserva `InteresCompuestoChart`.

> ⚠️ El `DetectaError` es donde reaparece el defecto C-2. `lineaCorrecta`,
> `enunciado` y `explicacion` van **por lenguaje**, o el enunciado se redacta sin
> citar ningún número —que es más robusto—. Lo comprueban las reglas 6 y 8.

**Dependencias:** T2, T4 · **Alcance:** M

**Criterios de aceptación (T6–T9)**
- [ ] Cada sección abre con `<Motivacion>`: escena concreta, tensión, gancho, ≤80 palabras
- [ ] Ninguna abre con «En esta sección estudiaremos…»
- [ ] Los tres `CodeTabs` traen los cuatro lenguajes
- [ ] Toda salida va dentro del bloque, con el prefijo de su lenguaje, y **está ejecutada**
- [ ] Ningún enunciado pide escribir un programa desde cero

---

#### ✅ Punto de control 3 — Contenido adaptado · superado el 2026-08-05

- [x] `verificar.py --sin-cuota --con-salidas` en verde: **las once comprobaciones**
- [x] `ejecutar_salidas.py`: **8 bloques ejecutados y comparados**, todos coinciden
- [x] Las cinco secciones abren con `<Motivacion>`
- [x] Los tres `CodeTabs` traen los cuatro lenguajes
- [x] Consola limpia · `ensamblar.py` sigue sin moverse (`6662f394cdfa2369`)
- [ ] Cuota completa — se cierra en el punto de control 4 (faltan E1, E3 y E7, que aporta la §4)

**Ejercicios probados en el navegador, no supuestos.** Todos los que califican se
condujeron por DOM hasta el veredicto:

| Ejercicio | Prueba | Resultado |
|---|---|---|
| E3 · precedencia | línea correcta en **los cuatro** lenguajes (4 · 5 · 5 · 8) | acierto en los cuatro; cada explicación cita el número que le toca |
| E3 · control negativo | línea 3 en pseudocódigo, que no es el error | rechazado, con «Clasificó bien el tipo, pero el error está en otra línea» |
| E6 · emparejamiento | la permutación `[2,5,4,0,1,3]`, calculada a mano | **6 de 6**, ningún rojo |
| E1 · traza de la meta | las seis celdas ocultas, con «Verdadero»/«Falso» | **6/6 celdas correctas** |
| Pestañas | cambiar el 2.º de los 3 selectores de la §3 | cambió **solo** ese bloque — decisión A1 viva |

**Y verificado por ejecución, no por lectura:** las cinco filas de la traza de
divisiones sucesivas se compararon contra el ciclo corriendo de verdad, y los
tres saldos del interés compuesto resultan exactos en IEEE 754 —comprobado, no
supuesto, porque `1.02` no es exacto en binario y el capítulo entero va a tratar
justamente de eso.

---

### Fase 4 — Sección 4 · La que el plan llama la más importante · ✅ COMPLETADA (2026-08-05)

**Un ejemplo que no servía, cazado antes de escribirlo.** El primer diseño del E3
iba a comparar `(1 000 000 / 3) × 3` contra 1 000 000: parece el caso de libro y
**no falla**, porque los redondeos se cancelan y el resultado vuelve a ser
exactamente 1 000 000. Lo mismo ocurre con `0.1+0.2+0.3+0.4 == 1.0`, que sí da
`True`. Se probaron seis candidatos ejecutándolos y se eligieron los que fallan de
verdad: acumular `0.01` cien veces (da 1.0000000000000007) y `0.1+0.1+0.1`.

Que unos cancelen y otros no es, además, el mejor argumento de la sección: no se
puede predecir cuál de los dos casos le va a tocar, y por eso la regla es no
comparar dinero con igualdad exacta —nunca—, y no «tener cuidado».

**El icono de la sección repite `Binary`.** El catálogo `Icons` vive dentro de
LP-CORE, así que añadir uno obligaría a editar la librería a mano —justo lo que
la comprobación 1 detecta— o a tocar `lp-core-extra.jsx` y reestampar los ocho
capítulos. Para esta sección `Binary` encaja de todos modos: va de representación
binaria. Queda anotado como limitación conocida del diseño.

**La comprobación 10 se ganó el sueldo.** Avisó de tres colores que se
introdujeron en el visualizador de bits (`#FDB913`, `#7DD3FC`, `#F9A8D4`). Se
midieron en el navegador sobre el fondo real del contenedor: **9,66 · 10,04 ·
9,23 : 1** sobre el navy `#001A4D`. Correctos, y ahora indultados con la razón
medida escrita en cada línea —no con un «ya lo miré».


#### Tarea 10 · `FlotanteVisualizer`

Descompone un número en signo / exponente / mantisa (IEEE 754 doble) y muestra el
error absoluto acumulado al sumar 0,01 diez mil veces.

> **Vive en el capítulo 1, junto a `ConversorBases` — no en LP-CORE.** Meterlo en
> `lp-core-extra.jsx` obligaría a reestampar los ocho capítulos para un
> componente que solo usa uno. Pasaría a LP-CORE únicamente si el capítulo 6 lo
> reutiliza al justificar `Currency`.

**Dependencias:** T4 · **Alcance:** M

#### Tarea 11 · Sección 4 · Representación de reales y error de redondeo

Aquí vive el gancho del capítulo: *un centavo de diferencia por transacción,
multiplicado por un millón de transacciones, es un descuadre contable que nadie
sabe explicar*.

Motivación · exposición · `CodeTabs` ×4 con `0.1 + 0.2 ≠ 0.3` · `FlotanteVisualizer`
· **E1** `TablaTraza` (acumulación del error) · **E3** `DetectaError` (`Double`
para dinero) · **E7** `Reto` (qué significa el descuadre para el negocio).

> ⚠️ En VBA con `Currency` **el problema no ocurre**. Eso *es* la lección y hay
> que decirlo, no esconderlo tras un bloque que finja el mismo resultado en los
> cuatro. Enlaza con el capítulo 6 y con el redondeo bancario.

**Dependencias:** T10 · **Alcance:** M

#### Tarea 12 · Cablear la sección nueva

`curriculum`, `CONFIG.temas` y la numeración: la evaluación pasa a ser la sexta
entrada.

**Dependencias:** T11 · **Alcance:** XS

---

#### ✅ Punto de control 4 — Capítulo completo · superado el 2026-08-05

- [x] Las **once** comprobaciones en verde, **cuota incluida y sin avisos**:
      `E1:3 E2:2 E3:2 E4:1 E5:1 E6:1 E7:2 E8:1` = **13 ejercicios**
- [x] **12 bloques** de Python y R ejecutados y comparados contra su salida declarada
- [x] Consola limpia · `ensamblar.py` sigue sin moverse (`6662f394cdfa2369`)
- [x] Las **seis** secciones a 375 px: 367 px de contenido, sin desborde de página
      ni interno —el bloque de 64 bits y la tabla de estrategias incluidos

**Los ejercicios de la §4, conducidos por DOM:**

| Ejercicio | Prueba | Resultado |
|---|---|---|
| E3 · conciliación | línea correcta en los cuatro lenguajes (8 · 6 · 7 · 9) | acierto en los cuatro; cada explicación cita su número |
| E1 · ¿en qué vuelta se rompe? | las tres celdas de la comparación | **3/3 correctas** |
| `FlotanteVisualizer` | los cuatro preajustes | 0,25 y 0,5 → exactos, comparación **Verdadero**; 0,1 y 0,07 → inexactos, comparación **Falso** |

Ese contraste no es decorativo: es lo que permite que el estudiante descubra por
su cuenta que el problema no es «los decimales» sino **qué decimales**.

---

### Fase 5 — Banco Moodle · ✅ COMPLETADA (2026-08-05)

**Hizo falta un verificador nuevo, y encontró dos defectos.** `compilar_banco.R`
comprueba la *estructura* —que los metadatos cuadren, que el answerlist tenga sus
items, que los `num` declaren tolerancia—. Nada de eso dice si la respuesta es
correcta ni si la variante sorteada **enseña algo**. Se escribió
`Banco Moodle/verificar_cloze.R`, que evalúa el chunk `datos` de cada ejercicio
cientos de veces y comprueba cada respuesta **por un camino distinto del que la
calculó** (si el ejercicio convierte a binario dividiendo, el verificador lo
comprueba con `strtoi`).

Lo que encontró, y que ninguna comprobación estructural podía ver:

- **`precedencia_operadores`, en la mitad de las variantes, no enseñaba nada.**
  El ejercicio existe para mostrar que la potencia asocia por la derecha, pero
  con `e1 = e2 = 2` resulta que `b^(2^2)` y `(b^2)^2` **valen lo mismo** —porque
  $2^2 = 2\times2$—, así que las dos asociaciones coinciden justo en el caso más
  obvio. Compilaba, validaba y era inservible. Se sortea ahora hasta que
  `e1^e2 != e1*e2`.
- **`conversion_bases` repetía el valor** en 2 de cada 300 sorteos: los rangos de
  `n_dec` y `n_hex` se solapan, y al coincidir, el literal c) se respondía
  copiando el enunciado. El comentario del código ya decía que eso había que
  evitarlo; el código no lo imponía.

Se guarda el guion en el repositorio **a propósito**: el hallazgo H2 de este
mismo plan es que un verificador equivalente para las salidas se perdió al
cerrar una sesión anterior y hubo que reconstruirlo.

#### Tarea 13 · Los 7 cloze del capítulo 1

Conversión entre bases (num) · valor posicional (num) · componente de Von Neumann
(schoice) · precedencia de operadores (num) · evaluación de expresión lógica
(schoice) · error de redondeo acumulado (num + schoice) · máscara de bits sobre
estado de transacción (mchoice).

**Criterios de aceptación**
- [x] `compilar_banco.R` en verde: los 7 validan y compilan a `xml/cap01.xml`
- [x] `verificar_cloze.R` en verde con **1000 sorteos** por ejercicio
- [x] Prueba negativa registrada: invertir el orden de los bits en
      `mascara_bits` se detecta de inmediato
- [x] El XML trae los tres tipos cloze: 55 `NUMERICAL`, 25 `MULTICHOICE`,
      5 `MULTIRESPONSE` (los sub-items esperados × 5 variantes)
- [x] Las cifras salen del mismo hilo del capítulo, no redactadas aparte

**Los siete, y de dónde sale cada uno**

| Ejercicio | Tipos | Nace de |
|---|---|---|
| `conversion_bases` | num·num·num | §1 — el byte de estado, 0–255 |
| `valor_posicional` | num·num·num | §1 — el peso depende de la posición, no del dígito |
| `componente_von_neumann` | schoice·schoice | §2 — el reparto de tareas y el cuello de botella |
| `precedencia_operadores` | num·num·num | §3 — la potencia asocia por la derecha |
| `expresion_logica` | schoice·schoice | §3 — el mismo defecto del E3: `Y` antes que `O` |
| `redondeo_acumulado` | num·schoice | §4 — leer el descuadre y deducir dónde está |
| `mascara_bits` | num·mchoice | §1 — el `0x0A` con el que abre el capítulo |

**Dependencias:** T11 · **Alcance:** M

---

### Fase 6 — Empaquetar el proceso · ✅ COMPLETADA (2026-08-05)

Instalada en `~/.claude/skills/lpf-capitulo/SKILL.md`, junto a las demás skills
del docente. Comprobado que **todos** los archivos y comandos que nombra existen
y corren, y que la tabla de cuota que cita coincide con la de `verificar.py`.

#### Tarea 14 · Skill `lpf-capitulo`

Se escribe **al final** a propósito: codifica el ciclo ya recorrido una vez.

**Qué contiene:** cuándo dispara · el ciclo `migrar.py` → `CONFIG` → sección a
sección → `verificar.py` → `ejecutar_salidas.py` → cloze · la receta de
`Motivacion` · la taxonomía E1–E8 con su cuota y su componente · la tabla de
ganchos por capítulo · y las trampas conocidas:

- `lineaCorrecta`, `enunciado` y `explicacion` por lenguaje en `DetectaError`
- la salida va dentro del bloque, con el prefijo de su lenguaje, y ejecutada
- el gold nunca como texto sobre fondo claro
- los componentes de un capítulo no van a LP-CORE
- nunca se edita `lp-base.html` ni el bloque LP-CORE a mano

> **La skill remite al README, no lo copia.** Duplicar las convenciones crearía
> deriva: en tres meses `README.md` y la skill dirían cosas distintas y no habría
> forma de saber cuál manda. Se duplica el **procedimiento** (el orden de los
> pasos, que es de la skill); se remite a la **norma** (que es del README).

**Criterios de aceptación**
- [ ] El capítulo 02 se puede empezar solo con la skill
- [ ] No duplica normas que ya viven en `README.md`
- [ ] Nombra los tres scripts y cuándo se corre cada uno
- [ ] Registra la decisión H1 (circularidad) para que nadie la redescubra

**Dependencias:** T13 · **Alcance:** M

---

#### ✅ Punto de control final · 2026-08-05

- [x] Capítulo 01 completo: 13 ejercicios, once comprobaciones, sin avisos
- [x] Banco Moodle: 7 cloze que compilan y pasan 1000 sorteos de contenido
- [x] Los cuatro guiones nuevos con sus pruebas negativas registradas
- [x] Bitácora del plan maestro (§11) actualizada
- [x] Skill instalada y sus referencias comprobadas una a una
- [ ] **Skill probada empezando el capítulo 02** — pendiente: es la prueba real,
      y solo la da escribir el 02 con ella
- [ ] **El bloque de VBA de la §4, comprobado en Excel real** — es lo único del
      capítulo que descansa en criterio y no en medición

```bash
python3 "Material html/_plantilla/verificar.py" --con-salidas
Rscript "Banco Moodle/compilar_banco.R"
Rscript "Banco Moodle/verificar_cloze.R" --reps 1000
```

---

## 9. Qué queda abierto

1. **La skill no está probada.** Se comprobó que todo lo que nombra existe y
   corre, pero eso no es lo mismo que usarla. La prueba es el capítulo 02.
2. **VBA no se ejecuta.** La comprobación 9 lo declara omitido en vez de darlo
   por bueno, y eso está bien; pero el bloque que afirma que `Currency` evita el
   error de redondeo debería verificarse en Excel antes de publicar.
3. **El proyecto sigue sin control de versiones.** El único punto de retorno es
   `01_LPF_Introduccion.html.bak`, que dejó `migrar.py` antes de estampar. Con
   un `git init` la marcha atrás sería por sección y no por archivo.
4. **La Tarea 6 (capítulo 3 piloto) sigue pendiente.** El capítulo 1 se adelantó;
   si el piloto mueve el formato, `migrar.py` reestampa en un comando.

---

## 5. Cuota de ejercicios — distribución objetivo

Mínimo del plan: 13 ejercicios + cuestionario. Se afina al redactar.

| Sección | E1 | E2 | E3 | E4 | E5 | E6 | E7 | E8 |
|---|:--:|:--:|:--:|:--:|:--:|:--:|:--:|:--:|
| 1 · Numeración | 1 | 1 | — | — | — | 1 | — | — |
| 2 · Von Neumann | — | — | — | 1 | 1 | — | — | 1 |
| 3 · Operadores | 1 | 1 | 1 | — | — | — | 1 | — |
| 4 · Flotante | 1 | — | 1 | — | — | — | 1 | — |
| **Total** | **3** | **2** | **2** | **1** | **1** | **1** | **2** | **1** |
| Cuota | 3–4 | 2–3 | 2 | 1–2 | 1–2 | 1 | 2 | 1–2 |

Más el `Quiz` integrador de 10 preguntas en la evaluación.

---

## 6. Riesgos

| Riesgo | Impacto | Mitigación |
|---|---|---|
| `ensamblar.py` deja de ser idempotente al estampar el capítulo 01 | **Alto** — rompe la fuente de la plantilla | Confirmado analíticamente (0 líneas entre `partA` y `partB` tras estampar); T5 lo mide con SHA antes de seguir |
| Un `#>` declarado y no ejecutado | **Alto** — el material enseña un resultado falso | Comprobación 9; ya cazó un caso real |
| El `DetectaError` nuevo repite el defecto C-2 | Medio — califica mal y en silencio | Comprobaciones 6 y 8; redactar sin citar números |
| Formato de salida distinto entre Python y R | Medio — falsos positivos en la 9 | Comparación por lenguaje, sin normalizar |
| `FlotanteVisualizer` acaba en LP-CORE | Medio — obligaría a reestampar los 8 capítulos | Componente local del capítulo 1, como `ConversorBases` |
| Escribir la skill antes de recorrer el ciclo | Medio — codificaría supuestos | Va en la Fase 6 |
| El piloto (cap. 3) mueve el formato después | Bajo | Formato auditado el 2026-08-05; `migrar.py` reestampa en un comando |
| VBA no se ejecuta | Bajo, **declarado** | La 9 lo omite explícitamente; se verifica en Excel real |

---

## 7. Supuestos declarados

1. La sección de punto flotante se numera **4** y la evaluación pasa a ser la
   sexta entrada del `curriculum`.
2. `FlotanteVisualizer` es **local** al capítulo 1. Pasaría a LP-CORE solo si el
   capítulo 6 lo reutiliza.
3. El cambio de `storageKey` pierde la posición guardada de quien ya hubiera
   abierto el archivo. Aceptable: no se ha distribuido.
4. La comprobación 10 emite **avisos**, no fallas, por lo explicado en la Tarea 3.

Corregir cualquiera de los cuatro antes de la Fase 2 cuesta poco; después, más.

---

## 8. Comandos

```bash
cd "Logica de programacion"

python3 "Material html/_plantilla/migrar.py" --dry-run "Material html/01_LPF_Introduccion.html"
python3 "Material html/_plantilla/migrar.py"           "Material html/01_LPF_Introduccion.html"

python3 "Material html/_plantilla/ensamblar.py"
python3 "Material html/_plantilla/verificar.py"
python3 "Material html/_plantilla/verificar.py" --con-salidas
python3 "Material html/_plantilla/verificar.py" "Material html/_plantilla/lp-base.html" --sin-cuota

Rscript "Banco Moodle/compilar_banco.R"
python3 -m http.server 8777 --directory "Material html"
```

---

## 10. Apéndice · El fallo intermitente del banco (2026-08-05)

Apareció en la comprobación final, cuando todo lo demás estaba cerrado:
`compilar_banco.R` fallaba **1 de cada 12 ejecuciones**, con las siete
validaciones en verde y un `x exams2moodle falló: all numeric items must be
finite and non-missing` al final. Un fallo fijo es molesto; uno intermitente
acaba rompiendo el banco el día de la entrega.

**La causa.** knitr aplica `format_sci` a los numéricos que rendera en línea y,
a partir de **10⁴**, los convierte a notación científica: en HTML, el 50000 sale
como `5 &times; 10<sup>4</sup>`. Medido:

| valor | `format()` | `format_sci(v, "html")` |
|---|---|---|
| 9 000 | `9000` | `9000` |
| 50 000 | `50000` | `5 &times; 10<sup>4</sup>` |
| 19 683 | `19683` | `1.9683 &times; 10<sup>4</sup>` |
| 11 111 010 | `11111010` | `1.111101 &times; 10<sup>7</sup>` |

Esa cadena caía dentro de `exsolution`, donde `as.numeric()` da `NA`. Solo
ocurría cuando el sorteo producía un valor grande —en `valor_posicional`, cuando
salía `pos = 4`—, de ahí la intermitencia.

**Alcance.** Era un defecto **latente en cinco ejercicios**, no en uno:
`valor_posicional` (aporte hasta 90 000), `conversion_bases` (el binario, hasta
ocho cifras), `precedencia_operadores` (r3 hasta 19 683) y también el **piloto del
capítulo 3**, cuyos importes van en millones y que arrastraba el mismo defecto
desde antes de esta sesión. Todos envuelven ahora sus números en
`format(x, scientific = FALSE)`; donde el valor ya era una cadena —el binario— se
usa la cadena y no `as.numeric()`.

**Verificación:** 60 compilaciones seguidas del banco completo, **0 fallos y 0
avisos de TeX**, frente a ~1 de cada 12 antes.

**Lo que NO se pudo hacer, y por qué se dice.** Se intentó una regla en
`validar()` que marcara los `num` no finitos. **No dispara nunca**: la validación
corre sobre `exams2html`, que interpreta bien el valor; solo el driver de Moodle
lo rompe. Se retiró en vez de dejarla —una comprobación que nunca ha fallado no
está comprobando nada— y en su lugar quedó una nota explicando el mecanismo, más
`compilar_uno_a_uno()`, que ante un fallo de la compilación conjunta recompila
ejercicio por ejercicio para **señalar el culpable**, que es lo que faltaba al
diagnosticarlo. Probado como unidad: sobre una carpeta con un ejercicio roto y
uno sano, señala el roto y solo el roto.
