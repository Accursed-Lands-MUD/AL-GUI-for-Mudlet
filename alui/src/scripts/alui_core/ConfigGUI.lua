-- ALUI Configuration GUI Panel
-- Provides a visual interface for configuration management
-- Complements the command-line interface with user-friendly dialogs

-- Ensure ALUI namespace exists
if not ALUI or not ALUI.Config then
    error("ALUI Configuration system not loaded. Please ensure Config.lua is loaded first.")
end

ALUI.ConfigGUI = ALUI.ConfigGUI or {}
local ConfigGUI = ALUI.ConfigGUI
local Config = ALUI.Config

-- GUI Panel state
ConfigGUI.panel = nil
ConfigGUI.isOpen = false
ConfigGUI.currentCategory = "ui"
ConfigGUI.dirty = false

-- Configuration categories for the GUI
ConfigGUI.categories = {
    {id = "ui", name = "Interface", icon = "🎨", description = "Layout, sizing, and visual elements"},
    {id = "colors", name = "Colors", icon = "🌈", description = "Color themes and status indicators"},
    {id = "mapping", name = "Mapping", icon = "🗺️", description = "Map integration and navigation"},
    {id = "chat", name = "Chat", icon = "💬", description = "Chat capture and display settings"},
    {id = "performance", name = "Performance", icon = "⚡", description = "Timing, caching, and optimization"},
    {id = "features", name = "Features", icon = "🔧", description = "Enable/disable functionality"}
}

-- GUI Styling
ConfigGUI.styles = {
    panel = {
        width = 800,
        height = 600,
        background = "rgba(20, 20, 20, 240)",
        border = "2px solid #444444",
        borderRadius = "8px"
    },
    
    sidebar = {
        width = 200,
        background = "rgba(40, 40, 40, 255)",
        itemHeight = 60,
        selectedColor = "#3366CC",
        hoverColor = "#555555"
    },
    
    content = {
        background = "rgba(30, 30, 30, 255)",
        padding = 20
    },
    
    input = {
        height = 30,
        background = "rgba(50, 50, 50, 255)",
        border = "1px solid #666666",
        color = "white",
        padding = "5px"
    },
    
    button = {
        height = 32,
        background = "#3366CC",
        hoverBackground = "#4477DD",
        border = "none",
        borderRadius = "4px",
        color = "white",
        padding = "8px 16px"
    }
}

