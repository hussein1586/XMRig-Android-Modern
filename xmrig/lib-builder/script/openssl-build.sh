#!/bin/bash

set -euo pipefail

source script/env.sh

cd "$EXTERNAL_LIBS_BUILD_ROOT/openssl"

export PATH="$TOOLCHAINS_PATH/bin:$PATH"
export ANDROID_NDK_ROOT="$ANDROID_HOME/ndk/$NDK_VERSION"
ANDROID_API=29
ANDROID_ABI="arm64-v8a"
TARGET_DIR="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI"

mkdir -p "$TARGET_DIR"

./Configure android-arm64 \
  -D__ANDROID_API__=$ANDROID_API \
  --prefix="$TARGET_DIR" \
  --openssldir="$TARGET_DIR/ssl" \
  no-shared no-tests no-zlib no-comp no-dgram no-filenames no-cms

make -j4
make install_sw

exit 0
