# Mysql Install Guide


## Download the installation package

Open the following link:
	https://dev.mysql.com/downloads/mysql/
to access eclipse official website,
![mysql_download_1](images/mysql_download_1.png)

, click the link to enter the download page.
![mysql_download_2](images/mysql_download_2.png)

This guide takes the installation of mysql-installer-community-8.0.17.0.msi as an example.


## Installation
1. Double click to install, as shown below:
	![mysql_install_1](images/mysql_install_1.png)

2. Agree to the license agreement, the next step
	![mysql_install_2](images/mysql_install_2.png)

3. Default, next step
	![mysql_install_3](images/mysql_install_3.png)

4. Next step
	![mysql_install_4](images/mysql_install_4.png)

5. Click `Execute`, wait for the installation to complete, next step
	![mysql_install_5](images/mysql_install_5.png)

6. Configuration, next step
	![mysql_install_6](images/mysql_install_6.png)

7. Mysql Server Configuration
	Enter Mysql Server Configuration Page
	![mysql_install_config_1](images/mysql_install_config_1.png)

	In the Mysql Server configuration step, configure all defaults, set the password of the root account, until the configuration is complete, click to execute
	![mysql_install_config_2](images/mysql_install_config_2.png)

	Mysql Server Configuration complete
	![mysql_install_config_3](images/mysql_install_config_3.png)

8. Mysql Router Configuration
	![mysql_install_6](images/mysql_install_6.png)

	Default configuration, click to complete
	![mysql_install_config_4](images/mysql_install_config_4.png)

9. Mysql Router Configuration
	![mysql_install_6](images/mysql_install_6.png)

	Enter the password of the root user just set, click `check`, test the connection is successful, the next step
	![mysql_install_config_5](images/mysql_install_config_5.png)

	Click `Execute`, then click `Finish`.
	![mysql_install_config_6](images/mysql_install_config_6.png)

10. back to the Install Page
	![mysql_install_6](images/mysql_install_6.png)
	
	Click `Next`, then click `finish`
	![mysql_install_7](images/mysql_install_7.png)

11.Installation Complete
	After the installation is complete, the command line and workbench interface are automatically opened.

	![mysql_install_8](images/mysql_install_8.png)
	![mysql_install_9](images/mysql_install_9.png)
	

## Check

1. In the workbench interface, choose `local instance`
	![mysql_mgmt_1](images/mysql_mgmt_1.png)

2. Enter the management interface to view service status, client connections, user permissions, and more.
	![mysql_mgmt_2](images/mysql_mgmt_2.png)

3. View the current schema list as follows
	![mysql_mgmt_3](images/mysql_mgmt_3.png)
