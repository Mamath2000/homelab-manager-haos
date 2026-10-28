# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
ARG HUB_VERSION=0.4.1
ARG HUB_IMAGE=mathmath350/homelab-manager:${HUB_VERSION}
ARG BUILD_FROM=ghcr.io/home-assistant/base-debian:bookworm

FROM ${HUB_IMAGE} AS hub
FROM node:22-bookworm-slim AS node
FROM mongo:7.0 AS mongo
FROM ${BUILD_FROM}

COPY --from=node /usr/local/bin/node /usr/local/bin/node
COPY --from=mongo /usr/bin/mongod /usr/bin/mongod

RUN apt-get update \
    && apt-get install -y --no-install-recommends ca-certificates curl libcurl4 libssl3 \
    && rm -rf /var/lib/apt/lists/*

RUN groupadd --gid 1000 node \
    && useradd --uid 1000 --gid node --no-create-home --shell /usr/sbin/nologin node \
    && groupadd --system --gid 999 mongodb \
    && useradd --system --uid 999 --gid mongodb --home-dir /data/db --no-create-home --shell /usr/sbin/nologin mongodb

COPY --from=hub /app/hub /app/hub
COPY --from=hub /app/web /app/web
COPY --from=hub /app/agent /app/agent
COPY rootfs /

LABEL \
    org.opencontainers.image.title="Homelab Manager" \
    org.opencontainers.image.description="Homelab Manager hub and MongoDB for Home Assistant OS" \
    org.opencontainers.image.source="https://github.com/Mamath2000/homelab-manager-haos" \
    org.opencontainers.image.licenses="MIT"
