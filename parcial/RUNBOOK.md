# Runbook del parcial

Una página. Se imprime y se lleva al salón, porque si falla la red no se puede
consultar en pantalla.

---

## La noche anterior

```bash
export LPF_PEPPER="…"          # el MISMO de siempre. Si cambia, no entra nadie.
export LPF_CODIGO="…"          # el código del día
export LPF_PANEL_CLAVE="…"     # distinta del código del día

Rscript parcial/generar.R --roster roster.csv
Rscript parcial/despliegue/comprobar.R
```

- [ ] `comprobar.R` termina en **«Todo en orden»**. Si no, no se abre el salón.
- [ ] La base de datos está **vacía**. Los datos de prueba dejan a estudiantes
      reales marcados como «ya entregó» y sin poder entrar.
- [ ] Abrir **tres exámenes al azar** y leerlos.
- [ ] Imprimir `salida/papel/*.pdf`. Sí, en papel. Es el plan B.
- [ ] Copiar `salida/{examenes,claves}` al servidor. **`roster.csv` no se sube.**
- [ ] Anotar aquí el pepper, el código y la clave del panel, y guardar el papel
      en un lugar distinto del maletín del portátil.

## Media hora antes

- [ ] `./parcial/despliegue/arrancar.sh`
- [ ] Entrar con una cédula de prueba **que no sea de nadie del curso** y salir.
- [ ] Abrir el panel por el túnel: `ssh -N -L 8899:127.0.0.1:8899 usuario@servidor`
- [ ] Dejar el respaldo LAN listo (abajo) y el portátil cargado.

## Durante

- El código del día se **escribe en el tablero**, no se manda por chat.
- El panel se mira cada tanto. Tres cosas importan:
  **sin entrar** (alguien no logró entrar), **requieren atención**
  (tiempo vencido o sin reloj) y **sin señal >2 min** (se le cayó algo).
- Tiempo extra: botones `+5` / `+10` en la fila de esa persona. Surte efecto en
  su reloj en menos de un segundo, sin tocarle la sesión.

## Si algo falla

| Qué pasa | Qué hacer |
|---|---|
| Alguien no entra | Que revise el documento (sin puntos da igual, se normaliza). Si el panel lo muestra «sin entrar» y el nombre está, el problema es el código del día. |
| Alguien dice que perdió lo escrito | No lo perdió. Que recargue y vuelva a entrar: sale el aviso verde de recuperación. |
| A alguien se le cayó la red | La app se reengancha sola. Si no, recargar. |
| **Se cae el servidor** | `./parcial/despliegue/arrancar.sh` otra vez. Las respuestas están en disco; los estudiantes recargan y siguen. |
| **Se cae la red del salón** | Pasar al respaldo LAN (abajo). |
| **Nada funciona** | Repartir los PDF impresos. El examen es el mismo, con las mismas cifras. Anunciar en voz alta cuánto tiempo queda. |

## Respaldo LAN — dos minutos

Con el portátil en la misma red que los equipos del salón:

```bash
export LPF_PEPPER="…"; export LPF_CODIGO="…"; export LPF_PANEL_CLAVE="…"
export LPF_SALIDA="$HOME/parcial/salida"
R -e "shiny::runApp('parcial/app', port=8080, host='0.0.0.0', launch.browser=FALSE)"
ipconfig getifaddr en0     # la dirección que se dicta al salón
```

Se anuncia `http://<esa-dirección>:8080`. Las respuestas que ya estaban en el
servidor **no** se mueven solas: al terminar hay que unir las dos bases con
`parcial/app/datos/eventos.jsonl` de cada una. Por eso el respaldo LAN es el
penúltimo recurso y el papel el último.

## Al terminar

- [ ] Panel → **Exportar al servidor** y **Descargar CSV**. Las dos.
- [ ] Copiar `parcial/app/datos/{parcial.sqlite,eventos.jsonl}` a dos sitios.
- [ ] Calificar las sustentaciones en el panel. Las notas con `*` siguen provisionales.
- [ ] Cruzar `sid → nombre` con `manifiesto.csv` y subir al LMS.
- [ ] **Borrar del servidor** los datos y apagarlo.

---

## Lo que no está probado

`parcial.service` y `Caddyfile` se escribieron sin un servidor donde probarlos.
El simulacro (D8) es la primera vez que se ejecutan de verdad: cuente con que
algo ahí falle y déjese margen.
