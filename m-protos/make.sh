#!/bin/bash

set -e

ROOT=`readlink -f ../m-deps-c/root/`
CPP_OUT_PATH=`readlink -f ../m-sh-c/src/generated/`
#JAVA_OUT_PATH=`readlink -f ../m-sh-java/src/main/java/`

export PATH="$PATH:$ROOT/bin/"

#mkdir -p ../src/generated/

#cpp
protoc --proto_path=./ --cpp_out="$CPP_OUT_PATH"  Recommendations.proto

protoc --proto_path=./ --grpc_out="$CPP_OUT_PATH" --plugin=protoc-gen-grpc=`which grpc_cpp_plugin` Recommendations.proto