-- Create the main configuration panel
function ConfigGUI.create()
    if ConfigGUI.panel then
        ConfigGUI.destroy()
    end
    
    -- Main panel container
    ConfigGUI.panel = Geyser.UserWindow:new({
        name = "ALUI_ConfigPanel",
        title = "ALUI Configuration",
        x = "center-400", y = "center-300",
        width = ConfigGUI.styles.panel.width,
        height = ConfigGUI.styles.panel.height,
        color = "black",
        docked = false,
        autoSave = false
    })
    
    -- Panel background styling
    ConfigGUI.panel:setStyleSheet(string.format([[
        QWidget {
            background: %s;
            border: %s;
            border-radius: %s;
            color: white;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 12px;
        }
    ]], ConfigGUI.styles.panel.background, 
        ConfigGUI.styles.panel.border,
        ConfigGUI.styles.panel.borderRadius))
    
    -- Create sidebar for categories
    ConfigGUI.sidebar = Geyser.VBox:new({
        name = "ALUI_ConfigSidebar",
        x = 0, y = 0,
        width = ConfigGUI.styles.sidebar.width,
        height = "100%"
    }, ConfigGUI.panel)
    
    ConfigGUI.sidebar:setStyleSheet(string.format([[
        QWidget { background: %s; }
    ]], ConfigGUI.styles.sidebar.background))
    
    -- Create content area
    ConfigGUI.content = Geyser.ScrollBox:new({
        name = "ALUI_ConfigContent",
        x = ConfigGUI.styles.sidebar.width, y = 0,
        width = ConfigGUI.styles.panel.width - ConfigGUI.styles.sidebar.width,
        height = "100%"
    }, ConfigGUI.panel)
    
    ConfigGUI.content:setStyleSheet(string.format([[
        QWidget { 
            background: %s; 
            padding: %dpx;
        }
    ]], ConfigGUI.styles.content.background, ConfigGUI.styles.content.padding))
    
    -- Create category buttons
    ConfigGUI.categoryButtons = {}
    for i, category in ipairs(ConfigGUI.categories) do
        local button = Geyser.Label:new({
            name = "ALUI_CategoryBtn_" .. category.id,
            x = 0, y = (i-1) * ConfigGUI.styles.sidebar.itemHeight,
            width = "100%", height = ConfigGUI.styles.sidebar.itemHeight
        }, ConfigGUI.sidebar)
        
        button:setStyleSheet(string.format([[
            QLabel {
                background: transparent;
                color: white;
                padding: 10px;
                border-bottom: 1px solid #555555;
                font-weight: bold;
            }
            QLabel:hover {
                background: %s;
            }
        ]], ConfigGUI.styles.sidebar.hoverColor))
        
        button:echo(string.format([[
            <center>
                <span style="font-size: 18px;">%s</span><br/>
                <span style="font-size: 14px; font-weight: bold;">%s</span><br/>
                <span style="font-size: 10px; color: #CCCCCC;">%s</span>
            </center>
        ]], category.icon, category.name, category.description))
        
        button:setClickCallback(function()
            ConfigGUI.selectCategory(category.id)
        end)
        
        ConfigGUI.categoryButtons[category.id] = button
    end
    
    -- Create bottom toolbar
    ConfigGUI.toolbar = Geyser.HBox:new({
        name = "ALUI_ConfigToolbar",
        x = 0, y = ConfigGUI.styles.panel.height - 50,
        width = "100%", height = 50
    }, ConfigGUI.panel)
    
    ConfigGUI.toolbar:setStyleSheet([[
        QWidget {
            background: rgba(40, 40, 40, 255);
            border-top: 1px solid #666666;
            padding: 10px;
        }
    ]])
    
    -- Toolbar buttons
    ConfigGUI.saveBtn = Geyser.Label:new({
        name = "ALUI_SaveBtn",
        width = 80, height = 30
    }, ConfigGUI.toolbar)
    
    ConfigGUI.saveBtn:setStyleSheet(string.format([[
        QLabel {
            background: %s;
            color: %s;
            border: %s;
            border-radius: %s;
            padding: %s;
            font-weight: bold;
        }
        QLabel:hover {
            background: %s;
        }
    ]], ConfigGUI.styles.button.background,
        ConfigGUI.styles.button.color,
        ConfigGUI.styles.button.border,
        ConfigGUI.styles.button.borderRadius,
        ConfigGUI.styles.button.padding,
        ConfigGUI.styles.button.hoverBackground))
    
    ConfigGUI.saveBtn:echo("<center>Save</center>")
    ConfigGUI.saveBtn:setClickCallback(function()
        ConfigGUI.save()
    end)
    
    -- Reset button
    ConfigGUI.resetBtn = Geyser.Label:new({
        name = "ALUI_ResetBtn",
        width = 80, height = 30
    }, ConfigGUI.toolbar)
    
    ConfigGUI.resetBtn:setStyleSheet([[
        QLabel {
            background: #CC3333;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 16px;
            font-weight: bold;
        }
        QLabel:hover {
            background: #DD4444;
        }
    ]])
    
    ConfigGUI.resetBtn:echo("<center>Reset</center>")
    ConfigGUI.resetBtn:setClickCallback(function()
        ConfigGUI.resetCategory()
    end)
    
    -- Close button
    ConfigGUI.closeBtn = Geyser.Label:new({
        name = "ALUI_CloseBtn",
        width = 80, height = 30
    }, ConfigGUI.toolbar)
    
    ConfigGUI.closeBtn:setStyleSheet([[
        QLabel {
            background: #666666;
            color: white;
            border: none;
            border-radius: 4px;
            padding: 8px 16px;
            font-weight: bold;
        }
        QLabel:hover {
            background: #777777;
        }
    ]])
    
    ConfigGUI.closeBtn:echo("<center>Close</center>")
    ConfigGUI.closeBtn:setClickCallback(function()
        ConfigGUI.close()
    end)
    
    ConfigGUI.isOpen = true
    
    -- Load initial category
    ConfigGUI.selectCategory("ui")
    
    cecho("<green>ALUI Configuration Panel opened\n")
