#!/usr/bin/env bash
source ../common/arch.sh

if [[ $# -ne 1 ]];
then
echo "usage: $0 architecture"
else
sudo apt-get install --yes software-properties-common
sudo apt-add-repository --yes ppa:pwntools/binutils
sudo apt-get update

for arch in $ARCHES; do
sudo apt-get install binutils-$arch-linux-gnu
done
fi