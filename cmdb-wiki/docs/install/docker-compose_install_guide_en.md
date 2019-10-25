# Docker-compose Install Guide

## Before installation
This installation guide uses the virtual machine on `Tencent Cloud` as an example.

1. Linux server with the Internet connection.
2. CentOS 7.2+ is preferred.
3. Kernel version should be 3.10.517 or higher.
4. Docker 1.17.03.x or higher ([docker install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/install/docker_install_guide_en.md)).

The following installation and configuration operations are performed under the `root` user.

## Installation
1. Download docker-compose

	```shell script
	curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
	```

2. Modify docker-compose execution authority

	```shell script
	chmod +x /usr/bin/docker-compose
	```

3. Check docker-compose command

	```shell script
	docker-compose --version
	```

	![docker-compose_version](images/docker-compose_version.png)