DEFAULT_HOTKEY_LIST = { "T", "Shift+T", "S", "N", "R", "B", "M" }
GLOBAL_HOTKEY_LIST = DEFAULT_HOTKEY_LIST
HOTKEY_LABELS = { "Execute Primary Action", "Execute Secondary Action", "Swap Primary Inputs",
    "Negate Primary Inputs", "Reset Secondary Input", "Go To Previous Scroll Group", "Go To Next Scroll Group" }

imgui_disable_vector_packing = true

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
        hideAutomatic = state.GetValue("global_hideAutomatic", false),
        pulseCoefficient = state.GetValue("global_pulseCoefficient", 0),
        pulseColor = state.GetValue("global_pulseColor", vector4(1)),
        useCustomPulseColor = state.GetValue("global_useCustomPulseColor", false),
        hotkeyList = state.GetValue("global_hotkeyList", DEFAULT_HOTKEY_LIST)
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

    local timeOffset = 50 -- [`state.SongTime`](lua://state.SongTime) isn't entirely accurate while the song is playing, so this aims to correct that.

    local timeSinceLastPulse = ((state.SongTime + timeOffset) - getTimingPointAt(state.SongTime).StartTime) %
        ((60000 / getTimingPointAt(state.SongTime).Bpm))

    if ((timeSinceLastPulse < prevVal)) then
        colStatus = 1
    else
        colStatus = (colStatus - state.DeltaTime / (60000 / getTimingPointAt(state.SongTime).Bpm))
    end

    local futureTime = state.SongTime + state.DeltaTime * 2 + timeOffset

    if ((futureTime - getTimingPointAt(futureTime).StartTime) < 0) then
        colStatus = 0
    end

    state.SetValue("colStatus", math.max(colStatus, 0))
    state.SetValue("prevVal", timeSinceLastPulse)

    colStatus = colStatus * globalVars
        .pulseCoefficient

    local borderColor = state.GetValue("global_baseBorderColor", vector4(1))
    local negatedBorderColor = vector4(1) - borderColor

    local pulseColor = globalVars.useCustomPulseColor and globalVars.pulseColor or negatedBorderColor

    imgui.PushStyleColor(imgui_col.Border, pulseColor * colStatus + borderColor * (1 - colStatus))
end
