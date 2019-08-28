#WeCMDB Developer Guide

## 准备工作
1. 安装JDK
	
	需要在开发电脑上先安装JDK，请参考[JDK安装文档](jdk_install_guide.md)

2. 安装Eclipse
	
	需要在开发电脑上先安装Eclipse，请参考[Eclipse安装文档](eclipse_install_guide.md)

3. 安装Mysql
	
	需要有一个Mysql数据库， 也可以在开发电脑上安装Mysql，请参考[Mysql安装文档](mysql_install_guide.md)

4. 安装CAS
	
	需要有一个CAS服务， 也可以在开发电脑上安装cas。dockerhub上有容器镜像，可以直接下载安装。
	
	命令如下：
	
	```
	docker pull kawhii/sso
	docker run -d --name cas -p 8443:8443 -p 8878:8080 kawhii/sso
	```
	
	CAS默认用户密码：admin/123

5. 安装node.js
	访问node.js官方网站：http://nodejs.cn/download， 下载v10.16.3版本。双击下载后的安装文件， 按默认配置进行安装。


## 导入工程
   可以直接从git上拉取代码， 也可以先将代码工程拉取到本地后， 再导入到Eclipse中， 本文以从本地导入为例。

1. 导入工程
	
	选择导入已有项目
	![wecmdb_import_1](images/wecmdb_import_1.png)
	
	选择已有maven工程
	![wecmdb_import_2](images/wecmdb_import_2.png)
	
	选择wecmdb的代码目录作为根目录
	![wecmdb_import_3](images/wecmdb_import_3.png)
	![wecmdb_import_4](images/wecmdb_import_4.png)
	
	确认后完成导入。
	![wecmdb_import_5](images/wecmdb_import_5.png)
	

2. 切换视图
	
	导入项目后，需要在 *Window > Show View* 中选择 *Project Explorer*
	![wecmdb_import_6](images/wecmdb_import_6.png)


3. 初始化数据库
	
	需要在本地或者远程的数据库上建立用户和database。
	
	参考语句：
	
	```
	create database wecmdb_dev DEFAULT CHARSET utf8 COLLATE utf8_general_ci; 

	create USER 'wecmdb'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Abcd1234';

	grant all privileges on `wecmdb_dev`.* to 'wecmdb'@'%' identified by 'Abcd1234';
	```
	
	在database上执行数据初始化脚本：
		[data_model.sql](../../../cmdb-core/database/data_model.sql)

4. 配置文件

	在 *Project Explorer* 视图中，将 *application-uat.yml* 复制一份，更名为 *application-dev.yml*
	![wecmdb_import_7](images/wecmdb_import_7.png)
	
	打开 *application-dev.yml* ，配置里面的数据库相关配置，
	
	application-dev.yml配置示例：

	```
	server:
		port: 37000
		address: localhost

	spring:
	  datasource:
	    driver-class-name: com.mysql.cj.jdbc.Driver
	    url: jdbc:mysql://127.0.0.1:3306/wecmdb_dev?characterEncoding=utf8&serverTimezone=UTC
	    username: wecmdb
	    password: password
	
	cmdb:
	  datasource:
	    schema: wecmdb_dev
	
	cas-server:
	  url: http://192.168.10.33:8080/cas
	  redirect-app-addr: localhost:37000
	  enabled: true
	```

5. 启动WeCMDB后端
	
	打开Window->Preferences窗口， 选择Java->Installed JREs，新增jdk配置，如下图
	![wecmdb_jdk_install](images/wecmdb_jdk_install.png)

	下载依赖， 如下图：
	![wecmdb_maven_install](images/wecmdb_maven_install.png)
	
	启动
	![wecmdb_start](images/wecmdb_start.png)
	
	打开 *http://localhost:37000/cmdb/swagger-ui.html* 打开 *swagger* 页面， 输入cas登录用户及密码，即可查看并测试API
	![wecmdb_swagger_ui](images/wecmdb_swagger_ui.png)


6. 启动WeCMDB前端
	
	运行CMD（Win+R或右下角点开始菜单的输入处），在展开的命令行窗口中,进入we-cmdb的代码子目录wecmbd-ui目录
	![wecmdb_ui_npm_install](images/wecmdb_ui_npm_install.png)
	
	执行npm安装命令
	
	```
	npm i
	```
	
	安装完成后， 执行命令

	
	```
	npm start
	```

	如下图：
	![wecmdb_ui_npm_start](images/wecmdb_ui_npm_start.png)

	服务已启动， 打开 *http://localhost:3000*, 可看到WeCMDB的页面
	![wecmdb_ui_web](images/wecmdb_ui_web.png)