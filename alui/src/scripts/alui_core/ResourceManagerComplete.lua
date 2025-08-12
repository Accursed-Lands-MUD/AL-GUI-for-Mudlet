-- Complete ResourceManager Integration Script
-- This script provides examples and patterns for integrating ResourceManager
-- into all remaining ALUI GUI components

if not ALUI or not ALUI.ResourceManager then
    error("ResourceManager must be loaded before running integration")
end

local RM = ALUI.ResourceManager

-- Integration utilities for common patterns
local Integration = {
    -- Pattern 1: Enhance existing UI creation functions
    wrapUICreation = function(originalFunction, category)
        return function(name, ...)
            local element = originalFunction(...)
            if element and name then
                RM.registerUIElement(name, element, category or "ui")
            end
            return element
        end
    end,

    -- Pattern 2: Enhance timer creation functions
    wrapTimerCreation = function(originalFunction, category)
        return function(name, delay, callback, recurring)
            -- Kill existing timer if it exists
            RM.killTimer(name)
            -- Create new tracked timer
            return RM.createTimer(name, delay, callback, recurring, category or "timer")
        end
    end,

    -- Pattern 3: Enhance CSS creation functions
    wrapCSSCreation = function(originalFunction, category)
        return function(name, stylesheet)
            local css = originalFunction(stylesheet)
            if css and name then
                RM.registerCSS(name, css, category or "style")
            end
            return css
        end
    end,

    -- Pattern 4: Create category cleanup functions
    createCategoryCleanup = function(category)
        return function()
            return RM.cleanupByCategory(category)
        end
    end
}

-- Enhanced GUI namespace functions
ALUI.GUI.Enhanced = ALUI.GUI.Enhanced or {}

-- Enhanced UI creation with automatic ResourceManager integration
ALUI.GUI.Enhanced.createBox = function(name, config, parent, category)
    local box = Geyser.HBox:new(config, parent)
    RM.registerUIElement(name, box, category or "ui")
    return box
end

ALUI.GUI.Enhanced.createVBox = function(name, config, parent, category)
    local box = Geyser.VBox:new(config, parent)
    RM.registerUIElement(name, box, category or "ui")
    return box
end

ALUI.GUI.Enhanced.createLabel = function(name, config, parent, category)
    local label = Geyser.Label:new(config, parent)
    RM.registerUIElement(name, label, category or "ui")
    return label
end

ALUI.GUI.Enhanced.createGauge = function(name, config, parent, category)
    local gauge = Geyser.Gauge:new(config, parent)
    RM.registerUIElement(name, gauge, category or "ui")
    return gauge
end

ALUI.GUI.Enhanced.createContainer = function(name, config, parent, category)
    local container = Geyser.Container:new(config, parent)
    RM.registerUIElement(name, container, category or "ui")
    return container
end

-- Enhanced CSS management
ALUI.GUI.Enhanced.createCSS = function(name, stylesheet, category)
    local css = CSSMan.new(stylesheet)
    RM.registerCSS(name, css, category or "style")
    return css
end

-- Enhanced timer management with categories
ALUI.GUI.Enhanced.createUITimer = function(name, delay, callback, recurring)
    return RM.createTimer(name, delay, callback, recurring, "ui")
end

ALUI.GUI.Enhanced.createAnimationTimer = function(name, delay, callback, recurring)
    return RM.createTimer(name, delay, callback, recurring, "animation")
end

ALUI.GUI.Enhanced.createUpdateTimer = function(name, delay, callback, recurring)
    return RM.createTimer(name, delay, callback, recurring, "update")
end

-- Category-specific cleanup functions
ALUI.GUI.Enhanced.cleanupUI = Integration.createCategoryCleanup("ui")
ALUI.GUI.Enhanced.cleanupAnimations = Integration.createCategoryCleanup("animation")
ALUI.GUI.Enhanced.cleanupUpdates = Integration.createCategoryCleanup("update")
ALUI.GUI.Enhanced.cleanupStyles = Integration.createCategoryCleanup("style")
ALUI.GUI.Enhanced.cleanupHeaders = Integration.createCategoryCleanup("header")
ALUI.GUI.Enhanced.cleanupGauges = Integration.createCategoryCleanup("gauge")

