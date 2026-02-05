#!/usr/bin/env bash
set -euo pipefail

# Minimal backup for nexus-edge (Pi-hole)
# - archives /etc/pihole and /etc/dnsmasq.d
# - stores it under /var/backups/nexus-edge/pihole
# Notes:
# - Teleporter export (UI) is still recommended for easy migration.

BACKUP_ROOT="/var/backups/nexus-edge/pihole"
STAMP="$(date +%F)"
ARCHIVE="${BACKUP_ROOT}/etc-pihole_${STAMP}.tar.gz"

echo "[nexus-edge] creating backup at: ${ARCHIVE}"

sudo mkdir -p "${BACKUP_ROOT}"
sudo tar -czf "${ARCHIVE}" /etc/pihole /etc/dnsmasq.d

echo "[nexus-edge] done"
sudo ls -lah "${BACKUP_ROOT}"

echo
echo "[note] Recommended: Pi-hole UI -> Settings -> Teleporter -> Export (store off-device)"
