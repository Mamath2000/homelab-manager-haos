# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
ARG HUB_VERSION=0.3.37
ARG HUB_IMAGE=mathmath350/homelab-manager:${HUB_VERSION}
ARG BUILD_FROM=ghcr.io/home-assistant/base-debian:bookworm

FROM ${HUB_IMAGE} AS hub
FROM node:22-bookworm-slim AS node
FROM ${BUILD_FROM}

COPY --from=node /usr/local/bin/node /usr/local/bin/node

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl gnupg \
    && curl -fsSL https://pgp.mongodb.com/server-7.0.asc \
        | gpg --dearmor -o /usr/share/keyrings/mongodb-server-7.0.gpg \
    && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg] https://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" \
        > /etc/apt/sources.list.d/mongodb-org-7.0.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends mongodb-org-server \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --no-create-home --shell /usr/sbin/nologin node

COPY --from=hub /app/hub /app/hub
COPY --from=hub /app/web /app/web
COPY --from=hub /app/agent /app/agent
COPY rootfs /

LABEL \
    org.opencontainers.image.title="Homelab Manager" \
    org.opencontainers.image.description="Homelab Manager hub and MongoDB for Home Assistant OS" \
    org.opencontainers.image.source="https://github.com/Mamath2000/homelab-manager-haos" \
    org.opencontainers.image.licenses="MIT"
