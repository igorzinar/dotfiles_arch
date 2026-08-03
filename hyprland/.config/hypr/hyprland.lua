-- -- =============================================================================
-- -- HYPRLAND 0.55+ NATIVE LUA CONFIGURATION (Fedora 44 / Hyprland 0.55+)
-- -- Clean, functional, and stripped of unnecessary fluff.
-- -- =============================================================================
--
-- local terminal = "kitty"
-- local filemanager = "nautilus"
-- local menu = "wofi --show drun --parse-cache"
--
-- local mainMod = "SUPER"
-- local mainModShift = "SUPER + SHIFT"
--
-- --------------------------------------------------------------------------------
-- -- 1. MONITORS
-- --------------------------------------------------------------------------------
-- hl.monitor({ output = "desc:lenovo group limited l28u-35 u1akw245", mode = "3840x2160@60", position = "auto", scale = 1.5 })
-- -- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, bitdepth = 10 })
-- -- hl.monitor({ output = "eDP-1", mode = "2560x1600@165", position = "0x0", scale = 1, bitdepth = 10 })
-- hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, bitdepth = 8 })
-- hl.monitor({ output = "eDP-1", mode = "2560x1600@165", position = "0x0", scale = 1, bitdepth = 8 })
--
-- --------------------------------------------------------------------------------
-- -- 2. ENVIRONMENT VARIABLES
-- --------------------------------------------------------------------------------
-- hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")
-- hl.env("XCURSOR_SIZE", "28")
-- hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
-- hl.env("HYPRCURSOR_SIZE", "28")
--
-- -- NVIDIA Hardware Handshakes
-- hl.env("LIBVA_DRIVER_NAME", "nvidia")
-- hl.env("XDG_SESSION_TYPE", "wayland")
-- hl.env("GBM_BACKEND", "nvidia-drm")
-- hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
-- hl.env("__GL_VRR_ALLOWED", "0")
-- hl.env("XDG_SESSION_DESKTOP", "Hyprland")
-- hl.env("XDG_DESKTOP_PORTAL_HYPRLAND_FORCE_SHM", "1")
--
-- hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
-- hl.env("QT_QPA_PLATFORM", "wayland;xcb")
--
--
-- -- hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")
-- -- hl.env("AQ_MGPU_NO_EXPLICIT", "1")
-- -- hl.env("AQ_FORCE_LINEAR_BLIT", "0")
--
-- -- Force hardware-specific synchronization
-- hl.env("EGL_PLATFORM", "wayland")
--
-- -- This variable often fixes the "stutter/freeze" on multi-GPU laptops with 550+ drivers
-- hl.env("OGL_DEDICATED_HW_STATE_PER_CONTEXT", "ENABLE_ROBUST")
-- --------------------------------------------------------------------------------
-- -- 3. AUTOSTART
-- --------------------------------------------------------------------------------
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("waybar & swaync & hypridle & hyprpaper & nm-applet")
--     -- Ensure environment variables are registered before starting portals
--         hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
--         hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
--         hl.exec_cmd("systemctl --user start graphical-session.target")
--         hl.exec_cmd("hyprsunset --temperature 5000K")
-- end)
--
-- --------------------------------------------------------------------------------
-- -- 4. SYSTEM VARIABLES & LOOK
-- --------------------------------------------------------------------------------
-- hl.config({
--     general = {
--         gaps_in = 5,
--         gaps_out = 10,
--         border_size = 2,
--         col = {
--             active_border = "rgba(33ccffee)",
--             inactive_border = "rgba(595959aa)"
--         },
--         resize_on_border = false,
--         allow_tearing = false,
--         layout = "dwindle"
--     },
--
--     decoration = {
--         rounding = 10,
--         rounding_power = 2,
--         active_opacity = 1.0,
--         inactive_opacity = 1.0,
--         shadow = {
--             enabled = false -- Disabled styling fluff
--         },
--         blur = {
--             enabled = false -- Disabled styling fluff
--         }
--     },
--
--     animations = {
--         enabled = false -- Strict performance mode
--     },
--
--     dwindle = {
--         preserve_split = true,
--         force_split = 2
--     },
--
--     master = {
--         new_status = "master"
--     },
--
--     misc = {
--         force_default_wallpaper = -1,
--         disable_hyprland_logo = true,
--         disable_splash_rendering = true
--     },
--
--     input = {
--         kb_layout = "us,ru",
--         kb_options = "grp:alt_shift_toggle",
--         follow_mouse = 1,
--         sensitivity = 0,
--         touchpad = {
--             natural_scroll = false
--         }
--     },
--
--     cursor = {
--      no_hardware_cursors = 1
--     }
-- })
--
-- --------------------------------------------------------------------------------
-- -- 5. WINDOW RULES (Clean & Functional)
-- --------------------------------------------------------------------------------
-- -- Prevent all applications from force-maximizing themselves
-- --
-- -- hl.window_rule({ match = { class = ".*" }, suppressevent = "maximize" })
--
-- -- XWayland Video Bridge (Essential for clean screen sharing without crashes)
-- hl.window_rule({ match = { class = "^(xwaylandvideobridge)$" }, opacity = 0.0, animation = "none" })
--
-- -- Zoom Ecosystem Rules (Keeps floating behavior correct)
-- hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
-- hl.window_rule({ match = { title = "^(cpt_frame_window)$" }, float = true, pin = true })
-- hl.window_rule({ match = { title = "^(zoom_share_toolbar)$" }, float = true, pin = true })
--
-- --------------------------------------------------------------------------------
-- -- 6. KEYBINDINGS
-- --------------------------------------------------------------------------------
-- -- Core System Keybinds
-- hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
-- hl.bind(mainMod .. " + C", hl.dsp.window.close())
-- hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
-- hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(filemanager))
-- hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("hyprctl dispatch togglefloating"))
-- hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
-- hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
-- hl.bind(mainMod .. " + BACKSLASH", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg togglesplit"))
-- hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))
--
-- -- Vim-style Focus Navigation
--
-- hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
-- hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
-- hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
-- hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))
--
-- hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
-- hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
--
-- -- System Utils & Scratchpads
-- hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m region"))
-- hl.bind("CTRL + SHIFT + W", hl.dsp.exec_cmd("hyprshot -m window"))
-- hl.bind(mainModShift .. " + L", hl.dsp.exec_cmd("hyprlock"))
-- hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace magic"))
-- hl.bind(mainModShift .. " + S", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:magic"))
--
-- -- Hyprsunset Temperature Shifts
-- hl.bind(mainModShift .. " + F1", hl.dsp.exec_cmd("pkill hyprsunset; hyprsunset --temperature 6500K"))
-- hl.bind(mainModShift .. " + F2", hl.dsp.exec_cmd("pkill hyprsunset; hyprsunset --temperature 5000K"))
-- hl.bind(mainModShift .. " + F3", hl.dsp.exec_cmd("pkill hyprsunset; hyprsunset --temperature 3500K"))
-- hl.bind(mainModShift .. " + F4", hl.dsp.exec_cmd("pkill hyprsunset"))
-- --------------------------------------------------------------------------------
-- -- 7. WORKSPACE GENERATION LOOP (0-9)
-- --------------------------------------------------------------------------------
-- for i = 0, 9 do
--     local key = tostring(i)
--     local ws = tostring(i == 0 and 10 or i)
--
--     -- Focus workspace (opens/creates empty workspace correctly)
--     hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
--
--     -- Move active window to workspace
--     hl.bind(mainModShift .. " + " .. key, hl.dsp.window.move({ workspace = ws }))
-- end

-- =============================================================================
-- HYPRLAND 0.55+ NATIVE LUA CONFIGURATION (Fedora 44 / Hyprland 0.55+)
-- Clean, functional, and stripped of unnecessary fluff.
-- =============================================================================

local terminal = "kitty"
local filemanager = "nautilus"
local menu = "wofi --show drun --parse-cache"

local mainMod = "SUPER"
local mainModShift = "SUPER + SHIFT"

--------------------------------------------------------------------------------
-- 1. MONITORS
--------------------------------------------------------------------------------
hl.monitor({ output = "desc:lenovo group limited l28u-35 u1akw245", mode = "3840x2160@60", position = "auto", scale = 1.5 })
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1, bitdepth = 8 })
hl.monitor({ output = "eDP-1", mode = "2560x1600@165", position = "0x0", scale = 1, bitdepth = 8 })




