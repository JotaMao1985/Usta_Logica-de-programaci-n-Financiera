#!/usr/bin/env python3
"""
Verificador estructural de los capítulos de Lógica de Programación Financiera.

Comprueba una cosa sobre la plantilla y dieciocho sobre cada archivo HTML de capítulo:

  1. DERIVA — que el bloque LP-CORE (la librería de componentes) sea
     byte a byte idéntico al de `_plantilla/lp-base.html`.
  2. CUOTA DE EJERCICIOS — que se cumpla la taxonomía E1..E8 acordada,
     con E1, E3 y E7 obligatorios.
  3. COMPONENTES SIN DEFINIR — que todo componente usado en el JSX exista.
  4. CODETABS COMPLETOS — que cada bloque de código traiga los cuatro
     lenguajes: pseudo, python, r, vba.
  5. MOTIVACIÓN — que cada sección del `curriculum` abra con <Motivacion>.
  6. EJERCICIOS MULTILINGÜES — que un ejercicio presentado en varios lenguajes
     los traiga los cuatro, y que `DetectaError` no use una `lineaCorrecta`
     fija cuando sus líneas cambian con el lenguaje.
  7. SALIDA — que vaya dentro del bloque y con el prefijo de su lenguaje
     (`//>` pseudocódigo · `#>` Python y R · `'>` VBA), y que no sobreviva
     ninguna propiedad `salidas={...}` del panel separado anterior.
  8. TEXTO POR LENGUAJE — que un `DetectaError` cuyas `lineas` cambian con el
     lenguaje no cite «la línea N» en un `enunciado` o una `explicacion` fijos.
     Es la regla 6 aplicada a la prosa: se arregló la clave y se dejó el texto.
  9. SALIDAS EJECUTADAS — que la salida declarada tras `#>` sea la que el código
     produce de verdad. Vive en `ejecutar_salidas.py` porque corre procesos y
     tarda; se pide con `--con-salidas`.
 10. CONTRASTE — que ningún color de la paleta por debajo de 3,0:1 sobre el
     fondo de la página se use como color de texto sin querer.
 11. ENUNCIADOS — que ningún ejercicio pida escribir un programa desde cero:
     está excluido por diseño de la taxonomía; eso es de los talleres.
 12. PREGUNTAS IMPOSIBLES — que ninguna pregunta con más de una respuesta
     correcta olvide `multiple: true`. Sin esa bandera la selección es de
     opción única —la segunda elección reemplaza a la primera— mientras la
     calificación sigue exigiendo el conjunto completo, así que la pregunta
     no se puede acertar. Se ve como un «incorrecto» que no explica nada.
 13. PLANTILLA AL DÍA — que `lp-base.html` sea lo que `ensamblar.py` produciría
     ahora con sus fuentes. Es el eslabón que le faltaba a la regla 1: sin ella,
     editar `lp-core-extra.jsx` y olvidar el ensamblado deja los capítulos
     coincidiendo con una plantilla vieja, y las doce reglas en verde mientras
     el material corre la librería anterior. Se comprueba una sola vez, antes
     que las demás, y aborta si falla.
 14. CLAVE PREVISIBLE EN UN `Quiz` — que una tanda de preguntas no tenga todas
     las claves en la misma letra.
 15. JSX COMPILA — que el bloque `text/babel` pase por Babel. Vive en
     `comprobar_jsx.js`. Nació de romper el capítulo 4 dos veces seguidas con
     las catorce reglas anteriores en verde: una comilla invertida dentro de un
     `template literal` y un comentario JSX puesto como hermano de un elemento.
     Las dos dejan el capítulo en blanco y ninguna se ve leyendo el archivo.
 16. CLAVE PREVISIBLE EN EL CAPÍTULO — que las claves de TODOS los ejercicios
     —no solo las del `Quiz`— no se concentren en una letra ni formen rachas.
     La regla 14 exige casi unanimidad y solo mira el `Quiz`; el capítulo 4
     llegó a la auditoría con 14 de 18 claves en la «b» y pasaba en verde.
 17. CLAVE MÁS LARGA — que la opción correcta no se delate por medir el doble
     que los distractores. Solo en ítems cuyas opciones son todas prosa.
 18. PREGUNTA REPETIDA — que ninguna opción del cuestionario final sea copia
     literal de otra que el estudiante ya respondió en el capítulo.
 19. COBERTURA DEL CUESTIONARIO — que el `Quiz` toque todas las secciones del
     `curriculum`. Se comprueba solo si las preguntas lo declaran con
     `seccion: 'capN'`: a qué sección pertenece una pregunta no se puede
     adivinar leyéndola, y adivinarlo mal sería peor que no comprobarlo.

Uso:
    python3 _plantilla/verificar.py                 # todos los capítulos
    python3 _plantilla/verificar.py 03_LPF_*.html   # archivos concretos
    python3 _plantilla/verificar.py --sin-cuota     # omite la regla 2
                                                    # (útil en capítulos a medias)
    python3 _plantilla/verificar.py --con-salidas   # añade la regla 9 (lenta)

La regla 15 necesita Node con @babel/core y @babel/preset-react instalados en
global (`npm i -g @babel/core @babel/preset-react`). Si faltan, avisa en vez de
fallar: no es lo mismo «está mal» que «no se pudo comprobar».

Devuelve 0 si todo pasa, 1 si algo falla.
"""

import hashlib
import re
import subprocess
import sys
from pathlib import Path

try:
    import ejecutar_salidas
    import ensamblar
except ImportError:  # se ejecuta desde otro directorio
    sys.path.insert(0, str(Path(__file__).resolve().parent))
    import ejecutar_salidas
    import ensamblar

AQUI = Path(__file__).resolve().parent
MATERIAL = AQUI.parent
BASE = AQUI / "lp-base.html"

MARCA_INICIO = "/* === LP-CORE INICIO"
MARCA_FIN = "/* === LP-CORE FIN === */"

# Cuota mínima y máxima por tipo de ejercicio (§4 del plan).
CUOTA = {
    "E1": (3, 4),
    "E2": (2, 4),
    "E3": (2, 2),
    "E4": (1, 2),
    "E5": (1, 2),
    "E6": (1, 1),
    "E7": (2, 2),
    "E8": (1, 2),
}
OBLIGATORIOS = ("E1", "E3", "E7")

# Cómo se cuenta cada tipo: componente propio o envoltorio <Ejercicio tipo="...">.
POR_COMPONENTE = {
    "E1": "TablaTraza",
    "E3": "DetectaError",
    "E4": "Comparador",
    "E5": "OrdenaPasos",
    "E6": "Emparejamiento",
}
POR_ENVOLTORIO = ("E2", "E7", "E8")

LENGUAJES = ("pseudo", "python", "r", "vba")

# Etiquetas que no son componentes React definidos por nosotros.
IGNORAR = {"React", "ReactDOM", "Fragment", "Math", "Object", "JSON", "Array",
           "Number", "String", "Boolean", "Promise", "Set", "Map", "Date"}

