function renderPresetMenu(menuLabel, menuVars, settingVars)
    local newPresetName = state.GetValue("newPresetName", "")
    _, newPresetName = imgui.InputText("##PresetName", newPresetName, 4096)
    imgui.SameLine()
    if (imgui.Button("Save") and newPresetName:len() > 0) then
        preset = {}
        preset.name = newPresetName
        newPresetName = ""
        preset.data = { menuVars = menuVars, settingVars = settingVars }
        preset.type = menuLabel
        if (menuLabel == "Standard" or menuLabel == "Still") then
            preset.menu = STANDARD_SVS[menuVars.svTypeIndex]
        end
        if (menuLabel == "Special") then
            preset.menu = SPECIAL_SVS[menuVars.svTypeIndex]
        end
        if (menuLabel == "Vibrato") then
            preset.menu = VIBRATO_SVS[menuVars.svTypeIndex]
        end
        table.insert(globalVars.presets, preset)
        write(globalVars)
    end

    state.SetValue("newPresetName", newPresetName)
    imgui.Columns(4)

    imgui.Text("Name")
    imgui.NextColumn()
    imgui.Text("Menu")
    imgui.NextColumn()
    imgui.Text("Details")
    imgui.NextColumn()
    imgui.Text("Select")
    imgui.NextColumn()

    imgui.Separator()
    for idx, preset in pairs(globalVars.presets) do
        imgui.Text(preset.name)
        imgui.NextColumn()
        imgui.Text(table.concat({ preset.type, " > ", removeTrailingTag(preset.menu) }))
        imgui.NextColumn()
        HelpMarker(table.stringify(preset.data.settingVars))
        imgui.NextColumn()
        if (imgui.Button("Select##Preset" .. idx)) then
            globalVars.placeTypeIndex = table.indexOf(CREATE_TYPES, preset.menu)
            saveVariables(preset.menu .. preset.type .. "Settings", preset.data.settingVars)
            saveVariables("place" .. preset.menu .. "Menu", preset.data.menuVars)
            globalVars.showPresetMenu = false
        end
        if (imgui.IsItemClicked("Right")) then
            table.remove(globalVars.presets, idx)
            write(globalVars)
        end
    end

    imgui.SetColumnWidth(0, 100)
    imgui.SetColumnWidth(1, 100)
    imgui.SetColumnWidth(2, 30)
    imgui.SetColumnWidth(3, 80)

    imgui.Columns(1)
end
