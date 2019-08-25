# 用Eclipse搭建并运行项目

1. [安装Java运行环境](#checkJava)
2. [安装Eclipse并运行项目](#installEclipse)

[1]:https://www.cnblogs.com/quickcodes/p/5127101.html "点此查看如何下载并安装JDK"
[2]:https://www.cnblogs.com/quickcodes/p/5399385.html "点此查看如何下载、安装及配置Eclipse"
[Eclipse]:https://www.eclipse.org/home/index.php "Eclipse官网"

## <span id="checkJava">检查是否安装Java运行环境</span>
1. 打开终端，输入`java -version`
2. 如果出现java版本号，则说明已安装。以下两个红框依次为：
	- 我们输入的命令
	- java版本号（需要**1.8**以上jdk）
![](./imgs/check-java.png)
3. 如果出现弹框提示，则需要[安装JDK](#installJdk)
4. 若已安装jdk，则需要[下载Eclipse](#installEclipse)



## <span id="checkJdkPath">检查JDK安装路径</span>
1. 打开终端，输入`/usr/libexec/java_home -V`
2. 出现以下结果，三个红框分别为：
	- 我们输入的命令
	- 已安装的JDK目录
	- Mac默认使用的JDK版本
![](./imgs/check-jdk.png)

## <span id="installEclipse">下载并安装Eclipse</span>
1. [打开Eclipse官网][Eclipse]
2. 点击右上角 *DOWNLOAD* 按钮
![](./imgs/download-eclipse1.png)
3. 点击 *Download 64 bit* 按钮
![](./imgs/download-eclipse2.png)
4. 点击 *Download* 按钮
![](./imgs/download-eclipse3.png)
5. 下载完成后，打开下载的 *.dmg* 文件，并将*Eclipse Installer*文件拖入*应用程序*，如下图所示
![](./imgs/install-eclipse1.png)
6. 进入应用程序
![](./imgs/install-eclipse2.png)
7. 点击安装器开始安装Eclipse，第一次安装时需要设置安装路径，建议和
![](./imgs/install-eclipse3.png)
8. 选择安装路径，并开始下载
![](./imgs/install-eclipse4.png)
9. 下载完成后，在刚刚设置的安装目录下打开Eclipse
![](./imgs/set-eclipse1.png)
10. 接下来便可[导入项目](#importProject)了

## <span id="importProject">导入并运行项目</span>
1. 导入我们的项目，选择cmdb作为根目录
![](./imgs/set-eclipse2.png)
![](./imgs/set-eclipse3.png)
![](./imgs/set-eclipse4.png)
![](./imgs/set-eclipse5.png)
![](./imgs/set-eclipse6.png)
2. 导入项目后，需要在 *Window > Show View* 中选择 *Project Explorer*
![](./imgs/set-eclipse7.png)
3. 在 *Project Explorer* 视图中，将 *application-uat.yml* 复制一份，更名为 *application-dev.yml*
4. 打开 *application-dev.yml* ，配置里面的数据库相关配置，并关闭鉴权（`enabled: true` -> `enabled: false`）
![](./imgs/set-eclipse8.png)
5. 启动我们的CMDB吧
![](./imgs/cmdb-start.png)
6. 启动完成后，打开 *http://localhost:37000/cmdb/swagger-ui.html* 打开 *swagger* 页面即可查看并测试API
![](./imgs/cmdb-swagger-ui.png)


## <span id="installJdk">安装JDK</span>
[点此查看如何安装JDK][1]