#!/bin/bash
set -ex
if ! docker --version &> /dev/null
then
    echo "must have docker installed"
    exit 1
fi

if ! docker-compose --version &> /dev/null
then
    echo  "must have docker-compose installed"
    exit 1
fi

source cmdb.cfg

sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_image_name~g" docker-compose-all.tpl > docker-compose.yml
sed -i "s~{{CMDB_SERVER_PORT}}~$cmdb_server_port~g" docker-compose.yml  
sed -i "s~{{CMDB_DATABASE_IMAGE_NAME}}~$database_image_name~g" docker-compose.yml  
sed -i "s~{{MYSQL_ROOT_PASSWORD}}~$database_init_password~g" docker-compose.yml 
sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~g" docker-compose.yml


docker-compose  -f docker-compose.yml  up -d

 










