function renderPresetMenu(menuVars, settingVars)
    imgui.Columns(4)

    imgui.Text("Name")
    imgui.NextColumn()
    imgui.Text("Menu")
    imgui.NextColumn()
    imgui.Text("Details")
    imgui.NextColumn()
    imgui.Text("Jump To")
    imgui.NextColumn()

    imgui.Separator()
    for _, preset in pairs(presets) do

    end

    imgui.SetColumnWidth(0, 100)
    imgui.SetColumnWidth(1, 100)
    imgui.SetColumnWidth(2, 100)
    imgui.SetColumnWidth(3, 100)

    imgui.Columns(1)
end
