-- Configuration Management System for AL-GUI
-- Implements suggestion #11: Centralized configuration with persistence, validation, and hot-reloading
-- Part of the consolidated ALUI namespace structure

-- Ensure the ALUI namespace exists (will be created by namespace.lua if not present)
if not ALUI then
    ALUI = {}
end

ALUI.Config = ALUI.Config or {}
local Config = ALUI.Config

-- Configuration file path
local CONFIG_FILE = getMudletHomeDir() .. "/alui_config.json"
local BACKUP_FILE = getMudletHomeDir() .. "/alui_config_backup.json"

-- Default configuration values consolidated from across the codebase
Config.defaults = {
    -- UI Layout and Dimensions
    ui = {
        -- Border and spacing configurations
        sideBorderPercent = 25, -- 25% from Create_Background.lua
        topBorderPercent = 5,   -- 5% from Create_Background.lua
        guiPadding = 10,        -- Gui_Padding from various files
        buttonWidth = 100,      -- Style_Button_Width from various files

        -- Resize behavior
        resizeTimerDelay = 0.1, -- RESIZE_TIMER_DELAY from alui_core.lua

        -- Container dimensions (percentages as strings)
        containers = {
            leftWidth = "25%",
            rightWidth = "25%",
            centerWidth = "50%",
            topHeight = "5%",
            fullHeight = "100%",
            fullWidth = "100%"
        }
    },

    -- Color scheme configuration
    colors = {
        -- Primary theme colors from alui_core.lua
        primary = {
            blue = "#2A768C",
            green = "#2EA652",
            yellow = "#E1B03E",
            orange = "#C3701C",
            red = "#830000"
        },

        -- Status indicator colors
        status = {
            aggressive = "#830000",       -- aggressiveColor from Boxes.lua
            defensive = "#2A768C",        -- defensiveColor from Boxes.lua
            neutral = "rgba(0,0,0,100)",  -- Default background from Header_Icons.lua
            transparent = "rgba(0,0,0,0)" -- Transparent background from Boxes.lua
        },

        -- Text colors
        text = {
            primary = "black", -- Default text color from Boxes.lua
            secondary = "white",
            muted = "gray"
        },

        -- Vitals color mappings (from vitals_update.lua)
        vitals = {
            thirst = {
                [1] = "#2EA652", -- green
                [2] = "#E1B03E", -- yellow
                [3] = "#C3701C", -- orange
                [4] = "#830000"  -- red
            },
            hunger = {
                [1] = "#2EA652", -- green
                [2] = "#E1B03E", -- yellow
                [3] = "#C3701C", -- orange
                [4] = "#830000"  -- red
            },
            fatigue = {
                [1] = "#2EA652", -- green
                [2] = "#E1B03E", -- yellow
                [3] = "#C3701C", -- orange
                [4] = "#830000"  -- red
            }
        }
    },

    -- Mapping system configuration
    mapping = {
        speedwalkDelay = 0,    -- map.configs.speedwalk_delay from Mapping_Script.lua
        speedwalkWait = false, -- map.configs.speedwalk_wait from Mapping_Script.lua
        autoMapping = true,    -- Enable/disable auto-mapping features
        pathHighlight = true,  -- Highlight speedwalk paths
        roomInfoDisplay = true -- Show room information
    },

    -- Chat and communication settings
    chat = {
        captureOOC = true,              -- Capture out-of-character chat
        captureGossip = true,           -- Capture gossip channel
        captureNewbie = true,           -- Capture newbie channel
        timestampFormat = "[%H:%M:%S]", -- Chat timestamp format
        maxChatLines = 1000,            -- Maximum chat history lines
        wordWrap = true                 -- Enable word wrapping in chat
    },

    -- Performance and behavior settings
    performance = {
        updateInterval = 100,    -- UI update interval in milliseconds
        maxLogSize = 10485760,   -- 10MB maximum log file size
        enableDebugMode = false, -- Enable debug logging
        cleanupInterval = 300,   -- Cleanup interval in seconds (5 minutes)
        cacheSize = 1000,        -- Maximum cache entries
        enableAnalytics = true,  -- Enable configuration analytics
        enableHotReload = true,  -- Enable hot-reloading of changes
        autoSave = true,         -- Auto-save configuration changes
        autoSaveDelay = 2.0      -- Delay before auto-saving (seconds)
    },

    -- Feature toggles
    features = {
        enableVitalsDisplay = true,  -- Show vitals in header
        enableMapIntegration = true, -- Enable mapping features
        enableChatCapture = true,    -- Enable chat capture
        enableStatusIcons = true,    -- Show status icons
        enableTooltips = true,       -- Show informational tooltips
        enableSounds = false,        -- Enable audio notifications
        enableAnimations = true,     -- Enable UI animations
        enableThemes = true,         -- Enable theme system
        enableConfigGUI = true,      -- Enable visual configuration panel
        enableConfigBackup = true    -- Enable automatic configuration backups
    },

    -- Advanced configuration options
    advanced = {
        configVersion = "1.0",    -- Configuration schema version
        migrationLevel = 6,       -- Current migration level (Suggestion #6 complete)
        backupRetentionDays = 30, -- Days to keep configuration backups
        maxConfigHistory = 50,    -- Maximum configuration history entries
        validateOnLoad = true,    -- Validate configuration when loading
        enableConfigSync = false, -- Enable cloud configuration sync (future)
        syncProvider = "none",    -- Cloud sync provider (future)
        encryptConfig = false     -- Encrypt sensitive configuration data (future)
    }
}

-- Current active configuration (starts as copy of defaults)
Config.current = {}

-- Configuration validation schemas
Config.validators = {
    ui = {
        sideBorderPercent = function(v) return type(v) == "number" and v >= 0 and v <= 50 end,
        topBorderPercent = function(v) return type(v) == "number" and v >= 0 and v <= 50 end,
        guiPadding = function(v) return type(v) == "number" and v >= 0 and v <= 100 end,
        buttonWidth = function(v) return type(v) == "number" and v >= 50 and v <= 500 end,
        resizeTimerDelay = function(v) return type(v) == "number" and v >= 0.01 and v <= 1.0 end
    },

    colors = {
        -- Color validation - accepts hex colors or rgba strings
        validateColor = function(color)
            if type(color) ~= "string" then return false end
            -- Check for hex format #RRGGBB
            if string.match(color, "^#%x%x%x%x%x%x$") then return true end
            -- Check for rgba format
            if string.match(color, "^rgba?%([%d%s,%.]+%)$") then return true end
            -- Check for named colors
            local namedColors = { "black", "white", "red", "green", "blue", "yellow", "orange", "gray", "transparent" }
            for _, named in ipairs(namedColors) do
                if color == named then return true end
            end
            return false
        end
    },

    mapping = {
        speedwalkDelay = function(v) return type(v) == "number" and v >= 0 and v <= 10 end,
        speedwalkWait = function(v) return type(v) == "boolean" end
    },

    performance = {
        updateInterval = function(v) return type(v) == "number" and v >= 10 and v <= 1000 end,
        maxLogSize = function(v) return type(v) == "number" and v >= 1048576 and v <= 104857600 end, -- 1MB to 100MB
        cleanupInterval = function(v) return type(v) == "number" and v >= 60 and v <= 3600 end       -- 1 minute to 1 hour
    }
}

-- Error handling and logging
local function logError(message, details)
    local timestamp = os.date("%Y-%m-%d %H:%M:%S")
    local logMessage = string.format("[%s] CONFIG ERROR: %s", timestamp, message)
    if details then
        logMessage = logMessage .. " Details: " .. tostring(details)
    end

    if cecho then
        cecho(f "<red>{logMessage}\n")
    else
        print(logMessage)
    end

    -- Write to log file if possible
    pcall(function()
        local logFile = io.open(getMudletHomeDir() .. "/alui_config_errors.log", "a")
        if logFile then
            logFile:write(logMessage .. "\n")
            logFile:close()
        end
    end)
end

-- Deep copy utility for configuration objects
local function deepCopy(original)
    local copy = {}
    for key, value in pairs(original) do
        if type(value) == "table" then
            copy[key] = deepCopy(value)
        else
            copy[key] = value
        end
    end
    return copy
end

-- Merge configurations with validation
local function mergeConfig(target, source, path)
    path = path or "config"

    for key, value in pairs(source) do
        local currentPath = path .. "." .. key

        if type(value) == "table" and type(target[key]) == "table" then
            -- Recursively merge nested tables
            mergeConfig(target[key], value, currentPath)
        elseif target[key] ~= nil then
            -- Validate the value if a validator exists
            local valid = true
            local categoryValidators = Config.validators[string.match(currentPath, "^config%.([^%.]+)")]

            if categoryValidators then
                local keyStr = tostring(key) -- Convert key to string to handle numeric keys
                if categoryValidators[key] and type(categoryValidators[key]) == "function" then
                    valid = categoryValidators[key](value)
                elseif keyStr:find("color") or keyStr:find("Color") then
                    -- Use color validator for any color-related keys
                    valid = categoryValidators.validateColor and categoryValidators.validateColor(value) or true
                end
            end

            if valid then
                target[key] = value
            else
                logError("Invalid configuration value",
                    string.format("Path: %s, Value: %s", currentPath, tostring(value)))
            end
        else
            -- New configuration option - log and add with caution
            logError("Unknown configuration option", string.format("Path: %s, Value: %s", currentPath, tostring(value)))
        end
    end
end

-- Load configuration from file
function Config.load()
    -- Start with defaults
    Config.current = deepCopy(Config.defaults)

    -- Try to load user configuration
    local success, userConfig = pcall(function()
        local file = io.open(CONFIG_FILE, "r")
        if not file then return nil end

        local content = file:read("*all")
        file:close()

        if content and content:trim() ~= "" then
            return yajl.to_value(content)
        end
        return nil
    end)

    if success and userConfig then
        -- Merge user configuration with defaults
        mergeConfig(Config.current, userConfig)
        if Config.current.performance.enableDebugMode then
            print("ALUI Config: Successfully loaded user configuration")
        end
    else
        -- Create default config file if it doesn't exist
        Config.save()
        if Config.current.performance.enableDebugMode then
            print("ALUI Config: Created default configuration file")
        end
    end

    -- Apply configuration to existing systems
    Config.apply()
end

-- Save current configuration to file
function Config.save()
    local success, error = pcall(function()
        -- Create backup of existing config
        if lfs.attributes(CONFIG_FILE) then
            local backupSuccess = pcall(function()
                local source = io.open(CONFIG_FILE, "r")
                local backup = io.open(BACKUP_FILE, "w")
                if source and backup then
                    backup:write(source:read("*all"))
                    source:close()
                    backup:close()
                end
            end)
            if not backupSuccess then
                logError("Failed to create configuration backup")
            end
        end

        -- Save current configuration
        local file = io.open(CONFIG_FILE, "w")
        if not file then
            error("Could not open config file for writing: " .. CONFIG_FILE)
        end

        local jsonConfig = yajl.to_string(Config.current)
        file:write(jsonConfig)
        file:close()

        if Config.current.performance.enableDebugMode then
            print("ALUI Config: Configuration saved successfully")
        end
    end)

    if not success then
        logError("Failed to save configuration", error)
    end
end

-- Get a configuration value with dot notation (e.g., "ui.sideBorderPercent")
function Config.get(path, default)
    local keys = string.split(path, ".")
    local value = Config.current

    for _, key in ipairs(keys) do
        if type(value) == "table" and value[key] ~= nil then
            value = value[key]
        else
            return default
        end
    end

    return value
end

-- Set a configuration value with validation
function Config.set(path, value)
    local keys = string.split(path, ".")
    local target = Config.current

    -- Navigate to parent of target key
    for i = 1, #keys - 1 do
        local key = keys[i]
        if type(target[key]) ~= "table" then
            target[key] = {}
        end
        target = target[key]
    end

    local finalKey = keys[#keys]

    -- Validate the value
    local category = keys[1]
    local categoryValidators = Config.validators[category]
    local valid = true

    if categoryValidators then
        if categoryValidators[finalKey] and type(categoryValidators[finalKey]) == "function" then
            valid = categoryValidators[finalKey](value)
        elseif (finalKey:find("color") or finalKey:find("Color")) and categoryValidators.validateColor then
            valid = categoryValidators.validateColor(value)
        end
    end

    if valid then
        target[finalKey] = value

        -- Auto-save if enabled
        if Config.get("performance.enableDebugMode") then
            print(f "ALUI Config: Set {path} = {value}")
        end

        -- Trigger hot-reload
        Config.notifyChange(path, value)

        return true
    else
        logError("Validation failed for configuration", f "Path: {path}, Value: {value}")
        return false
    end
end

-- Apply current configuration to all systems
function Config.apply()
    -- Apply to ALUI namespace systems
    if ALUI.GUI then
        -- Update color references
        if ALUI.GUI.Colors then
            for colorName, colorValue in pairs(Config.get("colors.primary", {})) do
                ALUI.GUI.Colors[colorName] = colorValue
            end
        end

        -- Update timer delays
        ALUI.GUI.RESIZE_TIMER_DELAY = Config.get("ui.resizeTimerDelay", 0.1)

        -- Update component references if ConfigGUI is available
        if ALUI.ConfigGUI and Config.get("features.enableConfigGUI", true) then
            -- ConfigGUI will handle its own updates via change handlers
        end

        -- Update theme system if available
        if ALUI.Themes and Config.get("features.enableThemes", true) then
            -- Themes will handle updates via change handlers
        end

        -- Update analytics if available
        if ALUI.ConfigAnalytics and Config.get("performance.enableAnalytics", true) then
            if not ALUI.ConfigAnalytics.monitoring then
                ALUI.ConfigAnalytics.startMonitoring()
            end
        end
    end

    -- Apply to mapping system
    if ALUI.Map and ALUI.Map.configs then
        ALUI.Map.configs.speedwalk_delay = Config.get("mapping.speedwalkDelay", 0)
        ALUI.Map.configs.speedwalk_wait = Config.get("mapping.speedwalkWait", false)
    end

    -- Apply to legacy systems for backward compatibility (these will proxy to ALUI)
    if GUI and GUI.Colors then
        for colorName, colorValue in pairs(Config.get("colors.primary", {})) do
            GUI.Colors[colorName] = colorValue
        end
    end

    if map and map.configs then
        map.configs.speedwalk_delay = Config.get("mapping.speedwalkDelay", 0)
        map.configs.speedwalk_wait = Config.get("mapping.speedwalkWait", false)
    end

    -- Update existing alui globals (will proxy to ALUI.Status)
    if alui then
        -- These will be proxied through the namespace compatibility layer
        alui.style = alui.style or {}
    end

    -- Apply advanced features
    Config.applyAdvancedFeatures()

    -- Broadcast configuration applied event
    if raiseEvent then
        raiseEvent("aluiConfigApplied", Config.current)
    end
end

-- Apply advanced configuration features
function Config.applyAdvancedFeatures()
    -- Hot-reload settings
    if not Config.get("performance.enableHotReload", true) then
        -- Disable hot-reload by clearing change handlers
        for path, _ in pairs(Config.changeHandlers) do
            Config.changeHandlers[path] = {}
        end
    end

    -- Auto-save settings
    if not Config.get("performance.autoSave", true) then
        -- Disable auto-save
        if Config.autoSaveTimer then
            killTimer(Config.autoSaveTimer)
            Config.autoSaveTimer = nil
        end
    else
        -- Update auto-save delay
        Config.autoSaveDelay = Config.get("performance.autoSaveDelay", 2.0)
    end

    -- Debug mode integration
    if Config.get("performance.enableDebugMode", false) then
        print("ALUI Config: Debug mode enabled - verbose logging active")
    end

    -- Analytics integration
    if Config.get("performance.enableAnalytics", true) and ALUI.ConfigAnalytics then
        if not ALUI.ConfigAnalytics.monitoring then
            ALUI.ConfigAnalytics.startMonitoring()
        end
    elseif ALUI.ConfigAnalytics and ALUI.ConfigAnalytics.monitoring then
        ALUI.ConfigAnalytics.monitoring = false
    end

    -- Backup management
    if Config.get("features.enableConfigBackup", true) then
        Config.manageBackups()
    end
end

-- Manage configuration backups
function Config.manageBackups()
    local backupDir = getMudletHomeDir() .. "/alui_config_backups"
    local retentionDays = Config.get("advanced.backupRetentionDays", 30)

    -- Create backup directory if it doesn't exist
    lfs.mkdir(backupDir)

    -- Clean old backups
    local cutoffTime = os.time() - (retentionDays * 24 * 60 * 60)

    for file in lfs.dir(backupDir) do
        if file:match("^alui_config_%d+%.json$") then
            local filepath = backupDir .. "/" .. file
            local attr = lfs.attributes(filepath)
            if attr and attr.modification < cutoffTime then
                os.remove(filepath)
            end
        end
    end

    -- Create new backup with timestamp
    local timestamp = os.date("%Y%m%d_%H%M%S")
    local backupPath = backupDir .. "/alui_config_" .. timestamp .. ".json"

    local success = pcall(function()
        local backupFile = io.open(backupPath, "w")
        if backupFile then
            backupFile:write(yajl.to_string(Config.current))
            backupFile:close()
        end
    end)

    if success and Config.get("performance.enableDebugMode", false) then
        print("ALUI Config: Created backup " .. backupPath)
    end
end

-- Hot-reload notification system
Config.changeHandlers = {}

function Config.onChange(path, handler)
    if type(handler) == "function" then
        Config.changeHandlers[path] = Config.changeHandlers[path] or {}
        table.insert(Config.changeHandlers[path], handler)
    end
end

function Config.notifyChange(path, value)
    -- Notify specific path handlers
    if Config.changeHandlers[path] then
        for _, handler in ipairs(Config.changeHandlers[path]) do
            pcall(handler, value, path)
        end
    end

    -- Notify wildcard handlers (handlers registered for parent paths)
    for handlerPath, handlers in pairs(Config.changeHandlers) do
        if path:find("^" .. handlerPath:gsub("%.", "%%.") .. "%.") then
            for _, handler in ipairs(handlers) do
                pcall(handler, value, path)
            end
        end
    end

    -- Broadcast generic change event
    raiseEvent("aluiConfigChanged", path, value)
end

-- Reset configuration to defaults
function Config.reset(category)
    if category then
        -- Reset specific category
        if Config.defaults[category] then
            Config.current[category] = deepCopy(Config.defaults[category])
            Config.apply()
            print(f "ALUI Config: Reset {category} category to defaults")
        else
            logError("Unknown configuration category", category)
        end
    else
        -- Reset all configuration
        Config.current = deepCopy(Config.defaults)
        Config.apply()
        print("ALUI Config: Reset all configuration to defaults")
    end
end

-- Export configuration for debugging/sharing
function Config.export()
    return yajl.to_string(Config.current)
end

-- Import configuration from JSON string
function Config.import(jsonString)
    local success, importedConfig = pcall(yajl.to_value, jsonString)
    if success and type(importedConfig) == "table" then
        mergeConfig(Config.current, importedConfig)
        Config.apply()
        return true
    else
        logError("Failed to import configuration", "Invalid JSON format")
        return false
    end
end

-- Get configuration schema information
function Config.getSchema()
    local schema = {
        categories = {},
        validators = {}
    }

    for category, _ in pairs(Config.defaults) do
        schema.categories[category] = {}
        for key, value in pairs(Config.defaults[category]) do
            schema.categories[category][key] = {
                type = type(value),
                default = value,
                hasValidator = Config.validators[category] and Config.validators[category][key] and true or false
            }
        end
    end

    return schema
end

-- Initialize configuration system
function Config.init()
    -- Load configuration from file
    Config.load()

    -- Set up auto-save on configuration changes
    Config.onChange("", function()
        -- Debounced save - only save after 2 seconds of no changes
        if Config.autoSaveTimer then
            killTimer(Config.autoSaveTimer)
        end
        Config.autoSaveTimer = tempTimer(2, function()
            Config.save()
            Config.autoSaveTimer = nil
        end)
    end)

    print("ALUI Configuration System initialized")
end

-- Cleanup function
function Config.cleanup()
    if Config.autoSaveTimer then
        killTimer(Config.autoSaveTimer)
        Config.autoSaveTimer = nil
    end

    -- Save any pending changes
    Config.save()
end

-- Initialize the configuration system
Config.init()

return Config
