function status_window(e)
    if e ~= "alui status window" then
        return
    end

    alui.combatmini:clear()
    local status = alui.status
    local bleeding = alui.bleeding
    if status.hunger then
        alui.combatmini:cecho("You are " .. status.hunger .. " and " .. status.thirst .. ".\n")
    end
    if status.fatigue then
        alui.combatmini:cecho("You are " .. status.fatigue .. ".\n")
    end
    if status.posture then
        alui.combatmini:cecho("You are " .. status.posture .. ".\n")
    end

    local m = alui.combatmini

    if alui.health then
        m:cecho("\n")

        if alui.health.body then
            if bleeding.body then
                m:cecho("      Body: " .. alui.health.body .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("      Body: " .. alui.health.body .. "/9\n")
            end
        end

        if alui.health.head then
            if bleeding.head then
                m:cecho("      Head: " .. alui.health.head .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("      Head: " .. alui.health.head .. "/9\n")
            end
        end

        if alui.health["left arm"] then
            if bleeding["left arm"] then
                m:cecho("  Left Arm: " .. alui.health["left arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("  Left Arm: " .. alui.health["left arm"] .. "/9\n")
            end
        end

        if alui.health["left leg"] then
            if bleeding["left leg"] then
                m:cecho("  Left Leg: " .. alui.health["left leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("  Left Leg: " .. alui.health["left leg"] .. "/9\n")
            end
        end

        if alui.health["left wing"] then
            if bleeding["left wing"] then
                m:cecho(" Left Wing: " .. alui.health["left wing"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho(" Left Wing: " .. alui.health["left wing"] .. "/9\n")
            end
        end

        if alui.health["right arm"] then
            if bleeding["right arm"] then
                m:cecho(" Right Arm: " .. alui.health["right arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho(" Right Arm: " .. alui.health["right arm"] .. "/9\n")
            end
        end

        if alui.health["right leg"] then
            if bleeding["right leg"] then
                m:cecho(" Right Leg: " .. alui.health["right leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho(" Right Leg: " .. alui.health["right leg"] .. "/9\n")
            end
        end

        if alui.health["right wing"] then
            if bleeding["right wing"] then
                m:cecho("Right Wing: " .. alui.health["right wing"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Wing: " .. alui.health["right wing"] .. "/9\n")
            end
        end

        if alui.health.tail then
            if bleeding.tail then
                m:cecho("     Tail: " .. alui.health.tail .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("     Tail: " .. alui.health.tail .. "/9\n")
            end
        end

        if alui.health["left front leg"] then
            if bleeding["left front leg"] then
                m:cecho("Left Front Leg: " .. alui.health["left front leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Left Front Leg: " .. alui.health["left front leg"] .. "/9\n")
            end
        end

        if alui.health["left hind leg"] then
            if bleeding["left hind leg"] then
                m:cecho("Left Hind Leg: " .. alui.health["left hind leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Left Hind Leg: " .. alui.health["left hind leg"] .. "/9\n")
            end
        end

        if alui.health["left rear leg"] then
            if bleeding["left rear leg"] then
                m:cecho("Left Rear Leg: " .. alui.health["left rear leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Left Rear Leg: " .. alui.health["left rear leg"] .. "/9\n")
            end
        end

        if alui.health["lower left arm"] then
            if bleeding["lower left arm"] then
                m:cecho("Lower Left Arm: " .. alui.health["lower left arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Left Arm: " .. alui.health["lower left arm"] .. "/9\n")
            end
        end

        if alui.health["lower right arm"] then
            if bleeding["lower right arm"] then
                m:cecho("Lower Right Arm: " .. alui.health["lower right arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Right Arm: " .. alui.health["lower right arm"] .. "/9\n")
            end
        end

        if alui.health["lower torso"] then
            if bleeding["lower torso"] then
                m:cecho("Lower Torso: " .. alui.health["lower torso"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Torso: " .. alui.health["lower torso"] .. "/9\n")
            end
        end

        if alui.health["right front leg"] then
            if bleeding["right front leg"] then
                m:cecho("Right Front Leg: " .. alui.health["right front leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Front Leg: " .. alui.health["right front leg"] .. "/9\n")
            end
        end

        if alui.health["right hind leg"] then
            if bleeding["right hind leg"] then
                m:cecho("Right Hind Leg: " .. alui.health["right hind leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Hind Leg: " .. alui.health["right hind leg"] .. "/9\n")
            end
        end

        if alui.health["right rear leg"] then
            if bleeding["right rear leg"] then
                m:cecho("Right Rear Leg: " .. alui.health["right rear leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Rear Leg: " .. alui.health["right rear leg"] .. "/9\n")
            end
        end

        if alui.health["upper left arm"] then
            if bleeding["upper left arm"] then
                m:cecho("Upper Left Arm: " .. alui.health["upper left arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Left Arm: " .. alui.health["upper left arm"] .. "/9\n")
            end
        end

        if alui.health["upper right arm"] then
            if bleeding["upper right arm"] then
                m:cecho("Upper Right Arm: " .. alui.health["upper right arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Right Arm: " .. alui.health["upper right arm"] .. "/9\n")
            end
        end

        if alui.health["upper torso"] then
            if bleeding["upper torso"] then
                m:cecho("Upper Torso: " .. alui.health["upper torso"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Torso: " .. alui.health["upper torso"] .. "/9\n")
            end
        end

        if alui.health["lower left tentacle"] then
            if bleeding["lower left tentacle"] then
                m:cecho("Lower Left Tentacle: " .. alui.health["lower left tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Left Tentacle: " .. alui.health["lower left tentacle"] .. "/9\n")
            end
        end

        if alui.health["lower right tentacle"] then
            if bleeding["lower right tentacle"] then
                m:cecho("Lower Right Tentacle: " .. alui.health["lower right tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Right Tentacle: " .. alui.health["lower right tentacle"] .. "/9\n")
            end
        end

        if alui.health["primary tentacle"] then
            if bleeding["primary tentacle"] then
                m:cecho("Primary Tentacle: " .. alui.health["primary tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Primary Tentacle: " .. alui.health["primary tentacle"] .. "/9\n")
            end
        end

        if alui.health.torso then
            if bleeding.torso then
                m:cecho("     Torso: " .. alui.health.torso .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("     Torso: " .. alui.health.torso .. "/9\n")
            end
        end

        if alui.health["upper left tentacle"] then
            if bleeding["upper left tentacle"] then
                m:cecho("Upper Left Tentacle: " .. alui.health["upper left tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Left Tentacle: " .. alui.health["upper left tentacle"] .. "/9\n")
            end
        end

        if alui.health["upper right tentacle"] then
            if bleeding["upper right tentacle"] then
                m:cecho("Upper Right Tentacle: " .. alui.health["upper right tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Right Tentacle: " .. alui.health["upper right tentacle"] .. "/9\n")
            end
        end
    end
end
