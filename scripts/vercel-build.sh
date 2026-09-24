#!/usr/bin/env bash
# Vercel build: install Flutter if needed, build the web app, then generate
# the offline service worker. Also works locally (uses the flutter on PATH).
set -euo pipefail

FLUTTER_VERSION="${FLUTTER_VERSION:-3.47.5}"

if ! command -v flutter >/dev/null 2>&1; then
  FLUTTER_DIR="$HOME/flutter"
  if [ ! -x "$FLUTTER_DIR/bin/flutter" ]; then
    command -v unzip >/dev/null 2>&1 || dnf install -y unzip
    git clone --depth 1 --branch "$FLUTTER_VERSION" https://github.com/flutter/flutter.git "$FLUTTER_DIR"
  fi
  export PATH="$FLUTTER_DIR/bin:$PATH"
fi

flutter --disable-analytics >/dev/null 2>&1 || true
flutter --version

cd app
flutter pub get
flutter build web --release --no-web-resources-cdn
cd ..

node scripts/gen-sw.mjs app/build/web
