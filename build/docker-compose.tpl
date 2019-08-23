version: '2'
networks:
  cmdb-core:
    external: false
services:
  cas:
    image: kawhii/sso
    container_name: cas_sso
    restart: always
    networks:
      - cmdb-core
    ports:
      - 8443:8443
    networks:
      - cmdb-core
    volumes:
      - /data/cmdb/db:/var/lib/mysql
  cmdb:
    image: {{CMDB_CORE_IMAGE_NAME}}
    restart: always
    volumes:
      - /data/cmdb/log:/data/
    depends_on:
      - cas
    network_mode: host
    ports:
      - {{CMDB_CORE_EXTERNAL_PORT}}:8080
    environment:
      - MYSQL_SERVER_ADDR=127.0.0.1
      - MYSQL_SERVER_PORT=3306
      - MYSQL_SERVER_DATABASE_NAME={{CMDB_CORE_DATABASE_NAME}}
      - MYSQL_USER_NAME={{CMDB_CORE_DATABASE_USER_NAME}}
      - MYSQL_USER_PASSWORD={{CMDB_CORE_DATABASE_PASSWORD}}
      - CMDB_SERVER_PORT={{CMDB_CORE_EXTERNAL_PORT}}
      - CAS_SERVER_URL={{CAS_SERVER_URL}}
      - CAS_REDIRECT_APP_ADDR={{CMDB_CORE_EXTERNAL_IP}}:{{CMDB_CORE_EXTERNAL_PORT}}
      - CMDB_IP_WHITELISTS={{CMDB_IP_WHITELISTS}}