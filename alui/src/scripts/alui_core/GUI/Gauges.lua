-- GUI.Footer = Geyser.HBox:new({
--   name = "GUI.Footer",
--   x = 0, y = 0,
--   width = "100%",
--   height = "100%",
-- },GUI.Bottom)

-- GUI.LeftColumn = Geyser.VBox:new({
--   name = "GUI.LeftColumn",
-- },GUI.Footer)

-- GUI.RightColumn = Geyser.VBox:new({
--   name = "GUI.RightColumn",
-- },GUI.Footer)

-- GUI.GaugeBackCSS = CSSMan.new([[
--   background-color: rgba(0,0,0,0);
--   border-style: solid;
--   border-color: white;
--   border-width: 1px;
--   border-radius: 5px;
--   margin: 5px;
-- ]])

-- GUI.GaugeFrontCSS = CSSMan.new([[
--   background-color: rgba(0,0,0,0);
--   border-style: solid;
--   border-color: white;
--   border-width: 1px;
--   border-radius: 5px;
--   margin: 5px;
-- ]])

-- GUI.Health = Geyser.Gauge:new({
--   name = "GUI.Health",
-- },GUI.LeftColumn)
-- GUI.Health.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
-- GUI.GaugeFrontCSS:set("background-color","red")
-- GUI.Health.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
-- GUI.Health:setValue(math.random(100),100)
-- GUI.Health.front:echo("GUI.Health")

-- GUI.Mana = Geyser.Gauge:new({
--   name = "GUI.Mana",
-- },GUI.LeftColumn)
-- GUI.Mana.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
-- GUI.GaugeFrontCSS:set("background-color","blue")
-- GUI.Mana.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
-- GUI.Mana:setValue(math.random(100),100)
-- GUI.Mana.front:echo("GUI.Mana")

-- GUI.Endurance = Geyser.Gauge:new({
--   name = "GUI.Endurance",
-- },GUI.RightColumn)
-- GUI.Endurance.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
-- GUI.GaugeFrontCSS:set("background-color","yellow")
-- GUI.Endurance.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
-- GUI.Endurance:setValue(math.random(100),100)
-- --GUI.Endurance.front:echo("GUI.Endurance")
-- GUI.Endurance.front:echo([[<span style = "color: black">GUI.Endurance</span>]])

-- GUI.Willpower = Geyser.Gauge:new({
--   name = "GUI.Willpower",
-- },GUI.RightColumn)
-- GUI.Willpower.back:setStyleSheet(GUI.GaugeBackCSS:getCSS())
-- GUI.GaugeFrontCSS:set("background-color","purple")
-- GUI.Willpower.front:setStyleSheet(GUI.GaugeFrontCSS:getCSS())
-- GUI.Willpower:setValue(math.random(100),100)
-- GUI.Willpower.front:echo("GUI.Willpower")
