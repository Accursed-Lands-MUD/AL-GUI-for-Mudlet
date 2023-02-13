function room_update(e)
  if e ~= "gmcp.Room.Info" then return end
  local r = {}
  for k, v in pairs(gmcp.Room.Info) do
    r[k:lower()] = v
  end
  
  local m = alui.roommini
  m:clear()
  if r.brief then m:echo(r.brief) end
  if r.heat then m:echo(f"\n{r.heat}") end
  if r.height and (r.height ~= "") then m:echo(f"\nThere is {r.height}.") end
  if r.light and (r.light ~= "") then m:echo(f"\nIt is {r.light}\.") end
  
  m:echo("\n\nCreatures:")
  for k, v in ipairs(r.creatures) do
    m:echo(f"\n {v}")
  end
  
  m:echo("\n\nItems:")
  if type(r.inventory) == "table" then
    local count = {}
    for k, v in ipairs(r.inventory) do
      count[v] = count[v] and (count[v] + 1) or 1
    end
    for k, v in pairs(count) do
      if v > 1 then m:echo(f"\n {v}x {k}") else m:echo(f"\n {k}") end
    end
  end
end
  