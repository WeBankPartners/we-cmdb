# Git安装指引

Git是一个开源的分布式版本控制系统，可以有效、高速的处理从很小到非常大的项目版本管理，是目前使用范围最广的版本管理工具。

## 安装前准备
1. 准备一台linux主机， 本安装指引以腾讯云上的虚拟机为例。
2. 网络可通外网，需下载git软件。
以下安装配置操作均在root用户下执行。

## 安装配置
1. 安装依赖包

```
yum -y install curl-devel expat-devel gettext-devel openssl-devel zlib-devel
yum -y install gcc perl-ExtUtils-MakeMaker
```

2. 删除已有的git

```
yum remove git
```

3. 下载git源码

切换目录：

```
cd /usr/src
```

下载安装包：

```
wget https://www.kernel.org/pub/software/scm/git/git-2.8.3.tar.gz
```

4. 配置安装

解压安装包：

```
tar -zxvf git-2.8.3.tar.gz

```

配置git安装路径：

```
cd git-2.8.3
./configure prefix=/usr/local/git/
```

编译安装：

```
make && make install
```

git已经安装完毕。


5. 将git指令添加到用户bash中

```
vi /etc/profile
```

在最后一行加入

```
export PATH=$PATH:/usr/local/git/bin
```

执行以下命令让该配置文件立即生效

```
source /etc/profile
```

6. 检查

查看git版本号：

```
git --version
```

能显示git的版本， 则安装配置已成功。
![git_version](images/git_version.png)

7. 初始化本地代码库

在当前目录新建一个Git代码库

```
git init
```