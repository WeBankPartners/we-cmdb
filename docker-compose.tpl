version: '2'
services:
  wecmdb:
    image: wecmdb:{{version}}
    container_name: wecmdb-{{version}}
    restart: always
    volumes:
      - /etc/localtime:/etc/localtime
      - {{path}}/cmdb/conf:/app/cmdb/conf
      - {{path}}/cmdb/logs:/app/cmdb/logs
    ports:
      - "{{port}}:8096"