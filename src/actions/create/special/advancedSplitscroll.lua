
-- Places advanced split scroll SVs
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function placeAdvancedSplitScrollSVs(settingVars)
    local tempOffsets = {
        uniqueNoteOffsetsBetweenSelected(),
        settingVars.noteTimes2,
        settingVars.noteTimes3,
        settingVars.noteTimes4
    }
    for i = 2, settingVars.numScrolls do
        for _, offset in pairs(tempOffsets[i]) do
            table.insert(tempOffsets[1], offset)
        end
    end
    tempOffsets[1] = table.sort(tempOffsets[1], sortAscending)
    local firstOffset = tempOffsets[1][1]
    local lastOffset = tempOffsets[1][#tempOffsets[1]]
    local allNoteOffsets = uniqueNoteOffsetsBetween(firstOffset, lastOffset)
    placeAdvancedSplitScrollSVsActual(settingVars, allNoteOffsets)
end

-- Places advanced split scroll SVs
--[[ **NOTE**
    Due to how quaver stores(? or calculates?) SVs that are super big,
    some sv distances will be imprecise but close enough when using the
    svMultiplier + tpDistance * useableMultiplier. The svMultiplier is so small compared
    to the other number that Quaver ends up not using it. If you want to be extra precise
    when preserving relative note positions, you can place another set of SVs after placing
    the splitscoll SVs that corrects this discrepency by calculating
    the idealTargetDistance - actualDistancesWithFirstSplitscrollSVsPlace, then
    adding an svBeforeBefore or svBefore that accounts for the difference.
    The current code doesn't do that, but you can code it in. Same applies to basic splitscroll.
--]]
-- Parameters
--    settingVars    : list of variables used for the current menu [Table]
--    allNoteOffsets : all note offsets used for splitscroll
function placeAdvancedSplitScrollSVsActual(settingVars, allNoteOffsets)
    local numScrolls = settingVars.numScrolls
    local noteOffsetToScrollIndex = {}
    local tempOffsets = {
        allNoteOffsets,
        settingVars.noteTimes2,
        settingVars.noteTimes3,
        settingVars.noteTimes4
    }
    local firstOffset = tempOffsets[1][1]
    local lastOffset = tempOffsets[1][#tempOffsets[1]]
    local totalTime = lastOffset - firstOffset
    local noteOffsets = allNoteOffsets
    for i = 1, numScrolls do
        for _, offset in pairs(tempOffsets[i]) do
            noteOffsetToScrollIndex[offset] = i
        end
    end
    local svsToAdd = {}
    local lastDuration = 1 / getUsableDisplacementMultiplier(lastOffset)
    local svsToRemove = getSVsBetweenOffsets(firstOffset, lastOffset + 2 * lastDuration)
    local distanceBacks = {
        -settingVars.distanceBack,
        -settingVars.distanceBack2,
        -settingVars.distanceBack3
    }
    local totalDistanceBack = 0
    for i = 1, numScrolls - 1 do
        totalDistanceBack = totalDistanceBack - distanceBacks[i]
    end
    local tpDistances = {}
    for i = 1, numScrolls - 1 do
        tpDistances[i] = distanceBacks[i]
    end
    tpDistances[#tpDistances + 1] = totalDistanceBack
    local msPerFrame = settingVars.msPerFrame
    local numFrames = math.floor((totalTime - 1) / msPerFrame) + 1
    local noteIndex = 2
    local svIndexesForScrolls = {}
    for i = 1, numScrolls do
        svIndexesForScrolls[i] = 1
    end
    local svsInScroll = {
        settingVars.svsInScroll1,
        settingVars.svsInScroll2,
        settingVars.svsInScroll3,
        settingVars.svsInScroll4
    }
    for i = 1, numScrolls do
        addStartSVIfMissing(svsInScroll[i], firstOffset)
    end
    local splitscrollOffsets = {}
    for i = 0, numFrames - 1 do
        local timePassed = i * msPerFrame
        table.insert(splitscrollOffsets, timePassed + firstOffset)
    end
    table.insert(splitscrollOffsets, lastOffset)
    local frameDistancesInScroll = {}
    local noteDistancesInScroll = {}
    for i = 1, numScrolls do
        frameDistancesInScroll[i] = calculateDisplacementsFromSVs(svsInScroll[i], splitscrollOffsets)
        noteDistancesInScroll[i] = calculateDisplacementsFromSVs(svsInScroll[i], noteOffsets)
    end
    local splitscrollDistances = {}
    for i = 1, numFrames + 1 do
        local scrollIndex = ((i - 2) % numScrolls) + 1
        local nextScrollIndex = ((i - 1) % numScrolls) + 1
        local currentFrameDistance = frameDistancesInScroll[scrollIndex][i]
        local nextFrameDistance = frameDistancesInScroll[nextScrollIndex][i]
        splitscrollDistances[i] = nextFrameDistance - currentFrameDistance + tpDistances[scrollIndex]
    end
    for i = 1, numFrames do
        local isFinalFrame = i == numFrames
        local scrollIndex = ((i - 1) % numScrolls) + 1
        local nextScrollIndex = (scrollIndex % numScrolls) + 1
        local timeAt = splitscrollOffsets[i + 1]
        local multiplier = getUsableDisplacementMultiplier(timeAt)
        local duration = 1 / multiplier
        local timeBefore = timeAt - duration
        local timeAfter = timeAt + duration
        local noteOffset = noteOffsets[noteIndex]
        while noteOffset < timeAt do
            local noteScrollIndex = noteOffsetToScrollIndex[noteOffset]
            local noteInSameScroll = noteScrollIndex == scrollIndex
            local noteMultiplier = getUsableDisplacementMultiplier(noteOffset)
            local noteDuration = 1 / noteMultiplier
            local noteTimeBefore = noteOffset - noteDuration
            local noteTimeAt = noteOffset
            local noteTimeAfter = noteOffset + noteDuration
            for j = 1, numScrolls do
                local currentSVsInScroll = svsInScroll[j]
                while svIndexesForScrolls[j] <= #currentSVsInScroll and
                    currentSVsInScroll[svIndexesForScrolls[j]].StartTime < noteTimeBefore do
                    if j == scrollIndex then
                        table.insert(svsToAdd, currentSVsInScroll[svIndexesForScrolls[j]])
                    end
                    svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
                end
            end
            if noteInSameScroll then
                for j = 1, numScrolls do
                    local currentSVsInScroll = svsInScroll[j]
                    while svIndexesForScrolls[j] <= #currentSVsInScroll and
                        currentSVsInScroll[svIndexesForScrolls[j]].StartTime <= noteTimeAfter do
                        if j == scrollIndex then
                            table.insert(svsToAdd, currentSVsInScroll[svIndexesForScrolls[j]])
                        end
                        svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
                    end
                end
            else
                local currentSVsList = svsInScroll[scrollIndex]
                local safeCurrentSVsListIndex = svIndexesForScrolls[scrollIndex] - 1
                local currentSVBefore = currentSVsList[safeCurrentSVsListIndex]
                local currentSVAt = currentSVsList[safeCurrentSVsListIndex]
                local currentSVAfter = currentSVsList[safeCurrentSVsListIndex]
                for j = 1, numScrolls do
                    local currentSVsInScroll = svsInScroll[j]
                    while svIndexesForScrolls[j] <= #currentSVsInScroll and
                        currentSVsInScroll[svIndexesForScrolls[j]].StartTime <= noteTimeAfter do
                        if j == scrollIndex then
                            local svTime = currentSVsInScroll[svIndexesForScrolls[j]].StartTime
                            if svTime <= noteTimeBefore then
                                currentSVBefore = currentSVsInScroll[svIndexesForScrolls[j]]
                            end
                            if svTime <= noteTimeAt then
                                currentSVAt = currentSVsInScroll[svIndexesForScrolls[j]]
                            end
                            if svTime <= noteTimeAfter then
                                currentSVAfter = currentSVsInScroll[svIndexesForScrolls[j]]
                            end
                        end
                        svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
                    end
                end
                local targetNoteDistance = noteDistancesInScroll[noteScrollIndex][noteIndex]
                local currentNoteDistance = noteDistancesInScroll[scrollIndex][noteIndex]
                local noteDistance = targetNoteDistance - currentNoteDistance
                if noteScrollIndex > scrollIndex then
                    for j = scrollIndex, noteScrollIndex - 1 do
                        noteDistance = noteDistance + tpDistances[j]
                    end
                else
                    for j = noteScrollIndex, scrollIndex - 1 do
                        noteDistance = noteDistance - tpDistances[j]
                    end
                end
                local svBefore = currentSVBefore.Multiplier + noteDistance * noteMultiplier
                local svAt = currentSVAt.Multiplier - noteDistance * noteMultiplier
                local svAfter = currentSVAfter.Multiplier
                addSVToList(svsToAdd, noteTimeBefore, svBefore, true)
                addSVToList(svsToAdd, noteTimeAt, svAt, true)
                addSVToList(svsToAdd, noteTimeAfter, svAfter, true)
            end
            noteIndex = noteIndex + 1
            noteOffset = noteOffsets[noteIndex]
        end
        for j = 1, numScrolls do
            local currentSVsInScroll = svsInScroll[j]
            while svIndexesForScrolls[j] <= #currentSVsInScroll and
                currentSVsInScroll[svIndexesForScrolls[j]].StartTime < timeBefore do
                if j == scrollIndex then
                    table.insert(svsToAdd, currentSVsInScroll[svIndexesForScrolls[j]])
                end
                svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
            end
        end
        if noteOffset == timeAt then
            local noteScrollIndex = noteOffsetToScrollIndex[noteOffset]
            local noteInSameScroll = noteScrollIndex == scrollIndex
            local svBefore = svsInScroll[scrollIndex][svIndexesForScrolls[scrollIndex] - 1]
            local svAt = svsInScroll[nextScrollIndex][svIndexesForScrolls[nextScrollIndex] - 1]
            for j = 1, numScrolls do
                local currentSVsInScroll = svsInScroll[j]
                while svIndexesForScrolls[j] <= #currentSVsInScroll and
                    currentSVsInScroll[svIndexesForScrolls[j]].StartTime <= timeAfter do
                    local currentSVStartTime = currentSVsInScroll[svIndexesForScrolls[j]].StartTime
                    local beforeCandidate = currentSVStartTime <= timeBefore
                    local atCandidate = currentSVStartTime <= timeAt
                    local forCurrentScroll = (j == scrollIndex)
                    local forNextScroll = (j == nextScrollIndex)
                    if forCurrentScroll and beforeCandidate then
                        svBefore = currentSVsInScroll[svIndexesForScrolls[j]]
                    end
                    if forNextScroll and atCandidate then
                        svAt = currentSVsInScroll[svIndexesForScrolls[j]]
                    end
                    svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
                end
            end
            local svAfter = svsInScroll[nextScrollIndex][svIndexesForScrolls[nextScrollIndex] - 1]
            local targetNoteDistance = noteDistancesInScroll[noteScrollIndex][noteIndex]
            local currentNoteDistance = noteDistancesInScroll[scrollIndex][noteIndex]
            local noteDistance = targetNoteDistance - currentNoteDistance
            if noteScrollIndex > scrollIndex then
                for j = scrollIndex, noteScrollIndex - 1 do
                    noteDistance = noteDistance + tpDistances[j]
                end
            else
                for j = noteScrollIndex, scrollIndex - 1 do
                    noteDistance = noteDistance - tpDistances[j]
                end
            end
            if noteInSameScroll then noteDistance = 0 end
            local tpDistanceAt = splitscrollDistances[i + 1] - noteDistance
            local svMultiplierBefore = svBefore.Multiplier + noteDistance * multiplier
            local svMultiplierAt = svAt.Multiplier + tpDistanceAt * multiplier
            local svMultiplierAfter = svAfter.Multiplier
            if isFinalFrame then
                local distanceBackToScroll1 = -frameDistancesInScroll[noteScrollIndex][numFrames + 1] +
                    frameDistancesInScroll[1][numFrames + 1]
                for j = 1, noteScrollIndex - 1 do
                    distanceBackToScroll1 = distanceBackToScroll1 - tpDistances[j]
                end
                svMultiplierAt = getSVMultiplierAt(lastOffset) + distanceBackToScroll1 * multiplier
                svMultiplierAfter = getSVMultiplierAt(lastOffset + lastDuration)
            end
            addSVToList(svsToAdd, timeBefore, svMultiplierBefore, true)
            addSVToList(svsToAdd, timeAt, svMultiplierAt, true)
            addSVToList(svsToAdd, timeAfter, svMultiplierAfter, true)
            noteIndex = noteIndex + 1
        else
            for j = 1, numScrolls do
                local currentSVsInScroll = svsInScroll[j]
                while svIndexesForScrolls[j] <= #currentSVsInScroll and
                    currentSVsInScroll[svIndexesForScrolls[j]].StartTime < timeAt do
                    if j == scrollIndex then
                        table.insert(svsToAdd, currentSVsInScroll[svIndexesForScrolls[j]])
                    end
                    svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
                end
            end
            local svAt = svsInScroll[nextScrollIndex][svIndexesForScrolls[nextScrollIndex] - 1]
            for j = 1, numScrolls do
                local currentSVsInScroll = svsInScroll[j]
                while svIndexesForScrolls[j] <= #currentSVsInScroll and
                    currentSVsInScroll[svIndexesForScrolls[j]].StartTime <= timeAfter do
                    if j == nextScrollIndex then
                        svAt = currentSVsInScroll[svIndexesForScrolls[j]]
                    end
                    svIndexesForScrolls[j] = svIndexesForScrolls[j] + 1
                end
            end
            local svAfter = svsInScroll[nextScrollIndex][svIndexesForScrolls[nextScrollIndex] - 1]
            local svMultiplierAt = svAt.Multiplier + splitscrollDistances[i + 1] * multiplier
            local svMultiplierAfter = svAfter.Multiplier
            addSVToList(svsToAdd, timeAt, svMultiplierAt, true)
            addSVToList(svsToAdd, timeAfter, svMultiplierAfter, true)
        end
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end