#!/bin/bash
cp -r ../../cmdb-core/database  database
docker build -t cmdb-db:dev .
rm -rf database
