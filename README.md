# erpnext

Custom Frappe/ERPNext Docker image, automatically built and pushed to
[ghcr.io](https://github.com/orgs/maki-it/packages).

## Default apps

By default the image contains the latest stable versions of:

| App | Repository |
|-----|-----------|
| ERPNext | <https://github.com/frappe/erpnext.git> |
| CRM | <https://github.com/frappe/crm.git> |

The default app list is maintained in [`apps.json`](./apps.json).

## Build triggers

| Event | Behaviour |
|-------|-----------|
| Push to `main` | Builds and pushes `ghcr.io/<org>/erpnext:latest` using the apps in `apps.json` |
| `workflow_dispatch` | Same as above, but you can supply a custom JSON array of apps (see below) |

## Manual build with custom apps

1. Go to **Actions → Build and Push Docker Image → Run workflow**.
2. In the *apps_json* field, paste a JSON array describing the apps you want installed, e.g.:

```json
[
  {"url": "https://github.com/frappe/erpnext.git", "branch": "version-15"},
  {"url": "https://github.com/frappe/crm.git",     "branch": "main"},
  {"url": "https://github.com/your-org/your-app.git"}
]
```

Leave the field empty to fall back to the default `apps.json`.

Each entry supports the following keys:

| Key | Required | Description |
|-----|----------|-------------|
| `url` | ✅ | Git URL of the Frappe app |
| `branch` | ❌ | Branch / tag to check out (defaults to the repository's default branch) |

## Local development

Build the image locally with the default apps:

```bash
# Linux
APPS_JSON_BASE64=$(base64 -w 0 apps.json)

# macOS
APPS_JSON_BASE64=$(base64 -i apps.json)

docker build \
  --build-arg APPS_JSON_BASE64="$APPS_JSON_BASE64" \
  -t erpnext-custom:local .
```
