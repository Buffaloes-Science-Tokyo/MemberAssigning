// Writes <web build dir>/sw.js from scripts/sw.js, with a precache manifest
// of the build's files. Run after `flutter build web`:
//   node scripts/gen-sw.mjs app/build/web
import { createHash } from 'node:crypto';
import { readFile, readdir, rm, writeFile } from 'node:fs/promises';
import { dirname, join, relative, sep } from 'node:path';
import { fileURLToPath } from 'node:url';

const buildDir = process.argv[2] ?? 'app/build/web';

// Only the two CanvasKit builds the default (JS + canvaskit) renderer can
// load: chromium/ on Chrome/Edge/Android, the full one on Safari/Firefox.
const CANVASKIT = new Set([
  'canvaskit/canvaskit.js',
  'canvaskit/canvaskit.wasm',
  'canvaskit/chromium/canvaskit.js',
  'canvaskit/chromium/canvaskit.wasm',
]);

function include(path) {
  if (path.startsWith('canvaskit/')) return CANVASKIT.has(path);
  if (path.endsWith('.symbols')) return false;
  return ![
    'sw.js',
    'flutter_service_worker.js',
    '.last_build_id',
    'assets/NOTICES', // license page only; runtime-cached if opened
  ].includes(path);
}

async function* walk(dir) {
  for (const entry of await readdir(dir, { withFileTypes: true })) {
    const full = join(dir, entry.name);
    if (entry.isDirectory()) yield* walk(full);
    else yield full;
  }
}

const manifest = {};
let bytes = 0;
for await (const file of walk(buildDir)) {
  const path = relative(buildDir, file).split(sep).join('/');
  if (!include(path)) continue;
  const content = await readFile(file);
  manifest[path] = createHash('sha256').update(content).digest('hex').slice(0, 16);
  bytes += content.length;
}
if (!manifest['index.html'] || !manifest['main.dart.js']) {
  throw new Error(`${buildDir} doesn't look like a Flutter web build`);
}

// Flutter's deprecated worker only unregisters itself; nothing loads it.
await rm(join(buildDir, 'flutter_service_worker.js'), { force: true });

const template = await readFile(join(dirname(fileURLToPath(import.meta.url)), 'sw.js'), 'utf8');
const sorted = Object.fromEntries(Object.entries(manifest).sort(([a], [b]) => a.localeCompare(b)));
await writeFile(join(buildDir, 'sw.js'), template.replace('__PRECACHE__', JSON.stringify(sorted, null, 2)));
console.log(`sw.js: precaching ${Object.keys(manifest).length} files (${(bytes / 1e6).toFixed(1)} MB)`);
