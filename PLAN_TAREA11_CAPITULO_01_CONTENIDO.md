# Plan · Tarea 11 — Mejora de contenido del capítulo 1

**Fecha:** 2026-11-10. **Estado:** aprobado por el docente el 2026-11-10 con las siete
recomendaciones (A–G) y **ejecutado** ese mismo día, fase por fase, con su visto bueno en
cada punto de control. Falta lo que es del docente: leer el capítulo completo, verlo en
Safari y en un teléfono, y decidir la fusión en `main`. El registro de cada fase está en
la bitácora del plan maestro (§11).

| Fase | Rama | Commit |
|---|---|---|
| 1 · Leer lo que falta | — (vault) | — |
| 2 · Sección 3, Operadores | `claude/cap01-fase2-operadores` | `09813b9` |
| 3 · Sección 4 | `claude/cap01-fase3-seccion4` | `b84d8ca` |
| 4 · Sección 1 | `claude/cap01-fase4-seccion1` | `487b27d` |
| 5 · Sección 2 | `claude/cap01-fase5-seccion2` | `12d9022` |
| 6 · Portada, cierre y evaluación | `claude/cap01-fase6-portada-cierre` | `d7dc02b` |
| 7 · Figuras · LP-CORE | `claude/cap01-fase7-figuras` · `claude/cap01-fase7-lpcore` | `51ca835` · `f0939eb` |
| 8 · Coherencia hacia adelante | `claude/cap01-fase8-coherencia` | `0ec6c41` |
| 9 · Cierre | `claude/cap01-fase9-cierre` | el de este cambio |

Cada rama parte de la anterior: la última las contiene a todas.

**Lo que el plan decía y no se hizo así.** La arquitectura Harvard y `MOV AL, 61h`
salieron en vez de citarse (sus fuentes eran PDF de fabricante que no se descargaron). El
reparto 1-11-52 sigue fuera del texto (decisión D: no hubo PDF de IEEE 754 ni de
Goldberg). El convenio de índices del pseudocódigo quedó para el capítulo 7.

**Archivo:** `Material html/01_LPF_Introduccion.html` (4 777 líneas en `main`, commit
`6e5e8eb`). Todos los números de línea de este plan son de ese commit.

---

## 0. Qué se decidió antes de planificar

Esta tarea no adapta el formato del capítulo —eso fue la Tarea 7—, sino su **contenido**:
de dónde sale lo que afirma, si lo que afirma es cierto, si cuenta una sola historia y si
cumple lo que los capítulos 2 a 5 dan por hecho.

Decisiones ya tomadas por el docente, que este plan no reabre:

| Decisión | Dónde está |
|---|---|
| Una referencia solo existe si está en Zotero; la lista «Referencias» se genera | `CLAUDE.md`, `Material html/_fuentes/POLITICA_DE_FUENTES.md` |
| APA 7 autor-año en el texto | decisión D02 del vault |
| Solo se cita una fuente leída; el pasaje queda en la nota de la afirmación | política, §3 |
| Toda afirmación es citada, ejecutada, derivada, ilustrativa o criterio del docente | política, §1 |
| Cuatro lenguajes en paralelo, con el pseudocódigo como único normativo | plan maestro, D0 |
| Ejercicios de interpretación, taxonomía E1–E8 | plan maestro |

Restricciones que salen de medir:

- **La numeración de las cuatro secciones no cambia.** El capítulo 5 las cita una por una
  (`05…:3858-3863`) y el 4 remite a «Capítulo 1, sección 3».
- **Los cambios del `head` y del bloque LP-CORE del capítulo 1 se propagan** a los otros
  cuatro (reglas 1 y 20). Este plan no los toca salvo en la fase de figuras, y lo dice.
- El contenido que cambie puede dejar desfasadas las 7 preguntas del banco Moodle del
  capítulo (`Banco Moodle/rmd/cap01`), que viven en un repositorio privado aparte.

## 1. Estado medido

La línea base está en el vault privado del curso (`Vault/`), una nota por cosa.

