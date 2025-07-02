-- Creates a button that adds frameTime objects to the list in the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addFrameTimes(settingVars)
    if not imgui.Button("Add selected notes to use for frames", ACTION_BUTTON_SIZE) then return end

    local hasAlreadyAddedLaneTime = {}
    for _ = 1, map.GetKeyCount() do
        table.insert(hasAlreadyAddedLaneTime, {})
    end
    local frameTimeToIndex = {}
    local totalTimes = #settingVars.frameTimes
    for i = 1, totalTimes do
        local frameTime = settingVars.frameTimes[i]
        local time = frameTime.time
        local lanes = frameTime.lanes
        frameTimeToIndex[time] = i
        for j = 1, #lanes do
            local lane = lanes[j]
            hasAlreadyAddedLaneTime[lane][time] = true
        end
    end
    for _, ho in pairs(state.SelectedHitObjects) do
        local lane = ho.Lane
        local time = ho.StartTime
        if (not hasAlreadyAddedLaneTime[lane][time]) then
            hasAlreadyAddedLaneTime[lane][time] = true
            if frameTimeToIndex[time] then
                local index = frameTimeToIndex[time]
                local frameTime = settingVars.frameTimes[index]
                table.insert(frameTime.lanes, lane)
                frameTime.lanes = sort(frameTime.lanes, sortAscending)
            else
                local defaultFrame = settingVars.currentFrame
                local defaultPosition = 0
                local newFrameTime = createFrameTime(time, { lane }, defaultFrame, defaultPosition)
                table.insert(settingVars.frameTimes, newFrameTime)
                frameTimeToIndex[time] = #settingVars.frameTimes
            end
        end
    end
    settingVars.frameTimes = sort(settingVars.frameTimes, sortAscendingTime)
end

-- Displays all existing frameTimes for the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function displayFrameTimes(settingVars)
    if #settingVars.frameTimes == 0 then
        imgui.Text("Add notes to fill the selection box below")
    else
        imgui.Text("time | lanes | frame # | position")
    end
    helpMarker("Make sure to select ALL lanes from a chord with multiple notes, not just one lane")
    addPadding()
    local frameTimeSelectionArea = { ACTION_BUTTON_SIZE.x, 120 }
    imgui.BeginChild("FrameTimes", frameTimeSelectionArea, 1)
    for i = 1, #settingVars.frameTimes do
        local frameTimeData = {}
        local frameTime = settingVars.frameTimes[i]
        frameTimeData[1] = frameTime.time
        frameTimeData[2] = frameTime.lanes .. ", "
        frameTimeData[3] = frameTime.frame
        frameTimeData[4] = frameTime.position
        local selectableText = frameTimeData .. " | "
        if imgui.Selectable(selectableText, settingVars.selectedTimeIndex == i) then
            settingVars.selectedTimeIndex = i
        end
    end
    imgui.EndChild()
end

-- Draws notes from the currently selected frame for the frames setup menu
-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    settingVars : list of variables used for the current menu [Table]
function drawCurrentFrame(globalVars, settingVars)
    local mapKeyCount = map.GetKeyCount()
    local noteWidth = 200 / mapKeyCount
    local noteSpacing = 5
    local barNoteHeight = math.round(2 * noteWidth / 5, 0)
    local noteColor = rgbaToUint(117, 117, 117, 255)
    local noteSkinType = NOTE_SKIN_TYPES[settingVars.noteSkinTypeIndex]
    local drawlist = imgui.GetWindowDrawList()
    local childHeight = 250
    imgui.BeginChild("Current Frame", vector.New(255, childHeight), 1)
    for _, frameTime in pairs(settingVars.frameTimes) do
        if frameTime.frame == settingVars.currentFrame then
            for _, lane in pairs(frameTime.lanes) do
                if noteSkinType == "Bar" then
                    local x1 = 2 * noteSpacing + (noteWidth + noteSpacing) * (lane - 1)
                    local y1 = (childHeight - 2 * noteSpacing) - (frameTime.position / 2)
                    local x2 = x1 + noteWidth
                    local y2 = y1 - barNoteHeight
                    if globalVars.upscroll then
                        y1 = childHeight - y1
                        y2 = y1 + barNoteHeight
                    end
                    local p1 = coordsRelativeToWindow(x1, y1)
                    local p2 = coordsRelativeToWindow(x2, y2)
                    drawlist.AddRectFilled(p1, p2, noteColor)
                elseif noteSkinType == "Circle" then
                    local circleRadius = noteWidth / 2
                    local leftBlankSpace = 2 * noteSpacing + circleRadius
                    local yBlankSpace = 2 * noteSpacing + circleRadius + frameTime.position / 2
                    local x1 = leftBlankSpace + (noteWidth + noteSpacing) * (lane - 1)
                    local y1 = childHeight - yBlankSpace
                    if globalVars.upscroll then
                        y1 = childHeight - y1
                    end
                    local p1 = coordsRelativeToWindow(x1, y1)
                    drawlist.AddCircleFilled(p1, circleRadius, noteColor, 20)
                end
            end
        end
    end
    imgui.EndChild()
end

-- Adds selected note times to the noteTimes list in menuVars
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function addSelectedNoteTimesToList(menuVars)
    for _, ho in pairs(state.SelectedHitObjects) do
        table.insert(menuVars.noteTimes, ho.StartTime)
    end
    menuVars.noteTimes = table.dedupe(menuVars.noteTimes)
    menuVars.noteTimes = sort(menuVars.noteTimes, sortAscending)
end
