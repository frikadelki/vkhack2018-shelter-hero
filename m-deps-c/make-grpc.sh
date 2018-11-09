#!/bin/bash

set -e

ROOT=`readlink -f ./root/`

export CPATH="$ROOT/include"
export LIBRARY_PATH="$ROOT/lib"
export LD_LIBRARY_PATH="$ROOT/lib"
export PATH="$PATH:$ROOT/bin"

pushd grpc

git submodule update --init

make -j3
make prefix=$ROOT install

popd

