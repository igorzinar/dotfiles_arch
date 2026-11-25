#!/usr/bin/env bash
# Runs as root (PID 1 chain) every time the container starts, before any
# user session exists. Builds a default-deny egress ruleset with nftables.
# Fails closed: if the ruleset cannot be applied, the container won't start.
set -uo pipefail

dir=/usr/local/share/egress-firewall
log=/var/log/egress-firewall.log
exec 3>&2
say() { echo "[egress-firewall] $*" | tee -a "$log" >&3; }
: >"$log"; chmod 0644 "$log"

v4=() v6=()
add_ip() { if [[ $1 == *:* ]]; then v6+=("$1"); else v4+=("$1"); fi; }

# 1. Resolve allowlisted hosts (network is still open; nothing else runs yet).
while read -r host; do
  host=${host%%#*}; host=${host//[[:space:]]/}
  [ -z "$host" ] && continue
  ips=$(getent ahosts "$host" | awk '{print $1}' | sort -u)
  if [ -z "$ips" ]; then say "WARN: could not resolve $host"; continue; fi
  for ip in $ips; do add_ip "$ip"; done
done <"$dir/allowed-domains.txt"

# 2. GitHub ranges (web, api, git).
if meta=$(curl -fsS --max-time 10 https://api.github.com/meta); then
  for cidr in $(jq -r '(.web + .api + .git)[]' <<<"$meta" | sort -u); do add_ip "$cidr"; done
else
  say "WARN: could not fetch GitHub meta; GitHub will be blocked"
fi

# De-duplicate (hosts often share IPs).
mapfile -t v4 < <(printf "%s\n" "${v4[@]}" | sort -u | sed "/^$/d")
mapfile -t v6 < <(printf "%s\n" "${v6[@]}" | sort -u | sed "/^$/d")

# 3. DNS only to the configured resolvers (no DNS to arbitrary hosts).
dns4=() dns6=()
for ns in $(awk '/^nameserver/{print $2}' /etc/resolv.conf); do
  if [[ $ns == *:* ]]; then dns6+=("$ns"); else dns4+=("$ns"); fi
done

join() { local IFS=,; echo "$*"; }
elems() { [ $# -gt 0 ] && echo "elements = { $(join "$@") }"; }
dnsrule() { # family list...
  local fam=$1; shift
  [ $# -gt 0 ] && echo "$fam daddr { $(join "$@") } meta l4proto { udp, tcp } th dport 53 accept"
}

ruleset=$(cat <<EOF
flush ruleset
table inet egress {
  set allow4 { type ipv4_addr; flags interval; auto-merge; $(elems "${v4[@]}") }
  set allow6 { type ipv6_addr; flags interval; auto-merge; $(elems "${v6[@]}") }

  chain output {
    type filter hook output priority 0; policy drop;
    oif lo accept
    ct state established,related accept
    $(dnsrule ip "${dns4[@]}")
    $(dnsrule ip6 "${dns6[@]}")
    ip daddr @allow4 tcp dport 443 accept
    ip6 daddr @allow6 tcp dport 443 accept
    counter reject with icmpx type admin-prohibited
  }

  chain input {
    type filter hook input priority 0; policy drop;
    iif lo accept
    ct state established,related accept
  }
}
EOF
)

if ! nft -f - <<<"$ruleset"; then
  say "FATAL: failed to apply nftables ruleset (is --cap-add=NET_ADMIN set?)"
  exit 1
fi
say "applied: ${#v4[@]} IPv4 + ${#v6[@]} IPv6 allow entries, DNS via ${dns4[*]} ${dns6[*]}"

# 4. Self-test.
if curl -fsS --max-time 5 -o /dev/null https://example.com 2>/dev/null; then
  say "FATAL: example.com reachable, firewall not effective"; exit 1
fi
curl -sS --max-time 5 -o /dev/null https://api.anthropic.com \
  && say "ok: example.com blocked, api.anthropic.com reachable" \
  || say "WARN: api.anthropic.com not reachable"

exec "$@"
