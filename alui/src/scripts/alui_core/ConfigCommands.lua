-- ALUI Configuration Commands
-- Provides command-line interface for configuration management
-- Usage: config <action> [category] [key] [value]

-- Ensure ALUI namespace exists
if not ALUI or not ALUI.Config then
    error("ALUI Configuration system not loaded. Please ensure Config.lua is loaded first.")
end

local Config = ALUI.Config

-- Command handler function
local function handleConfigCommand(action, category, key, value)
    action = action and string.lower(action)
    
    if not action then
        -- Show help
        cecho("<cyan>ALUI Configuration Commands:\n")
        cecho("<white>  config get [path]           <dim_grey>- Get configuration value\n")
        cecho("<white>  config set <path> <value>   <dim_grey>- Set configuration value\n")
        cecho("<white>  config list [category]      <dim_grey>- List configuration options\n")
        cecho("<white>  config reset [category]     <dim_grey>- Reset to defaults\n")
        cecho("<white>  config save                 <dim_grey>- Save configuration to file\n")
        cecho("<white>  config reload               <dim_grey>- Reload from file\n")
        cecho("<white>  config export               <dim_grey>- Export configuration as JSON\n")
        cecho("<white>  config schema               <dim_grey>- Show configuration schema\n")
        cecho("<dim_grey>\nExamples:\n")
        cecho("<white>  config get ui.guiPadding\n")
        cecho("<white>  config set colors.primary.blue #FF5733\n")
        cecho("<white>  config list colors\n")
        cecho("<white>  config reset ui\n")
        return
    end
    
    if action == "get" then
        local path = category or ""
        if path == "" then
            cecho("<red>Error: Path required for 'get' command\n")
            cecho("<white>Usage: config get <path>\n")
            return
        end
        
        local value = Config.get(path)
        if value ~= nil then
            local valueStr = type(value) == "table" and yajl.to_string(value) or tostring(value)
            cecho(f"<green>{path}<white> = <yellow>{valueStr}\n")
        else
            cecho(f"<red>Configuration path not found: <white>{path}\n")
        end
        
    elseif action == "set" then
        local path = category
        local newValue = key
        
        if not path or not newValue then
            cecho("<red>Error: Path and value required for 'set' command\n")
            cecho("<white>Usage: config set <path> <value>\n")
            return
        end
        
        -- Try to parse value as appropriate type
        local parsedValue = newValue
        if newValue == "true" then
            parsedValue = true
        elseif newValue == "false" then
            parsedValue = false
        elseif tonumber(newValue) then
            parsedValue = tonumber(newValue)
        end
        
        local success = Config.set(path, parsedValue)
        if success then
            cecho(f"<green>Set <white>{path}<green> = <yellow>{parsedValue}\n")
        else
            cecho(f"<red>Failed to set configuration: <white>{path}\n")
        end
        
    elseif action == "list" then
        local targetCategory = category
        local currentConfig = Config.current
        
        if targetCategory then
            if currentConfig[targetCategory] then
                cecho(f"<cyan>Configuration - {targetCategory}:\n")
                local function printCategory(data, prefix)
                    for k, v in pairs(data) do
                        local fullPath = prefix and (prefix .. "." .. k) or k
                        if type(v) == "table" then
                            cecho(f"<white>  {fullPath}/<dim_grey> (category)\n")
                            printCategory(v, fullPath)
                        else
                            local valueStr = tostring(v)
                            if string.len(valueStr) > 50 then
                                valueStr = string.sub(valueStr, 1, 47) .. "..."
                            end
                            cecho(f"<white>  {fullPath} <dim_grey>= <yellow>{valueStr}\n")
                        end
                    end
                end
                printCategory(currentConfig[targetCategory], targetCategory)
            else
                cecho(f"<red>Unknown configuration category: <white>{targetCategory}\n")
            end
        else
            cecho("<cyan>Configuration Categories:\n")
            for category, _ in pairs(currentConfig) do
                local count = 0
                local function countItems(data)
                    for _, v in pairs(data) do
                        if type(v) == "table" then
                            countItems(v)
                        else
                            count = count + 1
                        end
                    end
                end
                countItems(currentConfig[category])
                cecho(f"<white>  {category} <dim_grey>({count} settings)\n")
            end
            cecho("<dim_grey>\nUse 'config list <category>' for details\n")
        end
        
    elseif action == "reset" then
        local targetCategory = category
        
        if targetCategory then
            Config.reset(targetCategory)
            cecho(f"<green>Reset category '<white>{targetCategory}<green>' to defaults\n")
        else
            cecho("<yellow>This will reset ALL configuration to defaults. Are you sure? (y/N): ")
            -- Note: In a real implementation, you'd want to handle user input confirmation
            -- For now, require explicit category specification
            cecho("<red>Please specify a category to reset, or use 'config reset all' to confirm\n")
        end
        
    elseif action == "save" then
        Config.save()
        cecho("<green>Configuration saved to file\n")
        
    elseif action == "reload" then
        Config.load()
        cecho("<green>Configuration reloaded from file\n")
        
    elseif action == "export" then
        local jsonStr = Config.export()
        cecho("<cyan>Current Configuration (JSON):\n")
        cecho(f"<dim_grey>{jsonStr}\n")
        
    elseif action == "schema" then
        local schema = Config.getSchema()
        cecho("<cyan>Configuration Schema:\n")
        for category, settings in pairs(schema.categories) do
            cecho(f"<white>{category}:\n")
            for setting, info in pairs(settings) do
                local hasValidator = info.hasValidator and " (validated)" or ""
                cecho(f"<dim_grey>  {setting} <white>({info.type})<yellow> = {info.default}<dim_grey>{hasValidator}\n")
            end
        end
        
    else
        cecho(f"<red>Unknown action: <white>{action}\n")
        cecho("<dim_grey>Use 'config' with no arguments for help\n")
    end
end

-- Register the command alias
if tempAlias then
    -- Remove any existing alias first
    if ALUI.ConfigCommandAlias then
        killAlias(ALUI.ConfigCommandAlias)
    end
    
    -- Create new alias
    ALUI.ConfigCommandAlias = tempAlias("^config\\s*(\\w*)\\s*(\\S*)\\s*(\\S*)\\s*(.*)$", function()
        local action = matches[2] and matches[2] ~= "" and matches[2] or nil
        local category = matches[3] and matches[3] ~= "" and matches[3] or nil
        local key = matches[4] and matches[4] ~= "" and matches[4] or nil
        local value = matches[5] and matches[5] ~= "" and matches[5] or nil
        
        handleConfigCommand(action, category, key, value)
    end)
    
    cecho("<green>ALUI Configuration commands loaded. Type 'config' for help.\n")
else
    cecho("<red>Warning: tempAlias not available. Configuration commands not registered.\n")
end

-- Also provide direct function access
ALUI.ConfigCommands = {
    handle = handleConfigCommand
}

return ALUI.ConfigCommands
