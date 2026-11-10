#!/usr/bin/env python3
"""
Lo que comparten `exportar_zotero.py`, `estampar_referencias.py` y las reglas
26 a 29 de `verificar.py` sobre las fuentes del material.

Aquí no se llama a pandoc ni a Zotero ni se escribe ningún archivo: son
funciones puras sobre texto y diccionarios, para que el verificador pueda
recalcular la huella y el sello de un capítulo en una máquina sin pandoc.

El circuito completo:

    Zotero ──exportar_zotero.py──▶ _fuentes/referencias.json   (CSL-JSON)
    capítulo  <Cita k="clave"/>  ──estampar_referencias.py──▶  isla LP-REFS
    isla LP-REFS  ──Cita, Referencias, Fuente (LP-CORE)──▶  lo que ve el lector

La isla es un `<script type="application/json" id="lp-referencias">` entre los
centinelas `<!-- === LP-REFS INICIO … -->` y `<!-- === LP-REFS FIN === -->`, FUERA
del script Babel: entre su `</script>` y `</body>`. Dentro, las reglas de texto
de `verificar.py` (11, 17, 18, 21…) leerían cada entrada de la bibliografía como
si fuera prosa del capítulo. Y con `<` escrito `\\u003c`, para que ni un título
que diga `</script>` cierre la isla ni la regla 3 tome un `<em>` por componente.

Sus campos:

    v         versión del formato (hoy 1)
    huella    sha256 de lo que entró: las entradas citadas tal como están en
              referencias.json, el sha256 de apa-es.csl y el idioma. Cambia si
              cambia una fuente citada, el estilo o el conjunto de claves.
    sello     sha256 de lo que salió: v, huella, orden y entradas. Cambia si
              alguien edita la isla a mano.
    orden     las claves en el orden de la lista de referencias (el de la APA)
    entradas  {clave: {autor, anio, html, plano}}

`huella` responde «¿hay que volver a estampar?» y `sello` responde «¿alguien
tocó lo estampado?». Ninguna de las dos necesita pandoc.
"""

import hashlib
import json
import re
from pathlib import Path

AQUI = Path(__file__).resolve().parent
MATERIAL = AQUI.parent
DIR_FUENTES = MATERIAL / "_fuentes"
DIR_PRUEBAS = AQUI / "pruebas_fuentes"

ARCHIVO_REFERENCIAS = "referencias.json"
ARCHIVO_CSL = "apa-es.csl"
IDIOMA = "es-CO"
VERSION = 1

# La clave de cita: la que el docente pone en el campo nativo «Clave de cita» de
# Zotero. Sin mayúsculas, espacios ni signos: va en un `id="ref-…"` del HTML y
# en un atributo `k="a; b"`, donde `;` separa claves.
CLAVE = re.compile(r"^[a-z][a-z0-9_-]*$")

MARCA_FIN_CORE = "/* === LP-CORE FIN === */"
MARCA_REFS_INICIO = "<!-- === LP-REFS INICIO"
MARCA_REFS_FIN = "<!-- === LP-REFS FIN === -->"
LINEA_REFS_INICIO = ("    <!-- === LP-REFS INICIO — no editar a mano: se genera con "
                     "estampar_referencias.py === -->")
LINEA_REFS_FIN = "    " + MARCA_REFS_FIN
ID_ISLA = "lp-referencias"
APERTURA_ISLA = f'    <script type="application/json" id="{ID_ISLA}">'
CIERRE_ISLA = "    </script>"

# Lista BLANCA de campos CSL que se publican. Lo que no está aquí no sale del
# computador del docente: `abstract` y `note` son sus apuntes de lectura,
# `file` es una ruta de su disco, `archive*` y `call-number` son de su
# biblioteca. El repositorio es público.
CAMPOS_PERMITIDOS = (
    "id", "type",
    "author", "editor", "translator", "collection-editor", "container-author",
    "title", "title-short", "container-title", "collection-title",
    "collection-number", "publisher", "publisher-place",
    "issued", "accessed", "original-date",
    "edition", "volume", "issue", "page", "number", "number-of-volumes",
    "genre", "medium", "authority", "section", "event-title", "event-place",
    "DOI", "ISBN", "ISSN", "URL", "language",
)
CAMPOS_PRIVADOS = ("abstract", "note", "annote", "file", "keyword",
                   "archive", "archive_location", "archive-place", "call-number",
                   "source", "citation-key")

