function codeSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    CodeInput(settingVars, "code", "##code")
    if (imgui.Button("Refresh Plot", vector.New(ACTION_BUTTON_SIZE.x, 30))) then
        settingsChanged = true
    end
    imgui.Separator()
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged

    return settingsChanged
end
