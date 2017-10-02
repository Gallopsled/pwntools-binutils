#!/usr/bin/env bash
source ../common/arch.sh

if [[ $# -ne 1 ]];
then
echo "usage: $0 architecture"
else

TARGET=$1
V=2.29.1

cd /tmp
wget -nc http://ftp.gnu.org/gnu/binutils/binutils-$V.tar.gz
wget -nc http://ftp.gnu.org/gnu/binutils/binutils-$V.tar.gz.sig

gpg --keyserver keys.gnupg.net --recv-keys 13FCEF89DD9E3C4F
gpg --verify binutils-$V.tar.gz.sig

tar xf binutils-$V.tar.gz

rm -rf binutils-build
mkdir binutils-build
cd binutils-build
export AR=ar
export AS=as

../binutils-$V/configure \
    --prefix=/usr/local \
    --target=$TARGET-unknown-linux-gnu \
    --disable-static \
    --disable-multilib \
    --disable-werror \
    --disable-nls

MAKE=gmake
hash gmake || MAKE=make

$MAKE -j
sudo $MAKE install

fi
