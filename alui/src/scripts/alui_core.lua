--util funcs
function table.flip(tbl)
    local t = {}
    for k, v in pairs(tbl) do
        t[v] = k
    end
    return t
end

--end util funcs

local profileName = getProfileName()

-- Constants for better maintainability
local RESIZE_TIMER_DELAY = 0.1   -- Delay before executing resize operations
local RESIZE_MIN_INTERVAL = 0.05 -- Minimum interval between resize events (debouncing)

-- Initialize ALUI namespace (fully migrated from old globals)
ALUI = ALUI or {}
ALUI.GUI = ALUI.GUI or {}
ALUI.GUI.Menu = ALUI.GUI.Menu or {}
ALUI.GUI.Events = ALUI.GUI.Events or {}
ALUI.GUI.Timers = ALUI.GUI.Timers or {}
ALUI.GUI.Style = ALUI.GUI.Style or {}
ALUI.Status = ALUI.Status or {}
ALUI.Status.vitals = ALUI.Status.vitals or {}
ALUI.Status.bleeding = ALUI.Status.bleeding or {}
ALUI.Health = ALUI.Health or {}

-- Resize tracking for debouncing
ALUI.GUI.Timers.lastResizeTime = 0

-- Set colors in ALUI structure
ALUI.GUI.Colors = {
    blue = '#2A768C',
    green = '#2EA652',
    yellow = '#E1B03E',
    orange = '#C3701C',
    red = '#830000',
}

-- Timer cleanup function
local function cleanupTimers()
    local RM = ALUI and ALUI.ResourceManager
    if RM then
        RM.cleanupByCategory("resize")
        RM.cleanupByCategory("ui")
    else
        if ALUI.GUI.Timers.resize then
            killTimer(ALUI.GUI.Timers.resize)
            ALUI.GUI.Timers.resize = nil
        end
    end
    ALUI.GUI.Timers.lastResizeTime = 0
end

ALUI.GUI.cleanupTimers = cleanupTimers

-- Improved resize event handler
local resizeHandler = function()
    local RM = ALUI and ALUI.ResourceManager
    local currentTime = getEpoch()

    -- Debouncing logic
    if currentTime - ALUI.GUI.Timers.lastResizeTime < RESIZE_MIN_INTERVAL then
        return
    end

    ALUI.GUI.Timers.lastResizeTime = currentTime

    -- Use ResourceManager for timer if available
    if RM then
        RM.createTimer("resizeOperation", RESIZE_TIMER_DELAY, function()
            local success, error_msg = pcall(function()
                GUI.setBorders()
                GUI.setBackground()
                GUI.resizeBoxes()
                GUI.setBoxes()
                GUI.Style.update()
            end)
            if not success then
                echo(string.format("Error during resize operations: %s\n", tostring(error_msg)))
            end
        end, false, "resize")
    else
        if ALUI.GUI.Timers.resize then
            killTimer(ALUI.GUI.Timers.resize)
            ALUI.GUI.Timers.resize = nil
        end
        ALUI.GUI.Timers.resize = tempTimer(RESIZE_TIMER_DELAY, function()
            local success, error_msg = pcall(function()
                GUI.setBorders()
                GUI.setBackground()
                GUI.resizeBoxes()
                GUI.setBoxes()
                GUI.Style.update()
            end)
            ALUI.GUI.Timers.resize = nil
            if not success then
                echo(string.format("Error during resize operations: %s\n", tostring(error_msg)))
            end
        end)
    end
end

-- Register the event handler in ALUI namespace
ALUI.GUI.Events.resize = registerNamedEventHandler(profileName, 'ALUI.events.resize', "sysWindowResizeEvent",
    resizeHandler, false)

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("alui_core.lua")
end
