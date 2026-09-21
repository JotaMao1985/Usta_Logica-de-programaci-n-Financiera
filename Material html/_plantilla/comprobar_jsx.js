#!/usr/bin/env node
/*
 * Comprobación 15 · el bloque JSX del capítulo compila.
 *
 * Existe porque durante la auditoría del capítulo 4 el archivo se rompió DOS
 * veces al editarlo y las dos veces `verificar.py` dio verde:
 *
 *   1. una comilla invertida dentro de un `template literal` —en un comentario
 *      añadido a un bloque de código—, que cerró la cadena antes de tiempo;
 *   2. un comentario JSX puesto como hermano de un `<tr>` dentro del `return`
 *      de un `map`, que son dos elementos sin envoltorio.
 *
 * Ninguna de las dos se ve leyendo el archivo, ninguna la caza una regla de
 * texto, y las dos dejan el capítulo EN BLANCO: Babel no compila nada y el
 * `root` se queda vacío. Se descubrieron al abrirlo en el navegador, que es
 * tarde. Esta comprobación las encuentra en un segundo.
 *
 * Usa @babel/core + @babel/preset-react, el mismo analizador que el navegador
 * carga del CDN. Si no están instalados lo dice y sale con 2, para que quien
 * llama distinga «no se pudo comprobar» de «está mal».
 *
 *   node comprobar_jsx.js <archivo.html>
 *   0 = compila · 1 = error de sintaxis (lo describe) · 2 = falta Babel
 */
'use strict';
const fs = require('fs');
const { execSync } = require('child_process');

const ruta = process.argv[2];
if (!ruta) { console.error('uso: comprobar_jsx.js <archivo.html>'); process.exit(2); }

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

const texto = fs.readFileSync(ruta, 'utf8');
// Cada <script type="text/babel"> se analiza por separado. Lo que va antes se
// sustituye por saltos de línea —no se recorta— para que el número que informe
// Babel sea el del ARCHIVO y no el del fragmento. Comprobado: al romper la
// línea 5090 a propósito, informa la 5090.
const re = /<script\b[^>]*type=["']text\/babel["'][^>]*>([\s\S]*?)<\/script>/g;
let m, bloques = 0, fallos = 0;
while ((m = re.exec(texto)) !== null) {
    bloques++;
    const antes = texto.slice(0, m.index + m[0].indexOf(m[1]));
    const relleno = '\n'.repeat((antes.match(/\n/g) || []).length);
    try {
        babel.transformSync(relleno + m[1], {
            filename: ruta, presets: [preset],
            babelrc: false, configFile: false, compact: true, sourceType: 'script',
        });
    } catch (err) {
        fallos++;
        const donde = err.loc ? `línea ${err.loc.line}, columna ${err.loc.column + 1}` : 'posición desconocida';
        console.error(`${donde}: ${String(err.message).split('\n')[0].replace(/^.*?:\s*/, '')}`);
    }
}
if (bloques === 0) { console.error('no se encontró ningún <script type="text/babel">'); process.exit(2); }
process.exit(fallos ? 1 : 0);
