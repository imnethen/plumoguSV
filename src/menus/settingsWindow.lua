local SETTING_TYPES = {
    "General",
    "Appearance",
    "Windows + Widgets",
    "Keybinds"
}


function showPluginSettingsWindow(globalVars)
    local bgColor = vector.New(0.2, 0.2, 0.2, 1)

    imgui.PopStyleColor(20)
    setIncognitoColors()
    setPluginAppearanceStyles("Rounded + Border")
    imgui.PushStyleColor(imgui_col.WindowBg, bgColor)
    imgui.PushStyleColor(imgui_col.TitleBg, bgColor)
    imgui.PushStyleColor(imgui_col.TitleBgActive, bgColor)
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
        print("e!", "Settings have been reset.")
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
    imgui.PopStyleColor(40)
    setPluginAppearanceColors(COLOR_THEMES[globalVars.colorThemeIndex], globalVars.rgbPeriod)
    setPluginAppearanceStyles(STYLE_THEMES[globalVars.styleThemeIndex])
    imgui.End()
end
