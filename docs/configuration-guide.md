# ALUI Configuration System Usage Guide

## Overview

The ALUI Configuration System provides centralized management of all configurable values in the AL-GUI for Mudlet. This implements **Suggestion #11** by consolidating scattered hardcoded values into a single, validated, and persistent configuration system.

## Quick Start

```lua
-- Get a configuration value
local delay = ALUI.Config.get("mapping.speedwalkDelay", 0)

-- Set a configuration value (with validation)
ALUI.Config.set("ui.guiPadding", 15)

-- Reset a category to defaults
ALUI.Config.reset("colors")

-- Save current configuration
ALUI.Config.save()
```

## Configuration Categories

### UI Layout (`ui`)
Controls interface dimensions, spacing, and timing:

```lua
-- Border percentages
ALUI.Config.get("ui.sideBorderPercent")     -- 25% (left/right borders)
ALUI.Config.get("ui.topBorderPercent")      -- 5% (top border)

-- Spacing and dimensions
ALUI.Config.get("ui.guiPadding")            -- 10px (general padding)
ALUI.Config.get("ui.buttonWidth")           -- 100px (button width)

-- Timing
ALUI.Config.get("ui.resizeTimerDelay")      -- 0.1s (resize debounce)

-- Container dimensions (CSS percentages)
ALUI.Config.get("ui.containers.leftWidth")    -- "25%"
ALUI.Config.get("ui.containers.rightWidth")   -- "25%"
ALUI.Config.get("ui.containers.centerWidth")  -- "50%"
```

### Colors (`colors`)
Centralized color management:

```lua
-- Primary theme colors
ALUI.Config.get("colors.primary.blue")      -- "#2A768C"
ALUI.Config.get("colors.primary.green")     -- "#2EA652"
ALUI.Config.get("colors.primary.red")       -- "#830000"

-- Status colors
ALUI.Config.get("colors.status.aggressive") -- "#830000"
ALUI.Config.get("colors.status.defensive")  -- "#2A768C"
ALUI.Config.get("colors.status.neutral")    -- "rgba(0,0,0,100)"

-- Vitals colors (indexed by severity level)
ALUI.Config.get("colors.vitals.thirst.1")   -- "#2EA652" (good)
ALUI.Config.get("colors.vitals.thirst.4")   -- "#830000" (critical)
```

### Mapping (`mapping`)
Game mapping and navigation settings:

```lua
-- Speedwalk configuration
ALUI.Config.get("mapping.speedwalkDelay")   -- 0 (delay between steps)
ALUI.Config.get("mapping.speedwalkWait")    -- false (wait for movement)

-- Map display options
ALUI.Config.get("mapping.autoMapping")      -- true
ALUI.Config.get("mapping.pathHighlight")    -- true
ALUI.Config.get("mapping.roomInfoDisplay")  -- true
```

### Chat (`chat`)
Communication and channel settings:

```lua
-- Channel capture settings
ALUI.Config.get("chat.captureOOC")          -- true
ALUI.Config.get("chat.captureGossip")       -- true
ALUI.Config.get("chat.captureNewbie")       -- true

-- Display options
ALUI.Config.get("chat.timestampFormat")     -- "[%H:%M:%S]"
ALUI.Config.get("chat.maxChatLines")        -- 1000
ALUI.Config.get("chat.wordWrap")            -- true
```

### Performance (`performance`)
System behavior and optimization:

```lua
-- Update intervals
ALUI.Config.get("performance.updateInterval")    -- 100ms
ALUI.Config.get("performance.cleanupInterval")   -- 300s (5 minutes)

-- Resource limits
ALUI.Config.get("performance.maxLogSize")        -- 10MB
ALUI.Config.get("performance.cacheSize")         -- 1000 entries

-- Debug options
ALUI.Config.get("performance.enableDebugMode")   -- false
```

### Features (`features`)
Feature toggles for functionality:

```lua
-- UI components
ALUI.Config.get("features.enableVitalsDisplay")  -- true
ALUI.Config.get("features.enableStatusIcons")    -- true
ALUI.Config.get("features.enableTooltips")       -- true

-- System features
ALUI.Config.get("features.enableMapIntegration") -- true
ALUI.Config.get("features.enableChatCapture")    -- true
ALUI.Config.get("features.enableSounds")         -- false
```

## Advanced Usage

### Validation
All configuration values are validated when set:

```lua
-- Valid: within range 0-50
ALUI.Config.set("ui.sideBorderPercent", 30)  -- ✅ Success

-- Invalid: out of range
ALUI.Config.set("ui.sideBorderPercent", 80)  -- ❌ Validation error

-- Color validation
ALUI.Config.set("colors.primary.custom", "#FF5733")  -- ✅ Valid hex
ALUI.Config.set("colors.primary.custom", "invalid")  -- ❌ Invalid color
```