| Qué | Cuánto | Cómo está |
|---|---|---|
| Afirmaciones que dependen de algo externo | 39 | 6 verificadas (las del piloto), 6 con fuente candidata, 10 sin fuente, 15 por reescribir, 2 resueltas |
| — por sección | | sección 1: 7 · sección 2: 10 · sección 3: 10 · sección 4: 11 · portada: 1 |
| — por clase | | 16 sin clasificar · 7 criterio · 6 citada · 6 ilustrativa · 2 derivada · 2 ejecutada |
| Figuras | 6 | 4 con defectos, 2 sin revisar en el navegador; ninguna declara su fuente |
| Conceptos | 14 | 12 con discrepancia entre capítulos, 2 sin definir |
| Hilos narrativos | 7 | 4 colgantes, 3 abiertos |
| Ejercicios con tipo E1–E8 | 13 | cumple la cuota |
| Ejercicios heredados sin tipo | 12 | 6 de opción múltiple, 3 retos, 3 minicuestionarios |
| Cuestionario final | 8 preguntas | la cuota es 10 |
| Distractores con retroalimentación | 0 | LP-CORE la admite |
| Bibliografía | no hay | 9 «Recursos complementarios» sueltos |

Fuentes disponibles hoy: 29 referencias en Zotero. **Leídas, 5** (todas documentación
oficial abierta). De los 13 libros del syllabus y de los tres documentos con DOI no se
ha leído ninguno: faltan los PDF.

## 2. Hallazgos

### H1 · La sección que los demás capítulos usan es la que peor cumple
El capítulo 3 dice que el 1 «estableció la tabla de precedencia» y el 4 que enseña los
operadores «en los cuatro lenguajes». La sección 3 no hace ninguna de las dos cosas: su
tabla de precedencia es la de Python, y las tablas de relacionales y lógicos solo traen
sintaxis de Python. Además contradice a su propio pseudocódigo (`=` frente a `==`) y
presenta como Python dos fragmentos que no lo son (`2_SMMLV`, `cuenta <> 0`).

### H2 · Las frases dicen más que sus fuentes
En el piloto de la sección 4, dos verificadores independientes juzgaron diez parejas
afirmación–pasaje: **una** quedó respaldada tal como estaba escrita. Las otras nueve
añadían una cifra, un «nunca», una consecuencia o un detalle que el pasaje no trae
(«Decimal… más lenta», cuando la documentación de Python dice «fast»; el reparto
1-11-52 de un `double`, que ninguna fuente leída da). Citar el capítulo es, sobre todo,
**reescribirlo para que diga lo que se puede sostener**.

### H3 · Cuatro casos, ninguno cerrado
Cada sección abre con un caso propio. El código `0x0A` nunca se descifra y está mal
planteado; el reporte de cuarenta minutos y los once créditos se retoman sin nombrarlos;
el descuadre de $8 432 —el único que recorre el capítulo— atribuye a la representación
binaria lo que su propio ejercicio final atribuye a una política de redondeo. Ningún
caso inventado se declara ilustrativo.

### H4 · El capítulo no sabe qué sigue
El recuadro final anuncia «estructuras de control y funciones en la siguiente unidad».
El capítulo 2 es Algoritmos. Es el único capítulo sin «Lo que viene», y el 2 remite a
una medición del 1 que no existe (`02…:2516`).

### H5 · La sección 2 no tiene con qué respaldarse
Diez afirmaciones de arquitectura e historia y ninguna fuente leída. El syllabus no trae
un texto de arquitectura, y la explicación del ejercicio E4 (el bus de memoria) puede
ser incorrecta, no solo estar sin fuente.

### H6 · El capítulo 1 no se parece a los otros cuatro
Tutea en una docena de lugares; llama «Capítulo 1…4» a sus secciones y «Unidad 1» al
conjunto; su tabla de identificación, su glosario y su cierre tienen otro formato.

### H7 · Las figuras
Colores fuera de la paleta en tres de seis, una caché dibujada en la memoria principal,
un bus de un solo sentido, una leyenda con colores distintos de los bits que describe y
una gráfica cuyo sombreado no corresponde a lo que dice su pie.

## 3. Decisiones que necesito del docente antes de empezar

