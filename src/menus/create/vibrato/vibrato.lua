VIBRATO_SVS = { -- types of vibrato SVs
    "Linear"
}

-- Creates the menu for placing special SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeVibratoSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getVibratoPlaceMenuVars()
    changeSVTypeIfKeysPressed(menuVars)
    chooseVibratoSVType(menuVars)

    addSeparator()
    local currentSVType = VIBRATO_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Vibrato")
    if globalVars.showExportImportMenu then
        -- exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end

    if currentSVType == "Linear" then linearVibratoMenu(settingVars) end

    local labelText = table.concat({ currentSVType, "SettingsVibrato" })
    saveVariables(labelText, settingVars)
    saveVariables("placeSpecialMenu", menuVars)
end

-- Returns menuVars for the menu at Place SVs > Special
function getVibratoPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1
    }
    getVariables("placeSpecialMenu", menuVars)
    return menuVars
end
