function linearVibratoMenu(settingVars)
    customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs")
    customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs")

    simpleActionMenu("Place SSFs", 2, linearSSFVibrato, nil, settingVars)
end

-- sum shit idk
-- Returns whether or not the start or end SVs changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function customSwappableNegatableInputFloat2(settingVars, lowerName, higherName, tag)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 7, 4 })
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = { settingVars[lowerName], settingVars[higherName] }
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 6.5, 4 })
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2(tag, oldValues, "%.2fx")
    imgui.PopItemWidth()
    settingVars[lowerName] = newValues[1]
    settingVars[higherName] = newValues[2]
    if (swapButtonPressed or utils.IsKeyPressed(keys.S)) then
        settingVars[lowerName] = oldValues[2]
        settingVars[higherName] = oldValues[1]
    end
    if (negateButtonPressed or utils.IsKeyPressed(keys.N)) then
        settingVars[lowerName] = -oldValues[1]
        settingVars[higherName] = -oldValues[2]
    end
    return swapButtonPressed or negateButtonPressed or utils.IsKeyPressed(keys.S) or utils.IsKeyPressed(keys.N) or
        oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end
