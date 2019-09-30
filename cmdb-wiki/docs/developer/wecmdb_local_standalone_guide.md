# WeCMDB Local Standalone Package Guide

## 步骤
1. 安装JDK
	
	需要在开发电脑上先安装JDK，请参考[JDK安装文档](jdk_install_guide.md)

2. 克隆CMDB代码
	
	```shell script
    git clone git@github.com:WeBankPartners/we-cmdb.git
    ```

3. 运行本地编译
	
    ```shell script
     cd we-cmdb
     mvn clean package
    ```

4. 启动本地快速体验包
    ```shell script
    java -jar -Dspring.profiles.active=local cmdb-core/target/cmdb-core-*.jar
    ```
   
## 说明
指定spring.profiles.active=local参数启动CMDB，系统会启动内存数据库H2并配置为系统数据库源，初始化schema以及插入测试数据。