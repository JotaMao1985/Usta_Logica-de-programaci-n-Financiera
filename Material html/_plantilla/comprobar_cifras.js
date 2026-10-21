#!/usr/bin/env node
/*
 * Comprobación 20 · ninguna cifra de la prosa se puede partir entre renglones.
 *
 * El material escribe los miles con un espacio («1 150 000»), y el navegador
 * puede cortar una línea en cualquier espacio normal. En la tabla del acuerdo
 * de pago del capítulo 5, una celda angosta mostró «1 150» en un renglón y
 * «000» en el siguiente (H19 del plan del capítulo 5). En prosa pasa lo mismo
 * al final de un renglón, solo que menos a la vista. Ningún capítulo tenía un
 * solo espacio duro.
 *
 * Lo que se busca: el separador de miles («1 150 000», «−916 799,93»), el
 * espacio entre la cifra y el % («1,8 %») y los dos del producto de la
 * notación científica («7,5 × 10⁻⁸»). Los tres se cambian por un espacio duro
 * (U+00A0), que mide lo mismo que el que había: la página se ve igual, y solo
 * cambia que ahí ya no se puede partir el renglón. Se probó antes el espacio
 * fino duro (U+202F), que es el que piden la RAE y el SI para agrupar cifras,
 * pero Montserrat lo dibuja de 0,14 em, y «20 000 000» se leía «20000000».
 *
 * Solo en la prosa. El código no se toca: se ve en un `pre` que no parte
 * renglones, y el estudiante lo copia a su editor, donde un espacio duro en un
 * comentario sobra y en una línea de código es un error de sintaxis. Por eso
 * se usa el mismo analizador del navegador (Babel), y no expresiones sobre el
 * texto: hay que saber qué es código y qué no. Queda fuera
 *
 *   · lo que cuelga de una propiedad `pseudo`, `python`, `r` o `vba` cuyo valor
 *     es una plantilla literal o un arreglo: los bloques de `CodeTabs` y las
 *     líneas de `DetectaError`;
 *   · toda plantilla literal, y los atributos SVG (`viewBox="0 0 700 180"`
 *     parece una cifra y no lo es);
 *   · lo que está dentro de un `inline-code`, `code`, `pre` o `kbd`;
 *   · el % seguido de un número, que es el operador de módulo: «17 % 5»;
 *   · la librería LP-CORE, que se estampa y no se edita a mano;
 *   · los comentarios, que Babel ni siquiera entrega como nodos.
 *
 *   node comprobar_cifras.js <archivo.html>…              informa
 *   node comprobar_cifras.js --corregir <archivo.html>…   cambia los espacios
 *
 *   0 = nada que partir (o corregido) · 1 = hay cifras partibles · 2 = falta Babel
 */
'use strict';
const fs = require('fs');
const { execSync } = require('child_process');

const args = process.argv.slice(2);
const corregir = args.includes('--corregir');
const rutas = args.filter(a => !a.startsWith('--'));
if (!rutas.length) { console.error('uso: comprobar_cifras.js [--corregir] <archivo.html>…'); process.exit(2); }

let babel, preset;
try {
    const raiz = execSync('npm root -g', { encoding: 'utf8', stdio: ['ignore', 'pipe', 'ignore'] }).trim();
    babel = require(raiz + '/@babel/core');
    preset = raiz + '/@babel/preset-react';
    require.resolve(preset);
} catch (e) {
    console.error('SIN-BABEL: falta @babel/core o @babel/preset-react. Instale con:  npm i -g @babel/core @babel/preset-react');
    process.exit(2);
}

const DURO = '\u00A0';
const MARCA_FIN = '/* === LP-CORE FIN === */';
const LENGUAJES = new Set(['pseudo', 'python', 'r', 'vba']);
const ATRIBUTOS_SVG = new Set(['viewBox', 'points', 'd', 'transform', 'className', 'style', 'id', 'key',
    'href', 'src', 'fill', 'stroke', 'x', 'y', 'x1', 'x2', 'y1', 'y2', 'cx', 'cy', 'r', 'rx', 'ry',
    'width', 'height', 'dx', 'dy', 'strokeDasharray', 'strokeWidth', 'textAnchor', 'fontSize', 'offset']);
const ETIQUETAS_CODIGO = new Set(['code', 'pre', 'kbd']);
const SUPER = '⁻⁰¹²³⁴⁵⁶⁷⁸⁹';

// Cada patrón devuelve los tramos [desde, hasta) de espacio que hay que
// cambiar, y por qué carácter. `blanco` es el espacio que se tolera: en un
// texto JSX, un salto de línea con su sangría se lee como un espacio.
function tramos(s, blanco) {
    const fuera = [];
    const B = blanco;
    // Los grupos ya unidos con un espacio duro cuentan como parte de la cifra:
    // en \u00AB1 150 000\u00BB a medio arreglar, el espacio que queda tambi\u00E9n sale.
    const grupo = new RegExp(`(?<!\\d)\\d{1,3}((?:(?:${B}|${DURO}|\u202F)\\d{3})+)(?!\\d)`, 'g');
    let m;
    while ((m = grupo.exec(s)) !== null) {
        const sep = new RegExp(B, 'g');
        let k, base = m.index + m[0].length - m[1].length;
        while ((k = sep.exec(m[1])) !== null) fuera.push([base + k.index, base + k.index + k[0].length, DURO]);
    }
    const pct = new RegExp(`\\d(${B})%(?![ ${DURO}]*\\d)`, 'g');
    while ((m = pct.exec(s)) !== null) fuera.push([m.index + 1, m.index + 1 + m[1].length, DURO]);
    const sci = new RegExp(`\\d(${B})×(${B})10(?=[${SUPER}]|$)`, 'g');
    while ((m = sci.exec(s)) !== null) {
        const a = m.index + 1;
        fuera.push([a, a + m[1].length, DURO]);
        const b = a + m[1].length + 1;
        fuera.push([b, b + m[2].length, DURO]);
    }
    return fuera;
}

