# Eclipse Install Guide

## Install JDK
PLease refer to [JDK install guide](https://github.com/WeBankPartners/we-cmdb/blob/master/cmdb-wiki/docs/developer/jdk_install_guide_en.md) on how to install JDK.

## Download Eclipse

Open the following link:
	
	https://www.eclipse.org/home/index.php
to access eclipse official website, click "Download" to enter the download page.

![eclipse_download_1](images/eclipse_download_1.png)

Click “Download 64bit”
![eclipse_download_1](images/eclipse_download_2.png)

Download Eclipse
![eclipse_download_1](images/eclipse_download_3.png)

This guide takes the installation of eclipse-jee-2019-06-R-win32-x86_64 as an example.

## Installation
1. Unpacking the install package
	
	Extract the installation package as follows

	![eclipse_install_1](images/eclipse_install_1.png)

2. Double clikck eclipse.exe to start eclipse
	
	Select a directory as workspace
	
	![eclipse_install_2](images/eclipse_install_2.png)
	
	Startup Successfullt

	![eclipse_install_3](images/eclipse_install_3.png)

3. Add lombok.jar plugin
	
	Download `lombok.jar` from `https://projectlombok.org/download`.
	
	Save `lombok.jar` to the eclipse installation directory.

	![eclipse_lombok_1](images/eclipse_lombok_1.png)

	Edit the file `eclipse.ini` and add a new line:
	
	```
	-javaagent:D:\tools\eclipse\lombok.jar
	```

	Note: `D:\tools\eclipse\lombok.jar` Is the absolute path to the lombok.jar file.

	![eclipse_lombok_2](images/eclipse_lombok_2.png)

	Restart eclipse.
