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

-- Makes the main plugin window focused/active if Shift + Tab is pressed
function focusWindowIfHotkeysPressed()
    local shiftKeyPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local tabKeyPressed = utils.IsKeyPressed(keys.Tab)
    if shiftKeyPressedDown and tabKeyPressed then imgui.SetNextWindowFocus() end
end

-- Makes the main plugin window centered if Ctrl + Shift + Tab is pressed
function centerWindowIfHotkeysPressed()
    local ctrlPressedDown = utils.IsKeyDown(keys.LeftControl) or
        utils.IsKeyDown(keys.RightControl)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local tabPressed = utils.IsKeyPressed(keys.Tab)
    if not (ctrlPressedDown and shiftPressedDown and tabPressed) then return end

    local windowWidth, windowHeight = table.unpack(state.WindowSize)
    local pluginWidth, pluginHeight = table.unpack(imgui.GetWindowSize())
    local centeringX = (windowWidth - pluginWidth) / 2
    local centeringY = (windowHeight - pluginHeight) / 2
    local coordinatesToCenter = { centeringX, centeringY }
    imgui.SetWindowPos("plumoguSV", coordinatesToCenter)
end

-- Returns whether or not the corresponding menu tab shortcut keys were pressed [Boolean]
-- Parameters
--    tabName : name of the menu tab [String]
function keysPressedForMenuTab(tabName)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    if shiftPressedDown then return false end

    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local otherKey
    if tabName == "##info" then otherKey = keys.A end
    if tabName == "##placeStandard" then otherKey = keys.Z end
    if tabName == "##placeSpecial" then otherKey = keys.X end
    if tabName == "##placeStill" then otherKey = keys.C end
    if tabName == "##edit" then otherKey = keys.S end
    if tabName == "##delete" then otherKey = keys.D end
    local otherKeyPressed = utils.IsKeyPressed(otherKey)
    return altPressedDown and otherKeyPressed
end

-- Changes the SV type if certain keys are pressed
-- Returns whether or not the SV type has changed [Boolean]
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function changeSVTypeIfKeysPressed(menuVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return false end

    local maxSVTypes = #STANDARD_SVS
    local isSpecialType = menuVars.interlace == nil
    if isSpecialType then maxSVTypes = #SPECIAL_SVS end

    if xPressed then menuVars.svTypeIndex = menuVars.svTypeIndex + 1 end
    if zPressed then menuVars.svTypeIndex = menuVars.svTypeIndex - 1 end
    menuVars.svTypeIndex = wrapToInterval(menuVars.svTypeIndex, 1, maxSVTypes)
    return true
end

-- Changes the edit tool if certain keys are pressed
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function changeSelectToolIfKeysPressed(globalVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return end

    if xPressed then globalVars.selectTypeIndex = globalVars.selectTypeIndex + 1 end
    if zPressed then globalVars.selectTypeIndex = globalVars.selectTypeIndex - 1 end
    globalVars.selectTypeIndex = wrapToInterval(globalVars.selectTypeIndex, 1, #SELECT_TOOLS)
end

-- Changes the edit tool if certain keys are pressed
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function changeEditToolIfKeysPressed(globalVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return end

    if xPressed then globalVars.editToolIndex = globalVars.editToolIndex + 1 end
    if zPressed then globalVars.editToolIndex = globalVars.editToolIndex - 1 end
    globalVars.editToolIndex = wrapToInterval(globalVars.editToolIndex, 1, #EDIT_SV_TOOLS)
end