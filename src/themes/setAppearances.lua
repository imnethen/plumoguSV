function setPluginAppearance(globalVars)
    local colorTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local styleTheme = STYLE_THEMES[globalVars.styleThemeIndex]

    setPluginAppearanceStyles(styleTheme)
    setPluginAppearanceColors(colorTheme, globalVars)
end

-- Configures the plugin GUI styles
-- Parameters
--    styleTheme : name of the desired style theme [String]
function setPluginAppearanceStyles(styleTheme)
    local cornerRoundnessValue = (styleTheme == "Boxed" or
        styleTheme == "Boxed + Border") and 0 or 5 -- up to 12, 14 for WindowRounding and 16 for ChildRounding

    local borderSize = (styleTheme == "Rounded + Border" or
        styleTheme == "Boxed + Border") and 1 or 0

    imgui.PushStyleVar(imgui_style_var.FrameBorderSize, borderSize)
    imgui.PushStyleVar(imgui_style_var.WindowPadding, vector.New(PADDING_WIDTH, 8))
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushStyleVar(imgui_style_var.ItemSpacing, vector.New(DEFAULT_WIDGET_HEIGHT / 2 - 1, 4))
    imgui.PushStyleVar(imgui_style_var.ItemInnerSpacing, vector.New(SAMELINE_SPACING, 6))
    imgui.PushStyleVar(imgui_style_var.WindowRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.ChildRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.FrameRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.GrabRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.ScrollbarRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.TabRounding, cornerRoundnessValue)

    -- Doesn't work even though TabBorderSize is changeable in the style editor demo
    -- imgui.PushStyleVar( imgui_style_var.TabBorderSize,      borderSize           )

    -- https://github.com/ocornut/imgui/issues/7297
    -- Apparently TabBorderSize doesn't have a imgui_style_var, so it can only be changed with
    -- imgui.GetStyle() which hasn't worked from my testing in Quaver plugins
end

-- Configures the plugin GUI colors
-- Parameters
--    colorTheme : currently selected color theme [String]
--    rgbPeriod  : length in seconds of one RGB color cycle [Int/Float]
function setPluginAppearanceColors(colorTheme, globalVars)
    local borderColor = vector4(1)

    if colorTheme == "Classic" then borderColor = setClassicColors() end
    if colorTheme == "Strawberry" then borderColor = setStrawberryColors() end
    if colorTheme == "Amethyst" then borderColor = setAmethystColors() end
    if colorTheme == "Tree" then borderColor = setTreeColors() end
    if colorTheme == "Barbie" then borderColor = setBarbieColors() end
    if colorTheme == "Incognito" then borderColor = setIncognitoColors() end
    if colorTheme == "Incognito + RGB" then borderColor = setIncognitoRGBColors(globalVars.rgbPeriod) end
    if colorTheme == "Tobi's Glass" then borderColor = setTobiGlassColors() end
    if colorTheme == "Tobi's RGB Glass" then borderColor = setTobiRGBGlassColors(globalVars.rgbPeriod) end
    if colorTheme == "Glass" then borderColor = setGlassColors() end
    if colorTheme == "Glass + RGB" then borderColor = setGlassRGBColors(globalVars.rgbPeriod) end
    if colorTheme == "RGB Gamer Mode" then borderColor = setRGBGamerColors(globalVars.rgbPeriod) end
    if colorTheme == "edom remag BGR" then borderColor = setInvertedRGBGamerColors(globalVars.rgbPeriod) end
    if colorTheme == "BGR + otingocnI" then borderColor = setInvertedIncognitoRGBColors(globalVars.rgbPeriod) end
    if colorTheme == "otingocnI" then borderColor = setInvertedIncognitoColors() end
    if colorTheme == "CUSTOM" then borderColor = setCustomColors(globalVars) end

    state.SetValue("global_baseBorderColor", borderColor)
end
