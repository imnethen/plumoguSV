TAB_MENUS = { -- names of the tab menus
    "Info",
    "Select",
    "Create",
    "Edit",
    "Delete"
}

-- Creates a menu tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    tabName    : name of the currently selected tab [String]
function createMenuTab(globalVars, tabName)
    if not imgui.BeginTabItem(tabName) then return end
    addPadding()
    if tabName == "Info" then infoTab(globalVars) end
    if tabName == "Select" then selectTab(globalVars) end
    if tabName == "Create" then createSVTab(globalVars) end
    if tabName == "Edit" then editSVTab(globalVars) end
    if tabName == "Delete" then deleteTab(globalVars) end
    imgui.EndTabItem()
end