#!/bin/bash

set -e

mkdir -p ./tmp_build
CMAKE_BUILD_DIR=`readlink -f ./tmp_build`

pushd $CMAKE_BUILD_DIR

cmake -DCMAKE_BUILD_TYPE=Release ..
make -j3

popd
