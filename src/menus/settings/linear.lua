-- Creates the menu for linear SV settings
-- Returns whether settings have changed or not [Boolean]
-- Parameters
--    settingVars   : list of setting variables for this linear menu [Table]
--    skipFinalSV   : whether or not to skip choosing the final SV [Boolean]
--    svPointsForce : number of SV points to force [Int or nil]
function linearSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    if (settingVars.startSV < 0 and settingVars.endSV > 0 and math.abs(settingVars.startSV / settingVars.endSV) < 5) then
        height = state.GetValue("JumpHeight") or 0
        if settingsChanged then
            linearSet = generateLinearSet(settingVars.startSV, settingVars.endSV, settingVars.svPoints + 1)
            local sum = 0
            for i = 1, #linearSet - 1 do
                if (linearSet[i] >= 0) then break end
                sum = sum - linearSet[i] / settingVars.svPoints
            end
            height = sum
            state.SetValue("JumpHeight", sum)
        end
        imgui.TextColored({ 1, 0, 0, 1 }, "Jump detected. The maximum \nheight of the jump is " .. height .. "x.")
    end
    return settingsChanged
end
