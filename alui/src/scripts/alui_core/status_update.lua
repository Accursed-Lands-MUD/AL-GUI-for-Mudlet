alui.status = alui.status or {}

local fatigue_levels = {
    ["well rested"] = "<ansi_light_cyan>well rested<reset>",
    ["barely tired"] = "<ansi_green>barely tired<reset>",
    ["somewhat tired"] = "<ansi_green>somewhat tired<reset>",
    ["winded"] = "<ansi_green>winded<reset>",
    ["tired"] = "<ansi_green>tired<reset>",
    ["weary"] = "<ansi_light_yellow>weary<reset>",
    ["haggard"] = "<ansi_light_yellow>haggard<reset>",
    ["worn out"] = "<ansi_light_yellow>worn out<reset>",
    ["exhausted"] = "<ansi_light_yellow>exhausted<reset>",
    ["disoriented"] = "<ansi_light_red>disoriented<reset>",
    ["faint"] = "<ansi_light_red>faint<reset>",
    ["system shocked"] = "<ansi_light_red>system shocked<reset>"
}

function status_update(e)
    if e ~= "gmcp.Char.Status" then
        return
    end

    local status = gmcp.Char.Status

    alui.status.fatigue = fatigue_levels[status.Fatigue]
    alui.status.posture = status.Posture
    alui.status.meline = "You are " .. status.Name:title() .. ", a " .. status.Age .. " year old " .. status.Race .. "."

    raiseEvent("alui status window")
end