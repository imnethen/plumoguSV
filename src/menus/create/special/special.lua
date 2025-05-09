SPECIAL_SVS = { -- types of special SVs
    "Stutter",
    "Teleport Stutter",
    "Splitscroll (Basic)",
    "Splitscroll (Advanced)",
    "Splitscroll (Adv v2)",
    "Penis",
    "Frames Setup"
}

-- Creates the menu for placing special SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeSpecialSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getSpecialPlaceMenuVars()
    changeSVTypeIfKeysPressed(menuVars)
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
    if currentSVType == "Splitscroll (Basic)" then splitScrollBasicMenu(settingVars) end
    if currentSVType == "Splitscroll (Advanced)" then splitScrollAdvancedMenu(settingVars) end
    if currentSVType == "Splitscroll (Adv v2)" then splitScrollAdvancedV2Menu(settingVars) end
    if currentSVType == "Penis" then penisMenu(settingVars) end
    if currentSVType == "Frames Setup" then
        animationFramesSetupMenu(globalVars, settingVars)
    end

    local labelText = table.concat({ currentSVType, "SettingsSpecial" })
    saveVariables(labelText, settingVars)
    saveVariables("placeSpecialMenu", menuVars)
end