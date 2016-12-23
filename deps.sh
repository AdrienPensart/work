#!/bin/sh

set -e
sudo apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential luarocks libpq-dev postgresql-server-dev-all

wget -nc https://www.openssl.org/source/openssl-1.0.2j.tar.gz
wget -nc https://openresty.org/download/openresty-1.11.2.2.tar.gz

tar xf openssl-1.0.2j.tar.gz
tar xf openresty-1.11.2.2.tar.gz

nbcores=$(grep -c ^processor /proc/cpuinfo)
cd openresty-1.11.2.2
./configure --with-debug --with-openssl=../openssl-1.0.2j --with-http_postgres_module --with-pcre-jit --with-ipv6 -j$nbcores
make -j$nbcores
sudo make install
cd ..

#rm -rf openssl-1.0.2j*
#rm -rf openresty-1.11.2.2*

sudo ln -s /usr/local/openresty/bin/* /usr/local/bin/
sudo ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/

mkdir -p logs
sudo luarocks install pgmoon
