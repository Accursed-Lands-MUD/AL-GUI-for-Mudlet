-- Initialize namespace
alui = alui or {}
alui.style = alui.style or {}

function style_update(event)
    if event ~= "gmcp.Char.Style" then
        return
    end

    local style = gmcp.Char.Style

    -- Store in ALUI namespace with fallback
    local styleStorage = (ALUI and ALUI.Style) or alui.style
    if ALUI and not ALUI.Style then
        ALUI.Style = {}
        styleStorage = ALUI.Style
    end

    for f, v in pairs(style) do
        if tonumber(v) then
            styleStorage[f] = tonumber(v)
            -- Maintain backward compatibility
            alui.style[f] = tonumber(v)
        else
            styleStorage[f] = v
            alui.style[f] = v
        end
    end

    -- Update GUI with namespace fallback
    local StyleUpdate = (ALUI and ALUI.GUI and ALUI.GUI.Logic and ALUI.GUI.Logic.StyleUpdate) or GUI.Style.update
    if StyleUpdate then
        StyleUpdate()
    end
end

local function updateStyleGUI()
    -- Use ALUI namespace with fallback
    local styleData = (ALUI and ALUI.Style) or alui.style

    if not styleData then
        return
    end

    -- Get GUI components with namespace fallback
    local StyleGauges = (ALUI and ALUI.GUI and ALUI.GUI.Components and ALUI.GUI.Components.StyleGauges) or GUI

    if styleData.control and StyleGauges.Style_Gauge_Aim_Control then
        StyleGauges.Style_Gauge_Aim_Control:setValue(styleData.control)
    end
    if styleData.dodge and StyleGauges.Style_Gauge_Offensive_Dodge then
        StyleGauges.Style_Gauge_Offensive_Dodge:setValue(styleData.dodge)
    end
    if styleData.parry and StyleGauges.Style_Gauge_Daring_Parry then
        StyleGauges.Style_Gauge_Daring_Parry:setValue(styleData.parry)
    end
    if styleData.speed and StyleGauges.Style_Gauge_Power_Speed then
        StyleGauges.Style_Gauge_Power_Speed:setValue(styleData.speed)
    end
    if styleData.defense and StyleGauges.Style_Gauge_Attack_Defense then
        StyleGauges.Style_Gauge_Attack_Defense:setValue(styleData.defense)
    end
end

-- Maintain backward compatibility
GUI = GUI or {}
GUI.Style = GUI.Style or {}
GUI.Style.update = updateStyleGUI

-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.style_update = style_update
    ALUI.GUI.Logic.StyleUpdate = updateStyleGUI
end
