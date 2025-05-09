function tempBugFix()
    local ptr = 0
    local svsToRemove = {}
    for _, sv in pairs(map.ScrollVelocities) do
        if (math.abs(ptr - sv.StartTime) < 0.035) then
            table.insert(svsToRemove, sv)
        end
        ptr = sv.StartTime
    end
    actions.RemoveScrollVelocityBatch(svsToRemove)
end

-- Shows the settings menu for the current SV type
-- Returns whether or not any settings changed [Boolean]
-- Parameters
--    currentSVType : current SV type to choose the settings for [String]
--    settingVars   : list of variables used for the current menu [Table]
--    skipFinalSV   : whether or not to skip choosing the final SV [Boolean]
--    svPointsForce : number of SV points to force [Int or nil]
function showSettingsMenu(currentSVType, settingVars, skipFinalSV, svPointsForce)
    if currentSVType == "Linear" then
        return linearSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Exponential" then
        -- TODO: currently expo is the only one that needs globalVars so its parameters are different from the others thats  bad maybe
        return exponentialSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Bezier" then
        return bezierSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Hermite" then
        return hermiteSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Sinusoidal" then
        return sinusoidalSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Circular" then
        return circularSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Random" then
        return randomSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Custom" then
        return customSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Chinchilla" then
        return chinchillaSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Combo" then
        return comboSettingsMenu(settingVars)
    end
end

-- Provides a copy-pastable link to a cubic bezier website and also can parse inputted links
-- Returns whether new bezier coordinates were parsed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function provideBezierWebsiteLink(settingVars)
    local coordinateParsed = false
    local bezierText = state.GetValue("bezierText") or "https://cubic-bezier.com/"
    local imguiFlag = imgui_input_text_flags.AutoSelectAll
    _, bezierText = imgui.InputText("##bezierWebsite", bezierText, 100, imguiFlag)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.Button("Parse##beizerValues", SECONDARY_BUTTON_SIZE) then
        local regex = "(-?%d*%.?%d+)"
        local values = {}
        for value, _ in string.gmatch(bezierText, regex) do
            table.insert(values, tonumber(value))
        end
        if #values >= 4 then
            settingVars.x1, settingVars.y1, settingVars.x2, settingVars.y2 = table.unpack(values)
            coordinateParsed = true
        end
        bezierText = "https://cubic-bezier.com/"
    end
    state.SetValue("bezierText", bezierText)
    helpMarker("This site lets you play around with a cubic bezier whose graph represents the " ..
        "motion/path of notes. After finding a good shape for note motion, paste the " ..
        "resulting url into the input box and hit the parse button to import the " ..
        "coordinate values. Alternatively, enter 4 numbers and hit parse.")
    return coordinateParsed
end

-- Provides an import box to parse inputted custom SVs
-- Returns whether new custom SVs were parsed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function importCustomSVs(settingVars)
    local svsParsed = false
    local customSVText = state.GetValue("customSVText") or "Import SV values here"
    local imguiFlag = imgui_input_text_flags.AutoSelectAll
    _, customSVText = imgui.InputText("##customSVs", customSVText, 99999, imguiFlag)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.Button("Parse##customSVs", SECONDARY_BUTTON_SIZE) then
        local regex = "(-?%d*%.?%d+)"
        local values = {}
        for value, _ in string.gmatch(customSVText, regex) do
            table.insert(values, tonumber(value))
        end
        if #values >= 1 then
            settingVars.svMultipliers = values
            settingVars.selectedMultiplierIndex = 1
            settingVars.svPoints = #values
            svsParsed = true
        end
        customSVText = "Import SV values here"
    end
    state.SetValue("customSVText", customSVText)
    helpMarker("Paste custom SV values in the box then hit the parse button (ex. 2 -1 2 -1)")
    return svsParsed
end

