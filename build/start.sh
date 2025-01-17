#!/bin/bash

sed -i "s~{{CMDB_MYSQL_HOST}}~$CMDB_MYSQL_HOST~g" /app/cmdb/conf/default.json
sed -i "s~{{CMDB_MYSQL_PORT}}~$CMDB_MYSQL_PORT~g" /app/cmdb/conf/default.json
sed -i "s~{{CMDB_MYSQL_SCHEMA}}~$CMDB_MYSQL_SCHEMA~g" /app/cmdb/conf/default.json
sed -i "s~{{CMDB_MYSQL_USER}}~$CMDB_MYSQL_USER~g" /app/cmdb/conf/default.json
sed -i "s~{{CMDB_MYSQL_PWD}}~$CMDB_MYSQL_PWD~g" /app/cmdb/conf/default.json
sed -i "s~{{CMDB_LOG_LEVEL}}~$CMDB_LOG_LEVEL~g" /app/cmdb/conf/default.json
sed -i "s~{{GATEWAY_URL}}~$GATEWAY_URL~g" /app/cmdb/conf/default.json
sed -i "s~{{JWT_SIGNING_KEY}}~$JWT_SIGNING_KEY~g" /app/cmdb/conf/default.json
sed -i "s~{{SUB_SYSTEM_CODE}}~$SUB_SYSTEM_CODE~g" /app/cmdb/conf/default.json
sed -i "s~{{SUB_SYSTEM_KEY}}~$SUB_SYSTEM_KEY~g" /app/cmdb/conf/default.json
sed -i "s~{{HTTP_SERVER_PORT}}~$HTTP_SERVER_PORT~g" /app/cmdb/conf/default.json
sed -i "s~{{ENCRYPT_SEED}}~$ENCRYPT_SEED~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_MENU_API_ENABLE}}~$WECMDB_MENU_API_ENABLE~g" /app/cmdb/conf/default.json
if [ $PLUGIN_MODE ]
then
sed -i "s~{{PLUGIN_MODE}}~yes~g" /app/cmdb/conf/default.json
else
sed -i "s~{{PLUGIN_MODE}}~no~g" /app/cmdb/conf/default.json
fi

./cmdb-server