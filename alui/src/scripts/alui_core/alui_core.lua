--util funcs
function table.flip(tbl)
  local t = {}
  for k, v in pairs(tbl) do
    t[v] = k
  end
  return t
end
--end util funcs

alui = alui or {}
alui.mapcon = Adjustable.Container:new({
  name = "alui map con",
  x = 0, y = 0, 
  attached = "left",
  width = "25%",
  height = "50%",
})
alui.mapmini = Geyser.Mapper:new({
  name = "alui map window",
  x = 0, y = 0,
  width = "100%",
  height = "100%",
}, alui.mapcon)

alui.surveycon = Adjustable.Container:new({
  name = "alui survey con",
  x = "75%", y = 0, 
  width = "25%",
  height = "25%",
})

alui.surveymini = Geyser.MiniConsole:new({
  name = "alui survey mini",
  x = 0, y = 0,
  width = "100%",
  height = "100%",
  color = "black",
}, alui.surveycon)

alui.roomcon = Adjustable.Container:new({
  name = "alui room con",
  x = 0, y = "50%",
  attached = "left",
  width = "25%",
  height = "25%",
})

alui.roommini = Geyser.MiniConsole:new({
  name = "alui room miniconsole",
  x = 0, y = 0, 
  width = "100%",
  height = "100%",
  color = "black",
  autoWrap = true,
}, alui.roomcon)

alui.combatcon = Adjustable.Container:new({
  name = "alui combat con",
  x = 0, y = "75%",
  attached = "left",
  height = "25%",
  width = "25%",
})

alui.combatmini = Geyser.MiniConsole:new({
  name = "alui combat console",
  x = 0, y = 0, 
  height = "100%",
  width = "100%",
  color = "black",
  autoWrap = true,
}, alui.combatcon)

alui.stylecon = Adjustable.Container:new({
  name = "alui style con",
  x = "75%", y = 0,
  attached = "right",
  width = "25%",
  height = "25%",
})

alui.stylemini = alui.stylemini or Geyser.MiniConsole:new({
  name = "alui style console",
  x = 0, y = 0,
  width = "100%",
  height = "100%",
  color = "black",
}, alui.stylecon)

alui.chatcon = Adjustable.Container:new({
  name = "alui chat con",
  x = "75%", y = "25%",
  attached = "right",
  width = "25%",
  height = "75%",
})