-- Updates SVs and SV info stored in the menu
-- Parameters
--    currentSVType : current type of SV being updated [String]
--    globalVars    : list of variables used globally across all menus [Table]
--    menuVars      : list of variables used for the place SV menu [Table]
--    settingVars   : list of variables used for the current menu [Table]
--    skipFinalSV   : whether or not to skip the final SV for updating menu SVs [Boolean]
function updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, skipFinalSV)
    local interlaceMultiplier = nil
    if menuVars.interlace then interlaceMultiplier = menuVars.interlaceRatio end
    menuVars.svMultipliers = generateSVMultipliers(currentSVType, settingVars, interlaceMultiplier)
    local svMultipliersNoEndSV = makeDuplicateList(menuVars.svMultipliers)
    table.remove(svMultipliersNoEndSV)
    menuVars.svDistances = calculateDistanceVsTime(globalVars, svMultipliersNoEndSV)

    updateFinalSV(settingVars.finalSVIndex, menuVars.svMultipliers, settingVars.customSV,
        skipFinalSV)
    updateSVStats(menuVars.svGraphStats, menuVars.svStats, menuVars.svMultipliers,
        svMultipliersNoEndSV, menuVars.svDistances)
end

-- Updates the final SV of the precalculated menu SVs
-- Parameters
--    finalSVIndex  : index value for the type of final SV [Int]
--    svMultipliers : list of SV multipliers [Table]
--    customSV      : custom SV value [Int/Float]
--    skipFinalSV   : whether or not to skip the final SV for updating menu SVs [Boolean]
function updateFinalSV(finalSVIndex, svMultipliers, customSV, skipFinalSV)
    if skipFinalSV then
        table.remove(svMultipliers)
        return
    end

    local finalSVType = FINAL_SV_TYPES[finalSVIndex]
    if finalSVType == "Normal" then return end
    svMultipliers[#svMultipliers] = customSV
end

-- Adjusts the number of SV multipliers available for the custom SV menu
-- Parameters
--    settingVars : list of variables used for the custom SV menu [Table]
function adjustNumberOfMultipliers(settingVars)
    if settingVars.svPoints > #settingVars.svMultipliers then
        local difference = settingVars.svPoints - #settingVars.svMultipliers
        for i = 1, difference do
            table.insert(settingVars.svMultipliers, 1)
        end
    end
    if settingVars.svPoints >= #settingVars.svMultipliers then return end

    if settingVars.selectedMultiplierIndex > settingVars.svPoints then
        settingVars.selectedMultiplierIndex = settingVars.svPoints
    end
    local difference = #settingVars.svMultipliers - settingVars.svPoints
    for i = 1, difference do
        table.remove(settingVars.svMultipliers)
    end
end

-- Updates SVs and SV info stored in the stutter menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function updateStutterMenuSVs(settingVars)
    settingVars.svMultipliers = generateSVMultipliers("Stutter1", settingVars, nil)
    local svMultipliersNoEndSV = makeDuplicateList(settingVars.svMultipliers)
    table.remove(svMultipliersNoEndSV)

    settingVars.svMultipliers2 = generateSVMultipliers("Stutter2", settingVars, nil)
    local svMultipliersNoEndSV2 = makeDuplicateList(settingVars.svMultipliers2)
    table.remove(svMultipliersNoEndSV2)

    settingVars.svDistances = calculateStutterDistanceVsTime(svMultipliersNoEndSV,
        settingVars.stutterDuration,
        settingVars.stuttersPerSection)
    settingVars.svDistances2 = calculateStutterDistanceVsTime(svMultipliersNoEndSV2,
        settingVars.stutterDuration,
        settingVars.stuttersPerSection)

    if settingVars.linearlyChange then
        updateFinalSV(settingVars.finalSVIndex, settingVars.svMultipliers2, settingVars.customSV,
            false)
        table.remove(settingVars.svMultipliers)
    else
        updateFinalSV(settingVars.finalSVIndex, settingVars.svMultipliers, settingVars.customSV,
            false)
    end
    updateGraphStats(settingVars.svGraphStats, settingVars.svMultipliers, settingVars.svDistances)
    updateGraphStats(settingVars.svGraph2Stats, settingVars.svMultipliers2,
        settingVars.svDistances2)
end

-- Makes the SV info windows for stutter SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function displayStutterSVWindows(settingVars)
    if settingVars.linearlyChange then
        startNextWindowNotCollapsed("svInfo2AutoOpen")
        makeSVInfoWindow("SV Info (Starting first SV)", settingVars.svGraphStats, nil,
            settingVars.svDistances, settingVars.svMultipliers,
            settingVars.stutterDuration, false)
        startNextWindowNotCollapsed("svInfo3AutoOpen")
        makeSVInfoWindow("SV Info (Ending first SV)", settingVars.svGraph2Stats, nil,
            settingVars.svDistances2, settingVars.svMultipliers2,
            settingVars.stutterDuration, false)
    else
        startNextWindowNotCollapsed("svInfo1AutoOpen")
        makeSVInfoWindow("SV Info", settingVars.svGraphStats, nil, settingVars.svDistances,
            settingVars.svMultipliers, settingVars.stutterDuration, false)
    end
end

-- Creates a button that adds or clears note times for the 2nd scroll for the splitscroll menu
-- Parameters
--    settingVars          : list of variables used for the current menu [Table]
--    noNoteTimesInitially : whether or not there were note times initially [Boolean]
function addOrClearNoteTimes(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes2 .. " note times assigned for 2nd scroll")

    local buttonText = "Assign selected note times to 2nd scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes, nil, settingVars)

    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 2nd scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes2 = {}
end

-- Creates a button that adds or clears note times for the 3rd scroll for the splitscroll menu
-- Parameters
--    settingVars          : list of variables used for the current menu [Table]
--    noNoteTimesInitially : whether or not there were note times initially [Boolean]
function addOrClearNoteTimes2(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes3 .. " note times assigned for 3rd scroll")

    local buttonText = "Assign selected note times to 3rd scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes2, nil, settingVars)

    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 3rd scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes3 = {}
end

-- Creates a button that adds or clears note times for the 4th scroll for the splitscroll menu
-- Parameters
--    settingVars          : list of variables used for the current menu [Table]
--    noNoteTimesInitially : whether or not there were note times initially [Boolean]
function addOrClearNoteTimes3(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes4 .. " note times assigned for 4th scroll")

    local buttonText = "Assign selected note times to 4th scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes3, nil, settingVars)

    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 4th scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes4 = {}
end

-- Creates a button that adds selected note times to the splitscroll 2nd scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes2, hitObject.StartTime)
    end
    settingVars.noteTimes2 = dedupe(settingVars.noteTimes2)
    settingVars.noteTimes2 = table.sort(settingVars.noteTimes2, sortAscending)
