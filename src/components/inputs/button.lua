-- Creates an imgui button
-- Parameters
--    text       : text on the button [String]
--    size       : dimensions of the button [Table]
--    func       : function to execute once button is pressed [Function]
--    menuVars   : list of variables used for the current menu [Table]
---Creates an imgui button.
---@param text string The text that the button should have.
---@param size Vector2 The size of the button.
---@param func fun(menuVars?: table): nil The function that the button should run upon being clicked.
---@param menuVars? table A set of variables to be passed into the function.
function Button(text, size, func, menuVars)
    if not imgui.Button(text, size) then return end
    if menuVars then
        func(menuVars)
        return
    end
    func()
end
