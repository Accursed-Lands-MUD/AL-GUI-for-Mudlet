function status_window(e)
    if e ~= "alui status window" then
        return
    end

    local m = alui.combatmini

    m:clear()

    if alui.health then
        m:cecho("\n")

        local health = alui.health

        if health.body then
            if alui.bleeding.body then
                m:cecho("      Body: " .. health.body .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("      Body: " .. health.body .. "/9\n")
            end
        end

        if health.head then
            if alui.bleeding.head then
                m:cecho("      Head: " .. health.head .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("      Head: " .. health.head .. "/9\n")
            end
        end

        if health["left arm"] then
            if alui.bleeding["left arm"] then
                m:cecho("  Left Arm: " .. health["left arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("  Left Arm: " .. health["left arm"] .. "/9\n")
            end
        end

        if health["left leg"] then
            if alui.bleeding["left leg"] then
                m:cecho("  Left Leg: " .. health["left leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("  Left Leg: " .. health["left leg"] .. "/9\n")
            end
        end

        if health["left wing"] then
            if alui.bleeding["left wing"] then
                m:cecho(" Left Wing: " .. health["left wing"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho(" Left Wing: " .. health["left wing"] .. "/9\n")
            end
        end

        if health["right arm"] then
            if alui.bleeding["right arm"] then
                m:cecho(" Right Arm: " .. health["right arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho(" Right Arm: " .. health["right arm"] .. "/9\n")
            end
        end

        if health["right leg"] then
            if alui.bleeding["right leg"] then
                m:cecho(" Right Leg: " .. health["right leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho(" Right Leg: " .. health["right leg"] .. "/9\n")
            end
        end

        if health["right wing"] then
            if alui.bleeding["right wing"] then
                m:cecho("Right Wing: " .. health["right wing"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Wing: " .. health["right wing"] .. "/9\n")
            end
        end

        if health.tail then
            if alui.bleeding.tail then
                m:cecho("      Tail: " .. health.tail .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("      Tail: " .. health.tail .. "/9\n")
            end
        end

        if health["left front leg"] then
            if alui.bleeding["left front leg"] then
                m:cecho("Left Front Leg: " .. health["left front leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Left Front Leg: " .. health["left front leg"] .. "/9\n")
            end
        end

        if health["left hind leg"] then
            if alui.bleeding["left hind leg"] then
                m:cecho("Left Hind Leg: " .. health["left hind leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Left Hind Leg: " .. health["left hind leg"] .. "/9\n")
            end
        end

        if health["left rear leg"] then
            if alui.bleeding["left rear leg"] then
                m:cecho("Left Rear Leg: " .. health["left rear leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Left Rear Leg: " .. health["left rear leg"] .. "/9\n")
            end
        end

        if health["lower left arm"] then
            if alui.bleeding["lower left arm"] then
                m:cecho("Lower Left Arm: " .. health["lower left arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Left Arm: " .. health["lower left arm"] .. "/9\n")
            end
        end

        if health["lower right arm"] then
            if alui.bleeding["lower right arm"] then
                m:cecho("Lower Right Arm: " .. health["lower right arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Right Arm: " .. health["lower right arm"] .. "/9\n")
            end
        end

        if health["lower torso"] then
            if alui.bleeding["lower torso"] then
                m:cecho("Lower Torso: " .. health["lower torso"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Torso: " .. health["lower torso"] .. "/9\n")
            end
        end

        if health["right front leg"] then
            if alui.bleeding["right front leg"] then
                m:cecho("Right Front Leg: " .. health["right front leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Front Leg: " .. health["right front leg"] .. "/9\n")
            end
        end

        if health["right hind leg"] then
            if alui.bleeding["right hind leg"] then
                m:cecho("Right Hind Leg: " .. health["right hind leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Hind Leg: " .. health["right hind leg"] .. "/9\n")
            end
        end

        if health["right rear leg"] then
            if alui.bleeding["right rear leg"] then
                m:cecho("Right Rear Leg: " .. health["right rear leg"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Right Rear Leg: " .. health["right rear leg"] .. "/9\n")
            end
        end

        if health["upper left arm"] then
            if alui.bleeding["upper left arm"] then
                m:cecho("Upper Left Arm: " .. health["upper left arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Left Arm: " .. health["upper left arm"] .. "/9\n")
            end
        end

        if health["upper right arm"] then
            if alui.bleeding["upper right arm"] then
                m:cecho("Upper Right Arm: " .. health["upper right arm"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Right Arm: " .. health["upper right arm"] .. "/9\n")
            end
        end

        if health["upper torso"] then
            if alui.bleeding["upper torso"] then
                m:cecho("Upper Torso: " .. health["upper torso"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Torso: " .. health["upper torso"] .. "/9\n")
            end
        end

        if health["lower left tentacle"] then
            if alui.bleeding["lower left tentacle"] then
                m:cecho("Lower Left Tentacle: " .. health["lower left tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Left Tentacle: " .. health["lower left tentacle"] .. "/9\n")
            end
        end

        if health["lower right tentacle"] then
            if alui.bleeding["lower right tentacle"] then
                m:cecho("Lower Right Tentacle: " .. health["lower right tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Lower Right Tentacle: " .. health["lower right tentacle"] .. "/9\n")
            end
        end

        if health["primary tentacle"] then
            if alui.bleeding["primary tentacle"] then
                m:cecho("Primary Tentacle: " .. health["primary tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Primary Tentacle: " .. health["primary tentacle"] .. "/9\n")
            end
        end

        if health.torso then
            if alui.bleeding.torso then
                m:cecho("     Torso: " .. health.torso .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("     Torso: " .. health.torso .. "/9\n")
            end
        end

        if health["upper left tentacle"] then
            if alui.bleeding["upper left tentacle"] then
                m:cecho("Upper Left Tentacle: " .. health["upper left tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Left Tentacle: " .. health["upper left tentacle"] .. "/9\n")
            end
        end

        if health["upper right tentacle"] then
            if alui.bleeding["upper right tentacle"] then
                m:cecho("Upper Right Tentacle: " .. health["upper right tentacle"] .. "/9 <red>bleeding<reset>\n")
            else
                m:cecho("Upper Right Tentacle: " .. health["upper right tentacle"] .. "/9\n")
            end
        end
    end
end
