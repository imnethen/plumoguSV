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
        globalCheckbox(globalVars, "advancedMode", "Enable Advanced Mode",
            "Advanced mode enables a few features that simplify SV creation, at the cost of making the plugin more cluttered.")
        if (not globalVars.advancedMode) then imgui.BeginDisabled() end
        globalCheckbox(globalVars, "hideAutomatic", "Hide Automatically Placed TGs",
            "Timing groups placed by the \"Automatic\" feature will not be shown in the plumoguSV timing group selector.")
        if (not globalVars.advancedMode) then imgui.EndDisabled() end
        addSeparator()
        chooseUpscroll(globalVars)
        addSeparator()
        globalCheckbox(globalVars, "dontReplaceSV", "Don't Replace SVs When Placing Regular SVs",
            "Self-explanatory. Highly recommended to keep this setting disabled.")
        globalCheckbox(globalVars, "ignoreNotesOutsideTg", "Ignore Notes Outside Current Timing Group",
            "Notes that are in a timing group outside of the current one will be ignored by stills, selection checks, etc.")
        chooseStepSize(globalVars)
        globalCheckbox(globalVars, "dontPrintCreation", "Don't Print SV Creation Messages",
            "Disables printing \"Created __ SVs\" messages.")
        globalCheckbox(globalVars, "equalizeLinear", "Equalize Linear SV",
            "Forces the standard > linear option to have an average sv of 0 if the start and end SVs are equal. For beginners, this should be enabled.")
        addPadding()
    end
    if (SETTING_TYPES[typeIndex] == "Windows + Widgets") then
        globalCheckbox(globalVars, "hideSVInfo", "Hide SV Info Window",
            "Disables the window that shows note distances when placing Standard, Special, or Still SVs.")
        globalCheckbox(globalVars, "showVibratoWidget", "Separate Vibrato Into New Window",
            "For those who are used to having Vibrato as a separate plugin, this option makes a new, independent window with vibrato only.")
        addSeparator()
        globalCheckbox(globalVars, "showNoteDataWidget", "Show Note Data Of Selection",
            "If one note is selected, shows simple data about that note.")
        globalCheckbox(globalVars, "showMeasureDataWidget", "Show Measure Data Of Selection",
            "If two notes are selected, shows measure data within the selected region.")
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
