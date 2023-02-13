function survey_update()
  local m = alui.surveymini
  m:clear()
  m:decho(ansi2decho(gmcp.Room.survey))
  alui.surveycon:show()
end