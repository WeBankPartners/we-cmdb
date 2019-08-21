current_dir=$(shell pwd)
version=$(shell bash ./build/version.sh)
project_name=$(shell basename "${current_dir}" )

clean:
	rm -rf $(current_dir)/repository
	rm -rf $(current_dir)/cmdb-core/target
	rm -rf $(current_dir)/cmdb-ui/node
	rm -rf $(current_dir)/cmdb-ui/node_modules

.PHONY:build
build:
	mkdir -p repository
	docker run --rm --name my-maven-project -v $(current_dir)/build/maven_settings.xml:/usr/share/maven/ref/settings-docker.xml  -v $(current_dir):/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn -U clean install -Dmaven.test.skip=true -s /usr/share/maven/ref/settings-docker.xml dependency:resolve

image: 
	docker build -t $(project_name):$(version) .

