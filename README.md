# erpnext

Custom Frappe/ERPNext Docker image, automatically built and pushed to
[ghcr.io](https://github.com/maki-it/erpnext/pkgs/container/erpnext).

## Installed apps

See [apps.json](./apps.json) for the default list of apps included in the image. 
You can customize this list by modifying `apps.json` and rebuilding the image (see below).

## Versioning

App versions in `apps.json` are pinned to specific release tags (e.g. `v16.12.0`).
[Frappe Framework](https://github.com/frappe/frappe) version is pinned in `frappe-version.txt` (e.g. `v16.0.0`)

### Renovate

[Renovate](https://docs.renovatebot.com/) is configured via [`renovate.json`](./renovate.json)
to watch those tags and automatically open a pull request whenever a new release is published
upstream. Merging the PR into `main` triggers a new Docker image build and push.

## Local image build

1. Clone this repository with submodules:
2. Define custom apps in `apps.json` (optional, see above).
4. Build the image:
```bash
docker build \
 --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 --build-arg=FRAPPE_BRANCH=$(cat frappe-version.txt) \
 --build-arg=APPS_JSON_BASE64=$(base64 -w 0 apps.json) \
 --tag=custom:15 \
 --file=images/layered/Containerfile .
```