ROJO, VERDE, AMAR, GRIS, FIN = "\033[31m", "\033[32m", "\033[33m", "\033[90m", "\033[0m"


def bloque_core(texto, ruta):
    i = texto.find(MARCA_INICIO)
    j = texto.find(MARCA_FIN)
    if i == -1 or j == -1:
        return None, f"no se encontraron los centinelas LP-CORE en {ruta.name}"
    return texto[i:j + len(MARCA_FIN)], None


def cuerpo_capitulo(texto):
    """Todo lo que va DESPUÉS de LP-CORE: el contenido propio del capítulo."""
    j = texto.find(MARCA_FIN)
    return texto[j:] if j != -1 else texto


def contar_ejercicios(cuerpo):
    conteo = {}
    for tipo, comp in POR_COMPONENTE.items():
        conteo[tipo] = len(re.findall(r"<" + comp + r"[\s/>]", cuerpo))
    for tipo in POR_ENVOLTORIO:
        conteo[tipo] = len(re.findall(r'<Ejercicio\s+tipo="' + tipo + r'"', cuerpo))
    return conteo


def componentes_sin_definir(texto, cuerpo):
    usados = set(re.findall(r"<([A-Z][A-Za-z0-9_]*)[\s/>]", cuerpo))
    definidos = set(re.findall(r"const\s+([A-Z][A-Za-z0-9_]*)\s*=", texto))
    definidos |= set(re.findall(r"^\s{12}([A-Z][A-Za-z0-9_]*):\s*\(", texto, re.M))  # Icons
    return sorted(usados - definidos - IGNORAR)


def secciones_sin_motivacion(cuerpo):
    """Toda sección debe abrir con <Motivacion>: es la convención del curso.

    Se leen los componentes declarados en `curriculum` y, para cada uno, se
    comprueba que el primer componente de su cuerpo sea Motivacion (el <div
    className="prose-lp"> envolvente no cuenta: empieza en minúscula).
    """
    m = re.search(r"const\s+curriculum\s*=\s*\[(.*?)\n\s*\];", cuerpo, re.S)
    if not m:
        return ["no se encontró el arreglo `curriculum`"]

    fallos = []
    for comp in re.findall(r"component:\s*([A-Za-z0-9_]+)", m.group(1)):
        d = re.search(r"const\s+" + comp + r"\s*=\s*\(\s*\)\s*=>\s*\(", cuerpo)
        if not d:
            fallos.append(f"{comp}: no se encontró su definición")
            continue
        primero = re.search(r"<([A-Z][A-Za-z0-9_]*)", cuerpo[d.end():d.end() + 3000])
        if not primero:
            fallos.append(f"{comp}: no contiene ningún componente")
        elif primero.group(1) != "Motivacion":
            fallos.append(f"{comp}: abre con <{primero.group(1)}> y debería abrir con <Motivacion>")
    return fallos


def bloques_de(cuerpo, componente):
    """Devuelve el texto de cada `<Componente ... />` del cuerpo.

    No se puede usar una expresión regular perezosa hasta `/>`: un fragmento
    JSX (`enunciado={<>...</>}`) termina en `</>`, que contiene `/>`, y el
    bloque se cortaría a los pocos caracteres. Se recorre el texto llevando
    la cuenta de las llaves y se corta en el primer `/>` o `>` que esté
    FUERA de cualquier expresión `{...}`.
    """
    salida = []
    for m in re.finditer("<" + componente + r"[\s/>]", cuerpo):
        i = m.start()
        prof, j, n = 0, i, len(cuerpo)
        while j < n - 1:
            c = cuerpo[j]
            if c == "{":
                prof += 1
            elif c == "}":
                prof -= 1
            elif prof == 0 and c == "/" and cuerpo[j + 1] == ">":
                j += 2
                break
            elif prof == 0 and c == ">" and j > i:
                j += 1
                break
            j += 1
        salida.append(cuerpo[i:j])
    return salida


def mapa_de_lenguajes(texto, nombre):
    """¿La constante `nombre` es un objeto {pseudo, python, r, vba}?

    Devuelve la lista de lenguajes presentes, o None si no es un mapa.
    """
    m = re.search(r"const\s+" + nombre + r"\s*=\s*\{", texto)
    if not m:
        return None
    resto = texto[m.end():]
    cierre = re.search(r"\n\s{0,12}\};", resto)
    trozo = resto[:cierre.start()] if cierre else resto[:8000]
    presentes = [l for l in LENGUAJES if re.search(r"\n\s+" + l + r":", trozo)]
    return presentes if presentes else None


def ejercicios_multilingues_mal(texto, cuerpo):
    """Coherencia de los ejercicios que se presentan en varios lenguajes.

    El fallo grave es un `DetectaError` con `lineas` multilingüe y una
    `lineaCorrecta` fija: el mismo error NO está en la misma línea en los
    cuatro lenguajes, así que el ejercicio calificaría mal al cambiar de
    pestaña, y sin avisar de nada.
    """
    fallos = []

    for bloque in bloques_de(cuerpo, "DetectaError"):
        m_l = re.search(r"lineas=\{([A-Za-z0-9_]+)\}", bloque)
        m_c = re.search(r"lineaCorrecta=\{([A-Za-z0-9_]+)\}", bloque)
        if not m_l:
            continue
        idiomas = mapa_de_lenguajes(texto, m_l.group(1))
        if not idiomas:
            continue
        faltan = [l for l in LENGUAJES if l not in idiomas]
        if faltan:
            fallos.append(f"DetectaError · {m_l.group(1)}: faltan {', '.join(faltan)}")
        if not m_c:
            fallos.append(
                "DetectaError · `lineas` es multilingüe pero `lineaCorrecta` es un "
                "número fijo: calificaría mal al cambiar de pestaña")
            continue
        idiomas_c = mapa_de_lenguajes(texto, m_c.group(1))
        if idiomas_c is None:
            fallos.append(
                f"DetectaError · `lineaCorrecta` apunta a {m_c.group(1)}, que no es "
                "un objeto por lenguaje")
        else:
            faltan_c = [l for l in idiomas if l not in idiomas_c]
            if faltan_c:
                fallos.append(f"DetectaError · {m_c.group(1)}: faltan {', '.join(faltan_c)}")

    # `Trazador` no es un ejercicio y no entra en la cuota, pero su `codigo` se
    # presenta en pestañas igual que el de `TablaTraza`: un mapa al que le falte
    # un lenguaje deja la pestaña vacía sin avisar de nada.
    for comp, prop in (("TablaTraza", "codigo"), ("OrdenaPasos", "pasos"),
                       ("Emparejamiento", "izquierda"), ("Comparador", "codigo"),
                       ("Trazador", "codigo")):
        for bloque in bloques_de(cuerpo, comp):
            for nombre in re.findall(prop + r"\s*[:=]\s*\{?([A-Za-z0-9_]+)\}?", bloque):
                idiomas = mapa_de_lenguajes(texto, nombre)
                if idiomas:
                    faltan = [l for l in LENGUAJES if l not in idiomas]
                    if faltan:
                        fallos.append(f"{comp} · {nombre}: faltan {', '.join(faltan)}")
    return fallos


