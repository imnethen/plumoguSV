function showCustomThemeSettings(globalVars)
  local settingsChanged = false
  if (imgui.Button("Reset")) then
    globalVars.customStyle = table.duplicate(DEFAULT_STYLE)
    saveAndSyncGlobals(globalVars)
  end
  imgui.SameLine()
  if (imgui.Button("Import")) then
    state.SetValue("importingCustomTheme", true)
  end
  if (imgui.Button("Export")) then
    local str = stringifyCustomInput(globalVars.customInput)
    imgui.SetClipboardText(str)
  end
  settingsChanged = colorInput(globalVars.customStyle, "windowBg", "Window BG") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "popupBg", "Popup BG") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "frameBg", "Frame BG") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "frameBgHovered", "Frame BG\n(Hovered)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "frameBgActive", "Frame BG\n(Active)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "titleBg", "Title BG") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "titleBgActive", "Title BG\n(Active)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "titleBgCollapsed", "Title BG\n(Collapsed)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "checkMark", "Checkmark") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "sliderGrab", "Slider Grab") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "sliderGrabActive", "Slider Grab\n(Active)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "button", "Button") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "buttonHovered", "Button\n(Hovered)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "buttonActive", "Button\n(Active)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "tab", "Tab") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "tabHovered", "Tab\n(Hovered)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "tabActive", "Tab\n(Active)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "header", "Header") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "headerHovered", "Header\n(Hovered)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "headerActive", "Header\n(Active)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "separator", "Separator") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "text", "Text") or
      settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "textSelectedBg", "Text Selected\n(BG)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "scrollbarGrab", "Scrollbar Grab") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "scrollbarGrabHovered", "Scrollbar Grab\n(Hovered)") or
  settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "scrollbarGrabActive", "Scrollbar Grab\n(Active)") or
  settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "plotLines", "Plot Lines") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "plotLinesHovered", "Plot Lines\n(Hovered)") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "plotHistogram", "Plot Histogram") or settingsChanged
  settingsChanged = colorInput(globalVars.customStyle, "plotHistogramHovered", "Plot Histogram\n(Hovered)") or
  settingsChanged
  if (settingsChanged) then
    saveAndSyncGlobals(globalVars)
  end
end

function stringifyCustomInput(customStyle)
  local keys = table.keys(customStyle)
  local resultStr = ""

  for _, key in pairs(keys) do
    local value = customStyle[key]
    if (key:lower() == key) then
      keyId = key:sub(1, 1) .. key:sub(-1)
    else
      keyId = key:sub(1, 1)
      for char in key:gmatch("%u") do
        keyId = keyId .. char
      end
    end
    local r = math.floor(value.x * 255)
    local g = math.floor(value.y * 255)
    local b = math.floor(value.z * 255)
    local a = math.floor(value.w * 255)
    resultStr = resultStr .. keyId .. ":" .. rgbaToHexa(r, g, b, a) .. ","
  end

  return resultStr
end
