local Package_Root = getMudletHomeDir()

local blue = GUI.Colors.blue
local red = GUI.Colors.red

GUI.Header = Geyser.HBox:new({
    name = "GUI.Header",
    x = 0,
    y = 0,
    width = "100%",
    height = "100%",
}, GUI.Top)

GUI.InfoCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
  border-style: solid;
  border-width: 1px;
  border-color: white;
  border-radius: 5px;
  margin: 5px;
  qproperty-wordWrap: true;
  background-position: center;
  background-repeat: no-repeat;
  background-size: auto 50%;
]])

GUI.ActionCSS = CSSMan.new([[
  background-color: rgba(0,0,0,100);
  border-style: solid;
  border-width: 1px;
  border-color: white;
  margin: 5px;
  qproperty-wordWrap: true;
  background-position: center;
  background-repeat: no-repeat;
  background-size: auto 50%;
]])


-- background-repeat: no-repeat;
--   background-position: center;


local function createMenuItem(name, updateFunction, parent)


    local item = Geyser.Label:new({
        name = 'GUI.Menu.' .. name,
    }, parent)

    item.update = updateFunction

    item:update()

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
    return button
end

GUI.Menu.Hunger = createMenuItem("Hunger", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_hunger.png)"
    local label = nil
    local backgroundColor = alui.status.hunger

    if iconPath then
        GUI.InfoCSS:set("background-image", iconPath)
    else
        GUI.InfoCSS:set("background-image", "none")
        if label then
            self:echo("<center>" .. label)
        end
    end
    if backgroundColor then
        GUI.InfoCSS:set("background-color", backgroundColor)
    else
        GUI.InfoCSS:set("background-color", "rgba(0,0,0,100)")
    end

    self:setStyleSheet(GUI.InfoCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Thirst = createMenuItem("Thirst", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_thirst01.png)"
    local backgroundColor = alui.status.thirst

    GUI.InfoCSS:set("background-image", iconPath)

    if backgroundColor then
        GUI.InfoCSS:set("background-color", backgroundColor)
    else
        GUI.InfoCSS:set("background-color", "rgba(0,0,0,100)")
    end

    self:setStyleSheet(GUI.InfoCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Fatigue = createMenuItem("Fatigue", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_fatigue01.png)"

    local backgroundColor = alui.status.fatigue

    GUI.InfoCSS:set("background-image", iconPath)

    if backgroundColor then
        GUI.InfoCSS:set("background-color", backgroundColor)
    else
        GUI.InfoCSS:set("background-color", "rgba(0,0,0,100)")
    end

    self:setStyleSheet(GUI.InfoCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Posture = createMenuItem("Posture", function(self)
    local label = alui.status.posture

    GUI.InfoCSS:set("background-image", "none")

    if label then
        self:clear()
        self:echo("<center>" .. label)
    end

    GUI.InfoCSS:set("background-color", "rgba(0,0,0,100)")

    self:setStyleSheet(GUI.InfoCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Mercy = createMenuItem("Mercy", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_mercy01.png)"

    local showMercy = alui.status.mercy

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

    if alui.status.mercy then
        gameCommand = "mercy off"
        toolTip = "Turn Mercy On"
    end

    send(gameCommand, false)
    setLabelToolTip("GUI.Menu.Mercy", toolTip)
end)

GUI.Menu.Travel = createMenuItem("Travel", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_travel01.png)"

    local autoTravel = alui.status.travel

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

    if alui.status.travel then
        gameCommand = "travel off"
        toolTip = "Turn Travel On"
    end

    send(gameCommand, false)
    setLabelToolTip("GUI.Menu.Travel", toolTip)
end)

GUI.Menu.CommonSense = createMenuItem("CommonSense", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_commonsense.png)"

    local useCommonSense = alui.status.commonsense

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

    if alui.status.commonsense then
        gameCommand = "commonsense off"
        toolTip = "Turn Commonsense On"
    end

    send(gameCommand, false)
    setLabelToolTip("GUI.Menu.CommonSense", toolTip)
end)

GUI.Menu.Help = createMenuItem("Help", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/help_2.png)"

    GUI.ActionCSS:set("background-image", iconPath)

    GUI.ActionCSS:set("background-color", "rgba(0,0,0,100)")

    self:setStyleSheet(GUI.ActionCSS:getCSS())
end,
        GUI.Header)

setLabelToolTip("GUI.Menu.Help", 'Help')

GUI.Menu.Help:setClickCallback(function()
    openUserWindow("Help", false, false, "f")

    help = createMiniConsole('Help', 0, 0)

    help:clear()
    help:cecho('<center>ALUI Help<</reset>')
    help:cecho('<center>Commands')

    --cinsertText('Help', [[<center><h1>ALUI Help</h1>]])

    echo('\nHelp Clicked\n')
    --send(gameCommand, false)
end)







