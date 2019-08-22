source $1

sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_image_name~" docker-compose.tpl > docker-compose.yml
sed -i "s~{{CMDB_SERVER_PORT}}~$cmdb_server_port~" docker-compose.yml  
sed -i "s~{{CMDB_DATABASE_IMAGE_NAME}}~$database_image_name~" docker-compose.yml  
sed -i "s~{{MYSQL_ROOT_PASSWORD}}~$database_init_password~" docker-compose.yml 
sed -i "s~{{CAS_SERVER_URL}}~$cas_url~" docker-compose.yml
sed -i "s~{{CMDB_SERVER_IP}}~$cmdb_server_ip~" docker-compose.yml
sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~" docker-compose.yml

