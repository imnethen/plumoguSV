function renderPresetMenu(menuVars, settingVars)
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
    for idx, preset in pairs(presets) do
        imgui.Text(preset.name)
        imgui.NextColumn()
        imgui.Text(table.concat({ preset.type, " > ", preset.menu }))
        imgui.NextColumn()
        HelpMarker(table.stringify(preset.data.settingVars))
        imgui.NextColumn()
        if (imgui.Button("Select##Preset" .. idx)) then
            globalVars.showPresetMenu = false
            globalVars.placeTypeIndex = table.indexOf(CREATE_TYPES, preset.menu)
            saveVariables(preset.menu .. preset.type .. "Settings", preset.data.settingVars)
            saveVariables("place" .. preset.menu .. "Menu", preset.data.menuVars)
        end
    end

    imgui.SetColumnWidth(0, 100)
    imgui.SetColumnWidth(1, 100)
    imgui.SetColumnWidth(2, 30)
    imgui.SetColumnWidth(3, 80)

    imgui.Columns(1)
end
