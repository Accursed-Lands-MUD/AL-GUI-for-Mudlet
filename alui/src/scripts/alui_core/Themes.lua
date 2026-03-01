-- ALUI Theme and Preset System
-- Provides pre-configured themes and the ability to save/load configuration presets
-- Enhances the configuration system with user-friendly theme management

-- Ensure ALUI namespace exists
if not ALUI or not ALUI.Config then
    error("ALUI Configuration system not loaded. Please ensure Config.lua is loaded first.")
end

ALUI.Themes = ALUI.Themes or {}
local Themes = ALUI.Themes
local Config = ALUI.Config

-- Cache home directory path to avoid repeated system calls
local MUDLET_HOME_DIR = getMudletHomeDir()

-- Built-in theme definitions
Themes.builtIn = {
    -- Classic AL theme (original colors)
    classic = {
        name = "Classic AL",
        description = "Original AL-GUI color scheme with blue accents",
        author = "AL-GUI Team",
        version = "1.0",
        config = {
            colors = {
                primary = {
                    blue = "#2A768C",
                    green = "#2EA652",
                    yellow = "#E1B03E",
                    orange = "#C3701C",
                    red = "#830000"
                },
                status = {
                    aggressive = "#830000",
                    defensive = "#2A768C",
                    neutral = "rgba(0,0,0,100)",
                    transparent = "rgba(0,0,0,0)"
                },
                text = {
                    primary = "black",
                    secondary = "white",
                    muted = "gray"
                }
            },
            ui = {
                sideBorderPercent = 25,
                topBorderPercent = 5,
                guiPadding = 10
            }
        }
    },

    -- Dark theme with purple accents
    midnight = {
        name = "Midnight Purple",
        description = "Dark theme with purple accents for night gaming",
        author = "Community",
        version = "1.0",
        config = {
            colors = {
                primary = {
                    blue = "#6A4C93",   -- Purple-blue
                    green = "#52C41A",  -- Bright green
                    yellow = "#FAAD14", -- Gold
                    orange = "#FA8C16", -- Orange
                    red = "#F5222D"     -- Bright red
                },
                status = {
                    aggressive = "#F5222D",
                    defensive = "#6A4C93",
                    neutral = "rgba(20,20,30,180)",
                    transparent = "rgba(0,0,0,0)"
                },
                text = {
                    primary = "#E6E6FA",   -- Lavender
                    secondary = "#DDA0DD", -- Plum
                    muted = "#9370DB"      -- Medium slate blue
                }
            },
            ui = {
                sideBorderPercent = 20,
                topBorderPercent = 4,
                guiPadding = 15
            }
        }
    },

    -- High contrast theme for accessibility
    highContrast = {
        name = "High Contrast",
        description = "High contrast theme for better visibility",
        author = "Accessibility Team",
        version = "1.0",
        config = {
            colors = {
                primary = {
                    blue = "#0066FF",   -- Bright blue
                    green = "#00CC00",  -- Bright green
                    yellow = "#FFFF00", -- Bright yellow
                    orange = "#FF6600", -- Bright orange
                    red = "#FF0000"     -- Bright red
                },
                status = {
                    aggressive = "#FF0000",
                    defensive = "#0066FF",
                    neutral = "rgba(0,0,0,255)",
                    transparent = "rgba(255,255,255,0)"
                },
                text = {
                    primary = "#FFFFFF",
                    secondary = "#FFFF00",
                    muted = "#CCCCCC"
                }
            },
            ui = {
                sideBorderPercent = 30,
                topBorderPercent = 8,
                guiPadding = 20
            }
        }
    },

    -- Minimalist theme with subtle colors
    minimal = {
        name = "Minimal Clean",
        description = "Clean, minimalist design with subtle colors",
        author = "Design Team",
        version = "1.0",
        config = {
            colors = {
                primary = {
                    blue = "#718096",   -- Cool gray
                    green = "#68D391",  -- Soft green
                    yellow = "#F6E05E", -- Soft yellow
                    orange = "#ED8936", -- Soft orange
                    red = "#F56565"     -- Soft red
                },
                status = {
                    aggressive = "#F56565",
                    defensive = "#718096",
                    neutral = "rgba(247,250,252,100)",
                    transparent = "rgba(0,0,0,0)"
                },
                text = {
                    primary = "#2D3748",   -- Dark gray
                    secondary = "#4A5568", -- Medium gray
                    muted = "#718096"      -- Light gray
                }
            },
            ui = {
                sideBorderPercent = 22,
                topBorderPercent = 3,
                guiPadding = 12
            }
        }
    },

    -- Gaming theme with neon colors
    neon = {
        name = "Neon Gaming",
        description = "Vibrant neon colors for an energetic gaming experience",
        author = "Gaming Community",
        version = "1.0",
        config = {
            colors = {
                primary = {
                    blue = "#00FFFF",   -- Cyan
                    green = "#00FF00",  -- Lime
                    yellow = "#FFFF00", -- Yellow
                    orange = "#FF7F00", -- Orange
                    red = "#FF1493"     -- Deep pink
                },
                status = {
                    aggressive = "#FF1493",
                    defensive = "#00FFFF",
                    neutral = "rgba(0,0,0,200)",
                    transparent = "rgba(0,0,0,0)"
                },
                text = {
                    primary = "#FFFFFF",
                    secondary = "#00FFFF",
                    muted = "#808080"
                }
            },
            ui = {
                sideBorderPercent = 18,
                topBorderPercent = 6,
                guiPadding = 8
            }
        }
    }
}

