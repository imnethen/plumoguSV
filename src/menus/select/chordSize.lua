function selectChordSizeMenu()
    local menuVars = getMenuVars("selectChordSize")

    _, menuVars.single = imgui.Checkbox("Select Singles", menuVars.single)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.jump = imgui.Checkbox("Select Jumps", menuVars.jump)
    _, menuVars.hand = imgui.Checkbox("Select Hands", menuVars.hand)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.quad = imgui.Checkbox("Select Quads", menuVars.quad)

    simpleActionMenu("Select chords within region", 2, selectByChordSizes, nil, menuVars)

    saveVariables("selectChordSizeMenu", menuVars)
end