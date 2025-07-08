VIBRATO_SVS = { -- types of vibrato SVs
    "Linear##Vibrato",
    "Exponential##Vibrato",
    "Sinusoidal##Vibrato",
    "Custom##Vibrato"
}

-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeVibratoSVMenu(separateWindow)
    exportImportSettingsButton()
    local menuVars = getMenuVars("placeVibrato")
    chooseVibratoSVType(menuVars)

    addSeparator()
    imgui.Text("Vibrato Settings:")
    chooseVibratoMode(menuVars)
    chooseVibratoQuality(menuVars)
    if (menuVars.vibratoMode ~= 2) then
        chooseVibratoSides(menuVars)
    end

    local currentSVType = VIBRATO_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType .. (menuVars.vibratoMode == 1 and "SV" or "SSF"), "Vibrato")
    if globalVars.showExportImportMenu then
        -- exportImportSettingsMenu(menuVars, settingVars)
        return
    end

    addSeparator()

    if currentSVType == "Linear##Vibrato" then linearVibratoMenu(menuVars, settingVars, separateWindow) end
    if currentSVType == "Exponential##Vibrato" then exponentialVibratoMenu(menuVars, settingVars, separateWindow) end
    if currentSVType == "Sinusoidal##Vibrato" then sinusoidalVibratoMenu(menuVars, settingVars, separateWindow) end
    if currentSVType == "Custom##Vibrato" then customVibratoMenu(menuVars, settingVars, separateWindow) end

    local labelText = currentSVType .. "Vibrato$" .. (menuVars.vibratoMode == 1 and "$SV" or "$SSF")
    saveVariables(labelText .. "Settings", settingVars)
    saveVariables("placeVibratoMenu", menuVars)
end
