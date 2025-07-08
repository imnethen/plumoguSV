function hermiteSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
