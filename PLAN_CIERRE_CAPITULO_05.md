# Cierre del capítulo 5 · plan de ejecución

**Fecha:** 2026-11-02. **Rama:** `cap05/cierre05`, en el worktree
`.claude/worktrees/cierre05`, desde `main` en `c21ad99`.

## Contexto

El docente aprobó en el artefacto «Cierre del capítulo 5» los puntos que faltan
para cerrar «Control repetitivo». Este plan ejecuta los que están en `hacer` y
son trabajo de Claude, por fases, y verifica cada una antes de seguir. Nada se
fusiona en `main` ni se sube: la fusión la aprueba el docente.

**Por qué la rama no se llama `cap05/cierre`.** Esa rama ya existía al empezar,
sacada en el worktree `.claude/worktrees/cap05` (creada a las 16:59 desde
`main`), con tres archivos modificados sin commit que no son de esta tarea:
`Material html/README.md`, el plan maestro y `PLAN_TAREA10_CAPITULO_05.md`, en una
versión anterior a `c21ad99`. Git no deja sacar la misma rama en dos worktrees, y
mover o limpiar ese worktree no es de esta tarea. Se trabaja en `cap05/cierre05`
y no se toca el otro.

**Línea base, medida antes de cambiar nada:**
- `verificar.py --con-salidas`: los cinco capítulos pasan (19 ejercicios en el 5).
- La sonda, en sus cuatro modos: los cinco capítulos pasan, sin errores de
  JavaScript.

**Lo que no es de esta tarea**, aunque esté en `hacer`:
- `revision-docente` (la lectura completa) y `safari` (Safari e iPhone) son del
  docente.
- `ramas` espera a que se publique, y `publicar` está en `despues`: no se borra
  ninguna rama ni worktree.
- `notprose` se aplaza: solo se anota.
- `debug-print` se anota en el plan del capítulo 6.

## Fase 1 · Capítulo 5: texto y ejercicios

**`menores-prosa`.** Las frases de la §3 «Menores» de `REVISION_CAPITULOS_04_05.md`
que siguen en el capítulo, buscadas por el texto:

| Frase | Qué se hace |
|---|---|
| «a sí misma» en `saldoMora` | Ya no está: la justificación del E2 se reescribió el 2026-10-20 (G5.3). La única «a sí misma» que queda es «una variable que se lee a sí misma», que concuerda con «variable». No se toca |
| «un renglón más abajo» | Son **tres** en los cuatro lenguajes: `intereses <- 0` deja su sitio entre `saldo` y `meses`, y pasa debajo de `meses`, de la línea en blanco y de la cabecera del ciclo. Se corrige en la motivación, en «bajó un renglón», en el comentario de `EJ_AHORRO_MAL` y en el comentario de código de los cuatro lenguajes |
| La portada: «fuera del ciclo y no dentro» | Que diga lo que enseña la sección 5: cada inicialización justo antes del ciclo que acumula su variable, y no dentro de él |
| «El ciclo no tiene un error» | Que diga que la condición no está mal y que lo que falta está en el cuerpo |
| «Cobranza ofrece» | «El área de cobranza le ofrece un acuerdo a un cliente» |
| «Al migrarlo de Excel» | Lo que se migra es la macro que calcula el plan, no el plan |
| «el ciclo que recorre su variable» | «el ciclo que acumula su variable» |
| «abono 0: el cliente no alcanza a abonar este mes» | El abono del acuerdo es fijo: la glosa pasa a ser un abono mal registrado, sin decir qué hace el ciclo |

No cambia ninguna clave ni cifra. Cambian tres comentarios de código VBA, y con
ellos la huella del arnés: la fase 5 pega el módulo nuevo.

**`menores-ejercicios`.**
- **E2 de la sección 2, opción a.** La glosa «la deuda se cubre justo con el
  primer abono» dice que hay un primer abono, y con eso que la opción es falsa. Se
  reescribe sin decir si el ciclo entra.
- **E4 de la sección 4, la clave.** «Escribe las cuotas 1 a n, también con n
  igual a 0» no se entiende, y con n = 0 la fórmula de la cuota divide entre
  cero. La clave dirá que B escribe las mismas filas que A, de la cuota 1 a la n.
  La justificación conserva el caso n = 0, que responde a la opción d, y aclara
  que solo mira los ciclos: un plan de cero cuotas no tiene cuota que calcular.
  Se ejecutan en Python y en R las dos versiones con n de 0 a 24 y la fórmula con
  n = 0.
- **El E2 de las variables en camelCase.** Las opciones ya no las nombran desde
  G5.3; las nombra la justificación, en camelCase y con un paréntesis para Python
  y R. Se reescribe nombrando cada variable por lo que lleva, que vale en los
  cuatro lenguajes, y el paréntesis sobra.
- Ninguno cambia qué opción es la correcta. Se miden las reglas 16, 17 y 18.

*Verificación:* cada ejercicio cambiado, conducido en Chrome sin ventana por CDP
hasta el veredicto, en los cuatro lenguajes, con una respuesta buena y una mala.
Las props se leen por `__reactFiber$`.

