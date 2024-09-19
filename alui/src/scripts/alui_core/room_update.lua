function room_update(e)
    if e ~= "gmcp.Room.Info" then
        return
    end
    local r = {}
    for k, v in pairs(gmcp.Room.Info) do
        r[k:lower()] = v
    end

    local m = alui.roommini
    m:clear()
    if r.brief then
        m:cecho(r.brief)
    end
    if r.heat then
        m:cecho("\nIt is " .. r.heat .. '.')
    end
    if r.height and (r.height ~= "") then
        m:cecho("\nThere is " .. r.height .. ".")

    end
    if r.light and (r.light ~= "") then
        m:cecho("\nIt is " .. r.light .. ".")
    end

    m:cecho("\n\nCreatures:")
    if type(r.creatures) == "table" then
        for k, v in ipairs(r.creatures) do
            m:cecho("\n " .. v)
        end
    end

    m:cecho("\n\nItems:")
    if type(r.inventory) == "table" then
        local count = {}
        for k, v in ipairs(r.inventory) do
            count[v] = count[v] and (count[v] + 1) or 1
        end
        for k, v in pairs(count) do
            if v > 1 then
                m:cecho("\n " .. v .. "x " .. k)
            else
                m:cecho("\n " .. k)
            end
        end
    end
end
  