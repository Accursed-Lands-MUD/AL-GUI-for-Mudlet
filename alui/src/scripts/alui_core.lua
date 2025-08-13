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
    local GUI = ALUI and ALUI.GUI
    if RM then
        RM.cleanupByCategory("resize")
        RM.cleanupByCategory("ui")
    else
        if GUI.Timers.resize then
            killTimer(GUI.Timers.resize)
            GUI.Timers.resize = nil
        end
    end
    GUI.Timers.lastResizeTime = 0
end

ALUI.GUI.cleanupTimers = cleanupTimers

-- Improved resize event handler
local resizeHandler = function()
    local RM = ALUI and ALUI.ResourceManager
    local GUI = ALUI and ALUI.GUI
    local currentTime = getEpoch()

    -- Debouncing logic
    if currentTime - GUI.Timers.lastResizeTime < RESIZE_MIN_INTERVAL then
        return
    end

    GUI.Timers.lastResizeTime = currentTime

    -- Use ResourceManager for timer if available
    if RM then
        RM.createTimer("resizeOperation", RESIZE_TIMER_DELAY, function()
            local success, error_msg = pcall(function()
                -- Use ALUI namespace instead of global GUI
                if GUI then
                    if GUI.setBorders then GUI.setBorders() end
                    if GUI.setBackground then GUI.setBackground() end
                    if GUI.resizeBoxes then GUI.resizeBoxes() end
                    if GUI.setBoxes then GUI.setBoxes() end
                    if GUI.Style and GUI.Style.update then GUI.Style.update() end
                end
            end)
            if not success then
                echo(string.format("Error during resize operations: %s\n", tostring(error_msg)))
            end
        end, false, "resize")
    else
        if GUI.Timers.resize then
            killTimer(GUI.Timers.resize)
            GUI.Timers.resize = nil
        end
        GUI.Timers.resize = tempTimer(RESIZE_TIMER_DELAY, function()
            local success, error_msg = pcall(function()
                -- Use ALUI namespace instead of global GUI
                if ALUI and ALUI.GUI then
                    if GUI.setBorders then GUI.setBorders() end
                    if GUI.setBackground then GUI.setBackground() end
                    if GUI.resizeBoxes then GUI.resizeBoxes() end
                    if GUI.setBoxes then GUI.setBoxes() end
                    if GUI.Style and GUI.Style.update then GUI.Style.update() end
                end
            end)
            GUI.Timers.resize = nil
            if not success then
                echo(string.format("Error during resize operations: %s\n", tostring(error_msg)))
            end
        end)
    end
end

-- Register the event handler in ALUI namespace
ALUI.GUI.Events.resize = registerNamedEventHandler(profileName, 'ALUI.events.resize', "sysWindowResizeEvent",
    resizeHandler, false)
