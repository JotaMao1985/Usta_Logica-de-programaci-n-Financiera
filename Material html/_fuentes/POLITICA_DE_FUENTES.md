# Política de fuentes del material

Vigente desde el 2026-11-10. Aplica a los ocho capítulos y a todo lo que se publique con
ellos. Su propósito es uno: que **cada afirmación del material pueda rastrearse** hasta
una fuente leída, una ejecución, una cuenta a la vista o una declaración expresa de que
el dato es inventado.

## 1. Las seis clases de afirmación

Toda afirmación fáctica del material pertenece a una de estas clases. La clase se
registra; no se supone.

| Clase | Qué es | Cómo se ve en el HTML |
|---|---|---|
| **Citada** | Depende de una fuente externa: una fecha, una definición atribuida, una cifra del sector, una norma, el comportamiento documentado de un lenguaje. | `<Cita k="clave" loc="p. 12"/>` junto a la afirmación. |
| **Ejecutada** | Es la salida de un programa. | La salida está en su bloque y pasó la regla 9 de `verificar.py`. |
| **Derivada** | Sale de una cuenta que el propio texto muestra. | La aritmética está a la vista y cuadra. |
| **Ilustrativa** | Caso, cifra o regla de negocio inventados para enseñar. | `<Ilustrativo>` o `<Fuente ilustrativo/>`; el texto no los presenta como reales. |
| **Criterio del docente** | Recomendación u opinión profesional. | Redactada como tal («conviene», «en este curso»), no como hecho. |
| **Remisión** | Dice qué trata otro capítulo del material o qué pide el syllabus de la asignatura. | Nombra el destino («el capítulo 1», «el syllabus»); no lleva `<Cita>`, porque el destino es un documento del propio curso. |

Una **remisión** no se respalda con una fuente: se **coteja con su destino**. Quien la
escribe abre el capítulo o el syllabus, comprueba que diga lo que la frase le atribuye y
deja en la nota de la afirmación la fecha y el lugar del cotejo. La clase cubre solo lo
que el destino dice; un juicio añadido («que es más exigente») es criterio del docente y
se redacta como tal. Cuando un capítulo cambia, se vuelven a cotejar las remisiones que
apuntan a él: es el trabajo de la fase de coherencia de cada capítulo. La clase se añadió
el 2026-11-15, por decisión del docente.

Lo que no cabe en ninguna clase **se reescribe o se quita**. Una frase como «la mayoría
de los bancos…» o «el error más común…» es una afirmación sobre el mundo: o se respalda,
o se convierte en criterio del docente, o se va.

## 2. Qué cuenta como fuente

En este orden de preferencia:

1. **Estándares, normas y datos oficiales.** El estándar o la norma misma, y la entidad
   que produce el dato: la que expide la norma, certifica la tasa o publica la serie.
2. **Documentación oficial de los lenguajes** (Python, R, VBA), con versión y fecha de
   consulta.
3. **Libros de texto y artículos.** Primero los de acceso abierto y los del syllabus de
   los que haya ejemplar o PDF.
4. **La institución dueña del dato**, cuando la afirmación es sobre ella.

**No respaldan una afirmación**: Wikipedia, blogs, foros, sitios de tutoriales, videos,
salidas de un modelo de IA ni lo que un modelo «recuerda». Pueden ayudar a encontrar la
fuente y pueden recomendarse para practicar, en una lista aparte («Para practicar») y sin
atribuirles nada.

## 3. Cuándo se puede citar

Una fuente pasa por tres niveles:

| Nivel | Condición |
|---|---|
| `metadatos` | Su identificador (DOI, ISBN o URL oficial) resuelve y los datos bibliográficos se copiaron de ahí. |
| `leida` | Alguien leyó el pasaje pertinente y lo dejó copiado, con página o sección, en el registro privado. |
| `confirmada` | El docente cotejó el pasaje. |

**Solo se cita una fuente en nivel `leida` o superior.** Una fuente a la que no se tuvo
acceso puede figurar como lectura recomendada, en la lista «Para profundizar» del
capítulo, pero no se le atribuye ninguna afirmación concreta.

Cada cita lleva **localizador**: página, sección o artículo. «Según Joyanes» sin página
no es una cita verificable.

**Dónde va la cita.** La cita respalda lo que está **antes de ella dentro de su oración**,
y nada más. Lo que el material añade por su cuenta —una recomendación, una regla, lo que
muestra una salida ejecutada— va después de la cita o en otra oración. Así no se le
atribuye a una fuente lo que no dice: «Dos números de punto flotante que deberían ser
iguales pueden no serlo (cita). Por eso, nunca compare dinero con igualdad exacta», y no
al revés.

**Varias fuentes para una frase.** Cuando una frase habla de varias fuentes a la vez —«los
tres lenguajes…»—, lleva una cita por fuente, seguidas, y cada una respalda su parte.

**La fuente manda sobre la frase.** Si el pasaje dice menos que la afirmación, se cambia
la afirmación, no se estira el pasaje. Una cifra, un «siempre», un «más lento» o una
consecuencia práctica que el pasaje no trae necesitan otra fuente, una ejecución o
redactarse como criterio del docente.

## 4. De dónde sale la lista de referencias

- La biblioteca del curso está en Zotero. Una referencia solo existe si está allí.
- `Material html/_fuentes/referencias.json` es la exportación de esa biblioteca.
- La lista «Referencias» de cada capítulo la genera `estampar_referencias.py` en
  APA 7, solo con las obras citadas en ese capítulo. **Nunca se escribe a mano.**
- «Para profundizar» lista las obras que el capítulo recomienda y no cita. Se declara
  con `<ParaProfundizar k="clave; otra" />` y la genera el mismo guion, también en
  APA 7. Una obra no puede estar en las dos listas, y también necesita identificador.
- Una URL lleva fecha de consulta. Una norma lleva número, año y entidad que la expide.
- Un dato de una página sin fecha se presenta con su fecha de consulta: «según su
  página, consultada el…», no «a tal fecha».

## 5. Datos, cifras y figuras

- Toda figura lleva pie con su procedencia: una fuente citada, «elaboración propia» o
  «elaboración propia con datos ilustrativos».
- Una cifra del mundo real lleva fuente **y fecha**: las tasas, los topes y las tarifas
  cambian. Si la cifra va a envejecer, el texto dice a qué fecha corresponde y dónde se
  consulta el valor vigente.
- Una cifra inventada para un ejercicio debe ser verosímil y declararse ilustrativa
  cuando pueda confundirse con un dato real (una tarifa, una tasa, un tope legal).

## 6. Lo que revisa la máquina y lo que no

`verificar.py` comprueba que toda clave citada exista, que la lista corresponda
exactamente a lo citado, que el bloque estampado esté al día, que cada referencia tenga
identificador y que cada cita tenga su fila en el registro de afirmaciones.

No puede comprobar que el pasaje diga lo que el material le atribuye. Eso lo hace una
lectura independiente: quien verifica recibe la afirmación y el pasaje, no el borrador
ni el razonamiento de quien escribió. Una frase que el verificador marca «parcial» se
corrige y se vuelve a leer; antes de cerrar un capítulo se leen todas sus citas de una
vez, sobre el texto final.

## 7. Registro

- **Privado** (vault): una nota por afirmación, con el texto del material, el extracto
  de la fuente, el juicio y la acción.
- **Público** (`Material html/_fuentes/afirmaciones/NN.yaml`): una fila por cita, con el
  identificador, el ancla literal en el HTML, la clave, el localizador, quién y cuándo
  la leyó y la huella del extracto. No lleva el texto del extracto.
