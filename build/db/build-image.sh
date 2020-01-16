#!/bin/bash
cd `dirname $0`

rm -rf database

cp -r ../../cmdb-core/src/main/resources/database/ch database

cd database
for i in `ls -1 ./*.sql`; do
	sed -i '1 i\use cmdb;SET NAMES utf8;' $i
done
cd ../

echo -e "SET NAMES utf8;\n" > ./database/000000_create_database.sql
echo -e "create database cmdb charset = utf8;\n" >> ./database/000000_create_database.sql


docker build -t cmdb-db:dev .
