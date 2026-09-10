ARG N8N_VERSION=latest
FROM docker.n8n.io/n8nio/n8n:${N8N_VERSION}

USER root

# Install Python 3, pip, and essential build dependencies for Code Node Python support
RUN apk add --no-cache \
    python3 \
    py3-pip \
    py3-requests \
    curl \
    && ln -sf /usr/bin/python3 /usr/bin/python

# Switch back to node user for security
USER node
