// GET  /api/sync  -> { version, schemaVersion, updatedAt, data }
// PUT  /api/sync  { baseVersion, schemaVersion, data } -> { version }
//                 409 { version } if someone else synced since baseVersion.
//
// Both require `Authorization: Bearer <SYNC_TOKEN>`.
// Env: DATABASE_URL (Neon connection string), SYNC_TOKEN.
// For local development without Neon, see scripts/dev-server.mjs.
import { Pool, neonConfig } from '@neondatabase/serverless';
import ws from 'ws';

import { syncHandlers } from './_lib/handler.js';
import { ensureSchema } from './_lib/store.js';

neonConfig.webSocketConstructor = ws;

let schemaReady = null;

async function withNeonClient(work) {
  const pool = new Pool({ connectionString: process.env.DATABASE_URL });
  let client;
  try {
    client = await pool.connect();
    schemaReady ??= ensureSchema(client).catch((e) => {
      schemaReady = null;
      throw e;
    });
    await schemaReady;
    return await work(client);
  } finally {
    client?.release();
    await pool.end();
  }
}

const handlers = syncHandlers(withNeonClient);

export function GET(request) {
  return handlers.GET(request);
}

export function PUT(request) {
  return handlers.PUT(request);
}
