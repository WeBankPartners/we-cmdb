current_dir=$(shell pwd)
version=$(shell bash ./scripts/version.sh)
date=$(shell date +%Y%m%d%H%M%S)
project_name=$(shell basename "${current_dir}")
remote_docker_image_registry=ccr.ccs.tencentyun.com/webankpartners/wecube-plugins-wecmdb
mkfile_path := $(abspath $(lastword $(MAKEFILE_LIST)))
mkfile_dir := $(dir $(mkfile_path))

clean:
	rm -rf $(current_dir)/target

.PHONY:build
build: clean
	mkdir -p /data/repository
	docker run --rm --name plugin-build -v /data/repository:/usr/src/mymaven/repository   -v $(mkfile_dir)/scripts/maven_settings.xml:/usr/share/maven/ref/settings-docker.xml  -v $(mkfile_dir)/../:/usr/src/mymaven -w /usr/src/mymaven maven:3.3-jdk-8 mvn -U clean install -Dmaven.test.skip=true -DbuildType=plugin -s /usr/share/maven/ref/settings-docker.xml dependency:resolve

image: build
	docker build -t $(project_name):$(version) .

s3_server_url=http://10.10.10.1:9000
s3_access_key=access_key
s3_secret_key=secret_key
cmdb_database_path=$(mkfile_dir)/../cmdb-core/src/main/resources/database/ch/

.PHONY:package
package: image
	rm -rf package
	mkdir -p package
	cd package && docker save $(project_name):$(version) -o image.tar
	cd package && cp ../register.xml .
	cd package && sed -i "s~{{VERSION}}~$(version)~g" register.xml
	cd package && sed -i "s~{{REPOSITORY}}~$(project_name)~g" register.xml
	cd ../cmdb-ui/dist && zip -r ui.zip .
	cd package && cp $(mkfile_dir)/../cmdb-ui/dist/ui.zip .
	#cd package && cat $(cmdb_database_path)/01.cmdb.schema_ch.sql $(cmdb_database_path)/02.cmdb.system.data_ch.sql $(cmdb_database_path)/03.cmdb.system.data.mysql_ch.sql $(cmdb_database_path)/04.cmdb.experience.data_ch.sql >init.sql
	cp database/init.sql package/init.sql
	cd package && zip -r $(project_name)-$(version).zip .
	docker rmi $(project_name):$(version)

upload: package
	$(eval container_id:=$(shell docker run -v $(current_dir)/package:/package -itd --entrypoint=/bin/sh minio/mc))
	docker exec $(container_id) mc config host add wecubeS3 $(s3_server_url) $(s3_access_key) $(s3_secret_key) wecubeS3
	docker exec $(container_id) mc cp /package/$(project_name)-$(version).zip wecubeS3/wecube-plugin-package-bucket
	docker stop $(container_id)
	docker rm -f $(container_id)
