function copyNPasteMenu()
    local menuVars = getMenuVars("copy")

    _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
    KeepSameLine()
    _, menuVars.copyTable[2] = imgui.Checkbox("Copy SVs", menuVars.copyTable[2])
    _, menuVars.copyTable[3] = imgui.Checkbox("Copy SSFs", menuVars.copyTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.copyTable[4] = imgui.Checkbox("Copy Bookmarks", menuVars.copyTable[4])

    AddSeparator()
    _, menuVars.curSlot = imgui.InputInt("cur slot", menuVars.curSlot)
    while menuVars.curSlot > #menuVars.copiedSVs do
        -- this errors
        -- table.insert(menuVars.copiedLines, {})
        -- table.insert(menuVars.copiedSVs, {})
        -- table.insert(menuVars.copiedSSFs, {})
        -- table.insert(menuVars.copiedBMs, {})
        local newCopiedLines = table.duplicate(menuVars.copiedLines)
        table.insert(newCopiedLines, {})
        menuVars.copiedLines = newCopiedLines
        local newCopiedSVs   = table.duplicate(menuVars.copiedSVs)
        table.insert(newCopiedSVs, {})
        menuVars.copiedSVs = newCopiedSVs
        local newCopiedSSFs  = table.duplicate(menuVars.copiedSSFs)
        table.insert(newCopiedSSFs, {})
        menuVars.copiedSSFs = newCopiedSSFs
        local newCopiedBMs   = table.duplicate(menuVars.copiedBMs)
        table.insert(newCopiedBMs, {})
        menuVars.copiedBMs = newCopiedBMs

        break
    end
    AddSeparator()

    local copiedItemCount = #menuVars.copiedLines[menuVars.curSlot] + #menuVars.copiedSVs[menuVars.curSlot] + #menuVars.copiedSSFs[menuVars.curSlot] + #menuVars.copiedBMs[menuVars.curSlot]

    if (copiedItemCount == 0) then
        simpleActionMenu("Copy items between selected notes", 2, copyItems, menuVars)
    else
        FunctionButton("Clear copied items", ACTION_BUTTON_SIZE, clearCopiedItems, menuVars)
    end

    if copiedItemCount == 0 then
        saveVariables("copyMenu", menuVars)
        return
    end

    AddSeparator()

    _, menuVars.tryAlign = imgui.Checkbox("Try to fix misalignments", menuVars.tryAlign)
    saveVariables("copyMenu", menuVars)

    simpleActionMenu("Paste items at selected notes", 1, pasteItems, menuVars)
end
