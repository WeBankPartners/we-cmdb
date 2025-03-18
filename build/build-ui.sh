#!/bin/bash
set -e -x
npm -v
if [ $? -eq 0 ]
then
    cd $1/cmdb-ui
    # npm install --force
    npm run build
    cd dist
    mkdir -p wecmdb
    mv js css img fonts favicon.ico wecmdb-background.png wecmdb/
    cd ..
    mv dist dist_tmp
    npm run plugin
    mv dist plugin
    mv dist_tmp dist
else
    docker run --rm -v $1:/app/cmdb --name wecmdb-node-build node:12.13.1 /bin/bash /app/cmdb/build/build-ui-docker.sh
fi