end

-- Creates a button that adds selected note times to the splitscroll 3rd scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes2(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes3, hitObject.StartTime)
    end
    settingVars.noteTimes3 = dedupe(settingVars.noteTimes3)
    settingVars.noteTimes3 = table.sort(settingVars.noteTimes3, sortAscending)
end

-- Creates a button that adds selected note times to the splitscroll 4th scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes3(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes4, hitObject.StartTime)
    end
    settingVars.noteTimes4 = dedupe(settingVars.noteTimes4)
    settingVars.noteTimes4 = table.sort(settingVars.noteTimes4, sortAscending)
end

-- Creates a button that adds frameTime objects to the list in the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addFrameTimes(settingVars)
    if not imgui.Button("Add selected notes to use for frames", ACTION_BUTTON_SIZE) then return end

    local hasAlreadyAddedLaneTime = {}
    for i = 1, map.GetKeyCount() do
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
    for _, hitObject in pairs(state.SelectedHitObjects) do
        local lane = hitObject.Lane
        local time = hitObject.StartTime
        if (not hasAlreadyAddedLaneTime[lane][time]) then
            hasAlreadyAddedLaneTime[lane][time] = true
            if frameTimeToIndex[time] then
                local index = frameTimeToIndex[time]
                local frameTime = settingVars.frameTimes[index]
                table.insert(frameTime.lanes, lane)
                frameTime.lanes = table.sort(frameTime.lanes, sortAscending)
            else
                local defaultFrame = settingVars.currentFrame
                local defaultPosition = 0
                local newFrameTime = createFrameTime(time, { lane }, defaultFrame, defaultPosition)
                table.insert(settingVars.frameTimes, newFrameTime)
                frameTimeToIndex[time] = #settingVars.frameTimes
            end
        end
    end
    settingVars.frameTimes = table.sort(settingVars.frameTimes, sortAscendingTime)
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
    local frameTimeSelectionArea = { ACTION_BUTTON_SIZE[1], 120 }
    imgui.BeginChild("FrameTimes", frameTimeSelectionArea, true)
    for i = 1, #settingVars.frameTimes do
        local frameTimeData = {}
        local frameTime = settingVars.frameTimes[i]
        frameTimeData[1] = frameTime.time
        frameTimeData[2] = table.concat(frameTime.lanes, ", ")
        frameTimeData[3] = frameTime.frame
        frameTimeData[4] = frameTime.position
        local selectableText = table.concat(frameTimeData, " | ")
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
    local barNoteHeight = round(2 * noteWidth / 5, 0)
    local noteColor = rgbaToUint(117, 117, 117, 255)
    local noteSkinType = NOTE_SKIN_TYPES[settingVars.noteSkinTypeIndex]
    local drawlist = imgui.GetWindowDrawList()
    local childHeight = 250
    imgui.BeginChild("Current Frame", { 255, childHeight }, true)
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
                elseif noteSkinType == "Arrow" then
                    local fuckArrows
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
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(menuVars.noteTimes, hitObject.StartTime)
    end
    menuVars.noteTimes = dedupe(menuVars.noteTimes)
    menuVars.noteTimes = table.sort(menuVars.noteTimes, sortAscending)
