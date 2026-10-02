// Local sync server for development: serves /api/sync backed by PGlite
// (embedded Postgres) instead of Neon, so no DATABASE_URL is needed.
//
//   npm run dev                 # data persists in .local-db/
//   npm run dev -- --memory     # throwaway in-memory DB
//
// Env: PORT (default 8787), SYNC_TOKEN (default "dev").
// CORS is open so `flutter run -d chrome` (another port) can call it; point the
// app here with --dart-define=SYNC_SERVER_URL=http://localhost:8787.
import { createServer } from 'node:http';
import { fileURLToPath } from 'node:url';
import { PGlite } from '@electric-sql/pglite';

import { syncHandlers } from '../api/_lib/handler.js';
import { ensureSchema } from '../api/_lib/store.js';

const port = Number(process.env.PORT ?? 8787);
const memory = process.argv.includes('--memory');
const dataDir = fileURLToPath(new URL('../.local-db', import.meta.url));
process.env.SYNC_TOKEN ||= 'dev';

const db = memory ? new PGlite() : new PGlite(dataDir);
await ensureSchema(db);

// PGlite is a single connection, so run requests one at a time to keep each
// request's BEGIN/COMMIT from interleaving with another's.
let queue = Promise.resolve();
const withPgliteClient = (work) => {
  const run = queue.then(() => work(db));
  queue = run.catch(() => {});
  return run;
};

const handlers = syncHandlers(withPgliteClient);

const cors = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, PUT, OPTIONS',
  'Access-Control-Allow-Headers': 'Authorization, Content-Type',
  'Access-Control-Max-Age': '600',
  // The Chrome launch config uses --cross-origin-isolation (COEP).
  'Cross-Origin-Resource-Policy': 'cross-origin',
};

createServer(async (req, res) => {
  const url = new URL(req.url, `http://${req.headers.host}`);
  const started = Date.now();
  let response;
  if (url.pathname !== '/api/sync') {
    response = new Response('not found', { status: 404 });
  } else if (req.method === 'OPTIONS') {
    response = new Response(null, { status: 204 });
  } else if (req.method === 'GET' || req.method === 'PUT') {
    const chunks = [];
    for await (const chunk of req) chunks.push(chunk);
    const request = new Request(url, {
      method: req.method,
      headers: req.headers,
      body: req.method === 'PUT' ? Buffer.concat(chunks) : undefined,
    });
    response = await handlers[req.method](request);
  } else {
    response = new Response('method not allowed', { status: 405 });
  }

  res.writeHead(response.status, { ...Object.fromEntries(response.headers), ...cors });
  res.end(Buffer.from(await response.arrayBuffer()));
  if (req.method !== 'OPTIONS') {
    console.log(`${req.method} ${url.pathname} ${response.status} ${Date.now() - started}ms`);
  }
}).listen(port, () => {
  console.log(`Local sync server: http://localhost:${port}/api/sync`);
  console.log(`  DB: ${memory ? 'in-memory' : '.local-db/'}   Sync key: ${process.env.SYNC_TOKEN}`);
});
