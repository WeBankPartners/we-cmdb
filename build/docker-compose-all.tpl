version: '2'
services:
  wecmdb-mysql:
    image: {{CMDB_DATABASE_IMAGE_NAME}}
    restart: always
    command: [
            '--character-set-server=utf8mb4',
            '--collation-server=utf8mb4_unicode_ci',
            '--default-time-zone=+8:00',
            '--max_allowed_packet=4M'
    ]
    volumes:
      - /etc/localtime:/etc/localtime
    environment:
      - MYSQL_ROOT_PASSWORD={{MYSQL_ROOT_PASSWORD}}
    ports:
      - 3306:3306
    volumes:
      - /data/cmdb/db:/var/lib/mysql
  wecmdb-app:
    image: {{CMDB_CORE_IMAGE_NAME}}
    restart: always
    volumes:
      - /data/cmdb/log:/log/
      - /etc/localtime:/etc/localtime
    depends_on:
      - wecmdb-mysql
    network_mode: host
    ports:
      - {{CMDB_SERVER_PORT}}:{{CMDB_SERVER_PORT}}
    environment:
      - TZ=Asia/Shanghai
      - MYSQL_SERVER_ADDR=127.0.0.1
      - MYSQL_SERVER_PORT=3306
      - MYSQL_SERVER_DATABASE_NAME=cmdb
      - MYSQL_USER_NAME=root
      - MYSQL_USER_PASSWORD={{MYSQL_ROOT_PASSWORD}}
      - CMDB_SERVER_PORT={{CMDB_SERVER_PORT}}
      - CMDB_IP_WHITELISTS={{CMDB_IP_WHITELISTS}}
