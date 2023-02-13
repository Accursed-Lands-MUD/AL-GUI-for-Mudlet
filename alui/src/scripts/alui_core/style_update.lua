alui.style = alui.style or {}


function style_update(event)
  if event ~= "gmcp.Char.Style" then return end
  local style = gmcp.Char.Style
  for f, v in pairs(style) do
    if tonumber(v) then
      alui.style[f] = tonumber(v)
    else
      alui.style[f] = v
    end
  end
  
  alui.stylemini:clear()
  alui.stylemini:cecho(f[[
You are aiming at the {alui.style.Aim}.
{alui.style.Control}
<green>
Aim       {bar(alui.style.aim, alui.style.control)} Control
Offensive {bar(alui.style.offensive, 100-alui.style.offensive)} Dodge
Daring    {bar(alui.style.daring, alui.style.parry)} Parry
Power     {bar(alui.style.power, alui.style.speed)} Speed
Attack    {bar(alui.style.attack, alui.style.defense)} Defense
  ]])
end

function bar(x1, x2)
  local space1 = x2/2
  local space2 = x1/2
  local out = f[=[<green>[<red>{string.rep(" ", space1)}*{string.rep(" ", space2)}<green>]]=]
  return out
end