function draw()
    state.SetValue("computableInputFloatIndex", 1)

    local prevVal = state.GetValue("prevVal") or 0
    local colStatus = state.GetValue("colStatus") or 0

    local globalVars = {
        stepSize = state.GetValue("global_stepSize") or 5,
        keyboardMode = state.GetValue("global_keyboardMode") or false,
        dontReplaceSV = state.GetValue("global_dontReplaceSV") or false,
        upscroll = state.GetValue("global_upscroll") or false,
        colorThemeIndex = state.GetValue("global_colorThemeIndex") or 9,
        styleThemeIndex = state.GetValue("global_styleThemeIndex") or 1,
        effectFPS = state.GetValue("global_effectFPS") or 90,
        cursorTrailIndex = state.GetValue("global_cursorTrailIndex") or 1,
        cursorTrailShapeIndex = state.GetValue("global_cursorTrailShapeIndex") or 1,
        cursorTrailPoints = state.GetValue("global_cursorTrailPoints") or 10,
        cursorTrailSize = state.GetValue("global_cursorTrailSize") or 5,
        snakeSpringConstant = state.GetValue("global_snakeSpringConstant") or 1,
        cursorTrailGhost = state.GetValue("global_cursorTrailGhost") or false,
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
        advancedMode = state.GetValue("global_advancedMode") or false,
        pulseCoefficient = state.GetValue("global_pulseCoefficient") or 0
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

    imgui.Begin("plumoguSV-dev", imgui_window_flags.AlwaysAutoResize)
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

    local modTime = ((state.SongTime + 60) - getTimingPointAt(state.SongTime).StartTime) %
        ((60000 / getTimingPointAt(state.SongTime).Bpm))

    local frameTime = modTime - prevVal

    if ((modTime < prevVal)) then
        colStatus = 1
    else
        colStatus = (colStatus - frameTime / (60000 / getTimingPointAt(state.SongTime).Bpm))
    end


    if ((state.SongTime - getTimingPointAt(state.SongTime).StartTime) < 0) then
        colStatus = 0
    end

    state.SetValue("colStatus", math.max(colStatus, 0))
    state.SetValue("prevVal", modTime)

    colStatus = colStatus * globalVars
        .pulseCoefficient

    local borderColor = state.GetValue("global_baseBorderColor") or { 1, 1, 1, 1 }
    local negatedBorderColor = { 1 - borderColor[1], 1 - borderColor[2], 1 - borderColor[3], 1 - borderColor[4] }

    imgui.PushStyleColor(imgui_col.Border,
        { negatedBorderColor[1] * colStatus + borderColor[1] * (1 - colStatus), negatedBorderColor[2] * colStatus +
        borderColor[2] * (1 - colStatus), negatedBorderColor[3] * colStatus + borderColor[3] * (1 - colStatus),
            1 })
end
