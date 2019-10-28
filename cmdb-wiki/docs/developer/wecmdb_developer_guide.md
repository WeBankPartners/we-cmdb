# WeCMDB 开发环境配置

## 准备工作
1. 安装JDK
	
	需要在开发电脑上先安装JDK，请参考[JDK安装文档](jdk_install_guide.md)

2. 安装Eclipse
	
	需要在开发电脑上先安装Eclipse，请参考[Eclipse安装文档](eclipse_install_guide.md)

3. 安装Mysql
	
	需要有一个Mysql数据库， 也可以在开发电脑上安装Mysql，请参考[Mysql安装文档](mysql_install_guide.md)

4. 安装node.js
	
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

3. 配置文件

	在 *Project Explorer* 视图中，将 *application-local.yml* 复制一份，更名为 *application-dev.yml*
	![wecmdb_import_7](images/wecmdb_import_7.png)
	
	打开 *application-dev.yml* ，默认使用的是H2内存数据库，内容如下：

	```
    server:
      port: 9080
      address: localhost
    
    spring:
      datasource:
        platform: H2
        driver-class-name: org.h2.Driver
        url: jdbc:h2:mem:cmdb;MODE=MYSQL;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=true;MV_STORE=FALSE;INIT=CREATE SCHEMA IF NOT EXISTS wecmdb_dev\;SET SCHEMA wecmdb_dev
        username: sa
        password:
        schema: classpath:/database/01.cmdb.schema.sql
        data:
          - classpath:/database/02.cmdb.system.data.sql
          - classpath:/local/03.cmdb.system.data.h2.sql
          - classpath:/database/04.cmdb.experience.data.sql
        sql-script-encoding: utf-8
    
      jpa:
        database: MySQL
        database-platform: org.hibernate.dialect.MySQL5InnoDBDialect
        show-sql: false
        hibernate:
          ddl-auto: none
    
    cmdb:
      datasource:
        schema: wecmdb_dev
      security:
        enabled: false
        whitelist-ip-address: 127.0.0.1
	
	```

	如需要使用已存在的MYSQL数据库，可修改配置如下：
	```
    server:
      port: 9080
      address: localhost
    
    spring:
      datasource:
        driver-class-name: com.mysql.cj.jdbc.Driver
        url: jdbc:mysql://localhost:3306/wecmdb_dev?characterEncoding=utf8&serverTimezone=Asia/Shanghai
        username: root
        password: 
    
      jpa:
        database: MySQL
        database-platform: org.hibernate.dialect.MySQL5InnoDBDialect
        show-sql: false
        hibernate:
          ddl-auto: none
    
    cmdb:
      datasource:
        schema: wecmdb_dev
      security:
        enabled: false
        whitelist-ip-address: 127.0.0.1
	```
	如果你的数据库是空库，可以依次运行数据库初始化脚本：
	![wecmdb_import_8](images/wecmdb_import_8.png)

4. 启动WeCMDB后端
	
	打开Window->Preferences窗口， 选择Java->Installed JREs，新增jdk配置，如下图

	![wecmdb_jdk_install](images/wecmdb_jdk_install.png)

	下载依赖， 如下图：

	![wecmdb_maven_install](images/wecmdb_maven_install.png)
	
	启动

	![wecmdb_start](images/wecmdb_start.png)
	
	在浏览器输入 *http://localhost:9080/wecmdb/swagger-ui.html* 会跳转到登录页面

	![wecmdb_swagger_login](images/wecmdb_swagger_login.png)

	![wecmdb_swagger_ui](images/wecmdb_swagger_ui.png)


5. 启动WeCMDB前端
	
	运行CMD（Win+R或右下角点开始菜单的输入处），在展开的命令行窗口中,进入we-cmdb的代码子目录wecmdb-ui目录

	![wecmdb_ui_npm_install](images/wecmdb_ui_npm_install.png)
	
	执行npm安装命令
	
	```
	npm install
	```
	
	![wecmdb_ui_npm_install](images/wecmdb_ui_npm_install_end.png)

	安装完成后， 执行命令

	
	```
	npm start
	```

	如下图：

	![wecmdb_ui_npm_start](images/wecmdb_ui_npm_start.png)

	服务已启动， 打开 *http://localhost:3000*, 可看到WeCMDB的页面

	![wecmdb_ui_web](images/wecmdb_ui_web.png)