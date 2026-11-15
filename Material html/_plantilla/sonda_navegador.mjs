#!/usr/bin/env node
/*
 * Lo que el panel de vista previa no puede medir, medido en un Chrome sin ventana.
 *
 *     node _plantilla/sonda_navegador.mjs [modo] [capítulos…]
 *
 * Abre cada capítulo como `file://` —perfil nuevo y sin banderas que cambien la
 * seguridad de `file://`, que es lo que hace un doble clic— y recorre todas sus
 * lecciones con «Siguiente». Los modos:
 *
 *   file          (por omisión) monta, recorre, guarda en localStorage y no da
 *                 errores de JavaScript.
 *   320           lo mismo que 375, a 320 px: Safari de iPhone con la página
 *                 ampliada dibuja a ese ancho (comprobado el 2026-11-15 en un
 *                 iPhone 15 Pro: el sitio publicado tenía el zoom de página
 *                 cerca del 125 % y coincidía línea por línea).
 *   375           además, a 375 px de ancho desde la carga (con la barra lateral
 *                 cerrada), nada se sale del viewport sin un contenedor con
 *                 `overflow-x: auto|scroll`. Recortar con `overflow-x: hidden`
 *                 solo se admite dentro de un bloque de código plegado, que el
 *                 estudiante despliega: se cuenta aparte. Cualquier otro
 *                 recorte esconde contenido y falla. Antes de medir, una prueba
 *                 negativa: un div de 600 px tiene que salir. Y el botón
 *                 del menú no queda encima de lo que se desplaza: vive sobre
 *                 `#barra-movil`, que no se desplaza y lleva «Lección N de M»
 *                 (hasta el 2026-11-15 flotaba sobre el texto y tapaba las
 *                 primeras letras de la línea que pasaba debajo); su prueba
 *                 negativa: sin la barra, tiene que tocar el contenido.
 *   sin-almacen   `localStorage` lanza `SecurityError`, como en una ventana
 *                 privada o con el almacenamiento bloqueado (H16 del capítulo 5).
 *   sin-cdnjs     cdnjs no resuelve: el capítulo carga sin color en el código.
 *   sin-tailwind  cdn.tailwindcss.com no resuelve, como en un iPhone el
 *                 2026-11-03: Tailwind tiene que llegar de la copia de
 *                 `_vendor/`, que el `head` carga cuando el CDN no responde.
 *
 * En todos los modos se exige además que Tailwind haya aplicado sus estilos:
 * sin ellos el capítulo monta, recorre y no da errores, pero la barra lateral
 * no se esconde y nada tiene su sitio. Antes de esta comprobación, un capítulo
 * sin estilos pasaba la sonda.
 *
 * Por qué hace falta: en el panel de vista previa `requestAnimationFrame` no
 * corre y `ResizeObserver` no notifica (se midió el 2026-10-27), las
 * animaciones quedan congeladas, y un `file://` se abre como URL `data:` sin
 * almacenamiento. Aquí el renderizado es el de verdad.
 *
 * Necesita Google Chrome en la ruta de macOS y Node 22 o más (WebSocket global).
 * Devuelve 0 si todo pasa, 1 si algo falla y 2 si no pudo arrancar Chrome.
 */
import { spawn } from 'node:child_process';
import { mkdtempSync, rmSync, existsSync, readdirSync } from 'node:fs';
import { tmpdir } from 'node:os';
import { join, resolve, dirname } from 'node:path';
import { pathToFileURL, fileURLToPath } from 'node:url';

const CHROME = '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome';
const MODOS = new Set(['file', '375', '320', 'sin-almacen', 'sin-cdnjs', 'sin-tailwind']);
// El host que cada modo deja sin resolver, y que por eso no cuenta como error.
const SIN_HOST = { 'sin-cdnjs': 'cdnjs.cloudflare.com', 'sin-tailwind': 'cdn.tailwindcss.com' };
const espera = ms => new Promise(r => setTimeout(r, ms));

const args = process.argv.slice(2);
const modo = MODOS.has(args[0]) ? args.shift() : 'file';
// Los modos numéricos son un ancho de pantalla en px. 320 es un iPhone con la
// página ampliada en Safari: así la veía el teléfono del docente.
const ancho = /^\d+$/.test(modo) ? Number(modo) : 0;
const desconocidas = args.filter(a => a.startsWith('--'));
if (desconocidas.length) { console.error(`opción desconocida: ${desconocidas.join(', ')}`); process.exit(2); }
const MATERIAL = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const rutas = args.length ? args.map(a => resolve(a))
    : readdirSync(MATERIAL).filter(f => /^\d\d_LPF_.*\.html$/.test(f)).sort().map(f => join(MATERIAL, f));
