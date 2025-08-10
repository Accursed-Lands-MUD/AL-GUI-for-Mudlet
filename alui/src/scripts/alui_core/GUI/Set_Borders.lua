-- Set_Borders.lua - Migrated to ALUI namespace structure
-- Implements border management with new namespace while maintaining backward compatibility

-- Use ALUI namespace if available, with GUI fallback for compatibility
local GUI_NS = (ALUI and ALUI.GUI) or GUI or {}
local Config = (ALUI and ALUI.Config) or {}

-- Core border setting function
local function setBorders()
    local w, h = getMainWindowSize()

    -- Use configuration values if available, otherwise defaults
    local sideBorderPercent = 0.25
    local topBorderPercent = 1/20  -- h/20 = h * (1/20)
    
    if Config.get then
        sideBorderPercent = Config.get("ui.sideBorderPercent", 25) / 100  -- Convert percentage to decimal
        topBorderPercent = Config.get("ui.topBorderPercent", 5) / 100
    end

    local sideBorder = w * sideBorderPercent
    local topBorder = h * topBorderPercent

    setBorderLeft(sideBorder)
    setBorderTop(topBorder)
    setBorderBottom(0)
    setBorderRight(sideBorder)
end

-- Register function in both namespaces for compatibility
GUI_NS.setBorders = setBorders

-- Also register in legacy GUI namespace for backward compatibility
if GUI then
    GUI.setBorders = setBorders
end

-- Register in new ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.setBorders = setBorders
end

-- Mark this file as migrated to ALUI namespace
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("Set_Borders.lua")
end
