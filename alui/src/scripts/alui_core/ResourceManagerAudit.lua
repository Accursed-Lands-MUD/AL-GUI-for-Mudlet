-- ResourceManager Integration Audit and Fix Plan
-- This file identifies and provides fixes for missed ResourceManager use cases

local RM = ALUI and ALUI.ResourceManager

if not RM then
    error("ResourceManager must be loaded before running this integration audit")
end

-- =============================================================================
-- MISSED USE CASES AUDIT RESULTS
-- =============================================================================

local MissedUseCases = {
    -- GUI Component Files (Major UI Elements)
    guiComponents = {
        {
            file = "Boxes.lua",
            issues = {
                "12 Geyser UI elements created without ResourceManager tracking",
                "Multiple CSS objects (BoxCSS, GaugeBackCSS, GaugeFrontCSS) not tracked",
                "UI elements: Mapper, MiniConsoles, VBox, Container, Labels, Buttons, Gauges"
            },
            priority = "HIGH",
            impact = "Memory leaks from UI elements, no organized cleanup"
        },
        {
            file = "Header_Icons.lua",
            issues = {
                "Geyser.HBox (GUI.Header) not tracked",
                "Multiple Geyser.Label menu items not tracked",
                "CSS objects (InfoCSS, ActionCSS) not tracked",
                "Icon management UI elements not tracked"
            },
            priority = "HIGH",
            impact = "Header elements persist without cleanup"
        },
        {
            file = "ConfigGUI.lua",
            issues = {
                "8+ Geyser UI elements for config interface not tracked",
                "UserWindow, VBox, ScrollBox, Labels for config panel",
                "No cleanup when config window closed"
            },
            priority = "MEDIUM",
            impact = "Config UI elements accumulate over time"
        },
        {
            file = "Create_Background.lua",
            issues = {
                "Background Labels (GUI.Left, GUI.Right) not tracked",
                "BackgroundCSS not tracked",
                "Core background elements have no resource management"
            },
            priority = "HIGH",
            impact = "Core UI background elements unmanaged"
        },
        {
            file = "Gauges.lua",
            issues = {
                "Gauge UI elements commented but should be tracked when active",
                "CSS objects for gauges not tracked",
                "Health, Mana, Endurance, Willpower gauges"
            },
            priority = "MEDIUM",
            impact = "Gauge resources unmanaged when enabled"
        }
    },

    -- Timer Management Issues
    timerManagement = {
        {
            file = "alui_core.lua",
            issues = {
                "Fallback tempTimer usage in resize handler",
                "Direct killTimer calls instead of ResourceManager"
            },
            priority = "HIGH",
            impact = "Core resize timers not properly managed"
        },
        {
            file = "Mapping_Script.lua",
            issues = {
                "Direct tempTimer usage in speedwalk fallback",
                "timerID variable not managed by ResourceManager"
            },
            priority = "MEDIUM",
            impact = "Speedwalk timers can leak in fallback mode"
        },
        {
            file = "Config.lua",
            issues = {
                "Config.autoSaveTimer not managed by ResourceManager",
                "Direct tempTimer/killTimer usage for auto-save functionality"
            },
            priority = "MEDIUM",
            impact = "Config auto-save timer not cleaned up properly"
        },
        {
            file = "ConfigAnalytics.lua",
            issues = {
                "tempTimer usage not using ResourceManager",
                "Analytics timers not tracked"
            },
            priority = "LOW",
            impact = "Analytics timers unmanaged"
        }
    },

    -- Event Handler Issues
    eventHandlers = {
        {
            file = "logEvent.lua",
            issues = {
                "registerAnonymousEventHandler('*', 'logEvent') not using ResourceManager",
                "Global event handler not tracked"
            },
            priority = "MEDIUM",
            impact = "Global event handler persists without cleanup"
        },
        {
            file = "Mapping_Script.lua",
            issues = {
                "Fallback event handler registration not using ResourceManager",
                "Direct registerAnonymousEventHandler calls in fallback mode"
            },
            priority = "MEDIUM",
            impact = "Mapping event handlers unmanaged in fallback"
        }
    },

    -- CSS Object Management
    cssObjects = {
        {
            file = "Boxes.lua",
            issues = {
                "GUI.BoxCSS, GUI.GaugeBackCSS, GUI.GaugeFrontCSS not tracked",
                "Multiple CSS objects created without ResourceManager"
            },
            priority = "MEDIUM",
            impact = "CSS objects accumulate without cleanup"
        },
        {
            file = "Header_Icons.lua",
            issues = {
                "GUI.InfoCSS, GUI.ActionCSS not tracked",
                "createInfoCSS() and createActionCSS() functions not using ResourceManager"
            },
            priority = "MEDIUM",
            impact = "Header CSS objects unmanaged"
        },
        {
            file = "Create_Background.lua",
            issues = {
                "GUI.BackgroundCSS not tracked",
                "Background styling not managed by ResourceManager"
            },
            priority = "LOW",
            impact = "Background CSS unmanaged"
        }
    }
}

