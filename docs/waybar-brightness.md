# Waybar: screen brightness slider

Hover-drawer in Waybar that shows the current backlight level and slides open to
reveal a draggable slider. Added 2026-08-31.

## What it looks like

- **Collapsed (always visible):** sun icon + percentage, yellow, in a rounded
  `surface0` pill — same shape as the `group/hardware` and `group/bt-drawer` pills.
  The icon steps through `󰃞 / 󰃟 / 󰃠` as the level rises.
- **Hover:** the pill expands right-to-left over 500ms and reveals a real GTK
  slider. Drag it to set brightness.
- **Scroll** on the icon: ±5% without opening the drawer.

## Files

| File | Lines | Contents |
|---|---|---|
| `waybar/.config/waybar/config.jsonc` | `modules-right` | `"group/brightness"` between `network` and `pulseaudio` |
| `waybar/.config/waybar/config.jsonc` | module defs | `group/brightness`, `backlight`, `backlight/slider` |
| `waybar/.config/waybar/style.css` | end of file | `#group-brightness` pill + `#backlight-slider` trough/highlight/knob |
| `waybar/.config/waybar/style.css` | shared margin rule | `#backlight-slider` added alongside `#backlight` |

`~/.config/waybar` is a symlink into this repo, so edits are live — no stow re-run needed.

## Requirements

- **Waybar >= 0.10** for the native `backlight/slider` module. Verified on **0.15.0**.
- **`brightnessctl`** — only for the scroll actions. The slider does not shell
  out; Waybar performs the write itself (see below).

## Machine-specific: the `device` field

Both `backlight` and `backlight/slider` hardcode `"device": "intel_backlight"`.

```
$ ls /sys/class/backlight/
intel_backlight -> ../../devices/pci0000:00/0000:00:02.0/drm/card1/card1-eDP-1/intel_backlight
```

This is the laptop's internal eDP-1 panel and the only backlight device present.
Pinning it stops the slider from binding to the wrong device if another ever
appears. **On a different machine, check `ls /sys/class/backlight/` and update
both `device` fields** (or drop them to let Waybar autodetect).

Note the NVIDIA GPU on this box exposes no backlight device — external monitors
over DP/HDMI would need `ddcutil` (DDC/CI) and a `custom/` module instead; that
is not set up here.

## Permissions

No sudo, no `pkexec` wrapper, and **no udev rule** — but not because the sysfs
file is writable. It isn't:

```
$ ls -l /sys/class/backlight/intel_backlight/brightness
-rw-r--r--. 1 root root 4096 ... brightness      # no ACL for the user either
```

Both `brightnessctl` and Waybar link `libsystemd` and route the write through
**systemd-logind** instead:

```
org.freedesktop.login1.Session.SetBrightness(backlight, intel_backlight, <value>)
  on /org/freedesktop/login1/session/auto
```

logind grants this to the user who owns the **active local session** on the seat.
Verified directly:

```sh
gdbus call --system -d org.freedesktop.login1 \
  -o /org/freedesktop/login1/session/auto \
  -m org.freedesktop.login1.Session.SetBrightness \
  backlight intel_backlight 5200        # -> () , screen changes
```

Consequences of it being session-scoped rather than a file permission:

- It works out of the box on any systemd distro — nothing to install or configure.
- It only works from the **active** session. Over plain SSH into a non-active
  session, or from a user without a seat, the same call fails and brightness
  silently will not move. That is the first thing to check if it ever stops
  working — not file permissions:

```sh
loginctl show-session $XDG_SESSION_ID -p Active -p Seat
brightnessctl -d intel_backlight set 30%   # should change the screen
```

## `min: 5`

`backlight/slider` sets `"min": 5` so the slider cannot be dragged to 0 and black
out the panel. `max` is 100.

## Interaction with the media keys

`hyprland/.config/hypr/hyprland.conf` already binds the hardware keys:

```
bindel = ,xf86monbrightnessup,   exec, brightnessctl -e4 -n2 set 5%+
bindel = ,xf86monbrightnessdown, exec, brightnessctl -e4 -n2 set 5%-
```

Those use `-e4` (exponential/perceptual scaling) with `-n2` as a floor, while the
Waybar slider and scroll are **linear**. Both drive the same device and stay in
sync, but a 5% key press and a 5% scroll move the panel by different amounts at
the low end. Unify by either adding `-e4 -n2` to the `on-scroll-*` commands or
dropping it from the keybinds — the slider widget itself is always linear and
cannot be made exponential.

## Styling notes

Catppuccin Mocha via `mocha.css`: `@yellow` fill, `@surface2` trough, `@text` knob
turning `@rosewater` on hover.

The GTK node names matter — a slider is styled through its child nodes, not the
widget id alone:

```css
#backlight-slider trough    { /* the track */ }
#backlight-slider highlight { /* the filled portion */ }
#backlight-slider slider    { /* the knob */ }
```

`#backlight-slider` needs an explicit `min-width` (110px here) or it collapses to
zero width inside the drawer and is invisible.

## Reloading

```sh
pkill -SIGUSR2 waybar          # in-place reload
timeout 4 waybar -l debug 2>&1 | grep -i error   # check config parses
```

Two warnings are **pre-existing** and unrelated:

- `style.css:21:19` / `22:20` — `padding-left: 8;` in `#window` is missing `px`.
- `Can't open /dev/input/event*  (are you in the input group?)` — from the
  `keyboard-state` module.
