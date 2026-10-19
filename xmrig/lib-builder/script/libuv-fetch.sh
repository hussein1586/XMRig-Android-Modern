#!/usr/bin/env bash

set -e

source script/env.sh

cd "$EXTERNAL_LIBS_BUILD_ROOT"

version="v1.51.0"

if [ ! -d "libuv" ]; then
  git clone --depth 1 https://github.com/libuv/libuv.git -b "${version}"
else
  cd libuv
  git fetch --depth 1 origin "${version}"
  git checkout "${version}"
fi
