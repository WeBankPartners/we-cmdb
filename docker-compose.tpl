version: '2'
services:
  consul:
    image: wecmdb-pro:{{version}}
    container_name: wecmdb-pro-{{version}}
    restart: always
    volumes:
      - /etc/localtime:/etc/localtime
      - {{path}}/cmdb/conf:/app/cmdb/conf
      - {{path}}/cmdb/logs:/app/cmdb/logs
    ports:
      - "{{port}}:8096"