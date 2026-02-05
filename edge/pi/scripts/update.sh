#!/usr/bin/env bash
set -euo pipefail

# nexus-edge: minimal maintenance update
# - apt update/upgrade
# - optional: update Pi-hole
# - show health summary

DO_PIHOLE_UPDATE="${DO_PIHOLE_UPDATE:-0}"

echo "[nexus-edge] updating apt package lists..."
sudo apt-get update

echo "[nexus-edge] upgrading packages (non-interactive)..."
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y

echo "[nexus-edge] autoremove..."
sudo apt-get autoremove -y

if [[ "${DO_PIHOLE_UPDATE}" == "1" ]]; then
  echo "[nexus-edge] updating Pi-hole subsystems..."
  sudo pihole -up
else
  echo "[nexus-edge] skipping Pi-hole subsystem update (set DO_PIHOLE_UPDATE=1 to enable)"
fi

echo
echo "[nexus-edge] status summary"
echo "hostname: $(hostname)"
echo "uptime  : $(uptime -p || true)"
echo

echo "[nexus-edge] ufw"
sudo ufw status verbose | sed -n '1,120p' || true
echo

echo "[nexus-edge] pihole"
pihole status || true
echo

echo "[nexus-edge] listening ports (22/53/80/443)"
sudo ss -tulpn | egrep ':22|:53|:80|:443' || true
echo

echo "[nexus-edge] disk usage"
df -h / | tail -n 1 || true

echo "[nexus-edge] done"
