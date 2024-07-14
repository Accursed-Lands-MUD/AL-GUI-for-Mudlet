alui.status = alui.status or {}
alui.health = alui.health or {}

function vitals_update(e)
    if e ~= "gmcp.Char.Vitals" then
        return
    end
    local vit = gmcp.Char.Vitals

    alui.status.hunger = vit.Hunger
    alui.status.thirst = vit.Thirst

    --handle healths
    local c = table.flip({
        "massively injured",
        "horribly injured",
        "badly injured",
        "injured",
        "badly hurt",
        "hurt",
        "slightly wounded",
        "barely wounded",
        "in perfect health",
        [0] = "broken",
    })

    if type(vit.List) ~= "table" then
        for k, v in pairs(vit.List) do
            alui.health[k] = c[v] or 0
        end
    end

    raiseEvent("alui status window")
end