-- Header_Icons.lua - Migrated to ALUI namespace structure
-- Handles status icon management with new namespace while maintaining backward compatibility

local Package_Root = getMudletHomeDir()

-- Use ALUI namespace if available, with fallbacks for compatibility
local GUI_NS = (ALUI and ALUI.GUI) or GUI or {}
local Config = (ALUI and ALUI.Config) or {}
local Colors = (ALUI and ALUI.GUI and ALUI.GUI.Colors) or GUI.Colors or {}
local RM = ALUI and ALUI.ResourceManager

-- Get colors with configuration support
local function getColor(configPath, fallbackColor)
    if Config.get then
        return Config.get(configPath, fallbackColor)
    end
    return fallbackColor
end

local blue = getColor("colors.primary.blue", Colors.blue or '#2A768C')
local red = getColor("colors.primary.red", Colors.red or '#830000')

GUI.Header = Geyser.HBox:new({
    name = "GUI.Header",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
}, GUI.Top)

-- Initialize Menu namespace
GUI.Menu = GUI.Menu or {}

-- Register Header with ResourceManager
if RM then
    RM.registerUIElement("mainHeader", GUI.Header, "header")
end

-- Use configuration for styling if available
local neutralBg = getColor("colors.status.neutral", "rgba(0,0,0,100)")

-- Create individual CSS objects for each menu item to prevent shared state issues
local function createInfoCSS()
    local css = CSSMan.new(string.format([[
      background-color: %s;
      border-style: solid;
      border-width: 1px;
      border-color: white;
      border-radius: 5px;
      margin: 5px;
      qproperty-wordWrap: true;
      background-position: center;
      background-repeat: no-repeat;
      background-size: auto 50%%;
    ]], neutralBg))

    -- Register CSS with ResourceManager
    if RM then
        RM.registerCSS("headerInfoCSS", css, "header")
    end

    return css
end

local function createActionCSS()
    local css = CSSMan.new(string.format([[
      background-color: %s;
      border-style: solid;
      border-width: 1px;
      border-color: white;
      margin: 5px;
      qproperty-wordWrap: true;
      background-position: center;
      background-repeat: no-repeat;
      background-size: auto 50%%;
    ]], neutralBg))

    -- Register CSS with ResourceManager
    if RM then
        RM.registerCSS("headerActionCSS", css, "header")
    end

    return css
end

-- Legacy CSS objects for backward compatibility
GUI.InfoCSS = createInfoCSS()
GUI.ActionCSS = createActionCSS()

-- Core menu item creation function with ResourceManager integration
local function createMenuItem(name, updateFunction, parent)
    local item = Geyser.Label:new({
        name = 'GUI.Menu.' .. name,
    }, parent)

    item.update = updateFunction
    item:update()

    -- Register with ResourceManager
    if RM then
        RM.registerUIElement("menuItem_" .. name, item, "header")
    end

    -- setLabelToolTip(item.name, name)

    return item
end

local function createMenuButton(name, gameCommand, parent)
    local button = Geyser.Button:new({
        name = "GUI.Menu" .. name,
        width = '100%',
        tooltip = 'Toggle ' .. name,

        style = [[
    margin: 5px;
    boarder-radius:5px;
    border: 1px solid white;
    ]],

    }, parent)

    -- Register with ResourceManager
    if RM then
        RM.registerUIElement("menuButton_" .. name, button, "header")
    end

    return button
end

GUI.Menu.Hunger = createMenuItem("Hunger", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_hunger.png)"
        local label = nil
        -- Check ALUI namespace for hunger status
        local backgroundColor = nil
        if ALUI and ALUI.Status and ALUI.Status.vitals.hunger then
            backgroundColor = ALUI.Status.vitals.hunger
        end

        -- Create individual CSS object for this item
        local hungerCSS = createInfoCSS()

        if iconPath then
            hungerCSS:set("background-image", iconPath)
        else
            hungerCSS:set("background-image", "none")
            if label then
                self:echo("<center>" .. label)
            end
        end
        if backgroundColor then
            hungerCSS:set("background-color", backgroundColor)
        else
            hungerCSS:set("background-color", "rgba(0,0,0,100)")
        end

        self:setStyleSheet(hungerCSS:getCSS())
    end,
    GUI.Header)

