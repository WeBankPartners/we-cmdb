# WeCMDB Local Standalone Package Guide


## installation
1. install JDK
	
	PLease refer to [JDK install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/developer/jdk_install_guide_en.md) on how to install JDK.

2. pull We-CMDB source code from github
	
	```shell script
    git clone git@github.com:WeBankPartners/we-cmdb.git
    ```

3. compile
	
    ```shell script
     cd we-cmdb
     mvn clean package
    ```

4. start local standalone package
    
	```shell script
    java -jar -Dspring.profiles.active=local cmdb-core/target/cmdb-core-*.jar
    ```

5. Enter the following url in the browser `http://localhost:9080/cmdb/`, start exploring WeCMDB...
      
      
## description

Specify the `spring.profiles.active=local` parameter to start the We-CMDB service. The system will start the in-memory database H2 and configure it as the system database source, initialize the schema and insert test data.