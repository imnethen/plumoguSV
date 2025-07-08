function linearSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    if (settingVars.startSV < 0 and settingVars.endSV > 0 and math.abs(settingVars.startSV / settingVars.endSV) < 5) then
        height = state.GetValue("JumpHeight") or 0
        if settingsChanged then
            linearSet = generateLinearSet(settingVars.startSV, settingVars.endSV, settingVars.svPoints + 1, true)
            local sum = 0
            for i = 1, #linearSet - 1 do
                if (linearSet[i] >= 0) then break end
                sum = sum - linearSet[i] / settingVars.svPoints
            end
            height = sum
            state.SetValue("JumpHeight", sum)
        end
        imgui.TextColored(vector.New(1, 0, 0, 1), "Jump detected. The maximum \nheight of the jump is " .. height .. "x.")
    end
    return settingsChanged
end
