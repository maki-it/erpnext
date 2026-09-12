# erpnext

Custom Frappe/ERPNext Docker image, automatically built and pushed to
[ghcr.io](https://github.com/maki-it/erpnext/pkgs/container/erpnext).

## Installed apps

See [apps.json](./apps.json) for the default list of apps included in the image. 
You can customize this list by modifying `apps.json` and rebuilding the image (see below).

## Versioning

Apps in `apps.json` and [Frappe Framework](https://github.com/frappe/frappe) in `frappe-version.txt` track their respective `develop` branches. Each image build resolves the latest commit available on those branches.

### Renovate

[Renovate](https://docs.renovatebot.com/) is configured via [`renovate.json`](./renovate.json)
to update the `frappe_docker` submodule. App and framework repositories track `develop` directly,
so they do not need Renovate updates.

## Local image build

1. Clone this repository with submodules:
2. Define custom apps in `apps.json` (optional, see above).
3. Build the image:
```bash
docker build \
 --build-arg=FRAPPE_PATH=https://github.com/frappe/frappe \
 --build-arg=FRAPPE_BRANCH=$(cat frappe-version.txt) \
 --secret=id=apps_json,src=apps.json \
 --tag=custom:develop \
 --file=frappe_docker/images/layered/Containerfile frappe_docker
```