| # | Decisión | Opciones | Recomendación |
|---|---|---|---|
| A | **Hilo del capítulo** | (1) Un solo caso —el descuadre— recorre las cuatro secciones. (2) Cuatro casos, cada uno cerrado en su sección. | (2). Cerrar cuatro casos es menos reescritura y cada sección conserva su gancho; el descuadre queda como caso de la sección 4 y de la portada, corregido. |
| B | **Alcance** | (1) Corregir sobre la estructura actual. (2) Rediseñar el capítulo. | (1). La estructura está citada por otros capítulos y los ejercicios cumplen la cuota. |
| C | **Arquitectura (sección 2)** | (1) Usted aporta el PDF de un texto de arquitectura. (2) Busco y verifico uno de acceso abierto. (3) La sección se reduce a lo que se pueda respaldar. | (2), y (3) para lo que no aparezca. |
| D | **El reparto 1-11-52 del `double`** | (1) Conseguir el estándar IEEE 754 o el artículo de Goldberg y citarlo. (2) Dejar «53 bits de precisión». | (1) si hay PDF; mientras tanto (2), que es lo que hace el piloto. |
| E | **Datos del sector** (SWIFT, centrales de riesgo, «la solución de la banca») | (1) Respaldar con la fuente oficial y fecharla. (2) Convertir en ejemplo ilustrativo declarado. | (1) donde la entidad publique el dato; (2) para lo demás. |
| F | **«Recursos complementarios»** | (1) Pasan a una lista «Para profundizar» generada desde Zotero, con los recursos del syllabus. (2) Se quitan. | (1). |
| G | **Publicación** | (1) Al cerrar el capítulo. (2) Sección por sección. | (1): una sola fusión, con su visto bueno. |

## 4. Fases

Cada fase termina en un punto de control con lo medido. Una fase no empieza sin el
visto bueno de la anterior.

### Fase 1 — Leer lo que falta
Antes de escribir una línea: dejar en nivel «leída» las fuentes que el capítulo necesita.

- Documentación oficial ya registrada y aún sin leer: prioridad de operadores de VBA
  (tabla completa), operadores lógicos de R, operador `And` de VBA, operaciones
  booleanas de Python, `bin`/`hex`/`oct`, `Double` de VBA.
- Lo que depende de las decisiones C, D y E: texto de arquitectura, informe de Von
  Neumann, estándar o Goldberg, SWIFT, centrales de riesgo.
- Cada pasaje, con su localizador, a la nota de su afirmación.

**Hecho cuando:** ninguna afirmación del capítulo está en `sin-fuente` sin una decisión
escrita (citar, declarar ilustrativa, redactar como criterio o quitar).

### Fase 2 — Sección 3, Operadores
La primera, porque es la que usan los capítulos 3, 4 y 5.

- Tablas de aritméticos, relacionales y lógicos **en los cuatro lenguajes**, con el
  pseudocódigo como norma.
