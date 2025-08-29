-- Handles UI box creation and management with new namespace while maintaining backward compatibility

local EMCO = require("alui.emco")

-- Use ALUI namespace if available, with fallbacks for compatibility
local GUI = (ALUI and ALUI.GUI) or {}
local Config = (ALUI and ALUI.Config) or {}
local Colors = (ALUI and ALUI.GUI and GUI.Colors) or {}
local RM = ALUI and ALUI.ResourceManager

-- Core box setup function with ResourceManager integration
local function setBoxes()
    -- Clean up existing box resources first
    if RM then
        RM.cleanupByCategory("boxes")
        RM.cleanupByCategory("gauges")
    end

    -- Use configuration values for styling with fallbacks
    local guiPadding = 10
    local borderRadius = 10
    local transparentBg = "rgba(0,0,0,0)"

    if Config.get then
        guiPadding = Config.get("ui.guiPadding", 10)
        borderRadius = Config.get("ui.borderRadius", 10)
        transparentBg = Config.get("colors.status.transparent", "rgba(0,0,0,0)")
    end

    GUI.BoxCSS = CSSMan.new(string.format([[
  background-color: black;
  border-style: solid;
  border-width: 1px;
  border-radius: %dpx;
  border-color: white;
  margin: %dpx;
]], borderRadius, guiPadding))

    GUI.GaugeBackCSS = CSSMan.new(string.format([[
  background-color: %s;
  margin-top: 5px;
  margin-bottom: 5px;
  border-style: solid;
  border-color: white;
]], transparentBg))

    GUI.GaugeFrontCSS = CSSMan.new([[
  background-color: rgba(0,0,0,0);
  margin-top: 5px;
  margin-bottom: 5px;
  border-style: solid;
  border-color: white;
]])

    -- Register CSS objects with ResourceManager
    if RM then
        RM.registerCSS("boxCSS", GUI.BoxCSS, "boxes")
        RM.registerCSS("gaugeBackCSS", GUI.GaugeBackCSS, "gauges")
        RM.registerCSS("gaugeFrontCSS", GUI.GaugeFrontCSS, "gauges")
    end

    -- Configuration-driven styling values
    local Style_Button_Width = '10%'
    local Style_Gauge_Width = "40%"
    local Package_Root = getMudletHomeDir()
    local Gui_Padding = guiPadding -- Use configured padding

    -- Use configured colors with fallbacks
    local aggressiveColor = Colors.red or '#830000'
    local defensiveColor = Colors.blue or '#2A768C'

    if Config.get then
        aggressiveColor = Config.get("colors.status.aggressive", aggressiveColor)
        defensiveColor = Config.get("colors.status.defensive", defensiveColor)
    end

    -- Function to create a new box with ResourceManager tracking
    local function createBox(name, x, y, width, height, parent)
        local box = Geyser.Label:new({
            name = name,
            x = x,
            y = y,
            width = width,
            height = height,
        }, parent)
        box:setStyleSheet(GUI.BoxCSS:getCSS())

        -- Register with ResourceManager
        if RM then
            RM.registerUIElement(name, box, "boxes")
        end

        return box
    end

    local function createContainer(name, parent)
        local container = Geyser.Container:new({
            name = name,
            x = 0,
            y = 0,
            width = "100%",
            height = "100%",
        }, parent)

        -- Register with ResourceManager
        if RM then
            RM.registerUIElement(name, container, "boxes")
        end

        return container
    end

    local function createStyleHbox(name, parent)
        local Style_HBox_Height = "20%"
        local hbox = Geyser.HBox:new({
            name = name,
            width = "100%",
            height = Style_HBox_Height,
        }, parent)
        return hbox
    end

    local function createStyleButton(name, parent, color)
        local button = Geyser.Button:new({
            name = "GUI.Style_" .. name .. "_Increase",
            width = Style_Button_Width,
            tooltip = 'Increase ' .. name .. ' Some',

            style = [[ margin: 8px; boarder-radius:5px; background-color: ]] .. color .. [[; border: 1px solid white; ]],

        }, parent)
        button:echo("<center>" .. name)

        button:setClickCallback(function()
            send('increase ' .. string.lower(name) .. ' some', false)
        end)

        -- Register with ResourceManager
        if RM then
            RM.registerUIElement("styleButton_" .. name, button, "buttons")
        end

        return button
    end

    local function createStyleGauge(name, parent, leftColor, rightColor, value)
        local gauge = Geyser.Gauge:new({
            name = "GUI.Style_Gauge_" .. name,
            width = Style_Gauge_Width,
        }, parent)

        if not value then
            value = 5
        end

        gauge:setValue(value, 10)
        GUI.GaugeFrontCSS:set("background-color", leftColor)
        GUI.GaugeBackCSS:set("background-color", rightColor)

        gauge.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
        gauge.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())

        -- Register with ResourceManager
        if RM then
            RM.registerUIElement("styleGauge_" .. name, gauge, "gauges")
        end

        return gauge
    end



    -- Create boxes using the reusable function
    GUI.Box1 = createBox("GUI.Box1", 0, 0, "100%", "20%", GUI.Right)
    GUI.Box2 = createBox("GUI.Box2", 0, "20%", "100%", "40%", GUI.Right)
    GUI.Box3 = createBox("GUI.Box3", 0, "60%", "100%", "40%", GUI.Right)
    GUI.Box4 = createBox("GUI.Box4", 0, 0, "100%", "50%", GUI.Left)
    GUI.Box5 = createBox("GUI.Box5", 0, "50%", "100%", "30%", GUI.Left)
    GUI.Box7 = createBox("GUI.Box7", 0, "80%", "100%", "20%", GUI.Left)

    GUI.Map_Container = createContainer("GUI.Map_Container", GUI.Box4)

    GUI.Mapper = Geyser.Mapper:new({
        name = "GUI.Mapper",
        x = Gui_Padding * 2,
        y = Gui_Padding * 2,
        width = GUI.Map_Container:get_width() - (Gui_Padding * 4),
        height = GUI.Map_Container:get_height() - (Gui_Padding * 4),
    }, GUI.Map_Container)

    -- Register Mapper with ResourceManager
    if RM then
        RM.registerUIElement("mapper", GUI.Mapper, "mapping")
    end

    GUI.Room_Container = createContainer("GUI.Room_Container", GUI.Box5)

    GUI.Components = GUI.Components or {}
    GUI.Components.roommini = Geyser.MiniConsole:new({
        name = "ALUI room miniconsole",
        x = Gui_Padding * 2,
        y = Gui_Padding * 2,
        width = GUI.Room_Container:get_width() - (Gui_Padding * 4),
        height = GUI.Room_Container:get_height() - (Gui_Padding * 4),
        color = "black",
        autoWrap = true,
    }, GUI.Room_Container)

    -- Register room mini console with ResourceManager
    if RM then
        RM.registerUIElement("roomMini", GUI.Components.roommini, "interface")
    end

    GUI.Status_Container = createContainer("GUI.Status_Container", GUI.Box7)

    GUI.Components.combatmini = Geyser.MiniConsole:new({
        name = "ALUI combat console",
        x = Gui_Padding * 2,
        y = Gui_Padding * 2,
        height = GUI.Status_Container:get_height() - (Gui_Padding * 4),
        width = GUI.Status_Container:get_width() - (Gui_Padding * 4),
        color = "black",
        autoWrap = true,
    }, GUI.Status_Container)

    -- Register combat mini console with ResourceManager
    if RM then
        RM.registerUIElement("combatMini", GUI.Components.combatmini, "interface")
    end

    GUI.Style_Container = createContainer("GUI.Style_Container", GUI.Box1)

    GUI.Style_VBox = Geyser.VBox:new({
        name = "alui style vbox",
        x = Gui_Padding,
        y = Gui_Padding,
        width = GUI.Style_Container:get_width() - (Gui_Padding * 1),
        height = GUI.Style_Container:get_height() - (Gui_Padding * 1),
    }, GUI.Style_Container)

    -- Register Style VBox with ResourceManager
    if RM then
        RM.registerUIElement("styleVBox", GUI.Style_VBox, "interface")
    end

    GUI.Style_HBox_Aim_Control = createStyleHbox("GUI.Style_HBox_Aim_Control", GUI.Style_VBox)
    GUI.Style_HBox_Offensive_Dodge = createStyleHbox("GUI.Style_HBox_Offensive_Dodge", GUI.Style_VBox)
    GUI.Style_HBox_Darring_Parry = createStyleHbox("GUI.Style_HBox_Darring_Parry", GUI.Style_VBox)
    GUI.Style_HBox_Power_Speed = createStyleHbox("GUI.Style_HBox_Power_Speed", GUI.Style_VBox)
    GUI.Style_HBox_Attack_Defense = createStyleHbox("GUI.Style_HBox_Attack_Defense", GUI.Style_VBox)

    GUI.Style_Aim_Increase = createStyleButton("Aim", GUI.Style_HBox_Aim_Control, aggressiveColor)



    local styleData = (ALUI and ALUI.Style) or {}


    GUI.Style_Gauge_Aim_Control = createStyleGauge("GUI.Style_Gauge_Aim_Control", GUI.Style_HBox_Aim_Control,
        defensiveColor, aggressiveColor, styleData.control)
    GUI.Style_Control_Increase = createStyleButton("Control", GUI.Style_HBox_Aim_Control, defensiveColor)

    GUI.Style_Offensive_Increase = createStyleButton("Offensive", GUI.Style_HBox_Offensive_Dodge, aggressiveColor)
    GUI.Style_Gauge_Offensive_Dodge = createStyleGauge("Offensive_Dodge", GUI.Style_HBox_Offensive_Dodge, defensiveColor,
        aggressiveColor, styleData.dodge)
    GUI.Style_Dodge_Increase = createStyleButton("Dodge", GUI.Style_HBox_Offensive_Dodge, defensiveColor)

    GUI.Style_Daring_Increase = createStyleButton("Daring", GUI.Style_HBox_Darring_Parry, aggressiveColor)
    GUI.Style_Gauge_Daring_Parry = createStyleGauge("Daring_Parry", GUI.Style_HBox_Darring_Parry, defensiveColor,
        aggressiveColor, styleData.parry)
    GUI.Style_Parry_Increase = createStyleButton("Parry", GUI.Style_HBox_Darring_Parry, defensiveColor)

    GUI.Style_Power_Increase = createStyleButton("Power", GUI.Style_HBox_Power_Speed, aggressiveColor)
    GUI.Style_Gauge_Power_Speed = createStyleGauge("Power_Speed", GUI.Style_HBox_Power_Speed, defensiveColor,
        aggressiveColor, styleData.speed)
    GUI.Style_Speed_Increase = createStyleButton("Speed", GUI.Style_HBox_Power_Speed, defensiveColor)

    GUI.Style_Attack_Increase = createStyleButton("Attack", GUI.Style_HBox_Attack_Defense, aggressiveColor)
    GUI.Style_Gauge_Attack_Defense = createStyleGauge("Attack_Defense", GUI.Style_HBox_Attack_Defense, defensiveColor,
        aggressiveColor, styleData.defense)
    GUI.Style_Defense_Increase = createStyleButton("Defense", GUI.Style_HBox_Attack_Defense, defensiveColor)

    GUI.Survey_Container = Geyser.Container:new({
        name = "alui survey con",
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
    }, GUI.Box2)

    -- Register Survey Container with ResourceManager
    if RM then
        RM.registerUIElement("surveyContainer", GUI.Survey_Container, "interface")
    end

    -- Calculate survey padding - use more padding for better spacing
    local survey_padding = Gui_Padding * 1.6 -- 80% more padding than other containers

    GUI.Components.surveymini = Geyser.MiniConsole:new({
        name = "ALUI survey mini",
        x = survey_padding,
        y = survey_padding,
        width = GUI.Survey_Container:get_width() - (survey_padding * 2),
        height = GUI.Survey_Container:get_height() - (survey_padding * 2),
        color = "black",
    }, GUI.Survey_Container)

    -- Register survey mini console with ResourceManager
    if RM then
        RM.registerUIElement("surveyMini", GUI.Components.surveymini, "interface")
    end

    GUI.Chat_Container = Geyser.Container:new({
        name = "ALUI chat container",
        x = 0,
        y = 0,
        width = "100%",
        height = "100%",
    }, GUI.Box3)

    -- Register Chat Container with ResourceManager
    if RM then
        RM.registerUIElement("chatContainer", GUI.Chat_Container, "interface")
    end

    -- Calculate chat padding - use more padding for better spacing
    local chat_padding = Gui_Padding * 1.4 -- 40% more padding than other containers

    GUI.Components.chat_cap = EMCO:new({
        name = "ALUI chat cap",
        allTab = true,
        consoles = { "All", "Say", "Chat", "Mentor", "Newbie" },
        x = chat_padding,
        y = chat_padding,
        width = GUI.Chat_Container:get_width() - (chat_padding * 2),
        height = GUI.Chat_Container:get_height() - (chat_padding * 2),
        scrollbars = true,
    }, GUI.Chat_Container)