-- =============================================================================
-- INTEGRATION FIXES
-- =============================================================================

-- Fix 1: Enhanced UI creation functions for missed GUI components
local IntegrationFixes = {}

IntegrationFixes.enhanceBoxesLua = function()
    -- Integration pattern for Boxes.lua
    local originalSetBoxes = GUI.setBoxes
    if originalSetBoxes then
        GUI.setBoxes = function()
            -- Clean up existing box resources first
            RM.cleanupByCategory("boxes")
            RM.cleanupByCategory("gauges")

            -- Run original function
            originalSetBoxes()

            -- Register created elements with ResourceManager
            if GUI.BoxCSS then
                RM.registerCSS("boxCSS", GUI.BoxCSS, "boxes")
            end
            if GUI.GaugeBackCSS then
                RM.registerCSS("gaugeBackCSS", GUI.GaugeBackCSS, "gauges")
            end
            if GUI.GaugeFrontCSS then
                RM.registerCSS("gaugeFrontCSS", GUI.GaugeFrontCSS, "gauges")
            end
            if GUI.Mapper then
                RM.registerUIElement("mapper", GUI.Mapper, "boxes")
            end
            if alui.roommini then
                RM.registerUIElement("roomMini", alui.roommini, "boxes")
            end
            if alui.combatmini then
                RM.registerUIElement("combatMini", alui.combatmini, "boxes")
            end
            if GUI.Style_VBox then
                RM.registerUIElement("styleVBox", GUI.Style_VBox, "boxes")
            end
            if GUI.Survey_Container then
                RM.registerUIElement("surveyContainer", GUI.Survey_Container, "boxes")
            end
            if alui.surveymini then
                RM.registerUIElement("surveyMini", alui.surveymini, "boxes")
            end
            if GUI.Chat_Container then
                RM.registerUIElement("chatContainer", GUI.Chat_Container, "boxes")
            end
        end

        print("ALUI ResourceManager: Enhanced Boxes.lua integration")
    end
end

IntegrationFixes.enhanceHeaderIconsLua = function()
    -- Integration pattern for Header_Icons.lua
    if GUI.Header then
        RM.registerUIElement("header", GUI.Header, "header")
    end
    if GUI.InfoCSS then
        RM.registerCSS("headerInfoCSS", GUI.InfoCSS, "header")
    end
    if GUI.ActionCSS then
        RM.registerCSS("headerActionCSS", GUI.ActionCSS, "header")
    end

    -- Enhance menu item creation
    local originalCreateMenuItem = createMenuItem
    if originalCreateMenuItem then
        createMenuItem = function(name, updateFunction, parent)
            local item = originalCreateMenuItem(name, updateFunction, parent)
            RM.registerUIElement("menuItem_" .. name, item, "header")
            return item
        end
    end

    print("ALUI ResourceManager: Enhanced Header_Icons.lua integration")
end

IntegrationFixes.enhanceConfigLua = function()
    -- Integration pattern for Config.lua auto-save timer
    local originalConfigSave = Config.queueAutoSave
    if originalConfigSave then
        Config.queueAutoSave = function()
            -- Use ResourceManager for auto-save timer
            RM.createTimer("configAutoSave", 2, function()
                Config.saveToFile()
            end, false, "config")
        end

        print("ALUI ResourceManager: Enhanced Config.lua auto-save timer")
    end
end

IntegrationFixes.enhanceLogEventLua = function()
    -- Integration pattern for logEvent.lua
    -- Replace direct event handler registration with ResourceManager
    if RM and logEvent then
        RM.registerEventHandler(
            "globalLogEvent",
            registerAnonymousEventHandler("*", "logEvent"),
            "*",
            "logging"
        )

        print("ALUI ResourceManager: Enhanced logEvent.lua integration")
    end
end

IntegrationFixes.enhanceCreateBackgroundLua = function()
    -- Integration pattern for Create_Background.lua
    if GUI.BackgroundCSS then
        RM.registerCSS("backgroundCSS", GUI.BackgroundCSS, "background")
    end
    if GUI.Left then
        RM.registerUIElement("backgroundLeft", GUI.Left, "background")
    end
    if GUI.Right then
        RM.registerUIElement("backgroundRight", GUI.Right, "background")
    end

    print("ALUI ResourceManager: Enhanced Create_Background.lua integration")
end

-- Fix 2: Comprehensive cleanup functions by component
IntegrationFixes.createComponentCleanup = function()
    -- Component-specific cleanup functions
    ALUI.ResourceManager.cleanupBoxes = function()
        return RM.cleanupByCategory("boxes")
    end

    ALUI.ResourceManager.cleanupGauges = function()
        return RM.cleanupByCategory("gauges")
    end

    ALUI.ResourceManager.cleanupHeader = function()
        return RM.cleanupByCategory("header")
    end

    ALUI.ResourceManager.cleanupConfig = function()
        return RM.cleanupByCategory("config")
    end

    ALUI.ResourceManager.cleanupBackground = function()
        return RM.cleanupByCategory("background")
    end

    ALUI.ResourceManager.cleanupLogging = function()
        return RM.cleanupByCategory("logging")
    end

    print("ALUI ResourceManager: Component cleanup functions created")
