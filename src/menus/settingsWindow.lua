local DEFAULT_SETTING_TYPES = {
    "General",
    "Appearance",
    "Windows + Widgets",
    "Keybinds"
}


function showPluginSettingsWindow(globalVars)
    local bgColor = vector.New(0.2, 0.2, 0.2, 1)
    SETTING_TYPES = table.duplicate(DEFAULT_SETTING_TYPES)

    if (COLOR_THEMES[globalVars.colorThemeIndex] == "CUSTOM") then
        table.insert(SETTING_TYPES, 3, "Custom Theme")
    end

    imgui.PopStyleColor(20)
    setIncognitoColors()
    setPluginAppearanceStyles("Rounded + Border")
    imgui.PushStyleColor(imgui_col.WindowBg, bgColor)
    imgui.PushStyleColor(imgui_col.TitleBg, bgColor)
    imgui.PushStyleColor(imgui_col.TitleBgActive, bgColor)
    imgui.PushStyleColor(imgui_col.Border, vector4(1))
    imgui.SetNextWindowCollapsed(false)
    _, settingsOpened = imgui.Begin("plumoguSV Settings", true, 34)
    imgui.SetWindowSize("plumoguSV Settings", vector.New(433, 400))

    local typeIndex = state.GetValue("settings_typeIndex", 1)

    imgui.Columns(2, "Settings_ColumnList", true)
    imgui.BeginChild(420)
    imgui.Text("Setting Type")
    imgui.Separator()
    for idx, v in pairs(SETTING_TYPES) do
        if (imgui.Selectable(v, typeIndex == idx)) then
            typeIndex = idx
        end
    end
    addSeparator()
    if (imgui.Button("Reset Settings")) then
        saveAndSyncGlobals({})
        globalVars = loadGlobalVars()
        toggleablePrint("e!", "Settings have been reset.")
    end
    imgui.EndChild()
    imgui.SetColumnWidth(0, 150)
    imgui.SetColumnWidth(1, 283)

    imgui.NextColumn()
    imgui.BeginChild(69)
    if (SETTING_TYPES[typeIndex] == "General") then
        chooseAdvancedMode(globalVars)
        if (not globalVars.advancedMode) then imgui.BeginDisabled() end
        chooseHideAutomatic(globalVars)
        if (not globalVars.advancedMode) then imgui.EndDisabled() end
        addSeparator()
        chooseUpscroll(globalVars)
        addSeparator()
        chooseDontReplaceSV(globalVars)
        chooseIgnoreNotes(globalVars)
        chooseStepSize(globalVars)
        chooseDontPrintCreation(globalVars)
        addPadding()
    end
    if (SETTING_TYPES[typeIndex] == "Windows + Widgets") then
        chooseHideSVInfo(globalVars)
        chooseShowVibratoWidget(globalVars)
        addSeparator()
        chooseShowNoteDataWidget(globalVars)
        chooseShowMeasureDataWidget(globalVars)
    end
    if (SETTING_TYPES[typeIndex] == "Appearance") then
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
        if (state.GetValue("showColorPicker", false)) then
            choosePulseColor(globalVars)
        end
        if (not globalVars.useCustomPulseColor) then
            imgui.EndDisabled()
            state.SetValue("showColorPicker", false)
        end
    end
    if (SETTING_TYPES[typeIndex] == "Custom Theme") then
        local settingsChanged = false
        oldCustomThemeVal = globalVars.customStyle.windowBg
        _, globalVars.customStyle.windowBg = imgui.ColorPicker4("Window BG",
            globalVars.customStyle.windowBg or vector.New(0.00, 0.00, 0.00, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.windowBg or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.popupBg
        _, globalVars.customStyle.popupBg = imgui.ColorPicker4("Popup BG",
            globalVars.customStyle.popupBg or vector.New(0.08, 0.08, 0.08, 0.94))
        if (oldCustomThemeVal ~= globalVars.customStyle.popupBg or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.frameBg
        _, globalVars.customStyle.frameBg = imgui.ColorPicker4("Frame BG",
            globalVars.customStyle.frameBg or vector.New(0.14, 0.24, 0.28, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.frameBg or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.frameBgHovered
        _, globalVars.customStyle.frameBgHovered = imgui.ColorPicker4("Frame BG\n(Hovered)",
            globalVars.customStyle.frameBgHovered or vector.New(0.24, 0.34, 0.38, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.frameBgHovered or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.frameBgActive
        _, globalVars.customStyle.frameBgActive = imgui.ColorPicker4("Frame BG\n(Active)",
            globalVars.customStyle.frameBgActive or vector.New(0.29, 0.39, 0.43, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.frameBgActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.titleBg
        _, globalVars.customStyle.titleBg = imgui.ColorPicker4("Title BG",
            globalVars.customStyle.titleBg or vector.New(0.14, 0.24, 0.28, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.titleBg or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.titleBgActive
        _, globalVars.customStyle.titleBgActive = imgui.ColorPicker4("Title BG\n(Active)",
            globalVars.customStyle.titleBgActive or vector.New(0.51, 0.58, 0.75, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.titleBgActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.titleBgCollapsed
        _, globalVars.customStyle.titleBgCollapsed = imgui.ColorPicker4("Title BG\n(Collapsed)",
            globalVars.customStyle.titleBgCollapsed or vector.New(0.51, 0.58, 0.75, 0.50))
        if (oldCustomThemeVal ~= globalVars.customStyle.titleBgCollapsed or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.checkMark
        _, globalVars.customStyle.checkMark = imgui.ColorPicker4("Checkmark",
            globalVars.customStyle.checkMark or vector.New(0.81, 0.88, 1.00, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.checkMark or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.sliderGrab
        _, globalVars.customStyle.sliderGrab = imgui.ColorPicker4("Slider Grab",
            globalVars.customStyle.sliderGrab or vector.New(0.56, 0.63, 0.75, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.sliderGrab or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.sliderGrabActive
        _, globalVars.customStyle.sliderGrabActive = imgui.ColorPicker4("Slider Grab\n(Active)",
            globalVars.customStyle.sliderGrabActive or vector.New(0.61, 0.68, 0.80, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.sliderGrabActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.button
        _, globalVars.customStyle.button = imgui.ColorPicker4("Button",
            globalVars.customStyle.button or vector.New(0.31, 0.38, 0.50, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.button or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.buttonHovered
        _, globalVars.customStyle.buttonHovered = imgui.ColorPicker4("Button\n(Hovered)",
            globalVars.customStyle.buttonHovered or vector.New(0.41, 0.48, 0.60, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.buttonHovered or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.buttonActive
        _, globalVars.customStyle.buttonActive = imgui.ColorPicker4("Button\n(Active)",
            globalVars.customStyle.buttonActive or vector.New(0.51, 0.58, 0.70, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.buttonActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.tab
        _, globalVars.customStyle.tab = imgui.ColorPicker4("Tab",
            globalVars.customStyle.tab or vector.New(0.31, 0.38, 0.50, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.tab or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.tabHovered
        _, globalVars.customStyle.tabHovered = imgui.ColorPicker4("Tab\n(Hovered)",
            globalVars.customStyle.tabHovered or vector.New(0.51, 0.58, 0.75, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.tabHovered or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.tabActive
        _, globalVars.customStyle.tabActive = imgui.ColorPicker4("Tab\n(Active)",
            globalVars.customStyle.tabActive or vector.New(0.51, 0.58, 0.75, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.tabActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.header
        _, globalVars.customStyle.header = imgui.ColorPicker4("Header",
            globalVars.customStyle.header or vector.New(0.81, 0.88, 1.00, 0.40))
        if (oldCustomThemeVal ~= globalVars.customStyle.header or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.headerHovered
        _, globalVars.customStyle.headerHovered = imgui.ColorPicker4("Header\n(Hovered)",
            globalVars.customStyle.headerHovered or vector.New(0.81, 0.88, 1.00, 0.50))
        if (oldCustomThemeVal ~= globalVars.customStyle.headerHovered or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.headerActive
        _, globalVars.customStyle.headerActive = imgui.ColorPicker4("Header\n(Active)",
            globalVars.customStyle.headerActive or vector.New(0.81, 0.88, 1.00, 0.54))
        if (oldCustomThemeVal ~= globalVars.customStyle.headerActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.separator
        _, globalVars.customStyle.separator = imgui.ColorPicker4("Separator",
            globalVars.customStyle.separator or vector.New(0.81, 0.88, 1.00, 0.30))
        if (oldCustomThemeVal ~= globalVars.customStyle.separator or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.text
        _, globalVars.customStyle.text = imgui.ColorPicker4("Text",
            globalVars.customStyle.text or vector.New(1.00, 1.00, 1.00, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.text or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.textSelectedBg
        _, globalVars.customStyle.textSelectedBg = imgui.ColorPicker4("Text Selected\n(BG)",
            globalVars.customStyle.textSelectedBg or vector.New(0.81, 0.88, 1.00, 0.40))
        if (oldCustomThemeVal ~= globalVars.customStyle.textSelectedBg or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.scrollbarGrab
        _, globalVars.customStyle.scrollbarGrab = imgui.ColorPicker4("Scrollbar Grab",
            globalVars.customStyle.scrollbarGrab or vector.New(0.31, 0.38, 0.50, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.scrollbarGrab or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.scrollbarGrabHovered
        _, globalVars.customStyle.scrollbarGrabHovered = imgui.ColorPicker4("Scrollbar Grab\n(Hovered)",
            globalVars.customStyle.scrollbarGrabHovered or vector.New(0.41, 0.48, 0.60, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.scrollbarGrabHovered or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.scrollbarGrabActive
        _, globalVars.customStyle.scrollbarGrabActive = imgui.ColorPicker4("Scrollbar Grab\n(Active)",
            globalVars.customStyle.scrollbarGrabActive or vector.New(0.51, 0.58, 0.70, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.scrollbarGrabActive or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.plotLines
        _, globalVars.customStyle.plotLines = imgui.ColorPicker4("Plot Lines",
            globalVars.customStyle.plotLines or vector.New(0.61, 0.61, 0.61, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.plotLines or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.plotLinesHovered
        _, globalVars.customStyle.plotLinesHovered = imgui.ColorPicker4("Plot Lines\n(Hovered)",
            globalVars.customStyle.plotLinesHovered or vector.New(1.00, 0.43, 0.35, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.plotLinesHovered or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.plotHistogram
        _, globalVars.customStyle.plotHistogram = imgui.ColorPicker4("Plot Histogram",
            globalVars.customStyle.plotHistogram or vector.New(0.90, 0.70, 0.00, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.plotHistogram or settingsChanged) then
            settingsChanged = true
        end
        addSeparator()
        oldCustomThemeVal = globalVars.customStyle.plotHistogramHovered
        _, globalVars.customStyle.plotHistogramHovered = imgui.ColorPicker4("Plot Histogram\n(Hovered)",
            globalVars.customStyle.plotHistogramHovered or vector.New(1.00, 0.60, 0.00, 1.00))
        if (oldCustomThemeVal ~= globalVars.customStyle.plotHistogramHovered or settingsChanged) then
            settingsChanged = true
        end
        if (settingsChanged) then
            saveAndSyncGlobals(globalVars)
        end
    end
    if (SETTING_TYPES[typeIndex] == "Keybinds") then
        local hotkeyList = table.duplicate(globalVars.hotkeyList or DEFAULT_HOTKEY_LIST)
        if (#hotkeyList < #DEFAULT_HOTKEY_LIST) then
            hotkeyList = table.duplicate(DEFAULT_HOTKEY_LIST)
        end
        local awaitingIndex = state.GetValue("hotkey_awaitingIndex", 0)
        for k, v in pairs(hotkeyList) do
            if imgui.Button(awaitingIndex == k and "Listening...##listening" or v .. "##" .. k) then
                if (awaitingIndex == k) then
                    awaitingIndex = 0
                else
                    awaitingIndex = k
                end
            end
            imgui.SameLine(0, SAMELINE_SPACING)
            imgui.SetCursorPosX(95)
            imgui.Text("" .. HOTKEY_LABELS[k])
        end
        addSeparator()
        simpleActionMenu("Reset Hotkey Settings", 0, function()
            globalVars.hotkeyList = DEFAULT_HOTKEY_LIST
            saveAndSyncGlobals(globalVars)
            awaitingIndex = 0
        end, nil, nil, true, true)
        state.SetValue("hotkey_awaitingIndex", awaitingIndex)
        if (awaitingIndex == 0) then goto continue end
        local prefixes, key = listenForAnyKeyPressed()
        if (key == -1) then goto continue end
        hotkeyList[awaitingIndex] = table.concat(prefixes, "+") .. (truthy(prefixes) and "+" or "") .. keyNumToKey(key)
        awaitingIndex = 0
        globalVars.hotkeyList = hotkeyList
        GLOBAL_HOTKEY_LIST = hotkeyList
        saveAndSyncGlobals(globalVars)
        state.SetValue("hotkey_awaitingIndex", awaitingIndex)
    end
    ::continue::
    imgui.EndChild()
    imgui.Columns(1)
    state.SetValue("settings_typeIndex", typeIndex)
    if (not settingsOpened) then
        state.SetValue("showSettingsWindow", false)
        state.SetValue("settings_typeIndex", 1)
    end
    imgui.PopStyleColor(41)
    setPluginAppearanceColors(COLOR_THEMES[globalVars.colorThemeIndex], globalVars)
    setPluginAppearanceStyles(STYLE_THEMES[globalVars.styleThemeIndex])
    imgui.End()
end
