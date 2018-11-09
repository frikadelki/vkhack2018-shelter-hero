#!/bin/bash

set -e

ROOT=`readlink -f ./root/`

pushd protobuf

./autogen.sh
./configure --prefix=$ROOT --disable-shared "CFLAGS=-fPIC" "CXXFLAGS=-fPIC"

make -j3
#make check
make install

popd

