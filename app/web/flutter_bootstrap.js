{{flutter_js}}
{{flutter_build_config}}

// No `serviceWorkerSettings`: Flutter's own service worker is deprecated
// (it just unregisters itself). Offline caching is done by sw.js, which
// index.html registers and scripts/gen-sw.mjs generates at build time.
_flutter.loader.load();
