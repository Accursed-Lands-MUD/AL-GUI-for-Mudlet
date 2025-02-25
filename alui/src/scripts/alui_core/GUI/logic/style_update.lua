alui.style = alui.style or {}

function style_update(event)
    if event ~= "gmcp.Char.Style" then
        return
    end
    local style = gmcp.Char.Style
    for f, v in pairs(style) do
        if tonumber(v) then
            alui.style[f] = tonumber(v)
        else
            alui.style[f] = v
        end
    end


    ---- echo('\nstyle:\n' .. yajl.to_string(alui.style) .. '\n')
    --
    --GUI.Style_Gauge_Aim_Control:setValue(alui.style.control)
    --GUI.Style_Gauge_Offensive_Dodge:setValue(alui.style.dodge)
    --GUI.Style_Gauge_Daring_Parry:setValue(alui.style.parry)
    --GUI.Style_Gauge_Power_Speed:setValue(alui.style.speed)
    --GUI.Style_Gauge_Attack_Defense:setValue(alui.style.defense)

    GUI.Style.update()

end

GUI.Style.update = function()
    if alui.style then
        if alui.style.control then
            GUI.Style_Gauge_Aim_Control:setValue(alui.style.control)
        end
        if alui.style.dodge then
            GUI.Style_Gauge_Offensive_Dodge:setValue(alui.style.dodge)
        end
        if alui.style.parry then
            GUI.Style_Gauge_Daring_Parry:setValue(alui.style.parry)
        end
        if alui.style.speed then
            GUI.Style_Gauge_Power_Speed:setValue(alui.style.speed)
        end
        if alui.style.defense then
            GUI.Style_Gauge_Attack_Defense:setValue(alui.style.defense)
        end
    end
end