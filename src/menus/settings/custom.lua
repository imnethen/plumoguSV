-- Creates the menu for custom SV settings
-- Returns whether settings have changed or not [Boolean]
-- Parameters
--    settingVars   : list of setting variables for this custom menu [Table]
--    skipFinalSV   : whether or not to skip choosing the final SV [Boolean]
--    svPointsForce : number of SV points to force [Int or nil]
function customSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = importCustomSVs(settingVars) or settingsChanged
    settingsChanged = chooseCustomMultipliers(settingVars) or settingsChanged
    if not (svPointsForce and skipFinalSV) then addSeparator() end
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    adjustNumberOfMultipliers(settingVars)
    return settingsChanged
end
