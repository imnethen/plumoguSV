function ColorInput(customStyle, parameterName, label, tooltipText)
    AddSeparator()
    local oldCode = customStyle[parameterName]
    _, customStyle[parameterName] = imgui.ColorPicker4(label, customStyle[parameterName] or DEFAULT_STYLE[parameterName])
    if (tooltipText) then ToolTip(tooltipText) end
    return oldCode ~= customStyle[parameterName]
end
