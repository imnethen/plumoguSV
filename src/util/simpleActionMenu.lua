---Creates a big button that runs a function when clicked. If the number of notes selected is less than `minimumNotes`, returns a textual placeholder instead.
---@param buttonText string The text that should be rendered on the button.
---@param minimumNotes integer The minimum number of notes that are required to select berfore the button appears.
---@param actionfunc fun(...): any The function to run on button press.
---@param globalVars? {[string]: any} Optional global variable parameter.
---@param menuVars? {[string]: any} Optional menu variable parameter.
---@param hideNoteReq? boolean Whether or not to hide the textual placeholder if the selected note requirement isn't met.
---@param disableKeyInput? boolean Whether or not to disallow keyboard inputs as a substitution to pressing the button.
---@param optionalKeyOverride? string (Assumes `disableKeyInput` is false) Optional string to change the activation keybind.
function simpleActionMenu(buttonText, minimumNotes, actionfunc, globalVars, menuVars, hideNoteReq, disableKeyInput,
                          optionalKeyOverride)
    local enoughSelectedNotes = checkEnoughSelectedNotes(minimumNotes)
    local infoText = "Select " .. minimumNotes .. " or more notes"
    if (not enoughSelectedNotes) then
        if (not hideNoteReq) then imgui.Text(infoText) end
        return
    end
    button(buttonText, ACTION_BUTTON_SIZE, actionfunc, globalVars, menuVars)
    if (disableKeyInput) then return end
    if (hideNoteReq) then
        toolTip("Press \'" .. GLOBAL_HOTKEY_LIST[2] .. "\' on your keyboard to do the same thing as this button")
        executeFunctionIfTrue(exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[2]), actionfunc, globalVars, menuVars)
    else
        if (optionalKeyOverride) then
            toolTip("Press \'" .. optionalKeyOverride .. "\' on your keyboard to do the same thing as this button")
            executeFunctionIfTrue(exclusiveKeyPressed(optionalKeyOverride), actionfunc, globalVars, menuVars)
            return
        end
        toolTip("Press \'" .. GLOBAL_HOTKEY_LIST[1] .. "\' on your keyboard to do the same thing as this button")
        executeFunctionIfTrue(exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[1]), actionfunc, globalVars, menuVars)
    end
end

---Runs a function with the given parameters if the given `condition` is true.
---@param condition boolean The condition that is used.
---@param func fun(...): nil The function to run if the condition is true.
---@param globalVars? {[string]: any} Optional global variable parameter.
---@param menuVars? {[string]: any} Optional menu variable parameter.
function executeFunctionIfTrue(condition, func, globalVars, menuVars)
    if not condition then return end
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
