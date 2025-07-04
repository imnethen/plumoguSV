-- Provides a copy-pastable link to a cubic bezier website and also can parse inputted links
-- Returns whether new bezier coordinates were parsed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function provideBezierWebsiteLink(settingVars)
    local coordinateParsed = false
    local bezierText = state.GetValue("bezierText") or "https://cubic-bezier.com/"
    local imguiFlag = imgui_input_text_flags.AutoSelectAll
    _, bezierText = imgui.InputText("##bezierWebsite", bezierText, 100, imguiFlag)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.Button("Parse##bezierValues", SECONDARY_BUTTON_SIZE) then
        local regex = "(-?%d*%.?%d+)"
        local values = {}
        for value, _ in string.gmatch(bezierText, regex) do
            table.insert(values, tonumber(value))
        end
        if #values >= 4 then
            settingVars.p1 = vector.New(values[1], values[2])
            settingVars.p2 = vector.New(values[3], values[4])
            coordinateParsed = true
        end
        bezierText = "https://cubic-bezier.com/"
    end
    state.SetValue("bezierText", bezierText)
    helpMarker("This site lets you play around with a cubic bezier whose graph represents the " ..
        "motion/path of notes. After finding a good shape for note motion, paste the " ..
        "resulting url into the input box and hit the parse button to import the " ..
        "coordinate values. Alternatively, enter 4 numbers and hit parse.")
    return coordinateParsed
end
