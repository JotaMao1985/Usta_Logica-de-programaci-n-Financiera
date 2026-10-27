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
 *   375           además, a 375 px de ancho desde la carga (con la barra lateral
 *                 cerrada), nada se sale del viewport sin un contenedor con
 *                 `overflow-x: auto|scroll`. Recortar con `overflow-x: hidden`
 *                 solo se admite dentro de un bloque de código plegado, que el
 *                 estudiante despliega: se cuenta aparte. Cualquier otro
 *                 recorte esconde contenido y falla. Antes de medir, una prueba
 *                 negativa: un div de 600 px tiene que salir.
 *   sin-almacen   `localStorage` lanza `SecurityError`, como en una ventana
 *                 privada o con el almacenamiento bloqueado (H16 del capítulo 5).
 *   sin-cdnjs     cdnjs no resuelve: el capítulo carga sin color en el código.
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
const MODOS = new Set(['file', '375', 'sin-almacen', 'sin-cdnjs']);
const espera = ms => new Promise(r => setTimeout(r, ms));

const args = process.argv.slice(2);
const modo = MODOS.has(args[0]) ? args.shift() : 'file';
const desconocidas = args.filter(a => a.startsWith('--'));
if (desconocidas.length) { console.error(`opción desconocida: ${desconocidas.join(', ')}`); process.exit(2); }
const MATERIAL = resolve(dirname(fileURLToPath(import.meta.url)), '..');
const rutas = args.length ? args.map(a => resolve(a))
    : readdirSync(MATERIAL).filter(f => /^\d\d_LPF_.*\.html$/.test(f)).sort().map(f => join(MATERIAL, f));
if (!existsSync(CHROME)) { console.error(`no está Chrome en ${CHROME}`); process.exit(2); }

// Un puerto por proceso: si una ejecución anterior murió sin cerrar su Chrome,
// ese Chrome sigue ocupando su puerto, y conectarse a él daría medidas de otra
// página sin ningún error.
const puerto = 9400 + (process.pid % 500);
const perfil = mkdtempSync(join(tmpdir(), 'lpf-sonda-'));
const chrome = spawn(CHROME, [
    '--headless=new', `--remote-debugging-port=${puerto}`, `--user-data-dir=${perfil}`,
    '--no-first-run', '--no-default-browser-check', '--window-size=1280,900',
    ...(modo === 'sin-cdnjs' ? ['--host-resolver-rules=MAP cdnjs.cloudflare.com ~NOTFOUND'] : []),
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
if (modo === '375') await cdp('Emulation.setDeviceMetricsOverride', { width: 375, height: 812, deviceScaleFactor: 1, mobile: true });

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
const LECCION = `(() => { const m = document.body.innerText.match(/lección (\\d+) de (\\d+)/i); return m ? [Number(m[1]), Number(m[2])] : [0, 0]; })()`;
const SIGUIENTE = `(() => { const b = [...document.querySelectorAll('button')].find(b => /^\\s*Siguiente/i.test(b.innerText) && !b.disabled); if (b) b.click(); return !!b; })()`;

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
    if (modo === '375' && ruta === rutas[0]) {
        const n = await evaluar(`(() => { const d = document.createElement('div'); d.style.cssText = 'width:600px;height:10px';
            document.querySelector('.max-w-4xl').appendChild(d); const r = ${MEDIR}; d.remove(); return r.fuera.length; })()`);
        if (!n) { console.log('✗ la prueba negativa no detectó un div de 600 px: la medida no sirve'); await cerrar(); process.exit(1); }
    }
    const lecciones = [];
    let total = 0;
    for (let k = 0; k < 20; k++) {
        await espera(900);
        const [n, t] = await evaluar(LECCION);
        total = t;
        if (modo === '375') {
            const m = await evaluar(MEDIR);
            const bien = m.sw === m.vw && !m.fuera.length;
            if (!bien) fallos++;
            lecciones.push(bien ? `${n}${m.recortados ? `(${m.recortados} recortados)` : ''}` : `${n}: ✗ ${m.fuera.slice(0, 2).join(' | ')}`);
        } else lecciones.push(String(n));
        if (n === t || !(await evaluar(SIGUIENTE))) break;
    }
    const errores = eventos.filter(e => e.method === 'Runtime.exceptionThrown' ||
        (e.method === 'Runtime.consoleAPICalled' && e.params.type === 'error') ||
        (e.method === 'Log.entryAdded' && e.params.entry.level === 'error' && !(modo === 'sin-cdnjs' && /cdnjs/.test(e.params.entry.url || ''))));
    const guardado = modo === 'sin-almacen' ? 'sin almacenamiento'
        : await evaluar(`(() => { try { return Object.keys(localStorage).filter(k => k.startsWith('lpf_')).length + ' claves lpf_'; } catch (e) { return 'error: ' + e.message; } })()`);
    const recorrio = lecciones.length === total;
    if (errores.length || !recorrio) fallos++;
    console.log(`${errores.length || !recorrio ? '✗' : '✓'} ${nombre}: ${lecciones.length} de ${total} lecciones · ${guardado} · errores de JS: ${errores.length}`);
    if (modo === '375') console.log(`    ${lecciones.join(' · ')}`);
    for (const e of errores.slice(0, 3)) {
        const t = e.method === 'Runtime.exceptionThrown' ? (e.params.exceptionDetails.exception?.description || e.params.exceptionDetails.text)
            : e.method === 'Log.entryAdded' ? `${e.params.entry.text} ${e.params.entry.url || ''}` : e.params.args.map(a => a.value ?? a.description).join(' ');
        console.log(`    ✗ ${String(t).slice(0, 220)}`);
    }
}
ws.close();
await cerrar();
process.exit(fallos ? 1 : 0);
