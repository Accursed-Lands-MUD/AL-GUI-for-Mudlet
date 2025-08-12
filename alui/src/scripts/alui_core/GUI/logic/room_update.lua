function room_update(e)
    if e ~= "gmcp.Room.Info" then
        return
    end

    local r = {}
    for k, v in pairs(gmcp.Room.Info) do
        r[k:lower()] = v
    end

    -- Use ALUI namespace for room mini with fallback
    local roommini = ALUI.GUI.Components.roommini
    if not roommini then
        return
    end

    roommini:clear()
    if r.brief then
        roommini:cecho(r.brief)
    end
    if r.heat and r.heat:len() > 0 then
        roommini:cecho("\nIt is " .. r.heat .. '.')
    end
    if r.height and (r.height ~= "") then
        roommini:cecho("\nThere is " .. r.height .. ".")
    end
    if r.light and (r.light ~= "") then
        roommini:cecho("\nIt is " .. r.light .. ".")
    end

    roommini:cecho("\n\nCreatures:")
    if type(r.creatures) == "table" then
        for k, v in ipairs(r.creatures) do
            roommini:cecho("\n " .. v)
        end
    end

    roommini:cecho("\n\nItems:")
    if type(r.inventory) == "table" then
        local count = {}
        for k, v in ipairs(r.inventory) do
            count[v] = count[v] and (count[v] + 1) or 1
        end
        for k, v in pairs(count) do
            if v > 1 then
                roommini:cecho("\n " .. v .. "x " .. k)
            else
                roommini:cecho("\n " .. k)
            end
        end
    end
end

-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.room_update = room_update
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("room_update.lua")
end
