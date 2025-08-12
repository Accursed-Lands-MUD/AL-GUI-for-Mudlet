-- ResourceManager Integration Script
-- This script integrates the ResourceManager with existing ALUI components
-- and provides migration utilities for existing code

-- Ensure ResourceManager is loaded
if not ALUI or not ALUI.ResourceManager then
    error("ResourceManager not found. Please ensure ResourceManager.lua is loaded first.")
end

local RM = ALUI.ResourceManager

-- Integration status tracking
ALUI.ResourceManager.Integration = {
    version = "1.0.0",
    status = "active",
    integratedFiles = {},
    enhancedFunctions = {}
}

local Integration = ALUI.ResourceManager.Integration

-- Enhanced timer creation wrapper for backward compatibility
local function enhanceTimerFunctions()
    -- Store original functions if they exist
    if ALUI.GUI.createTimer then
        Integration.enhancedFunctions.originalCreateTimer = ALUI.GUI.createTimer
    end
    if ALUI.GUI.killTimer then
        Integration.enhancedFunctions.originalKillTimer = ALUI.GUI.killTimer
    end

    -- Replace with ResourceManager versions
    ALUI.GUI.createTimer = function(name, delay, callback, recurring, category)
        return RM.createTimer(name, delay, callback, recurring, category or "gui")
    end

    ALUI.GUI.killTimer = function(name)
        return RM.killTimer(name)
    end

    print("ALUI: Timer functions enhanced with ResourceManager")
end

-- Enhanced UI element creation helpers
ALUI.GUI.createTrackedUIElement = function(name, constructor, config, category)
    local element = constructor(config)
    RM.registerUIElement(name, element, category or "ui")
    return element
end

ALUI.GUI.createTrackedCSS = function(name, stylesheet, category)
    local css = CSSMan.new(stylesheet)
    RM.registerCSS(name, css, category or "style")
    return css
end

-- Enhanced event handler registration
ALUI.Events.createTrackedHandler = function(name, eventName, callback, category)
    local handlerId = registerAnonymousEventHandler(eventName, callback)
    RM.registerEventHandler(name, handlerId, eventName, category or "event")
    return handlerId
end

-- Resource cleanup helpers by category
ALUI.ResourceManager.cleanupUI = function()
    return RM.cleanupByCategory("ui")
end

ALUI.ResourceManager.cleanupTimers = function()
    return RM.cleanupByCategory("gui") + RM.cleanupByCategory("timer")
end

ALUI.ResourceManager.cleanupMapping = function()
    return RM.cleanupByCategory("mapping")
end

ALUI.ResourceManager.cleanupEvents = function()
    return RM.cleanupByCategory("event")
end

-- Migration helper for existing code
ALUI.ResourceManager.migrateExistingTimers = function()
    local migrated = 0

    -- Migrate GUI.Timers to ResourceManager tracking
    if GUI and GUI.Timers then
        for name, timerId in pairs(GUI.Timers) do
            if timerId and type(timerId) == "number" then
                -- Register existing timer with ResourceManager
                RM.resources.timers[name] = {
                    id = timerId,
                    delay = 0,         -- Unknown delay for existing timers
                    recurring = false, -- Assume non-recurring
                    category = "legacy",
                    created = getEpoch()
                }

                RM.metadata.creationTimes[name] = getEpoch()
                RM.metadata.usageCount[name] = 1

                migrated = migrated + 1
            end
        end
    end

    if migrated > 0 then
        print(string.format("ALUI ResourceManager: Migrated %d existing timers", migrated))
    end

    return migrated
end

-- Development and debugging helpers
ALUI.ResourceManager.getResourceSummary = function()
    local report = RM.getResourceReport()

    print("=== ALUI ResourceManager Summary ===")
    print(string.format("Total Resources: %d", report.totalResources))
    print(string.format("  Timers: %d", report.timers))
    print(string.format("  Event Handlers: %d", report.eventHandlers))
    print(string.format("  UI Elements: %d", report.uiElements))
    print(string.format("  CSS Objects: %d", report.cssObjects))

    if report.oldestResource then
        print(string.format("Oldest Resource: %s (%.1f minutes old)",
            report.oldestResource, report.oldestAge / 60))
    end

    -- Show resources by category
    local categories = {}
    for name, timer in pairs(RM.resources.timers) do
        categories[timer.category] = (categories[timer.category] or 0) + 1
    end
    for name, element in pairs(RM.resources.uiElements) do
        categories[element.category] = (categories[element.category] or 0) + 1
    end
    for name, handler in pairs(RM.resources.eventHandlers) do
        categories[handler.category] = (categories[handler.category] or 0) + 1
    end
    for name, css in pairs(RM.resources.cssObjects) do
        categories[css.category] = (categories[css.category] or 0) + 1
    end

    print("\nResources by Category:")
    for category, count in pairs(categories) do
        print(string.format("  %s: %d", category, count))
    end
end

-- Force cleanup function for development
ALUI.ResourceManager.forceCleanupAll = function()
    local cleaned = RM.cleanupAll()
    collectgarbage("collect")
    print(string.format("ALUI ResourceManager: Force cleanup completed (%d resources)", cleaned))
    return cleaned
end

-- Enhanced cleanup on disconnect
local function setupEnhancedCleanup()
    -- Register enhanced cleanup on disconnect
    ALUI.Events.createTrackedHandler(
        "resourceManagerCleanup",
        "sysDisconnectionEvent",
        function()
            print("ALUI ResourceManager: Player disconnected, performing cleanup...")
            RM.cleanupAll()
        end,
        "system"
    )
end

-- Auto-monitoring setup
local function setupAutoMonitoring()
    -- Create periodic monitoring timer
    RM.createTimer("resourceMonitoring", 1800, function() -- Every 30 minutes
        local report = RM.getResourceReport()

        -- Log warnings for high resource usage
        if report.totalResources > 100 then
            print(string.format("ALUI ResourceManager Warning: High resource usage (%d total resources)",
                report.totalResources))
        end

        -- Auto-cleanup old resources
        RM.cleanupOldResources(3600) -- Clean resources older than 1 hour
    end, true, "monitoring")
end

-- Initialize integration
local function initializeIntegration()
    -- Enhance timer functions
    enhanceTimerFunctions()

    -- Setup enhanced cleanup
    setupEnhancedCleanup()

    -- Setup monitoring
    setupAutoMonitoring()

    -- Migrate existing timers
    ALUI.ResourceManager.migrateExistingTimers()

    Integration.status = "initialized"
    Integration.initTime = getEpoch()

    print("ALUI ResourceManager Integration: Fully initialized")
    print("Use ALUI.ResourceManager.getResourceSummary() to view current resource usage")
end

-- Initialize if ALUI namespace is ready
if ALUI and ALUI.ResourceManager then
    initializeIntegration()
else
    print("ALUI ResourceManager Integration: Waiting for ALUI namespace...")
end

-- Export integration status for debugging
return Integration