ETIQUETAS_PERMITIDAS = ("em", "i", "sup", "sub", "a")


class ErrorFuentes(Exception):
    """Algo de las fuentes no se pudo leer o no tiene la forma esperada."""


# ------------------------------------------------------------ referencias.json

def canonico(obj):
    """El JSON de `obj` escrito de una sola manera: es lo que se resume."""
    return json.dumps(obj, ensure_ascii=False, sort_keys=True, separators=(",", ":"))


def sha256(texto):
    return hashlib.sha256(texto.encode("utf-8")).hexdigest()


def ruta_referencias(directorio=None):
    return Path(directorio or DIR_FUENTES) / ARCHIVO_REFERENCIAS


def ruta_csl(directorio=None):
    """El estilo de `directorio`, o el de `_fuentes/` si allí no hay uno.

    El accesorio de pruebas no lleva su propia copia de `apa-es.csl`: serían
    86 KB duplicados que alguien tendría que acordarse de actualizar.
    """
    propio = Path(directorio or DIR_FUENTES) / ARCHIVO_CSL
    return propio if propio.exists() else DIR_FUENTES / ARCHIVO_CSL


def sha_csl(directorio=None):
    ruta = ruta_csl(directorio)
    if not ruta.exists():
        raise ErrorFuentes(f"no se encuentra {ruta}")
    return hashlib.sha256(ruta.read_bytes()).hexdigest()


def leer_referencias(directorio=None):
    """La lista de entradas CSL de `referencias.json`, sin interpretar nada."""
    ruta = ruta_referencias(directorio)
    if not ruta.exists():
        raise ErrorFuentes(f"no se encuentra {ruta}")
    try:
        datos = json.loads(ruta.read_text(encoding="utf-8"))
    except json.JSONDecodeError as e:
        raise ErrorFuentes(f"{ruta.name} no es JSON válido: {e}")
    if not isinstance(datos, list) or not all(isinstance(e, dict) for e in datos):
        raise ErrorFuentes(f"{ruta.name} debe ser una lista de entradas CSL")
    return datos


def por_clave(entradas):
    """{id: entrada}. Si un id se repite gana el último; lo denuncia la regla 29."""
    return {e.get("id"): e for e in entradas if isinstance(e.get("id"), str)}


def filtrar_entrada(csl):
    """La entrada con solo los campos de la lista blanca, y sin los vacíos."""
    return {k: csl[k] for k in CAMPOS_PERMITIDOS if csl.get(k) not in (None, "", [], {})}


def serializar_referencias(entradas):
    """El texto de `referencias.json`: ordenado por id, un campo por línea.

    Ordenado y con sangría para que el `git diff` de una exportación muestre
    qué fuente cambió, y no un archivo entero reescrito.
    """
    orden = sorted(entradas, key=lambda e: e["id"])
    return json.dumps(orden, ensure_ascii=False, indent=2) + "\n"


def _con_texto(valor):
    return isinstance(valor, str) and valor.strip() != ""


def _tiene_autor(csl):
    autores = csl.get("author")
    if not isinstance(autores, list) or not autores:
        return False
    return all(isinstance(a, dict) and (_con_texto(a.get("family")) or _con_texto(a.get("literal")))
               for a in autores)


def _con_fecha(valor):
    if not isinstance(valor, dict):
        return False
    partes = valor.get("date-parts")
    con_partes = (isinstance(partes, list) and bool(partes) and isinstance(partes[0], list)
                  and bool(partes[0]) and str(partes[0][0]).strip() != "")
    return con_partes or _con_texto(valor.get("raw")) or _con_texto(valor.get("literal"))


