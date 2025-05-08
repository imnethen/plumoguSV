
-- Creates the copy and paste menu
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function copyNPasteMenu(globalVars)
    local menuVars = {
        copyTable = { true, true, true, true }, -- 1: timing lines, 2: svs, 3: ssfs, 4: bookmarks
        copiedLines = {},
        copiedSVs = {},
        copiedSSFs = {},
        copiedBMs = {},
    }
    getVariables("copyMenu", menuVars)

    _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.copyTable[2] = imgui.Checkbox("Copy SVs", menuVars.copyTable[2])
    _, menuVars.copyTable[3] = imgui.Checkbox("Copy SSFs", menuVars.copyTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.copyTable[4] = imgui.Checkbox("Copy Bookmarks", menuVars.copyTable[4])

    addSeparator()

    local copiedItemCount = #menuVars.copiedLines + #menuVars.copiedSVs + #menuVars.copiedSSFs + #menuVars.copiedBMs

    if (copiedItemCount == 0) then
        simpleActionMenu("Copy items between selected notes", 2, copyItems, nil, menuVars)
    else
        button("Clear copied items", ACTION_BUTTON_SIZE, clearCopiedItems, nil, menuVars)
    end


    saveVariables("copyMenu", menuVars)

    if copiedItemCount == 0 then return end

    addSeparator()
    simpleActionMenu("Paste items at selected notes", 1, pasteItems, globalVars, menuVars)
end
