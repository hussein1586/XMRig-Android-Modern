#!/bin/bash

set -euo pipefail

source script/env.sh

cd "$EXTERNAL_LIBS_BUILD_ROOT/xmrig"

# Android's libc already provides pthread/rt symbols; keep only the libraries
# that are valid explicit link targets with modern NDKs.
sed -i 's/set(EXTRA_LIBS pthread rt dl log)/set(EXTRA_LIBS dl log)/' CMakeLists.txt

TOOLCHAIN="$ANDROID_HOME/ndk/$NDK_VERSION/build/cmake/android.toolchain.cmake"
CMAKE="$ANDROID_HOME/cmake/3.18.1/bin/cmake"
ANDROID_PLATFORM=android-29
ANDROID_ABI="arm64-v8a"
TARGET_DIR="$EXTERNAL_LIBS_ROOT/xmrig/$ANDROID_ABI"
BUILD_DIR="$EXTERNAL_LIBS_BUILD_ROOT/xmrig/build/$ANDROID_ABI"

mkdir -p "$TARGET_DIR" "$BUILD_DIR"
cd "$BUILD_DIR"

"$CMAKE" \
  -DCMAKE_TOOLCHAIN_FILE="$TOOLCHAIN" \
  -DANDROID_ABI="$ANDROID_ABI" \
  -DANDROID_PLATFORM="$ANDROID_PLATFORM" \
  -DCMAKE_INSTALL_PREFIX="$TARGET_DIR" \
  -DCMAKE_BUILD_TYPE=Release \
  -DANDROID_CROSS_COMPILE=ON \
  -DBUILD_SHARED_LIBS=OFF \
  -DBUILD_STATIC=OFF \
  -DWITH_HWLOC=OFF \
  -DWITH_OPENCL=OFF \
  -DWITH_CUDA=OFF \
  -DWITH_MSR=OFF \
  -DWITH_DMI=OFF \
  -DWITH_TLS=ON \
  -DWITH_HTTP=ON \
  -DWITH_RANDOMX=ON \
  -DARM_V8=ON \
  -DUV_LIBRARY="$EXTERNAL_LIBS_ROOT/libuv/$ANDROID_ABI/lib/libuv_a.a" \
  -DUV_INCLUDE_DIR="$EXTERNAL_LIBS_ROOT/libuv/$ANDROID_ABI/include" \
  -DOPENSSL_SSL_LIBRARY="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/lib/libssl.a" \
  -DOPENSSL_CRYPTO_LIBRARY="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/lib/libcrypto.a" \
  -DOPENSSL_INCLUDE_DIR="$EXTERNAL_LIBS_ROOT/openssl/$ANDROID_ABI/include" \
  ../..

"$CMAKE" --build . --parallel 4

# XMRig's Android build is an executable that the app launches from jniLibs.
test -x xmrig

exit 0
