
-- Creates a simple action menu + button that does SV things
-- Parameters
--    buttonText   : text on the button that appears [String]
--    minimumNotes : minimum number of notes to select before the action button appears [Int/Float]
--    actionfunc   : function to execute once button is pressed [Function]
--    globalVars   : list of variables used globally across all menus [Table]
--    menuVars     : list of variables used for the current menu [Table]
function simpleActionMenu(buttonText, minimumNotes, actionfunc, globalVars, menuVars, hideNoteReq)
    local enoughSelectedNotes = checkEnoughSelectedNotes(minimumNotes)
    local infoText = table.concat({ "Select ", minimumNotes, " or more notes" })
    if (not enoughSelectedNotes) then
        if (not hideNoteReq) then imgui.Text(infoText) end
        return
    end
    button(buttonText, ACTION_BUTTON_SIZE, actionfunc, globalVars, menuVars)
    if (hideNoteReq) then
        toolTip("Press 'Shift+T' on your keyboard to do the same thing as this button")
        if (utils.IsKeyUp(keys.LeftShift) and utils.IsKeyUp(keys.RightShift)) then return end
        executeFunctionIfKeyPressed(keys.T, actionfunc, globalVars, menuVars)
    else
        if (utils.IsKeyDown(keys.LeftShift) or utils.IsKeyDown(keys.RightShift)) then return end
        toolTip("Press 'T' on your keyboard to do the same thing as this button")
        executeFunctionIfKeyPressed(keys.T, actionfunc, globalVars, menuVars)
    end
end