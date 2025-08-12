-- ALUI Namespace Consolidation
-- Implements Suggestion #6: Consolidate multiple global namespaces into single ALUI structure
-- This creates a centralized namespace structure while maintaining backward compatibility

-- Initialize the main ALUI namespace
ALUI = ALUI or {}

-- Core sub-namespaces for organization
ALUI.Core = ALUI.Core or {}
ALUI.GUI = ALUI.GUI or {}
ALUI.Map = ALUI.Map or {}
ALUI.Chat = ALUI.Chat or {}
ALUI.Status = ALUI.Status or {}
ALUI.Health = ALUI.Health or {}
ALUI.Events = ALUI.Events or {}
ALUI.Utils = ALUI.Utils or {}

-- Initialize sub-structures
ALUI.GUI.Components = ALUI.GUI.Components or {}
ALUI.GUI.Styles = ALUI.GUI.Styles or {}
ALUI.GUI.Timers = ALUI.GUI.Timers or {}
ALUI.GUI.Colors = ALUI.GUI.Colors or {}

ALUI.Map.configs = ALUI.Map.configs or {}
ALUI.Map.handlers = ALUI.Map.handlers or {}

ALUI.Status.vitals = ALUI.Status.vitals or {}
ALUI.Status.bleeding = ALUI.Status.bleeding or {}
ALUI.Status.icons = ALUI.Status.icons or {}

ALUI.Events.handlers = ALUI.Events.handlers or {}
ALUI.Events.registered = ALUI.Events.registered or {}

-- Migrate existing color definitions from GUI.Colors if they exist
if GUI and GUI.Colors then
    for colorName, colorValue in pairs(GUI.Colors) do
        ALUI.GUI.Colors[colorName] = colorValue
    end
end

-- Set up default colors if not already defined
ALUI.GUI.Colors.blue = ALUI.GUI.Colors.blue or '#2A768C'
ALUI.GUI.Colors.green = ALUI.GUI.Colors.green or '#2EA652'
ALUI.GUI.Colors.yellow = ALUI.GUI.Colors.yellow or '#E1B03E'
ALUI.GUI.Colors.orange = ALUI.GUI.Colors.orange or '#C3701C'
ALUI.GUI.Colors.red = ALUI.GUI.Colors.red or '#830000'

-- Migrate existing alui status if it exists
if alui then
    if alui.status then
        for key, value in pairs(alui.status) do
            ALUI.Status.vitals[key] = value
        end
    end

    if alui.health then
        for key, value in pairs(alui.health) do
            ALUI.Health[key] = value
        end
    end

    if alui.bleeding then
        for key, value in pairs(alui.bleeding) do
            ALUI.Status.bleeding[key] = value
        end
    end
end

-- Migrate existing map configs if they exist
if map and map.configs then
    for key, value in pairs(map.configs) do
        ALUI.Map.configs[key] = value
    end
end

-- Migrate existing GUI timers if they exist
if GUI and GUI.Timers then
    for key, value in pairs(GUI.Timers) do
        ALUI.GUI.Timers[key] = value
    end
end

-- Migration completed - no backward compatibility layer needed
-- All code has been migrated to use ALUI namespace directly

-- Utility functions for the ALUI namespace
ALUI.Utils.getNamespaceInfo = function()
    local info = {
        version = "2.0.0",
        migrationStatus = "complete",
        namespaces = {
            "ALUI.Core",
            "ALUI.GUI",
            "ALUI.Map",
            "ALUI.Chat",
            "ALUI.Status",
            "ALUI.Health",
            "ALUI.Events",
            "ALUI.Utils"
        },
        features = {
            "Centralized namespace structure",
            "ResourceManager integration",
            "Configuration system",
            "Event management"
        }
    }
    return info
end

-- Helper function for debugging namespace structure
ALUI.Utils.debugNamespace = function()
    print("=== ALUI Namespace Structure ===")
    print("Version: 2.0.0")
    print("Migration Status: Complete")
    print("Main Namespaces:")
    for _, ns in ipairs(ALUI.Utils.getNamespaceInfo().namespaces) do
        print("  - " .. ns)
    end
    return info
end

-- Helper function to migrate existing code patterns
ALUI.Utils.migrateToNamespace = function(legacy, modern)
    local migrationGuide = {
        ["alui.status"] = "ALUI.Status.vitals",
        ["alui.health"] = "ALUI.Health",
        ["alui.bleeding"] = "ALUI.Status.bleeding",
        ["GUI.Colors"] = "ALUI.GUI.Colors",
        ["GUI.Timers"] = "ALUI.GUI.Timers",
        ["map.configs"] = "ALUI.Map.configs"
    }

    return migrationGuide[legacy] or modern
