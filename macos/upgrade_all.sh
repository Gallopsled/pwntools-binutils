#!/usr/bin/env bash
source ../common/arch.sh

for arch in $ARCHES; do
brew upgrade binutils-$arch.rb
done