def valor_de_prop(bloque, nombre):
    """Texto crudo del valor de `nombre=` dentro de un bloque JSX.

    Devuelve el interior de `{...}` con las llaves equilibradas —hace falta:
    `enunciado={<>…</>}` lleva llaves anidadas— o el interior de las comillas
    si el valor es una cadena. `None` si la propiedad no aparece.
    """
    m = re.search(r"\b" + nombre + r"\s*=\s*", bloque)
    if not m:
        return None
    i = m.end()
    if i >= len(bloque):
        return None
    if bloque[i] in "\"'":
        cierre = bloque.find(bloque[i], i + 1)
        return bloque[i + 1:cierre] if cierre != -1 else bloque[i + 1:]
    if bloque[i] != "{":
        return None
    prof = 0
    for j in range(i, len(bloque)):
        if bloque[j] == "{":
            prof += 1
        elif bloque[j] == "}":
            prof -= 1
            if prof == 0:
                return bloque[i + 1:j]
    return bloque[i + 1:]


# `<strong>línea 5</strong>`, «la línea 4», «las líneas 3 y 4»: el número puede
# venir envuelto en etiquetas, así que se quitan antes de buscar.
CITA_LINEA = re.compile(r"l[ií]neas?\s+\d+", re.I)


def cita_numero_de_linea(valor):
    return bool(CITA_LINEA.search(re.sub(r"<[^>]*>", " ", valor)))


def prop_por_lenguaje(texto, valor):
    """¿El valor de la propiedad es un objeto {pseudo, python, r, vba}?

    Admite las dos formas de escribirlo: una constante con nombre
    (`explicacion={ERROR_EXPLICACION}`) o el objeto literal en el sitio.
    """
    v = valor.strip()
    if re.fullmatch(r"[A-Za-z0-9_]+", v):
        return mapa_de_lenguajes(texto, v) is not None
    if v.startswith("{"):
        return any(re.search(r"[{,]\s*" + l + r"\s*:", v) for l in LENGUAJES)
    return False


def textos_de_detectaerror_mal(texto, cuerpo):
    """El TEXTO de un E3 multilingüe también depende del lenguaje.

    Un `DetectaError` cuyas `lineas` cambian con el lenguaje no puede citar un
    número de línea en un `enunciado` o una `explicacion` fijos: «el comentario
    de la línea 4» es cierto en pseudocódigo y falso en Python, donde la 4 es
    justamente la respuesta —el enunciado la regala mientras afirma otra cosa—.

    Es el mismo fallo silencioso que motivó la comprobación 6, pero en la prosa
    en vez de en la clave: se arregló `lineaCorrecta` y se dejó el texto fijo.
    Lo más robusto es redactar sin citar números; si hay que citarlos, la
    propiedad va por lenguaje.
    """
    fallos = []
    for bloque in bloques_de(cuerpo, "DetectaError"):
        m_l = re.search(r"lineas=\{([A-Za-z0-9_]+)\}", bloque)
        if not m_l or not mapa_de_lenguajes(texto, m_l.group(1)):
            continue
        for prop in ("enunciado", "explicacion"):
            valor = valor_de_prop(bloque, prop)
            if valor is None or prop_por_lenguaje(texto, valor):
                continue
            if cita_numero_de_linea(valor):
                fallos.append(
                    f"DetectaError · `{prop}` cita un número de línea y no es un "
                    f"objeto por lenguaje; como `lineas` sí lo es, ese número "
                    f"solo es cierto en uno de los cuatro")
    return fallos


PREFIJO_SALIDA = {"pseudo": "//>", "python": "#>", "r": "#>", "vba": "'>"}


def salida_mal_puesta(cuerpo):
    """La salida va DENTRO del bloque, con el prefijo de su lenguaje.

    Dos fallos que se cuelan solos:
      · sobrevive la antigua propiedad `salidas={...}` de un panel aparte;
      · una línea de salida lleva el prefijo de OTRO lenguaje —copiar y pegar
        entre variantes es justo como pasa—, y entonces no se resalta como
        salida ni es comentario válido en ese lenguaje.
    """
    fallos = []
    if re.search(r"\bsalidas=\{", cuerpo):
        fallos.append("sobrevive una propiedad `salidas={...}`: la salida va dentro del bloque")

    # El `\n` final va en un lookahead: si se consume, el bloque siguiente se
    # queda sin el `\n` que necesita para empezar y solo se ve uno de cada dos.
    for m in re.finditer(r"\n            (pseudo|python|r|vba): `(.*?)`,(?=\n)", cuerpo, re.S):
        lang, codigo = m.group(1), m.group(2)
        propio = PREFIJO_SALIDA[lang]
        ajenos = {p for l, p in PREFIJO_SALIDA.items() if p != propio}
        for linea in codigo.split("\n"):
            s = linea.strip()
            for aj in ajenos:
                if s.startswith(aj) and not s.startswith(propio):
                    fallos.append(
                        f"bloque `{lang}`: la línea «{s[:34]}» usa el prefijo de otro "
                        f"lenguaje; en {lang} debe ser `{propio}`")
                    break
    return fallos


def codetabs_incompletos(texto, cuerpo):
    fallos = []
    for nombre in re.findall(r"<CodeTabs[\s\S]{0,400}?bloques=\{([A-Za-z0-9_]+)\}", cuerpo):
        m = re.search(r"const\s+" + nombre + r"\s*=\s*\{", texto)
        if not m:
            fallos.append(f"{nombre}: no se encontró su definición")
            continue
        # Trozo hasta el cierre del objeto, a nivel de indentación de la declaración.
        resto = texto[m.end():]
        cierre = re.search(r"\n\s{0,12}\};", resto)
        trozo = resto[:cierre.start()] if cierre else resto[:6000]
        faltan = [l for l in LENGUAJES if not re.search(r"\n\s+" + l + r":", trozo)]
        if faltan:
            fallos.append(f"{nombre}: faltan {', '.join(faltan)}")
    return fallos


# ---------------------------------------------------------------- 10 · color

MINIMO_WCAG = 3.0          # texto grande; el texto normal exige 4,5:1
FONDO_SUPUESTO = "#F8FAFC"

# Un uso ya revisado se calla escribiendo `contraste-ok` en su línea o en la
# anterior. Sin esa válvula, el aviso del `text-gold` legítimo de la barra
# lateral saldría en cada ejecución para siempre, y un aviso que siempre está
# ahí deja de leerse: la comprobación se volvería decorativa.
INDULTO = "contraste-ok"


def _luminancia(hexa):
    def canal(v):
        v /= 255
        return v / 12.92 if v <= 0.03928 else ((v + 0.055) / 1.055) ** 2.4
    r, g, b = (int(hexa[i:i + 2], 16) for i in (1, 3, 5))
    return 0.2126 * canal(r) + 0.7152 * canal(g) + 0.0722 * canal(b)


