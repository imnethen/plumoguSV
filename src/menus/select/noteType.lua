function selectNoteTypeMenu()
    local menuVars = getMenuVars("selectNoteType")

    _, menuVars.rice = imgui.Checkbox("Select Rice Notes", menuVars.rice)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.ln = imgui.Checkbox("Select LNs", menuVars.ln)

    simpleActionMenu("Select notes within region", 2, selectByNoteType, nil, menuVars)

    saveVariables("selectNoteTypeMenu", menuVars)
end
