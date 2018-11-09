#!/bin/bash

set -e

#protobuf
git clone https://github.com/protocolbuffers/protobuf.git
pushd ./protobuf/
git checkout tags/v3.6.1
popd

#grpc
git clone -b $(curl -L https://grpc.io/release) https://github.com/grpc/grpc
cd grpc
git submodule update --init

