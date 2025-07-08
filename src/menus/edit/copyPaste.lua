function copyNPasteMenu()
    local menuVars = getMenuVars("copy")

    _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.copyTable[2] = imgui.Checkbox("Copy SVs", menuVars.copyTable[2])
    _, menuVars.copyTable[3] = imgui.Checkbox("Copy SSFs", menuVars.copyTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.copyTable[4] = imgui.Checkbox("Copy Bookmarks", menuVars.copyTable[4])

    addSeparator()

    local copiedItemCount = #menuVars.copiedLines + #menuVars.copiedSVs + #menuVars.copiedSSFs + #menuVars.copiedBMs

    if (copiedItemCount == 0) then
        simpleActionMenu("Copy items between selected notes", 2, copyItems, menuVars)
    else
        button("Clear copied items", ACTION_BUTTON_SIZE, clearCopiedItems, menuVars)
    end

    saveVariables("copyMenu", menuVars)

    if copiedItemCount == 0 then return end

    addSeparator()
    simpleActionMenu("Paste items at selected notes", 1, pasteItems, menuVars)
end
