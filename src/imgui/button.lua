-- Creates an imgui button
-- Parameters
--    text       : text on the button [String]
--    size       : dimensions of the button [Table]
--    func       : function to execute once button is pressed [Function]
--    menuVars   : list of variables used for the current menu [Table]
function button(text, size, func, menuVars)
    if not imgui.Button(text, size) then return end
    if menuVars then
        func(menuVars)
        return
    end
    func()
end