end

-- Select and display a configuration category
function ConfigGUI.selectCategory(categoryId)
    ConfigGUI.currentCategory = categoryId
    
    -- Update sidebar selection
    for id, button in pairs(ConfigGUI.categoryButtons) do
        if id == categoryId then
            button:setStyleSheet(string.format([[
                QLabel {
                    background: %s;
                    color: white;
                    padding: 10px;
                    border-bottom: 1px solid #555555;
                    font-weight: bold;
                }
            ]], ConfigGUI.styles.sidebar.selectedColor))
        else
            button:setStyleSheet(string.format([[
                QLabel {
                    background: transparent;
                    color: white;
                    padding: 10px;
                    border-bottom: 1px solid #555555;
                    font-weight: bold;
                }
                QLabel:hover {
                    background: %s;
                }
            ]], ConfigGUI.styles.sidebar.hoverColor))
        end
    end
    
    -- Clear and rebuild content area
    ConfigGUI.buildCategoryContent(categoryId)
end

-- Build content for a specific category
function ConfigGUI.buildCategoryContent(categoryId)
    if not ConfigGUI.content then return end
    
    ConfigGUI.content:clear()
    
    local categoryConfig = Config.current[categoryId]
    if not categoryConfig then
        ConfigGUI.content:echo("<center><span style='color: #FF6666;'>Category not found: " .. categoryId .. "</span></center>")
        return
    end
    
    -- Category title
    local categoryInfo = nil
    for _, cat in ipairs(ConfigGUI.categories) do
        if cat.id == categoryId then
            categoryInfo = cat
            break
        end
    end
    
    if categoryInfo then
        ConfigGUI.content:echo(string.format([[
            <div style="margin-bottom: 20px; padding-bottom: 10px; border-bottom: 1px solid #555555;">
                <h2 style="color: white; margin: 0;">%s %s</h2>
                <p style="color: #CCCCCC; margin: 5px 0 0 0;">%s</p>
            </div>
        ]], categoryInfo.icon, categoryInfo.name, categoryInfo.description))
    end
    
    -- Build settings for this category
    ConfigGUI.buildSettingsSection(categoryConfig, categoryId)
end

-- Build individual settings controls
function ConfigGUI.buildSettingsSection(config, path)
    for key, value in pairs(config) do
        local fullPath = path .. "." .. key
        
        if type(value) == "table" then
            -- Nested category - create collapsible section
            ConfigGUI.content:echo(string.format([[
                <div style="margin: 15px 0;">
                    <h3 style="color: #66CCFF; margin: 0 0 10px 0;">%s</h3>
                </div>
            ]], key:gsub("(%l)(%u)", "%1 %2"):gsub("^%l", string.upper)))
            
            ConfigGUI.buildSettingsSection(value, fullPath)
        else
            -- Individual setting - create appropriate control
            ConfigGUI.buildSettingControl(key, value, fullPath)
        end
    end
end

