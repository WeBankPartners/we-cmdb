## 修改内核参数
建议操作系统为centos7.2.建议内核版本为3.10.517以上
1. 编辑内核参数文件/etc/sysctl.conf,确认这几个选项如下：
```
net.ipv4.ip_forward=1
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables = 1
```
2. 执行命令
```
ip link add name brtest type bridge
sysctl -p
p link del dev  brtest
```

## 安装docker
1. 下载二进制包到docker目录
```
mkdir  /data/
cd /data
wget https://download.docker.com/linux/static/stable/x86_64/docker-18.06.3-ce.tgz
```
2. 解压二进制包
```
tar xzvf docker-18.06.3-ce.tgz
mv docker/* /usr/bin
```
3. 创建/etc/docker目录，创建配置文件/etc/docker/daemon.json
```
{
  "bip": "169.254.32.1/28",
  "bridge": "",
  "debug": false,
  "default-runtime": "runc",
  "exec-opts": [],
  "exec-root": "",
  "graph": "/var/lib/docker",
  "group": "",
  "insecure-registries": [],
  "ip-forward": true,
  "ip-masq": true,
  "iptables": true,
  "ipv6": false,
  "labels": [],
  "live-restore": true,
  "log-driver": "json-file",
  "log-level": "warn",
  "log-opts": {
    "max-file": "10",
    "max-size": "100m"
  },
  "registry-mirrors": [
    "https://mirror.ccs.tencentyun.com"
  ],
  "runtimes": {},
  "selinux-enabled": false,
  "storage-driver": "overlay2",
  "storage-opts": [
    "overlay2.override_kernel_check=true"
  ]
}

```
4. 创建docker服务文件/lib/systemd/system/dockerd.service
```
[Unit]
Description=dockerd

[Service]
Environment=QCLOUD_NORM_URL=
Type=notify
ExecStart=/usr/bin/dockerd --config-file=/etc/docker/daemon.json
ExecStartPre=/bin/rm -f /var/run/docker.pid
ExecStartPost=-/sbin/iptables -I FORWARD -s 0.0.0.0/0 -j ACCEPT
ExecReload=/bin/kill -s HUP $MAINPID
LimitNOFILE=1048576
LimitNPROC=1048576
LimitCORE=infinity
TimeoutStartSec=0
Delegate=yes
KillMode=process
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
```

5. 创建服务并启动服务
```
systemctl enable dockerd
systemctl start  dockerd
```

6. 运行docker version确认docker安装成功