def razon_contraste(uno, otro):
    a, b = _luminancia(uno), _luminancia(otro)
    return (max(a, b) + 0.05) / (min(a, b) + 0.05)


def paleta_de(texto):
    """{nombre: '#RRGGBB'} de la configuración de Tailwind del head."""
    m = re.search(r"colors:\s*\{(.*?)\n\s*\}", texto, re.S)
    if not m:
        return {}
    return {n: h.upper() for n, h in re.findall(r"(\w+):\s*'(#[0-9A-Fa-f]{6})'", m.group(1))}


def linea_de(texto, pos):
    return texto.count("\n", 0, pos) + 1


def indultado(texto, pos):
    fin = texto.find("\n", pos)
    ini = texto.rfind("\n", 0, texto.rfind("\n", 0, pos))
    return INDULTO in texto[max(ini, 0):fin if fin != -1 else len(texto)]


def zona_jsx(texto):
    """(fragmento, desplazamiento) del JSX, dejando fuera el CSS del head.

    No vale reutilizar `cuerpo_capitulo` por dos motivos opuestos. Por abajo se
    queda corto: en un capítulo todavía sin centinelas devuelve el archivo
    entero, y entonces se miden los colores de Prism —que van sobre el fondo
    oscuro de los bloques de código— contra el fondo claro de la página; todos
    incumplirían, ninguno sería un defecto. Por arriba se pasa: empieza en
    `LP-CORE FIN`, así que la librería no la auditaría nadie nunca.

    Se empieza, entonces, donde empieza el JSX y no antes.
    """
    i = texto.find('<script type="text/babel">')
    return (texto[i:], i) if i != -1 else (texto, 0)


def es_icono(texto, pos):
    """¿La clase está en un `<i>`? Un icono no es texto y no le aplica la regla.

    La convención del curso lo dice explícitamente: el lugar del gold es «la
    barra lateral navy y los iconos». Sin esta excepción, el `fa-dumbbell` de
    `Reto` avisaría en los ocho capítulos, y por un uso que está permitido.
    """
    abre = texto.rfind("<", 0, pos)
    return abre != -1 and re.match(r"<i[\s>]", texto[abre:abre + 3]) is not None


def contraste_dudoso(texto, _cuerpo, _desplazamiento):
    """Colores demasiado tenues para ir como texto sobre el fondo de la página.

    Sale como AVISO y no como falla a propósito: `text-gold` es correcto dentro
    de la barra lateral navy e incorrecto sobre `#F8FAFC`. Distinguirlos exige
    saber qué elemento envuelve a cuál, y eso el análisis estático no lo resuelve
    de forma fiable. Un veredicto automático daría confianza falsa; una lista
    corta de sitios a confirmar, no.
    """
    cuerpo, desplazamiento = zona_jsx(texto)
    paleta = paleta_de(texto)
    if not paleta:
        return ["no se encontró la paleta del head: no se pudo medir nada"]
    fondo = paleta.get("bg", FONDO_SUPUESTO)

    avisos = []
    for nombre, hexa in sorted(paleta.items()):
        if nombre in ("bg", "surface"):
            continue
        razon = razon_contraste(hexa, fondo)
        if razon >= MINIMO_WCAG:
            continue
        lineas = [linea_de(texto, desplazamiento + m.start())
                  for m in re.finditer(r"\btext-" + nombre + r"\b", cuerpo)
                  if not indultado(cuerpo, m.start()) and not es_icono(cuerpo, m.start())]
        if lineas:
            avisos.append(
                f"`{nombre}` ({hexa}) da {razon:.2f}:1 sobre {fondo}, por debajo de "
                f"{MINIMO_WCAG}:1. Se usa como texto en la línea "
                f"{', '.join(map(str, lineas))} — confirme que va sobre fondo oscuro "
                f"y marque la línea con «{INDULTO}»")

    # Colores escritos a mano, fuera de la paleta, que sí son inequívocamente
    # texto: `text-[#RRGGBB]` de Tailwind y `color:` de un estilo en línea.
    for m in re.finditer(r"text-\[(#[0-9A-Fa-f]{6})\]|color:\s*'?(#[0-9A-Fa-f]{6})", cuerpo):
        hexa = (m.group(1) or m.group(2)).upper()
        razon = razon_contraste(hexa, fondo)
        if razon < MINIMO_WCAG and not indultado(cuerpo, m.start()):
            avisos.append(
                f"{hexa} da {razon:.2f}:1 sobre {fondo} y se usa como color de texto "
                f"en la línea {linea_de(texto, desplazamiento + m.start())}")
    return avisos


# ----------------------------------------------------------- 11 · enunciados

PIDE_PROGRAMA = re.compile(
    r"\b(?:escrib\w+|redact\w+|cree|creen|implement\w+|desarroll\w+|codifiqu\w+"
    r"|construy\w+|elabor\w+|program(?:e|en))"
    r"\s+(?:un|una|el|la|los|las|su|sus)?\s*"
    r"(?:programas?|funci[oó]n|funciones|algoritmos?|scripts?|macros?"
    r"|procedimientos?|subrutinas?)\b",
    re.I)

PROPS_ENUNCIADO = ("enunciado", "pregunta", "titulo")


def valores_de(cuerpo, nombre):
    """(posición, valor) de cada `nombre=` del cuerpo, con llaves equilibradas."""
    for m in re.finditer(r"\b" + nombre + r"\s*=\s*", cuerpo):
        i = m.end()
        if i >= len(cuerpo):
            continue
        if cuerpo[i] in "\"'":
            cierre = cuerpo.find(cuerpo[i], i + 1)
            yield i, cuerpo[i + 1:cierre if cierre != -1 else len(cuerpo)]
            continue
        if cuerpo[i] != "{":
            continue
        prof = 0
        for j in range(i, len(cuerpo)):
            if cuerpo[j] == "{":
                prof += 1
            elif cuerpo[j] == "}":
                prof -= 1
                if prof == 0:
                    yield i, cuerpo[i + 1:j]
                    break


def cuerpos_de_reto(cuerpo):
    """El enunciado de un E8 va en los hijos de `<Reto>`, no en una propiedad."""
    for m in re.finditer(r"<Reto\b", cuerpo):
        abre = cuerpo.find(">", m.end())
        fin = cuerpo.find("</Reto>", abre)
        if abre != -1 and fin != -1:
            yield abre, cuerpo[abre + 1:fin]


