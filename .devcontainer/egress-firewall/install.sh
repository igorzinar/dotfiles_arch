#!/usr/bin/env bash
# Runs as root at image build time.
set -euo pipefail

export DEBIAN_FRONTEND=noninteractive
apt-get update
apt-get install -y --no-install-recommends nftables jq curl ca-certificates
rm -rf /var/lib/apt/lists/*

dest=/usr/local/share/egress-firewall
install -d -m 0755 "$dest"
install -m 0755 entrypoint.sh "$dest/entrypoint.sh"
install -m 0644 allowed-domains.txt "$dest/allowed-domains.txt"

# Remove passwordless sudo for the dev user. (no-new-privileges in runArgs
# also blocks setuid sudo; this is belt and braces.)
rm -f /etc/sudoers.d/node /etc/sudoers.d/"${_REMOTE_USER:-node}"
if [ -n "${_REMOTE_USER:-}" ] && id -nG "$_REMOTE_USER" 2>/dev/null | grep -qw sudo; then
  gpasswd -d "$_REMOTE_USER" sudo || true
fi
