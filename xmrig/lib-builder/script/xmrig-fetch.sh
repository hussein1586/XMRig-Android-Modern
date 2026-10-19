#!/usr/bin/env bash

set -e

source script/env.sh

cd "$EXTERNAL_LIBS_BUILD_ROOT"

version="v6.26.0"

if [ ! -d "xmrig" ]; then
  git clone --depth 1 https://github.com/xmrig/xmrig.git -b "${version}"
else
  cd xmrig
  git fetch --depth 1 origin "${version}"
  git checkout "${version}"
fi
