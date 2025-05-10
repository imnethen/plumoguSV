-- Creates the menu for custom SV settings
-- Returns whether settings have changed or not [Boolean]
-- Parameters
--    settingVars : list of setting variables for this combo menu [Table]
function comboSettingsMenu(settingVars)
    local settingsChanged = false
    startNextWindowNotCollapsed("svType1AutoOpen")
    imgui.Begin("SV Type 1 Settings", imgui_window_flags.AlwaysAutoResize)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    local svType1 = STANDARD_SVS[settingVars.svType1Index]
    local settingVars1 = getSettingVars(svType1, "Combo1")
    settingsChanged = showSettingsMenu(svType1, settingVars1, true, nil) or settingsChanged
    local labelText1 = table.concat({ svType1, "SettingsCombo1" })
    saveVariables(labelText1, settingVars1)
    imgui.End()

    startNextWindowNotCollapsed("svType2AutoOpen")
    imgui.Begin("SV Type 2 Settings", imgui_window_flags.AlwaysAutoResize)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    local svType2 = STANDARD_SVS[settingVars.svType2Index]
    local settingVars2 = getSettingVars(svType2, "Combo2")
    settingsChanged = showSettingsMenu(svType2, settingVars2, true, nil) or settingsChanged
    local labelText2 = table.concat({ svType2, "SettingsCombo2" })
    saveVariables(labelText2, settingVars2)
    imgui.End()

    local maxComboPhase = settingVars1.svPoints + settingVars2.svPoints

    settingsChanged = chooseStandardSVTypes(settingVars) or settingsChanged
    settingsChanged = chooseComboSVOption(settingVars, maxComboPhase) or settingsChanged

    addSeparator()
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    if not settingVars.dontNormalize then
        settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    end
    settingsChanged = chooseFinalSV(settingVars, false) or settingsChanged
    settingsChanged = chooseNoNormalize(settingVars) or settingsChanged

    return settingsChanged
end