-- Integration examples for specific files

-- Example: Header_Icons.lua integration
ALUI.GUI.Enhanced.HeaderIcons = {
    createHeader = function()
        -- Create main header container
        local header = ALUI.GUI.Enhanced.createBox(
            "mainHeader",
            {
                name = "GUI.Header",
                x = 0,
                y = 0,
                width = "100%",
                height = "100%"
            },
            GUI.Top,
            "header"
        )

        -- Create header background CSS
        local headerCSS = ALUI.GUI.Enhanced.createCSS(
            "headerBackground",
            [[
                background-color: rgba(0, 0, 0, 0.8);
                border: 1px solid #333;
            ]],
            "header"
        )

        -- Create header update timer
        ALUI.GUI.Enhanced.createUpdateTimer(
            "headerUpdate",
            5.0,
            function()
                -- Header update logic
                if GUI.Header then
                    GUI.Header:update()
                end
            end,
            true
        )

        return header
    end,

    cleanup = function()
        return ALUI.GUI.Enhanced.cleanupHeaders()
    end
}

-- Example: Gauges.lua integration
ALUI.GUI.Enhanced.Gauges = {
    createHealthGauge = function(config)
        local gauge = ALUI.GUI.Enhanced.createGauge(
            "healthGauge",
            config,
            GUI.Right,
            "gauge"
        )

        -- Create gauge update timer
        ALUI.GUI.Enhanced.createUpdateTimer(
            "healthGaugeUpdate",
            0.1,
            function()
                if gauge and ALUI.Health.current and ALUI.Health.max then
                    gauge:setValue(ALUI.Health.current, ALUI.Health.max)
                end
            end,
            true
        )

        return gauge
    end,

    createManaGauge = function(config)
        local gauge = ALUI.GUI.Enhanced.createGauge(
            "manaGauge",
            config,
            GUI.Right,
            "gauge"
        )

        ALUI.GUI.Enhanced.createUpdateTimer(
            "manaGaugeUpdate",
            0.1,
            function()
                if gauge and ALUI.Status.vitals.mana and ALUI.Status.vitals.maxmana then
                    gauge:setValue(ALUI.Status.vitals.mana, ALUI.Status.vitals.maxmana)
                end
            end,
            true
        )

        return gauge
    end,

    cleanup = function()
        return ALUI.GUI.Enhanced.cleanupGauges()
    end
}

-- Example: Boxes.lua integration
ALUI.GUI.Enhanced.Boxes = {
    createChatBox = function()
        local chatBox = ALUI.GUI.Enhanced.createBox(
            "chatBox",
            {
                name = "GUI.Chat",
                x = 0,
                y = "100%-200",
                width = "40%",
                height = "200"
            },
            GUI.Main,
            "chat"
        )

        -- Create chat styling
        local chatCSS = ALUI.GUI.Enhanced.createCSS(
            "chatBoxStyle",
            [[
                background-color: rgba(0, 0, 0, 0.9);
                border: 2px solid #444;
                color: #ffffff;
            ]],
            "chat"
        )

        return chatBox
    end,

    createStatusBox = function()
        local statusBox = ALUI.GUI.Enhanced.createVBox(
            "statusBox",
            {
                name = "GUI.Status",
                x = "100%-300",
                y = 0,
                width = "300",
                height = "100%"
            },
            GUI.Main,
            "status"
        )

        return statusBox
    end,

    cleanup = function()
        return RM.cleanupByCategory("chat") + RM.cleanupByCategory("status")
    end
}

