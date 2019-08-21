## 安装docker-compose
1. 下载docker-compose
```
curl -L https://github.com/docker/compose/releases/download/1.25.0-rc2/docker-compose-`uname -s`-`uname -m` -o /usr/bin/docker-compose
```
2. 修改docker-compose权限
```
chmod +x /usr/bin/docker-compose
```
3. 验证docker-compose是否安装成功
```
docker-compose --version
```