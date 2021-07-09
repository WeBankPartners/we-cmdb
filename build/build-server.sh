#!/bin/bash
set -e -x
cd $(dirname $0)/../cmdb-server
go build -ldflags "-linkmode external -extldflags -static -s"