# Docker安装指引

## 安装前准备
1. 准备一台linux主机， 本安装指引以腾讯云上的虚拟机为例；
2. 建议操作系统为centos7.2.建议内核版本为3.10.517以上；
3. 网络可通外网，需远程下载安装软件；
以下安装配置操作均在root用户下执行。


## 安装步骤
1. 下载二进制包到本地

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

3. 创建/etc/docker目录，创建配置文件/etc/docker/daemon.json，将下列内容拷贝到文件中

	```
	{
	  "bip": "10.0.0.1/28",
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

4. 创建docker服务文件/lib/systemd/system/dockerd.service，将下列内容拷贝到文件中

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

5. 创建服务并启动

	```
	systemctl enable dockerd
	systemctl start  dockerd
	```

6. 运行命令确认docker安装成功
	```
	docker --version
	```
	![docker_version](images/docker_version.png)

## 设置内核参数

1. 编辑内核参数文件/etc/sysctl.conf,确认这几个选项如下：

	```
	net.ipv4.ip_forward=1
	net.bridge.bridge-nf-call-ip6tables = 1
	net.bridge.bridge-nf-call-iptables = 1
	```
2. 执行命令
	
	```
	sysctl -p
	```
