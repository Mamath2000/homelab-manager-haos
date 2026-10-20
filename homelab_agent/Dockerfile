# https://developers.home-assistant.io/docs/apps/configuration#app-dockerfile
# HM_VERSION: release of homelab-manager whose signed agent binary is shipped (set by sync.yaml).
# HUB_IMAGE: override for a local test with an unreleased hub image (make build HUB_IMAGE=…).
ARG HM_VERSION=0.3.9
ARG HUB_IMAGE=mathmath350/homelab-manager:${HM_VERSION}
ARG BUILD_FROM=ghcr.io/home-assistant/base-debian:trixie

FROM ${HUB_IMAGE} AS hub

FROM ${BUILD_FROM}

# proxmox-backup-client, from the client-only repository of Proxmox (amd64): directory backups to the
# PBS, run by the agent (next step, not used yet)
RUN curl -fsSL https://enterprise.proxmox.com/debian/proxmox-release-trixie.gpg \
        -o /usr/share/keyrings/proxmox-release-trixie.gpg \
    && echo "deb [signed-by=/usr/share/keyrings/proxmox-release-trixie.gpg] http://download.proxmox.com/debian/pbs-client trixie main" \
        > /etc/apt/sources.list.d/pbs-client.list \
    && apt-get update \
    && apt-get install -y --no-install-recommends proxmox-backup-client \
    && rm -rf /var/lib/apt/lists/*

# the signed binary of the hub image, as distributed to the other hosts
COPY --from=hub /app/agent/homelab-agent-linux-amd64 /usr/bin/homelab-agent

COPY rootfs /

LABEL \
    org.opencontainers.image.title="Homelab Manager Agent" \
    org.opencontainers.image.description="Homelab Manager agent for Home Assistant OS" \
    org.opencontainers.image.source="https://github.com/Mamath2000/homelab-manager-haos" \
    org.opencontainers.image.licenses="MIT"
