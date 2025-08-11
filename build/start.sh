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

sed -i "s~{{WECMDB_SYNC_ENABLE}}~$WECMDB_SYNC_ENABLE~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_TYPE}}~$WECMDB_SYNC_TYPE~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_SOURCE_IP}}~$WECMDB_SYNC_SOURCE_IP~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_TARGET_IP}}~$WECMDB_SYNC_TARGET_IP~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_NEXUS_ADDRESS}}~$WECMDB_SYNC_NEXUS_ADDRESS~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_NEXUS_USER}}~$WECMDB_SYNC_NEXUS_USER~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_NEXUS_PWD}}~$WECMDB_SYNC_NEXUS_PWD~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_NEXUS_REPO}}~$WECMDB_SYNC_NEXUS_REPO~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_SYNC_START_ID}}~$WECMDB_SYNC_START_ID~g" /app/cmdb/conf/default.json
sed -i "s~{{ALLOCATE_HOST}}~$ALLOCATE_HOST~g" /app/cmdb/conf/default.json
sed -i "s~{{WECMDB_AUTOFILL_WITHOUT_LIST}}~$WECMDB_AUTOFILL_WITHOUT_LIST~g" /app/cmdb/conf/default.json
if [ $PLUGIN_MODE ]
then
sed -i "s~{{PLUGIN_MODE}}~yes~g" /app/cmdb/conf/default.json
else
sed -i "s~{{PLUGIN_MODE}}~no~g" /app/cmdb/conf/default.json
fi

./cmdb-server