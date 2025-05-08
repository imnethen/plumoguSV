
-- Configures the plugin GUI colors
-- Parameters
--    colorTheme : currently selected color theme [String]
--    rgbPeriod  : length in seconds of one RGB color cycle [Int/Float]
function setPluginAppearanceColors(colorTheme, rgbPeriod)
    if colorTheme == "Classic" then setClassicColors() end
    if colorTheme == "Strawberry" then setStrawberryColors() end
    if colorTheme == "Amethyst" then setAmethystColors() end
    if colorTheme == "Tree" then setTreeColors() end
    if colorTheme == "Barbie" then setBarbieColors() end
    if colorTheme == "Incognito" then setIncognitoColors() end
    if colorTheme == "Incognito + RGB" then setIncognitoRGBColors(rgbPeriod) end
    if colorTheme == "Tobi's Glass" then setTobiGlassColors() end
    if colorTheme == "Tobi's RGB Glass" then setTobiRGBGlassColors(rgbPeriod) end
    if colorTheme == "Glass" then setGlassColors() end
    if colorTheme == "Glass + RGB" then setGlassRGBColors(rgbPeriod) end
    if colorTheme == "RGB Gamer Mode" then setRGBGamerColors(rgbPeriod) end
    if colorTheme == "edom remag BGR" then setInvertedRGBGamerColors(rgbPeriod) end
    if colorTheme == "BGR + otingocnI" then setInvertedIncognitoRGBColors(rgbPeriod) end
    if colorTheme == "otingocnI" then setInvertedIncognitoColors() end
end