**`tasas`.** Un `Box` en la sección 1, junto al ahorro programado, que es donde
aparece la primera de las dos: el 0,9 % mensual de ese ahorro y el 2 % mensual
de las secciones 4 y 5 son ilustrativos. Da las equivalencias efectivas anuales,
ejecutadas: (1,009)¹² − 1 y (1,02)¹² − 1 = 26,82 %. Sin tasa de usura concreta:
la Superintendencia Financiera la certifica, y una tasa real se compara con la
vigente. Las cifras con espacio duro (regla 21). El 5 % del capítulo 4 no se
toca: queda como pregunta.

*Verificación de la fase:* `verificar.py --con-salidas` en los cinco capítulos,
`comprobar_cifras.js` sobre el 5, la sonda en sus cuatro modos, las pruebas por
DOM, y a 375 px ningún elemento nuevo fuera del viewport, con la barra lateral
cerrada.

## Fase 2 · Capítulo 5: flujogramas

**`menores-graficos`.** Cada flujograma contra el bloque que acompaña:
- **`FlujogramaMientras`** acompaña a `EJ_ACUERDO`, que asigna `saldo`, `abono`
  y `meses` y escribe `meses` y `saldo`. Dibuja «Leer saldo, abono» y solo
  «Escribir meses». Pasa a un proceso de tres líneas y a «Escribir meses, saldo».
- **`FlujogramaPara`** dibuja el cobro (`Leer n, cuota`, `cobrado`), y lo que
  sigue es `EJ_PLAN_PAGOS`. Se redibuja ese plan: los datos, la cuota, el saldo y
  el acumulador de intereses, el `Para` desarmado y el cuerpo con su `Escribir`.
- **`FlujogramaAnidado`** coincide con `TZ_CARTERA`: «Leer saldo, abono» resume
  sus dos lecturas. No se toca.
- **`FlujogramaRepita`** no omite nada que contradiga `EJ_VALIDAR_MONTO` (le
  falta el mensaje que pide el monto, que es de forma). No se toca.
- Su `DESCRIPCION` accesible, actualizada.

**`flechas-ids`.** Como en el capítulo 4: un `flechaDefs(id)` y un id por
componente, `lp-flecha5-<Componente>` y `lp-flecha5-<Componente>-retorno`.

*Verificación:* en el DOM, ningún id repetido en todo el documento y cada
`url(#…)` de un `marker-end` encuentra su marcador, en las secciones de los
flujogramas, a escritorio y a 375 px, con prueba negativa. Una captura de cada
flujograma. `verificar.py --con-salidas` y la sonda en sus cuatro modos.

## Fase 3 · Herramientas

Un commit por punto, cada uno con su prueba negativa registrada.
- **`regla11`.** Que deje pasar «¿Qué escribe el programa?» —el programa es el
  sujeto— y siga cazando «Escriba un programa que…». Se prueban los dos sentidos.
- **`cifras-app`.** `comprobar_cifras.js --corregir` salta el tramo del `App`,
  delimitado con las anclas de `migrar.py`, y dice que el cambio va en
  `lp-demo.jsx`. Prueba negativa sobre una copia.
- **`demo-regla17`.** La función de la regla 17 sobre `lp-base.html` encuentra los
  tres ítems; se reescriben en `lp-demo.jsx` sin cambiar la clave y se ensambla.
  El diff de `lp-base.html` cae solo en la demostración, las reglas 1 y 23 pasan
  sin reestampar, y ensamblar dos veces no mueve un byte.
- **`cotejar`.** Regla 25, de aviso: las `//>` de cada bloque contra las `#>` de
  Python. VBA fuera. Primero se mide en los cinco capítulos; si hay diferencias
  legítimas, una normalización mínima y justificada. Prueba negativa con un `//>`
  alterado en una copia. Docstring y README, a veinticinco.

## Fase 4 · Anotaciones

- **`notprose`:** en la bitácora y en el estado de L4, que el docente aprobó
  dejarlo para el rediseño de los componentes.
- **`debug-print`:** en el plan del capítulo 6 (§5), explicar el espacio del
  signo y las zonas de 14 columnas de `Debug.Print`.

## Fase 5 · VBA en Excel (opcional)

`ejecutar_vba.py preparar`, pegar los dos módulos en `Arnes_VBA_LPF.xlsm`,
compilar, guardar y `comparar`. Solo si el acceso al escritorio se concede; si
no, se anota y se salta.

## Fase 6 · Cierre

Bitácora (§11), línea de Estado de `PLAN_TAREA10_CAPITULO_05.md`, «Estado al
2026-11-02» en la revisión, verificación final completa y el artefacto
actualizado.

## Puntos de control

### PC1 · Fase 1 · texto, ejercicios y tasas · 2026-11-02

**Hecho.**
- **Siete frases de la revisión**, corregidas: «tres renglones» en la motivación,
  en «bajó tres renglones», en el comentario de `EJ_AHORRO_MAL` y en el
  comentario de código de los cuatro lenguajes; la portada; «La condición no está
  mal»; «El área de cobranza»; «la macro de Excel que lo calcula»; «el ciclo que
  acumula su variable»; y el abono 0, ahora «mal registrado». La octava, «a sí
  misma», ya no estaba (ver la tabla de la fase 1).
