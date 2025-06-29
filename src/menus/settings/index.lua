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
    imgui.SetColumnWidth(0, 150)
    imgui.SetColumnWidth(1, 283)

    -- CATEGORY COLUMN

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
    if (imgui.Button("Crash The Game")) then
        ---@diagnostic disable-next-line: param-type-mismatch
        imgui.Text(nil)
    end
    imgui.EndChild()
    imgui.NextColumn()

    -- SETTINGS COLUMN

    imgui.BeginChild(69)
    if (SETTING_TYPES[typeIndex] == "General") then
        showGeneralSettings(globalVars)
    end
    if (SETTING_TYPES[typeIndex] == "Windows + Widgets") then
        showWindowSettings(globalVars)
    end
    if (SETTING_TYPES[typeIndex] == "Appearance") then
        showAppearanceSettings(globalVars)
    end
    if (SETTING_TYPES[typeIndex] == "Custom Theme") then
        showCustomThemeSettings(globalVars)
    end
    if (SETTING_TYPES[typeIndex] == "Keybinds") then
        showKeybindSettings(globalVars)
    end
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
