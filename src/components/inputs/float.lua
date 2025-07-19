function ComputableInputFloat(label, var, decimalPlaces, suffix)
    local computableStateIndex = state.GetValue("ComputableInputFloatIndex") or 1
    local previousValue = var

    _, var = imgui.InputText(label,
        string.format("%." .. decimalPlaces .. "f" .. suffix,
            math.toNumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+") or tostring(var):match("%d*[%-]?%d+")) or 0),
        4096,
        imgui_input_text_flags.AutoSelectAll)
    if (not imgui.IsItemActive() and state.GetValue("previouslyActiveImguiFloat" .. computableStateIndex, false)) then
        local desiredComp = tostring(var):gsub(" ", "")
        var = expr(desiredComp)
    end
    state.SetValue("previouslyActiveImguiFloat" .. computableStateIndex, imgui.IsItemActive())
    state.SetValue("ComputableInputFloatIndex", computableStateIndex + 1)

    return math.toNumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+") or tostring(var):match("%d*[%-]?%d+")),
        previousValue ~= var
end

function NegatableComputableInputFloat(label, var, decimalPlaces, suffix)
    local oldValue = var
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("Neg.", SECONDARY_BUTTON_SIZE)
    ToolTip("Negate SV value")
    KeepSameLine()
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local newValue = ComputableInputFloat(label, var, decimalPlaces, suffix)
    imgui.PopItemWidth()
    if ((negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) and newValue ~= 0) then
        newValue = -newValue
    end
    return newValue, oldValue ~= newValue
end

function SwappableNegatableInputFloat2(settingVars, lowerName, higherName, label, suffix, digits, widthFactor)
    digits = digits or 2
    suffix = suffix or "x"
    widthFactor = widthFactor or 0.7
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local swapButtonPressed = imgui.Button("S##" .. lowerName, TERTIARY_BUTTON_SIZE)
    ToolTip("Swap start/end values")
    local oldValues = vector.New(settingVars[lowerName], settingVars[higherName])
    KeepSameLine()
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N##" .. higherName, TERTIARY_BUTTON_SIZE)
    ToolTip("Negate start/end values")
    KeepSameLine()
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * widthFactor - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2(label, oldValues, "%." .. digits .. "f" .. suffix)
    imgui.PopItemWidth()
    settingVars[lowerName] = newValues.x
    settingVars[higherName] = newValues.y
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars[lowerName] = oldValues.y
        settingVars[higherName] = oldValues.x
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars[lowerName] = -oldValues.x
        settingVars[higherName] = -oldValues.y
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues ~= newValues
end
