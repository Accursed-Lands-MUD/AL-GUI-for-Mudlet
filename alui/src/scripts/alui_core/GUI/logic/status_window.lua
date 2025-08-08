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

    local m = alui.combatmini
    if not m then
        return
    end

    m:clear()

    if alui.health then
        m:cecho(NEWLINE)

        local health = alui.health
        local bleeding = alui.bleeding

        -- Display all body parts using helper function
        displayBodyPart(m, health, bleeding, "body", "      Body")
        displayBodyPart(m, health, bleeding, "head", "      Head")
        displayBodyPart(m, health, bleeding, "left arm", "  Left Arm")
        displayBodyPart(m, health, bleeding, "left leg", "  Left Leg")
        displayBodyPart(m, health, bleeding, "left wing", " Left Wing")
        displayBodyPart(m, health, bleeding, "right arm", " Right Arm")
        displayBodyPart(m, health, bleeding, "right leg", " Right Leg")
        displayBodyPart(m, health, bleeding, "right wing", "Right Wing")
        displayBodyPart(m, health, bleeding, "tail", "      Tail")
        displayBodyPart(m, health, bleeding, "left front leg", "Left Front Leg")
        displayBodyPart(m, health, bleeding, "left hind leg", "Left Hind Leg")
        displayBodyPart(m, health, bleeding, "left rear leg", "Left Rear Leg")
        displayBodyPart(m, health, bleeding, "lower left arm", "Lower Left Arm")
        displayBodyPart(m, health, bleeding, "lower right arm", "Lower Right Arm")
        displayBodyPart(m, health, bleeding, "lower torso", "Lower Torso")
        displayBodyPart(m, health, bleeding, "right front leg", "Right Front Leg")
        displayBodyPart(m, health, bleeding, "right hind leg", "Right Hind Leg")
        displayBodyPart(m, health, bleeding, "right rear leg", "Right Rear Leg")
        displayBodyPart(m, health, bleeding, "upper left arm", "Upper Left Arm")
        displayBodyPart(m, health, bleeding, "upper right arm", "Upper Right Arm")
        displayBodyPart(m, health, bleeding, "upper torso", "Upper Torso")
        displayBodyPart(m, health, bleeding, "lower left tentacle", "Lower Left Tentacle")
        displayBodyPart(m, health, bleeding, "lower right tentacle", "Lower Right Tentacle")
        displayBodyPart(m, health, bleeding, "primary tentacle", "Primary Tentacle")
        displayBodyPart(m, health, bleeding, "torso", "     Torso")
        displayBodyPart(m, health, bleeding, "upper left tentacle", "Upper Left Tentacle")
        displayBodyPart(m, health, bleeding, "upper right tentacle", "Upper Right Tentacle")
    end
end
