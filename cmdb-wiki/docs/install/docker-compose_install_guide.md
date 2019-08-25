# docker-compose安装指引

## 安装前准备
1. 准备一台linux主机， 本安装指引以腾讯云上的虚拟机为例；
2. 建议操作系统为centos7.2.建议内核版本为3.10.517以上；
3. 网络可通外网，需远程下载安装软件；
4. 安装docker1.17.03.x以上版本；
以下安装配置操作均在root用户下执行。

## 安装步骤
1. 下载docker-compose

	```
	curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
	```

2. 修改docker-compose权限

	```
	chmod +x /usr/bin/docker-compose
	```

3. 验证docker-compose是否安装成功

	```
	docker-compose --version
	```

	![docker-compose_version](images/docker-compose_version.png)