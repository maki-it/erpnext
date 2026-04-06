#!/usr/bin/env python3
"""Invoke easy-install.py build with the tags and options from the environment."""

import os
import subprocess
import sys


def main() -> None:
    for required in ("TAGS", "FRAPPE_BRANCH"):
        if not os.environ.get(required):
            print(f"Error: required environment variable {required!r} is not set.", file=sys.stderr)
            sys.exit(1)

    tags = [t.strip() for t in os.environ["TAGS"].splitlines() if t.strip()]
    branch = os.environ["FRAPPE_BRANCH"]
    should_push = os.environ.get("SHOULD_PUSH", "false").lower() == "true"

    cmd = [
        sys.executable,
        "easy-install.py",
        "build",
        "--apps-json",
        "apps.json",
        "--frappe-branch",
        branch,
    ]
    for tag in tags:
        cmd += ["--tag", tag]
    if should_push:
        cmd.append("--push")

    try:
        subprocess.run(cmd, check=True)
    except subprocess.CalledProcessError as exc:
        print(f"Command failed (exit {exc.returncode}): {' '.join(cmd)}", file=sys.stderr)
        sys.exit(exc.returncode)


if __name__ == "__main__":
    main()
