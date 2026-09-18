ARG N8N_VERSION=latest
FROM docker.io/n8nio/n8n:${N8N_VERSION}

# NOTE: The official n8nio/n8n image is now built from Docker's "Hardened Images"
# base, which ships WITHOUT a package manager (no apk/apt), so `RUN apk add ...`
# fails the build on any current tag. It's also unnecessary: n8n's built-in
# Code node "Python (Beta)" mode runs Python in-process via Pyodide (WASM) and
# does not use a system python3 binary at all. None of this workshop's
# workflows use a Python code node (they all use JavaScript), so no extra
# packages are required — this file just re-tags the upstream image.

