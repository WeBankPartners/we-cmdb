# Mysql Install Guide

## 下载安装包
打开以下链接：
	https://dev.mysql.com/downloads/mysql/
进入Mysql下载官网。
![mysql_download_1](images/mysql_download_1.png)

点击进入下载页面
![mysql_download_2](images/mysql_download_2.png)

本文以安装mysql-installer-community-8.0.17.0.msi为例。


## 安装
1. 下载后双击即可安装，如下图：
	![mysql_install_1](images/mysql_install_1.png)

2. 同意许可协议， 下一步
	![mysql_install_2](images/mysql_install_2.png)

3. 默认， 下一步
	![mysql_install_3](images/mysql_install_3.png)

4. 继续下一步
	![mysql_install_4](images/mysql_install_4.png)

5. 点击执行，等待安装完成后， 下一步
	![mysql_install_5](images/mysql_install_5.png)

6. 配置，下一步
	![mysql_install_6](images/mysql_install_6.png)

7. Mysql Server配置
	进入Mysql Server配置页
	![mysql_install_config_1](images/mysql_install_config_1.png)

	在Mysql Server配置步骤中， 配置全部默认， 设置root账号的密码， 直至配置完成，点执行
	![mysql_install_config_2](images/mysql_install_config_2.png)

	Mysql Server配置完成
	![mysql_install_config_3](images/mysql_install_config_3.png)

8. Mysql Router配置
	![mysql_install_6](images/mysql_install_6.png)

	默认配置， 点击完成
	![mysql_install_config_4](images/mysql_install_config_4.png)

9. Mysql Router配置
	![mysql_install_6](images/mysql_install_6.png)

	输入刚刚设置的root用户的密码， 点击check， 测试连接成功，下一步
	![mysql_install_config_5](images/mysql_install_config_5.png)

	点击执行，然后点击完成
	![mysql_install_config_6](images/mysql_install_config_6.png)

10. 回到安装界面
	![mysql_install_6](images/mysql_install_6.png)
	
	下一步，然后点完成
	![mysql_install_7](images/mysql_install_7.png)

11.安装完成
	安装完成后， 自动打开命令行和workbench界面
	![mysql_install_8](images/mysql_install_8.png)
	![mysql_install_9](images/mysql_install_9.png)
	

## 检查

1. 在workbench界面中， 点击本地实例
	![mysql_mgmt_1](images/mysql_mgmt_1.png)

2. 进入管理界面， 可查看服务状态，客户端连接，用户权限等。
	![mysql_mgmt_2](images/mysql_mgmt_2.png)

3. 查看当前的schema列表
	![mysql_mgmt_3](images/mysql_mgmt_3.png)
