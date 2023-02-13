local EMCO = require("alui.EMCO")
alui = alui or {}
alui.chatcon = Adjustable.Container:new({
  name = "alui chat con",
  x = "75%", y = "25%",
  attached = "right",
  width = "25%",
  height = "75%",
})

alui.chat_cap = EMCO:new({
  name = "alui chat cap",
  allTab = true,
  consoles = {"All", "Say", "Chat", "Mentor", "Newbie"},
  x = 0, y = 0,
  width = "100%",
  height = "100%",
}, alui.chatcon)
