alui.status = alui.status or {}
alui.health = alui.health or {}

local thirst_colors = {
    ["bloated"] = "<ansi_green>",
    ["quenched"] = "<ansi_green>",
    ["not thirsty"] = "<ansi_green>",
    ["slightly thirsty"] = "<yellow>",
    ["moderately thirsty"] = "<yellow>",
    ["thirsty"] = "<yellow>",
    ["very thirsty"] = "<red>",
    ["parched"] = "<red>",
    ["dehydrated"] = "<red>",
    ["dying of thirst"] = "<red>",
}

local hunger_colors = {
    ["stuffed"] = "<ansi_green>",
    ["full"] = "<ansi_green>",
    ["satiated"] = "<ansi_green>",
    ["not hungry"] = "<ansi_green>",
    ["peckish"] = "<yellow>",
    ["slightly hungry"] = "<yellow>",
    ["very hungry"] = "<red>",
    ["famished"] = "<red>",
    ["starving"] = "<red>",
    ["dying of hunger"] = "<red>",
}

local health_levels = {
    [0] = "<ansi_light_yellow:ansi_light_red>",
    [1] = "<ansi_red:ansi_light_yellow>",
    [2] = "<ansi_light_red>",
    [3] = "<ansi_light_red>",
    [4] = "<ansi_light_yellow>",
    [5] = "<ansi_light_yellow>",
    [6] = "<ansi_light_yellow>",
    [7] = "<ansi_light_green>",
    [8] = "<ansi_light_green>",
    [9] = "<ansi_light_cyan>",
}

local health_to_number = {
    ["destroyed"] = -1,
    ["broken"] = 0,
    ["massively injured"] = 1,
    ["horribly injured"] = 2,
    ["badly injured"] = 3,
    ["injured"] = 4,
    ["badly hurt"] = 5,
    ["hurt"] = 6,
    ["slightly wounded"] = 7,
    ["barely wounded"] = 8,
    ["in perfect health"] = 9
}

function vitals_update(e)
    if e ~= "gmcp.Char.Vitals" then
        return
    end
    local vit = gmcp.Char.Vitals

    alui.status.hunger = set_hunger_color(vit.Hunger)
    alui.status.thirst = set_thirst_color(vit.Thirst)

    --handle healths
    if type(vit.List) == "table" then
        for part, health in pairs(vit.List) do
            alui.health[part] = get_health_color_from_number(convert_health_to_number(health))
        end
    end

    raiseEvent("alui status window")
end

function set_thirst_color(level)
    -- check thirst level against table and set color accordingly

    local thirst_color = thirst_colors[level]
    return thirst_color .. level .. "<reset>"
end

function set_hunger_color(level)
    -- check hunger level against table and set color accordingly

    local hunger_color = hunger_colors[level]
    return hunger_color .. level .. "<reset>"
end

function convert_health_to_number(health)


    return health_to_number[health] or 0
end

function get_health_color_from_number(healthLevel)


    return health_levels[healthLevel] .. healthLevel .. "<reset>"
end

