function BasicInputInt(settingVars, parameterName, label, bounds, tooltip)
    local oldValue = settingVars[parameterName]
    _, settingVars[parameterName] = imgui.InputInt(label, oldValue, 1, 1)
    if (tooltip) then HelpMarker(tooltip) end
    if (truthy(#bounds)) then
        settingVars[parameterName] = math.clamp(settingVars[parameterName], bounds[1], bounds[2])
    end
    return oldValue ~= settingVars[parameterName]
end
