# syntax=docker/dockerfile:1
# Build a custom Frappe/ERPNext image with the apps listed in APPS_JSON_BASE64.
#
# Multi-stage build:
#   1. builder – install apps into the bench using frappe_builder.
#   2. final   – copy the populated bench into the lean frappe_worker runtime.

ARG FRAPPE_VERSION=latest

# ── Stage 1: install apps ────────────────────────────────────────────────────
FROM ghcr.io/frappe/frappe_builder:${FRAPPE_VERSION} AS builder

ARG APPS_JSON_BASE64

COPY install_apps.py /usr/local/bin/install_apps.py

RUN --mount=type=cache,target=/root/.cache/pip \
    export APPS_JSON_BASE64=${APPS_JSON_BASE64} && \
    python3 /usr/local/bin/install_apps.py

# ── Stage 2: runtime image ───────────────────────────────────────────────────
FROM ghcr.io/frappe/frappe_worker:${FRAPPE_VERSION}

COPY --from=builder /home/frappe/frappe-bench /home/frappe/frappe-bench