def pide_escribir_programa(texto, cuerpo, desplazamiento):
    """Ningún ejercicio pide escribir un programa desde cero.

    Está excluido por diseño de la taxonomía: aquí se lee, se traza, se
    diagnostica, se compara y se justifica; escribir desde cero es de los
    talleres evaluables.

    Se busca SOLO en enunciados —las propiedades y el cuerpo de `<Reto>`— y no
    en la prosa de la exposición. Ahí la frase es legítima («en el taller se le
    pedirá escribir un programa que…») y marcarla como falla haría que el
    verificador mintiera, que es peor que no comprobar.
    """
    fallos = []
    trozos = [(p, v) for prop in PROPS_ENUNCIADO for p, v in valores_de(cuerpo, prop)]
    trozos += list(cuerpos_de_reto(cuerpo))
    for pos, valor in trozos:
        m = PIDE_PROGRAMA.search(re.sub(r"<[^>]*>", " ", valor))
        if m:
            fallos.append(
                f"línea {linea_de(texto, desplazamiento + pos)}: «{m.group(0)}» pide "
                f"escribir código desde cero, y la taxonomía lo excluye")
    return fallos


def preguntas_imposibles(texto, cuerpo, desplazamiento):
    """Ninguna pregunta con varias respuestas correctas sin `multiple: true`.

    `Quiz` y `MCQ` deciden con esa bandera cómo se comporta la selección: sin
    ella, elegir una segunda opción **reemplaza** a la primera, mientras que la
    calificación sigue exigiendo el conjunto completo. Una pregunta con dos
    `correcta: true` y sin la bandera es, por tanto, **imposible de acertar**.

    No se ve en pantalla: la pregunta se pinta bien, se puede responder y el
    veredicto es «incorrecto» sin decir por qué. Se descubrió respondiendo el
    cuestionario del capítulo 2 con las diez respuestas buenas y obteniendo 9.

    La etiqueta «(selección múltiple)» la pinta el componente a partir de la
    bandera, así que escribirla a mano en el enunciado no arregla nada y además
    la duplica; eso se avisa aparte.

    Los comentarios `//` se retiran antes de mirar. No es un detalle: la primera
    versión de esta regla no encontraba nada porque el comentario que explica la
    bandera la escribe, y bastaba con eso para que la regla se diera por
    satisfecha. Lo descubrió su propia prueba negativa, que es exactamente para
    lo que sirve.

    Desde la auditoría del capítulo 4 mira los ítems por su lista `opciones` y
    no por la palabra `pregunta:`. Antes solo veía los objetos de `Quiz`, que la
    escriben con dos puntos; un `<MCQ>` o un `<Comparador>` sueltos la escriben
    como prop JSX, `pregunta=`, y quedaban fuera. Se comprobó quitándole la
    bandera a un `<MCQ>` de dos respuestas correctas: la regla daba verde a un
    ejercicio imposible de acertar. Y la bandera se acepta en sus dos formas,
    `multiple: true` y `multiple={{true}}`, según dónde viva la pregunta.
    """
    fallos = []
    limpio = _sin_comentarios(cuerpo)
    items = items_de_opciones(limpio)
    for k, (ini, fin, opciones) in enumerate(items):
        correctas = sum(1 for _t, ok in opciones if ok)
        if correctas <= 1:
            continue
        # La bandera va cerca, pero a un lado distinto según la forma: en el
        # objeto de `Quiz` va DESPUÉS de la lista y en un componente suelto
        # ANTES, como prop JSX. Se mira todo lo que hay entre el ítem anterior
        # y el siguiente: es exacto y no se cuela en el vecino.
        desde = items[k - 1][1] if k else 0
        hasta = items[k + 1][0] if k + 1 < len(items) else len(limpio)
        if re.search(r"\bmultiple\s*(?::\s*true|=\s*\{\s*true\s*\})", limpio[desde:hasta]):
            continue
        fallos.append(
            f"línea {linea_de(texto, desplazamiento + ini)}: la pregunta tiene "
            f"{correctas} opciones correctas y no declara `multiple: true` ni "
            f"`multiple={{true}}`, así que es imposible de acertar")
    return fallos


def etiqueta_multiple_a_mano(texto, cuerpo, desplazamiento):
    """La etiqueta «(selección múltiple)» la pone el componente, no el autor."""
    avisos = []
    for m in re.finditer(r"pregunta:\s*['\"][^'\"]*\(selecci[óo]n m[úu]ltiple\)", cuerpo):
        avisos.append(
            f"línea {linea_de(texto, desplazamiento + m.start())}: «(selección "
            f"múltiple)» escrito en el enunciado; el componente ya la pinta a "
            f"partir de `multiple: true` y aquí saldría dos veces")
    return avisos


def clave_siempre_en_el_mismo_sitio(texto, cuerpo, desplazamiento):
    """Ninguna tanda de preguntas pone la respuesta correcta siempre en la misma letra.

    Un cuestionario cuyas diez claves son la «a» se responde entero sin leer una
    sola pregunta, y califica 10 sobre 10. El defecto no se ve al escribirlo
    —cada pregunta se redacta por separado, y lo natural es poner primero la
    respuesta buena y después inventar los distractores— ni al responderlo, si
    se responde de verdad; solo se ve contando.

    Apareció al escribir el cuestionario del capítulo 3: sus diez claves habían
    quedado en la «a». Al medir los otros dos capítulos resultó que no era un
    descuido de ese día sino el patrón de todo el material.

    La regla mira cada bloque `<Quiz>` por separado, porque es la tanda que el
    estudiante responde de una sentada. Exige al menos cuatro preguntas: por
    debajo de eso, que coincidan puede ser casualidad. De cada pregunta toma la
    posición de la PRIMERA opción correcta —basta para el patrón, y así una
    pregunta de selección múltiple no queda fuera de la cuenta—.

    No hizo falta fabricarle una prueba negativa: los capítulos 1 y 2 la traían
    puesta, y la regla los señaló en cuanto se ejecutó —doce claves en la «a»
    repartidas en dos `Quiz`, y nueve de diez en la «b»—. Fueron ellos, además,
    los que afinaron el umbral: con la primera versión, que exigía unanimidad, el
    capítulo 2 pasaba en verde.
    """
    fallos = []
    letras = "abcdefgh"
    sin_comentarios = re.sub(r"//[^\n]*", lambda c: " " * len(c.group(0)), cuerpo)
    for q in re.finditer(r"<Quiz\b", sin_comentarios):
        # La tanda llega hasta el cierre del componente. Se corta en el `<Quiz`
        # siguiente si lo hubiera, que es más barato que equilibrar llaves.
        sig = sin_comentarios.find("<Quiz", q.end())
        tanda = sin_comentarios[q.start():sig if sig != -1 else len(sin_comentarios)]
        posiciones = []
        for m in re.finditer(r"\bpregunta:\s*", tanda):
            fin = tanda.find("justificacion:", m.end())
            trozo = tanda[m.end():fin if fin != -1 else len(tanda)]
            opciones = [o.start() for o in re.finditer(r"\{\s*texto:", trozo)]
            if not opciones:
                continue
            for i, ini in enumerate(opciones):
                hasta = opciones[i + 1] if i + 1 < len(opciones) else len(trozo)
                if re.search(r"correcta:\s*true", trozo[ini:hasta]):
                    posiciones.append(i)
                    break
        n = len(posiciones)
        if n < 4:
            continue
        sitio = max(set(posiciones), key=posiciones.count)
        repiten = posiciones.count(sitio)
        # Todas iguales desde cuatro preguntas; o todas menos una desde seis. La
        # segunda mitad de la regla existe porque el capítulo 2 tenía nueve de
        # diez claves en la «b» y la primera versión, que exigía unanimidad, lo
        # dejaba pasar: la décima pregunta es de selección múltiple y su primera
        # correcta cae en otro sitio. Nueve de diez no es casualidad.
        if repiten == n or (n >= 6 and n - repiten <= 1):
            cuantas = "todas" if repiten == n else f"{repiten} de {n}"
            fallos.append(
                f"línea {linea_de(texto, desplazamiento + q.start())}: en este "
                f"`Quiz` de {n} preguntas, {cuantas} tienen la respuesta correcta "
                f"en la misma posición (la «{letras[sitio]}»), así que se acierta "
                f"sin leerlas")
    return fallos


