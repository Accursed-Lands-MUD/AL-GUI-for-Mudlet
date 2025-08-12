-- Pre-calculated strings for better performance
local BLEEDING_TEXT = " <red>bleeding<reset>"
local HEALTH_SUFFIX = "/9"
local NEWLINE = "\n"

-- Helper function to format health status with optional bleeding
local function formatHealthStatus(label, health_value, is_bleeding)
    if is_bleeding then
        return string.format("%s: %s%s%s%s", label, health_value, HEALTH_SUFFIX, BLEEDING_TEXT, NEWLINE)
    else
        return string.format("%s: %s%s%s", label, health_value, HEALTH_SUFFIX, NEWLINE)
    end
end

-- Helper function to display health for a body part if it exists
local function displayBodyPart(m, health, bleeding, part_name, display_label)
    if health[part_name] then
        local formatted_text = formatHealthStatus(display_label, health[part_name], bleeding[part_name])
        m:cecho(formatted_text)
    end
end

function status_window(e)
    if e ~= "alui status window" then
        return
    end

    -- Use ALUI namespace for combat mini with fallback
    local combatmini = ALUI.GUI.Components.combatmini
    if not combatmini then
        return
    end

    combatmini:clear()

    -- Use ALUI namespace for health data
    local healthData = (ALUI and ALUI.Health)
    if healthData then
        combatmini:cecho(NEWLINE)

        local health = healthData
        local bleeding = (ALUI and ALUI.Bleeding)

        -- Display all body parts using helper function
        displayBodyPart(combatmini, health, bleeding, "body", "      Body")
        displayBodyPart(combatmini, health, bleeding, "head", "      Head")
        displayBodyPart(combatmini, health, bleeding, "left arm", "  Left Arm")
        displayBodyPart(combatmini, health, bleeding, "left leg", "  Left Leg")
        displayBodyPart(combatmini, health, bleeding, "left wing", " Left Wing")
        displayBodyPart(combatmini, health, bleeding, "right arm", " Right Arm")
        displayBodyPart(combatmini, health, bleeding, "right leg", " Right Leg")
        displayBodyPart(combatmini, health, bleeding, "right wing", "Right Wing")
        displayBodyPart(combatmini, health, bleeding, "tail", "      Tail")
        displayBodyPart(combatmini, health, bleeding, "left front leg", "Left Front Leg")
        displayBodyPart(combatmini, health, bleeding, "left hind leg", "Left Hind Leg")
        displayBodyPart(combatmini, health, bleeding, "left rear leg", "Left Rear Leg")
        displayBodyPart(combatmini, health, bleeding, "lower left arm", "Lower Left Arm")
        displayBodyPart(combatmini, health, bleeding, "lower right arm", "Lower Right Arm")
        displayBodyPart(combatmini, health, bleeding, "lower torso", "Lower Torso")
        displayBodyPart(combatmini, health, bleeding, "right front leg", "Right Front Leg")
        displayBodyPart(combatmini, health, bleeding, "right hind leg", "Right Hind Leg")
        displayBodyPart(combatmini, health, bleeding, "right rear leg", "Right Rear Leg")
        displayBodyPart(combatmini, health, bleeding, "upper left arm", "Upper Left Arm")
        displayBodyPart(combatmini, health, bleeding, "upper right arm", "Upper Right Arm")
        displayBodyPart(combatmini, health, bleeding, "upper torso", "Upper Torso")
        displayBodyPart(combatmini, health, bleeding, "lower left tentacle", "Lower Left Tentacle")
        displayBodyPart(combatmini, health, bleeding, "lower right tentacle", "Lower Right Tentacle")
        displayBodyPart(combatmini, health, bleeding, "primary tentacle", "Primary Tentacle")
        displayBodyPart(combatmini, health, bleeding, "torso", "     Torso")
        displayBodyPart(combatmini, health, bleeding, "upper left tentacle", "Upper Left Tentacle")
        displayBodyPart(combatmini, health, bleeding, "upper right tentacle", "Upper Right Tentacle")
    end
end

-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.status_window = status_window
end
