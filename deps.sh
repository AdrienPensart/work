#!/bin/sh

sudo apt-get install -y libreadline-dev libncurses5-dev libpcre3-dev libssl-dev perl make build-essential

wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz
wget https://openresty.org/download/openresty-1.11.2.2.tar.gz

tar xf openssl-1.0.2j.tar.gz
tar xf openresty-1.11.2.2.tar.gz

cd openresty-1.11.2.2
./configure --with-openssl=../openssl-1.0.2j -j4
make -j4
sudo make install
cd ..

rm -rf openssl-1.0.2j*
rm -rf openresty-1.11.2.2*

sudo ln -s /usr/local/openresty/bin/* /usr/local/bin/
sudo ln -s /usr/local/openresty/nginx/sbin/nginx /usr/local/bin/