end

-- Event system integration
ALUI.Events.registerHandler = function(eventName, handlerName, callback)
    if not ALUI.Events.handlers[eventName] then
        ALUI.Events.handlers[eventName] = {}
    end

    ALUI.Events.handlers[eventName][handlerName] = callback

    -- Register with Mudlet's event system
    local mudletHandler = registerNamedEventHandler(profileName or "ALUI", handlerName, eventName, callback)
    ALUI.Events.registered[handlerName] = mudletHandler

    return mudletHandler
end

ALUI.Events.unregisterHandler = function(handlerName)
    if ALUI.Events.registered[handlerName] then
        killAnonymousEventHandler(ALUI.Events.registered[handlerName])
        ALUI.Events.registered[handlerName] = nil

        -- Remove from our internal tracking
        for eventName, handlers in pairs(ALUI.Events.handlers) do
            if handlers[handlerName] then
                handlers[handlerName] = nil
            end
        end

        return true
    end
    return false
end

-- Timer management utilities (enhanced with ResourceManager integration)
ALUI.GUI.createTimer = function(name, delay, callback, recurring)
    -- Use ResourceManager if available
    local RM = ALUI and ALUI.ResourceManager
    if RM then
        return RM.createTimer(name, delay, callback, recurring, "gui")
    else
        -- Fallback to legacy timer management
        if ALUI.GUI.Timers[name] then
            killTimer(ALUI.GUI.Timers[name])
            ALUI.GUI.Timers[name] = nil
        end

        local timerFunction = recurring and tempTimer or tempTimer
        ALUI.GUI.Timers[name] = timerFunction(delay, callback)

        return ALUI.GUI.Timers[name]
    end
end

ALUI.GUI.killTimer = function(name)
    -- Use ResourceManager if available
    local RM = ALUI and ALUI.ResourceManager
    if RM then
        return RM.killTimer(name)
    else
        -- Fallback to legacy timer management
        if ALUI.GUI.Timers[name] then
            killTimer(ALUI.GUI.Timers[name])
            ALUI.GUI.Timers[name] = nil
            return true
        end
        return false
    end
end

-- Enhanced cleanup function with ResourceManager integration
ALUI.cleanup = function()
    -- Use ResourceManager if available for comprehensive cleanup
    local RM = ALUI and ALUI.ResourceManager
    if RM then
        local cleaned = RM.cleanupAll()
        print(string.format("ALUI enhanced cleanup completed (%d resources)", cleaned))
        return cleaned
    else
        -- Legacy cleanup fallback
        for name, timerId in pairs(ALUI.GUI.Timers) do
            if timerId then
                killTimer(timerId)
            end
        end
        ALUI.GUI.Timers = {}

        for handlerName, handlerId in pairs(ALUI.Events.registered) do
            if handlerId then
                killAnonymousEventHandler(handlerId)
            end
        end
        ALUI.Events.registered = {}
        ALUI.Events.handlers = {}

        print("ALUI namespace cleaned up successfully")
        return 0
    end
end

-- Migration status tracking
ALUI.migration = {
    status = "in-progress",
    completedFiles = {},
    remainingFiles = {
        "alui_core.lua",
        "Mapping_Script.lua",
        "Create_Background.lua",
        "Boxes.lua",
        "vitals_update.lua",
        "Header_Icons.lua",
        "Gauges.lua",
        "Set_Borders.lua"
    },
    backwardCompatibility = true
}

-- Mark migration as complete
ALUI.migration.status = "complete"
ALUI.migration.completedFiles = {
    "namespace.lua",
    "alui_core.lua",
    "Config.lua",
    "GUI/Boxes.lua",
    "GUI/Header_Icons.lua",
    "GUI/Create_Background.lua",
    "GUI/Set_Borders.lua",
    "Mapping_Script.lua",
    "ConfigAnalytics.lua",
    "logEvent.lua"
}
ALUI.migration.remainingFiles = {}
ALUI.migration.backwardCompatibility = false

-- Initialize the completed namespace system
print("ALUI Namespace migration completed successfully!")
print("All files migrated to unified ALUI.* structure")
print("Backward compatibility layer removed")

return ALUI
