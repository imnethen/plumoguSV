-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeStillSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getMenuVars("placeStill")
    local needSVUpdate = #menuVars.svMultipliers == 0
    needSVUpdate = chooseStandardSVType(menuVars, false) or needSVUpdate

    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Still")
    if globalVars.showExportImportMenu then
        --saveVariables("placeStillMenu", menuVars)
        exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end
    imgui.Text("Still Settings:")
    chooseNoteSpacing(menuVars)
    chooseStillBehavior(menuVars)
    chooseStillType(menuVars)

    addSeparator()
    needSVUpdate = showSettingsMenu(currentSVType, settingVars, false, nil) or needSVUpdate

    addSeparator()
    needSVUpdate = chooseInterlace(menuVars) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false) end

    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, false)

    addSeparator()
    menuVars.settingVars = settingVars
    simpleActionMenu("Place SVs between selected notes", 2, placeStillSVsParent, globalVars, menuVars)

    saveVariables(currentSVType .. "StillSettings", settingVars)
    saveVariables("placeStillMenu", menuVars)
end