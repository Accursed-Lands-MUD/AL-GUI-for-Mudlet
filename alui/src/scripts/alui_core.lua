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

GUI.Events.resize = registerNamedEventHandler(profileName, 'alui.events.resize', "sysWindowResizeEvent", function()
    if GUI.Timers.resize then
        killTimer(GUI.Timers.resize)
    end

    GUI.Timers.resize = tempTimer(0.1, function()
        GUI.setBorders()
        GUI.setBackground()
        GUI.resizeBoxes()
        GUI.setBoxes()
    end)
end, false)
