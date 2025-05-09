function draw()
    local globalVars = {
        stepSize = state.GetValue("global_stepSize") or 5,
        keyboardMode = false,
        dontReplaceSV = false,
        upscroll = state.GetValue("global_upscroll") or false,
        colorThemeIndex = state.GetValue("global_colorThemeIndex") or 9,
        styleThemeIndex = state.GetValue("global_styleThemeIndex") or 1,
        effectFPS = state.GetValue("global_effectFPS") or 90,
        cursorTrailIndex = state.GetValue("global_cursorTrailIndex") or 1,
        cursorTrailShapeIndex = 1,
        cursorTrailPoints = state.GetValue("global_cursorTrailPoints") or 10,
        cursorTrailSize = state.GetValue("global_cursorTrailSize") or 5,
        snakeSpringConstant = 1,
        cursorTrailGhost = false,
        rgbPeriod = state.GetValue("global_rgbPeriod") or 2,
        drawCapybara = state.GetValue("global_drawCapybara") or false,
        drawCapybara2 = state.GetValue("global_drawCapybara2") or false,
        drawCapybara312 = state.GetValue("global_drawCapybara312") or false,
        selectTypeIndex = 1,
        placeTypeIndex = 1,
        editToolIndex = 1,
        showExportImportMenu = false,
        importData = "",
        exportCustomSVData = "",
        exportData = "",
        debugText = "debug",
        scrollGroupIndex = 1,
        BETA_IGNORE_NOTES_OUTSIDE_TG = state.GetValue("global_ignoreNotes") or false,
        advancedMode = state.GetValue("global_advancedMode") or false
    }

    getVariables("globalVars", globalVars)

    drawCapybara(globalVars)
    drawCapybara2(globalVars)
    drawCapybara312(globalVars)
    drawCursorTrail(globalVars)
    setPluginAppearance(globalVars)
    startNextWindowNotCollapsed("plumoguSVAutoOpen")
    focusWindowIfHotkeysPressed()
    centerWindowIfHotkeysPressed()

    imgui.Begin("plumoguSV", imgui_window_flags.AlwaysAutoResize)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    if globalVars.keyboardMode then
        imgui.BeginTabBar("Quick tabs")
        createQuickTabs(globalVars)
        imgui.EndTabBar()
    else
        imgui.BeginTabBar("SV tabs")
        for i = 1, #TAB_MENUS do
            createMenuTab(globalVars, TAB_MENUS[i])
        end
        imgui.EndTabBar()
    end
    state.IsWindowHovered = imgui.IsWindowHovered()
    imgui.End()

    saveVariables("globalVars", globalVars)

    local clockTime = 0.2
    if ((os.clock() or 0) - (state.GetValue("lastRecordedTime") or 0) >= clockTime) then
        state.SetValue("lastRecordedTime", os.clock() or 0)
        updateDirectEdit()
    end
end
