alui.status = alui.status or {}

local fatigue_levels = {
    ["well rested"] = "<ansi_cyan>",
    ["barely tired"] = "<ansi_green>",
    ["somewhat tired"] = "<ansi_green>",
    ["winded"] = "<ansi_green>",
    ["tired"] = "<ansi_green>",
    ["weary"] = "<ansi_light_yellow>",
    ["haggard"] = "<ansi_light_yellow>",
    ["worn out"] = "<ansi_light_yellow>",
    ["exhausted"] = "<ansi_light_yellow>",
    ["disoriented"] = "<ansi_light_red>",
    ["faint"] = "<ansi_light_red>",
    ["system shocked"] = "<ansi_light_red>"
}

function status_update(e)
    if e ~= "gmcp.Char.Status" then
        return
    end

    local status = gmcp.Char.Status

    alui.status.fatigue = set_fatigue_color(status.Fatigue)
    alui.status.posture = status.Posture
    alui.status.meline = f "You are {status.Name:title()}, a {status.Age} year old {status.Race}."

    raiseEvent("alui status window")
end

function set_fatigue_color(level)
    -- check fatigue level against table and set color accordingly

    local fatigue_color = fatigue_levels[level]
    
    return fatigue_color .. level .. "<reset>"
end