-- Sets plugin colors to the "Classic" theme
function setClassicColors()
    imgui.PushStyleColor(imgui_col.WindowBg, { 0.00, 0.00, 0.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, { 0.81, 0.88, 1.00, 0.30 })
    imgui.PushStyleColor(imgui_col.FrameBg, { 0.14, 0.24, 0.28, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgHovered, { 0.24, 0.34, 0.38, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgActive, { 0.29, 0.39, 0.43, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBg, { 0.41, 0.48, 0.65, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgActive, { 0.51, 0.58, 0.75, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, { 0.51, 0.58, 0.75, 0.50 })
    imgui.PushStyleColor(imgui_col.CheckMark, { 0.81, 0.88, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrab, { 0.56, 0.63, 0.75, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrabActive, { 0.61, 0.68, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.Button, { 0.31, 0.38, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonHovered, { 0.41, 0.48, 0.60, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonActive, { 0.51, 0.58, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.Tab, { 0.31, 0.38, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.TabHovered, { 0.51, 0.58, 0.75, 1.00 })
    imgui.PushStyleColor(imgui_col.TabActive, { 0.51, 0.58, 0.75, 1.00 })
    imgui.PushStyleColor(imgui_col.Header, { 0.81, 0.88, 1.00, 0.40 })
    imgui.PushStyleColor(imgui_col.HeaderHovered, { 0.81, 0.88, 1.00, 0.50 })
    imgui.PushStyleColor(imgui_col.HeaderActive, { 0.81, 0.88, 1.00, 0.54 })
    imgui.PushStyleColor(imgui_col.Separator, { 0.81, 0.88, 1.00, 0.30 })
    imgui.PushStyleColor(imgui_col.Text, { 1.00, 1.00, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.TextSelectedBg, { 0.81, 0.88, 1.00, 0.40 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, { 0.31, 0.38, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, { 0.41, 0.48, 0.60, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, { 0.51, 0.58, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLines, { 0.61, 0.61, 0.61, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, { 1.00, 0.43, 0.35, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogram, { 0.90, 0.70, 0.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, { 1.00, 0.60, 0.00, 1.00 })
end

-- Sets plugin colors to the "Strawberry" theme
function setStrawberryColors()
    imgui.PushStyleColor(imgui_col.WindowBg, { 0.00, 0.00, 0.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, { 1.00, 0.81, 0.88, 0.30 })
    imgui.PushStyleColor(imgui_col.FrameBg, { 0.28, 0.14, 0.24, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgHovered, { 0.38, 0.24, 0.34, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgActive, { 0.43, 0.29, 0.39, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBg, { 0.65, 0.41, 0.48, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgActive, { 0.75, 0.51, 0.58, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, { 0.75, 0.51, 0.58, 0.50 })
    imgui.PushStyleColor(imgui_col.CheckMark, { 1.00, 0.81, 0.88, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrab, { 0.75, 0.56, 0.63, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrabActive, { 0.80, 0.61, 0.68, 1.00 })
    imgui.PushStyleColor(imgui_col.Button, { 0.50, 0.31, 0.38, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonHovered, { 0.60, 0.41, 0.48, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonActive, { 0.70, 0.51, 0.58, 1.00 })
    imgui.PushStyleColor(imgui_col.Tab, { 0.50, 0.31, 0.38, 1.00 })
    imgui.PushStyleColor(imgui_col.TabHovered, { 0.75, 0.51, 0.58, 1.00 })
    imgui.PushStyleColor(imgui_col.TabActive, { 0.75, 0.51, 0.58, 1.00 })
    imgui.PushStyleColor(imgui_col.Header, { 1.00, 0.81, 0.88, 0.40 })
    imgui.PushStyleColor(imgui_col.HeaderHovered, { 1.00, 0.81, 0.88, 0.50 })
    imgui.PushStyleColor(imgui_col.HeaderActive, { 1.00, 0.81, 0.88, 0.54 })
    imgui.PushStyleColor(imgui_col.Separator, { 1.00, 0.81, 0.88, 0.30 })
    imgui.PushStyleColor(imgui_col.Text, { 1.00, 1.00, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.TextSelectedBg, { 1.00, 0.81, 0.88, 0.40 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, { 0.50, 0.31, 0.38, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, { 0.60, 0.41, 0.48, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, { 0.70, 0.51, 0.58, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLines, { 0.61, 0.61, 0.61, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, { 1.00, 0.43, 0.35, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogram, { 0.90, 0.70, 0.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, { 1.00, 0.60, 0.00, 1.00 })
end

-- Sets plugin colors to the "Amethyst" theme
function setAmethystColors()
    imgui.PushStyleColor(imgui_col.WindowBg, { 0.16, 0.00, 0.20, 1.00 })
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, { 0.90, 0.00, 0.81, 0.30 })
    imgui.PushStyleColor(imgui_col.FrameBg, { 0.40, 0.20, 0.40, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgHovered, { 0.50, 0.30, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgActive, { 0.55, 0.35, 0.55, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBg, { 0.31, 0.11, 0.35, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgActive, { 0.41, 0.21, 0.45, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, { 0.41, 0.21, 0.45, 0.50 })
    imgui.PushStyleColor(imgui_col.CheckMark, { 1.00, 0.80, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrab, { 0.95, 0.75, 0.95, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrabActive, { 1.00, 0.80, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.Button, { 0.60, 0.40, 0.60, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonHovered, { 0.70, 0.50, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonActive, { 0.80, 0.60, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.Tab, { 0.50, 0.30, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.TabHovered, { 0.70, 0.50, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.TabActive, { 0.70, 0.50, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.Header, { 1.00, 0.80, 1.00, 0.40 })
    imgui.PushStyleColor(imgui_col.HeaderHovered, { 1.00, 0.80, 1.00, 0.50 })
    imgui.PushStyleColor(imgui_col.HeaderActive, { 1.00, 0.80, 1.00, 0.54 })
    imgui.PushStyleColor(imgui_col.Separator, { 1.00, 0.80, 1.00, 0.30 })
    imgui.PushStyleColor(imgui_col.Text, { 1.00, 1.00, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.TextSelectedBg, { 1.00, 0.80, 1.00, 0.40 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, { 0.60, 0.40, 0.60, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, { 0.70, 0.50, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, { 0.80, 0.60, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLines, { 1.00, 0.80, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, { 1.00, 0.70, 0.30, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogram, { 1.00, 0.80, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, { 1.00, 0.70, 0.30, 1.00 })
end

-- Sets plugin colors to the "Tree" theme
function setTreeColors()
    imgui.PushStyleColor(imgui_col.WindowBg, { 0.20, 0.16, 0.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, { 0.81, 0.90, 0.00, 0.30 })
    imgui.PushStyleColor(imgui_col.FrameBg, { 0.40, 0.40, 0.20, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgHovered, { 0.50, 0.50, 0.30, 1.00 })
    imgui.PushStyleColor(imgui_col.FrameBgActive, { 0.55, 0.55, 0.35, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBg, { 0.35, 0.31, 0.11, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgActive, { 0.45, 0.41, 0.21, 1.00 })
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, { 0.45, 0.41, 0.21, 0.50 })
    imgui.PushStyleColor(imgui_col.CheckMark, { 1.00, 1.00, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrab, { 0.95, 0.95, 0.75, 1.00 })
    imgui.PushStyleColor(imgui_col.SliderGrabActive, { 1.00, 1.00, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.Button, { 0.60, 0.60, 0.40, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonHovered, { 0.70, 0.70, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.ButtonActive, { 0.80, 0.80, 0.60, 1.00 })
    imgui.PushStyleColor(imgui_col.Tab, { 0.50, 0.50, 0.30, 1.00 })
    imgui.PushStyleColor(imgui_col.TabHovered, { 0.70, 0.70, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.TabActive, { 0.70, 0.70, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.Header, { 1.00, 1.00, 0.80, 0.40 })
    imgui.PushStyleColor(imgui_col.HeaderHovered, { 1.00, 1.00, 0.80, 0.50 })
    imgui.PushStyleColor(imgui_col.HeaderActive, { 1.00, 1.00, 0.80, 0.54 })
    imgui.PushStyleColor(imgui_col.Separator, { 1.00, 1.00, 0.80, 0.30 })
    imgui.PushStyleColor(imgui_col.Text, { 1.00, 1.00, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.TextSelectedBg, { 1.00, 1.00, 0.80, 0.40 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, { 0.60, 0.60, 0.40, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, { 0.70, 0.70, 0.50, 1.00 })
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, { 0.80, 0.80, 0.60, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLines, { 1.00, 1.00, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, { 0.30, 1.00, 0.70, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogram, { 1.00, 1.00, 0.80, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, { 0.30, 1.00, 0.70, 1.00 })
end

-- Sets plugin colors to the "Barbie" theme
function setBarbieColors()
    local pink = { 0.79, 0.31, 0.55, 1.00 }
    local white = { 0.95, 0.85, 0.87, 1.00 }
    local blue = { 0.37, 0.64, 0.84, 1.00 }
    local pinkTint = { 1.00, 0.86, 0.86, 0.40 }

    imgui.PushStyleColor(imgui_col.WindowBg, pink)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, pinkTint)
    imgui.PushStyleColor(imgui_col.FrameBg, blue)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, pinkTint)
    imgui.PushStyleColor(imgui_col.TitleBg, blue)
    imgui.PushStyleColor(imgui_col.TitleBgActive, blue)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, pink)
    imgui.PushStyleColor(imgui_col.CheckMark, blue)
    imgui.PushStyleColor(imgui_col.SliderGrab, blue)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Button, blue)
    imgui.PushStyleColor(imgui_col.ButtonHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Tab, blue)
    imgui.PushStyleColor(imgui_col.TabHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.TabActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Header, blue)
    imgui.PushStyleColor(imgui_col.HeaderHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Separator, pinkTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, pinkTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, pinkTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, white)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, white)
    imgui.PushStyleColor(imgui_col.PlotLines, pink)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.PlotHistogram, pink)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, pinkTint)
end

-- Sets plugin colors to the "Incognito" theme
function setIncognitoColors()
    local black = { 0.00, 0.00, 0.00, 1.00 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local grey = { 0.20, 0.20, 0.20, 1.00 }
    local whiteTint = { 1.00, 1.00, 1.00, 0.40 }
    local red = { 1.00, 0.00, 0.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, black)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, whiteTint)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, black)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Separator, whiteTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, white)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, white)
    imgui.PushStyleColor(imgui_col.PlotLines, white)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, red)
    imgui.PushStyleColor(imgui_col.PlotHistogram, white)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, red)
end

-- Sets plugin colors to the "Incognito + RGB" theme
-- Parameters
--    rgbPeriod : length in seconds of one RGB color cycle [Int/Float]
function setIncognitoRGBColors(rgbPeriod)
    local black = { 0.00, 0.00, 0.00, 1.00 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local grey = { 0.20, 0.20, 0.20, 1.00 }
    local whiteTint = { 1.00, 1.00, 1.00, 0.40 }
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local rgbColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.8 }

    imgui.PushStyleColor(imgui_col.WindowBg, black)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, rgbColor)
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, rgbColor)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, black)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Separator, rgbColor)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, rgbColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, white)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotLines, white)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotHistogram, white)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, rgbColor)
end

-- Sets plugin colors to the "Tobi's Glass" theme
function setTobiGlassColors()
    local transparentBlack = { 0.00, 0.00, 0.00, 0.70 }
    local transparentWhite = { 0.30, 0.30, 0.30, 0.50 }
    local whiteTint = { 1.00, 1.00, 1.00, 0.30 }
    local buttonColor = { 0.14, 0.24, 0.28, 0.80 }
    local frameColor = { 0.24, 0.34, 0.38, 1.00 }
    local white = { 1.00, 1.00, 1.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, frameColor)
    imgui.PushStyleColor(imgui_col.FrameBg, buttonColor)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, whiteTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparentBlack)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, frameColor)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, buttonColor)
    imgui.PushStyleColor(imgui_col.Button, buttonColor)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Tab, transparentBlack)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Header, transparentBlack)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Separator, whiteTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotLines, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotHistogram, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, transparentWhite)
end

-- Sets plugin colors to the "Tobi's RGB Glass" theme
-- Parameters
--    rgbPeriod : length in seconds of one RGB color cycle [Int/Float]
function setTobiRGBGlassColors(rgbPeriod)
    local transparent = { 0.00, 0.00, 0.00, 0.85 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.8 }
    local colorTint = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.3 }

    imgui.PushStyleColor(imgui_col.WindowBg, transparent)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, activeColor)
    imgui.PushStyleColor(imgui_col.FrameBg, transparent)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, colorTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, colorTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparent)
    imgui.PushStyleColor(imgui_col.CheckMark, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrab, colorTint)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Button, transparent)
    imgui.PushStyleColor(imgui_col.ButtonHovered, colorTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, colorTint)
    imgui.PushStyleColor(imgui_col.Tab, transparent)
    imgui.PushStyleColor(imgui_col.TabHovered, colorTint)
    imgui.PushStyleColor(imgui_col.TabActive, colorTint)
    imgui.PushStyleColor(imgui_col.Header, transparent)
    imgui.PushStyleColor(imgui_col.HeaderHovered, colorTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, colorTint)
    imgui.PushStyleColor(imgui_col.Separator, colorTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, colorTint)
    imgui.PushStyleColor(imgui_col.PlotHistogram, activeColor)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, colorTint)
end

-- Sets plugin colors to the "Glass" theme
function setGlassColors()
    local transparentBlack = { 0.00, 0.00, 0.00, 0.25 }
    local transparentWhite = { 1.00, 1.00, 1.00, 0.70 }
    local whiteTint = { 1.00, 1.00, 1.00, 0.30 }
    local white = { 1.00, 1.00, 1.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, transparentWhite)
    imgui.PushStyleColor(imgui_col.FrameBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, whiteTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparentBlack)
    imgui.PushStyleColor(imgui_col.CheckMark, transparentWhite)
    imgui.PushStyleColor(imgui_col.SliderGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, transparentWhite)
    imgui.PushStyleColor(imgui_col.Button, transparentBlack)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Tab, transparentBlack)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Header, transparentBlack)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Separator, whiteTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotLines, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotHistogram, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, transparentWhite)
end

-- Sets plugin colors to the "Glass + RGB" theme
-- Parameters
--    rgbPeriod : length in seconds of one RGB color cycle [Int/Float]
function setGlassRGBColors(rgbPeriod)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.8 }
    local colorTint = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.3 }
    local transparent = { 0.00, 0.00, 0.00, 0.25 }
    local white = { 1.00, 1.00, 1.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, transparent)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, activeColor)
    imgui.PushStyleColor(imgui_col.FrameBg, transparent)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, colorTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, colorTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparent)
    imgui.PushStyleColor(imgui_col.CheckMark, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrab, colorTint)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Button, transparent)
    imgui.PushStyleColor(imgui_col.ButtonHovered, colorTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, colorTint)
    imgui.PushStyleColor(imgui_col.Tab, transparent)
    imgui.PushStyleColor(imgui_col.TabHovered, colorTint)
    imgui.PushStyleColor(imgui_col.TabActive, colorTint)
    imgui.PushStyleColor(imgui_col.Header, transparent)
    imgui.PushStyleColor(imgui_col.HeaderHovered, colorTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, colorTint)
    imgui.PushStyleColor(imgui_col.Separator, colorTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, colorTint)
    imgui.PushStyleColor(imgui_col.PlotHistogram, activeColor)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, colorTint)
end

-- Sets plugin colors to the "RGB Gamer Mode" theme
-- Parameters
--    rgbPeriod : length in seconds of one RGB color cycle [Int/Float]
function setRGBGamerColors(rgbPeriod)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.8 }
    local inactiveColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.5 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local clearWhite = { 1.00, 1.00, 1.00, 0.40 }
    local black = { 0.00, 0.00, 0.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, black)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.08, 0.08, 0.08, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, inactiveColor)
    imgui.PushStyleColor(imgui_col.FrameBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, activeColor)
    imgui.PushStyleColor(imgui_col.FrameBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.TitleBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, inactiveColor)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, white)
    imgui.PushStyleColor(imgui_col.Button, inactiveColor)
    imgui.PushStyleColor(imgui_col.ButtonHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ButtonActive, activeColor)
    imgui.PushStyleColor(imgui_col.Tab, inactiveColor)
    imgui.PushStyleColor(imgui_col.TabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.TabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Header, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderHovered, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderActive, activeColor)
    imgui.PushStyleColor(imgui_col.Separator, inactiveColor)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, clearWhite)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, inactiveColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, { 0.61, 0.61, 0.61, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, { 1.00, 0.43, 0.35, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogram, { 0.90, 0.70, 0.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, { 1.00, 0.60, 0.00, 1.00 })
end

-- Sets plugin colors to the "edom remag BGR" theme
-- Parameters
--    rgbPeriod : length in seconds of one RGB color cycle [Int/Float]
function setInvertedRGBGamerColors(rgbPeriod)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.8 }
    local inactiveColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.5 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local clearBlack = { 0.00, 0.00, 0.00, 0.40 }
    local black = { 0.00, 0.00, 0.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, white)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.92, 0.92, 0.92, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, inactiveColor)
    imgui.PushStyleColor(imgui_col.FrameBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, activeColor)
    imgui.PushStyleColor(imgui_col.FrameBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.TitleBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, inactiveColor)
    imgui.PushStyleColor(imgui_col.CheckMark, black)
    imgui.PushStyleColor(imgui_col.SliderGrab, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, black)
    imgui.PushStyleColor(imgui_col.Button, inactiveColor)
    imgui.PushStyleColor(imgui_col.ButtonHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ButtonActive, activeColor)
    imgui.PushStyleColor(imgui_col.Tab, inactiveColor)
    imgui.PushStyleColor(imgui_col.TabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.TabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Header, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderHovered, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderActive, activeColor)
    imgui.PushStyleColor(imgui_col.Separator, inactiveColor)
    imgui.PushStyleColor(imgui_col.Text, black)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, clearBlack)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, inactiveColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, { 0.39, 0.39, 0.39, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, { 0.00, 0.57, 0.65, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogram, { 0.10, 0.30, 1.00, 1.00 })
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, { 0.00, 0.40, 1.00, 1.00 })
end

-- Sets plugin colors to the "BGR + otingocnI" theme
-- Parameters
--    rgbPeriod : length in seconds of one RGB color cycle [Int/Float]
function setInvertedIncognitoRGBColors(rgbPeriod)
    local black = { 0.00, 0.00, 0.00, 1.00 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local grey = { 0.80, 0.80, 0.80, 1.00 }
    local blackTint = { 0.00, 0.00, 0.00, 0.40 }
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local rgbColor = { currentRGB.red, currentRGB.green, currentRGB.blue, 0.8 }

    imgui.PushStyleColor(imgui_col.WindowBg, white)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.92, 0.92, 0.92, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, rgbColor)
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, blackTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, rgbColor)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, white)
    imgui.PushStyleColor(imgui_col.CheckMark, black)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, blackTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, blackTint)
    imgui.PushStyleColor(imgui_col.TabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, blackTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Separator, rgbColor)
    imgui.PushStyleColor(imgui_col.Text, black)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, rgbColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, blackTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, black)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotLines, black)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotHistogram, black)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, rgbColor)
end

-- Sets plugin colors to the "otingocnI" theme
function setInvertedIncognitoColors()
    local black = { 0.00, 0.00, 0.00, 1.00 }
    local white = { 1.00, 1.00, 1.00, 1.00 }
    local grey = { 0.80, 0.80, 0.80, 1.00 }
    local blackTint = { 0.00, 0.00, 0.00, 0.40 }
    local notRed = { 0.00, 1.00, 1.00, 1.00 }

    imgui.PushStyleColor(imgui_col.WindowBg, white)
    imgui.PushStyleColor(imgui_col.PopupBg, { 0.92, 0.92, 0.92, 0.94 })
    imgui.PushStyleColor(imgui_col.Border, blackTint)
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, blackTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, blackTint)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, white)
    imgui.PushStyleColor(imgui_col.CheckMark, black)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, blackTint)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, blackTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, blackTint)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, blackTint)
    imgui.PushStyleColor(imgui_col.TabActive, blackTint)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, blackTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, blackTint)
    imgui.PushStyleColor(imgui_col.Separator, blackTint)
    imgui.PushStyleColor(imgui_col.Text, black)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, blackTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, blackTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, black)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, black)
    imgui.PushStyleColor(imgui_col.PlotLines, black)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, notRed)
    imgui.PushStyleColor(imgui_col.PlotHistogram, black)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, notRed)
end

-- Returns the RGB colors based on the current time [Table]
-- Parameters
--    rgbPeriod : length in seconds for one complete RGB cycle (i.e. period) [Int/Float]
function getCurrentRGBColors(rgbPeriod)
    local currentTime = imgui.GetTime()
    local percentIntoRGBCycle = (currentTime % rgbPeriod) / rgbPeriod
    local stagesElapsed = 6 * percentIntoRGBCycle
    local currentStageNumber = math.floor(stagesElapsed)
    local percentIntoStage = clampToInterval(stagesElapsed - currentStageNumber, 0, 1)

    local red = 0
    local green = 0
    local blue = 0
    if currentStageNumber == 0 then
        green = 1 - percentIntoStage
        blue = 1
    elseif currentStageNumber == 1 then
        blue = 1
        red = percentIntoStage
    elseif currentStageNumber == 2 then
        blue = 1 - percentIntoStage
        red = 1
    elseif currentStageNumber == 3 then
        green = percentIntoStage
        red = 1
    elseif currentStageNumber == 4 then
        green = 1
        red = 1 - percentIntoStage
    else
        blue = percentIntoStage
        green = 1
    end
    return { red = red, green = green, blue = blue }
end