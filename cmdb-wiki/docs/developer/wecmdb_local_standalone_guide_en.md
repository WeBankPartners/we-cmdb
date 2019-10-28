# WeCMDB Local Standalone Package Guide


## Installation
1. Install Java SE Development Kit (JDK)
	
	PLease refer to [JDK install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/developer/jdk_install_guide_en.md) on how to install JDK.

2. Pull We-CMDB source code from github
	
	```shell script
    git clone git@github.com:WeBankPartners/we-cmdb.git
    ```

3. Compile
	
    ```shell script
     cd we-cmdb
     mvn clean package -Dmaven.test.skip=true
    ```

4. Start local standalone package
    
	```shell script
    java -jar -Dspring.profiles.active=local cmdb-core/target/cmdb-core-*.jar
    ```

5. Enter the following url in the browser
[http://localhost:9080/wecmdb/](http://localhost:9080/wecmdb/)
      

>**Note**
Specify the `spring.profiles.active=local` parameter to start the We-CMDB service. The system will start the in-memory database H2 and configure it as > the system database source, initialize the schema and insert test data.