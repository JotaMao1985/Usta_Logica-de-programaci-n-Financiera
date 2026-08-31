# Traspaso · El parcial servido por app propia

> **Para retomar en una sesión nueva.** El plan completo, con los 29 hallazgos y
> las fases fechadas, está en `PLAN_PARCIAL1_APP.md`. Este documento es lo que
> hay que leer **antes** de tocar nada.
>
> Rama: `parcial/app-examen`, 18 commits por delante de `main`.
> Fecha: 2026-08-30 · Docente: Javier Mauricio Sierra.

---

## 1. Dónde está el proyecto

**Construido y probado: D1 a D7.** La app sirve el examen, autoguarda, reanuda,
lleva su propio reloj, releva sesiones, aguanta que le maten el servidor debajo
y se opera desde un panel docente aparte. El respaldo en papel sale del mismo
sorteo. El simulacro tiene su quiz, su guion de sabotaje y un informe que emite
el veredicto.

**Sin ejecutar: D8.** El VPS no se ha provisionado, la sala no se ha visitado y
el simulacro no se ha hecho. Nada de eso se puede hacer desde una sesión de
trabajo: son actos del docente.

**No hay exámenes reales generados.** Faltan las dos cosas de la §3.

### Decisión de fondo que conviene no olvidar

Esto se construyó **porque el banco ya existía**. Los 21 cloze de los capítulos
1 a 3, con sus variantes por estudiante, estaban compilados desde la Tarea 6. Lo
único que faltaba era la plomería. Si en algún momento hay que decidir entre
esta app y Moodle, el argumento no es «ya invertimos mucho»: es que el Trazador
interactivo, el monitoreo en vivo y el tiempo extra por persona no existen en el
LMS. Todo lo demás Moodle lo hace, y el XML del banco sigue compilado y listo.

---

## 2. Qué hay, archivo por archivo

| Archivo | Qué hace |
|---|---|
| `parcial/blueprint.yml` | Qué entra en el parcial. **Única fuente de verdad.** |
| `parcial/blueprint_simulacro.yml` | Lo mismo para el ensayo. `edicion` distinta (§4). |
| `parcial/trazas.R` | Las tres pruebas de escritorio, como función de una semilla. |
| `parcial/generar.R` | Roster → examen JSON + clave aparte + PDF de respaldo. |
| `parcial/calificar.R` | Un solo calificador, sobre `exams_eval()`. 57 pruebas. |
| `parcial/esquema.R` | El esquema de la base. **Lo cargan las dos apps** (§4). |
| `parcial/app/app.R` | La app del estudiante. |
| `parcial/panel/app.R` | El panel docente, app y puerto aparte. |
| `parcial/vendorizar.R` | Baja los 40 archivos externos y reescribe los CSS. |
| `parcial/plantilla_papel.tex` | Plantilla del examen impreso. |
| `parcial/despliegue/comprobar.R` | **Doce comprobaciones que se niegan a abrir el parcial.** |
| `parcial/despliegue/pepper.sh` | Crea y custodia el pepper. |
| `parcial/despliegue/arrancar.sh` | Comprueba y arranca. Si falla, no arranca. |
| `parcial/despliegue/simulacro.sh` | Lo mismo para el ensayo, todo aparte. |
| `parcial/despliegue/informe_simulacro.R` | El veredicto del simulacro, calculado. |
| `parcial/RUNBOOK.md` | Una página para llevar impresa el día del parcial. |
| `parcial/SIMULACRO.md` | Protocolo del ensayo, sabotaje y criterio de aborto. |

**Nada de esto se versiona** y es a propósito: `roster.csv`, `parcial/salida/`,
`parcial/salida_simulacro/`, `parcial/app/datos/` y el pepper.

---

## 3. Lo que bloquea la generación real

Dos cosas, y ninguna está en el repositorio.

1. **El roster.** `Rscript parcial/generar.R --plantilla-roster` escribe el CSV
   con el encabezado correcto. La cédula admite puntos y espacios.
2. **El pepper.** `source ./parcial/despliegue/pepper.sh` lo crea una vez fuera
   del repositorio. **Cópielo a un gestor de contraseñas el mismo día.**

Con las dos: `Rscript parcial/generar.R --roster roster.csv`.

### Decisiones abiertas · hay que tomarlas ANTES de generar

- **Reparto de puntos (§H16).** Hoy es por ejercicio, y nueve de los 21 tienen un
  solo sub-ítem: cinco de capítulo 3 valen **15 puntos en un solo número**, y
  cuatro de capítulo 2 valen 10. Un dato suelto vale entre 3,33 y 15 puntos.
  Recomendación pendiente de su respuesta: **sacar del blueprint esos cinco de
  cap03** —el capítulo ya se evalúa con la traza— y dejar los tres que tienen
  tres sub-ítems.