- **Una tabla canónica de precedencia** en pseudocódigo y una fila de diferencias por
  lenguaje (asociatividad de la potencia, `%%` en R, `\` y `Mod` en VBA), cada una con
  su cita.
- Evaluación de cortocircuito: qué hace cada lenguaje y qué hace el pseudocódigo.
- Resolver `=` frente a `==`; corregir `2_SMMLV` y `cuenta <> 0`.
- Declarar ilustrativos los pesos del scoring y las reglas de negocio; corregir los
  rótulos de IVA y retención de la tabla de operadores.
- Cerrar el caso de los once créditos con su propio ejercicio.

**Hecho cuando:** lo que los capítulos 3 y 4 dicen del capítulo 1 es cierto, y la
verificación independiente no devuelve ningún «parcial».

### Fase 3 — Sección 4, Reales y error de redondeo
Lo que el piloto dejó fuera: la afirmación sobre «la solución de la banca», el pasaje
«el problema no es el tamaño del error» (que choca con el caso del descuadre), el
laboratorio de bits y su leyenda, y el minicuestionario que la sección no tiene.

### Fase 4 — Sección 1, Sistemas de numeración
- Resolver o reemplazar el caso `0x0A`.
- Desligar de SWIFT el ejemplo de máscaras de bits y declararlo ilustrativo; la cifra
  institucional, con fuente y fecha o fuera.
- Respaldar o matizar «base 10 por los diez dedos» y los niveles de voltaje.

### Fase 5 — Sección 2, Estructura del computador
- Rehacer la sección sobre el texto de arquitectura que salga de la decisión C.
- Corregir la jerarquía de memoria (la caché) en el texto y en el diagrama a la vez.
- Rehacer la explicación del ejercicio E4, si hace falta con una medición propia
  ejecutada, y cerrar con él el caso del reporte de cuarenta minutos.

### Fase 6 — Portada, cierre y evaluación
- Portada: el descuadre, dicho de modo que coincida con su ejercicio final; tabla de
  identificación como la de los capítulos 2 a 5.
- Cierre: «Lo que viene», que nombre el capítulo 2; glosario con el formato del curso.
- Todo el capítulo a «usted»; «sección» para lo interno.
- Cuestionario final a 10 preguntas; retroalimentación en los distractores; tipo E1–E8
  a los ejercicios heredados o retirarlos.
- «Referencias» y, según la decisión F, «Para profundizar».

### Fase 7 — Figuras
Las seis, con su `Fuente` (citada, propia o ilustrativa), en la paleta institucional y
dentro de `<figure>`. La gráfica de interés: sombrear la brecha y no el área, y
separadores de miles en español. **Si toca LP-CORE (el relleno ámbar viene de ahí), se
reestampan los cinco capítulos.**

### Fase 8 — Coherencia hacia adelante
Lo mínimo en los capítulos 2 a 4 para que digan del capítulo 1 lo que ahora es cierto:
`02…:2516`, `03…:3137-3141`, `03…:3165-3166`, `04…:3394-3398`. Y la lista de preguntas
del banco Moodle del capítulo 1 que el cambio deja desfasadas, para que usted decida.

### Fase 9 — Cierre
`verificar.py --con-salidas` y la sonda en sus modos; verificación independiente de
**todas** las citas del capítulo; su lectura completa; Safari y teléfono.

## 5. Criterios de aceptación del capítulo

1. Ninguna afirmación en `sin-fuente` ni `sin-clasificar`: las 39 (y las que aparezcan)
   quedan citadas, ejecutadas, derivadas, ilustrativas o como criterio.
2. Toda cita tiene su fila en `Material html/_fuentes/afirmaciones/01.yaml` y pasa las
   reglas 26 a 29 y 31.
3. La verificación independiente no deja ningún «parcial» ni «no respalda».
4. Las seis figuras pasan la regla 30; el capítulo no deja avisos de la regla 32 sin
   indulto justificado.
5. Los 14 conceptos quedan en `coherente`, y los 7 hilos en `cerrado`.
6. Cuota de ejercicios: se mantiene; cuestionario de 10; distractores con
   retroalimentación.
7. Los capítulos 2 a 5 no dicen del capítulo 1 nada que no sea cierto.
8. `verificar.py` en verde en los cinco capítulos.

## 6. Riesgos

| Riesgo | Qué se hace |
|---|---|
| No aparece un texto de arquitectura legible | La sección 2 se reduce a lo respaldable (decisión C, opción 3). |
| La reescritura rompe ejercicios que hoy cumplen la cuota | La regla 2 se corre al final de cada fase, no solo al cierre. |
| El banco Moodle queda desfasado | Fase 8: lista de preguntas afectadas antes de fusionar. |
| Una fuente web cambia después de leída | La nota guarda el pasaje y la fecha; la referencia lleva fecha de consulta. |
| Un cambio en LP-CORE obliga a reestampar | Solo en la fase 7, anunciado, y con `verificar.py` en los cinco. |
| Varias sesiones en el repo | Una rama por fase, `git add` con rutas explícitas. |

## 7. Qué queda fuera

- Los capítulos 2 a 5, salvo las frases de la fase 8. Cada uno tendrá su línea base.
- La actualización del syllabus: es un borrador aparte, en el vault.
- El banco Moodle: solo se lista lo afectado.
- Publicar: lo decide el docente al cierre.
