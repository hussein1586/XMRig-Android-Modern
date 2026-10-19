#!/usr/bin/env bash

set -euo pipefail

source script/env.sh

cd "$EXTERNAL_LIBS_BUILD_ROOT"

OPENSSL_VERSION="1.1.1w"

if [ ! -d "openssl" ]; then
  wget -q "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" -O openssl.tar.gz
  tar -xzf openssl.tar.gz
  mv "openssl-${OPENSSL_VERSION}" openssl
fi
