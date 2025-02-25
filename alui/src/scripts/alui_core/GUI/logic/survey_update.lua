function survey_update()
  local m = alui.surveymini
  m:clear()
  m:decho(ansi2decho(gmcp.Room.survey))
  GUI.Survey_Container:show()
end
