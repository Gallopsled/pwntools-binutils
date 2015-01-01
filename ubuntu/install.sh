#!/usr/bin/env bash

sudo apt-get install software-properties-common pwgen

sudo apt-add-repository --yes ppa:pwntools/binutils

sudo apt-get update

ARCHES="aarch64 alpha arm avr cris hppa ia64 m68k mips mips64 msp430 powerpc powerpc64 s390 sparc vax xscale"

for arch in $ARCHES; do

sudo apt-get install binutils-$arch-linux-gnu

done