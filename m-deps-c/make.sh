#!/bin/bash

set -e

mkdir -p root

./make-protobuf.sh
./make-grpc.sh
