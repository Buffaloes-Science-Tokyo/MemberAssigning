// HTTP layer for /api/sync, shared by the Vercel function (Neon) and the
// local dev server (PGlite). `withClient(fn)` runs `fn(client)` with a
// ready-to-use client whose schema has been ensured.
import { timingSafeEqual } from 'node:crypto';

import { BadRequestError, ConflictError, readSnapshot, writeSnapshot } from './store.js';

export function syncHandlers(withClient) {
  return {
    GET: (request) => handle(request, withClient, (client) => readSnapshot(client)),
    PUT: (request) =>
      handle(request, withClient, async (client) => {
        const body = await request.json().catch(() => {
          throw new BadRequestError('invalid JSON');
        });
        return { version: await writeSnapshot(client, body ?? {}) };
      }),
  };
}

async function handle(request, withClient, work) {
  const denied = checkAuth(request);
  if (denied) return denied;
  try {
    return json(await withClient(work));
  } catch (e) {
    if (e instanceof ConflictError) return json({ error: 'conflict', version: e.version }, 409);
    if (e instanceof BadRequestError) return json({ error: e.message }, 400);
    console.error(e);
    return json({ error: 'internal error' }, 500);
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