def problemas_de_entrada(csl):
    """Lo que le falta a una entrada para poder verificarse (regla 29).

    Verificable quiere decir que un lector puede llegar a la fuente: sabe quién
    la firma y cómo se llama, y tiene un DOI, un ISBN o una URL para buscarla.
    Si lo único que hay es una URL, hace falta además la fecha de consulta: una
    página cambia o desaparece, y sin fecha no se sabe qué versión se citó.
    """
    problemas = []
    clave = csl.get("id")
    if not isinstance(clave, str) or not CLAVE.match(clave):
        problemas.append(f"la clave «{clave}» no cumple {CLAVE.pattern}")
    if not _tiene_autor(csl):
        problemas.append("sin autor (`author` con `family` o `literal`)")
    if not _con_texto(csl.get("title")):
        problemas.append("sin título")
    doi, isbn, url = (_con_texto(csl.get(c)) for c in ("DOI", "ISBN", "URL"))
    if not (doi or isbn or url):
        problemas.append("sin DOI, ISBN ni URL: no hay cómo llegar a la fuente")
    elif url and not (doi or isbn) and not _con_fecha(csl.get("accessed")):
        problemas.append("solo tiene URL y le falta la fecha de consulta (`accessed`)")
    privados = sorted(c for c in csl if c not in CAMPOS_PERMITIDOS)
    if privados:
        problemas.append("campos fuera de la lista blanca: " + ", ".join(privados)
                         + " — el repositorio es público; vuelva a exportar con exportar_zotero.py")
    return problemas


def problemas_del_archivo(entradas):
    """[(clave, problema)] de todo `referencias.json`, más su orden y sus repetidos."""
    salida = []
    ids = [e.get("id") for e in entradas]
    vistos = set()
    for i in ids:
        if i in vistos:
            salida.append((str(i), "la clave está repetida"))
        vistos.add(i)
    if [str(i) for i in ids] != sorted(str(i) for i in ids):
        salida.append(("(archivo)", "las entradas no están ordenadas por id; "
                                    "vuelva a exportar con exportar_zotero.py"))
    for e in entradas:
        for p in problemas_de_entrada(e):
            salida.append((str(e.get("id")), p))
    return salida


# --------------------------------------------------------- claves que se citan

def _blanquear(m):
    return re.sub(r"[^\n]", " ", m.group(0))


def sin_comentarios(texto):
    """Los comentarios cambiados por espacios, sin mover ninguna posición.

    Los `//` precedidos de `:` se dejan: son los de `https://…`, y blanquear
    desde ahí se llevaría una cita escrita en el mismo renglón que una URL.
    """
    texto = re.sub(r"/\*[\s\S]*?\*/", _blanquear, texto)
    return re.sub(r"(?<!:)//[^\n]*", _blanquear, texto)


def zona_de_contenido(texto):
    """(fragmento, desplazamiento) de lo que escribe el autor del capítulo.

    Va de `LP-CORE FIN` al `</script>` que cierra el script Babel. La librería
    queda fuera —`Fuente` usa `<Cita k={k}/>` por dentro, y eso no es una cita—,
    y la isla también: está después de ese `</script>`. Un archivo sin
    centinela (`lp-demo.jsx`) es contenido entero.
    """
    i = texto.find(MARCA_FIN_CORE)
    if i == -1:
        return texto, 0
    j = texto.find("</script>", i)
    return texto[i:j if j != -1 else len(texto)], i


def _fin_de_cadena(texto, i):
    """Posición de la comilla que cierra la cadena abierta en `texto[i]`."""
    q = texto[i]
    j = i + 1
    while j < len(texto):
        if texto[j] == "\\":
            j += 2
            continue
        if texto[j] == q:
            return j
        j += 1
    return len(texto) - 1


def _fin_de_llaves(texto, i):
    """Posición de la `}` que cierra la `{` de `texto[i]`, saltando cadenas."""
    prof = 0
    j = i
    while j < len(texto):
        c = texto[j]
        if c in "\"'`":
            j = _fin_de_cadena(texto, j)
        elif c == "{":
            prof += 1
        elif c == "}":
            prof -= 1
            if prof == 0:
                return j
        j += 1
    return len(texto) - 1


