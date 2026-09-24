// Snapshot storage for /api/sync. `client` is anything with
// `query(text, params) -> { rows }` (a node-postgres-compatible client from
// @neondatabase/serverless in production, PGlite in tests).
//
// Each Drift table on the device gets a mirror table here, so the data is
// browsable from the Neon console. The JSON keys are exactly what Drift's
// generated `toJson()` produces (camelCase); columns are snake_case.

/** Snapshot key -> [jsonKey, pgType][], parents before children. */
export const TABLES = {
  persons: [['id', 'integer'], ['name', 'text'], ['isOut', 'boolean'], ['gen', 'integer'], ['guest', 'boolean']],
  plays: [['id', 'integer'], ['category', 'text'], ['name', 'text']],
  playPositions: [['id', 'integer'], ['playId', 'integer'], ['positionIndex', 'integer'], ['label', 'text']],
  personPositions: [['id', 'integer'], ['personId', 'integer'], ['playId', 'integer'], ['positionIndex', 'integer']],
  lineupSlots: [['id', 'integer'], ['playId', 'integer'], ['positionIndex', 'integer'], ['personId', 'integer']],
  mainMembers: [['id', 'integer'], ['playId', 'integer'], ['positionIndex', 'integer'], ['personId', 'integer']],
  subMembers: [['id', 'integer'], ['playId', 'integer'], ['positionIndex', 'integer'], ['personId', 'integer']],
  lineupTemplates: [['id', 'integer'], ['playId', 'integer'], ['name', 'text']],
  lineupTemplateSlots: [
    ['id', 'integer'], ['templateId', 'integer'], ['area', 'text'], ['positionIndex', 'integer'], ['personId', 'integer'],
  ],
};

const snake = (s) => s.replace(/[A-Z]/g, (c) => `_${c.toLowerCase()}`);
const quote = (s) => `"${s}"`;

export class ConflictError extends Error {
  constructor(version) {
    super('version conflict');
    this.version = version;
  }
}

export class BadRequestError extends Error {}

export async function ensureSchema(client) {
  await client.query(`CREATE TABLE IF NOT EXISTS sync_meta (
    id integer PRIMARY KEY CHECK (id = 1),
    version integer NOT NULL,
    schema_version integer,
    updated_at timestamptz
  )`);
  await client.query('INSERT INTO sync_meta (id, version) VALUES (1, 0) ON CONFLICT (id) DO NOTHING');
  // No foreign keys: this is a mirror of the device's database, and the
  // device (SQLite without `PRAGMA foreign_keys`) may hold orphan rows.
  for (const [key, cols] of Object.entries(TABLES)) {
    const defs = cols.map(([name, type]) => `${snake(name)} ${type}${name === 'id' ? ' PRIMARY KEY' : ''}`);
    await client.query(`CREATE TABLE IF NOT EXISTS ${snake(key)} (${defs.join(', ')})`);
  }
}

export async function readSnapshot(client) {
  const { rows } = await client.query('SELECT version, schema_version, updated_at FROM sync_meta WHERE id = 1');
  const meta = rows[0];
  const result = {
    version: meta.version,
    schemaVersion: meta.schema_version,
    updatedAt: meta.updated_at ? new Date(meta.updated_at).toISOString() : null,
    data: null,
  };
  if (meta.version === 0) return result;

  result.data = {};
  for (const [key, cols] of Object.entries(TABLES)) {
    const select = cols.map(([name]) => `${snake(name)} AS ${quote(name)}`).join(', ');
    const res = await client.query(`SELECT ${select} FROM ${snake(key)} ORDER BY id`);
    result.data[key] = res.rows;
  }
  return result;
}

/**
 * Replaces the stored snapshot with `data`, but only if the server is still
 * at `baseVersion` (optimistic locking). Returns the new version.
 */
export async function writeSnapshot(client, { baseVersion, schemaVersion, data }) {
  validate(baseVersion, data);
  await client.query('BEGIN');
  try {
    const { rows } = await client.query('SELECT version FROM sync_meta WHERE id = 1 FOR UPDATE');
    if (rows[0].version !== baseVersion) throw new ConflictError(rows[0].version);

    for (const key of Object.keys(TABLES).reverse()) {
      await client.query(`DELETE FROM ${snake(key)}`);
    }
    for (const [key, cols] of Object.entries(TABLES)) {
      const rowsJson = data[key] ?? [];
      if (rowsJson.length === 0) continue;
      const target = cols.map(([name]) => snake(name)).join(', ');
      const source = cols.map(([name]) => quote(name)).join(', ');
      const recordDef = cols.map(([name, type]) => `${quote(name)} ${type}`).join(', ');
      await client.query(
        `INSERT INTO ${snake(key)} (${target})
         SELECT ${source} FROM jsonb_to_recordset($1::jsonb) AS x(${recordDef})`,
        [JSON.stringify(rowsJson)],
      );
    }
    const updated = await client.query(
      `UPDATE sync_meta SET version = version + 1, schema_version = $1, updated_at = now()
       WHERE id = 1 RETURNING version`,
      [Number.isInteger(schemaVersion) ? schemaVersion : null],
    );
    await client.query('COMMIT');
    return updated.rows[0].version;
  } catch (e) {
    await client.query('ROLLBACK');
    // Bad types/duplicate ids in the payload surface as Postgres errors.
    if (e.code && /^(22|23)/.test(e.code)) throw new BadRequestError(e.message);
    throw e;
  }
}

function validate(baseVersion, data) {
  if (!Number.isInteger(baseVersion) || baseVersion < 0) {
    throw new BadRequestError('baseVersion must be a non-negative integer');
  }
  if (typeof data !== 'object' || data === null || Array.isArray(data)) {
    throw new BadRequestError('data must be an object');
  }
  for (const key of Object.keys(TABLES)) {
    const rows = data[key];
    if (rows === undefined) continue;
    if (!Array.isArray(rows) || rows.some((r) => typeof r !== 'object' || r === null || !Number.isInteger(r.id))) {
      throw new BadRequestError(`data.${key} must be an array of rows with integer ids`);
    }
  }
}
