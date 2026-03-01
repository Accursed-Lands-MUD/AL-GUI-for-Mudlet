function style_update(event)
    if event ~= "gmcp.Char.Style" then
        return
    end

    local style = gmcp.Char.Style

    -- Store in ALUI namespace with fallback
    local styleStorage = (ALUI and ALUI.Style)
    if ALUI and not ALUI.Style then
        ALUI.Style = {}
        styleStorage = ALUI.Style
    end

    for f, v in pairs(style) do
        if tonumber(v) then
            styleStorage[f] = tonumber(v)
        else
            styleStorage[f] = v
        end
    end


    local StyleUpdate = (ALUI and ALUI.GUI and ALUI.GUI.Logic and ALUI.GUI.Logic.StyleUpdate)
    if StyleUpdate then
        StyleUpdate()
    end
end

local function updateStyleGUI()
    local styleData = (ALUI and ALUI.Style)

    if not styleData then
        return
    end


    local GUI = (ALUI and ALUI.GUI and ALUI.GUI) or {}


    if styleData.control and GUI.Style_Gauge_Aim_Control then
        GUI.Style_Gauge_Aim_Control:setValue(styleData.control)
    end
    if styleData.dodge and GUI.Style_Gauge_Offensive_Dodge then
        GUI.Style_Gauge_Offensive_Dodge:setValue(styleData.dodge)
    end
    if styleData.parry and GUI.Style_Gauge_Daring_Parry then
        GUI.Style_Gauge_Daring_Parry:setValue(styleData.parry)
    end
    if styleData.speed and GUI.Style_Gauge_Power_Speed then
        GUI.Style_Gauge_Power_Speed:setValue(styleData.speed)
    end
    if styleData.defense and GUI.Style_Gauge_Attack_Defense then
        GUI.Style_Gauge_Attack_Defense:setValue(styleData.defense)
    end
end


-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.style_update = style_update
    ALUI.GUI.Logic.StyleUpdate = updateStyleGUI
end
