#!/bin/sh

db_host=$1
db_port=$2
db_schema=$3

mkdir -p /log
java -jar /application/wecube-plugins-wecmdb.jar  \
--server.address=0.0.0.0 \
--server.port=8081 \
--spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver \
--spring.datasource.url="jdbc:mysql://${db_host}:${db_port}/${db_schema}?characterEncoding=utf8&serverTimezone=UTC" \
--spring.datasource.username=$4 \
--spring.datasource.password=$5 >>/log/wecube-plugins-wecmdb.log 