GUI.Menu.Thirst = createMenuItem("Thirst", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_thirst01.png)"
        -- Check ALUI namespace for thirst status
        local backgroundColor = nil
        if ALUI and ALUI.Status and ALUI.Status.vitals.thirst then
            backgroundColor = ALUI.Status.vitals.thirst
        end

        -- Create individual CSS object for this item
        local thirstCSS = createInfoCSS()

        thirstCSS:set("background-image", iconPath)

        if backgroundColor then
            thirstCSS:set("background-color", backgroundColor)
        else
            thirstCSS:set("background-color", "rgba(0,0,0,100)")
        end

        self:setStyleSheet(thirstCSS:getCSS())
    end,
    GUI.Header)

GUI.Menu.Fatigue = createMenuItem("Fatigue", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_fatigue01.png)"
        -- Check ALUI namespace for fatigue status
        local backgroundColor = nil
        if ALUI and ALUI.Status and ALUI.Status.vitals.fatigue then
            backgroundColor = ALUI.Status.vitals.fatigue
        end

        -- Create individual CSS object for this item
        local fatigueCSS = createInfoCSS()

        fatigueCSS:set("background-image", iconPath)

        if backgroundColor then
            fatigueCSS:set("background-color", backgroundColor)
        else
            fatigueCSS:set("background-color", "rgba(0,0,0,100)")
        end

        self:setStyleSheet(fatigueCSS:getCSS())
    end,
    GUI.Header)

GUI.Menu.Posture = createMenuItem("Posture", function(self)
        -- Check both ALUI namespace and legacy namespace for posture
        local label = nil
        if ALUI and ALUI.Status and ALUI.Status.posture then
            label = ALUI.Status.posture
        end

        -- Fallback: Try to get data directly from GMCP if not in status
        if not label and gmcp and gmcp.Char and gmcp.Char.Status and gmcp.Char.Status.Posture then
            label = gmcp.Char.Status.Posture
            -- Update both status tables for next time
            if ALUI and ALUI.Status then
                ALUI.Status.posture = label
            end
        end

        -- Create individual CSS object for this item
        local postureCSS = createInfoCSS()

        postureCSS:set("background-image", "none")
        postureCSS:set("background-color", "rgba(0,0,0,100)")

        if label and label ~= "" then
            self:clear()
            self:echo("<center>" .. tostring(label))
        else
            self:clear()
            self:echo("<center>Unknown")
        end

        self:setStyleSheet(postureCSS:getCSS())
    end,
    GUI.Header)

GUI.Menu.Mercy = createMenuItem("Mercy", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_mercy01.png)"

        -- Check both ALUI namespace and legacy namespace for mercy
        local showMercy = nil
        if ALUI and ALUI.Status and ALUI.Status.mercy ~= nil then
            showMercy = ALUI.Status.mercy
        elseif alui and alui.status and alui.status.mercy ~= nil then
            showMercy = alui.status.mercy
        end

        GUI.ActionCSS:set("background-image", iconPath)


        -- self:echo("<center> Mercy")

        if showMercy then
            GUI.ActionCSS:set("background-color", blue)
        else
            GUI.ActionCSS:set("background-color", red)
        end

        self:setStyleSheet(GUI.ActionCSS:getCSS())
    end,


    GUI.Header)

GUI.Menu.Mercy:setClickCallback(function()
    local gameCommand = "mercy on"
    local toolTip = "Turn Mercy Off"

    -- Check both namespaces for mercy status
    local currentMercy = nil
    if ALUI and ALUI.Status and ALUI.Status.mercy ~= nil then
        currentMercy = ALUI.Status.mercy
    elseif alui and alui.status and alui.status.mercy ~= nil then
        currentMercy = alui.status.mercy
    end

    if currentMercy then
        gameCommand = "mercy off"
        toolTip = "Turn Mercy On"
    end

    send(gameCommand, false)
    setLabelToolTip("GUI.Menu.Mercy", toolTip)
end)

