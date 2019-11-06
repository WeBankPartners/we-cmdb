# Maven Install Guide

## Maven Download
Open the following official website link:  
http://maven.apache.org/download.cgi  

Download the zip package according to your OS system. e.g. download binary zip for Windows system.  
![maven_download](images/maven_download.png)

 

## Maven installation
Extract the package any location as you want:

![maven_install](images/maven_install.png)

## Configure maven environment variables
1. Right-click on 'Computer' on the desktop and choose 'Properties' , select 'Advanced System Settings' in the opened console.  

![jdk_config_1](images/jdk_config_1.png)

2. Select "Advanced -> Environment Variable" from "System Properties"
	
![jdk_config_2](images/jdk_config_2.png)

3. In the Environment Variables panel, go to System Variables and select 'New'.

![jdk_config_3](images/jdk_config_3.png)

4. In the "New System Variables" dialog box, input "MAVEN_HOME" as variable name, while the value is your Maven installation path. In my example, it is "D:\xusizhe\java\apache-maven-3.6.2"

5. In the "System Variables", select 'path' to edit by appending "; %MAVEN_HOME%\bin" at the end.
	
![maven_env](images/maven_env.png)

6. Click 'OK' to save the configuration.

> Now all the configuration are ready.

## Maven check

Run CMD (Win+R or the input of the start menu in the lower right corner), enter mvn-v or mvn-version in the expanded command line window, and output as shown in the figure below will show that Maven has been successfully installed.

![maven_check](images/maven_check.png)

## Maven Repository
1. Local Repository  
It is used for storing the plug-ins and jars downloaded from the remote repository or the central repository. The project USES some plug-ins or jars. Priority is given to finding the default local repository from the local repository at ${user.dir}/.m2/repository. Local repositories can be configured in the Maven installation directory -conf-settings.xml.

2. Remote Repository:  
If a plug-in or jar is needed locally, which is not available in the local repository, download it from the remote repository by default. Remote repositories can be either over the Internet or over a local area network.

3. Central Repository: 
In maven software built-in a remote warehouse address in http://repo1.maven.org/maven2, it is a central repository, service on the Internet, it is by maven team maintenance, stored inside a very full of jars, it contains the world's most popular open source project artifacts.

![maven_settings](image/maven_settings.png)


