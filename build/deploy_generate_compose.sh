#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Missing configure file"
    exit 1
fi

source $1

build_path=`dirname $0`

sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_core_image_name~" ${build_path}/docker-compose.tpl > docker-compose.yml
sed -i "s~{{CMDB_SERVER_PORT}}~$cmdb_server_port~" docker-compose.yml  
sed -i "s~{{CAS_SERVER_URL}}~$cas_server_url~" docker-compose.yml
sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~" docker-compose.yml
sed -i "s~{{CMDB_CORE_EXTERNAL_PORT}}~$cmdb_core_external_port~" docker-compose.yml
sed -i "s~{{CMDB_CORE_EXTERNAL_IP}}~$cmdb_core_exteranl_ip~" docker-compose.yml
sed -i "s~{{CMDB_CORE_DATABASE_NAME}}~$cmdb_core_database_name~" docker-compose.yml
sed -i "s~{{CMDB_CORE_DATABASE_USER_NAME}}~$cmdb_core_database_user_name~" docker-compose.yml
sed -i "s~{{CMDB_CORE_DATABASE_PASSWORD}}~$cmdb_core_database_password~" docker-compose.yml
sed -i "s~{{CMDB_CORE_DATABASE_SERVER}}~$cmdb_core_database_server~" docker-compose.yml
sed -i "s~{{CMDB_CORE_DATABASE_PORT}}~$cmdb_core_database_port~" docker-compose.yml

 