GUI.Menu.Travel = createMenuItem("Travel", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_travel01.png)"

        -- Check both ALUI namespace and legacy namespace for travel
        local autoTravel = nil
        if ALUI and ALUI.Status and ALUI.Status.travel ~= nil then
            autoTravel = ALUI.Status.travel
        elseif alui and alui.status and alui.status.travel ~= nil then
            autoTravel = alui.status.travel
        end

        GUI.ActionCSS:set("background-image", iconPath)
        -- self:echo("<center>Travel")

        if autoTravel then
            GUI.ActionCSS:set("background-color", blue)
        else
            GUI.ActionCSS:set("background-color", red)
        end

        self:setStyleSheet(GUI.ActionCSS:getCSS())
    end,
    GUI.Header)

GUI.Menu.Travel:setClickCallback(function()
    local gameCommand = "travel on"
    local toolTip = "Turn Travel Off"

    -- Check both namespaces for travel status
    local currentTravel = nil
    if ALUI and ALUI.Status and ALUI.Status.travel ~= nil then
        currentTravel = ALUI.Status.travel
    elseif alui and alui.status and alui.status.travel ~= nil then
        currentTravel = alui.status.travel
    end

    if currentTravel then
        gameCommand = "travel off"
        toolTip = "Turn Travel On"
    end

    send(gameCommand, false)
    setLabelToolTip("GUI.Menu.Travel", toolTip)
end)

GUI.Menu.CommonSense = createMenuItem("CommonSense", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_commonsense.png)"

        -- Check both ALUI namespace and legacy namespace for commonsense
        local useCommonSense = nil
        if ALUI and ALUI.Status and ALUI.Status.commonsense ~= nil then
            useCommonSense = ALUI.Status.commonsense
        elseif alui and alui.status and alui.status.commonsense ~= nil then
            useCommonSense = alui.status.commonsense
        end

        GUI.ActionCSS:set("background-image", iconPath)
        -- self:echo("<center>CommonSense")

        if useCommonSense then
            GUI.ActionCSS:set("background-color", blue)
        else
            GUI.ActionCSS:set("background-color", red)
        end
        self:setStyleSheet(GUI.ActionCSS:getCSS())
    end,
    GUI.Header)

GUI.Menu.CommonSense:setClickCallback(function()
    local gameCommand = "commonsense on"
    local toolTip = "Turn Commonsense Off"

    -- Check both namespaces for commonsense status
    local currentCommonSense = nil
    if ALUI and ALUI.Status and ALUI.Status.commonsense ~= nil then
        currentCommonSense = ALUI.Status.commonsense
    elseif alui and alui.status and alui.status.commonsense ~= nil then
        currentCommonSense = alui.status.commonsense
    end

    if currentCommonSense then
        gameCommand = "commonsense off"
        toolTip = "Turn Commonsense On"
    end

    send(gameCommand, false)
    setLabelToolTip("GUI.Menu.CommonSense", toolTip)
end)

GUI.Menu.Help = createMenuItem("Help", function(self)
        local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/help_2.png)"

        GUI.ActionCSS:set("background-image", iconPath)

        GUI.ActionCSS:set("background-color", neutralBg)

        self:setStyleSheet(GUI.ActionCSS:getCSS())
    end,
    GUI.Header)

setLabelToolTip("GUI.Menu.Help", 'Help')

GUI.Menu.Help:setClickCallback(function()
    openUrl("https://github.com/BrettMN/AL-GUI-for-Mudlet/wiki")
end)

-- Register components in ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Components = ALUI.GUI.Components or {}
    ALUI.GUI.Components.Header = GUI.Header
    ALUI.GUI.Components.Menu = GUI.Menu

    ALUI.GUI.Styles = ALUI.GUI.Styles or {}
    ALUI.GUI.Styles.InfoCSS = GUI.InfoCSS
    ALUI.GUI.Styles.ActionCSS = GUI.ActionCSS

    -- Store menu items
    if GUI.Menu then
        ALUI.GUI.Components.MenuItems = {
            Hunger = GUI.Menu.Hunger,
            Thirst = GUI.Menu.Thirst,
            Fatigue = GUI.Menu.Fatigue,
            Posture = GUI.Menu.Posture,
            Mercy = GUI.Menu.Mercy,
            Travel = GUI.Menu.Travel,
            CommonSense = GUI.Menu.CommonSense,
            Help = GUI.Menu.Help
        }
    end
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("Header_Icons.lua")
end