--------------------------------------------------------------------------------
-- 2. ENVIRONMENT VARIABLES
--------------------------------------------------------------------------------
hl.env("XCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_THEME", "catppuccin-mocha-dark-cursors")
hl.env("HYPRCURSOR_SIZE", "28")

-- NVIDIA / multi-GPU setup: iGPU primary, dGPU secondary (Optimus laptop)
-- LIBVA_DRIVER_NAME, GBM_BACKEND, __GLX_VENDOR_LIBRARY_NAME intentionally
-- NOT forced to nvidia — let the iGPU be the default so the whole desktop
-- isn't rendered on the 4090.
hl.env("AQ_DRM_DEVICES", "/dev/dri/card1:/dev/dri/card0")  -- iGPU (card1) first, RTX 4090 (card0) second

hl.env("XDG_SESSION_TYPE", "wayland")
hl.env("__GL_VRR_ALLOWED", "0")
hl.env("XDG_SESSION_DESKTOP", "Hyprland")
hl.env("XDG_DESKTOP_PORTAL_HYPRLAND_FORCE_SHM", "1")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")
hl.env("EGL_PLATFORM", "wayland")
hl.env("OGL_DEDICATED_HW_STATE_PER_CONTEXT", "ENABLE_ROBUST")
hl.env("WLR_NO_HARDWARE_CURSORS", "1")

