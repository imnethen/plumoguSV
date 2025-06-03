VIBRATO_SVS = { -- types of vibrato SVs
    "Linear##Vibrato",
    "Exponential##Vibrato"
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
    imgui.Text("Vibrato Settings:")
    chooseVibratoMode(menuVars)
    chooseVibratoQuality(menuVars)
    if (menuVars.vibratoMode ~= 2) then
        _, menuVars.oneSided = imgui.Checkbox("One-Sided Vibrato?", menuVars.oneSided)
    end

    local currentSVType = VIBRATO_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Vibrato" .. menuVars.vibratoMode)
    if globalVars.showExportImportMenu then
        -- exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end



    addSeparator()

    if currentSVType == "Linear##Vibrato" then linearVibratoMenu(menuVars, settingVars) end
    if currentSVType == "Exponential##Vibrato" then exponentialVibratoMenu(menuVars, settingVars) end

    local labelText = table.concat({ currentSVType, "SettingsVibrato" .. menuVars.vibratoMode })
    saveVariables(labelText, settingVars)
    saveVariables("placeVibratoMenu", menuVars)
end

-- Returns menuVars for the menu at Place SVs > Special
function getVibratoPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1,
        vibratoMode = 1,
        vibratoQuality = 3,
        oneSided = false
    }
    getVariables("placeVibratoMenu", menuVars)
    return menuVars
end
