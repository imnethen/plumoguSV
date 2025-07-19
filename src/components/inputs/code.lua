function CodeInput(settingVars, parameterName, label, tooltipText)
    local oldCode = settingVars[parameterName]
    _, settingVars[parameterName] = imgui.InputTextMultiline(label, settingVars[parameterName], 16384,
        vector.New(240, 120))
    if (tooltipText) then ToolTip(tooltipText) end
    return oldCode ~= settingVars[parameterName]
end
