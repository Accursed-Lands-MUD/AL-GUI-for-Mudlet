alui.status = alui.status or {}

function status_update(e)
  if e ~= "gmcp.Char.Status" then return end
  
  local status = gmcp.Char.Status
  
  alui.status.fatigue = status.Fatigue
  alui.status.posture = status.Posture
  alui.status.meline = f"You are {status.Name:title()}, a {status.Age} year old {status.Race}."
  
  raiseEvent("alui status window")
end

