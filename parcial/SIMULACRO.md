# Simulacro

Una página para imprimir. El simulacro es lo único que separa «creemos que
funciona» de «lo vimos funcionar con treinta personas a la vez».

---

## Qué es y qué no es

**Es** una prueba de carga con personas de verdad, en la sala de verdad, a la
misma hora y con los mismos equipos. Su trabajo es **hacer fallar la
infraestructura una semana antes**.

**No es** una evaluación. El quiz dura 20 minutos, es de capítulos 1 y 2, la
dificultad es mínima a propósito y **no tiene peso en la nota**. Si además fuera
difícil, un mal resultado no distinguiría entre «falló la app» y «no supieron»,
que es justo lo que hay que poder distinguir.

Cubre los cinco caminos que el parcial usará: numérico, opción única, opción
múltiple, prueba de escritorio y respuesta abierta. Un camino que no se ejercite
hoy será el que falle el día del parcial.

**No comparte nada con el parcial:** carpeta aparte, base de datos aparte,
código del día distinto y —lo importante— una `edicion` distinta, que entra en
el sorteo de cada ejercicio. Sin eso, el ensayo le enseñaría a cada estudiante
las cifras exactas de su propio parcial.

---

## El día anterior

```bash
export LPF_PEPPER="…"                       # el MISMO del parcial
./parcial/despliegue/simulacro.sh generar --roster roster.csv
```

- [ ] Anunciar al curso: **20 minutos, sin peso en la nota, traigan su equipo.**
- [ ] Imprimir esta página y la hoja de observación de abajo.
- [ ] Comprobar que el código del día del simulacro **no** es el del parcial.

## El día · 40 minutos

| Minuto | Qué pasa |
|---|---|
| 0–5 | Se dicta la URL y el código en el tablero. **Anotar cuántos no logran entrar y por qué.** |
| 5–25 | El quiz. Usted mira el panel, no la clase. |
| 25–35 | Sabotaje (abajo), con voluntarios y en voz alta. |
| 35–40 | Preguntar en voz alta: «¿a quién se le cayó algo?». Anotarlo. |

## Sabotaje · con cuatro voluntarios, a la vista de todos

Se hace **durante** el quiz y se anuncia, para que nadie se asuste.

| # | Qué se le pide al voluntario | Qué debe pasar |
|---|---|---|
| 1 | Cerrar el navegador de golpe y volver a entrar | Recupera todo, con aviso verde, y **el reloj sigue donde iba** |
| 2 | Apagar el wifi 30 segundos y volver a encenderlo | Aviso naranja abajo, se reengancha solo, el reloj descuenta el corte |
| 3 | Entrar desde un segundo equipo con la misma cédula | El primero pasa a «Sesión abierta en otro lugar»; el segundo sigue |
| 4 | Pedirle a usted tiempo extra | Desde el panel, `+5`; su reloj cambia en menos de un segundo |

Y uno que hace usted, sin avisar: **matar el servidor y levantarlo**
(`Ctrl-C` y `./parcial/despliegue/simulacro.sh arrancar`). Todos recargan y
siguen. Es la prueba que más vale y la que más incomoda hacer.

---

## Hoja de observación

Anotar a mano. El informe cuenta lo que la app ve; esto cuenta lo que la app
**no** puede ver.

| | |
|---|---|
| Estudiantes presentes | ____ de ____ |
| No lograron entrar (y por qué) | ____________________ |
| Equipos sin navegador utilizable | ____ |
| Tiempo desde «pueden empezar» hasta que el último está dentro | ____ min |
| ¿La red del salón aguantó? | sí / no / a ratos |
| ¿Los equipos se ven entre sí? (respaldo LAN) | sí / no |
| Lo que más preguntaron | ____________________ |
| Lo que a usted le costó operar | ____________________ |

## El veredicto · lo calcula el guion, no la impresión

```bash
LPF_BD=parcial/app/datos/simulacro.sqlite \
LPF_SALIDA=parcial/salida_simulacro \
Rscript parcial/despliegue/informe_simulacro.R
```

Cuenta como **afectado** quien no entró, quien entró y no pudo responder nada, y
quien tuvo un incidente grave. Si pasan del **10 %**, el parcial va por Moodle.

Ese umbral se fijó por escrito antes de saber el resultado, y esa es toda su
utilidad: el día del simulacro habrá ganas de explicar por qué esos tres casos
«no cuentan». Cuentan.

Reanudar **no** es un fallo: significa que el sistema hizo su trabajo. Pero es
la huella de que algo se cayó, así que el informe lo saca aparte y hay que
mirarlo antes del parcial.

## Después

- [ ] Leer las respuestas abiertas: ahí es donde reportan lo que no se ve.
- [ ] Corregir **solo** lo que el simulacro rompió. Nada nuevo a una semana del parcial.
- [ ] Anotar en `PLAN_PARCIAL1_APP.md` qué falló y qué se hizo.
- [ ] Si el veredicto fue NO APTO: avisar al curso ese mismo día que el parcial
      será en Moodle. No dejarlo para la víspera.