end

-- Fix 3: Migration helper for existing UI elements
IntegrationFixes.migrateExistingUIElements = function()
    local migrated = 0

    -- Check for existing GUI elements and register them
    local guiElements = {
        { name = "header",          element = GUI.Header,           category = "header" },
        { name = "mapper",          element = GUI.Mapper,           category = "boxes" },
        { name = "roomMini",        element = alui.roommini,        category = "boxes" },
        { name = "combatMini",      element = alui.combatmini,      category = "boxes" },
        { name = "surveyMini",      element = alui.surveymini,      category = "boxes" },
        { name = "styleVBox",       element = GUI.Style_VBox,       category = "boxes" },
        { name = "surveyContainer", element = GUI.Survey_Container, category = "boxes" },
        { name = "chatContainer",   element = GUI.Chat_Container,   category = "boxes" },
        { name = "backgroundLeft",  element = GUI.Left,             category = "background" },
        { name = "backgroundRight", element = GUI.Right,            category = "background" }
    }

    for _, item in ipairs(guiElements) do
        if item.element then
            RM.registerUIElement(item.name, item.element, item.category)
            migrated = migrated + 1
        end
    end

    -- Check for existing CSS objects
    local cssObjects = {
        { name = "boxCSS",          object = GUI.BoxCSS,        category = "boxes" },
        { name = "gaugeBackCSS",    object = GUI.GaugeBackCSS,  category = "gauges" },
        { name = "gaugeFrontCSS",   object = GUI.GaugeFrontCSS, category = "gauges" },
        { name = "headerInfoCSS",   object = GUI.InfoCSS,       category = "header" },
        { name = "headerActionCSS", object = GUI.ActionCSS,     category = "header" },
        { name = "backgroundCSS",   object = GUI.BackgroundCSS, category = "background" }
    }

    for _, item in ipairs(cssObjects) do
        if item.object then
            RM.registerCSS(item.name, item.object, item.category)
            migrated = migrated + 1
        end
    end

    if migrated > 0 then
        print(string.format("ALUI ResourceManager: Migrated %d existing UI elements and CSS objects", migrated))
    end

    return migrated
end

-- =============================================================================
-- AUTO-APPLY INTEGRATION FIXES
-- =============================================================================

local function applyAllIntegrationFixes()
    print("ALUI ResourceManager: Applying integration fixes for missed use cases...")

    -- Apply all fixes
    IntegrationFixes.enhanceBoxesLua()
    IntegrationFixes.enhanceHeaderIconsLua()
    IntegrationFixes.enhanceConfigLua()
    IntegrationFixes.enhanceLogEventLua()
    IntegrationFixes.enhanceCreateBackgroundLua()
    IntegrationFixes.createComponentCleanup()

    -- Migrate existing elements
    local migrated = IntegrationFixes.migrateExistingUIElements()

    print("ALUI ResourceManager: All integration fixes applied")
    print(string.format("Total elements migrated: %d", migrated))

    -- Show current resource summary
    local report = RM.getResourceReport()
    print(string.format("Current resource count: %d total", report.totalResources))
end

-- =============================================================================
-- VALIDATION AND TESTING
-- =============================================================================

IntegrationFixes.validateIntegration = function()
    print("=== ResourceManager Integration Validation ===")

    local issues = {}

    -- Check if major UI elements are tracked
    local expectedElements = {
        "header", "mapper", "roomMini", "combatMini", "surveyMini",
        "styleVBox", "surveyContainer", "chatContainer",
        "backgroundLeft", "backgroundRight"
    }

    for _, elementName in ipairs(expectedElements) do
        if not RM.resources.uiElements[elementName] then
            table.insert(issues, "Missing UI element: " .. elementName)
        end
    end

    -- Check if major CSS objects are tracked
    local expectedCSS = {
        "boxCSS", "gaugeBackCSS", "gaugeFrontCSS",
        "headerInfoCSS", "headerActionCSS", "backgroundCSS"
    }

    for _, cssName in ipairs(expectedCSS) do
        if not RM.resources.cssObjects[cssName] then
            table.insert(issues, "Missing CSS object: " .. cssName)
        end
    end

    -- Report results
    if #issues == 0 then
        print("✅ All major UI elements and CSS objects are tracked")
    else
        print("❌ Integration issues found:")
        for _, issue in ipairs(issues) do
            print("  - " .. issue)
        end
    end

    -- Show resource summary
    RM.getResourceSummary()

    return #issues == 0
end

-- Auto-apply fixes on load
applyAllIntegrationFixes()

-- Export for manual use
return {
    audit = MissedUseCases,
    fixes = IntegrationFixes,
    applyAll = applyAllIntegrationFixes
}
