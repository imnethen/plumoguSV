VIBRATO_SVS = { -- types of vibrato SVs
    "Linear##Vibrato",
    "Exponential##Vibrato",
    "Sinusoidal##Vibrato",
    "Custom##Vibrato"
}

-- Creates the menu for placing special SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function placeVibratoSVMenu(globalVars, separateWindow)
    exportImportSettingsButton(globalVars)
    local menuVars = getMenuVars("placeVibrato")
    chooseVibratoSVType(menuVars)

    addSeparator()
    imgui.Text("Vibrato Settings:")
    chooseVibratoMode(menuVars)
    chooseVibratoQuality(menuVars)
    if (menuVars.vibratoMode ~= 2) then
        imgui.AlignTextToFramePadding()
        imgui.Dummy(vector.New(27, 0))
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Sides:")
        imgui.SameLine(0, RADIO_BUTTON_SPACING)
        if imgui.RadioButton("1", menuVars.sides == 1) then
            menuVars.sides = 1
        end
        imgui.SameLine(0, RADIO_BUTTON_SPACING)
        if imgui.RadioButton("2", menuVars.sides == 2) then
            menuVars.sides = 2
        end
        imgui.SameLine(0, RADIO_BUTTON_SPACING)
        if imgui.RadioButton("3", menuVars.sides == 3) then
            menuVars.sides = 3
        end
    end

    local currentSVType = VIBRATO_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType .. (menuVars.vibratoMode == 1 and "SV" or "SSF"), "Vibrato")
    if globalVars.showExportImportMenu then
        -- exportImportSettingsMenu(globalVars, menuVars, settingVars)
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
