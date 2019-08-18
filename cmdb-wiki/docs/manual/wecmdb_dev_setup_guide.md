# WeCMDB Developer Guide

## 介绍
WeCMDB主要使用Java进行研发，前端为React JS，数据库是MySQL，并依赖Tomcat运行。<br>
搭建WeCMDB研发环境分为3个步骤 - Java开发环境，搭建数据库，运行Tomcat
## Java开发环境
### Step 1：下载必要软件：<br>
    1, 从Oracle网站下载[Java SDK](https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html)（1.8以上）
    <br>
    2, 下载IDE，本工程不绑定IDE工具，推荐[IntelliJ社区版本](https://www.jetbrains.com/idea/)。
    <br>
    3，[下载Git](https://git-scm.com/downloads)，如果国内下载太慢，推荐[腾讯电脑管家下载](https://pc.qq.com/detail/13/detail_22693.html)。<br>
### Step 2：配置IDE：<br>
    打开IntelliJ：<br>
    1，配置Java Compiler：Ctrl+Shift+ALT+S打开Project Structure，然后在“Platform Setting - SDKs”中设置已经按照的Java SDK。最后在“Project Setting - Project”中设定配置的SDK。<br>
    2，配置Git：Settings-> Verstion Control中配置Github账号等信息，然后从Git创建项目：File -> New -> Project from Version Control -> Git。<br>
### Step 3：启动编译和运行自动化测试:
    1, 确认Maven插件已经安装，点击 - Reimport ALL Maven Projects <br>
    2, IDE会自行下载和编译整个工程，第一次需要下载比较多的依赖包，会需要大概30分钟。<br>
    3，找到测试类 - \we-cmdb\cmdb-core\src\test\java，右键点击 - “Run All Tests”<br>
    4, 确认所有测试执行成功。
<br>
## 搭建数据库
TODO

## 运行Tomcat
TODO

