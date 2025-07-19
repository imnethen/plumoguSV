function BasicCheckbox(settingVars, parameterName, label, tooltip)
    local oldValue = settingVars[parameterName]
    _, settingVars[parameterName] = imgui.Checkbox(label, oldValue)
    if (tooltip) then HelpMarker(tooltip) end
    return oldValue ~= settingVars[parameterName]
end

function GlobalCheckbox(parameterName, label, tooltipText)
    local oldValue = globalVars[parameterName]
    ---@cast oldValue boolean
    _, globalVars[parameterName] = imgui.Checkbox(label, oldValue)
    if (tooltipText) then ToolTip(tooltipText) end
    if (oldValue ~= globalVars[parameterName]) then write(globalVars) end
end
