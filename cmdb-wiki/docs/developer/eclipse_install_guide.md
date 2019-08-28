# Eclipse Install Guide

## 安装JDK
需要在开发电脑上先安装JDK，请参考[JDK安装文档](jdk_install_guide.md)

## 下载Eclipse

打开以下链接：
	
	https://www.eclipse.org/home/index.php
进入Eclipse官网。

点击“Download”，进入下载页。
![eclipse_download_1](images/eclipse_download_1.png)

点击“Download 64bit”
![eclipse_download_1](images/eclipse_download_2.png)

下载软件
![eclipse_download_1](images/eclipse_download_3.png)

本文以安装eclipse-jee-2019-06-R-win32-x86_64为例。

## 安装Eclipse
1. 解压
	
	下载完成之后，解压安装包，解压路径随意，打开解压好的eclipse文件夹，选中eclipse.exe文件，在桌面创建快捷方式，Eclipse的安装完成。

	![eclipse_install_1](images/eclipse_install_1.png)

2. 双击eclipse.exe运行
	
	配置工作区目录
	
	![eclipse_install_2](images/eclipse_install_2.png)
	
	启动成功

	![eclipse_install_3](images/eclipse_install_3.png)

3. 添加lombok.jar插件
	
	下载lombok.jar，可以访问https://projectlombok.org/download进行下载。
	
	下载后， 将lombok.jar保存到eclipse的安装目录下

	![eclipse_lombok_1](images/eclipse_lombok_1.png)

	编辑eclipse.ini文件，添加一行：
	
	```
	-javaagent:D:\tools\eclipse\lombok.jar
	```

	其中，"D:\tools\eclipse\lombok.jar"是lombok.jar文件的绝对路径。

	![eclipse_lombok_2](images/eclipse_lombok_2.png)

	重启eclipse。
