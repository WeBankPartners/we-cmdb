#/bin/sh
mkdir -p /data/
java -jar /home/cmdb-core.jar  --server.address=0.0.0.0 --server.port=${CMDB_SERVER_PORT} --server.servlet.context-path=/cmdb  \
--spring.datasource.driver-class-name=com.mysql.cj.jdbc.Driver \
--spring.datasource.url=jdbc:mysql://${MYSQL_SERVER_ADDR}:${MYSQL_SERVER_PORT}/${MYSQL_SERVER_DATABASE_NAME}?characterEncoding=utf8  \
--spring.datasource.username=${MYSQL_USER_NAME} \
--spring.datasource.password=${MYSQL_USER_PASSWORD}  \
--cmdb.datasource.schema=${MYSQL_SERVER_DATABASE_NAME} \
--cas-server.url=${CAS_SERVER_URL}  \
--cas-server.redirect-app-addr=${CAS_REDIRECT_APP_ADDR} \
--cas-server.enabled=true \
--cas-server.whitelist-ipaddress=${CMDB_IP_WHITELISTS}>>/data/cmdb-core.log 