### Hot-Reloading
Register handlers for configuration changes:

```lua
-- React to specific config changes
ALUI.Config.onChange("ui.guiPadding", function(newValue, path)
    print(f"Padding changed to: {newValue}")
    -- Update UI elements with new padding
    GUI.updatePadding(newValue)
end)

-- React to category changes
ALUI.Config.onChange("colors", function(newValue, path)
    print(f"Color changed: {path} = {newValue}")
    -- Refresh all color-dependent UI elements
    GUI.refreshColors()
end)

-- Global change handler
registerAnonymousEventHandler("aluiConfigChanged", function(_, path, value)
    print(f"Configuration changed: {path} = {value}")
end)
```

### Persistence
Configuration is automatically saved to `alui_config.json`:

```lua
-- Manual save (auto-save is debounced)
ALUI.Config.save()

-- Export configuration for sharing
local jsonString = ALUI.Config.export()

-- Import configuration from JSON
ALUI.Config.import(jsonString)

-- Reset to defaults
ALUI.Config.reset()           -- Reset all
ALUI.Config.reset("colors")   -- Reset specific category
```

### Schema Information
Get metadata about configuration structure:

```lua
local schema = ALUI.Config.getSchema()
-- Returns information about categories, types, defaults, and validators
```

## Integration Examples

### Updating Existing Code
Replace hardcoded values with configuration calls:

```lua
-- Before
local delay = 0.1
local padding = 10

-- After  
local delay = ALUI.Config.get("ui.resizeTimerDelay", 0.1)
local padding = ALUI.Config.get("ui.guiPadding", 10)
```

### CSS Generation with Configuration
Use configuration values in CSS generation:

```lua
local function createButtonCSS()
    local config = ALUI.Config
    local buttonWidth = config.get("ui.buttonWidth", 100)
    local primaryColor = config.get("colors.primary.blue", "#2A768C")
    local padding = config.get("ui.guiPadding", 10)
    
    return CSSMan.new(string.format([[
        width: %dpx;
        background-color: %s;
        margin: %dpx;
    ]], buttonWidth, primaryColor, padding))
end
```

### Conditional Features
Use feature toggles to control functionality:

```lua
local function updateVitals(data)
    if not ALUI.Config.get("features.enableVitalsDisplay", true) then
        return -- Vitals display disabled
    end
    
    -- Update vitals UI
    local thirstColor = ALUI.Config.get("colors.vitals.thirst." .. data.thirstLevel)
    GUI.updateThirstGauge(data.thirst, thirstColor)
end
```

## Error Handling

The configuration system includes comprehensive error handling:

- **Validation Errors**: Invalid values are rejected and logged
- **File I/O Errors**: Graceful degradation with backup creation
- **Missing Values**: Default values are returned for undefined paths
- **Type Safety**: Validators ensure correct data types

## Migration from Hardcoded Values

### Identified Values to Migrate

1. **Timer Delays**
   - `RESIZE_TIMER_DELAY = 0.1`
   - `map.configs.speedwalk_delay = 0`

2. **Layout Dimensions**
   - `width = "25%"`, `height = "100%"`
   - `Gui_Padding`, `Style_Button_Width`

3. **Colors**
   - `#2A768C`, `#2EA652`, `#830000`
   - `rgba(0,0,0,100)`, `rgba(0,0,0,0)`

4. **Performance Settings**
   - Update intervals, cache sizes
   - Debug flags, logging levels

### Migration Strategy

1. **Identify**: Use grep to find hardcoded values
2. **Categorize**: Group related values into logical categories
3. **Define**: Add to configuration defaults with validation
4. **Replace**: Update code to use `ALUI.Config.get()`
5. **Test**: Verify functionality with new configuration system
6. **Document**: Update this guide with new configuration options

## Files Modified for Configuration Integration

- ✅ `Config.lua` - Main configuration system
- ✅ `Boxes.lua` - Updated to use padding and color configuration
- ✅ `Create_Background.lua` - Updated to use layout configuration
- 🔄 `vitals_update.lua` - Uses color configuration (previously migrated)
- 🔄 `alui_core.lua` - Uses timer and color configuration (previously migrated)

## Next Steps

1. **Complete Migration**: Update remaining files to use configuration system
2. **User Interface**: Create in-game configuration panel
3. **Import/Export**: Add preset configuration sharing
4. **Documentation**: Complete configuration reference guide
5. **Testing**: Validate all configuration combinations

The configuration system provides a solid foundation for maintainable, user-customizable settings while ensuring data integrity through validation and proper error handling.
