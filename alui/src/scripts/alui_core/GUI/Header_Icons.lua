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

GUI.IconCSS = CSSMan.new([[
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
        GUI.IconCSS:set("background-image", iconPath)
    else
        GUI.IconCSS:set("background-image", "none")
        if label then
            self:echo("<center>" .. label)
        end
    end
    if backgroundColor then
        GUI.IconCSS:set("background-color", backgroundColor)
    else
        GUI.IconCSS:set("background-color", "rgba(0,0,0,100)")
    end

    self:setStyleSheet(GUI.IconCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Thirst = createMenuItem("Thirst", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_thirst01.png)"
    local backgroundColor = alui.status.thirst

    GUI.IconCSS:set("background-image", iconPath)

    if backgroundColor then
        GUI.IconCSS:set("background-color", backgroundColor)
    else
        GUI.IconCSS:set("background-color", "rgba(0,0,0,100)")
    end

    self:setStyleSheet(GUI.IconCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Fatigue = createMenuItem("Fatigue", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_fatigue01.png)"

    local backgroundColor = alui.status.fatigue

    GUI.IconCSS:set("background-image", iconPath)

    if backgroundColor then
        GUI.IconCSS:set("background-color", backgroundColor)
    else
        GUI.IconCSS:set("background-color", "rgba(0,0,0,100)")
    end

    self:setStyleSheet(GUI.IconCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Posture = createMenuItem("Posture", function(self)
    local label = alui.status.posture

    GUI.IconCSS:set("background-image", "none")

    if label then
        self:clear()
        self:echo("<center>" .. label)
    end

    GUI.IconCSS:set("background-color", "rgba(0,0,0,100)")

    self:setStyleSheet(GUI.IconCSS:getCSS())
end,
        GUI.Header)

GUI.Menu.Mercy = createMenuItem("Mercy", function(self)
    local iconPath = "url(" .. Package_Root .. "/alui/icons/medium/AL_mercy01.png)"

    local showMercy = alui.status.mercy

    GUI.IconCSS:set("background-image", iconPath)


    -- self:echo("<center> Mercy")

    if showMercy then
        GUI.IconCSS:set("background-color", blue)
    else
        GUI.IconCSS:set("background-color", red)
    end

    self:setStyleSheet(GUI.IconCSS:getCSS())
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

    GUI.IconCSS:set("background-image", iconPath)
    -- self:echo("<center>Travel")

    if autoTravel then
        GUI.IconCSS:set("background-color", blue)
    else
        GUI.IconCSS:set("background-color", red)
    end

    self:setStyleSheet(GUI.IconCSS:getCSS())
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

    GUI.IconCSS:set("background-image", iconPath)
    -- self:echo("<center>CommonSense")

    if useCommonSense then
        GUI.IconCSS:set("background-color", blue)
    else
        GUI.IconCSS:set("background-color", red)
    end
    self:setStyleSheet(GUI.IconCSS:getCSS())
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

















--GUI.Menu.Menu = createMenuItem("Menu", function(self)
--    local iconPath = "url(" .. Package_Root .. "/alui/icons/menuIcon.png)"
--
--
--
--
--    GUI.IconCSS:set("background-image", iconPath)
--
--    GUI.IconCSS:set("background-color", "rgba(0,0,0,100)")
--
--
--    self:setStyleSheet(GUI.IconCSS:getCSS())
--  end,
--  GUI.Header)
