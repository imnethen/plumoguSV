-- Configures the plugin GUI appearance
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function setPluginAppearance(globalVars)
    local colorTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local styleTheme = STYLE_THEMES[globalVars.styleThemeIndex]

    setPluginAppearanceStyles(styleTheme)
    setPluginAppearanceColors(colorTheme, globalVars.rgbPeriod)
end

-- Configures the plugin GUI styles
-- Parameters
--    styleTheme : name of the desired style theme [String]
function setPluginAppearanceStyles(styleTheme)
    local boxedStyle = styleTheme == "Boxed" or
        styleTheme == "Boxed + Border"
    local cornerRoundnessValue = 5 -- up to 12, 14 for WindowRounding and 16 for ChildRounding
    if boxedStyle then cornerRoundnessValue = 0 end

    local borderedStyle = styleTheme == "Rounded + Border" or
        styleTheme == "Boxed + Border"
    local borderSize = 0
    if borderedStyle then borderSize = 1 end

    imgui.PushStyleVar(imgui_style_var.FrameBorderSize, borderSize)
    imgui.PushStyleVar(imgui_style_var.WindowPadding, { PADDING_WIDTH, 8 })
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushStyleVar(imgui_style_var.ItemSpacing, { DEFAULT_WIDGET_HEIGHT / 2 - 1, 4 })
    imgui.PushStyleVar(imgui_style_var.ItemInnerSpacing, { SAMELINE_SPACING, 6 })
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