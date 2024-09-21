function status_window(e)
    if e ~= "alui status window" then
        return
    end

    alui.combatmini:clear()
    local status = alui.status
    local bleeding = alui.bleeding
    if status.hunger then
        alui.combatmini:cecho("You are " .. status.hunger .. " and " .. status.thirst .. ".")
    end
    if status.fatigue then
        alui.combatmini:cecho("You are " .. status.fatigue .. ".")
    end
    if status.posture then
        alui.combatmini:cecho("You are " .. status.posture .. ".")
    end

    local m = alui.combatmini

    if alui.health then

        m:cecho("")

        if alui.health.body then
            m:cecho("      Body: " .. alui.health.body .. "/9")
            if bleeding.body then
                m:cecho(" (" .. bleeding.body .. ")")
            end

            m:cecho("\n")
        end

        if alui.health.head then
            m:cecho("      Head: " .. alui.health.head .. "/9")
            if bleeding.head then
                m:cecho(" (" .. bleeding.head .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["left arm"] then
            m:cecho("  Left Arm: " .. alui.health["left arm"] .. "/9")
            if bleeding["left arm"] then
                m:cecho(" (" .. bleeding["left arm"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["left leg"] then
            m:cecho("  Left Leg: " .. alui.health["left leg"] .. "/9")
            if bleeding["left leg"] then
                m:cecho(" (" .. bleeding["left leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["left wing"] then
            m:cecho("Left Wing: " .. alui.health["left wing"] .. "/9")
            if bleeding["left wing"] then
                m:cecho(" (" .. bleeding["left wing"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["right arm"] then
            m:cecho(" Right Arm: " .. alui.health["right arm"] .. "/9")
            if bleeding["right arm"] then
                m:cecho(" (" .. bleeding["right arm"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["right leg"] then
            m:cecho(" Right Leg: " .. alui.health["right leg"] .. "/9")
            if bleeding["right leg"] then
                m:cecho(" (" .. bleeding["right leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["right wing"] then
            m:cecho("Right Wing: " .. alui.health["right wing"] .. "/9")
            if bleeding["right wing"] then
                m:cecho(" (" .. bleeding["right wing"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health.tail then
            m:cecho("      Tail: " .. alui.health.tail .. "/9")
            if bleeding.tail then
                m:cecho(" (" .. bleeding.tail .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["left front leg"] then
            m:cecho("Left Front Leg: " .. alui.health["left front leg"] .. "/9")
            if bleeding["left front leg"] then
                m:cecho(" (" .. bleeding["left front leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["left hind leg"] then
            m:cecho("Left Hind Leg: " .. alui.health["left hind leg"] .. "/9")
            if bleeding["left hind leg"] then
                m:cecho(" (" .. bleeding["left hind leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["left rear leg"] then
            m:cecho("Left Rear Leg: " .. alui.health["left rear leg"] .. "/9")
            if bleeding["left rear leg"] then
                m:cecho(" (" .. bleeding["left rear leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["lower left arm"] then
            m:cecho("Lower Left Arm: " .. alui.health["lower left arm"] .. "/9")
            if bleeding["lower left arm"] then
                m:cecho(" (" .. bleeding["lower left arm"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["lower right arm"] then
            m:cecho("Lower Right Arm: " .. alui.health["lower right arm"] .. "/9")
            if bleeding["lower right arm"] then
                m:cecho(" (" .. bleeding["lower right arm"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["lower torso"] then
            m:cecho("Lower Torso: " .. alui.health["lower torso"] .. "/9")
            if bleeding["lower torso"] then
                m:cecho(" (" .. bleeding["lower torso"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["right front leg"] then
            m:cecho("Right Front Leg: " .. alui.health["right front leg"] .. "/9")
            if bleeding["right front leg"] then
                m:cecho(" (" .. bleeding["right front leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["right hind leg"] then
            m:cecho("Right Hind Leg: " .. alui.health["right hind leg"] .. "/9")
            if bleeding["right hind leg"] then
                m:cecho(" (" .. bleeding["right hind leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["right rear leg"] then
            m:cecho("Right Rear Leg: " .. alui.health["right rear leg"] .. "/9")
            if bleeding["right rear leg"] then
                m:cecho(" (" .. bleeding["right rear leg"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["upper left arm"] then
            m:cecho("Upper Left Arm: " .. alui.health["upper left arm"] .. "/9")
            if bleeding["upper left arm"] then
                m:cecho(" (" .. bleeding["upper left arm"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["upper right arm"] then
            m:cecho("Upper Right Arm: " .. alui.health["upper right arm"] .. "/9")
            if bleeding["upper right arm"] then
                m:cecho(" (" .. bleeding["upper right arm"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["upper torso"] then
            m:cecho("Upper Torso: " .. alui.health["upper torso"] .. "/9")
            if bleeding["upper torso"] then
                m:cecho(" (" .. bleeding["upper torso"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["lower left tentacle"] then
            m:cecho("Lower Left Tentacle: " .. alui.health["lower left tentacle"] .. "/9")
            if bleeding["lower left tentacle"] then
                m:cecho(" (" .. bleeding["lower left tentacle"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["lower right tentacle"] then
            m:cecho("Lower Right Tentacle: " .. alui.health["lower right tentacle"] .. "/9")
            if bleeding["lower right tentacle"] then
                m:cecho(" (" .. bleeding["lower right tentacle"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["primary tentacle"] then
            m:cecho("Primary Tentacle: " .. alui.health["primary tentacle"] .. "/9")
            if bleeding["primary tentacle"] then
                m:cecho(" (" .. bleeding["primary tentacle"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health.torso then
            m:cecho("Torso: " .. alui.health.torso .. "/9")
            if bleeding.torso then
                m:cecho(" (" .. bleeding.torso .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["upper left tentacle"] then
            m:cecho("Upper Left Tentacle: " .. alui.health["upper left tentacle"] .. "/9")
            if bleeding["upper left tentacle"] then
                m:cecho(" (" .. bleeding["upper left tentacle"] .. ")")
            end
            m:cecho("\n")
        end

        if alui.health["upper right tentacle"] then
            m:cecho("Upper Right Tentacle: " .. alui.health["upper right tentacle"] .. "/9")
            if bleeding["upper right tentacle"] then
                m:cecho(" (" .. bleeding["upper right tentacle"] .. ")")
            end
            m:cecho("\n")
        end
    end
end