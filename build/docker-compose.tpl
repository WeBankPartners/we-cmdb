version: '2'
services:
  wecmdb-app:
    image: {{CMDB_CORE_IMAGE_NAME}}:{{IMAGE_VERSION}}
    restart: always
    volumes:
      - /data/cmdb/log:/log/
      - /etc/localtime:/etc/localtime
    network_mode: host
    ports:
      - {{CMDB_SERVER_PORT}}:{{CMDB_SERVER_PORT}}
    environment:
      - TZ=Asia/Shanghai
      - MYSQL_SERVER_ADDR={{CMDB_DATABASE_SERVER}}
      - MYSQL_SERVER_PORT={{CMDB_DATABASE_PORT}}
      - MYSQL_SERVER_DATABASE_NAME={{CMDB_DATABASE_NAME}}
      - MYSQL_USER_NAME={{CMDB_DATABASE_USER_NAME}}
      - MYSQL_USER_PASSWORD={{MYSQL_INIT_PASSWORD}}
      - CMDB_SERVER_PORT={{CMDB_SERVER_PORT}}
      - CMDB_IP_WHITELISTS={{CMDB_IP_WHITELISTS}}
      - {CUSTOM_PARAM}={{{CUSTOM_PARAM}}}