// Un número suelto («02») no es una ruta: sin esta comprobación Chrome carga una
// página de error y la sonda dice «no montó», que parece un fallo del capítulo.
const inexistentes = rutas.filter(r => !existsSync(r));
if (inexistentes.length) { console.error(`no existe: ${inexistentes.join(', ')} — se pasa el nombre del archivo, p. ej. 02_LPF_Algoritmos.html`); process.exit(2); }
if (!existsSync(CHROME)) { console.error(`no está Chrome en ${CHROME}`); process.exit(2); }

// Un puerto por proceso: si una ejecución anterior murió sin cerrar su Chrome,
// ese Chrome sigue ocupando su puerto, y conectarse a él daría medidas de otra
// página sin ningún error.
const puerto = 9400 + (process.pid % 500);
const perfil = mkdtempSync(join(tmpdir(), 'lpf-sonda-'));
const chrome = spawn(CHROME, [
    '--headless=new', `--remote-debugging-port=${puerto}`, `--user-data-dir=${perfil}`,
    '--no-first-run', '--no-default-browser-check', '--window-size=1280,900',
    ...(SIN_HOST[modo] ? [`--host-resolver-rules=MAP ${SIN_HOST[modo]} ~NOTFOUND`] : []),
    'about:blank',
], { stdio: 'ignore' });
const cerrar = async () => { try { chrome.kill(); } catch { } await espera(300); rmSync(perfil, { recursive: true, force: true }); };
process.on('SIGINT', async () => { await cerrar(); process.exit(130); });

let ws;
for (let i = 0; i < 50 && !ws; i++) {
    try {
        const l = await (await fetch(`http://127.0.0.1:${puerto}/json/list`)).json();
        const url = l.find(t => t.type === 'page')?.webSocketDebuggerUrl;
        if (url) ws = new WebSocket(url);
    } catch { }
    if (!ws) await espera(200);
}
if (!ws) { console.error('Chrome no abrió su puerto de depuración'); await cerrar(); process.exit(2); }
await new Promise(r => ws.addEventListener('open', r, { once: true }));
let id = 0;
const pendientes = new Map(), eventos = [];
ws.addEventListener('message', ev => {
    const m = JSON.parse(ev.data);
    if (m.id && pendientes.has(m.id)) { pendientes.get(m.id)(m); pendientes.delete(m.id); } else if (m.method) eventos.push(m);
});
const cdp = (method, params = {}) => new Promise(r => { const n = ++id; pendientes.set(n, r); ws.send(JSON.stringify({ id: n, method, params })); });
const evaluar = async expr => {
    const r = await cdp('Runtime.evaluate', { expression: expr, returnByValue: true, awaitPromise: true });
    if (r.result?.exceptionDetails) throw new Error(JSON.stringify(r.result.exceptionDetails).slice(0, 300));
    return r.result?.result?.value;
};
await cdp('Runtime.enable'); await cdp('Log.enable'); await cdp('Page.enable');
if (modo === 'sin-almacen') {
    await cdp('Page.addScriptToEvaluateOnNewDocument', { source:
        `Object.defineProperty(window, 'localStorage', { configurable: true, get() { throw new DOMException('almacenamiento bloqueado', 'SecurityError'); } });` });
}
if (ancho) await cdp('Emulation.setDeviceMetricsOverride', { width: ancho, height: ancho === 320 ? 693 : 812, deviceScaleFactor: 1, mobile: true });