-- User preset storage
Themes.userPresets = {}
Themes.currentTheme = "classic"

-- Theme management functions
function Themes.list()
    cecho("<cyan>Available Themes:\n")
    cecho("<white>Built-in Themes:\n")

    for id, theme in pairs(Themes.builtIn) do
        local current = (Themes.currentTheme == id) and " <green>(current)" or ""
        cecho(f "<white>  {id} <dim_grey>- <yellow>{theme.name}<dim_grey> by {theme.author}{current}\n")
        cecho(f "<dim_grey>    {theme.description}\n")
    end

    if next(Themes.userPresets) then
        cecho("<white>User Presets:\n")
        for id, preset in pairs(Themes.userPresets) do
            local current = (Themes.currentTheme == id) and " <green>(current)" or ""
            cecho(f "<white>  {id} <dim_grey>- <yellow>{preset.name}<dim_grey> (custom){current}\n")
        end
    end
end

-- Apply a theme
function Themes.apply(themeId)
    local theme = Themes.builtIn[themeId] or Themes.userPresets[themeId]

    if not theme then
        cecho(f "<red>Theme not found: <white>{themeId}\n")
        return false
    end

    -- Apply theme configuration
    local function mergeThemeConfig(target, source)
        for key, value in pairs(source) do
            if type(value) == "table" and type(target[key]) == "table" then
                mergeThemeConfig(target[key], value)
            else
                target[key] = value
            end
        end
    end

    -- Create backup of current config
    Themes.configBackup = Config.export()

    -- Apply theme settings
    mergeThemeConfig(Config.current, theme.config)

    -- Apply configuration to systems
    Config.apply()

    -- Save current theme
    Themes.currentTheme = themeId

    cecho(f "<green>Applied theme: <white>{theme.name}\n")
    cecho("<dim_grey>Use 'theme save <name>' to make this permanent\n")

    return true
end

-- Save current configuration as a theme preset
function Themes.save(presetName, description)
    if not presetName or presetName == "" then
        cecho("<red>Error: Preset name required\n")
        cecho("<white>Usage: theme save <name> [description]\n")
        return false
    end

    -- Check if name conflicts with built-in themes
    if Themes.builtIn[presetName] then
        cecho(f "<red>Error: Cannot override built-in theme '<white>{presetName}<red>'\n")
        return false
    end

    -- Create preset
    local preset = {
        name = presetName:gsub("^%l", string.upper), -- Capitalize first letter
        description = description or "Custom user preset",
        author = getProfileName() or "User",
        created = os.date("%Y-%m-%d %H:%M:%S"),
        config = Config.current
    }

    Themes.userPresets[presetName] = preset
    Themes.currentTheme = presetName

    -- Save presets to file
    Themes.savePresets()

    cecho(f "<green>Saved preset: <white>{preset.name}\n")
    return true
end

-- Delete a user preset
function Themes.delete(presetName)
    if not presetName or presetName == "" then
        cecho("<red>Error: Preset name required\n")
        return false
    end

    if Themes.builtIn[presetName] then
        cecho(f "<red>Error: Cannot delete built-in theme '<white>{presetName}<red>'\n")
        return false
    end

    if not Themes.userPresets[presetName] then
        cecho(f "<red>Preset not found: <white>{presetName}\n")
        return false
    end

    Themes.userPresets[presetName] = nil
    Themes.savePresets()

    cecho(f "<yellow>Deleted preset: <white>{presetName}\n")
    return true
end

-- Load user presets from file
function Themes.loadPresets()
    local presetsFile = MUDLET_HOME_DIR .. "/alui_themes.json"

    local success, presets = pcall(function()
        local file = io.open(presetsFile, "r")
        if not file then return {} end

        local content = file:read("*all")
        file:close()

        if content and content:trim() ~= "" then
            return yajl.to_value(content)
        end
        return {}
    end)

    if success and type(presets) == "table" then
        Themes.userPresets = presets
        if Config.get("performance.enableDebugMode") then
            cecho("<dim_grey>Loaded user theme presets\n")
        end
    end
