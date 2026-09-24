// Offline service worker for the Flutter web build. This file is a template:
// scripts/gen-sw.mjs fills in PRECACHE and writes the result to build/web/sw.js.
//
// - Every file in PRECACHE is downloaded on install, so the app starts with
//   no network at all after the first visit. Entries are keyed by content
//   hash, so a redeploy only re-downloads files that actually changed.
// - Navigations are answered with the cached index.html.
// - /api/* (sync) always goes to the network.
// - Anything else (e.g. the Japanese fallback fonts Flutter pulls from
//   fonts.gstatic.com) is cached the first time it's fetched online.

/** @type {Record<string, string>} path -> content hash */
const PRECACHE = __PRECACHE__;

const PRECACHE_NAME = 'kick-members-precache';
const RUNTIME_NAME = 'kick-members-runtime';

const scope = new URL(self.registration.scope);
const urlFor = (path) => new URL(path, scope).href;
const keyFor = (path) => `${urlFor(path)}?__sw=${PRECACHE[path]}`;
const precachedByUrl = new Map(Object.keys(PRECACHE).map((path) => [urlFor(path), path]));

self.addEventListener('install', (event) => {
  event.waitUntil((async () => {
    const cache = await caches.open(PRECACHE_NAME);
    const have = new Set((await cache.keys()).map((req) => req.url));
    for (const path of Object.keys(PRECACHE)) {
      const key = keyFor(path);
      if (have.has(key)) continue;
      const res = await fetch(urlFor(path), { cache: 'no-cache' });
      if (!res.ok) throw new Error(`precache ${path}: ${res.status}`);
      await cache.put(key, res);
    }
    await self.skipWaiting();
  })());
});

self.addEventListener('activate', (event) => {
  event.waitUntil((async () => {
    const wanted = new Set(Object.keys(PRECACHE).map(keyFor));
    const cache = await caches.open(PRECACHE_NAME);
    for (const req of await cache.keys()) {
      if (!wanted.has(req.url)) await cache.delete(req);
    }
    await self.clients.claim();
  })());
});

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET') return;
  const url = new URL(request.url);
  if (url.origin === scope.origin && url.pathname.startsWith('/api/')) return;

  if (request.mode === 'navigate') {
    event.respondWith(fromPrecache('index.html').then((res) => res ?? fetch(request)));
    return;
  }

  const path = precachedByUrl.get(url.origin + url.pathname);
  if (path !== undefined) {
    event.respondWith(fromPrecache(path).then((res) => res ?? fetch(request)));
    return;
  }

  event.respondWith(runtime(request));
});

async function fromPrecache(path) {
  const cache = await caches.open(PRECACHE_NAME);
  return cache.match(keyFor(path));
}

/** Cache-first for immutable cross-origin assets (fonts), network-first otherwise. */
async function runtime(request) {
  const cache = await caches.open(RUNTIME_NAME);
  const immutable = new URL(request.url).origin !== scope.origin;
  if (immutable) {
    const hit = await cache.match(request);
    if (hit) return hit;
  }
  try {
    const res = await fetch(request);
    if (res.ok || res.type === 'opaque') await cache.put(request, res.clone());
    return res;
  } catch (e) {
    const hit = await cache.match(request);
    if (hit) return hit;
    throw e;
  }
}
