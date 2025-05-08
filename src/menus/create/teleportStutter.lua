-- Creates the menu for teleport stutter SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function teleportStutterMenu(settingVars)
    if settingVars.useDistance then
        chooseDistance(settingVars)
        helpMarker("Start SV teleport distance")
    else
        chooseStartSVPercent(settingVars)
    end
    chooseMainSV(settingVars)
    chooseAverageSV(settingVars)
    chooseFinalSV(settingVars, false)
    chooseUseDistance(settingVars)
    chooseLinearlyChange(settingVars)

    addSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeTeleportStutterSVs, nil, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeTeleportStutterSSFs, nil, settingVars, true)
end
