alui.status = alui.status or {}
alui.health = alui.health or {}

local thirst_colors = {
    ["bloated"] = "<ansi_green>bloated<reset>",
    ["quenched"] = "<ansi_green>quenched<reset>",
    ["not thirsty"] = "<ansi_green>not thirsty<reset>",
    ["slightly thirsty"] = "<yellow>slightly thirsty<reset>",
    ["moderately thirsty"] = "<yellow>moderately thirsty<reset>",
    ["thirsty"] = "<yellow>thirsty<reset>",
    ["very thirsty"] = "<ansi_red>very thirsty<reset>",
    ["parched"] = "<ansi_red>parched<reset>",
    ["dehydrated"] = "<ansi_light_red>dehydrated<reset>",
    ["dying of thirst"] = "<ansi_light_red>dying of thirst<reset>",
}

local hunger_colors = {
    ["stuffed"] = "<ansi_green>stuffed<reset>",
    ["full"] = "<ansi_green>full<reset>",
    ["satiated"] = "<ansi_green>satiated<reset>",
    ["not hungry"] = "<ansi_green>not hungry<reset>",
    ["peckish"] = "<yellow>peckish<reset>",
    ["slightly hungry"] = "<yellow>sightly hungry<reset>",
    ["hungry"] = "<yellow>hungry<reset>",
    ["very hungry"] = "<red>vry hungry<reset>",
    ["famished"] = "<red>famished<reset>",
    ["starving"] = "<red>starving<reset>",
    ["dying of hunger"] = "<red>dying of hunger<reset>",
}

local health_levels = {
    ["destroyed"] = "<ansi_light_yellow:ansi_light_red>-1<reset>",
    ["broken"] = "<ansi_light_yellow:ansi_light_red>0<reset>",
    ["massively injured"] = "<ansi_red:ansi_light_yellow>1<reset>",
    ["horribly injured"] = "<ansi_light_red>2<reset>",
    ["badly injured"] = "<ansi_light_red>3<reset>",
    ["injured"] = "<ansi_light_yellow>4<reset>",
    ["badly hurt"] = "<ansi_light_yellow>5<reset>",
    ["hurt"] = "<ansi_light_yellow>6<reset>",
    ["slightly wounded"] = "<ansi_light_green>7<reset>",
    ["barely wounded"] = "<ansi_light_green>8<reset>",
    ["in perfect health"] = "<ansi_light_cyan>9<reset>",
}

function vitals_update(e)
    if e ~= "gmcp.Char.Vitals" then
        return
    end
    local vit = gmcp.Char.Vitals

    alui.status.hunger = hunger_colors[vit.Hunger]
    alui.status.thirst = thirst_colors[vit.Thirst]

    --handle healths
    if type(vit.List) == "table" then
        for part, health in pairs(vit.List) do
            alui.health[part] = health_levels[health]
        end
    end

    raiseEvent("alui status window")
end