-- Build control for individual setting
function ConfigGUI.buildSettingControl(key, value, fullPath)
    local displayName = key:gsub("(%l)(%u)", "%1 %2"):gsub("^%l", string.upper)
    local valueType = type(value)
    local controlHtml = ""
    
    if valueType == "boolean" then
        local checked = value and "checked" or ""
        controlHtml = string.format([[
            <div style="margin: 10px 0; padding: 10px; background: rgba(50,50,50,100); border-radius: 4px;">
                <label style="color: white; font-weight: bold;">%s</label><br/>
                <input type="checkbox" %s onchange="ConfigGUI.updateSetting('%s', this.checked)"/> 
                <span style="color: #CCCCCC;">Enable/disable this feature</span>
            </div>
        ]], displayName, checked, fullPath)
    elseif valueType == "number" then
        controlHtml = string.format([[
            <div style="margin: 10px 0; padding: 10px; background: rgba(50,50,50,100); border-radius: 4px;">
                <label style="color: white; font-weight: bold;">%s</label><br/>
                <input type="number" value="%s" style="width: 200px; padding: 5px; background: rgba(70,70,70,255); border: 1px solid #666; color: white;" 
                       onchange="ConfigGUI.updateSetting('%s', parseFloat(this.value))"/>
                <span style="color: #CCCCCC; margin-left: 10px;">Current: %s</span>
            </div>
        ]], displayName, value, fullPath, value)
    elseif valueType == "string" then
        if key:find("[Cc]olor") or value:match("^#%x%x%x%x%x%x$") or value:match("^rgba?%(") then
            -- Color input
            controlHtml = string.format([[
                <div style="margin: 10px 0; padding: 10px; background: rgba(50,50,50,100); border-radius: 4px;">
                    <label style="color: white; font-weight: bold;">%s</label><br/>
                    <input type="color" value="%s" style="width: 60px; height: 30px; background: none; border: 1px solid #666;" 
                           onchange="ConfigGUI.updateSetting('%s', this.value)"/>
                    <input type="text" value="%s" style="width: 130px; padding: 5px; margin-left: 10px; background: rgba(70,70,70,255); border: 1px solid #666; color: white;" 
                           onchange="ConfigGUI.updateSetting('%s', this.value)"/>
                    <div style="width: 30px; height: 30px; background: %s; border: 1px solid #666; display: inline-block; margin-left: 10px; vertical-align: top;"></div>
                </div>
            ]], displayName, value:match("^#%x%x%x%x%x%x$") and value or "#FFFFFF", fullPath, value, fullPath, value)
        else
            -- Text input
            controlHtml = string.format([[
                <div style="margin: 10px 0; padding: 10px; background: rgba(50,50,50,100); border-radius: 4px;">
                    <label style="color: white; font-weight: bold;">%s</label><br/>
                    <input type="text" value="%s" style="width: 300px; padding: 5px; background: rgba(70,70,70,255); border: 1px solid #666; color: white;" 
                           onchange="ConfigGUI.updateSetting('%s', this.value)"/>
                    <span style="color: #CCCCCC; margin-left: 10px;">Text value</span>
                </div>
            ]], displayName, value, fullPath)
        end
    end
    
    ConfigGUI.content:echo(controlHtml)
end

-- Update a setting value
function ConfigGUI.updateSetting(path, value)
    local success = Config.set(path, value)
    if success then
        ConfigGUI.dirty = true
        cecho(f"<green>Updated {path} = {value}\n")
    else
        cecho(f"<red>Failed to update {path}\n")
    end
end

-- Save configuration
function ConfigGUI.save()
    Config.save()
    ConfigGUI.dirty = false
    cecho("<green>Configuration saved\n")
end

-- Reset current category
function ConfigGUI.resetCategory()
    Config.reset(ConfigGUI.currentCategory)
    ConfigGUI.selectCategory(ConfigGUI.currentCategory) -- Refresh display
    ConfigGUI.dirty = true
    cecho(f"<yellow>Reset {ConfigGUI.currentCategory} category to defaults\n")
end

-- Close the configuration panel
function ConfigGUI.close()
    if ConfigGUI.dirty then
        cecho("<yellow>Warning: You have unsaved changes. Use 'config save' to persist changes.\n")
    end
    
    ConfigGUI.destroy()
end

-- Destroy the panel
function ConfigGUI.destroy()
    if ConfigGUI.panel then
        ConfigGUI.panel:hide()
        ConfigGUI.panel = nil
    end
    
    ConfigGUI.isOpen = false
    ConfigGUI.dirty = false
    
    cecho("<dim_grey>ALUI Configuration Panel closed\n")
end

-- Toggle panel visibility
function ConfigGUI.toggle()
    if ConfigGUI.isOpen then
        ConfigGUI.close()
    else
        ConfigGUI.create()
    end
end

-- Register GUI toggle command
if tempAlias then
    if ALUI.ConfigGUIAlias then
        killAlias(ALUI.ConfigGUIAlias)
    end
    
    ALUI.ConfigGUIAlias = tempAlias("^config gui$", function()
        ConfigGUI.toggle()
    end)
end

return ConfigGUI
