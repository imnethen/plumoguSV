function saveSettingsButton(globalVars, settingVars, label)
    imgui.SameLine(0, SAMELINE_SPACING)
    if (not imgui.Button("Save")) then return end
    globalVars.defaultProperties[label] = settingVars
    loadDefaultProperties(globalVars.defaultProperties)
    saveAndSyncGlobals(globalVars)
end

function showDefaultPropertiesSettings(globalVars)
    imgui.SeparatorText("Linear Settings")
    do
        settingVars = getSettingVars("linear", "Settings")
        chooseStartEndSVs(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)
        saveSettingsButton(globalVars, settingVars, "linear")
    end
end
