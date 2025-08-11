-- vitals_update.lua - Migrated to ALUI namespace structure
-- Handles game vitals processing with new namespace while maintaining backward compatibility

-- Initialize both old and new namespace structures for compatibility
alui = alui or {}
alui.status = alui.status or {}
alui.health = alui.health or {}
alui.bleeding = alui.bleeding or {}

-- Use ALUI namespace for new structure, with fallbacks for compatibility
local Status = (ALUI and ALUI.Status) or {}
local Health = (ALUI and ALUI.Health) or {}
local Colors = (ALUI and ALUI.GUI and ALUI.GUI.Colors) or GUI.Colors or {}
local Config = (ALUI and ALUI.Config) or {}

-- Get colors from configuration if available, otherwise use direct references
local function getColor(configPath, fallbackColor)
    if Config.get then
        return Config.get(configPath, fallbackColor)
    end
    return fallbackColor
end

-- Use configured colors or fallback to hardcoded values
local blue = getColor("colors.primary.blue", Colors.blue or '#2A768C')
local green = getColor("colors.primary.green", Colors.green or '#2EA652')
local yellow = getColor("colors.primary.yellow", Colors.yellow or '#E1B03E')
local orange = getColor("colors.primary.orange", Colors.orange or '#C3701C')
local red = getColor("colors.primary.red", Colors.red or '#830000')

-- Use configured vitals colors if available
local thirst_colors = {}
local hunger_colors = {}

if Config.get then
    -- Try to use configured vitals colors
    local vitalsConfig = Config.get("colors.vitals", {})
    if vitalsConfig.thirst then
        thirst_colors = {
            ["bloated"] = vitalsConfig.thirst[1] or blue,
            ["quenched"] = vitalsConfig.thirst[1] or green,
            ["not thirsty"] = vitalsConfig.thirst[1] or green,
            ["slightly thirsty"] = vitalsConfig.thirst[2] or yellow,
            ["moderately thirsty"] = vitalsConfig.thirst[2] or yellow,
            ["thirsty"] = vitalsConfig.thirst[2] or yellow,
            ["very thirsty"] = vitalsConfig.thirst[3] or orange,
            ["parched"] = vitalsConfig.thirst[3] or orange,
            ["dehydrated"] = vitalsConfig.thirst[4] or red,
            ["dying of thirst"] = vitalsConfig.thirst[4] or red,
        }
    end

    if vitalsConfig.hunger then
        hunger_colors = {
            ["stuffed"] = vitalsConfig.hunger[1] or blue,
            ["full"] = vitalsConfig.hunger[1] or green,
            ["satiated"] = vitalsConfig.hunger[1] or green,
            ["not hungry"] = vitalsConfig.hunger[1] or green,
            ["peckish"] = vitalsConfig.hunger[2] or yellow,
            ["slightly hungry"] = vitalsConfig.hunger[2] or yellow,
            ["hungry"] = vitalsConfig.hunger[2] or yellow,
            ["very hungry"] = vitalsConfig.hunger[3] or orange,
            ["famished"] = vitalsConfig.hunger[3] or orange,
            ["ravenous"] = vitalsConfig.hunger[3] or orange,
            ["starving"] = vitalsConfig.hunger[4] or red,
            ["dying of hunger"] = vitalsConfig.hunger[4] or red,
        }
    end
end

-- Fallback to hardcoded colors if no configuration available
if not next(thirst_colors) then
    thirst_colors = {
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
end

if not next(hunger_colors) then
    hunger_colors = {
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
end

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

-- Core vitals update function
local function updateVitals(e)
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
        -- Update both old and new namespace structures
        alui.status.hunger = hunger_colors[vit.Hunger]
        if Status.vitals then
            Status.vitals.hunger = hunger_colors[vit.Hunger]
        end

        if GUI.Menu and GUI.Menu.Hunger and GUI.Menu.Hunger.update then
            GUI.Menu.Hunger:update()
        end
    end

    -- Update thirst status with validation
    if vit.Thirst and thirst_colors[vit.Thirst] then
        -- Update both old and new namespace structures
        alui.status.thirst = thirst_colors[vit.Thirst]
        if Status.vitals then
            Status.vitals.thirst = thirst_colors[vit.Thirst]
        end

        if GUI.Menu and GUI.Menu.Thirst and GUI.Menu.Thirst.update then
            GUI.Menu.Thirst:update()
        end
    end

    -- Handle health information
    if type(vit.List) == "table" then
        for part, health_and_bleading in pairs(vit.List) do
            -- Use pattern matching instead of string.find and string.sub for better performance
            local health_status, has_bleeding = health_and_bleading:match("^(.+) and ")

            if health_status then
                -- There is bleeding - update both namespace structures
                alui.bleeding[part] = true
                alui.health[part] = health_levels[health_status]

                if Status.bleeding then
                    Status.bleeding[part] = true
                end
                if Health then
                    Health[part] = health_levels[health_status]
                end
            else
                -- No bleeding, use the full string as health status
                alui.bleeding[part] = false
                alui.health[part] = health_levels[health_and_bleading]

                if Status.bleeding then
                    Status.bleeding[part] = false
                end
                if Health then
                    Health[part] = health_levels[health_and_bleading]
                end
            end
        end
    end

    raiseEvent("alui status window")
end

-- Register the function in both old and new systems
vitals_update = updateVitals

-- Register in ALUI namespace if available
if ALUI and ALUI.Status then
    ALUI.Status.updateVitals = updateVitals
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("vitals_update.lua")
end
