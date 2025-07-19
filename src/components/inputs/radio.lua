function RadioButtons(label, value, options, optionValues, tooltip)
    imgui.AlignTextToFramePadding()
    imgui.Text(label)
    if (tooltip) then ToolTip(tooltip) end
    for idx, option in pairs(options) do
        imgui.SameLine(0, RADIO_BUTTON_SPACING)
        if imgui.RadioButton(option, value == optionValues[idx]) then
            value = optionValues[idx]
        end
    end
    return value
end
