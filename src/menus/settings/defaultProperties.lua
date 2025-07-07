function saveSettingsButton(settingVars, label)
    imgui.SameLine(0, SAMELINE_SPACING)
    if (not imgui.Button("Save")) then return end
end

function showDefaultPropertiesSettings(globalVars)
    imgui.SeparatorText("Linear Settings")
    do
        settingVars = getSettingVars("linear", "Settings")
        chooseStartEndSVs(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)
        saveSettingsButton(settingVars, "linear")
    end
end
