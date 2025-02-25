GUI.BackgroundCSS = CSSMan.new([[
  background-color: rgb(20,0,20);
  background-image: url('C:\workspace\AL-GUI-for-Mudlet\alui\src\resources\banner.webp');
]])

GUI.Left = Geyser.Label:new({
    name = "GUI.Left",
    x = 0,
    y = 0,
    width = "25%",
    height = "100%",
})
GUI.Left:setStyleSheet(GUI.BackgroundCSS:getCSS())

GUI.Right = Geyser.Label:new({
    name = "GUI.Right",
    x = "-25%",
    y = 0,
    width = "25%",
    height = "100%",
    backgroundImages = "url('/banner.webp')",
})
GUI.Right:setStyleSheet(GUI.BackgroundCSS:getCSS())

GUI.Top = Geyser.Label:new({
    name = "GUI.Top",
    x = "25%",
    y = 0,
    width = "50%",
    height = "5%",
})
GUI.Top:setStyleSheet(GUI.BackgroundCSS:getCSS())

GUI.setBackground = function()
    local sideBorder = "25%"

    GUI.Left.height = "100%"
    GUI.Left.width = sideBorder

    GUI.Right.height = "100%"
    GUI.Right.width = sideBorder

    GUI.Top.height = "5%"
    GUI.Top.width = topBorder

    GUI.Left:show()
    GUI.Right:show()
    GUI.Top:show()
    -- GUI.Bottom:show()

    local width, _ = getMainWindowSize()

    local fontSize = getFontSize()

    local fontWidth, _ = calcFontSize(fontSize)

    local lineWidth = width / fontWidth

    local lineWidthAdjusted = lineWidth / 2

    setWindowWrap("main", lineWidthAdjusted)
end
