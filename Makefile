current_dir:=$(shell pwd)
version:=$(shell bash ./build/version.sh)
date:=$(shell date +%Y%m%d%H%M%S)
project_name:=$(shell basename "${current_dir}")
remote_docker_image_registry=ccr.ccs.tencentyun.com/webankpartners/wecmdb-app


clean:
	rm -rf $(current_dir)/cmdb-core/target
	rm -rf $(current_dir)/cmdb-ui/node
	rm -rf $(current_dir)/cmdb-ui/node_modules

clean_core_plugin:
	rm -rf $(current_dir)/cmdb-core/target
	rm -rf $(current_dir)/cmdb-ui/node
	rm -rf $(current_dir)/cmdb-ui/node_modules

.PHONY:build

build_name=wecmdb-build
build:
	mkdir -p repository
	docker run --rm --name $(build_name) -v /data/repository:/usr/src/mymaven/repository   -v $(current_dir)/build/maven_settings.xml:/usr/share/maven/ref/settings-docker.xml  -v $(current_dir):/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn -U clean install -Dmaven.test.skip=true -s /usr/share/maven/ref/settings-docker.xml dependency:resolve

build_core_plugin:
	mkdir -p repository
	docker run --rm --name $(build_name) -v /data/repository:/usr/src/mymaven/repository   -v $(current_dir)/build/maven_settings.xml:/usr/share/maven/ref/settings-docker.xml  -v $(current_dir):/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn -U clean install -Pcore_plugin -Dmaven.test.skip=true -s /usr/share/maven/ref/settings-docker.xml dependency:resolve

image: 
	docker build -t $(project_name):$(version) .

push:
	docker tag  $(project_name):$(version) $(remote_docker_image_registry):$(date)-$(version)
	docker push $(remote_docker_image_registry):$(date)-$(version)

env_config=smoke_branch.cfg
target_host="tcp://10.0.0.1:2375"
deploy:
	docker tag  $(project_name):$(version) $(remote_docker_image_registry):$(date)-$(version)
	docker push $(remote_docker_image_registry):$(date)-$(version)
	sh build/deploy_generate_compose.sh $(env_config) $(date)-$(version)
	docker-compose -f docker-compose.yml -H $(target_host) up -d
