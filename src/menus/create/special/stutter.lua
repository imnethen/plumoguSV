function stutterMenu(settingVars)
    local settingsChanged = #settingVars.svMultipliers == 0
    settingsChanged = chooseControlSecondSV(settingVars) or settingsChanged
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseStutterDuration(settingVars) or settingsChanged
    settingsChanged = chooseLinearlyChange(settingVars) or settingsChanged

    addSeparator()
    settingsChanged = chooseStuttersPerSection(settingVars) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, false) or settingsChanged
    if settingsChanged then updateStutterMenuSVs(settingVars) end
    displayStutterSVWindows(settingVars)

    addSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeStutterSVs, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeStutterSSFs, settingVars, true)
end