-- Migration helper for existing files
ALUI.ResourceManager.Migration = {
    -- Scan existing code for timer patterns
    findTimerPatterns = function(code)
        local patterns = {
            "tempTimer%s*%(",
            "killTimer%s*%(",
            "GUI%.Timers%[",
            "ALUI%.GUI%.Timers%["
        }

        local found = {}
        for _, pattern in ipairs(patterns) do
            for match in string.gmatch(code, pattern) do
                table.insert(found, match)
            end
        end

        return found
    end,

    -- Scan for UI element creation patterns
    findUIPatterns = function(code)
        local patterns = {
            "Geyser%.%w+:new%s*%(",
            "CSSMan%.new%s*%(",
            "Adjustable%.Container:new%s*%("
        }

        local found = {}
        for _, pattern in ipairs(patterns) do
            for match in string.gmatch(code, pattern) do
                table.insert(found, match)
            end
        end

        return found
    end,

    -- Generate migration suggestions
    generateSuggestions = function(filename)
        local file = io.open(filename, "r")
        if not file then return nil end

        local content = file:read("*all")
        file:close()

        local suggestions = {
            filename = filename,
            timerPatterns = ALUI.ResourceManager.Migration.findTimerPatterns(content),
            uiPatterns = ALUI.ResourceManager.Migration.findUIPatterns(content),
            suggestions = {}
        }

        -- Generate specific suggestions based on patterns found
        if #suggestions.timerPatterns > 0 then
            table.insert(suggestions.suggestions,
                "Replace timer creation with RM.createTimer() for automatic tracking")
        end

        if #suggestions.uiPatterns > 0 then
            table.insert(suggestions.suggestions,
                "Replace UI creation with ALUI.GUI.Enhanced functions for automatic tracking")
        end

        return suggestions
    end
}

-- Development helpers
ALUI.ResourceManager.Dev = {
    -- Test resource creation and cleanup
    testResourceLifecycle = function()
        print("Testing ResourceManager lifecycle...")

        -- Create test resources
        local timer = RM.createTimer("testTimer", 1.0, function() end, false, "test")
        local css = ALUI.GUI.Enhanced.createCSS("testCSS", "color: red;", "test")

        -- Verify they exist
        local report1 = RM.getResourceReport()
        print(string.format("Created resources: %d total", report1.totalResources))

        -- Clean them up
        local cleaned = RM.cleanupByCategory("test")
        print(string.format("Cleaned up: %d resources", cleaned))

        -- Verify cleanup
        local report2 = RM.getResourceReport()
        print(string.format("Remaining resources: %d total", report2.totalResources))

        return cleaned > 0
    end,

    -- Monitor resource usage over time
    startResourceMonitoring = function(interval)
        interval = interval or 10 -- Default 10 seconds

        RM.createTimer("resourceMonitor", interval, function()
            local report = RM.getResourceReport()
            print(string.format("[%s] Resources: %d total (T:%d, E:%d, U:%d, C:%d)",
                os.date("%H:%M:%S"),
                report.totalResources,
                report.timers,
                report.eventHandlers,
                report.uiElements,
                report.cssObjects
            ))
        end, true, "monitoring")

        print("Resource monitoring started (interval: " .. interval .. "s)")
    end,

    -- Stop resource monitoring
    stopResourceMonitoring = function()
        RM.killTimer("resourceMonitor")
        print("Resource monitoring stopped")
    end
}

-- Initialize integration
local function initializeCompleteIntegration()
    print("ALUI ResourceManager: Complete integration initialized")
    print("Available enhanced functions:")
    print("  - ALUI.GUI.Enhanced.* for UI creation with automatic tracking")
    print("  - ALUI.ResourceManager.Migration.* for migration assistance")
    print("  - ALUI.ResourceManager.Dev.* for development and testing")
    print("")
    print("Test the system with: ALUI.ResourceManager.Dev.testResourceLifecycle()")
    print("Start monitoring with: ALUI.ResourceManager.Dev.startResourceMonitoring()")
end

-- Auto-initialize
initializeCompleteIntegration()

-- Export integration utilities
return {
    Integration = Integration,
    Enhanced = ALUI.GUI.Enhanced,
    Migration = ALUI.ResourceManager.Migration,
    Dev = ALUI.ResourceManager.Dev
}