-- Only enable if the external-monitor CPU/fan issue persists after testing:
-- hl.env("AQ_FORCE_LINEAR_BLIT", "0")
-----------------------------------------------
-- 3. AUTOSTART
-- --------------------------------------------------------------------------------
-- hl.on("hyprland.start", function()
--     hl.exec_cmd("waybar & swaync & hypridle & hyprpaper & nm-applet")
--     hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
--     hl.exec_cmd("systemctl --user start xdg-desktop-portal-hyprland")
--     hl.exec_cmd("systemctl --user start graphical-session.target")
--     hl.exec_cmd("hyprsunset --temperature 5000K")
-- end)
-- Remove the manual 'systemctl start' lines for portals
-- Instead, ensure they are started via the D-Bus activation system.
hl.on("hyprland.start", function()
    hl.exec_cmd("waybar & swaync & hypridle & hyprpaper & nm-applet")
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
    hl.exec_cmd("systemctl --user start hyprland-session.target")
    hl.exec_cmd("hyprsunset --temperature 5000K")
end)

hl.on("hyprland.shutdown", function()
    os.execute("systemctl --user stop hyprland-session.target && sleep 0.1")
end)

hl.permission({ binary = "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland", type = "screencopy", mode = "allow" })
hl.permission({ binary = "/usr/bin/grim", type = "screencopy", mode = "allow" })

--------------------------------------------------------------------------------
-- 4. SYSTEM VARIABLES & LOOK
--------------------------------------------------------------------------------
hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = "rgba(33ccffee)",
            inactive_border = "rgba(595959aa)"
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle"
    },
    ecosystem = {
            enforce_permissions = false
        },

    decoration = {
        rounding = 10,
        rounding_power = 2,
        active_opacity = 1.0,
        inactive_opacity = 1.0,
        shadow = { enabled = false },
        blur = { enabled = false }
    },

    animations = { enabled = false },
    dwindle = { preserve_split = true, force_split = 2 },
    master = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
        disable_splash_rendering = true
    },

    input = {
        kb_layout = "us,ru",
        kb_options = "grp:alt_shift_toggle",
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = false }
    },

    cursor = { no_hardware_cursors = 1 }
})

--------------------------------------------------------------------------------
-- 5. WINDOW RULES
--------------------------------------------------------------------------------
hl.window_rule({ match = { class = "^(xwaylandvideobridge)$" }, opacity = 0.0, animation = "none" })
hl.window_rule({ match = { class = "^(zoom)$" }, float = true })
hl.window_rule({ match = { title = "^(cpt_frame_window)$" }, float = true, pin = true })
hl.window_rule({ match = { title = "^(zoom_share_toolbar)$" }, float = true, pin = true })

--------------------------------------------------------------------------------
-- 6. KEYBINDINGS
--------------------------------------------------------------------------------
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + C", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprctl dispatch exit"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(filemanager))
hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("hyprctl dispatch togglefloating"))
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(menu))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("hyprctl dispatch pseudo"))
hl.bind(mainMod .. " + BACKSLASH", hl.dsp.exec_cmd("hyprctl dispatch layoutmsg togglesplit"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("hyprctl dispatch fullscreen 0"))

hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "l" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "r" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "u" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "d" }))

hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("CTRL + SHIFT + 4", hl.dsp.exec_cmd("hyprshot -m region"))
hl.bind("CTRL + SHIFT + W", hl.dsp.exec_cmd("hyprshot -m window"))
hl.bind(mainModShift .. " + L", hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprctl dispatch togglespecialworkspace magic"))
hl.bind(mainModShift .. " + S", hl.dsp.exec_cmd("hyprctl dispatch movetoworkspace special:magic"))

hl.bind(mainModShift .. " + F1", hl.dsp.exec_cmd("pkill hyprsunset; hyprsunset --temperature 6500K"))
hl.bind(mainModShift .. " + F2", hl.dsp.exec_cmd("pkill hyprsunset; hyprsunset --temperature 5000K"))
hl.bind(mainModShift .. " + F3", hl.dsp.exec_cmd("pkill hyprsunset; hyprsunset --temperature 3500K"))
hl.bind(mainModShift .. " + F4", hl.dsp.exec_cmd("pkill hyprsunset"))

--------------------------------------------------------------------------------
-- 7. WORKSPACE GENERATION LOOP (0-9)
--------------------------------------------------------------------------------
for i = 0, 9 do
    local key = tostring(i)
    local ws = tostring(i == 0 and 10 or i)
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = ws }))
    hl.bind(mainModShift .. " + " .. key, hl.dsp.window.move({ workspace = ws }))
end