def atributos(texto, i):
    """{nombre: (tipo, valor)} de la etiqueta JSX que abre en `texto[i]`.

    `tipo` es 'cadena' (`k="a"`), 'expresion' (`k={…}`, sin las llaves) o
    'bandera' (`propia`). Se recorre atributo por atributo, y no con una
    expresión regular sobre toda la etiqueta, para que un `k=` escrito DENTRO
    del valor de otro atributo no pase por la clave.
    """
    attrs = {}
    m = re.compile(r"<[A-Za-z_][\w.]*").match(texto, i)
    j = m.end() if m else i + 1
    n = len(texto)
    while j < n:
        while j < n and texto[j].isspace():
            j += 1
        if j >= n or texto[j] == ">" or texto.startswith("/>", j):
            break
        if texto[j] == "{":                       # {...resto}
            j = _fin_de_llaves(texto, j) + 1
            continue
        nombre = re.compile(r"[A-Za-z_][\w-]*").match(texto, j)
        if not nombre:
            j += 1
            continue
        j = nombre.end()
        k = j
        while k < n and texto[k].isspace():
            k += 1
        if k >= n or texto[k] != "=":
            attrs[nombre.group(0)] = ("bandera", None)
            continue
        k += 1
        while k < n and texto[k].isspace():
            k += 1
        if k < n and texto[k] in "\"'":
            fin = _fin_de_cadena(texto, k)
            attrs[nombre.group(0)] = ("cadena", texto[k + 1:fin])
            j = fin + 1
        elif k < n and texto[k] == "{":
            fin = _fin_de_llaves(texto, k)
            attrs[nombre.group(0)] = ("expresion", texto[k + 1:fin])
            j = fin + 1
        else:
            j = k
    return attrs


LITERAL = re.compile(r"""\s*(['"])((?:(?!\1)[^\\\n])*)\1\s*\Z""")


def literal_de(valor):
    """El texto de un atributo si es una cadena escrita ahí mismo; si no, None.

    Valen `k="a"`, `k='a'` y `k={'a'}`. No valen `k={clave}` ni una plantilla:
    lo que se cita tiene que poder leerse en el archivo sin ejecutar nada.
    """
    if valor is None:
        return None
    tipo, texto = valor
    if tipo == "cadena":
        return texto
    if tipo == "expresion":
        m = LITERAL.match(texto)
        return m.group(2) if m else None
    return None


def _claves_de(texto_k):
    return [c.strip() for c in texto_k.split(";")]


def citas_de(texto):
    """(citas, problemas) de un capítulo, por orden de aparición.

    `citas` es una lista de (posición, componente, [claves]) y `problemas` una
    de (posición, mensaje); la posición es la del archivo completo. Se cita de
    tres maneras, y las tres cuentan:

        <Cita k="a; b" loc="p. 12" />
        <Fuente k="a" />
        <ChartFrame fuente="a" />   o   fuente={{ k: 'a', loc: 'cuadro 2' }}

    Lo que no es literal es un problema y no una cita: una clave que sale de
    una variable no la puede comprobar la regla 26 ni la puede estampar
    `estampar_referencias.py`.
    """
    zona, base = zona_de_contenido(texto)
    limpio = sin_comentarios(zona)
    citas, problemas = [], []

    def anotar(pos, componente, texto_k):
        claves = _claves_de(texto_k)
        malas = [c for c in claves if not CLAVE.match(c)]
        if malas:
            problemas.append((pos, f"<{componente}> cita «{'», «'.join(malas)}», que no es una "
                                   f"clave válida ({CLAVE.pattern}); varias claves se separan con «;»"))
        buenas = [c for c in claves if CLAVE.match(c)]
        if buenas:
            citas.append((pos, componente, buenas))

    for m in re.finditer(r"<(Cita|Fuente|ChartFrame)(?=[\s/>])", limpio):
        componente, pos = m.group(1), base + m.start()
        attrs = atributos(limpio, m.start())
        if componente in ("Cita", "Fuente"):
            if "k" not in attrs:
                if componente == "Cita":
                    problemas.append((pos, "<Cita> sin la propiedad `k`"))
                continue
            texto_k = literal_de(attrs["k"])
            if texto_k is None:
                problemas.append((pos, f"<{componente}> no escribe su clave como cadena literal "
                                       f"(`k=\"clave\"`); una clave que sale de una variable no se "
                                       f"puede comprobar ni estampar"))
                continue
            anotar(pos, componente, texto_k)
            if componente == "Cita" and "loc" in attrs and len(_claves_de(texto_k)) > 1:
                problemas.append((pos, "<Cita> con varias claves y un `loc`: no se sabe a cuál de "
                                       "ellas pertenece; escriba una <Cita> por fuente"))
            continue
        # ChartFrame
        if "fuente" not in attrs:
            continue
        tipo, valor = attrs["fuente"]
        texto_k = literal_de(attrs["fuente"])
        if texto_k is not None:
            anotar(pos, "ChartFrame fuente", texto_k)
        elif tipo == "expresion" and valor.strip().startswith("{"):
            con_k = re.search(r"(?<![\w$])k\s*:\s*", valor)
            if not con_k:
                continue                          # { propia: true } o { ilustrativo: true }
            lit = re.compile(r"""(['"])((?:(?!\1)[^\\\n])*)\1""").match(valor, con_k.end())
            if lit:
                anotar(pos, "ChartFrame fuente", lit.group(2))
            else:
                problemas.append((pos, "<ChartFrame> no escribe la clave de su `fuente` como "
                                       "cadena literal (`fuente={{ k: 'clave' }}`)"))
        elif tipo == "expresion" and valor.strip().startswith("<"):
            continue                              # fuente={<Fuente …/>}: se lee al llegar a ella
        else:
            problemas.append((pos, "<ChartFrame> recibe su `fuente` de una variable; escriba "
                                   "`fuente=\"clave\"`, `fuente={{ k: 'clave', loc: '…' }}`, "
                                   "`fuente={{ propia: true }}` o `fuente={{ ilustrativo: true }}`"))
    return citas, problemas


