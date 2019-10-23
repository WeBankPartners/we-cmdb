# WeCMDB Developer Guide

## Preparation
1. install JDK
	
	PLease refer to [JDK install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/developer/jdk_install_guide_en.md) on how to install JDK.

2. install Eclipse
	
	PLease refer to [Eclipse install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/developer/eclipse_install_guide_en.md) on how to install Eclipse.

3. install Mysql
	
	PLease refer to [Mysql install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/developer/mysql_install_guide_en.md) on how to install Mysql.

4. install node.js
	
	Download node.js v10.16.3 from `http://nodejs.cn/download`. Double-click the downloaded installation file to install it by default configuration.



## import project
   You can pull the code directly from git, or you can pull the code project to the local and then import it into Eclipse. This article takes local import as an example.

1. project import
	
	Choose to import an existing project
	![wecmdb_import_1](images/wecmdb_import_1.png)
	
	Choose an existing maven project
	![wecmdb_import_2](images/wecmdb_import_2.png)
	
	Select the code directory of wecmdb as the root directory 

	![wecmdb_import_3](images/wecmdb_import_3.png)
	![wecmdb_import_4](images/wecmdb_import_4.png)
	
	Confirm and complete the import.
	![wecmdb_import_5](images/wecmdb_import_5.png)
	
	After the project is imported, the dependencies and compilations are automatically downloaded. Make sure the network connection is normal.

2. switch view
	
	After the project is imported, open the menu *Window > Show View*, choose *Project Explorer*
	![wecmdb_import_6](images/wecmdb_import_6.png)


3. initialize the database
	
	Users and databases need to be built on a local or remote database.
	
	sample sql as follows：
	
	```
	create database wecmdb_dev DEFAULT CHARSET utf8 COLLATE utf8_general_ci; 

	create USER 'wecmdb'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Abcd1234';

	grant all privileges on `wecmdb_dev`.* to 'wecmdb'@'%' identified by 'Abcd1234';
	```
	
	Execute the following data initialization script on the database：
		[data_model.sql](../../../cmdb-core/database/data_model.sql)

4. config files

	In *Project Explorer* view，copy *application-uat.yml* and rename as *application-dev.yml*
	![wecmdb_import_7](images/wecmdb_import_7.png)
	
	Edit *application-dev.yml* ，Modify the relevant configuration, without CAS in development mode, you can remove the CAS related configuration.
	
	application-dev.yml sample as follows：

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
	
	```

5. start WeCMDB backend
	
	Open Window->Preferences， choose Java->Installed JREs，add new jdk config as follows:
	![wecmdb_jdk_install](images/wecmdb_jdk_install.png)

	Download dependencies, compile, as follows：

	![wecmdb_maven_install](images/wecmdb_maven_install.png)
	
	start service

	![wecmdb_start](images/wecmdb_start.png)
	
	Enter the following url in the browser  *http://localhost:37000/cmdb/swagger-ui.html* Will redirect to the login page

	![wecmdb_swagger_login](images/wecmdb_swagger_login.png)

	Confirm after entering the user, will be redirected to the home page

	![wecmdb_swagger_redirect](images/wecmdb_swagger_redirect.png)

	Enter the following url again in the browser  *http://localhost:37000/cmdb/swagger-ui.html* , Go to the swagger page

	![wecmdb_swagger_ui](images/wecmdb_swagger_ui.png)


6. start WeCMDB frontend
	
	Run CMD (Win+R or the bottom right corner of the start menu entry), in the expanded command line window, enter the we-cmdb code subdirectory wecmdb-ui.

	![wecmdb_ui_npm_install](images/wecmdb_ui_npm_install.png)
	
	install npm
	
	```
	npm install
	```
	
	![wecmdb_ui_npm_install](images/wecmdb_ui_npm_install_end.png)

	After the installation is complete, execute the command

	
	```
	npm start
	```

	as follows：

	![wecmdb_ui_npm_start](images/wecmdb_ui_npm_start.png)

	Service started, open *http://localhost:3000*, go to the WeCMDB home page

	![wecmdb_ui_web](images/wecmdb_ui_web.png)