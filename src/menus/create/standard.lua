STANDARD_SVS = {
    "Linear",
    "Exponential",
    "Bezier",
    "Hermite",
    "Sinusoidal",
    "Circular",
    "Random",
    "Custom",
    "Chinchilla",
    "Combo",
    "Code"
}

function placeStandardSVMenu()
    presetButton()
    local menuVars = getMenuVars("placeStandard")
    local needSVUpdate = #menuVars.svMultipliers == 0
    needSVUpdate = chooseStandardSVType(menuVars, false) or needSVUpdate

    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Standard")
    if globalVars.showPresetMenu then
        renderPresetMenu(menuVars, settingVars)
        return
    end

    needSVUpdate = showSettingsMenu(currentSVType, settingVars, false, nil) or needSVUpdate
    addSeparator()

    needSVUpdate = chooseInterlace(menuVars) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, menuVars, settingVars, false) end

    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, false)

    menuVars.settingVars = settingVars
    addSeparator()
    if (STANDARD_SVS[menuVars.svTypeIndex] == "Exponential" and settingVars.distanceMode == 2) then
        simpleActionMenu("Place SVs between selected notes##Exponential", 2, placeExponentialSpecialSVs, menuVars)
    else
        simpleActionMenu("Place SVs between selected notes", 2, placeSVs, menuVars)
    end
    simpleActionMenu("Place SSFs between selected notes", 2, placeSSFs, menuVars, true)

    saveVariables(currentSVType .. "StandardSettings", settingVars)
    saveVariables("placeStandardMenu", menuVars)
end