def claves_citadas(texto):
    """Las claves citadas, sin repetir y en orden de primera aparición."""
    citas, _ = citas_de(texto)
    vistas = []
    for _pos, _comp, claves in citas:
        for c in claves:
            if c not in vistas:
                vistas.append(c)
    return vistas


# ------------------------------------------------------------ huella y sello

def huella(entradas_citadas, sha_del_csl, idioma=IDIOMA):
    """Resumen de todo lo que decide cómo se ve la lista de referencias.

    Entra el CONJUNTO de entradas y no cada una por separado: con dos obras del
    mismo autor y año, quitar una cambia la otra de «2024a» a «2024».
    """
    return sha256(canonico({
        "v": VERSION,
        "idioma": idioma,
        "csl": sha_del_csl,
        "entradas": sorted(entradas_citadas, key=lambda e: str(e.get("id"))),
    }))


def sello(bloque):
    """Resumen de lo estampado: todo el bloque menos el propio sello."""
    return sha256(canonico({k: bloque.get(k) for k in ("v", "huella", "orden", "entradas")}))


def componer_bloque(huella_, orden, entradas):
    bloque = {"v": VERSION, "huella": huella_, "sello": "", "orden": list(orden),
              "entradas": {k: entradas[k] for k in orden}}
    bloque["sello"] = sello(bloque)
    return bloque


# -------------------------------------------------------------------- la isla

def texto_de_isla(bloque):
    """Las líneas que van en el archivo, de centinela a centinela.

    `<` se escribe `\\u003c`: `JSON.parse` lo lee igual, y así ni un título con
    `</script>` cierra la isla ni un `<em>` parece un componente sin definir.
    """
    cuerpo = json.dumps(bloque, ensure_ascii=False, indent=2).replace("<", "\\u003c")
    return "\n".join([LINEA_REFS_INICIO, APERTURA_ISLA, cuerpo, CIERRE_ISLA, LINEA_REFS_FIN])


def tramo_isla(texto):
    """(inicio, fin) del tramo entre centinelas, líneas enteras; None si no hay.

    Lanza `ErrorFuentes` si los centinelas no son exactamente uno y uno, o
    están cruzados: con dos islas, el navegador lee la primera y el
    estampador reescribiría la que encontrara, que puede ser la otra.
    """
    n_ini, n_fin = texto.count(MARCA_REFS_INICIO), texto.count(MARCA_REFS_FIN)
    if n_ini == 0 and n_fin == 0:
        return None
    if n_ini != 1 or n_fin != 1:
        raise ErrorFuentes(f"hay {n_ini} centinelas LP-REFS INICIO y {n_fin} LP-REFS FIN; "
                           f"debe haber uno de cada uno")
    i, j = texto.find(MARCA_REFS_INICIO), texto.find(MARCA_REFS_FIN)
    if j < i:
        raise ErrorFuentes("el centinela LP-REFS FIN aparece antes que LP-REFS INICIO")
    ini = texto.rfind("\n", 0, i) + 1
    return ini, j + len(MARCA_REFS_FIN)


