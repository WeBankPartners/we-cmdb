version: '2'
services:
  wecube-cas:
    image: kawhii/sso
    container_name: cas_sso
    restart: always
    volumes:
      - /etc/localtime:/etc/localtime
    ports:
      - 8443:8443

  wecmdb-app:
    image: {{CMDB_CORE_IMAGE_NAME}}
    restart: always
    volumes:
      - /data/cmdb/log:/log/
      - /etc/localtime:/etc/localtime
    depends_on:
      - wecube-cas
    network_mode: host
    ports:
      - {{CMDB_CORE_EXTERNAL_PORT}}:8080
    environment:
      - TZ=Asia/Shanghai
      - MYSQL_SERVER_ADDR={{CMDB_CORE_DATABASE_SERVER}}
      - MYSQL_SERVER_PORT={{CMDB_CORE_DATABASE_PORT}}
      - MYSQL_SERVER_DATABASE_NAME={{CMDB_CORE_DATABASE_NAME}}
      - MYSQL_USER_NAME={{CMDB_CORE_DATABASE_USER_NAME}}
      - MYSQL_USER_PASSWORD={{CMDB_CORE_DATABASE_PASSWORD}}
      - CMDB_SERVER_PORT={{CMDB_CORE_EXTERNAL_PORT}}
      - CAS_SERVER_URL={{CAS_SERVER_URL}}
      - CAS_REDIRECT_APP_ADDR={{CMDB_CORE_EXTERNAL_IP}}:{{CMDB_CORE_EXTERNAL_PORT}}
      - CMDB_IP_WHITELISTS={{CMDB_IP_WHITELISTS}}
