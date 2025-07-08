TAB_MENUS = { -- names of the tab menus
    "Info",
    "Select",
    "Create",
    "Edit",
    "Delete"
}

---Creates a menu tab.
---@param globalVars table
---@param tabName string
function createMenuTab(globalVars, tabName)
    if not imgui.BeginTabItem(tabName) then return end
    addPadding()
    if tabName == "Info" then
        infoTab(globalVars)
    else
        state.SetValue("showSettingsWindow", false)
    end
    if tabName == "Select" then selectTab(globalVars) end
    if tabName == "Create" then createSVTab(globalVars) end
    if tabName == "Edit" then editSVTab(globalVars) end
    if tabName == "Delete" then deleteTab(globalVars) end
    imgui.EndTabItem()
end
