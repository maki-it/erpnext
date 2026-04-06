#!/usr/bin/env python3
"""Install Frappe apps defined in the APPS_JSON_BASE64 environment variable."""

import base64
import json
import os
import subprocess
import sys


def install_apps() -> None:
    apps_json_base64 = os.environ.get("APPS_JSON_BASE64", "")
    if not apps_json_base64:
        print("No apps to install (APPS_JSON_BASE64 is not set).")
        return

    try:
        apps = json.loads(base64.b64decode(apps_json_base64).decode("utf-8"))
    except (ValueError, UnicodeDecodeError) as exc:
        print(f"Failed to parse APPS_JSON_BASE64: {exc}", file=sys.stderr)
        sys.exit(1)

    for app in apps:
        url = app.get("url")
        if not url:
            print(f"Skipping entry with no 'url': {app}", file=sys.stderr)
            continue

        branch = app.get("branch")
        version = app.get("version") or branch
        cmd = ["bench", "get-app", "--resolve-deps"]
        if version:
            cmd += ["--branch", version]
        cmd.append(url)

        print(f"Installing: {url}" + (f" @ {version}" if version else ""))
        subprocess.run(cmd, check=True, cwd="/home/frappe/frappe-bench")


if __name__ == "__main__":
    install_apps()
