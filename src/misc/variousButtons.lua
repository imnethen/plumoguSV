function presetButton()
    local buttonText = ": )"
    if globalVars.showPresetMenu then buttonText = "X" end
    local buttonPressed = imgui.Button(buttonText, EXPORT_BUTTON_SIZE)
    ToolTip("View presets and export/import them.")
    KeepSameLine()
    if not buttonPressed then return end

    globalVars.showPresetMenu = not globalVars.showPresetMenu
end
