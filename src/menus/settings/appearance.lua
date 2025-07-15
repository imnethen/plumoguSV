function showAppearanceSettings()
    imgui.PushItemWidth(150)
    chooseStyleTheme()
    chooseColorTheme()
    addSeparator()
    chooseCursorTrail()
    chooseCursorTrailShape()
    chooseEffectFPS()
    chooseCursorTrailPoints()
    chooseCursorShapeSize()
    chooseSnakeSpringConstant()
    chooseCursorTrailGhost()
    addSeparator()
    imgui.PopItemWidth()
    chooseDrawCapybara()
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    chooseDrawCapybara2()
    chooseDrawCapybara312()
    addSeparator()
    choosePulseCoefficient()
    _, globalVars.useCustomPulseColor = imgui.Checkbox("Use Custom Color?", globalVars.useCustomPulseColor)
    if (not globalVars.useCustomPulseColor) then imgui.BeginDisabled() end
    keepSameLine()
    if (imgui.Button("Edit Color")) then
        state.SetValue("showColorPicker", true)
    end
    if (state.GetValue("showColorPicker")) then
        choosePulseColor()
    end
    if (not globalVars.useCustomPulseColor) then
        imgui.EndDisabled()
        state.SetValue("showColorPicker", false)
    end
end
