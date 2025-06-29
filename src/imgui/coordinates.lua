-- Returns coordinates relative to the plugin window [Table]
-- Parameters
--    x : x coordinate relative to the plugin window [Int]
--    y : y coordinate relative to the plugin window [Int]
function coordsRelativeToWindow(x, y)
    local newX = x + imgui.GetWindowPos()[1]
    local newY = y + imgui.GetWindowPos()[2]
    return { newX, newY }
end

-- Returns a point relative to a given point [Table]
-- Parameters
--    point   : (x, y) coordinates [Table]
--    xChange : change in x coordinate [Int]
--    yChange : change in y coordinate [Int]
function relativePoint(point, xChange, yChange)
    return { point[1] + xChange, point[2] + yChange }
end

-- Checks and returns whether or not the frame number has changed [Boolean]
-- Parameters
--    currentTime : current in-game time of the plugin [Int/Float]
--    fps         : frames per second set by the user/plugin [Int]
function checkIfFrameChanged(currentTime, fps)
    local oldFrameInfo = { frameNumber = 0 }
    getVariables("oldFrameInfo", oldFrameInfo)
    local newFrameNumber = math.floor(currentTime * fps) % fps
    local frameChanged = oldFrameInfo.frameNumber ~= newFrameNumber
    oldFrameInfo.frameNumber = newFrameNumber
    saveVariables("oldFrameInfo", oldFrameInfo)
    return frameChanged
end
