#!/bin/bash
cp -r ../../cmdb-core/database  database

TEXT='use cmdb;'

cd database
for i in `ls -1 ./*`; do
     CONTENTS=`cat $i`
     echo $TEXT > $i  # use echo -n if you want the append to be on the same line
     echo $CONTENTS >> $i
done
cd ../

echo "SET NAMES utf8;" > ./database/000000_create_database.sql
echo "create database cmdb charset = utf8;;" >> ./database/000000_create_database.sql


docker build -t cmdb-db:dev .
rm -rf database
