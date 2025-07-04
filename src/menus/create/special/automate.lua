function automateSVMenu(settingVars)
    local copiedSVCount = #settingVars.copiedSVs

    if (copiedSVCount == 0) then
        simpleActionMenu("Copy SVs between selected notes", 2, automateCopySVs, nil, settingVars)
        return
    end

    button("Clear copied items", ACTION_BUTTON_SIZE, clearAutomateSVs, nil, settingVars)
    addSeparator()
    _, settingVars.scaleSVs = imgui.Checkbox("Scale SVs?", settingVars.scaleSVs)
    _, settingVars.maintainMs = imgui.Checkbox("Maintain Time?", settingVars.maintainMs)
    if (settingVars.maintainMs) then
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.PushItemWidth(90)
        settingVars.ms = computableInputFloat("Time", settingVars.ms, 2, "ms")
        imgui.PopItemWidth()
    end
    addSeparator()
    simpleActionMenu("Automate SVs for selected notes", 1, automateSVs, nil, settingVars)
end