# --------------------------------------------------- 13 · plantilla al día
# La comprobación 1 mira capítulo contra `lp-base.html`, y esa cadena tiene un
# eslabón antes: `lp-base.html` contra sus fuentes. Si alguien edita
# `lp-core-extra.jsx` y no ensambla, los tres capítulos coinciden con una
# plantilla vieja y las doce comprobaciones dan verde mientras el material
# corre la librería anterior. Pasó al escribir el `Trazador`: el capítulo se
# abrió en blanco con un error de React que no dice qué componente lo produjo.
#
# De paso cubre la trampa 1 del procedimiento —`ensamblar.py` lee el `head` del
# capítulo 1, así que ese archivo es fuente y destino a la vez—: tocarlo también
# deja la plantilla desactualizada, y hasta ahora eso no lo detectaba nada.
def plantilla_desactualizada():
    esperado = ensamblar.construir()
    real = BASE.read_text(encoding="utf-8")
    if esperado == real:
        return None
    a, b = esperado.splitlines(), real.splitlines()
    for i, (x, y) in enumerate(zip(a, b)):
        if x != y:
            return (f"lp-base.html no coincide con sus fuentes (primera diferencia en la "
                    f"línea {i + 1})\n        ejecute: python3 _plantilla/ensamblar.py")
    return (f"lp-base.html no coincide con sus fuentes ({len(real)} líneas en disco, "
            f"{len(esperado)} al ensamblar)\n        ejecute: python3 _plantilla/ensamblar.py")


def _sin_comentarios(cuerpo):
    """Los comentarios `//` sustituidos por espacios de la misma longitud.

    No se borran: así las posiciones no se mueven y el número de línea que se
    informa sigue siendo el del archivo. Y se retiran antes de mirar porque el
    comentario que explica la bandera `multiple` la escribe literalmente, y con
    eso la regla 12 se daba por satisfecha. Lo cazó su propia prueba negativa.
    """
    return re.sub(r"//[^\n]*", lambda c: " " * len(c.group(0)), cuerpo)


def items_de_opciones(cuerpo):
    """Cada lista `opciones` del capítulo, en orden de aparición.

    Las hay de dos formas y hasta la auditoría del capítulo 4 solo se miraba
    una: `opciones: [...]` dentro de un objeto de `Quiz`, y `opciones={[...]}`
    como prop de un `<MCQ>` o un `<Comparador>` sueltos. La regla 12 buscaba
    `pregunta:` con dos puntos, así que los sueltos —que son la mayoría de los
    ejercicios— quedaban fuera de su radar. Se comprobó: un `<MCQ>` con dos
    respuestas correctas y sin bandera pasaba en verde.

    Devuelve (inicio, fin, [(texto, es_correcta), ...]) por ítem.
    """
    items = []
    for m in re.finditer(r"opciones\s*(?:=\{|:)\s*\[", cuerpo):
        ini = cuerpo.rindex("[", m.start(), m.end())
        prof, i = 0, ini
        while i < len(cuerpo):
            if cuerpo[i] == "[":
                prof += 1
            elif cuerpo[i] == "]":
                prof -= 1
                if prof == 0:
                    break
            i += 1
        bloque, opciones, prof2, desde = cuerpo[ini:i + 1], [], 0, None
        for j, ch in enumerate(bloque):
            if ch == "{":
                if prof2 == 0:
                    desde = j
                prof2 += 1
            elif ch == "}":
                prof2 -= 1
                if prof2 == 0 and desde is not None:
                    trozo = bloque[desde:j + 1]
                    t = re.search(r"texto:\s*'(.*?)'(?=\s*,\s*correcta)", trozo, re.S)
                    opciones.append((t.group(1) if t else "",
                                     bool(re.search(r"correcta:\s*true", trozo))))
                    desde = None
        if opciones:
            items.append((ini, i + 1, opciones))
    return items


def claves_del_capitulo(cuerpo):
    """Posición de la clave en TODOS los ítems, en orden de lectura.

    Incluye los `tipoCorrecto` de los `DetectaError`, que también son una
    pregunta de opción múltiple aunque no se escriban con `opciones`.
    """
    limpio = _sin_comentarios(cuerpo)
    claves = []
    for ini, _fin, opciones in items_de_opciones(limpio):
        primera = next((k for k, (_t, ok) in enumerate(opciones) if ok), None)
        if primera is not None:
            claves.append((ini, primera, len(opciones)))
    for m in re.finditer(r"tipoCorrecto=\{(\d+)\}", limpio):
        claves.append((m.start(), int(m.group(1)), 4))
    claves.sort()
    return claves


def clave_previsible_en_el_capitulo(texto, cuerpo, desplazamiento):
    """La clave no se concentra en una letra ni encadena rachas largas.

    La regla 14 mira cada `<Quiz>` por separado, que es la tanda que el
    estudiante responde de una sentada, y exige casi unanimidad. Esta mira el
    capítulo ENTERO —los MCQ de sección, los comparadores y los tipos de los
    `DetectaError`, que son la mayoría de los ítems y que aquella no ve— y se
    conforma con mucho menos.

    Hizo falta porque el capítulo 4 llegó a la auditoría con **14 de 17 claves
    en la «b»**, cinco de ellas seguidas, y la regla 14 lo dejaba pasar: su
    `<Quiz>` tenía 8 de 10, y «todas menos una» son 9. Marcando siempre la «b»
    se sacaba 8 sobre 10 y el componente felicitaba por el dominio del tema.

    Umbrales medidos contra los cuatro capítulos ya escritos, que reparten como
    mucho un 38 % en una posición y no encadenan más de dos seguidas.
    """
    letras = "abcdefgh"
    claves = claves_del_capitulo(cuerpo)
    if len(claves) < 8:
        return []
    fallos = []
    posiciones = [p for _i, p, _n in claves]
    sitio = max(set(posiciones), key=posiciones.count)
    repiten = posiciones.count(sitio)
    if repiten * 2 > len(posiciones):
        fallos.append(
            f"{repiten} de las {len(posiciones)} claves del capítulo están en la "
            f"misma posición (la «{letras[sitio]}»): se acierta la mayoría sin leer")
    racha = inicio = 1
    for k in range(1, len(posiciones)):
        if posiciones[k] == posiciones[k - 1]:
            racha += 1
            if racha >= 4:
                fallos.append(
                    f"línea {linea_de(texto, desplazamiento + claves[k][0])}: "
                    f"{racha} ejercicios seguidos con la clave en la «{letras[posiciones[k]]}»")
                break
        else:
            racha = 1
    return fallos


