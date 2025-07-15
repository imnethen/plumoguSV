function copyNPasteMenu()
    local menuVars = getMenuVars("copy")

    _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
    keepSameLine()
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

    if copiedItemCount == 0 then
        saveVariables("copyMenu", menuVars)
        return
    end

    addSeparator()

    _, menuVars.tryAlign = imgui.Checkbox("Try to fix misalignments", menuVars.tryAlign)
    saveVariables("copyMenu", menuVars)

    simpleActionMenu("Paste items at selected notes", 1, pasteItems, menuVars)
end
