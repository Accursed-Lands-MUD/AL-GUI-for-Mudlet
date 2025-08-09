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
GUI.Events.resize = registerNamedEventHandler(profileName, 'alui.events.resize', "sysWindowResizeEvent", function()
    -- Improved timer management: only kill if exists, then clear reference
    if GUI.Timers.resize then
        killTimer(GUI.Timers.resize)
        GUI.Timers.resize = nil
    end

    -- Only create timer if one doesn't already exist
    if not GUI.Timers.resize then
        GUI.Timers.resize = tempTimer(RESIZE_TIMER_DELAY, function()
            -- Execute resize logic with error handling
            local success, error_msg = pcall(function()
                GUI.setBorders()
                GUI.setBackground()
                GUI.resizeBoxes()
                GUI.setBoxes()
                GUI.Style.update()
            end)

            -- Clean up timer reference after execution
            GUI.Timers.resize = nil

            -- Log any errors (addressing suggestion #7)
            if not success then
                echo("Error during resize operations: " .. tostring(error_msg) .. "\n")
            end
        end)
    end
end, false)