end

------------------------------------------------------------------------------- Notes, SVs, Offsets

-- Adds the final SV to the "svsToAdd" list if there isn't an SV at the end offset already
-- Parameters
--    svsToAdd     : list of SVs to add [Table]
--    endOffset    : millisecond time of the final SV [Int]
--    svMultiplier : the final SV's multiplier [Int/Float]
function addFinalSV(svsToAdd, endOffset, svMultiplier, force)
    local sv = getSVMultiplierAt(endOffset)
    local svExistsAtEndOffset = sv and (sv.StartTime == endOffset)
    if svExistsAtEndOffset and not force then return end

    addSVToList(svsToAdd, endOffset, svMultiplier, true)
end

function addFinalSSF(ssfsToAdd, endOffset, ssfMultiplier)
    local ssf = map.GetScrollSpeedFactorAt(endOffset)
    local ssfExistsAtEndOffset = ssf and (ssf.StartTime == endOffset)
    if ssfExistsAtEndOffset then return end

    addSSFToList(ssfsToAdd, endOffset, ssfMultiplier, true)
end

function addInitialSSF(ssfsToAdd, startOffset)
    local ssf = map.GetScrollSpeedFactorAt(startOffset)
    if (ssf == nil) then return end
    local ssfExistsAtStartOffset = ssf and (ssf.StartTime == startOffset)
    if ssfExistsAtStartOffset then return end

    addSSFToList(ssfsToAdd, startOffset, ssf.Multiplier, true)
end

-- Adds an SV with the start offset into the list if there isn't an SV there already
-- Parameters
--    svs         : list of SVs [Table]
--    startOffset : start offset in milliseconds for the list of SVs [Int]
function addStartSVIfMissing(svs, startOffset)
    if #svs ~= 0 and svs[1].StartTime == startOffset then return end
    addSVToList(svs, startOffset, getSVMultiplierAt(startOffset), false)
end

-- Creates and adds a new SV to an existing list of SVs
-- Parameters
--    svList     : list of SVs [Table]
--    offset     : offset in milliseconds for the new SV [Int/Float]
--    multiplier : multiplier for the new SV [Int/Float]
--    endOfList  : whether or not to add the SV to the end of the list (else, the front) [Boolean]
function addSVToList(svList, offset, multiplier, endOfList)
    local newSV = utils.CreateScrollVelocity(offset, multiplier)
    if endOfList then
        table.insert(svList, newSV)
        return
    end
    table.insert(svList, 1, newSV)
