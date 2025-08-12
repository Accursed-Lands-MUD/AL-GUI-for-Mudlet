-- Resource Cleanup Manager for ALUI
-- Provides comprehensive cleanup for timers, event handlers, UI elements, and other resources
-- Addresses suggestion #16: Resource Cleanup

-- Ensure ALUI namespace exists
if not ALUI then
    error("ALUI namespace not loaded. Please ensure namespace.lua is loaded first.")
end

-- Resource cleanup manager
ALUI.ResourceManager = ALUI.ResourceManager or {}
local RM = ALUI.ResourceManager

-- Resource tracking tables
RM.resources = {
    timers = {},        -- Track all timers created by ALUI
    eventHandlers = {}, -- Track all event handlers
    uiElements = {},    -- Track all UI elements (Geyser objects)
    cssObjects = {},    -- Track all CSS objects
    aliases = {},       -- Track all aliases
    triggers = {},      -- Track all triggers
    tempTimers = {}     -- Track temporary timers with metadata
}

-- Resource metadata for debugging and monitoring
RM.metadata = {
    creationTimes = {},  -- When resources were created
    lastAccessed = {},   -- When resources were last accessed
    usageCount = {},     -- How many times resources were accessed
    memoryEstimates = {} -- Estimated memory usage
}

-- Enhanced timer creation with tracking
RM.createTimer = function(name, delay, callback, recurring, category)
    -- Clean up existing timer if it exists
    RM.killTimer(name)

    -- Create new timer
    local timerFunction = recurring and tempTimer or tempTimer
    local timerId = timerFunction(delay, callback)

    -- Track the timer with metadata
    RM.resources.timers[name] = {
        id = timerId,
        delay = delay,
        recurring = recurring or false,
        category = category or "general",
        created = getEpoch(),
        lastAccessed = getEpoch()
    }

    -- Update metadata
    RM.metadata.creationTimes[name] = getEpoch()
    RM.metadata.usageCount[name] = 0

    return timerId
end

-- Enhanced timer cleanup
RM.killTimer = function(name)
    if RM.resources.timers[name] then
        killTimer(RM.resources.timers[name].id)
        RM.resources.timers[name] = nil
        RM.metadata.creationTimes[name] = nil
        RM.metadata.lastAccessed[name] = nil
        RM.metadata.usageCount[name] = nil
        return true
    end
    return false
end

-- Track UI elements (Geyser objects)
RM.registerUIElement = function(name, element, category)
    RM.resources.uiElements[name] = {
        element = element,
        category = category or "ui",
        created = getEpoch(),
        type = type(element)
    }

    RM.metadata.creationTimes[name] = getEpoch()
    RM.metadata.usageCount[name] = 0
end

-- Clean up UI elements
RM.destroyUIElement = function(name)
    if RM.resources.uiElements[name] then
        local element = RM.resources.uiElements[name].element

        -- Attempt to hide and remove the element
        if element and element.hide then
            element:hide()
        end

        -- Remove from tracking
        RM.resources.uiElements[name] = nil
        RM.metadata.creationTimes[name] = nil
        RM.metadata.lastAccessed[name] = nil
        RM.metadata.usageCount[name] = nil

        return true
    end
    return false
end

-- Track CSS objects
RM.registerCSS = function(name, cssObject, category)
    RM.resources.cssObjects[name] = {
        object = cssObject,
        category = category or "style",
        created = getEpoch()
    }

    RM.metadata.creationTimes[name] = getEpoch()
end

-- Clean up CSS objects
RM.destroyCSS = function(name)
    if RM.resources.cssObjects[name] then
        -- CSS objects don't need explicit cleanup in Mudlet, just remove tracking
        RM.resources.cssObjects[name] = nil
        RM.metadata.creationTimes[name] = nil
        return true
    end
    return false
end

-- Enhanced event handler tracking
RM.registerEventHandler = function(name, handlerId, eventName, category)
    RM.resources.eventHandlers[name] = {
        id = handlerId,
        eventName = eventName,
        category = category or "event",
        created = getEpoch()
    }

    RM.metadata.creationTimes[name] = getEpoch()
    RM.metadata.usageCount[name] = 0
end

-- Clean up event handlers
RM.unregisterEventHandler = function(name)
    if RM.resources.eventHandlers[name] then
        local handler = RM.resources.eventHandlers[name]

        -- Kill the event handler
        if handler.id then
            killAnonymousEventHandler(handler.id)
        end

        -- Remove from tracking
        RM.resources.eventHandlers[name] = nil
        RM.metadata.creationTimes[name] = nil
        RM.metadata.lastAccessed[name] = nil
        RM.metadata.usageCount[name] = nil

        return true
    end
    return false
end