// Mide desde el panel de la lección, que es el padre de `.max-w-4xl`: subir más
// allá encontraría su propio `overflow-y-auto` y daría todo por contenido.
const MEDIR = `(() => {
    const vw = document.documentElement.clientWidth;
    const panel = document.querySelector('.max-w-4xl').parentElement;
    const fuera = []; let recortados = 0;
    for (const el of panel.querySelectorAll('*')) {
        const r = el.getBoundingClientRect();
        if (!r.width || !r.height || (r.right <= vw + 0.5 && r.left >= -0.5)) continue;
        let a = el.parentElement, contenido = false, recorta = false;
        while (a && a !== panel) {
            const ox = getComputedStyle(a).overflowX;
            if (ox === 'auto' || ox === 'scroll') { contenido = true; break; }
            if (ox === 'hidden' || ox === 'clip') recorta = true;
            a = a.parentElement;
        }
        if (contenido) continue;
        // Recortar solo se admite en un bloque de código plegado, que se despliega.
        if (recorta && el.closest('.plegado')) recortados++;
        else if (recorta) fuera.push('recortado fuera de un bloque plegado: ' + el.tagName.toLowerCase() + '.' + String(el.className).slice(0, 40));
        else fuera.push(el.tagName.toLowerCase() + '.' + String(el.className).slice(0, 40) + ' hasta ' + Math.round(r.right) + ' px');
    }
    return { vw, sw: document.documentElement.scrollWidth, fuera, recortados };
})()`;
// El botón del menú no puede quedar encima de lo que se desplaza: taparía la
// línea que pase por debajo. Por debajo de `lg` vive sobre `#barra-movil`, que
// no se desplaza; si su rectángulo toca el de `#contenido-scroll`, tapa texto.
// La barra, además, tiene que traer «Lección N de M» a la derecha del botón.
const TAPA = `(() => {
    const toca = (a, b) => a.left < b.right && b.left < a.right && a.top < b.bottom && b.top < a.bottom;
    const menu = document.querySelector('button[aria-label$="menú"]').getBoundingClientRect();
    const mal = [];
    if (toca(menu, document.getElementById('contenido-scroll').getBoundingClientRect())) mal.push('el contenido que se desplaza');
    const rotulo = document.querySelector('#barra-movil span');
    if (!rotulo || !rotulo.getBoundingClientRect().width) mal.push('(falta «Lección N de M» en la barra)');
    else if (toca(menu, rotulo.getBoundingClientRect())) mal.push(rotulo.innerText.trim().slice(0, 24));
    return mal;
})()`;
// Palabras pegadas. JSX borra el salto de línea entre un texto y una etiqueta:
//     …la Ley 1266 de 2008 llama
//     <strong>operador de información</strong>
// se pinta «llamaoperador de información». No es un error de JavaScript ni se
// sale de nada: solo se ve leyendo (visto en un iPhone el 2026-11-15). Se mide
// en el DOM: una etiqueta en línea cuyo texto empieza o termina en letra o
// cifra, pegada a un texto vecino que también. `sinAire` son las que además
// no tienen relleno ni margen de ese lado y se ven pegadas; las otras (el
// código en línea, que trae su relleno) se ven separadas, pero se copian y se
// leen en voz alta pegadas, y cuentan igual. `data-pegado-ok` lo calla.
const PEGADAS = `(() => {
    const panel = document.querySelector('.max-w-4xl');
    const L = /[\\p{L}\\p{N}]/u, out = [];
    for (const el of panel.querySelectorAll('strong, em, a, b, i, span, code, button, sup, sub')) {
        if (el.closest('pre, svg, select, textarea, mjx-container, .katex, [data-pegado-ok]')) continue;
        if (!getComputedStyle(el).display.startsWith('inline')) continue;
        const txt = el.textContent;
        if (!txt.trim() || el.tagName === 'SUP' || el.tagName === 'SUB') continue;
        const cs = getComputedStyle(el);
        const a = el.previousSibling, d = el.nextSibling;
        if (a && a.nodeType === 3 && L.test(a.textContent.slice(-1)) && L.test(txt[0]))
            out.push({ t: a.textContent.slice(-18) + '▌' + txt.slice(0, 18), sinAire: parseFloat(cs.paddingLeft) + parseFloat(cs.marginLeft) < 2 });
        if (d && d.nodeType === 3 && L.test(d.textContent[0]) && L.test(txt.slice(-1)))
            out.push({ t: txt.slice(-18) + '▌' + d.textContent.slice(0, 18), sinAire: parseFloat(cs.paddingRight) + parseFloat(cs.marginRight) < 2 });
    }
    return out;
})()`;
const LECCION = `(() => { const m = document.body.innerText.match(/lección (\\d+) de (\\d+)/i); return m ? [Number(m[1]), Number(m[2])] : [0, 0]; })()`;
const SIGUIENTE = `(() => { const b = [...document.querySelectorAll('button')].find(b => /^\\s*Siguiente/i.test(b.innerText) && !b.disabled); if (b) b.click(); return !!b; })()`;
// Tailwind aplicado: `max-w-4xl` solo tiene ancho máximo si Tailwind generó su regla.
const ESTILOS = `(() => { const e = document.querySelector('.max-w-4xl'); return !!window.tailwind && !!e && getComputedStyle(e).maxWidth !== 'none'; })()`;

