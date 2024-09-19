function status_window(e)
    if e ~= "alui status window" then
        return
    end

    alui.combatmini:clear()
    local status = alui.status
    if status.hunger then
        alui.combatmini:cecho(f "You are {status.hunger} and {status.thirst}.\n")
    end
    if status.fatigue then
        alui.combatmini:cecho(f "You are {status.fatigue}.\n")
    end
    if status.posture then
        alui.combatmini:cecho(f "You are {status.posture}.\n")
    end

    local m = alui.combatmini

    if alui.health then
        m:cecho(f [[

      Body: {alui.health.body}/9
      Head: {alui.health.head}/9
  Left Arm: {alui.health["left arm"]}/9
  Left Leg: {alui.health["left leg"]}/9]])
        if alui.health["left wing"] then
            m:cecho(f [[

 Left Wing: {alui.health["left wing"]}/9]])
        end

        m:cecho(f [[

 Right Arm: {alui.health["right arm"]}/9
 Right Leg: {alui.health["right leg"]}/9]])

        if alui.health["right wing"] then
            m:cecho(f [[

Right Wing: {alui.health["right wing"]}/9]])
        end


    end

    if alui.health.tail then
        m:cecho(f [[

      Tail: {alui.health.tail}/9]])
    end
end