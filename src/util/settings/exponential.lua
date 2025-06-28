-- Creates the menu for exponential SV settings
-- Returns whether settings have changed or not [Boolean]
-- Parameters
--    settingVars   : list of setting variables for this exponential menu [Table]
--    skipFinalSV   : whether or not to skip choosing the final SV [Boolean]
--    svPointsForce : number of SV points to force [Int or nil]
function exponentialSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseSVBehavior(settingVars) or settingsChanged

    settingsChanged = chooseIntensity(settingVars) or settingsChanged
    if (state.GetValue("global_advancedMode")) then
        settingsChanged = chooseDistanceMode(settingVars) or settingsChanged
    end
    if (settingVars.distanceMode ~= 3) then
        settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    end
    if (settingVars.distanceMode == 1) then
        settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    elseif (settingVars.distanceMode == 2) then
        settingsChanged = chooseDistance(settingVars) or settingsChanged
    else
        settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    end
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
