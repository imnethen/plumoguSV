function showAppearanceSettings(globalVars)
  imgui.PushItemWidth(150)
  chooseStyleTheme(globalVars)
  chooseColorTheme(globalVars)
  addSeparator()
  chooseCursorTrail(globalVars)
  chooseCursorTrailShape(globalVars)
  chooseEffectFPS(globalVars)
  chooseCursorTrailPoints(globalVars)
  chooseCursorShapeSize(globalVars)
  chooseSnakeSpringConstant(globalVars)
  chooseCursorTrailGhost(globalVars)
  addSeparator()
  imgui.PopItemWidth()
  chooseDrawCapybara(globalVars)
  imgui.SameLine(0, RADIO_BUTTON_SPACING)
  chooseDrawCapybara2(globalVars)
  chooseDrawCapybara312(globalVars)
  addSeparator()
  choosePulseCoefficient(globalVars)
  _, globalVars.useCustomPulseColor = imgui.Checkbox("Use Custom Color?", globalVars.useCustomPulseColor)
  if (not globalVars.useCustomPulseColor) then imgui.BeginDisabled() end
  imgui.SameLine(0, SAMELINE_SPACING)
  if (imgui.Button("Edit Color")) then
    state.SetValue("showColorPicker", true)
  end
  if (state.GetValue("showColorPicker")) then
    choosePulseColor(globalVars)
  end
  if (not globalVars.useCustomPulseColor) then
    imgui.EndDisabled()
    state.SetValue("showColorPicker", false)
  end
end
