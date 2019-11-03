# WeCMDB 快速本地启动环境配置

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
     mvn clean package -Dmaven.test.skip=true
    ```

4. 启动本地快速体验包
    ```shell script
    java -jar -Dspring.profiles.active=local cmdb-core/target/cmdb-core-*.jar
    ```

5. 打开浏览器，输入下面的URL,即可体验WeCMDB功能  
  
   [http://localhost:9080/wecmdb/](http://localhost:9080/wecmdb/)
    
      
> **说明**
指定spring.profiles.active=ch-local参数启动CMDB，系统会启动内存数据库H2并配置为系统数据库源，初始化schema以及插入体验数据。
