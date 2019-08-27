#jdk install guide

## 下载JDK
打开以下链接：
	
	http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
进入JDK1.8下载官网。

进入官网后，根据自己的需求下载，通常32位的系统只支持32位的jdk，64位系统可以兼容32和64。
![jdk_version_list](images/jdk_version_list.png)

本文以安装jdk-8u201-windows-x64为例。

## 安装JDK
下载后双击即可安装，如下图：
![jdk_install_1](images/jdk_install_1.png)

![jdk_install_2](images/jdk_install_2.png)

选择默认配置， 下一步， 直至安装完成。

## 环境变量配置
1. 在桌面上右击"我的电脑(计算机)-->属性"，打开控制面板，选择"高级系统设置"。
	![jdk_config_1](images/jdk_config_1.png)

2. 在"系统属性"中选择"高级-->环境变量"
	![jdk_config_2](images/jdk_config_2.png)

3. 在"环境变量"面板中找到"系统变量"，选择"新建"。
	![jdk_config_3](images/jdk_config_3.png)

4. 在"新建系统变量"对话框中，变量名一栏输入:"JAVA_HOME"，变量值找到jdk的安装路径填入。
	![jdk_config_4](images/jdk_config_4.png)

5. 接着在"系统变量"中找到"path"变量，选中之后，点击"编辑"。
	![jdk_config_5](images/jdk_config_5.png)

6. 在变量值一行的末尾输入:";%JAVA_HOME%\bin"，必须是英文。
	![jdk_config_6](images/jdk_config_6.png)

	之后确定即可。到此环境变量已经配置好了。

## 校验
运行CMD（Win+R或右下角点开始菜单的输入处），在展开的命令行窗口中，输入java –version，出现下图所示输出，则说明jdk安装成功。
![jdk_install_check](images/jdk_install_check.png)

