# WeCmdb安装指引
WeCmdb运行环境包括3个组件,这3个组件都已做成docker镜像,本安装指引通过docker-compose的方式启动这三个容器，不需要再单独安装mysql和cas服务。
- mysql服务
- cas服务，提供单点登陆功能
- WeCmdb服务

 ## 安装前准备
 1. 准备好一台主机最少资源配置为4核8G。
 2. 操作系统版本至少为centos7.2以上
 3. 建议网络可通外网(需从外网下载docker运行镜像)。
 4. 安装docker命令，请参考[docker安装文档](docker_install_guide.md)
 5. 安装docker-compose命令，请参考[docker-compose安装文档](docker-compose_install_guide.md)
 6. 安装git客户端
 ```
 yum install -y git
 ```
 
 ## 安装过程
 1. 从github拉取WeCmdb代码
 ```
 git clone https://github.com/WeBankPartners/we-cmdb.git
 ```

 2. 进入代码目录下的build目录，编辑cmdb.cfg文件该文件包含的配置项如下，用户根据各自部的部署环境替换掉相关值：
 
 配置项                    |说明
 -------------------------|--------------------
 cas_url                  |单点登陆cas服务器url,docker-compose.tpl中已经自带cas服务器，默认用户名为admin，密码为123，如果要使用该服务器，此处的ip地址填部署主机的ip;
 cmdb_server_ip           |cmdb的服务ip，cas单点登录成功后的回跳地址；如果浏览器是通过局域网访问，该值填部署主机的局域网ip;如果是公网访问需填公网可访问的ip地址，如LB的ip
 cmdb_server_port         |cmdb的服务端口
 cmdb_image_name          |cmdb的docker镜像名称
 cmdb_ip_whitelists       |第三方服务如果要调用cmdb的api，需将第三方服务的访问ip加到此处，如果有多个服务，中间用逗号隔开
 database_image_name      |cmdb依赖的数据库docker镜像名称
 database_init_password   |cmdb依赖的数据库root用户的初始化密码


 3. 执行如下命令，通过docker-compose拉起WeCMDB服务。
 ```
 /bin/bash ./install.sh
 ```
 
 4. 安装完成后，访问WeCMDB的url，确认页面访问正常 http://cmdb_server_ip:cmdb_server_port/cmdb
