// GET  /api/sync  -> { version, schemaVersion, updatedAt, data }
// PUT  /api/sync  { baseVersion, schemaVersion, data } -> { version }
//                 409 { version } if someone else synced since baseVersion.
//
// Both require `Authorization: Bearer <SYNC_TOKEN>`.
// Env: DATABASE_URL (Neon connection string), SYNC_TOKEN.
import { timingSafeEqual } from 'node:crypto';
import { Pool, neonConfig } from '@neondatabase/serverless';
import ws from 'ws';

import { BadRequestError, ConflictError, ensureSchema, readSnapshot, writeSnapshot } from './_lib/store.js';

neonConfig.webSocketConstructor = ws;

let schemaReady = null;

export async function GET(request) {
  return handle(request, (client) => readSnapshot(client));
}

export async function PUT(request) {
  return handle(request, async (client) => {
    const body = await request.json().catch(() => {
      throw new BadRequestError('invalid JSON');
    });
    return { version: await writeSnapshot(client, body ?? {}) };
  });
}

async function handle(request, work) {
  const denied = checkAuth(request);
  if (denied) return denied;

  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
  let client;
  try {
    client = await pool.connect();
    schemaReady ??= ensureSchema(client).catch((e) => {
      schemaReady = null;
      throw e;
    });
    await schemaReady;
    return json(await work(client));
  } catch (e) {
    if (e instanceof ConflictError) return json({ error: 'conflict', version: e.version }, 409);
    if (e instanceof BadRequestError) return json({ error: e.message }, 400);
    console.error(e);
    return json({ error: 'internal error' }, 500);
  } finally {
    client?.release();
    await pool.end();
  }
}

function checkAuth(request) {
  const expected = process.env.SYNC_TOKEN;
  if (!expected) return json({ error: 'SYNC_TOKEN is not configured on the server' }, 500);
  const header = request.headers.get('authorization') ?? '';
  const given = header.startsWith('Bearer ') ? header.slice(7) : '';
  const a = Buffer.from(given);
  const b = Buffer.from(expected);
  if (a.length !== b.length || !timingSafeEqual(a, b)) return json({ error: 'unauthorized' }, 401);
  return null;
}

function json(body, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json; charset=utf-8', 'Cache-Control': 'no-store' },
  });
}
