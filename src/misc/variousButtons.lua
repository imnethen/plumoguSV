function exportImportSettingsButton()
    local buttonText = ": )"
    if globalVars.showExportImportMenu then buttonText = "X" end
    local buttonPressed = imgui.Button(buttonText, EXPORT_BUTTON_SIZE)
    toolTip("Export and import menu settings")
    imgui.SameLine(0, SAMELINE_SPACING)
    if not buttonPressed then return end

    globalVars.showExportImportMenu = not globalVars.showExportImportMenu
end