def clave_mas_larga(texto, cuerpo, desplazamiento):
    """La respuesta correcta no se delata por ser mucho más larga que el resto.

    Es el sesgo clásico, y nace del oficio: se redacta primero la buena —con
    sus matices, sus «pero» y sus «de modo que»— y después se inventan tres
    frases cortas. Quien no sabe el tema marca la larga y acierta.

    Solo se mira cuando las cuatro opciones son prosa (20 caracteres o más).
    En un ítem cuyas opciones son cifras o un «Cero», la longitud no dice nada
    y avisar sería ruido.
    """
    avisos = []
    limpio = _sin_comentarios(cuerpo)
    for ini, _fin, opciones in items_de_opciones(limpio):
        largos = [len(t) for t, _ok in opciones]
        correctas = [k for k, (_t, ok) in enumerate(opciones) if ok]
        if len(correctas) != 1 or len(opciones) < 3 or min(largos) < 20:
            continue
        c = largos[correctas[0]]
        otros = [l for k, l in enumerate(largos) if k != correctas[0]]
        if c >= 1.8 * max(otros):
            avisos.append(
                f"línea {linea_de(texto, desplazamiento + ini)}: la opción correcta "
                f"mide {c} caracteres y el distractor más largo {max(otros)}; "
                f"se acierta por el tamaño")
    return avisos


def _normaliza(t):
    t = t.lower().replace("á", "a").replace("é", "e").replace("í", "i")
    t = t.replace("ó", "o").replace("ú", "u").replace("ñ", "n")
    return re.sub(r"[^a-z0-9]+", " ", t).strip()


def opcion_repetida(texto, cuerpo, desplazamiento):
    """Ninguna opción del cuestionario final es copia literal de una anterior.

    Un cuestionario integrador que repite una opción ya vista mide memoria de
    la respuesta, no transferencia. En el capítulo 4 la opción correcta de una
    pregunta era **carácter por carácter** la misma que un `tipoCorrecto` del
    `DetectaError` de la sección 4, que el estudiante acababa de responder.
    """
    avisos = []
    limpio = _sin_comentarios(cuerpo)
    q = limpio.find("<Quiz")
    if q == -1:
        return []
    antes, despues = [], []
    for ini, _fin, opciones in items_de_opciones(limpio):
        destino = despues if ini > q else antes
        for t, _ok in opciones:
            if len(t) >= 25:
                destino.append((ini, t))
    for m in re.finditer(r"tipos=\{\[(.*?)\]\}", limpio, re.S):
        for t in re.findall(r"'(.*?)'", m.group(1), re.S):
            if len(t) >= 25:
                antes.append((m.start(), t))
    vistas = {_normaliza(t): i for i, t in antes}
    for ini, t in despues:
        n = _normaliza(t)
        if n in vistas:
            avisos.append(
                f"línea {linea_de(texto, desplazamiento + ini)}: esta opción del "
                f"cuestionario repite palabra por palabra una de la línea "
                f"{linea_de(texto, desplazamiento + vistas[n])}")
    return avisos


def cobertura_del_cuestionario(texto, cuerpo, desplazamiento):
    """El cuestionario final toca todas las secciones del `curriculum`.

    Se comprueba solo si las preguntas lo declaran con `seccion: 'capN'`. No se
    puede adivinar a qué sección pertenece una pregunta leyéndola, y adivinarlo
    mal sería peor que no comprobarlo; declararlo cuesta una línea por pregunta
    y deja escrita la intención.

    Hizo falta porque el cuestionario del capítulo 4 no tenía **ni una** pregunta
    de su sección 6 —la de los casos financieros, donde vive el resultado de
    aprendizaje del syllabus— mientras la 5 se llevaba tres.
    """
    limpio = _sin_comentarios(cuerpo)
    q = limpio.find("<Quiz")
    if q == -1:
        return []
    declaradas = set(re.findall(r"seccion:\s*'([^']+)'", limpio[q:]))
    if not declaradas:
        return []
    n_preguntas = len(re.findall(r"\bpregunta:\s*", limpio[q:]))
    if len(re.findall(r"seccion:\s*'", limpio[q:])) != n_preguntas:
        return [f"línea {linea_de(texto, desplazamiento + q)}: unas preguntas del "
                f"`Quiz` declaran `seccion` y otras no; o todas o ninguna"]
    secciones = [m for m in re.findall(r"id:\s*'([^']+)'", cuerpo)
                 if m not in ("portada", "eval")]
    faltan = [x for x in secciones if x not in declaradas]
    if faltan:
        return [f"línea {linea_de(texto, desplazamiento + q)}: el cuestionario no "
                f"tiene ninguna pregunta de {', '.join(faltan)}"]
    return []


def jsx_compila(ruta):
    """El bloque `text/babel` del capítulo compila de verdad.

    Vive en `comprobar_jsx.js` porque necesita el mismo analizador que el
    navegador —@babel/core con preset-react—, y ahí está explicado por qué
    existe: dos veces en una sola auditoría un editor rompió la sintaxis y las
    catorce reglas anteriores dieron verde mientras el capítulo salía en blanco.

    Devuelve (problemas, avisos). Si falta Node o Babel avisa, no falla: no es
    lo mismo «está mal» que «no se pudo comprobar».
    """
    guion = Path(__file__).resolve().parent / "comprobar_jsx.js"
    if not guion.exists():
        return [], ["jsx — falta _plantilla/comprobar_jsx.js, no se pudo comprobar"]
    try:
        r = subprocess.run(["node", str(guion), str(ruta)],
                           capture_output=True, text=True, timeout=180)
    except (FileNotFoundError, subprocess.TimeoutExpired):
        return [], ["jsx — no se pudo ejecutar Node, no se comprobó la sintaxis"]
    salida = (r.stderr or r.stdout).strip()
    if r.returncode == 0:
        return [], []
    if r.returncode == 2:
        return [], [f"jsx — no se pudo comprobar: {salida}"]
    return [f"jsx — {l}" for l in salida.splitlines() if l.strip()], []


