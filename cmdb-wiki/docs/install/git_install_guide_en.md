# Git Install Guide

Git is a free and open source distributed version control system designed to handle everything from small to very large projects with speed and efficiency.

This installation guide uses the virtual machine on `Tencent Cloud` as an example.


## Before installation

You should prepare a Linux host with the Internet connection.

The following installation and configuration operations are performed under the `root` user.


## Installation
1. Dependency package installation:

    ```shell script
    yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
    yum -y install gcc perl-ExtUtils-MakeMaker
    ```

2. Delete existing git:

    ```shell script
    yum remove git
    ```

3. Download git source code:

    ```shell script
    # Switch directory
    cd /usr/src
    
    # Download the installation package：
    wget https://www.kernel.org/pub/software/scm/git/git-2.8.3.tar.gz
    ```

4. Configuration and installation:

    ```shell script
    # Unpacking the install package
    tar -zxvf git-2.8.3.tar.gz
   
    # Configuring the installation path：
   
    cd git-2.8.3
    ./configure prefix=/usr/local/git/
   
    # Compile and install：
   
    make && make install
    ```

5. Add the git directive to the user bash:

    ```shell script
    vi /etc/profile
    
    # Join in the last line
    export PATH=$PATH:/usr/local/git/bin
    
    # Execute the following command to make the configuration take effect immediately
    source /etc/profile
    ```

6. Check git version:

    ```shell script
    git --version
    ```
    
    If the version of git display normally, the installation configuration has been successful.

    ![git_version](images/git_version.png)

7. Initialize the local repository:

    ```shell script
    # Create a new Git repository in the current directory
    git init
    ```
