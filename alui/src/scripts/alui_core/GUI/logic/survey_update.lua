function survey_update()
    -- Use ALUI namespace for survey mini with fallback
    local surveymini = ALUI.GUI.Components.surveymini
    local SurveyContainer = (ALUI and ALUI.GUI and ALUI.GUI.Components and ALUI.GUI.Components.Survey_Container) or
    GUI.Survey_Container

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

-- Mark this file as migrated
if ALUI and ALUI.migration and ALUI.migration.markComplete then
    ALUI.migration.markComplete("survey_update.lua")
end
