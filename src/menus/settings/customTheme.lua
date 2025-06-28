function showCustomThemeSettings(globalVars)
  local settingsChanged = false
  if (imgui.Button("Reset")) then
    globalVars.customInput = {}
    saveAndSyncGlobals(globalVars)
  end
  settingsChanged = colorInput(globalVars.customInput, "windowBg", "Window BG", vector.New(0.00, 0.00, 0.00, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "popupBg", "Popup BG", vector.New(0.08, 0.08, 0.08, 0.94)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "frameBg", "Frame BG", vector.New(0.14, 0.24, 0.28, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "frameBgHovered", "Frame BG\n(Hovered)",
    vector.New(0.24, 0.34, 0.38, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "frameBgActive", "Frame BG\n(Active)",
    vector.New(0.29, 0.39, 0.43, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "titleBg", "Title BG", vector.New(0.14, 0.24, 0.28, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "titleBgActive", "Title BG\n(Active)",
    vector.New(0.51, 0.58, 0.75, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "titleBgCollapsed", "Title BG\n(Collapsed)",
    vector.New(0.51, 0.58, 0.75, 0.50)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "checkMark", "Checkmark", vector.New(0.81, 0.88, 1.00, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "sliderGrab", "Slider Grab",
    vector.New(0.56, 0.63, 0.75, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "sliderGrabActive", "Slider Grab\n(Active)",
    vector.New(0.61, 0.68, 0.80, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "button", "Button", vector.New(0.31, 0.38, 0.50, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "buttonHovered", "Button\n(Hovered)",
    vector.New(0.41, 0.48, 0.60, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "buttonActive", "Button\n(Active)",
    vector.New(0.51, 0.58, 0.70, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "tab", "Tab", vector.New(0.31, 0.38, 0.50, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "tabHovered", "Tab\n(Hovered)",
    vector.New(0.51, 0.58, 0.75, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "tabActive", "Tab\n(Active)",
    vector.New(0.51, 0.58, 0.75, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "header", "Header", vector.New(0.81, 0.88, 1.00, 0.40)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "headerHovered", "Header\n(Hovered)",
    vector.New(0.81, 0.88, 1.00, 0.50)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "headerActive", "Header\n(Active)",
    vector.New(0.81, 0.88, 1.00, 0.54)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "separator", "Separator", vector.New(0.81, 0.88, 1.00, 0.30)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "text", "Text", vector.New(1.00, 1.00, 1.00, 1.00)) or
      settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "textSelectedBg", "Text Selected\n(BG)",
    vector.New(0.81, 0.88, 1.00, 0.40)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "scrollbarGrab", "Scrollbar Grab",
    vector.New(0.31, 0.38, 0.50, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "scrollbarGrabHovered", "Scrollbar Grab\n(Hovered)",
    vector.New(0.41, 0.48, 0.60, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "scrollbarGrabActive", "Scrollbar Grab\n(Active)",
    vector.New(0.51, 0.58, 0.70, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "plotLines", "Plot Lines",
    vector.New(0.61, 0.61, 0.61, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "plotLinesHovered", "Plot Lines\n(Hovered)",
    vector.New(1.00, 0.43, 0.35, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "plotHistogram", "Plot Histogram",
    vector.New(0.90, 0.70, 0.00, 1.00)) or settingsChanged
  settingsChanged = colorInput(globalVars.customInput, "plotHistogramHovered", "Plot Histogram\n(Hovered)",
    vector.New(1.00, 0.60, 0.00, 1.00)) or settingsChanged
  if (settingsChanged) then
    saveAndSyncGlobals(globalVars)
  end
end
