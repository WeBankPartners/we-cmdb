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

source cmdb-core.cfg

sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_image_name~" docker-compose.tpl > docker-compose.yml
sed -i "s~{{CMDB_CORE_EXTERNAL_PORT}}~$cmdb_core_external_port~" docker-compose.yml  
sed -i "s~{{CMDB_DATABASE_IMAGE_NAME}}~$database_image_name~" docker-compose.yml  
sed -i "s~{{MYSQL_USER_PASSWORD}}~$database_user_password~" docker-compose.yml 
sed -i "s~{{CAS_SERVER_URL}}~$cas_url~" docker-compose.yml
sed -i "s~{{CMDB_CORE_EXTERNAL_IP}}~$cmdb_core_exteranl_ip~" docker-compose.yml
sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~" docker-compose.yml
 
docker-compose  -f docker-compose.yml  up -d