end

GUI.resizeBoxes = function()
    GUI.Box1:show()
    GUI.Box2:show()
    GUI.Box3:show()
    GUI.Box4:show()
    GUI.Box5:show()
    GUI.Box7:show()
    GUI.Map_Container:show()
    GUI.Mapper:show()
    GUI.Room_Container:show()
    GUI.Components.roommini:show()
    GUI.Status_Container:show()
    GUI.Components.combatmini:show()
    GUI.Style_Container:show()
    GUI.Style_VBox:show()
    GUI.Style_HBox_Aim_Control:show()
    GUI.Style_HBox_Offensive_Dodge:show()
    GUI.Style_HBox_Darring_Parry:show()
    GUI.Style_HBox_Power_Speed:show()
    GUI.Style_HBox_Attack_Defense:show()
    GUI.Style_Aim_Increase:show()
    GUI.Style_Gauge_Aim_Control:show()
    GUI.Style_Control_Increase:show()
    GUI.Style_Offensive_Increase:show()
    GUI.Style_Gauge_Offensive_Dodge:show()
    GUI.Style_Dodge_Increase:show()
    GUI.Style_Daring_Increase:show()
    GUI.Style_Gauge_Daring_Parry:show()
    GUI.Style_Parry_Increase:show()
    GUI.Style_Power_Increase:show()
    GUI.Style_Gauge_Power_Speed:show()
    GUI.Style_Speed_Increase:show()
    GUI.Style_Attack_Increase:show()
    GUI.Style_Gauge_Attack_Defense:show()
    GUI.Style_Defense_Increase:show()
    GUI.Logic:StyleUpdate()
    GUI.Survey_Container:show()
    GUI.Components.surveymini:show()
    GUI.Chat_Container:show()
    GUI.Components.chat_cap:show()
end

-- Register function in both old and new namespaces for compatibility
GUI.setBoxes = setBoxes

-- Register in new ALUI namespace if available
if GUI then
    GUI.setBoxes = setBoxes
    GUI.Components = GUI.Components or {}
    GUI.Components.boxes = setBoxes
end

GUI.setBoxes()
