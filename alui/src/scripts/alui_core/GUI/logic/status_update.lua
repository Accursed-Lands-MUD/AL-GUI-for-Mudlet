function status_update(e)
    -- Initialize status storage with ALUI namespace preference
    local Status = (ALUI and ALUI.Status) or {}
    if ALUI and ALUI.Status then
        ALUI.Status = ALUI.Status
    else
        alui.status = alui.status or {}
    end

    -- Use ALUI namespace for colors with fallback
    local Colors = (ALUI and ALUI.GUI and ALUI.GUI.Colors) or GUI.Colors or {}
    local Config = (ALUI and ALUI.Config) or {}

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


    -- {"AddEffect":"Your mind feels very awake.","Mercy":"On","Gender":"male","CommonSense":"On","Fatigue":"somewhat tired","Race":"molok","Name":"batu","Travel":"Off","Posture":"standing","Age":"25"}



    if status.Mercy then
        -- Store in namespace with fallback
        if ALUI and ALUI.Status then
            ALUI.Status.mercy = status.Mercy == "On"
        else
            alui.status.mercy = status.Mercy == "On"
        end

        -- Update GUI with namespace fallback
        local Menu = (ALUI and ALUI.GUI and ALUI.GUI.Components and ALUI.GUI.Components.Menu) or GUI.Menu
        if Menu and Menu.Mercy and Menu.Mercy.update then
            Menu.Mercy:update()
        end
    end

    if status.CommonSense then
        if ALUI and ALUI.Status then
            ALUI.Status.commonsense = status.CommonSense == "On"
        else
            alui.status.commonsense = status.CommonSense == "On"
        end

        local Menu = (ALUI and ALUI.GUI and ALUI.GUI.Components and ALUI.GUI.Components.Menu) or GUI.Menu
        if Menu and Menu.CommonSense and Menu.CommonSense.update then
            Menu.CommonSense:update()
        end
    end

    if status.Travel then
        if ALUI and ALUI.Status then
            ALUI.Status.travel = status.Travel == "On"
        else
            alui.status.travel = status.Travel == "On"
        end

        local Menu = (ALUI and ALUI.GUI and ALUI.GUI.Components and ALUI.GUI.Components.Menu) or GUI.Menu
        if Menu and Menu.Travel and Menu.Travel.update then
            Menu.Travel:update()
        end
    end

    -- Store fatigue and posture data
    if ALUI and ALUI.Status then
        ALUI.Status.fatigue = fatigue_levels[status.Fatigue]
        ALUI.Status.posture = status.Posture
    else
        alui.status.fatigue = fatigue_levels[status.Fatigue]
        alui.status.posture = status.Posture
    end

    local Menu = (ALUI and ALUI.GUI and ALUI.GUI.Components and ALUI.GUI.Components.Menu) or GUI.Menu
    if Menu then
        if Menu.Fatigue and Menu.Fatigue.update then
            Menu.Fatigue:update()
        end
        if Menu.Posture and Menu.Posture.update then
            Menu.Posture:update()
        end
    end
    if status.Name and status.Age and status.Race then
        if ALUI and ALUI.Status then
            ALUI.Status.meline = "You are " ..
                status.Name:title() .. ", a " .. status.Age .. " year old " .. status.Race .. "."
        else
            alui.status.meline = "You are " ..
                status.Name:title() .. ", a " .. status.Age .. " year old " .. status.Race .. "."
        end
    end

    raiseEvent("alui status window")
end

-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.status_update = status_update
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("status_update.lua")
end
