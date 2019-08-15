# WeCMDB Compile Guide

## 编译前准备
1. 准备好一台主机最少资源配置为4核8GB。
2. 操作系统版本可以为ubuntu16.04以上或centos7.3以上。
3. 建议网络可通外网(需从外网下载docker运行镜像)。
4. 安装docker1.17.03.x以上。

## 编译过程
1. 通过github拉取WeCMDB代码。
2. 进入代码目录，执行make build 等待编译完成，make build过程中会从外网拉取maven包和npm包，如果有更快的mvn源，建议修改build目录下的maven_setting.xml文件。
3. 编译完成后，执行make image，将制作WeCMDB的运行镜像。
