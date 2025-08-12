function logEvent(e)
    --echo('\nEvent:\n' .. e .. '\n')
    --echo('\ngmcp:\n' .. yajl.to_string(gmcp) .. '\n')

    -- Format the current date and time
    local timestamp = os.date("%Y-%m-%d_%H-%M-%S") -- Example: 2025-01-16_14-00-00

    -- Define the file path
    local filePath = getMudletHomeDir() .. "/alui/logs/" .. timestamp .. "_event_" .. e .. ".log"

    -- Open the file for writing
    local file = io.open(filePath, "w")

    if file then
        -- Write some content to the file
        file:write(yajl.to_string(gmcp))
        -- Close the file
        file:close()
        --echo("File created: " .. filePath .. "\n")
    else
        --echo("Failed to create file: " .. filePath .. "\n")
    end
end

registerAnonymousEventHandler("*", "logEvent")

-- Register with ResourceManager if available
local RM = ALUI and ALUI.ResourceManager
if RM then
    RM.registerEventHandler(
        "globalLogEvent",
        registerAnonymousEventHandler("*", "logEvent"),
        "*",
        "logging"
    )
    print("ALUI: logEvent registered with ResourceManager")
else
    -- Fallback to direct registration
    registerAnonymousEventHandler("*", "logEvent")
end

-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.logEvent = logEvent
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("logEvent.lua")
end
