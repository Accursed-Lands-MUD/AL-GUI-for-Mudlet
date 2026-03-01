# Copilot Instructions for AL-GUI Mudlet Plugin

## Project Overview
This is a Lua-based GUI plugin for Mudlet, a cross-platform, open-source MUD client. The plugin creates an advanced user interface with adjustable containers, windows, and interactive elements for enhanced gameplay experience.  All the code that we will be customizing is in the `alui` directory.  This project uses Muddler to build. 

## Technology Stack
- **Language**: Lua 5.1+ (Mudlet's embedded Lua interpreter)
- **Framework**: Mudlet's Geyser GUI framework
- **Platform**: Cross-platform (Windows, macOS, Linux)

## Key Mudlet/Geyser Components

### Window and Container Types
- `Geyser.UserWindow` - Dockable windows with title bars
- `Geyser.Container` - Basic container for organizing UI elements
- `Adjustable.Container` - Resizable containers with user interaction
- `Geyser.VBox` / `Geyser.HBox` - Layout containers for vertical/horizontal organization
- `Geyser.Mapper` - Built-in mapping widget
- `Geyser.MiniConsole` - Text display areas for game output
- `Geyser.Label` - Text labels and clickable areas
- `Geyser.Button` - Interactive buttons

### Common Properties
- Position: `x`, `y` (pixels or percentages as strings)
- Size: `width`, `height` (pixels or percentages as strings)
- Attachment: `attached` ("left", "right", "top", "bottom")
- Docking: `docked` (boolean), `dockPosition` ("left", "right", "top", "bottom")

### Styling
- Use `setStyleSheet()` method with CSS-like syntax
- Support for borders, backgrounds, colors, margins, padding
- Image borders: `border-image: url('path/image.png') slice-widths stretch`

## File Structure Patterns
```
/project-root/
├── alui_core.lua              # Main initialization file
├── alui/
│   └── src/
│       └── scripts/
│           └── GUI/
│               ├── Boxes.lua   # UI container definitions
│               └── ...
└── resources/
    └── UI Assets/             # Images and other assets
```

## Coding Conventions

### Variable Naming
- Use `alui` as the main namespace table
- CamelCase for GUI components: `alui.mapContainer`, `GUI.Box1`
- Use descriptive names: `alui.roomConsole`, `alui.statusWindow`

### Resource Loading
- Use relative paths from script location: `"resources/images/border.png"`
- Load Lua modules with `dofile("path/file.lua")` or `require("module")`
- For require, modify package.path: `package.path = package.path .. ";resources/scripts/?.lua"`

### Common Patterns
```lua
-- Initialize namespace
alui = alui or {}

-- Create container with styling
alui.container = Geyser.Container:new({
    name = "ContainerName",
    x = 0, y = 0,
    width = "25%", height = "100%",
})

alui.container:setStyleSheet([[
    background-color: black;
    border: 2px solid white;
    border-radius: 5px;
]])

-- Add content to container
alui.content = Geyser.MiniConsole:new({
    name = "ContentName",
    x = 0, y = 0,
    width = "100%", height = "100%",
    color = "black",
    autoWrap = true,
}, alui.container)
```

### Event Handling
```lua
-- Button click callbacks
button:setClickCallback(function()
    -- Handle click event
end)

-- Menu systems using labels
function showPopupMenu()
    local menu = Geyser.Container:new({...})
    -- Create menu items as labels with click callbacks
end
```

## Best Practices

1. **Error Handling**: Always check if objects exist before using them
2. **Resource Management**: Use relative paths for portability
3. **Modularity**: Separate UI components into different files
4. **Consistency**: Use consistent naming and styling patterns
5. **Performance**: Avoid creating UI elements repeatedly; reuse when possible

## Common Issues and Solutions

1. **Main Display Offset**: Check for docked windows affecting layout
2. **Resource Loading**: Ensure file paths are correct and accessible
3. **Styling Issues**: Verify CSS syntax and property support
4. **Window Management**: Use appropriate container types for intended behavior

## Mudlet-Specific Notes

- Percentages must be strings: `"25%"` not `25%`
- Colors can be named ("black", "white") or hex values
- Mapper requires proper room/area data to function
- UserWindows can be docked to main window edges
- Use `tostring()` to convert numbers to strings when needed

## References
- [Mudlet Wiki](https://wiki.mudlet.org)
- [Muddler Wiki](https://github.com/demonnic/muddler/wiki)