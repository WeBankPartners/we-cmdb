# Code contributors submit guidelines

## 步骤
### fork项目
	进入we-cmdb仓库，点击右边的fork,fork的含义就是创建mfjc项目的副本作为你自已的项目
	[fork.png]
	
### fork之后的图如下图所示，从下图可以看出we-cmdb已经处于自已的github帐号库中，同时也可以发现github还标明了该库的来源，因为只有标明了来源，后面你修改了文件才有提交的路径
	[my_reposiory.png]
	
### 修改或者增加仓库里的文件，可以选择在线修改，在线修改一般适合修改量较少，这里介绍的是采用Git工具，将代码仓库下载到本地，在本地修改之后再上传上去，相关命令如下：
	mkdir myRepositories #创建myRepositories目录
	cd myRepositories #切换到myRepositories目录
	git init #创建并初始化git库
	#增加远程git仓库
	git remote add origin https://github.com/xuxuzhesi/we-cmdb.git(自己仓库地址)   [图片]
	#将远程git库下载到本地
	git pull origin master
	
### 在本地编译器修改代码后，接下来要做的就是将修改后的代码库上传上去，命令如下：
	#会将当前目录myRepositories下所有文件都增加到本地库中
	git add .
	#提交更改
	git commit -am 'commit'
	#将库上传到github上
	git push -u origin master
	
### 上传完后，再回到github网站上，可以看到刚才提交的内容：
	
	
	
	