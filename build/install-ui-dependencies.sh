#!/bin/bash
set -euo pipefail

ui_dir=${1:?"ui directory is required"}
cache_dir=${NPM_CACHE_DIR:-"${HOME}/.npm"}

cd "${ui_dir}"
mkdir -p "${cache_dir}"

# Reinstall only when the dependency definition or the runtime used to install
# it changes. This keeps a Jenkins workspace/node_modules cache reusable while
# still preventing dependency reuse across incompatible Node/npm versions.
dependency_fingerprint=$( {
  sha256sum package.json package-lock.json
  node --version
  npm --version
} | sha256sum | awk '{print $1}')
fingerprint_file=node_modules/.wecmdb-ui-dependencies

if [[ -d node_modules && -f "${fingerprint_file}" && "$(<"${fingerprint_file}")" == "${dependency_fingerprint}" ]]; then
  echo "Reuse existing UI dependencies"
  exit 0
fi

echo "Install UI dependencies"
npm install \
  --registry https://registry.npmmirror.com \
  --cache "${cache_dir}" \
  --prefer-offline \
  --no-audit \
  --no-fund

printf '%s\n' "${dependency_fingerprint}" > "${fingerprint_file}"
