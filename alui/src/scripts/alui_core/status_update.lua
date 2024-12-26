function status_update(e)

    alui.status = alui.status or {}

    local blue = GUI.Colors.blue
    local green = GUI.Colors.green
    local yellow = GUI.Colors.yellow
    local orange = GUI.Colors.orange
    local red = GUI.Colors.red

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
        alui.status.mercy = status.Mercy == "On"
        GUI.Menu.Mercy:update()
    end

    if status.CommonSense then
        alui.status.commonsense = status.CommonSense == "On"
        GUI.Menu.CommonSense:update()
    end

    if status.Travel then
        alui.status.travel = status.Travel == "On"
        GUI.Menu.Travel:update()
    end

    alui.status.fatigue = fatigue_levels[status.Fatigue]
    GUI.Menu.Fatigue:update()

    alui.status.posture = status.Posture
    GUI.Menu.Posture:update()

    if status.Name and status.Age and status.Race then
        alui.status.meline = "You are " ..
                status.Name:title() .. ", a " .. status.Age .. " year old " .. status.Race .. "."
    end
    raiseEvent("alui status window")
end