end

function addSSFToList(ssfList, offset, multiplier, endOfList)
    local newSSF = utils.CreateScrollSpeedFactor(offset, multiplier)
    if endOfList then
        table.insert(ssfList, newSSF)
        return
    end
    table.insert(ssfList, 1, newSSF)
end

-- Calculates the total msx displacements over time at offsets
-- Returns a table of total displacements [Table]
-- Parameters
--    noteOffsets : list of offsets (milliseconds) to calculate displacement at [Table]
--    noteSpacing : SV multiplier determining spacing [Int/Float]
function calculateDisplacementsFromNotes(noteOffsets, noteSpacing)
    local totalDisplacement = 0
    local displacements = { 0 }
    for i = 1, #noteOffsets - 1 do
        local noteOffset1 = noteOffsets[i]
        local noteOffset2 = noteOffsets[i + 1]
        local time = (noteOffsets[i + 1] - noteOffsets[i])
        local distance = time * noteSpacing
        totalDisplacement = totalDisplacement + distance
        table.insert(displacements, totalDisplacement)
    end
    return displacements
end

-- Calculates the total msx displacement over time for a given set of SVs
-- Returns a table of total displacements [Table]
-- Parameters
--    svs         : list of ordered svs to calculate displacement with [Table]
--    startOffset : starting time for displacement calculation [Int/Float]
--    endOffset   : ending time for displacement calculation [Int/Float]
function calculateDisplacementFromSVs(svs, startOffset, endOffset)
    return calculateDisplacementsFromSVs(svs, { startOffset, endOffset })[2]
end

