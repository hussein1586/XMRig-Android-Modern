#!/bin/bash

set -euo pipefail

source script/env.sh

cd "$EXTERNAL_LIBS_BUILD_ROOT/libuv"

TOOLCHAIN="$ANDROID_HOME/ndk/$NDK_VERSION/build/cmake/android.toolchain.cmake"
CMAKE="$ANDROID_HOME/cmake/3.18.1/bin/cmake"
ANDROID_PLATFORM=android-29
ANDROID_ABI="arm64-v8a"
TARGET_DIR="$EXTERNAL_LIBS_ROOT/libuv/$ANDROID_ABI"
BUILD_DIR="$EXTERNAL_LIBS_BUILD_ROOT/libuv/build/$ANDROID_ABI"

mkdir -p "$TARGET_DIR" "$BUILD_DIR"
cd "$BUILD_DIR"

"$CMAKE" \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" \
  -DANDROID_ABI="$ANDROID_ABI" \
  -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
  -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" \
  -DBUILD_SHARED_LIBS=OFF \
  -DLIBUV_BUILD_TESTS=OFF \
  ../..

"$CMAKE" --build . --parallel 4
"$CMAKE" --install .

exit 0
