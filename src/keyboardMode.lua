-- Creates the "Info" tab for "keyboard" mode
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function infoTabKeyboard(globalVars)
    provideMorePluginInfo()
    listKeyboardShortcuts()
    choosePluginBehaviorSettings(globalVars)
    choosePluginAppearance(globalVars)
end


-- Creates the menu tabs for quick keyboard access for "keyboard" mode
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function createQuickTabs(globalVars)
    local tabMenus = {
        "##info",
        "##placeStandard",
        "##placeSpecial",
        "##placeStill",
        "##edit",
        "##delete"
    }
    local tabMenuFunctions = {
        infoTabKeyboard,
        placeStandardSVMenu,
        placeSpecialSVMenu,
        placeStillSVMenu,
        editSVTab,
        deleteTab
    }
    for i = 1, #tabMenus do
        local tabName = tabMenus[i]
        local tabItemFlag = imgui_tab_item_flags.None
        if keysPressedForMenuTab(tabName) then tabItemFlag = imgui_tab_item_flags.SetSelected end
        if imgui.BeginTabItem(tabName, true, tabItemFlag) then
            imgui.InvisibleButton("SV stands for sv veleocity", { 255, 1 })
            if tabName == "##info" then
                imgui.Text("This is keyboard mode (for pro users)")
                imgui.Text("Tab navigation: Alt + (Z, X, C, A, S, D)")
                imgui.Text("Tool naviation: Alt + Shift + (Z, X)")
            end
            tabMenuFunctions[i](globalVars)
            imgui.EndTabItem()
        end
    end
end

--------------------------------------------------------------------------------------------- Menus
