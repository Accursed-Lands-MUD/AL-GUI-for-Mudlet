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

-- Constants for better maintainability (addressing suggestion #13)
local RESIZE_TIMER_DELAY = 0.1 -- Delay before executing resize operations

alui = alui or {}
alui.style = alui.style or {}
alui.status = alui.status or {}
alui.health = alui.health or {}
alui.bleeding = alui.bleeding or {}
GUI = GUI or {}
GUI.Menu = GUI.Menu or {}
GUI.Events = GUI.Events or {}
GUI.Timers = GUI.Timers or {}
GUI.Style = GUI.Style or {}

GUI.Colors = {
    blue = '#2A768C',
    green = '#2EA652',
    yellow = '#E1B03E',
    orange = '#C3701C',
    red = '#830000',
}

-- Timer cleanup function to prevent memory leaks (addressing suggestion #19)
function GUI.cleanupTimers()
    if GUI.Timers.resize then
        killTimer(GUI.Timers.resize)
        GUI.Timers.resize = nil
    end
end

-- Improved resize event handler with better timer management and error handling
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

-- Constants for better maintainability (addressing suggestion #13)
local RESIZE_TIMER_DELAY = 0.1   -- Delay before executing resize operations
local RESIZE_MIN_INTERVAL = 0.05 -- Minimum interval between resize events (debouncing)

-- Initialize new ALUI namespace (will be properly set up by namespace.lua)
-- For backward compatibility, still initialize old globals but they'll be proxied
alui = alui or {}
alui.style = alui.style or {}
alui.status = alui.status or {}
alui.health = alui.health or {}
alui.bleeding = alui.bleeding or {}
GUI = GUI or {}
GUI.Menu = GUI.Menu or {}
GUI.Events = GUI.Events or {}
GUI.Timers = GUI.Timers or {}
GUI.Style = GUI.Style or {}

-- Resize tracking for debouncing
GUI.Timers.lastResizeTime = 0
GUI.Timers = GUI.Timers or {}
GUI.Style = GUI.Style or {}

-- Use ALUI namespace if available, otherwise fallback to GUI
local Colors = (ALUI and ALUI.GUI and ALUI.GUI.Colors) or {
    blue = '#2A768C',
    green = '#2EA652',
    yellow = '#E1B03E',
    orange = '#C3701C',
    red = '#830000',
}

-- Set colors in both new and old structures for compatibility
if ALUI and ALUI.GUI then
    ALUI.GUI.Colors = Colors
end
GUI.Colors = Colors

-- Timer cleanup function to prevent memory leaks (addressing suggestion #19)
local function cleanupTimers()
    -- Use ALUI timers if available, otherwise fall back to GUI
    local timers = (ALUI and ALUI.GUI and ALUI.GUI.Timers) or GUI.Timers

    if timers.resize then
        killTimer(timers.resize)
        timers.resize = nil
    end

    -- Reset resize tracking
    timers.lastResizeTime = 0
end

-- Update both namespace structures for compatibility
GUI.cleanupTimers = cleanupTimers
if ALUI and ALUI.GUI then
    ALUI.GUI.cleanupTimers = cleanupTimers
end

-- Improved resize event handler with debouncing and better timer management
local resizeHandler = function()
    -- Use ALUI timers if available, otherwise fall back to GUI
    local timers = (ALUI and ALUI.GUI and ALUI.GUI.Timers) or GUI.Timers

    -- Get current time for debouncing
    local currentTime = getEpoch()

    -- Check if enough time has passed since last resize event (debouncing)
    if currentTime - timers.lastResizeTime < RESIZE_MIN_INTERVAL then
        -- Too soon since last resize, extend the existing timer instead of creating new one
        if timers.resize then
            killTimer(timers.resize)
        end
    else
        -- Enough time has passed, update last resize time
        timers.lastResizeTime = currentTime
    end

    -- Clean up existing timer
    if timers.resize then
        killTimer(timers.resize)
        timers.resize = nil
    end

    -- Create new debounced timer
    timers.resize = tempTimer(RESIZE_TIMER_DELAY, function()
        -- Execute resize logic with error handling
        local success, error_msg = pcall(function()
            GUI.setBorders()
            GUI.setBackground()
            GUI.resizeBoxes()
            GUI.setBoxes()
            GUI.Style.update()
        end)

        -- Clean up timer reference after execution
        timers.resize = nil

        -- Log any errors (addressing suggestion #5)
        if not success then
            echo(string.format("Error during resize operations: %s\n", tostring(error_msg)))
        end
    end)
end

-- Register the event handler
GUI.Events.resize = registerNamedEventHandler(profileName, 'alui.events.resize', "sysWindowResizeEvent", resizeHandler,
false)

-- Also register in ALUI namespace if available
if ALUI and ALUI.Events then
    ALUI.Events.resize = GUI.Events.resize
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("alui_core.lua")
end
