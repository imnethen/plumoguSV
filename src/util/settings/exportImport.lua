--    settingVars : list of setting variables for the current sv type [Table]
function exportImportSettingsMenu(menuVars, settingVars)
    local multilineWidgetSize = { ACTION_BUTTON_SIZE.x, 50 }
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    local isSpecialPlaceType = placeType == "Special"
    local svType
    if isSpecialPlaceType then
        svType = SPECIAL_SVS[menuVars.svTypeIndex]
    else
        svType = STANDARD_SVS[menuVars.svTypeIndex]
    end
    local isComboType = svType == "Combo"
    local noExportOption = svType == "Splitscroll (Basic)" or
        svType == "Splitscroll (Advanced)" or
        svType == "Frames Setup"
    imgui.Text("Paste exported data here to import")
    _, globalVars.importData = imgui.InputTextMultiline("##placeImport", globalVars.importData,
        MAX_IMPORT_CHARACTER_LIMIT,
        multilineWidgetSize)
    importPlaceSVButton()
    addSeparator()
    if noExportOption then
        imgui.Text("No export option")
        return
    end

    if not isSpecialPlaceType then
        imgui.Text("Copy + paste exported data somewhere safe")
        imgui.InputTextMultiline("##customSVExport", globalVars.exportCustomSVData,
            #globalVars.exportCustomSVData, multilineWidgetSize,
            imgui_input_text_flags.ReadOnly)
        exportCustomSVButton(menuVars)
        addSeparator()
    end
    if not isComboType then
        imgui.Text("Copy + paste exported data somewhere safe")
        imgui.InputTextMultiline("##placeExport", globalVars.exportData, #globalVars.exportData,
            multilineWidgetSize, imgui_input_text_flags.ReadOnly)
        exportPlaceSVButton(menuVars, settingVars)
    end
end
