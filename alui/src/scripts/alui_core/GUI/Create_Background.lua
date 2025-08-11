-- Create_Background.lua - Migrated to ALUI namespace structure
-- Handles background UI creation with new namespace while maintaining backward compatibility

-- Use ALUI namespace if available, with fallbacks for compatibility
local GUI_NS = (ALUI and ALUI.GUI) or GUI or {}
local Config = (ALUI and ALUI.Config) or {}

-- Get configuration values with fallbacks
local sideBorderPercent = 25
local topBorderPercent = 5
local containerConfig = {}

if Config.get then
    sideBorderPercent = Config.get("ui.sideBorderPercent", 25)
    topBorderPercent = Config.get("ui.topBorderPercent", 5)
    containerConfig = Config.get("ui.containers", {})
end

-- Set default container config values
containerConfig.leftWidth = containerConfig.leftWidth or (sideBorderPercent .. "%")
containerConfig.rightWidth = containerConfig.rightWidth or (sideBorderPercent .. "%")
containerConfig.centerWidth = containerConfig.centerWidth or "50%"
containerConfig.topHeight = containerConfig.topHeight or (topBorderPercent .. "%")
containerConfig.fullHeight = containerConfig.fullHeight or "100%"

GUI.BackgroundCSS = CSSMan.new([[
  background-color: #353535;
]])

GUI.Left = Geyser.Label:new({
    name = "GUI.Left",
    x = 0,
    y = 0,
    width = containerConfig.leftWidth,
    height = containerConfig.fullHeight,
})
GUI.Left:setStyleSheet(GUI.BackgroundCSS:getCSS())

GUI.Right = Geyser.Label:new({
    name = "GUI.Right",
    x = "-" .. containerConfig.rightWidth,
    y = 0,
    width = containerConfig.rightWidth,
    height = containerConfig.fullHeight,
    backgroundImages = "url('/banner.webp')",
})
GUI.Right:setStyleSheet(GUI.BackgroundCSS:getCSS())

GUI.Top = Geyser.Label:new({
    name = "GUI.Top",
    x = containerConfig.leftWidth,
    y = 0,
    width = containerConfig.centerWidth,
    height = containerConfig.topHeight,
})
GUI.Top:setStyleSheet(GUI.BackgroundCSS:getCSS())

-- Core background setup function
local function setBackground()
    -- Use configuration values for dynamic sizing
    local sideBorder = sideBorderPercent .. "%"
    local topBorder = topBorderPercent .. "%"

    GUI.Left.height = containerConfig.fullHeight
    GUI.Left.width = sideBorder

    GUI.Right.height = containerConfig.fullHeight
    GUI.Right.width = sideBorder

    GUI.Top.height = topBorder
    GUI.Top.width = containerConfig.centerWidth

    GUI.Left:show()
    GUI.Right:show()
    GUI.Top:show()
    -- GUI.Bottom:show()

    local width, _ = getMainWindowSize()
    local fontSize = getFontSize()
    local fontWidth, _ = calcFontSize(fontSize)
    local lineWidth = width / fontWidth
    local lineWidthAdjusted = (lineWidth / 2) - (fontWidth / 4)

    setWindowWrap("main", lineWidthAdjusted)
end

-- Register function in both old and new namespaces for compatibility
GUI.setBackground = setBackground

-- Register in new ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.setBackground = setBackground
    ALUI.GUI.Components = ALUI.GUI.Components or {}
    ALUI.GUI.Components.background = setBackground

    -- Store UI components in ALUI namespace
    ALUI.GUI.Components.Left = GUI.Left
    ALUI.GUI.Components.Right = GUI.Right
    ALUI.GUI.Components.Top = GUI.Top
    ALUI.GUI.Styles = ALUI.GUI.Styles or {}
    ALUI.GUI.Styles.BackgroundCSS = GUI.BackgroundCSS
end

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("Create_Background.lua")
end
