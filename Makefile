current_dir=$(shell pwd)
version=$(shell bash ./build/version.sh)
date=$(shell date +%Y%m%d%H%M%S)
project_name=$(shell basename "${current_dir}")
remote_docker_image_registry=ccr.ccs.tencentyun.com/webankpartners/wecmdb-app


clean:
	rm -rf $(current_dir)/cmdb-core/target
	rm -rf $(current_dir)/cmdb-ui/node
	rm -rf $(current_dir)/cmdb-ui/node_modules

.PHONY:build
build:
	mkdir -p repository
	docker run --rm --name my-maven-project -v /data/repository:/usr/src/mymaven/repository   -v $(current_dir)/build/maven_settings.xml:/usr/share/maven/ref/settings-docker.xml  -v $(current_dir):/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn -U clean install -Dmaven.test.skip=true -s /usr/share/maven/ref/settings-docker.xml dependency:resolve

image: 
	docker build -t $(project_name):$(version) .

TAG=latest
push:
	docker tag  $(project_name):$(version) $(remote_docker_image_registry):$(date)-$(version)
	docker push $(remote_docker_image_registry):$(date)-$(version)
	docker tag  $(project_name):$(version) $(remote_docker_image_registry):$(TAG)
    docker tag  $(remote_docker_image_registry):$(TAG)