- **Los tres detalles de ejercicios.**
  - La glosa de la «a» del E2 de la sección 2: «la deuda es justo del tamaño de
    un abono».
  - La clave del E4 de la sección 4: «escribe las mismas filas que A, de la
    cuota 1 a la n». La justificación aclara que n = 0 solo mira los ciclos.
  - La justificación del E2 de la sección 1 nombra cada variable por lo que lleva
    y ya no necesita el paréntesis de Python y R.
- **La nota de las tasas,** un `Box` junto al ahorro programado de la sección 1.

**Medido.**
- **Las cifras, en Python y en R:**
  - (1,02)¹² − 1 = 26,8242 % y (1,009)¹² − 1 = 11,3510 %;
  - las versiones A y B del E4 escriben las mismas filas, de la 1 a la n, con
    n de 0 a 24;
  - con n = 0, la fórmula de la cuota: Python lanza `ZeroDivisionError` y R da
    `Inf`;
  - «tres renglones» en los cuatro lenguajes, contado sobre los bloques: la
    línea pasa de 1 a 4 renglones debajo de `saldo <- 0`.
- **Regla 17:** la clave del E4 mide 109 caracteres, y el distractor más largo,
  113. El E2 de la sección 2 es de selección múltiple y la regla no lo mide.
- **Por DOM, en Chrome sin ventana, 123 comprobaciones**, todas bien:
  - los tres ejercicios, en los cuatro lenguajes;
  - las opciones del DOM son las de las props, leídas por `__reactFiber$`;
  - la respuesta buena da «¡Correcto!» y la mala, «Revisa la explicación»;
  - la explicación trae el texto nuevo y ya no el viejo;
  - en el `Comparador`, la pestaña activa muestra el código de su lenguaje.
- **A 375 px,** con la barra lateral cerrada (0 px), la nota va de 24 a 343 px.
  Ningún elemento sale; la prueba negativa (un div de 600 px dentro de la nota)
  sí sale.
- **La regla 21** cazó las cuatro cifras de la nota antes del espacio duro.
  `--corregir` cambió esos cuatro espacios y ninguno más.
- **`verificar.py --con-salidas`:** los cinco pasan. **La sonda,** en sus cuatro
  modos: los cinco pasan, con los mismos recortes a 375 px que la línea base.

**Para la fase 5.** Cambió el comentario de una línea del VBA de `EJ_AHORRO_MAL`,
y con él la huella del arnés: hay que pegar el módulo nuevo.

### PC2 · Fase 2 · flujogramas · 2026-11-02

**Hecho.**
- **`FlujogramaMientras`** asigna lo que asigna `EJ_ACUERDO` (`saldo ← 2350000`,
  `abono ← 400000`, `meses ← 0`, en un proceso de tres líneas) y escribe lo que
  escribe: `meses, saldo`. Antes leía `saldo` y `abono` y escribía solo `meses`.
  El pie de figura pasa a condicional («si el saldo ya fuera cero»), porque el
  saldo ya no se lee.
- **`FlujogramaPara`** dibuja el plan de pagos de `EJ_PLAN_PAGOS`, que viene
  después:
  - los datos;
  - la cuota, partida en dos líneas;
  - `Escribir cuota`;
  - `saldo` y `totalIntereses`;
  - el `Para` desarmado;
  - el cuerpo de cuatro asignaciones;
  - el `Escribir` de cada fila;
  - el total de intereses.

  Mide 893 unidades de alto y, como el anidado, tiene un ancho máximo de 300 px.
- **`FlujogramaAnidado` y `FlujogramaRepita`** coinciden con su código y no
  cambiaron de dibujo.
- **`fjProceso` y `fjEntradaSalida`** aceptan más de dos líneas, con las mismas
  medidas de antes para una y dos.
- **Las dos `DESCRIPCION` nuevas** no llevan cifras: «saldo y abono reciben sus
  valores».
- **`flechaDefs(id)`, como en el capítulo 4:** cada flujograma define
  `lp-flecha5-<Componente>` y `lp-flecha5-<Componente>-retorno`, y `fjFlecha` y
  `fjRetorno` reciben ese id. Son cinco componentes: la simbología, el
  `Mientras`, el `Repita`, el `Para` y el anidado.

**Medido en el DOM**, en las nueve lecciones, a escritorio y a 375 px, con la barra
lateral cerrada:
- **Antes:** la lección 2 tenía `lp-flecha5`×2 y `lp-flecha5-retorno`×2.
- **Ahora:** ningún id repetido en el documento, y los 39 `marker-end` de las
  lecciones 2 a 5 (8 + 5 + 12 + 14) encuentran su `<marker>`.
- **La prueba negativa:** un marcador clonado sale como repetido, y una
  referencia a `#lp-flecha5-no-existe`, como rota.
- **Las capturas,** a 375 px: las cinco figuras pintan sus puntas.

**`verificar.py --con-salidas`:** los cinco pasan. **La sonda,** en sus cuatro
modos: los cinco pasan. El 5 a 375 px tiene los mismos recortes que la línea base.
