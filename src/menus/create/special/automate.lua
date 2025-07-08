function automateSVMenu(settingVars)
    local copiedSVCount = #settingVars.copiedSVs

    if (copiedSVCount == 0) then
        simpleActionMenu("Copy SVs between selected notes", 2, automateCopySVs, settingVars)
        return
    end

    button("Clear copied items", ACTION_BUTTON_SIZE, clearAutomateSVs, settingVars)
    addSeparator()
    settingVars.initialSV = negatableComputableInputFloat("Initial SV", settingVars.initialSV, 2, "x")
    _, settingVars.scaleSVs = imgui.Checkbox("Scale SVs?", settingVars.scaleSVs)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.optimizeTGs = imgui.Checkbox("Optimize TGs?", settingVars.optimizeTGs)
    _, settingVars.maintainMs = imgui.Checkbox("Static Time?", settingVars.maintainMs)
    if (settingVars.maintainMs) then
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.PushItemWidth(71)
        settingVars.ms = computableInputFloat("Time", settingVars.ms, 2, "ms")
        imgui.PopItemWidth()
    end
    addSeparator()
    simpleActionMenu("Automate SVs for selected notes", 2, automateSVs, settingVars)
end
