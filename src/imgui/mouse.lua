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
    local oldMousePosition = {
        x = 0,
        y = 0
    }
    getVariables("oldMousePosition", oldMousePosition)
    local xChanged = currentMousePosition.x ~= oldMousePosition.x
    local yChanged = currentMousePosition.y ~= oldMousePosition.y
    local mousePositionChanged = xChanged or yChanged
    oldMousePosition.x = currentMousePosition.x
    oldMousePosition.y = currentMousePosition.y
    saveVariables("oldMousePosition", oldMousePosition)
    return mousePositionChanged
end

-- Returns the current (x, y) coordinates of the mouse [Table]
function getCurrentMousePosition()
    return imgui.GetMousePos()
end
