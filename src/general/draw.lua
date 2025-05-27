function draw()
    state.SetValue("computableInputFloatIndex", 1)

    local prevVal = state.GetValue("prevVal", 0)
    local colStatus = state.GetValue("colStatus", 0)

    local globalVars = {
        stepSize = state.GetValue("global_stepSize", 5),
        keyboardMode = state.GetValue("global_keyboardMode", false),
        dontReplaceSV = state.GetValue("global_dontReplaceSV", false),
        upscroll = state.GetValue("global_upscroll", false),
        colorThemeIndex = state.GetValue("global_colorThemeIndex", 9),
        styleThemeIndex = state.GetValue("global_styleThemeIndex", 1),
        effectFPS = state.GetValue("global_effectFPS", 90),
        cursorTrailIndex = state.GetValue("global_cursorTrailIndex", 1),
        cursorTrailShapeIndex = state.GetValue("global_cursorTrailShapeIndex", 1),
        cursorTrailPoints = state.GetValue("global_cursorTrailPoints", 10),
        cursorTrailSize = state.GetValue("global_cursorTrailSize", 5),
        snakeSpringConstant = state.GetValue("global_snakeSpringConstant", 1),
        cursorTrailGhost = state.GetValue("global_cursorTrailGhost", false),
        rgbPeriod = state.GetValue("global_rgbPeriod", 2),
        drawCapybara = state.GetValue("global_drawCapybara", false),
        drawCapybara2 = state.GetValue("global_drawCapybara2", false),
        drawCapybara312 = state.GetValue("global_drawCapybara312", false),
        selectTypeIndex = 1,
        placeTypeIndex = 1,
        editToolIndex = 1,
        showExportImportMenu = false,
        importData = "",
        exportCustomSVData = "",
        exportData = "",
        debugText = "debug",
        scrollGroupIndex = 1,
        showColorPicker = false,
        BETA_IGNORE_NOTES_OUTSIDE_TG = state.GetValue("global_ignoreNotes", false),
        advancedMode = state.GetValue("global_advancedMode", false),
        pulseCoefficient = state.GetValue("global_pulseCoefficient", 0),
        pulseColor = state.GetValue("global_pulseColor", { 1, 1, 1, 1 }),
        useCustomPulseColor = state.GetValue("global_useCustomPulseColor", false),
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

    local v1 = vector.New(1, 2, 3)
    local v2 = vector.New(1, 2)

    if (imgui.Button("hi")) then
        print(vector.Table(v2))
    end

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

    local borderColor = state.GetValue("global_baseBorderColor", { 1, 1, 1, 1 })
    local negatedBorderColor = { 1 - borderColor[1], 1 - borderColor[2], 1 - borderColor[3], 1 - borderColor[4] }

    local pulseColor = globalVars.useCustomPulseColor and globalVars.pulseColor or negatedBorderColor

    imgui.PushStyleColor(imgui_col.Border,
        { pulseColor[1] * colStatus + borderColor[1] * (1 - colStatus), pulseColor[2] * colStatus +
        borderColor[2] * (1 - colStatus), pulseColor[3] * colStatus + borderColor[3] * (1 - colStatus),
            1 })
end