let fallos = 0;
for (const ruta of rutas) {
    eventos.length = 0;
    const nombre = ruta.split('/').pop();
    await cdp('Page.navigate', { url: pathToFileURL(ruta).href });
    let montado = false;
    for (let i = 0; i < 120 && !montado; i++) {
        await espera(250);
        montado = await evaluar(`!!document.querySelector('#root') && document.querySelector('#root').innerText.length > 200`).catch(() => false);
    }
    if (!montado) { console.log(`✗ ${nombre}: no montó`); fallos++; continue; }
    if (ancho && ruta === rutas[0]) {
        const n = await evaluar(`(() => { const d = document.createElement('div'); d.style.cssText = 'width:600px;height:10px';
            document.querySelector('.max-w-4xl').appendChild(d); const r = ${MEDIR}; d.remove(); return r.fuera.length; })()`);
        if (!n) { console.log('✗ la prueba negativa no detectó un div de 600 px: la medida no sirve'); await cerrar(); process.exit(1); }
        const t = await evaluar(`(() => { const b = document.getElementById('barra-movil'); b.style.display = 'none';
            const t = ${TAPA}; b.style.display = ''; return t.length; })()`);
        if (!t) { console.log('✗ la prueba negativa no vio el botón del menú sobre el contenido al quitar la barra: la medida no sirve'); await cerrar(); process.exit(1); }
    }
    const lecciones = [], pegadas = [];
    let total = 0, leccionesMal = 0;
    for (let k = 0; k < 20; k++) {
        await espera(900);
        const [n, t] = await evaluar(LECCION);
        total = t;
        for (const x of await evaluar(PEGADAS)) pegadas.push(`lección ${n}: «${x.t}»${x.sinAire ? '' : ' (código en línea)'}`);
        if (ancho) {
            const m = await evaluar(MEDIR);
            const tapa = await evaluar(TAPA);
            const bien = m.sw === m.vw && !m.fuera.length && !tapa.length;
            if (!bien) leccionesMal++;
            const mal = [...m.fuera.slice(0, 2), ...(tapa.length ? [`el botón del menú tapa «${tapa.join('», «')}»`] : [])];
            lecciones.push(bien ? `${n}${m.recortados ? `(${m.recortados} recortados)` : ''}` : `${n}: ✗ ${mal.join(' | ')}`);
        } else lecciones.push(String(n));
        if (n === t || !(await evaluar(SIGUIENTE))) break;
    }
    const errores = eventos.filter(e => e.method === 'Runtime.exceptionThrown' ||
        (e.method === 'Runtime.consoleAPICalled' && e.params.type === 'error') ||
        (e.method === 'Log.entryAdded' && e.params.entry.level === 'error' && !(SIN_HOST[modo] && (e.params.entry.url || '').includes(SIN_HOST[modo]))));
    const guardado = modo === 'sin-almacen' ? 'sin almacenamiento'
        : await evaluar(`(() => { try { return Object.keys(localStorage).filter(k => k.startsWith('lpf_')).length + ' claves lpf_'; } catch (e) { return 'error: ' + e.message; } })()`);
    const recorrio = lecciones.length === total;
    const conEstilos = await evaluar(ESTILOS);
    // Una lección que falla a 375 px marca también la línea del capítulo:
    // antes del 2026-11-03 la sonda salía con 1 y la línea decía ✓.
    const mal = errores.length || !recorrio || !conEstilos || leccionesMal || pegadas.length;
    if (mal) fallos++;
    console.log(`${mal ? '✗' : '✓'} ${nombre}: ${lecciones.length} de ${total} lecciones · ${guardado} · ${conEstilos ? 'con Tailwind' : 'SIN Tailwind'} · errores de JS: ${errores.length}`);
    if (ancho) console.log(`    ${lecciones.join(' · ')}`);
    if (pegadas.length) console.log(`    ✗ ${pegadas.length} palabras pegadas (falta un espacio entre el texto y la etiqueta):`);
    for (const x of pegadas.slice(0, process.env.LPF_TODAS ? 999 : 6)) console.log(`      ${x}`);
    for (const e of errores.slice(0, 3)) {
        const t = e.method === 'Runtime.exceptionThrown' ? (e.params.exceptionDetails.exception?.description || e.params.exceptionDetails.text)
            : e.method === 'Log.entryAdded' ? `${e.params.entry.text} ${e.params.entry.url || ''}` : e.params.args.map(a => a.value ?? a.description).join(' ');
        console.log(`    ✗ ${String(t).slice(0, 220)}`);
    }
}
ws.close();
await cerrar();
process.exit(fallos ? 1 : 0);
