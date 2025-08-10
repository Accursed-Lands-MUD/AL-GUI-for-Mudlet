-- ALUI Configuration System Integration Test
-- Tests all components of the configuration management system
-- Ensures proper integration with namespace consolidation (Suggestion #6)

local function testConfigurationSystem()
    cecho("<cyan>ALUI Configuration System Integration Test\n")
    cecho("<white>==========================================\n")
    
    local tests = {
        passed = 0,
        failed = 0,
        total = 0
    }
    
    local function test(name, testFunc)
        tests.total = tests.total + 1
        cecho(f"<white>Testing {name}... ")
        
        local success, result = pcall(testFunc)
        if success and result then
            tests.passed = tests.passed + 1
            cecho("<green>PASS\n")
        else
            tests.failed = tests.failed + 1
            cecho(f"<red>FAIL{result and (' - ' .. result) or ''}\n")
        end
    end
    
    -- Test 1: Basic configuration system availability
    test("Configuration System Loaded", function()
        return ALUI and ALUI.Config and type(ALUI.Config.get) == "function"
    end)
    
    -- Test 2: Configuration commands available
    test("Configuration Commands", function()
        return ALUI.ConfigCommands and type(ALUI.ConfigCommands.handle) == "function"
    end)
    
    -- Test 3: Theme system availability
    test("Theme System", function()
        return ALUI.Themes and ALUI.Themes.builtIn and next(ALUI.Themes.builtIn)
    end)
    
    -- Test 4: Analytics system availability
    test("Analytics System", function()
        return ALUI.ConfigAnalytics and type(ALUI.ConfigAnalytics.getReport) == "function"
    end)
    
    -- Test 5: Configuration GUI availability  
    test("Configuration GUI", function()
        return ALUI.ConfigGUI and type(ALUI.ConfigGUI.create) == "function"
    end)
    
    -- Test 6: Basic configuration retrieval
    test("Configuration Retrieval", function()
        local value = ALUI.Config.get("ui.guiPadding", 10)
        return type(value) == "number" and value >= 0
    end)
    
    -- Test 7: Configuration setting with validation
    test("Configuration Setting", function()
        local originalValue = ALUI.Config.get("ui.guiPadding")
        local success = ALUI.Config.set("ui.guiPadding", 15)
        local newValue = ALUI.Config.get("ui.guiPadding")
        
        -- Restore original value
        ALUI.Config.set("ui.guiPadding", originalValue)
        
        return success and newValue == 15
    end)
    
    -- Test 8: Validation rejection
    test("Validation System", function()
        local success = ALUI.Config.set("ui.sideBorderPercent", -10) -- Invalid negative value
        return not success -- Should fail validation
    end)
    
    -- Test 9: Theme application
    test("Theme Application", function()
        local originalTheme = ALUI.Themes.currentTheme
        local success = ALUI.Themes.apply("classic")
        
        -- Restore original theme if needed
        if originalTheme and originalTheme ~= "classic" then
            ALUI.Themes.apply(originalTheme)
        end
        
        return success
    end)
    
    -- Test 10: Hot-reload system
    test("Hot-reload System", function()
        local handlerCalled = false
        
        -- Register temporary change handler
        ALUI.Config.onChange("test.value", function()
            handlerCalled = true
        end)
        
        -- Trigger change
        ALUI.Config.set("test.value", "test")
        
        -- Clean up
        ALUI.Config.changeHandlers["test.value"] = nil
        
        return handlerCalled
    end)
    
    -- Test 11: Namespace integration
    test("Namespace Integration", function()
        return ALUI.GUI and ALUI.GUI.Colors and 
               GUI and GUI.Colors and -- Legacy compatibility
               ALUI.Config.get("colors.primary.blue") == GUI.Colors.blue
    end)
    
    -- Test 12: Configuration categories
    test("Configuration Categories", function()
        local categories = {"ui", "colors", "mapping", "chat", "performance", "features", "advanced"}
        for _, category in ipairs(categories) do
            if not ALUI.Config.current[category] then
                return false
            end
        end
        return true
    end)
    
    -- Test 13: Analytics data collection
    test("Analytics Data Collection", function()
        if ALUI.ConfigAnalytics.monitoring then
            local report = ALUI.ConfigAnalytics.getReport()
            return report and report.summary and type(report.summary.totalConfigChanges) == "number"
        else
            return true -- Not monitoring, that's fine
        end
    end)
    
    -- Test 14: Built-in themes availability
    test("Built-in Themes", function()
        local expectedThemes = {"classic", "midnight", "highContrast", "minimal", "neon"}
        for _, theme in ipairs(expectedThemes) do
            if not ALUI.Themes.builtIn[theme] then
                return false
            end
        end
        return true
    end)
    
    -- Test 15: Configuration persistence (mock test)
    test("Configuration Persistence", function()
        -- Test that save/load functions exist and are callable
        return type(ALUI.Config.save) == "function" and 
               type(ALUI.Config.load) == "function"
    end)
    
    -- Display results
    cecho("<white>==========================================\n")
    cecho(f"<green>Tests Passed: {tests.passed}/{tests.total}\n")
    if tests.failed > 0 then
        cecho(f"<red>Tests Failed: {tests.failed}/{tests.total}\n")
    end
    
    local percentage = math.floor((tests.passed / tests.total) * 100)
    cecho(f"<cyan>Success Rate: {percentage}%\n")
    
    if tests.failed == 0 then
        cecho("<green>✅ All configuration systems are working correctly!\n")
        cecho("<dim_grey>Suggestion #11 implementation is fully functional.\n")
    else
        cecho("<yellow>⚠️  Some tests failed. Check the implementation.\n")
    end
    
    return tests.failed == 0
end

-- Quick configuration demo
local function demoConfiguration()
    cecho("<cyan>ALUI Configuration Demo\n")
    cecho("<white>======================\n")
    
    cecho("<yellow>Available Commands:\n")
    cecho("<white>  config list                  <dim_grey>- List all configuration\n")
    cecho("<white>  config get ui.guiPadding     <dim_grey>- Get specific value\n")
    cecho("<white>  config set ui.guiPadding 20  <dim_grey>- Set specific value\n")
    cecho("<white>  config gui                   <dim_grey>- Open visual interface\n")
    cecho("<white>  theme list                   <dim_grey>- List available themes\n")
    cecho("<white>  theme apply midnight         <dim_grey>- Apply a theme\n")
    cecho("<white>  analytics report             <dim_grey>- View analytics\n")
    
    cecho("<yellow>Current Configuration Sample:\n")
    cecho(f"<white>  UI Padding: <green>{ALUI.Config.get('ui.guiPadding')}\n")
    cecho(f"<white>  Border Percent: <green>{ALUI.Config.get('ui.sideBorderPercent')}%\n")
    cecho(f"<white>  Primary Blue: <green>{ALUI.Config.get('colors.primary.blue')}\n")
    cecho(f"<white>  Debug Mode: <green>{ALUI.Config.get('performance.enableDebugMode') and 'On' or 'Off'}\n")
    cecho(f"<white>  Current Theme: <green>{ALUI.Themes.currentTheme}\n")
end

-- Register test commands
if tempAlias then
    -- Test command
    if ALUI.ConfigTestAlias then
        killAlias(ALUI.ConfigTestAlias)
    end
    
    ALUI.ConfigTestAlias = tempAlias("^config test$", function()
        testConfigurationSystem()
    end)
    
    -- Demo command
    if ALUI.ConfigDemoAlias then
        killAlias(ALUI.ConfigDemoAlias)
    end
    
    ALUI.ConfigDemoAlias = tempAlias("^config demo$", function()
        demoConfiguration()
    end)
end

-- Show initialization message
cecho("<green>ALUI Configuration System Test Suite loaded.\n")
cecho("<dim_grey>Use 'config test' to run integration tests.\n")
cecho("<dim_grey>Use 'config demo' to see available commands.\n")

return {
    test = testConfigurationSystem,
    demo = demoConfiguration
}
