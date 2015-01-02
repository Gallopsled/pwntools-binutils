#!/usr/bin/env bash
source ../common/arch.sh

for arch in $ARCHES; do
bash install.sh $arch
done