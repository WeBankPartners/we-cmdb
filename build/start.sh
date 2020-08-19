#!/bin/sh
mkdir -p /log

JAVA_OPT="-verbose:gc -Xloggc:/data/wecmdb/log/wecmdb_gc_%p.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy"
JAVA_OPT="${JAVA_OPT} -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=30m"

java -jar /application/cmdb-core.jar ${JAVA_OPT} --server.address=0.0.0.0 --server.port=${CMDB_SERVER_PORT} --server.servlet.context-path=/wecmdb  \
--spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver \
--spring.datasource.url=jdbc:mysql://${MYSQL_SERVER_ADDR}:${MYSQL_SERVER_PORT}/${MYSQL_SERVER_DATABASE_NAME}?serverTimezone=Asia\/Shanghai\&characterEncoding=utf8  \
--spring.datasource.username=${MYSQL_USER_NAME} \
--spring.datasource.password=${MYSQL_USER_PASSWORD}  \
--cmdb.datasource.schema=${MYSQL_SERVER_DATABASE_NAME} \
--cmdb.security.enabled=false \
--cmdb.security.whitelist-ip-address=${CMDB_IP_WHITELISTS} \
${CUSTOM_PARAM} >>/data/wecmdb/log/wecmdb-core.log
