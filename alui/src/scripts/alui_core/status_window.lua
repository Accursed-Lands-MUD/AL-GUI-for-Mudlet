function status_window(e)
  if e ~= "alui status window" then return end

  alui.combatmini:clear()
  local status = alui.status
  if status.hunger then alui.combatmini:echo(f"You are {status.hunger} and {status.thirst}.\n") end
  if status.fatigue then alui.combatmini:echo(f"You are {status.fatigue}.\n") end
  if status.posture then alui.combatmini:echo(f"You are {status.posture}.\n") end
  
  local m = alui.combatmini
  
  if alui.health then
    m:echo(f[[

      Head: {alui.health.head}/9
      Body: {alui.health.body}/9
  Left Arm: {alui.health["left arm"]}/9
 Right Arm: {alui.health["right arm"]}/9
  Left Leg: {alui.health["left leg"]}/9
 Right Leg: {alui.health["right leg"]}/9]])
  end
  if alui.health["left wing"] then 
    m:echo(f[[

 Left Wing: {alui.health["left wing"]}/9]])
  end
  if alui.health["right wing"] then
    m:echo(f[[

Right Wing: {alui.health["right wing"]}/9]])
  end
  if alui.health.tail then
    m:echo(f[[

      Tail: {alui.health.tail}/9]])
  end
end