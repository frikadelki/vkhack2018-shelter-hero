#!/bin/bash

set -e

ROOT=`readlink -f ../m-deps-c/root/`
CPP_OUT_PATH=`readlink -f ../m-sh-c/src/generated/`

export PATH="$PATH:$ROOT/bin/"

protoc --proto_path=./ --cpp_out="$CPP_OUT_PATH"  Recommendations.proto
protoc --proto_path=./ --cpp_out="$CPP_OUT_PATH"  General.proto

protoc --proto_path=./ --grpc_out="$CPP_OUT_PATH" --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` Recommendations.proto
