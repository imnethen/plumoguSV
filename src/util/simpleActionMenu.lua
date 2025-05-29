-- Creates a simple action menu + button that does SV things
-- Parameters
--    buttonText   : text on the button that appears [String]
--    minimumNotes : minimum number of notes to select before the action button appears [Int/Float]
--    actionfunc   : function to execute once button is pressed [Function]
--    globalVars   : list of variables used globally across all menus [Table]
--    menuVars     : list of variables used for the current menu [Table]
function simpleActionMenu(buttonText, minimumNotes, actionfunc, globalVars, menuVars, hideNoteReq, disableKeyInput)
    local enoughSelectedNotes = checkEnoughSelectedNotes(minimumNotes)
    local infoText = table.concat({ "Select ", minimumNotes, " or more notes" })
    if (not enoughSelectedNotes) then
        if (not hideNoteReq) then imgui.Text(infoText) end
        return
    end
    button(buttonText, ACTION_BUTTON_SIZE, actionfunc, globalVars, menuVars)
    if (disableKeyInput) then return end
    if (hideNoteReq) then
        toolTip("Press \"" .. GLOBAL_HOTKEY_LIST[2] .. "\" on your keyboard to do the same thing as this button")
        executeFunctionIfTrue(exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[2]), actionfunc, globalVars, menuVars)
    else
        toolTip("Press \"" .. GLOBAL_HOTKEY_LIST[1] .. "\" on your keyboard to do the same thing as this button")
        executeFunctionIfTrue(exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[1]), actionfunc, globalVars, menuVars)
    end
end

-- Executes a function if a key is pressed
-- Parameters
--    key        : key to be pressed [keys.~, from Quaver's MonoGame.Framework.Input.Keys enum]
--    func       : function to execute once key is pressed [Function]
--    globalVars : list of variables used globally across all menus [Table]
--    menuVars   : list of variables used for the current menu [Table]
function executeFunctionIfTrue(boolean, func, globalVars, menuVars)
    if not boolean then return end
    if globalVars and menuVars then
        func(globalVars, menuVars)
        return
    end
    if globalVars then
        func(globalVars)
        return
    end
    if menuVars then
        func(menuVars)
        return
    end
    func()
end
