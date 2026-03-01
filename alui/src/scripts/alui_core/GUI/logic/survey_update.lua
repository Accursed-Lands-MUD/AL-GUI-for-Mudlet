function survey_update()
    -- Validate GMCP data exists before proceeding
    if not gmcp or not gmcp.Room or not gmcp.Room.survey then
        return
    end

    -- Use ALUI namespace for survey mini with fallback
    local surveymini = ALUI.GUI.Components.surveymini
    local SurveyContainer = ALUI.GUI.Survey_Container

    if surveymini then
        surveymini:clear()
        surveymini:decho(ansi2decho(gmcp.Room.survey))
    end

    if SurveyContainer then
        SurveyContainer:show()
    end
end

-- Register with ALUI namespace if available
if ALUI and ALUI.GUI then
    ALUI.GUI.Logic = ALUI.GUI.Logic or {}
    ALUI.GUI.Logic.survey_update = survey_update
end
