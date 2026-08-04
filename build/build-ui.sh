#!/bin/bash
set -euo pipefail
set -x

project_dir=${1:?"project directory is required"}

if command -v npm >/dev/null 2>&1; then
    cd "${project_dir}/cmdb-ui"
    "${project_dir}/build/install-ui-dependencies.sh" "${PWD}"
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
    cache_dir=${NPM_CACHE_DIR:-"${HOME}/.npm"}
    mkdir -p "${cache_dir}"
    docker run --rm \
      -v "${project_dir}:/app/cmdb" \
      -v "${cache_dir}:/root/.npm" \
      --name wecmdb-node-build \
      node:12.13.1 /bin/bash /app/cmdb/build/build-ui-docker.sh
fi