- **El ítem abierto.** Está redactado (diagnóstico de un error de precedencia).
  Cámbielo si prefiere otro.
- **Código del día y clave del panel.** Distintos entre sí; `comprobar.R` lo exige.

---

## 4. Las trampas · lo que costó tiempo descubrir

Todo esto está resuelto en el código y comentado allí. Se repite aquí para que
nadie lo vuelva a descubrir por su cuenta.

| # | Trampa | Dónde |
|---|---|---|
| H12 | R arranca en locale `C` sin `LANG` y rompe los acentos. Los guiones se lo fijan solos. | `generar.R` |
| H13 | **Seis ejercicios del banco no compilan a PDF.** R/exams antepone `\def\LTcaptype{none}` a las tablas y el contador ya no existe. Cura: `\newcounter{none}`. | `plantilla_papel.tex` |
| H14 | `babel` con `spanish` revienta con `64.8\,\%` en modo matemático. `es-noshorthands` no lo evita. **No volver a añadirlo.** | `plantilla_papel.tex` |
| H17 | `radioButtons` deja marcada la primera opción: quien no responde entrega algo que nunca dio. `selected = character(0)`. | `app.R` |
| H19 | `allowReconnect(TRUE)` **no hace nada** bajo `runApp()`. Va en `"force"`. Exige un solo proceso de R o sesiones pegajosas. | `app.R` |
| H20 | Sin `local()` en el bucle de observadores, todo el examen se guarda en un solo campo. | `app.R` |
| H21 | El esquema de la base estuvo duplicado y el panel se quedó en blanco. Vive en `esquema.R`. | ambas apps |
| H22 | Un pepper distinto del que generó los exámenes deja fuera a todos **y nada más se ve mal**. La huella lo caza. | `comprobar.R` |
| H27 | `shiny-bound-input` puesta a mano hace que Shiny **se salte** el campo. | `app.R` |
| H29 | Sin `edicion` en la semilla, el simulacro reparte las cifras del parcial. | `generar.R` |
| H18 | Bootstrap activa `scroll-behavior: smooth`; con el navegador en segundo plano las comprobaciones automáticas dicen que la página no baja. No es cierto. | `examen.css` |

### Dos principios de diseño

- **Se califica lo guardado, no la pantalla.** `entregar()` vuelca los campos a
  la base y luego lee de la base. Es lo que permite cerrar bien un examen cuyo
  navegador ya se fue.
- **La clave nunca viaja al navegador.** Ni en los cloze, ni en las celdas de la
  traza. `comprobar.R` lo verifica en cada generación.

---

## 5. Comandos

```bash
Rscript parcial/generar.R --plantilla-roster      # una vez
source ./parcial/despliegue/pepper.sh             # una vez, y guárdelo
Rscript parcial/generar.R --roster roster.csv
Rscript parcial/despliegue/comprobar.R            # si falla, no se abre
./parcial/despliegue/arrancar.sh                  # examen + panel
ssh -N -L 8899:127.0.0.1:8899 usuario@servidor    # llegar al panel

./parcial/despliegue/simulacro.sh generar --roster roster.csv
./parcial/despliegue/simulacro.sh arrancar
Rscript parcial/despliegue/informe_simulacro.R    # el veredicto

Rscript parcial/calificar.R --pruebas             # 57 pruebas
Rscript parcial/vendorizar.R --verificar
```

---

## 6. Lo que NO hay que hacer

- **No regenerar con otro pepper** una vez repartido el examen: los
  identificadores cambian y nadie entra.
- **No arrancar el parcial con la base de datos del simulacro o de las pruebas
  dentro.** El curso entero aparecería como «ya entregó». `comprobar.R` lo
  detiene; no lo salte.
- **No poner el mismo valor** en el código del día y en la clave del panel.
- **No publicar el panel en internet.** Va en `127.0.0.1` y se llega por túnel.
- **No subir `roster.csv` al servidor.** Las cédulas no salen de su máquina; el
  `manifiesto.csv` que sí sube lleva nombres, no cédulas.
- **No añadir `babel` a la plantilla del papel** (H14).

---

## 7. Riesgo que sigue vivo

`Banco Moodle/` completo vive **solo en la rama `cap03/control-secuencial`**, de
la que sale esta. `main` no tiene ni un ejercicio. Mientras esas ramas no se
fundan, el banco y el parcial cuelgan de trabajo sin integrar, con un único
punto de fallo. Es el §H15 del plan y sigue sin resolverse porque fundir ramas
es decisión del docente.
