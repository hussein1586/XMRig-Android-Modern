#!/bin/bash

set -euo pipefail

source script/env.sh

ROOT_DIR="$(cd ../.. && pwd)"
XARCH="arm64-v8a"
XMRIG_BIN="$EXTERNAL_LIBS_BUILD_ROOT/xmrig/build/$XARCH/xmrig"
OUT_DIR="$ROOT_DIR/android/app/src/main/jniLibs/$XARCH"

rm -rf "$ROOT_DIR/android/app/src/main/jniLibs"
mkdir -p "$OUT_DIR"

test -x "$XMRIG_BIN"
cp "$XMRIG_BIN" "$OUT_DIR/libxmrig.so"
chmod 0755 "$OUT_DIR/libxmrig.so"
sha256sum "$OUT_DIR/libxmrig.so"

exit 0
