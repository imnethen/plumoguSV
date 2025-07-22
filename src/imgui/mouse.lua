--[[ may implement in the future when making mouse click effects
function  checkIfMouseClicked()
    local mouseDownBefore = state.GetValue("wasMouseDown")
    local mouseDownNow = imgui.IsAnyMouseDown()
    state.SetValue("wasMouseDown", mouseDownNow)
    return (not mouseDownBefore) and mouseDownNow
end
--]]
-- Checks and returns whether or not the mouse position has changed [Boolean]
-- Parameters
--    currentMousePosition : current (x, y) coordinates of the mouse [Table]
function checkIfMouseMoved(currentMousePosition)
    local oldMousePosition = vector2(0)
    getVariables("oldMousePosition", oldMousePosition)
    local mousePositionChanged = currentMousePosition ~= oldMousePosition
    saveVariables("oldMousePosition", currentMousePosition)
    return mousePositionChanged
end
