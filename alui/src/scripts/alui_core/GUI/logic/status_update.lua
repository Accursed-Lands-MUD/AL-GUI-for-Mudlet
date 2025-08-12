function status_update(e)
    -- Initialize ALUI namespace
    ALUI = ALUI or {}
    ALUI.Status = ALUI.Status or {}
    ALUI.Status.vitals = ALUI.Status.vitals or {}

    -- Use ALUI namespace for colors
    local Colors = ALUI.GUI.Colors or {}
    local Config = ALUI.Config or {}

    local blue = Colors.blue
    local green = Colors.green
    local yellow = Colors.yellow
    local orange = Colors.orange
    local red = Colors.red

    local fatigue_levels = {
        ["well rested"] = blue,
        ["barely tired"] = green,
        ["somewhat tired"] = green,
        ["winded"] = green,
        ["tired"] = green,
        ["weary"] = yellow,
        ["haggard"] = yellow,
        ["worn out"] = yellow,
        ["exhausted"] = orange,
        ["disoriented"] = orange,
        ["faint"] = red,
        ["system shocked"] = red
    }

    if e ~= "gmcp.Char.Status" then
        return
    end

    local status = gmcp.Char.Status

    if status.Mercy then
        local mercyValue = status.Mercy == "On"
        -- Store in both locations for compatibility
        ALUI.Status.mercy = mercyValue
        ALUI.Status.vitals.mercy = mercyValue

        local Menu = ALUI.GUI.Components.Menu or GUI.Menu
        if Menu and Menu.Mercy and Menu.Mercy.update then
            Menu.Mercy:update()
        end
    end

    if status.CommonSense then
        local commonsenseValue = status.CommonSense == "On"
        -- Store in both locations for compatibility
        ALUI.Status.commonsense = commonsenseValue
        ALUI.Status.vitals.commonsense = commonsenseValue

        local Menu = ALUI.GUI.Components.Menu or GUI.Menu
        if Menu and Menu.CommonSense and Menu.CommonSense.update then
            Menu.CommonSense:update()
        end
    end

    if status.Travel then
        local travelValue = status.Travel == "On"
        -- Store in both locations for compatibility
        ALUI.Status.travel = travelValue
        ALUI.Status.vitals.travel = travelValue

        local Menu = ALUI.GUI.Components.Menu or GUI.Menu
        if Menu and Menu.Travel and Menu.Travel.update then
            Menu.Travel:update()
        end
    end

    -- Store fatigue and posture data
    ALUI.Status.vitals.fatigue = fatigue_levels[status.Fatigue]
    ALUI.Status.vitals.posture = status.Posture

    local Menu = ALUI.GUI.Components.Menu or GUI.Menu
    if Menu then
        if Menu.Fatigue and Menu.Fatigue.update then
            Menu.Fatigue:update()
        end
        if Menu.Posture and Menu.Posture.update then
            Menu.Posture:update()
        end
    end

    if status.Name and status.Age and status.Race then
        ALUI.Status.vitals.meline = "You are " ..
            status.Name:title() .. ", a " .. status.Age .. " year old " .. status.Race .. "."
    end

    raiseEvent("ALUI status window")
end

-- Register with ALUI namespace
ALUI.GUI.Logic = ALUI.GUI.Logic or {}
ALUI.GUI.Logic.status_update = status_update
