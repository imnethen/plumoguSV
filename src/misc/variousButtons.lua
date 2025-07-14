function presetButton()
    local buttonText = ": )"
    if globalVars.showPresetMenu then buttonText = "X" end
    local buttonPressed = imgui.Button(buttonText, EXPORT_BUTTON_SIZE)
    toolTip("View presets and export/import them.")
    imgui.SameLine(0, SAMELINE_SPACING)
    if not buttonPressed then return end

    globalVars.showPresetMenu = not globalVars.showPresetMenu
end
