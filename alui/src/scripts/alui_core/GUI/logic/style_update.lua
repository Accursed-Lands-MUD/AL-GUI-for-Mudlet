alui.style = alui.style or {}

--- Creates a bar for the style window when given the two values to compare.
--- @param x1 number
--- @param x2 number
local function bar(x1, x2)
    local space1 = x2 / 2
    local space2 = x1 / 2
    local out = "<green>[<red>" .. string.rep(" ", space1) .. "*" .. string.rep(" ", space2) .. "<green>]"
    return out
end

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


    -- echo('\nstyle:\n' .. yajl.to_string(alui.style) .. '\n')

    GUI.Style_Gauge_Aim_Control:setValue(alui.style.control)
    GUI.Style_Gauge_Offensive_Dodge:setValue(alui.style.dodge)
    GUI.Style_Gauge_Daring_Parry:setValue(alui.style.parry)
    GUI.Style_Gauge_Power_Speed:setValue(alui.style.speed)
    GUI.Style_Gauge_Attack_Defense:setValue(alui.style.defense)



    -- alui.stylemini:clear()

    -- alui.stylemini:cecho("You are aiming at the " .. alui.style.Aim .. ".\n")
    -- alui.stylemini:cecho(alui.style.Control .. "<green>\n")
    -- alui.stylemini:cecho("<green>Aim       " .. bar(alui.style.aim, alui.style.control) .. " Control\n")
    -- alui.stylemini:cecho("<green>Offensive " .. bar(alui.style.offensive, 100 - alui.style.offensive) .. " Dodge\n")
    -- alui.stylemini:cecho("<green>Daring    " .. bar(alui.style.daring, alui.style.parry) .. " Parry\n")
    -- alui.stylemini:cecho("<green>Power     " .. bar(alui.style.power, alui.style.speed) .. " Speed\n")
    -- alui.stylemini:cecho("<green>Attack    " .. bar(alui.style.attack, alui.style.defense) .. " Defense\n")
end