end

-- Save user presets to file
function Themes.savePresets()
    local presetsFile = MUDLET_HOME_DIR .. "/alui_themes.json"

    local success = pcall(function()
        local file = io.open(presetsFile, "w")
        if not file then
            error("Could not open themes file for writing: " .. presetsFile)
        end

        local jsonPresets = yajl.to_string(Themes.userPresets)
        file:write(jsonPresets)
        file:close()
    end)

    if not success then
        cecho("<red>Failed to save theme presets\n")
    end
end

-- Reset to original configuration
function Themes.resetToOriginal()
    if Themes.configBackup then
        Config.import(Themes.configBackup)
        cecho("<green>Restored original configuration\n")
    else
        Config.reset()
        cecho("<green>Reset to default configuration\n")
    end

    Themes.currentTheme = "default"
end

-- Export theme configuration
function Themes.export(themeId)
    local theme = Themes.builtIn[themeId] or Themes.userPresets[themeId]

    if not theme then
        cecho(f "<red>Theme not found: <white>{themeId}\n")
        return nil
    end

    local exportData = {
        theme = theme,
        exported = os.date("%Y-%m-%d %H:%M:%S"),
        version = "1.0"
    }

    local jsonStr = yajl.to_string(exportData)
    cecho(f "<cyan>Theme Export - {theme.name}:\n")
    cecho(f "<dim_grey>{jsonStr}\n")

    return jsonStr
end

-- Import theme from JSON
function Themes.import(jsonStr, presetName)
    if not jsonStr or not presetName then
        cecho("<red>Error: JSON data and preset name required\n")
        return false
    end

    local success, importData = pcall(yajl.to_value, jsonStr)
    if not success or not importData.theme then
        cecho("<red>Invalid theme export format\n")
        return false
    end

    local theme = importData.theme
    theme.imported = os.date("%Y-%m-%d %H:%M:%S")

    Themes.userPresets[presetName] = theme
    Themes.savePresets()

    cecho(f "<green>Imported theme as: <white>{presetName}\n")
    return true
end

-- Theme command handler
local function handleThemeCommand(action, name, description)
    action = action and string.lower(action)

    if not action or action == "help" then
        cecho("<cyan>ALUI Theme Commands:\n")
        cecho("<white>  theme list                    <dim_grey>- List available themes\n")
        cecho("<white>  theme apply <name>            <dim_grey>- Apply a theme\n")
        cecho("<white>  theme save <name> [desc]      <dim_grey>- Save current config as preset\n")
        cecho("<white>  theme delete <name>           <dim_grey>- Delete user preset\n")
        cecho("<white>  theme export <name>           <dim_grey>- Export theme as JSON\n")
        cecho("<white>  theme import <json> <name>    <dim_grey>- Import theme from JSON\n")
        cecho("<white>  theme reset                   <dim_grey>- Reset to original config\n")
        cecho("<dim_grey>\nExamples:\n")
        cecho("<white>  theme apply midnight\n")
        cecho("<white>  theme save myTheme 'My custom blue theme'\n")
        return
    end

    if action == "list" then
        Themes.list()
    elseif action == "apply" then
        if not name then
            cecho("<red>Error: Theme name required\n")
            return
        end
        Themes.apply(name)
    elseif action == "save" then
        Themes.save(name, description)
    elseif action == "delete" then
        Themes.delete(name)
    elseif action == "export" then
        Themes.export(name)
    elseif action == "reset" then
        Themes.resetToOriginal()
    else
        cecho(f "<red>Unknown theme action: <white>{action}\n")
        cecho("<dim_grey>Use 'theme help' for available commands\n")
    end
end

-- Register theme command
if tempAlias then
    if ALUI.ThemeAlias then
        killAlias(ALUI.ThemeAlias)
    end

    ALUI.ThemeAlias = tempAlias("^theme\\s*(\\w*)\\s*(\\S*)\\s*(.*)$", function()
        local action = matches[2] and matches[2] ~= "" and matches[2] or nil
        local name = matches[3] and matches[3] ~= "" and matches[3] or nil
        local description = matches[4] and matches[4] ~= "" and matches[4] or nil

        handleThemeCommand(action, name, description)
    end)
end

-- Initialize themes system
function Themes.init()
    Themes.loadPresets()
    cecho("<green>ALUI Theme System initialized. Type 'theme list' to see available themes.\n")
end

-- Initialize on load
Themes.init()

return Themes
