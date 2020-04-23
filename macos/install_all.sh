#!/usr/bin/env bash
source ../common/arch.sh

for arch in $ARCHES; do
brew install binutils-$arch.rb
done
