all: libuv openssl xmrig install

libuv: libuv_dl
	script/libuv-build.sh

libuv_dl:
	script/libuv-fetch.sh

openssl: openssl_dl
	script/openssl-build.sh

openssl_dl:
	script/openssl-fetch.sh

xmrig: xmrig_dl
	script/xmrig-build.sh

xmrig_dl:
	script/xmrig-fetch.sh

install:
	script/install.sh

clean:
	script/clean.sh
