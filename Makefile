current_dir=$(shell pwd)
version=$(PLUGIN_VERSION)
project_dir=$(shell basename "${current_dir}")
project_name=wecmdb-pro

clean:
	rm -rf cmdb-server/cmdb-server
	rm -rf cmdb-ui/dist
	rm -rf cmdb-ui/plugin

build: clean
	chmod +x ./build/*.sh
	docker run --rm -v $(current_dir):/go/src/github.com/WeBankPartners/$(project_dir) --name build_$(project_dir) ccr.ccs.tencentyun.com/webankpartners/golang-ext:v1.15.6 /bin/bash /go/src/github.com/WeBankPartners/$(project_dir)/build/build-server.sh
	./build/build-ui.sh $(current_dir)

image: build
	docker build -t $(project_name):$(version) .

package: image
	mkdir -p plugin
	cp -r cmdb-ui/plugin/* plugin/
	cp docker-compose.tpl docker-compose.yml
	cp build/default.json default.json
	zip -r ui.zip plugin
	rm -rf plugin
	cp build/register.xml ./
	cp wiki/db/init.sql ./init.sql
	cp wiki/db/practices_structure.sql ./practices_structure.sql
	cp wiki/db/practices_demo_data.sql ./practices_demo_data.sql
	sed -i "s~{{PLUGIN_VERSION}}~$(version)~g" ./register.xml
	sed -i "s~{{REPOSITORY}}~$(project_name)~g" ./register.xml
	sed -i "s~{{version}}~$(version)~g" ./docker-compose.yml
	sed -i "s~{{PLUGIN_MODE}}~no~g" ./default.json
	sed -i "s~{{GATEWAY_URL}}~~g" ./default.json
	sed -i "s~{{JWT_SIGNING_KEY}}~~g" ./default.json
	sed -i "s~{{SUB_SYSTEM_CODE}}~~g" ./default.json
	sed -i "s~{{SUB_SYSTEM_KEY}}~~g" ./default.json
	docker save -o image.tar $(project_name):$(version)
	zip  wecube-plugins-wecmdb-$(version).zip image.tar init.sql practices_structure.sql practices_demo_data.sql register.xml docker-compose.yml default.json ui.zip
	rm -f register.xml init.sql practices_structure.sql practices_demo_data.sql ui.zip
	rm -rf ./*.tar
	rm -f docker-compose.yml
	rm -f default.json
	docker rmi $(project_name):$(version)

upload: package
	$(eval container_id:=$(shell docker run -v $(current_dir):/package -itd --entrypoint=/bin/sh minio/mc))
	docker exec $(container_id) mc config host add wecubeS3 $(s3_server_url) $(s3_access_key) $(s3_secret_key) wecubeS3
	docker exec $(container_id) mc cp /package/wecube-plugins-wecmdb-$(version).zip wecubeS3/wecube-plugin-package-bucket
	docker rm -f $(container_id)
	rm -rf wecube-plugins-wecmdb-$(version).zip
