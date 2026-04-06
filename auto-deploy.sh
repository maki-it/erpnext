#!/usr/bin/env bash

# https://github.com/frappe/frappe_docker/issues/1640#issuecomment-3303368460

set -eo pipefail

cp apps.json frappe_docker/apps.json
cd frappe-docker

wget https://raw.githubusercontent.com/frappe/bench/develop/easy-install.py

python3 easy-install.py build \
  --frappe-branch=version-16 \
  --python-version=3.14.2 \
  --node-version=24.14.1 \
  --apps-json=apps.json

python3 easy-install.py deploy \
  --image=custom-apps \
  --version=latest \
  --no-ssl --http-port=8080 \
  --project erp-with-crm \
  --sitename=erp-demo.maki-it.de \
  --app=erpnext \
  --app=crm