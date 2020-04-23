#!/usr/bin/env bash

if [[ $# -ne 1 ]];
then
echo "usage: $0 architecture"
else
brew install binutils-*$1*.rb
fi