def verificar(ruta, hash_base, revisar_cuota=True, con_salidas=False):
    texto = ruta.read_text(encoding="utf-8")
    cuerpo = cuerpo_capitulo(texto)
    desplazamiento = max(texto.find(MARCA_FIN), 0)
    problemas, avisos = [], []

    # 1 · deriva
    core, err = bloque_core(texto, ruta)
    if err:
        problemas.append(err)
    else:
        h = hashlib.sha256(core.encode("utf-8")).hexdigest()
        if h != hash_base:
            problemas.append(
                f"el bloque LP-CORE difiere de lp-base.html\n"
                f"        capítulo {h[:12]}…  base {hash_base[:12]}…\n"
                f"        corrija lp-core-extra.jsx y regenere, no edite el capítulo a mano"
            )

    # 2 · cuota de ejercicios
    conteo = contar_ejercicios(cuerpo)
    if revisar_cuota:
        for tipo, (lo, hi) in CUOTA.items():
            n = conteo[tipo]
            if n < lo:
                destino = problemas if tipo in OBLIGATORIOS else avisos
                destino.append(f"{tipo}: hay {n}, se esperan al menos {lo}")
            elif n > hi:
                avisos.append(f"{tipo}: hay {n}, la cuota sugiere máximo {hi}")

    # 3 · componentes sin definir
    faltantes = componentes_sin_definir(texto, cuerpo)
    if faltantes:
        problemas.append(f"componentes usados pero no definidos: {', '.join(faltantes)}")

    # 4 · CodeTabs completos
    for f in codetabs_incompletos(texto, cuerpo):
        problemas.append(f"CodeTabs incompleto — {f}")

    # 5 · motivación de apertura en cada sección
    for f in secciones_sin_motivacion(cuerpo):
        problemas.append(f"sección sin motivación — {f}")

    # 6 · coherencia de los ejercicios multilingües
    for f in ejercicios_multilingues_mal(texto, cuerpo):
        problemas.append(f"ejercicio multilingüe — {f}")

    # 7 · la salida va dentro del bloque, con el prefijo de su lenguaje
    for f in salida_mal_puesta(cuerpo):
        problemas.append(f"salida — {f}")

    # 8 · el texto del E3 no cita líneas que solo valen en un lenguaje
    for f in textos_de_detectaerror_mal(texto, cuerpo):
        problemas.append(f"texto por lenguaje — {f}")

    # 9 · la salida declarada es la que el código produce (lenta: opt-in)
    if con_salidas:
        p9, a9, _ = ejecutar_salidas.auditar(ruta)
        problemas += [f"salida ejecutada — {f}" for f in p9]
        avisos += [f"salida ejecutada — {f}" for f in a9]

    # 10 · ningún color tenue usado como texto sin confirmar
    for f in contraste_dudoso(texto, cuerpo, desplazamiento):
        avisos.append(f"contraste — {f}")

    # 11 · ningún enunciado pide escribir un programa desde cero
    for f in pide_escribir_programa(texto, cuerpo, desplazamiento):
        problemas.append(f"enunciado — {f}")

    # 12 · ninguna pregunta con varias respuestas correctas es inacertable
    for f in preguntas_imposibles(texto, cuerpo, desplazamiento):
        problemas.append(f"pregunta imposible — {f}")
    for f in etiqueta_multiple_a_mano(texto, cuerpo, desplazamiento):
        avisos.append(f"pregunta — {f}")

    # 14 · la clave no está siempre en la misma letra dentro de un `Quiz`
    for f in clave_siempre_en_el_mismo_sitio(texto, cuerpo, desplazamiento):
        problemas.append(f"clave previsible — {f}")

    # 15 · el bloque JSX compila de verdad
    p15, a15 = jsx_compila(ruta)
    problemas += p15
    avisos += a15

    # 16 · la clave tampoco se concentra en una letra en todo el capítulo
    for f in clave_previsible_en_el_capitulo(texto, cuerpo, desplazamiento):
        problemas.append(f"clave previsible — {f}")

    # 17 · la clave no se delata por ser mucho más larga
    for f in clave_mas_larga(texto, cuerpo, desplazamiento):
        avisos.append(f"clave larga — {f}")

    # 18 · el cuestionario no repite una opción ya vista en el capítulo
    for f in opcion_repetida(texto, cuerpo, desplazamiento):
        avisos.append(f"pregunta repetida — {f}")

    # 19 · el cuestionario cubre todas las secciones (si lo declaran)
    for f in cobertura_del_cuestionario(texto, cuerpo, desplazamiento):
        problemas.append(f"cobertura — {f}")

    total = sum(conteo.values())
    resumen = " ".join(f"{t}:{conteo[t]}" for t in sorted(conteo))
    return problemas, avisos, total, resumen


def main():
    args = [a for a in sys.argv[1:] if not a.startswith("--")]
    revisar_cuota = "--sin-cuota" not in sys.argv
    con_salidas = "--con-salidas" in sys.argv

    if not BASE.exists():
        print(f"{ROJO}ERROR{FIN}: falta {BASE}. Ejecute antes ensamblar.py.", file=sys.stderr)
        return 1

    core_base, err = bloque_core(BASE.read_text(encoding="utf-8"), BASE)
    if err:
        print(f"{ROJO}ERROR{FIN}: {err}", file=sys.stderr)
        return 1
    hash_base = hashlib.sha256(core_base.encode("utf-8")).hexdigest()

    # 13 · la plantilla está al día con sus fuentes. Se comprueba antes que
    # nada: si falla, el hash de referencia es el de una librería vieja y todo
    # lo que venga después mide contra el patrón equivocado.
    desfase = plantilla_desactualizada()
    if desfase:
        print(f"{ROJO}FALLA{FIN} _plantilla/lp-base.html")
        print(f"        {ROJO}✗{FIN} {desfase}")
        return 1

    if args:
        rutas = []
        for a in args:
            p = Path(a)
            rutas.extend(sorted(MATERIAL.glob(a)) if not p.exists() else [p])
    else:
        rutas = sorted(MATERIAL.glob("[0-9][0-9]_LPF_*.html"))

    if not rutas:
        print(f"{AMAR}Sin capítulos que verificar todavía.{FIN}")
        print(f"{GRIS}LP-CORE de referencia: {hash_base[:16]}…{FIN}")
        return 0

    print(f"{GRIS}LP-CORE de referencia: {hash_base[:16]}…{FIN}")
    if not con_salidas:
        print(f"{GRIS}Comprobación 9 omitida — añada --con-salidas para ejecutar el código{FIN}")
    print()
    fallos = 0
    for ruta in rutas:
        problemas, avisos, total, resumen = verificar(ruta, hash_base, revisar_cuota, con_salidas)
        estado = f"{ROJO}FALLA{FIN}" if problemas else (f"{AMAR}AVISO{FIN}" if avisos else f"{VERDE}OK   {FIN}")
        print(f"{estado}  {ruta.name}")
        print(f"        {GRIS}{total} ejercicios · {resumen}{FIN}")
        for p in problemas:
            print(f"        {ROJO}✗{FIN} {p}")
        for a in avisos:
            print(f"        {AMAR}!{FIN} {a}")
        if problemas:
            fallos += 1
        print()

    if fallos:
        print(f"{ROJO}{fallos} de {len(rutas)} capítulos con problemas.{FIN}")
        return 1
    print(f"{VERDE}Los {len(rutas)} capítulos pasan la verificación.{FIN}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