def leer_isla(texto):
    """El bloque de referencias del capítulo como diccionario; None si no hay."""
    tramo = tramo_isla(texto)
    if tramo is None:
        if f'id="{ID_ISLA}"' in sin_isla_ni_core(texto):
            raise ErrorFuentes(f'hay un elemento id="{ID_ISLA}" fuera de los centinelas LP-REFS')
        return None
    dentro = texto[tramo[0]:tramo[1]]
    m = re.search(r'<script type="application/json" id="' + ID_ISLA + r'">(.*?)</script>',
                  dentro, re.S)
    if not m:
        raise ErrorFuentes(f'entre los centinelas LP-REFS no hay un '
                           f'<script type="application/json" id="{ID_ISLA}">')
    if dentro.count("<script") != 1:
        raise ErrorFuentes("entre los centinelas LP-REFS hay más de un <script>")
    try:
        bloque = json.loads(m.group(1))
    except json.JSONDecodeError as e:
        raise ErrorFuentes(f"la isla de referencias no es JSON válido: {e}")
    if not isinstance(bloque, dict) or not isinstance(bloque.get("entradas"), dict) \
            or not isinstance(bloque.get("orden"), list):
        raise ErrorFuentes("la isla de referencias no trae `orden` y `entradas`")
    return bloque


def sin_isla_ni_core(texto):
    """El archivo sin la librería (que nombra el id de la isla) ni la isla."""
    i, j = texto.find("/* === LP-CORE INICIO"), texto.find(MARCA_FIN_CORE)
    if i != -1 and j != -1:
        texto = texto[:i] + texto[j:]
    try:
        tramo = tramo_isla(texto)
    except ErrorFuentes:
        tramo = None
    return texto if tramo is None else texto[:tramo[0]] + texto[tramo[1]:]


def poner_isla(texto, isla):
    """El archivo con `isla` (texto, o None para quitarla) en su sitio.

    Su sitio es justo antes del último `</body>`, después del `</script>` que
    cierra el script Babel. Si ya hay una, se reemplaza de centinela a
    centinela y se queda donde estaba.
    """
    tramo = tramo_isla(texto)
    if tramo is not None:
        ini, fin = tramo
        if isla is None:
            fin = fin + 1 if texto[fin:fin + 1] == "\n" else fin
            return texto[:ini] + texto[fin:]
        return texto[:ini] + isla + texto[fin:]
    if isla is None:
        return texto
    cuerpo = texto.rfind("</body>")
    if cuerpo == -1:
        raise ErrorFuentes("no se encontró </body>")
    ini = texto.rfind("\n", 0, cuerpo) + 1
    if texto.rfind("</script>", 0, cuerpo) == -1:
        raise ErrorFuentes("no se encontró el </script> del script Babel antes de </body>")
    return texto[:ini] + isla + "\n" + texto[ini:]


def isla_bien_puesta(texto):
    """None si la isla está entre el `</script>` de Babel y `</body>`; si no, por qué."""
    tramo = tramo_isla(texto)
    if tramo is None:
        return None
    babel = texto.find('<script type="text/babel">')
    cierre = texto.find("</script>", babel) if babel != -1 else -1
    cuerpo = texto.rfind("</body>")
    if babel == -1 or cierre == -1 or cuerpo == -1:
        return "no se encontró el script Babel o </body>: no se pudo situar la isla"
    if not (cierre < tramo[0] and tramo[1] <= cuerpo):
        return ("la isla de referencias no está entre el </script> del script Babel y </body>; "
                "dentro del script, las reglas de texto la leerían como prosa del capítulo")
    return None


# ------------------------------------------------------- saneado de las entradas

def solo_etiquetas_permitidas(html):
    """¿El HTML de una entrada usa solo em, i, sup, sub y a[href] con http(s)?"""
    for m in re.finditer(r"<(/?)([A-Za-z][\w-]*)([^>]*)>", html):
        cierra, nombre, resto = m.groups()
        if nombre not in ETIQUETAS_PERMITIDAS:
            return False
        if cierra:
            if resto.strip():
                return False
        elif nombre == "a":
            if not re.fullmatch(r'\s+href="https?://[^"<>\s]+"', resto):
                return False
        elif resto.strip():
            return False
    return "<" not in re.sub(r"<(/?)([A-Za-z][\w-]*)([^>]*)>", "", html)


def texto_plano(html):
    """El texto de una entrada sin etiquetas: va en el `title` de la cita."""
    import html as _html
    return " ".join(_html.unescape(re.sub(r"<[^>]*>", "", html)).split())
