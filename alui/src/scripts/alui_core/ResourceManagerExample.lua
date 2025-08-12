-- Example: Enhanced Header Icons with Resource Management
-- This demonstrates how to integrate ALUI.ResourceManager into existing GUI code

-- Use ALUI namespace if available, otherwise fall back to GUI
local UIElements = (ALUI and ALUI.GUI) or GUI
local RM = ALUI and ALUI.ResourceManager

-- Enhanced UI creation function that tracks resources
local function createTrackedUIElement(name, constructor, config, category)
    local element = constructor(config)

    -- Register with ResourceManager if available
    if RM then
        RM.registerUIElement(name, element, category or "ui")
    end

    return element
end

-- Enhanced CSS creation function that tracks resources
local function createTrackedCSS(name, stylesheet, category)
    local css = CSSMan.new(stylesheet)

    -- Register with ResourceManager if available
    if RM then
        RM.registerCSS(name, css, category or "style")
    end

    return css
end

-- Enhanced timer creation function that tracks resources
local function createTrackedTimer(name, delay, callback, recurring, category)
    if RM then
        return RM.createTimer(name, delay, callback, recurring, category)
    else
        -- Fallback to standard timer creation
        return tempTimer(delay, callback)
    end
end

-- Example: Modified Header creation with resource tracking
local function createHeaderWithTracking()
    -- Create header container with tracking
    local header = createTrackedUIElement(
        "mainHeader",
        function(config) return Geyser.HBox:new(config, GUI.Top) end,
        {
            name = "GUI.Header",
            x = 0,
            y = 0,
            width = "100%",
            height = "100%"
        },
        "header"
    )

    -- Create header CSS with tracking
    local headerCSS = createTrackedCSS(
        "headerStyle",
        [[
            background-color: rgba(0, 0, 0, 0.8);
            border: 1px solid #333;
        ]],
        "header"
    )

    return header, headerCSS
end

-- Example: Cleanup function for header components
local function cleanupHeader()
    if RM then
        -- Clean up all header-related resources
        RM.cleanupByCategory("header")
    else
        -- Manual cleanup fallback
        if GUI.Header then
            GUI.Header:hide()
        end
    end
end

-- Example: Create cleanup timer that runs periodically
local function setupPeriodicCleanup()
    createTrackedTimer(
        "headerMaintenanceTimer",
        300, -- 5 minutes
        function()
            if RM then
                -- Clean up old unused resources
                RM.cleanupOldResources(1800) -- 30 minutes
            end
        end,
        true, -- recurring
        "maintenance"
    )
end

-- Export functions for use by other modules
local HeaderManager = {
    create = createHeaderWithTracking,
    cleanup = cleanupHeader,
    setupMaintenance = setupPeriodicCleanup,

    -- Utility functions
    createTrackedUI = createTrackedUIElement,
    createTrackedCSS = createTrackedCSS,
    createTrackedTimer = createTrackedTimer
}

-- Initialize if ResourceManager is available
if RM then
    print("Header Icons: Enhanced with ResourceManager tracking")
    setupPeriodicCleanup()
else
    print("Header Icons: Using standard resource management")
end

return HeaderManager
