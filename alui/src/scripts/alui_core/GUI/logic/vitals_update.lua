alui = alui or {}
alui.status = alui.status or {}
alui.health = alui.health or {}
alui.bleeding = alui.bleeding or {}

local blue = GUI.Colors.blue
local green = GUI.Colors.green
local yellow = GUI.Colors.yellow
local orange = GUI.Colors.orange
local red = GUI.Colors.red

local thirst_colors = {
    ["bloated"] = blue,
    ["quenched"] = green,
    ["not thirsty"] = green,
    ["slightly thirsty"] = yellow,
    ["moderately thirsty"] = yellow,
    ["thirsty"] = yellow,
    ["very thirsty"] = orange,
    ["parched"] = orange,
    ["dehydrated"] = red,
    ["dying of thirst"] = red,
}


-- 1. Stuffed
-- 2. Full
-- 3. Satiated
-- 4. Not Hungry
-- 5. Peckish
-- 6. Slightly Hungry
-- 7. Hungry
-- 8. Very Hungry
-- 9. Famished
-- 10. Ravenous
-- 11. Starving
-- 12. Dying of Hunger


local hunger_colors = {
    ["stuffed"] = blue,
    ["full"] = green,
    ["satiated"] = green,
    ["not hungry"] = green,
    ["peckish"] = yellow,
    ["slightly hungry"] = yellow,
    ["hungry"] = yellow,
    ["very hungry"] = orange,
    ["famished"] = orange,
    ["ravenous"] = orange,
    ["starving"] = red,
    ["dying of hunger"] = red,
}

local health_levels = {
    ["missing"] = "<ansi_light_yellow:ansi_light_red>missing<reset>",
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


    -- local wounds = gmcp.Char.Wounds
    -- echo('\n' .. yajl.to_string(wounds) .. '\n')


    alui.status.hunger = hunger_colors[vit.Hunger]
    GUI.Menu.Hunger:update()

    alui.status.thirst = thirst_colors[vit.Thirst]
    GUI.Menu.Thirst:update()

    --handle healths
    if type(vit.List) == "table" then
        for part, health_and_bleading in pairs(vit.List) do
            local health_ends, _ = string.find(health_and_bleading, " and ")

            -- if there is a " and " in the string, then the health is followed by a bleeding status
            if health_ends then
                -- get the health status without the bleeding status
                health_and_bleading = string.sub(health_and_bleading, 1, health_ends - 1)
                -- set the bleeding status for this part to true
                alui.bleeding[part] = true
            else
                -- set the bleeding status for this part to false
                alui.bleeding[part] = false
            end
            -- set the health status for this part
            alui.health[part] = health_levels[health_and_bleading]
        end
    end

    raiseEvent("alui status window")
end
