function teleportStutterMenu(settingVars)
    if settingVars.useDistance then
        chooseDistance(settingVars)
        HelpMarker("Start SV teleport distance")
    else
        chooseStartSVPercent(settingVars)
    end
    chooseMainSV(settingVars)
    chooseAverageSV(settingVars)
    chooseFinalSV(settingVars, false)
    BasicCheckbox(settingVars, "useDistance", "Use distance for start SV")
    BasicCheckbox(settingVars, "linearlyChange", "Change stutter over time")

    AddSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeTeleportStutterSVs, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeTeleportStutterSSFs, settingVars, true)
end
