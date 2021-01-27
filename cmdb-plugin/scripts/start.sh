#!/bin/sh

db_host=$1
db_port=$2
db_schema=$3

JAVA_OPT="-Xmx3G -Xms512m -XX:+UseG1GC -XX:MaxGCPauseMillis=200  -XX:MaxTenuringThreshold=14"
JAVA_OPT="${JAVA_OPT} -verbose:gc -Xloggc:/data/wecmdb/log/wecmdb_gc_%p.log -XX:+PrintGCDetails -XX:+PrintGCDateStamps -XX:+PrintGCApplicationStoppedTime -XX:+PrintAdaptiveSizePolicy"
JAVA_OPT="${JAVA_OPT} -XX:+UseGCLogFileRotation -XX:NumberOfGCLogFiles=5 -XX:GCLogFileSize=30m"

/bin/sh /scripts/tomcat_exporter/start.sh
mkdir -p /data/wecmdb/log
java ${JAVA_OPT} -Duser.timezone=Asia/Shanghai \
-Dcom.sun.management.jmxremote \
-Dcom.sun.management.jmxremote.port=18082 \
-Dcom.sun.management.jmxremote.rmi.port=18082 \
-Dcom.sun.management.jmxremote.authenticate=false \
-Dcom.sun.management.jmxremote.ssl=false \
-jar /application/wecube-plugins-wecmdb.jar  \
--server.address=0.0.0.0 \
--server.port=8081 \
--spring.datasource.username=$4 \
--spring.datasource.password=$5 >>/data/wecmdb/log/wecmdb-core.log
