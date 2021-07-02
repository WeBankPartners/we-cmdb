# We-cmdb独立运行指引

## 运行环境准备
#### 1. mysql数据库，version >= 5.5
#### 2. docker程序，version >= 17
#### 3. (可选) docker-compose

## 安装包准备
#### 1. 下载软件包: https://github.com/WeBankPartners/wecube-platform/releases 上最新的wecube-plugins-wecmdb包
#### 2. 解压包后里面会有 image.tar和init.sql等文件
#### 3. 在mysql上导入init.sql初始化数据库，如果是升级，请在init.sql最后面查找版本间的数据库更新脚本去执行，如果要用最佳实践上的模型和数据，请依次继续导入practices_structure.sql和practices_demo_data.sql
#### 4. 导入docker镜像
```
docker load --input image.tar
```

## docker-compose运行
#### 1. release压缩包里包含有docker-compose.yml,default.json文件，需要把里面的一些变量改一下，主要有如下几个变量
```
# docker-compose.yml
{{path}}      -> 日志和配置等映射到主机的绝对路径
{{port}}      -> 对外提供的http服务端口

# default.json
{{CMDB_MYSQL_HOST}}   -> 数据库IP
{{CMDB_MYSQL_PORT}}   -> 数据库端口
{{CMDB_MYSQL_SCHEMA}} -> 数据库名
{{CMDB_MYSQL_USER}}   -> 数据库用户
{{CMDB_MYSQL_PWD}}    -> 数据库密码
{{CMDB_LOG_LEVEL}} -> 日志级别，主要有 debug、info(默认)、warn、error
```
#### 2. 创建{{path}}/cmdb/conf文件夹并将修改完后的 default.json 复制到 {{path}}/cmdb/conf/ 里面
#### 3. 运行
```
docker-compose  -f docker-compose.yml  up -d
```
#### 4. 打开服务页面地址 http://{{ip}}:{{port}}/wecmdb
#### 5. 默认登录的用户密码是
```
user: super_admin
pass: Abcd1234
```
#### 6. 因为内置的权限是最低权限，菜单只一个授权，先给自身授权其它菜单权限，再退出重新登录