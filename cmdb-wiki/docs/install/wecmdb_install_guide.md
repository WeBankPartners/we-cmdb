# WeCMDB安装指引

WeCMDB运行环境需要3个组件： wecmdb-app、wecmdb-db（mysql）、cas server。这3个组件都已做成docker镜像，本安装指引通过docker-compose的方式启动这3个容器，不需要再单独安装mysql和cas服务。用户也可以自行安装mysql和cas，修改部分配置文件即可。

## 安装前准备
1. 准备一台linux主机，资源配置建议为4核8GB或以上。
2. 操作系统版本建议为ubuntu16.04以上或centos7.3以上。
3. 建议网络可通外网(需从外网下载部分软件)。
4. 安装docker1.17.03.x以上版本以及docker-compose命令。
	- docker安装请参考[docker安装文档](docker_install_guide.md)
	- docker-compose安装请参考[docker-compose安装文档](docker-compose_install_guide.md)


## 加载镜像

   通过文件方式加载镜像，执行以下命令：

   ```
   docker load --input wecmdb-app.tar
   docker load --input wecmdb-db.tar 
   ```

   导入镜像， 再执行命令

   ```
	docker images
   ```

   能看到镜像已经导入：

   ![wecmdb_images](images/wecmdb_images.png)

   记下镜像列表中的镜像名称以及TAG， 在下面的配置中需要用到。

## 配置
1. 建立执行目录和相关文件
	
	在部署机器上建立安装目录，新建以下4个文件：

	[cmdb.cfg](../../../build/cmdb.cfg)

	[install.sh](../../../build/install.sh)

	[uninstall.sh](../../../build/uninstall.sh)

	[docker-compose-all.tpl](../../../build/docker-compose-all.tpl)

2. cmdb.cfg配置文件，该文件包含如下配置项，用户根据各自的部署环境替换掉相关值。

	```	
	#cmdb
	cmdb_server_port=8080
	cmdb_image_name=we-cmdb:dev
	cmdb_ip_whitelists={$cmdb_ip_whitelists}

	#database
	database_image_name=cmdb-db:dev
	database_init_password=mysql
	```

	 配置项                    |说明
	 -------------------------|--------------------
	 cmdb_server_port         |cmdb的服务端口
	 cmdb_image_name          |cmdb的docker镜像名称及TAG，请填入在“加载镜像”章节中看到的镜像名称以及TAG，需要保持一致， 例如：we-cmdb:a092a47
	 cmdb_ip_whitelists       |第三方服务如果要调用cmdb的api，需将第三方服务的访问ip加到此处，如果有多个服务，中间用逗号隔开；若无，默认填127.0.0.1
	 database_image_name      |cmdb依赖的数据库docker镜像名称及TAG，请填入在“加载镜像”章节中看到的镜像名称以及TAG，需要保持一致， 例如：cmdb-db:dev
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
	
	sed "s~{{CMDB_CORE_IMAGE_NAME}}~$cmdb_image_name~" docker-compose-all.tpl > docker-compose.yml
	sed -i "s~{{CMDB_SERVER_PORT}}~$cmdb_server_port~" docker-compose.yml  
	sed -i "s~{{CMDB_DATABASE_IMAGE_NAME}}~$database_image_name~" docker-compose.yml  
	sed -i "s~{{MYSQL_ROOT_PASSWORD}}~$database_init_password~" docker-compose.yml 
	sed -i "s~{{CMDB_IP_WHITELISTS}}~$cmdb_ip_whitelists~" docker-compose.yml
	
	
	docker-compose -f docker-compose.yml up -d
	```

4. uninstall.sh文件。

	```
	#!/bin/bash
	docker-compose -f docker-compose.yml down -v
	```

5. docker-compose-all.tpl文件
	
	此文件中配置了要安装的服务：wecmdb-cas、wecmdb-mysql、wecmdb-app。
	如果已有cas和mysql，在文件中将wecmdb-cas、wecmdb-mysql这两段内容注释掉，在wecmdb-app的environment配置中，手动修改cas和数据库配置即可。
	
	详细代码如下：

	```
	version: '2'
	services:
	  wecmdb-mysql:
	    image: {{CMDB_DATABASE_IMAGE_NAME}}
	    restart: always
	    command: [
	            '--character-set-server=utf8mb4',
	            '--collation-server=utf8mb4_unicode_ci',
	            '--default-time-zone=+8:00'
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
	    ports:
	      - {{CMDB_SERVER_PORT}}:8080
	    environment:
	      - TZ=Asia/Shanghai
	      - MYSQL_SERVER_ADDR=wecmdb-mysql
	      - MYSQL_SERVER_PORT=3306
	      - MYSQL_SERVER_DATABASE_NAME=cmdb
	      - MYSQL_USER_NAME=root
	      - MYSQL_USER_PASSWORD={{MYSQL_ROOT_PASSWORD}}
	      - CMDB_SERVER_PORT={{CMDB_SERVER_PORT}}
	      - CMDB_IP_WHITELISTS={{CMDB_IP_WHITELISTS}}
	```

## 执行安装
1. 执行如下命令，通过docker-compose拉起WeCmdb服务。
	
	```
	/bin/bash ./install.sh
	```
 
2. 安装完成后，访问WeCMDB的url，确认页面访问正常,如果正常请输入初始用户名admin进行登陆。
	http://cmdb_server_ip:cmdb_server_port/wecmdb

## 卸载
执行如下命令，通过docker-compose停止WeCmdb服务。

```
/bin/bash ./uninstall.sh
```

## 重启
执行如下命令，通过docker-compose停止WeCmdb服务。

```
/bin/bash ./uninstall.sh
```

根据需要修改cmdb.cfg配置文件，重启服务

```
/bin/bash ./install.sh
```