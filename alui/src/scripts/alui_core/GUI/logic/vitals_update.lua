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

-- Pre-calculated health level strings for better performance
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

    -- Validate GMCP data exists before proceeding
    if not gmcp or not gmcp.Char or not gmcp.Char.Vitals then
        return
    end

    local vit = gmcp.Char.Vitals


    -- Update hunger status with validation
    if vit.Hunger and hunger_colors[vit.Hunger] then
        alui.status.hunger = hunger_colors[vit.Hunger]
        if GUI.Menu and GUI.Menu.Hunger and GUI.Menu.Hunger.update then
            GUI.Menu.Hunger:update()
        end
    end

    -- Update thirst status with validation
    if vit.Thirst and thirst_colors[vit.Thirst] then
        alui.status.thirst = thirst_colors[vit.Thirst]
        if GUI.Menu and GUI.Menu.Thirst and GUI.Menu.Thirst.update then
            GUI.Menu.Thirst:update()
        end
    end

    --handle healths
    if type(vit.List) == "table" then
        for part, health_and_bleading in pairs(vit.List) do
            -- Use pattern matching instead of string.find and string.sub for better performance
            local health_status, has_bleeding = health_and_bleading:match("^(.+) and ")

            echo('\nhealth part update: ' ..
                part .. ' - ' .. health_and_bleading .. ', health_status: ' .. (health_status or "unknown"))

            if health_status then
                -- There is bleeding
                alui.bleeding[part] = true
                alui.health[part] = health_levels[health_status]
            else
                -- No bleeding, use the full string as health status
                alui.bleeding[part] = false
                alui.health[part] = health_levels[health_and_bleading]
            end
        end
    end

    raiseEvent("alui status window")
end
