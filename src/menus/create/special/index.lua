SPECIAL_SVS = { -- types of special SVs
    "Stutter",
    "Teleport Stutter",
    "Frames Setup",
    "Automate",
    "Animation Palette",
    "Penis",
}

-- Creates the menu for placing special SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeSpecialSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getMenuVars("placeSpecial")
    chooseSpecialSVType(menuVars)

    addSeparator()
    local currentSVType = SPECIAL_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Special")
    if globalVars.showExportImportMenu then
        --saveVariables("placeSpecialMenu", menuVars)
        exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end

    if currentSVType == "Stutter" then stutterMenu(settingVars) end
    if currentSVType == "Teleport Stutter" then teleportStutterMenu(settingVars) end
    if currentSVType == "Frames Setup" then
        animationFramesSetupMenu(globalVars, settingVars)
    end
    if currentSVType == "Automate" then automateSVMenu(settingVars) end
    if currentSVType == "Animation Palette" then animationPaletteMenu(settingVars) end
    if currentSVType == "Penis" then penisMenu(settingVars) end

    local labelText = currentSVType .. "Special"
    saveVariables(labelText .. "Settings", settingVars)
    saveVariables("placeSpecialMenu", menuVars)
end
