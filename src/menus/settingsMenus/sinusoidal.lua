-- Creates the menu for sinusoidal SV settings
-- Returns whether settings have changed or not [Boolean]
-- Parameters
--    settingVars   : list of setting variables for this sinusoidal menu [Table]
--    skipFinalSV   : whether or not to skip choosing the final SV [Boolean]
--    svPointsForce : number of SV points to force [Int or nil]
function sinusoidalSettingsMenu(settingVars, skipFinalSV, _)
    local settingsChanged = false
    imgui.Text("Amplitude:")
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseCurveSharpness(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 1) or settingsChanged
    settingsChanged = chooseNumPeriods(settingVars) or settingsChanged
    settingsChanged = choosePeriodShift(settingVars) or settingsChanged
    settingsChanged = chooseSVPerQuarterPeriod(settingVars) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
