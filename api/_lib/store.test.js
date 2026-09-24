import assert from 'node:assert/strict';
import { test } from 'node:test';
import { PGlite } from '@electric-sql/pglite';

import { BadRequestError, ConflictError, ensureSchema, readSnapshot, writeSnapshot } from './store.js';

async function freshDb() {
  const db = new PGlite();
  await ensureSchema(db);
  await ensureSchema(db); // idempotent
  return db;
}

const snapshot = {
  persons: [
    { id: 1, name: '田中', isOut: false, gen: 3, guest: false },
    { id: 4, name: 'Kevin', isOut: true, gen: null, guest: true },
  ],
  plays: [{ id: 1, category: 'KC', name: '左sabel_α' }],
  playPositions: [{ id: 1, playId: 1, positionIndex: 0, label: '10' }],
  personPositions: [{ id: 1, personId: 1, playId: 1, positionIndex: 0 }],
  lineupSlots: [{ id: 1, playId: 1, positionIndex: 0, personId: null }],
  mainMembers: [{ id: 1, playId: 1, positionIndex: 0, personId: 4 }],
  subMembers: [{ id: 2, playId: 1, positionIndex: 3, personId: 1 }],
  lineupTemplates: [{ id: 1, playId: 1, name: '通常' }],
  lineupTemplateSlots: [{ id: 1, templateId: 1, area: 'sub', positionIndex: 3, personId: 1 }],
};

test('empty server reports version 0 and no data', async () => {
  const db = await freshDb();
  const res = await readSnapshot(db);
  assert.equal(res.version, 0);
  assert.equal(res.data, null);
});

test('write then read round-trips the snapshot exactly', async () => {
  const db = await freshDb();
  assert.equal(await writeSnapshot(db, { baseVersion: 0, schemaVersion: 7, data: snapshot }), 1);
  const res = await readSnapshot(db);
  assert.equal(res.version, 1);
  assert.equal(res.schemaVersion, 7);
  assert.ok(res.updatedAt);
  assert.deepEqual(res.data, snapshot);
});

test('a second write replaces everything, and a stale baseVersion conflicts', async () => {
  const db = await freshDb();
  await writeSnapshot(db, { baseVersion: 0, schemaVersion: 7, data: snapshot });
  await writeSnapshot(db, { baseVersion: 1, schemaVersion: 7, data: { persons: [{ id: 9, name: 'x', isOut: false, gen: null, guest: false }] } });

  const res = await readSnapshot(db);
  assert.equal(res.version, 2);
  assert.deepEqual(res.data.persons.map((p) => p.id), [9]);
  assert.deepEqual(res.data.plays, []);

  await assert.rejects(
    writeSnapshot(db, { baseVersion: 1, schemaVersion: 7, data: snapshot }),
    (e) => e instanceof ConflictError && e.version === 2,
  );
  assert.equal((await readSnapshot(db)).version, 2);
});

test('bad payloads are rejected without touching stored data', async () => {
  const db = await freshDb();
  await writeSnapshot(db, { baseVersion: 0, schemaVersion: 7, data: snapshot });
  for (const body of [
    { baseVersion: '1', data: snapshot },
    { baseVersion: 1, data: [] },
    { baseVersion: 1, data: { persons: [{ name: 'no id' }] } },
    { baseVersion: 1, data: { persons: [{ id: 1, name: 'a', isOut: 'nope' }] } },
    { baseVersion: 1, data: { persons: [{ id: 1, name: 'a' }, { id: 1, name: 'b' }] } },
  ]) {
    await assert.rejects(writeSnapshot(db, body), BadRequestError, JSON.stringify(body));
  }
  const res = await readSnapshot(db);
  assert.equal(res.version, 1);
  assert.deepEqual(res.data, snapshot);
});
