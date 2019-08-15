## WeCMDB Install Guide
 
 ## 安装前准备
 1. 准备好一台主机最少资源配置为4核8GB。
 2. 操作系统版本可以为ubuntu16.04以上或centos7.3以上，
 3. 建议网络可通外网(需从外网下载docker运行镜像)。
 4. 安装docker1.17.03.x以上，
 5. 安装docker-compose命令。
 
 ## 安装过程
 1. 通过github拉取WeCMDB代码。
 2. 进入代码目录，编辑cmdb-core.cfg文件，cmdb-core.cfg中的配置项如下，根据主机环境替换掉相关的值：
 
 配置项                    |说明
 -------------------------|--------------------
 cas_url                  |cas登录服务器的url,docker-compose.tpl中已经自带一个cas服务器，默认用户名为admin，密码为123，如果要使用该服务器，此处的ip填主机ip即可;
 cmdb_core_external_port  |cmdb的外部访问端口
 cmdb_image_name          |cmdb的docker镜像名称
 cmdb_core_exteranl_ip    |cmdb的访问ip，cas单点登录成功后的回跳地址；如果是局域网里访问填vm的局域网ip，如果是公网访问需填公网ip
 cmdb_ip_whitelists       |调用cmdb api接口的ip白名单，wecube-core需要调用cmdb的api接口，此处填上wecube-core运行主机的ip地址
 database_image_name      |cmdb运行时对应的数据库docker镜像
 database_user_password   |cmdb运行时对应的数据库密码
 
 3. 执行如下命令，通过docker-compose拉起WeCMDB服务。
 ```
 /bin/bash ./install.sh
 ```
 
 4. 安装完成后，访问WeCMDB的url http://ip:port/cmdb确认页面正常显示。