-- Calculates the total msx displacements over time at offsets for a given set of SVs
-- Returns a table of total displacements [Table]
-- Parameters
--    svs     : list of ordered svs to calculate displacement with [Table]
--    offsets : list of offsets (milliseconds) to calculate displacement at [Table]
function calculateDisplacementsFromSVs(svs, offsets)
    local totalDisplacement = 0
    local displacements = {}
    local lastOffset = offsets[#offsets]
    addSVToList(svs, lastOffset, 0, true)
    local j = 1
    for i = 1, (#svs - 1) do
        local lastSV = svs[i]
        local nextSV = svs[i + 1]
        local svTimeDifference = nextSV.StartTime - lastSV.StartTime
        while nextSV.StartTime > offsets[j] do
            local svToOffsetTime = offsets[j] - lastSV.StartTime
            local displacement = totalDisplacement
            if svToOffsetTime > 0 then
                displacement = displacement + lastSV.Multiplier * svToOffsetTime
            end
            table.insert(displacements, displacement)
            j = j + 1
        end
        if svTimeDifference > 0 then
            local thisDisplacement = svTimeDifference * lastSV.Multiplier
            totalDisplacement = totalDisplacement + thisDisplacement
        end
    end
    table.remove(svs)
    table.insert(displacements, totalDisplacement)
    return displacements
end

-- Calculates still displacements
-- Returns the still displacements [Table]
-- Parameters
--    stillType        : type of still [String]
--    stillDistance    : distance of the still according to the still type [Int/Float]
--    svDisplacements  : list of displacements of notes based on svs [Table]
--    nsvDisplacements : list of displacements of notes based on notes only, no sv [Table]
function calculateStillDisplacements(stillType, stillDistance, svDisplacements, nsvDisplacements)
    local finalDisplacements = {}
    for i = 1, #svDisplacements do
        local difference = nsvDisplacements[i] - svDisplacements[i]
        table.insert(finalDisplacements, difference)
    end
    local extraDisplacement = stillDistance
    if stillType == "End" or stillType == "Otua" then
        extraDisplacement = stillDistance - finalDisplacements[#finalDisplacements]
    end
    if stillType ~= "No" then
        for i = 1, #finalDisplacements do
            finalDisplacements[i] = finalDisplacements[i] + extraDisplacement
        end
    end
    return finalDisplacements
end

-- Checks to see if enough notes are selected (ONLY works for minimumNotes = 0, 1, or 2)
-- Returns whether or not there are enough notes [Boolean]
-- Parameters
--    minimumNotes : minimum number of notes needed to be selected [Int]
function checkEnoughSelectedNotes(minimumNotes)
    if minimumNotes == 0 then return true end
    local selectedNotes = state.SelectedHitObjects
    local numSelectedNotes = #selectedNotes
    if numSelectedNotes == 0 then return false end
    if minimumNotes == 1 then return true end
    if numSelectedNotes > map.GetKeyCount() then return true end
    return selectedNotes[1].StartTime ~= selectedNotes[numSelectedNotes].StartTime
end

-- Gets removable SVs that are in the map at the exact time where an SV will get added
-- Parameters
--    svsToRemove   : list of SVs to remove [Table]
--    svTimeIsAdded : list of SVs times added [Table]
--    startOffset   : starting offset to remove after [Int]
--    endOffset     : end offset to remove before [Int]
function getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset, retroactiveSVRemovalTable)
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime <= endOffset + 1
        if svIsInRange then
            local svIsRemovable = svTimeIsAdded[sv.StartTime]
            if svIsRemovable then table.insert(svsToRemove, sv) end
        end
    end
    if (retroactiveSVRemovalTable) then
        for idx, sv in pairs(retroactiveSVRemovalTable) do
            local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime <= endOffset + 1
            if svIsInRange then
                local svIsRemovable = svTimeIsAdded[sv.StartTime]
                if svIsRemovable then table.remove(retroactiveSVRemovalTable, idx) end
            end
        end
    end
end

-- Removes and adds SVs
-- Parameters
--    svsToRemove : list of SVs to remove [Table]
--    svsToAdd    : list of SVs to add [Table]
function removeAndAddSVs(svsToRemove, svsToAdd)
    local tolerance = 0.035
    if #svsToAdd == 0 then return end
    for idx, sv in pairs(svsToRemove) do
        local baseSV = getSVMultiplierAt(sv.StartTime)
        if (math.abs(baseSV.StartTime - sv.StartTime) > tolerance) then
            table.remove(svsToRemove, idx)
        end
    end
    local editorActions = {
        utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
        utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd)
    }
    actions.PerformBatch(editorActions)
end

function removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
    if #ssfsToAdd == 0 then return end
    local editorActions = {
        utils.CreateEditorAction(action_type.RemoveScrollSpeedFactorBatch, ssfsToRemove),
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfsToAdd)
    }
    actions.PerformBatch(editorActions)
end

------------------------------------------------------------------------------------- Acting on SVs

function ssf(startTime, multiplier)
    return utils.CreateScrollSpeedFactor(startTime, multiplier)
end

function ssfVibrato(lowerStart, lowerEnd, higherStart, higherEnd, startTime, endTime, resolution, curvature)
    local exponent = 2 ^ (curvature / 100)
    local delta = endTime - startTime / 2 * resolution
    local time = startTime
    local ssfs = { ssf(startTime - getUsableDisplacementMultiplier(startTime), map.GetScrollSpeedFactorAt(time)) }
    while time < endTime do
        local x = ((time - startTime) - (endTime - startTime)) ^ exponent
        local y = ((time + delta - startTime) - (endTime - startTime)) ^ exponent
        table.insert(ssfs, ssf(time - getUsableDisplacementMultiplier(time), higherStart + x * (higherEnd - higherStart)))
        table.insert(ssfs, ssf(time, lowerStart + x * (lowerEnd - lowerStart)))
        table.insert(ssfs, ssf(time - getUsableDisplacementMultiplier(time), lowerStart + y * (lowerEnd - lowerStart)))
        table.insert(ssfs, ssf(time, higherStart + y * (higherEnd - higherStart)))
        time = time + 2 * delta
    end

    utils.PlaceScrollSpeedFactorBatch(ssfs)
end
