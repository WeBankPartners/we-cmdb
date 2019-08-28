#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Missing configure file"
    exit 1
fi

source $1

image_version=$2

build_path=`dirname $0`

sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_core_image_name~g" ${build_path}/docker-compose.tpl > docker-compose.yml
sed -i "s~{{CMDB_SERVER_IP}}~$cmdb_server_ip~g" docker-compose.yml  
sed -i "s~{{CAS_SERVER_URL}}~$cas_server_url~g" docker-compose.yml
sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~g" docker-compose.yml
sed -i "s~{{CMDB_SERVER_PORT}}~$cmdb_server_port~g" docker-compose.yml
sed -i "s~{{CMDB_DATABASE_NAME}}~$cmdb_database_name~g" docker-compose.yml
sed -i "s~{{CMDB_DATABASE_USER_NAME}}~$cmdb_database_user_name~g" docker-compose.yml
sed -i "s~{{MYSQL_INIT_PASSWORD}}~$mysql_init_password~g" docker-compose.yml
sed -i "s~{{CMDB_DATABASE_SERVER}}~$cmdb_database_server~g" docker-compose.yml
sed -i "s~{{CMDB_DATABASE_PORT}}~$cmdb_database_port~g" docker-compose.yml
sed -i "s~{{IMAGE_VERSION}}~$image_version~g" docker-compose.yml
 
