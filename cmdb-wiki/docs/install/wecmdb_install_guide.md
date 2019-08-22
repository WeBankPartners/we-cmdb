# WeCMDB安装指引

WeCMDB运行环境需要3个组件： wecmdb-app、wecmdb-db（mysql）、cas server。这3个组件都已做成docker镜像，本安装指引通过docker-compose的方式启动这3个容器，不需要再单独安装mysql和cas服务。用户也可以自行安装mysql和cas，修改部分配置文件即可。

## 安装前准备
1. 准备一台linux主机，资源配置建议为4核8GB或以上。
2. 操作系统版本建议为ubuntu16.04以上或centos7.3以上。
3. 建议网络可通外网(需从外网下载部分软件)。
4. 安装docker1.17.03.x以上版本以及docker-compose命令。
	- docker安装请参考[docker安装文档](docker_install_guide.md)
	- docker-compose安装请参考[docker-compose安装文档](docker-compose_install_guide.md)

## 配置
1. 建立执行目录和相关文件
	
	在部署机器上建立安装目录，新建以下三个文件：

	[cmdb.cfg](../../../build/cmdb.cfg)

	[install.sh](../../../build/install.sh)

	[docker-compose.tpl](../../../build/docker-compose.tpl)

2. cmdb.cfg配置文件，该文件包含如下配置项，用户根据各自的部署环境替换掉相关值。

	```	
	cas_url=http://{$cas_ip}:8443/cas

	cmdb_server_ip={$cmdb_server_ip}
	cmdb_server_port=8080
	cmdb_image_name=cmdb:dev
	cmdb_ip_whitelists={$cmdb_ip_whitelists}

	database_image_name=cmdb-db:dev
	database_init_password=mysql
	```

	 配置项                    |说明
	 -------------------------|--------------------
	 cas_url                  |单点登陆cas服务器url,docker-compose.tpl中已经自带cas服务器，默认用户名为admin，密码为123，如果要使用该服务器，此处的ip地址填部署主机的ip;
	 cmdb_server_ip           |cmdb的服务ip，cas单点登录成功后的回跳地址；如果浏览器是通过局域网访问，该值填部署主机的局域网ip;如果是公网访问需填公网可访问的ip地址，如LB的ip
	 cmdb_server_port         |cmdb的服务端口
	 cmdb_image_name          |cmdb的docker镜像名称
	 cmdb_ip_whitelists       |第三方服务如果要调用cmdb的api，需将第三方服务的访问ip加到此处，如果有多个服务，中间用逗号隔开
	 database_image_name      |cmdb依赖的数据库docker镜像名称
	 database_init_password   |cmdb依赖的数据库root用户对应的初始化密码


3. install.sh文件。

	```
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
	
	sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_image_name~" docker-compose.tpl > docker-compose.yml
	sed -i "s~{{CMDB_SERVER_PORT}}~$cmdb_server_port~" docker-compose.yml  
	sed -i "s~{{CMDB_DATABASE_IMAGE_NAME}}~$database_image_name~" docker-compose.yml  
	sed -i "s~{{MYSQL_ROOT_PASSWORD}}~$database_init_password~" docker-compose.yml 
	sed -i "s~{{CAS_SERVER_URL}}~$cas_url~" docker-compose.yml
	sed -i "s~{{CMDB_SERVER_IP}}~$cmdb_server_ip~" docker-compose.yml
	sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~" docker-compose.yml
	
	
	docker-compose  -f docker-compose.yml  up -d
	```

4. docker-compose.tpl文件
	
	此文件中配置了要安装的服务：cas、mysql、cmdb。
	如果已有cas和mysql，在文件中将这两段内容注释掉，在cmdb的environment配置中，手动修改cas和数据库配置即可。
	详细代码如下：
	```
	version: '2'
	services:
	  cas:
	    image: kawhii/sso
	    container_name: cas_sso
	    restart: always
	    volumes:
	      - /etc/localtime:/etc/localtime
	    ports:
	      - 8443:8443
	  mysql:
	    image: {{CMDB_DATABASE_IMAGE_NAME}}
	    restart: always
	    command: [
	            '--character-set-server=utf8mb4',
	            '--collation-server=utf8mb4_unicode_ci',
	            '--default-time-zone=+8:00'
	    ]
	    volumes:
	      - /etc/localtime:/etc/localtime
	    environment:
	      - MYSQL_ROOT_PASSWORD={{MYSQL_ROOT_PASSWORD}}
	    ports:
	      - 3306:3306
	    volumes:
	      - /data/cmdb/db:/var/lib/mysql
	  cmdb:
	    image: {{CMDB_CORE_IMAGE_NAME}}
	    restart: always
	    volumes:
	      - /data/cmdb/log:/log/
	      - /etc/localtime:/etc/localtime
	    depends_on:
	      - mysql
	      - cas
	    ports:
	      - {{CMDB_SERVER_PORT}}:8080
	    environment:
	      - TZ=Asia/Shanghai
	      - MYSQL_SERVER_ADDR=mysql
	      - MYSQL_SERVER_PORT=3306
	      - MYSQL_SERVER_DATABASE_NAME=cmdb
	      - MYSQL_USER_NAME=root
	      - MYSQL_USER_PASSWORD={{MYSQL_ROOT_PASSWORD}}
	      - CMDB_SERVER_PORT={{CMDB_SERVER_PORT}}
	      - CAS_SERVER_URL={{CAS_SERVER_URL}}
	      - CAS_REDIRECT_APP_ADDR={{CMDB_SERVER_IP}}:{{CMDB_SERVER_PORT}}
	      - CMDB_IP_WHITELISTS={{CMDB_IP_WHITELISTS}}
	```

## 执行安装
1.拉取镜像文件
	通过文件方式加载镜像
	docker load --input wecmdb-app.tar
	docker load --input wecmdb-db.tar 
	执行docker images 命令，能看到镜像已经导入。
	
2. 执行如下命令，通过docker-compose拉起WeCmdb服务。
	
	```
	/bin/bash ./install.sh
	```
 
3. 安装完成后，访问WeCMDB的url，确认页面访问正常。
	http://cmdb_server_ip:cmdb_server_port/cmdb