function nombreAtributo(n) { return n && n.name ? (n.name.name || n.name) : null; }

function esCodigoJSX(el) {
    const ab = el.openingElement;
    if (!ab || ab.name.type !== 'JSXIdentifier') return false;
    if (ETIQUETAS_CODIGO.has(ab.name.name)) return true;
    return ab.attributes.some(a => a.type === 'JSXAttribute' && nombreAtributo(a) === 'className' &&
        a.value && a.value.type === 'StringLiteral' && /\binline-code\b/.test(a.value.value));
}

function analizar(ruta) {
    const texto = fs.readFileSync(ruta, 'utf8');
    const finCore = texto.indexOf(MARCA_FIN);
    const cambios = [];
    const re = /<script\b[^>]*type=["']text\/babel["'][^>]*>([\s\S]*?)<\/script>/g;
    let m;
    while ((m = re.exec(texto)) !== null) {
        const base = m.index + m[0].indexOf(m[1]);
        const ast = babel.parseSync(m[1], { presets: [preset], babelrc: false, configFile: false, sourceType: 'script' });

        const visitar = (nodo, padres) => {
            if (!nodo || typeof nodo.type !== 'string') return;
            if (nodo.type === 'TemplateLiteral') return;
            if (nodo.type === 'JSXElement' && esCodigoJSX(nodo)) return;
            if (nodo.type === 'JSXAttribute' && ATRIBUTOS_SVG.has(nombreAtributo(nodo))) return;
            if (nodo.type === 'ObjectProperty' && nodo.key && LENGUAJES.has(nodo.key.name || nodo.key.value) &&
                (nodo.value.type === 'TemplateLiteral' || nodo.value.type === 'ArrayExpression')) return;

            const ini = base + nodo.start;
            if (ini > finCore && (nodo.type === 'JSXText' || nodo.type === 'StringLiteral')) {
                const crudo = texto.slice(ini, base + nodo.end);
                const blanco = nodo.type === 'JSXText' ? '(?: |\\s*\\n\\s*)' : ' ';
                for (const [a, b, c] of tramos(crudo, blanco)) cambios.push([ini + a, ini + b, c]);

                // «{tasa} % mensual» y «… + ' %'»: el número lo pone una expresión.
                const padre = padres[padres.length - 1];
                if (/^ %/.test(crudo) && nodo.type === 'JSXText' && padre && padre.children) {
                    const i = padre.children.indexOf(nodo);
                    if (i > 0 && padre.children[i - 1].type === 'JSXExpressionContainer') cambios.push([ini, ini + 1, DURO]);
                }
                if (nodo.type === 'StringLiteral' && /^[' "] %/.test(crudo) && padre &&
                    padre.type === 'BinaryExpression' && padre.operator === '+' && padre.right === nodo) {
                    cambios.push([ini + 1, ini + 2, DURO]);
                }
                // «7,5 × 10<sup>−8</sup>»: el exponente es un elemento aparte, y
                // a veces la mantisa también ({m} × 10<sup>…</sup>).
                if (nodo.type === 'JSXText' && padre && padre.children) {
                    const i = padre.children.indexOf(nodo);
                    const sig = padre.children[i + 1];
                    if (sig && sig.type === 'JSXElement' && sig.openingElement.name.name === 'sup') {
                        const s = /(\d|^) × 10$/.exec(crudo);
                        if (s) {
                            const a = ini + s.index + s[1].length;
                            cambios.push([a, a + 1, DURO], [a + 2, a + 3, DURO]);
                        }
                    }
                }
            }
            for (const clave of Object.keys(nodo)) {
                if (clave === 'loc' || /Comments$/.test(clave)) continue;
                const v = nodo[clave];
                if (Array.isArray(v)) v.forEach(h => visitar(h, padres.concat([nodo])));
                else if (v && typeof v.type === 'string') visitar(v, padres.concat([nodo]));
            }
        };
        visitar(ast.program, []);
    }
    // Sin duplicados (dos patrones pueden marcar el mismo espacio).
    const vistos = new Set();
    return {
        texto,
        cambios: cambios.filter(([a]) => !vistos.has(a) && vistos.add(a)).sort((x, y) => x[0] - y[0]),
    };
}

function lineaDe(texto, pos) { return texto.slice(0, pos).split('\n').length; }

let hallados = 0;
for (const ruta of rutas) {
    const { texto, cambios } = analizar(ruta);
    if (!cambios.length) continue;
    if (corregir) {
        let nuevo = '', desde = 0;
        for (const [a, b, c] of cambios) { nuevo += texto.slice(desde, a) + c; desde = b; }
        nuevo += texto.slice(desde);
        fs.writeFileSync(ruta, nuevo);
        console.log(`${ruta.split('/').pop()}: ${cambios.length} espacios cambiados`);
        continue;
    }
    hallados += cambios.length;
    for (const [a, b] of cambios) {
        const ctx = texto.slice(Math.max(0, a - 22), b + 12).replace(/\s+/g, ' ');
        console.log(`${ruta.split('/').pop()}:${lineaDe(texto, a)}: «…${ctx}…»`);
    }
}
process.exit(!corregir && hallados ? 1 : 0);
