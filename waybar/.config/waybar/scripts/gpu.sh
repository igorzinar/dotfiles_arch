#!/usr/bin/env bash
# Waybar GPU module (NVIDIA). Prints one JSON line for "return-type": "json".
#
# On hybrid laptops the NVIDIA GPU sleeps when idle. Calling nvidia-smi wakes
# it up, so polling it every few seconds keeps it awake and drains the
# battery. Reading runtime_status from sysfs does not wake it, so check that
# first and only call nvidia-smi when the GPU is already running.

status=""
for f in /sys/bus/pci/drivers/nvidia/0000:*/power/runtime_status; do
  [ -r "$f" ] && status=$(<"$f") && break
done

if [ "$status" = "suspended" ]; then
  echo '{"text":"off","tooltip":"NVIDIA GPU: asleep (saving power)","class":"off"}'
  exit 0
fi

command -v nvidia-smi >/dev/null || exit 0 # no NVIDIA driver: hide module

IFS=', ' read -r util used total temp < <(
  nvidia-smi --query-gpu=utilization.gpu,memory.used,memory.total,temperature.gpu \
    --format=csv,noheader,nounits | head -n1
)
[ -n "$total" ] || exit 0

vram=$((used * 100 / total))
class="normal"
if [ "$util" -ge 90 ] || [ "$vram" -ge 90 ]; then
  class="critical"
elif [ "$util" -ge 70 ] || [ "$vram" -ge 75 ]; then
  class="warning"
fi

gib() { awk -v m="$1" 'BEGIN { printf "%.1f", m / 1024 }'; }
tooltip="NVIDIA GPU\\nLoad: ${util}%\\nVRAM: $(gib "$used") / $(gib "$total") GiB (${vram}%)\\nTemp: ${temp}°C\\n\\nClick: nvtop"

printf '{"text":"%s%% 󰍛 %s%%","tooltip":"%s","class":"%s"}\n' "$util" "$vram" "$tooltip" "$class"