-- Comprehensive cleanup by category
RM.cleanupByCategory = function(category)
    local cleaned = 0

    -- Clean timers
    for name, timer in pairs(RM.resources.timers) do
        if timer.category == category then
            RM.killTimer(name)
            cleaned = cleaned + 1
        end
    end

    -- Clean UI elements
    for name, element in pairs(RM.resources.uiElements) do
        if element.category == category then
            RM.destroyUIElement(name)
            cleaned = cleaned + 1
        end
    end

    -- Clean CSS objects
    for name, css in pairs(RM.resources.cssObjects) do
        if css.category == category then
            RM.destroyCSS(name)
            cleaned = cleaned + 1
        end
    end

    -- Clean event handlers
    for name, handler in pairs(RM.resources.eventHandlers) do
        if handler.category == category then
            RM.unregisterEventHandler(name)
            cleaned = cleaned + 1
        end
    end

    return cleaned
end

-- Complete cleanup of all resources
RM.cleanupAll = function()
    local totalCleaned = 0

    -- Clean all timers
    for name, _ in pairs(RM.resources.timers) do
        if RM.killTimer(name) then
            totalCleaned = totalCleaned + 1
        end
    end

    -- Clean all UI elements
    for name, _ in pairs(RM.resources.uiElements) do
        if RM.destroyUIElement(name) then
            totalCleaned = totalCleaned + 1
        end
    end

    -- Clean all CSS objects
    for name, _ in pairs(RM.resources.cssObjects) do
        if RM.destroyCSS(name) then
            totalCleaned = totalCleaned + 1
        end
    end

    -- Clean all event handlers
    for name, _ in pairs(RM.resources.eventHandlers) do
        if RM.unregisterEventHandler(name) then
            totalCleaned = totalCleaned + 1
        end
    end

    -- Force garbage collection
    collectgarbage("collect")

    print(string.format("ALUI Resource Manager: Cleaned up %d resources", totalCleaned))
    return totalCleaned
end

-- Resource monitoring and reporting
RM.getResourceReport = function()
    local report = {
        timers = table.size(RM.resources.timers),
        eventHandlers = table.size(RM.resources.eventHandlers),
        uiElements = table.size(RM.resources.uiElements),
        cssObjects = table.size(RM.resources.cssObjects),
        totalResources = 0,
        oldestResource = nil,
        oldestAge = 0
    }

    report.totalResources = report.timers + report.eventHandlers + report.uiElements + report.cssObjects

    -- Find oldest resource
    local currentTime = getEpoch()
    for name, time in pairs(RM.metadata.creationTimes) do
        local age = currentTime - time
        if age > report.oldestAge then
            report.oldestAge = age
            report.oldestResource = name
        end
    end

    return report
end

-- Cleanup old/unused resources (garbage collection helper)
RM.cleanupOldResources = function(maxAge)
    maxAge = maxAge or 3600 -- Default: 1 hour
    local currentTime = getEpoch()
    local cleaned = 0

    for name, creationTime in pairs(RM.metadata.creationTimes) do
        local age = currentTime - creationTime
        local lastAccessed = RM.metadata.lastAccessed[name] or creationTime
        local timeSinceAccess = currentTime - lastAccessed

        -- Clean if resource is old and hasn't been accessed recently
        if age > maxAge and timeSinceAccess > (maxAge / 2) then
            -- Try to clean from each resource type
            if RM.killTimer(name) or RM.destroyUIElement(name) or
                RM.destroyCSS(name) or RM.unregisterEventHandler(name) then
                cleaned = cleaned + 1
            end
        end
    end

    if cleaned > 0 then
        print(string.format("ALUI Resource Manager: Cleaned up %d old resources", cleaned))
        collectgarbage("collect")
    end

    return cleaned
end

-- Automatic cleanup on profile disconnect
RM.registerAutoCleanup = function()
    if not RM.autoCleanupRegistered then
        -- Register cleanup on profile disconnect
        ALUI.Events.registerHandler("alui.cleanup", "sysDisconnectionEvent", function()
            RM.cleanupAll()
        end, "system")

        -- Register periodic cleanup (every 30 minutes)
        RM.createTimer("periodicCleanup", 1800, function()
            RM.cleanupOldResources(3600) -- Clean resources older than 1 hour
        end, true, "system")

        RM.autoCleanupRegistered = true
        print("ALUI Resource Manager: Auto-cleanup registered")
    end
end

-- Initialize auto-cleanup
RM.registerAutoCleanup()

-- Helper function to update existing ALUI cleanup to use ResourceManager
if ALUI.cleanup then
    local originalCleanup = ALUI.cleanup
    ALUI.cleanup = function()
        -- Run original cleanup
        originalCleanup()
        -- Run enhanced cleanup
        RM.cleanupAll()
    end
else
    ALUI.cleanup = RM.cleanupAll
end

-- Debug function
RM.debug = function()
    local report = RM.getResourceReport()
    print("=== ALUI Resource Manager Debug ===")
    print(string.format("Total Resources: %d", report.totalResources))
    print(string.format("  Timers: %d", report.timers))
    print(string.format("  Event Handlers: %d", report.eventHandlers))
    print(string.format("  UI Elements: %d", report.uiElements))
    print(string.format("  CSS Objects: %d", report.cssObjects))

    if report.oldestResource then
        print(string.format("Oldest Resource: %s (%.1f minutes old)",
            report.oldestResource, report.oldestAge / 60))
    end
end

print("ALUI Resource Manager loaded successfully")
