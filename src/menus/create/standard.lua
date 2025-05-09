STANDARD_SVS = { -- types of standard SVs
    "Linear",
    "Exponential",
    "Bezier",
    "Hermite",
    "Sinusoidal",
    "Circular",
    "Random",
    "Custom",
    "Chinchilla",
    "Combo"
}

-- Creates the menu for placing standard SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeStandardSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getStandardPlaceMenuVars()
    local needSVUpdate = changeSVTypeIfKeysPressed(menuVars)
    needSVUpdate = needSVUpdate or #menuVars.svMultipliers == 0
    needSVUpdate = chooseStandardSVType(menuVars, false) or needSVUpdate

    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Standard")
    if globalVars.showExportImportMenu then
        --saveVariables("placeStandardMenu", menuVars)
        exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end

    needSVUpdate = showSettingsMenu(currentSVType, settingVars, false, nil) or needSVUpdate

    addSeparator()
    needSVUpdate = chooseInterlace(menuVars) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false) end

    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, false)

    addSeparator()
    if (STANDARD_SVS[menuVars.svTypeIndex] == "Exponential" and settingVars.distanceMode == 2) then
        menuVars.settingVars = settingVars
        simpleActionMenu("Place SVs between selected notes##Exponential", 2, placeExponentialSpecialSVs, globalVars,
            menuVars)
    else
        simpleActionMenu("Place SVs between selected notes", 2, placeSVs, globalVars, menuVars)
    end
    simpleActionMenu("Place SSFs between selected notes", 2, placeSSFs, globalVars, menuVars, true)

    local labelText = table.concat({ currentSVType, "SettingsStandard" })
    saveVariables(labelText, settingVars)
    saveVariables("placeStandardMenu", menuVars)
end