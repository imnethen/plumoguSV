-- Creates the "Delete SVs" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function deleteTab(globalVars)
    local menuVars = {
        deleteTable = { true, true, true, true }
    }
    getVariables("deleteMenu", menuVars)
    _, menuVars.deleteTable[1] = imgui.Checkbox("Delete Lines", menuVars.deleteTable[1])
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.deleteTable[2] = imgui.Checkbox("Delete SVs", menuVars.deleteTable[2])
    _, menuVars.deleteTable[3] = imgui.Checkbox("Delete SSFs", menuVars.deleteTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.deleteTable[4] = imgui.Checkbox("Delete Bookmarks", menuVars.deleteTable[4])

    saveVariables("deleteMenu", menuVars)

    for i = 1, 4 do
        if (menuVars.deleteTable[i]) then goto continue end
    end

    do return 69 end

    ::continue::

    simpleActionMenu("Delete items between selected notes", 2, deleteItems, nil, menuVars)
end
