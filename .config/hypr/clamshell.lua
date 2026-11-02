local panel = "eDP-1"
local lid_path = "/proc/acpi/button/lid/LID0/state"
local outputs_path = os.getenv("HOME") .. "/.config/hypr/dms/outputs.lua"
local grace_seconds = 60
local missing_since = nil
local suspend_requested = false
local last_tick = os.time()

-- Keep logind from bypassing the grace period while this compositor is alive.
local process = assert(io.open("/proc/self/stat", "r"))
local compositor_pid = assert(process:read("*l"):match("^(%d+)"))
process:close()
hl.exec_cmd("systemctl --user start hyprland-lid-grace@" .. compositor_pid .. ".service")

local function lid_closed()
    local file = io.open(lid_path, "r")
    if not file then
        return nil
    end
    local state = file:read("*a")
    file:close()
    if state:match("closed") then
        return true
    elseif state:match("open") then
        return false
    end
    return nil
end

local function restore_panel()
    local rule = { output = panel, mode = "preferred", position = "auto", scale = "auto" }
    -- Reuse the saved DMS panel rule without changing other outputs or its files.
    local environment = setmetatable({
        hl = { monitor = function(spec)
            if spec.output == panel or spec.output == "desc:Samsung Display Corp. ATNA60DL01-0" then
                rule = spec
            end
        end },
    }, { __index = _G })
    local load_outputs = loadfile(outputs_path, "t", environment)
    if load_outputs then
        load_outputs()
    end
    rule.disabled = false
    hl.monitor(rule)
end

local function reconcile()
    local now = os.time()
    -- Restart the grace period after resume so dock links can return.
    if now - last_tick > 3 then
        missing_since = nil
        suspend_requested = false
    end
    last_tick = now

    local closed = lid_closed()
    local panel_active = false
    local external_active = false
    for _, monitor in ipairs(hl.get_monitors()) do
        if monitor.name == panel then
            panel_active = true
        elseif monitor.name:match("^DP%-%d") or monitor.name:match("^HDMI%-A%-%d") then
            external_active = true
        end
    end

    if closed == true and external_active then
        if panel_active then
            hl.monitor({ output = panel, disabled = true })
        end
    elseif not panel_active then
        -- Never leave the session without a usable panel after undocking.
        restore_panel()
    end

    if closed == true and not external_active then
        -- Reopening the lid or docking cancels the one-minute lock/sleep grace.
        missing_since = missing_since or now
        if now - missing_since >= grace_seconds and not suspend_requested then
            suspend_requested = true
            hl.exec_cmd("systemctl suspend")
        end
    else
        missing_since = nil
        suspend_requested = false
    end
end

-- Reading actual state also covers startup, config reload, hotplug and resume.
-- DPMS-off outputs still count, so display idle does not trigger suspend.
hl.timer(reconcile, { timeout = 1000, type = "repeat" })
