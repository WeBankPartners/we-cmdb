# Maven Install Guide

## 下载Maven
打开以下链接：
	
	http://maven.apache.org/download.cgi
进入Maven下载官网。

进入官网后，根据自己的需求下载，windows系统下载二进制zip包就可以。
![maven_download](images/maven_download.png)

 

## 安装Maven
安装-解压即可 注意不要解压在中文路径下

![maven_install](images/maven_install.png)




## 环境变量配置
1. 在桌面上右击"我的电脑(计算机)-->属性"，打开控制面板，选择"高级系统设置"。
	
![jdk_config_1](images/jdk_config_1.png)

2. 在"系统属性"中选择"高级-->环境变量"
	
![jdk_config_2](images/jdk_config_2.png)

3. 在"环境变量"面板中找到"系统变量"，选择"新建"。
	
![jdk_config_3](images/jdk_config_3.png)

4. 在"新建系统变量"对话框中，变量名一栏输入:"MAVEN_HOME"，变量值找到jdk的安装路径填入。
	
	

5. 接着在"系统变量"中找到"path"变量，选中之后，点击"编辑"。
	


6. 在变量值一行的末尾输入:";%MAVEN_HOME%\bin"，必须是英文。
	
![maven_env](images/maven_env.png)

	之后确定即可。到此环境变量已经配置好了。

## 校验

运行CMD（Win+R或右下角点开始菜单的输入处），在展开的命令行窗口中，输入mvn -v,或者mvn -version，出现下图所示输出，则说明Maven安装成功。

![maven_check](images/maven_check.png)

## Maven仓库
1. 本地仓库 ：用来存储从远程仓库或中央仓库下载的插件和jar包，项目使用一些插件或jar包，优先从本地仓库查找默认本地仓库位置在 ${user.dir}/.m2/repository，${user.dir}表示windows用户目录。可以在Maven安装目录-conf-settings.xml配置本地仓库。

2. 远程仓库：如果本地需要插件或者jar包，本地仓库没有，默认去远程仓库下载。远程仓库可以在互联网内也可以在局域网内。

3. 中央仓库 ：在maven软件中内置一个远程仓库地址http://repo1.maven.org/maven2 ，它是中央仓库，服务于整个互联网，它是由Maven团队自己维护，里面存储了非常全的jar包，它包含了世界上大部分流行的开源项目构件。

![maven_settings](image/maven_settings.png)

因为中央仓库服务器在国外，如果中央仓库网速太慢，也可以用国内阿里或者腾讯的仓库




