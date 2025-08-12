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

-- Backward compatibility layer - maintain references to old globals
-- This ensures existing code continues to work during transition

-- Create compatibility tables that proxy to ALUI structure
local function createCompatibilityProxy(target, source)
    return setmetatable({}, {
        __index = function(t, k)
            return source[k]
        end,
        __newindex = function(t, k, v)
            source[k] = v
            -- Also update the target for backward compatibility
            if target then
                target[k] = v
            end
        end,
        __pairs = function(t)
            return pairs(source)
        end
    })
end

-- Maintain backward compatibility for existing globals
if not alui then
    alui = {}
end

-- Set up proxies for the old structure to point to new structure
alui.status = createCompatibilityProxy(alui.status, ALUI.Status.vitals)
alui.health = createCompatibilityProxy(alui.health, ALUI.Health)
alui.bleeding = createCompatibilityProxy(alui.bleeding, ALUI.Status.bleeding)

-- Maintain GUI global compatibility
if not GUI then
    GUI = {}
end

GUI.Colors = createCompatibilityProxy(GUI.Colors, ALUI.GUI.Colors)
GUI.Timers = createCompatibilityProxy(GUI.Timers, ALUI.GUI.Timers)

-- Maintain map global compatibility
if not map then
    map = {}
end

map.configs = createCompatibilityProxy(map.configs, ALUI.Map.configs)

-- Utility functions for the ALUI namespace
ALUI.Utils.getNamespaceInfo = function()
    local info = {
        version = "1.0.0",
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
        compatibility = {
            "alui.* -> ALUI.Status.*",
            "GUI.Colors -> ALUI.GUI.Colors",
            "GUI.Timers -> ALUI.GUI.Timers",
            "map.configs -> ALUI.Map.configs"
        }
    }
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

-- Mark a file as migrated
ALUI.migration.markComplete = function(filename)
    table.insert(ALUI.migration.completedFiles, filename)

    -- Remove from remaining files
    for i, file in ipairs(ALUI.migration.remainingFiles) do
        if file == filename then
            table.remove(ALUI.migration.remainingFiles, i)
            break
        end
    end

    -- Check if migration is complete
    if #ALUI.migration.remainingFiles == 0 then
        ALUI.migration.status = "complete"
        print("ALUI namespace migration completed!")
    end
end

-- Initialize the namespace system
print("ALUI Namespace initialized with backward compatibility")
print("Migrated from: alui, GUI, map -> ALUI.*")

-- Debug function to show namespace state
ALUI.debug = function()
    print("=== ALUI Namespace Debug Info ===")
    print("Status: " .. ALUI.migration.status)
    print("Completed files: " .. table.concat(ALUI.migration.completedFiles, ", "))
    print("Remaining files: " .. table.concat(ALUI.migration.remainingFiles, ", "))
    print("Colors available: " .. table.concat(table.keys(ALUI.GUI.Colors), ", "))
    print("Active timers: " .. #table.keys(ALUI.GUI.Timers))
    print("Event handlers: " .. #table.keys(ALUI.Events.registered))
end

return ALUI
