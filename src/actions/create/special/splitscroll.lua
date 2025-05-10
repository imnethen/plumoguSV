-- Places split scroll SVs
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function placeSplitScrollSVs(settingVars)
    local noteOffsetToScrollIndex = {}
    local offsets = uniqueNoteOffsetsBetweenSelected()
    for _, offset in pairs(settingVars.noteTimes2) do
        table.insert(offsets, offset)
    end
    offsets = table.sort(offsets, sortAscending)
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    local totalTime = lastOffset - firstOffset
    local noteOffsets = uniqueNoteOffsetsBetween(firstOffset, lastOffset)
    for _, offset in pairs(noteOffsets) do
        noteOffsetToScrollIndex[offset] = 1
    end
    for _, offset in pairs(settingVars.noteTimes2) do
        noteOffsetToScrollIndex[offset] = 2
    end
    local svsToAdd = {}
    local lastDuration = 1 / getUsableDisplacementMultiplier(lastOffset)
    local svsToRemove = getSVsBetweenOffsets(firstOffset, lastOffset + 2 * lastDuration)
    local scrollSpeeds = { settingVars.scrollSpeed1, settingVars.scrollSpeed2 }
    local scrollDifference = scrollSpeeds[1] - scrollSpeeds[2]
    local noteHeights = { settingVars.height1, settingVars.height2 }
    local tpDistance = settingVars.distanceBack
    local msPerFrame = settingVars.msPerFrame
    local numFrames = math.floor((totalTime - 1) / msPerFrame) + 1
    local noteIndex = 2
    addSVToList(svsToAdd, firstOffset, scrollSpeeds[1], true)
    for i = 1, numFrames do
        local isLastFrame = i == numFrames
        local scrollIndex = ((i - 1) % 2) + 1
        local timePassed = i * msPerFrame
        if isLastFrame then timePassed = totalTime end
        local frameTpDistance = tpDistance + timePassed * scrollDifference
        if scrollIndex == 1 then frameTpDistance = -frameTpDistance end
        local currentHeight = noteHeights[scrollIndex]
        local currentScrollSpeed = scrollSpeeds[scrollIndex]
        local nextScrollSpeed = scrollSpeeds[scrollIndex + 1] or scrollSpeeds[1]
        if isLastFrame then nextScrollSpeed = getSVMultiplierAt(lastOffset + lastDuration) end

        local timeAt = firstOffset + timePassed
        local multiplier = getUsableDisplacementMultiplier(timeAt)
        local duration = 1 / multiplier
        local timeBefore = timeAt - duration
        local timeAfter = timeAt + duration
        local noteOffset = noteOffsets[noteIndex]
        while noteOffset < timeAt do
            local noteMultiplier = getUsableDisplacementMultiplier(noteOffset)
            local noteDuration = 1 / noteMultiplier
            local noteScrollIndex = noteOffsetToScrollIndex[noteOffset]
            local noteInOtherScroll = noteScrollIndex ~= scrollIndex
            local noteTimeBefore = noteOffset - noteDuration
            local noteTimeAt = noteOffset
            local noteTimeAfter = noteOffset + noteDuration
            local noteHeight = noteHeights[noteScrollIndex]
            local tpDistanceToOtherScroll = 0
            if noteInOtherScroll then
                local timeElapsed = noteOffset - firstOffset
                tpDistanceToOtherScroll = tpDistance + timeElapsed * scrollDifference
                if scrollIndex == 1 then tpDistanceToOtherScroll = -tpDistanceToOtherScroll end
            end
            local noteDisplacement = noteHeight + tpDistanceToOtherScroll
            local svBefore = currentScrollSpeed + noteDisplacement * noteMultiplier
            local svAt = currentScrollSpeed - noteDisplacement * noteMultiplier
            local svAfter = currentScrollSpeed
            addSVToList(svsToAdd, noteTimeBefore, svBefore, true)
            addSVToList(svsToAdd, noteTimeAt, svAt, true)
            addSVToList(svsToAdd, noteTimeAfter, svAfter, true)
            noteIndex = noteIndex + 1
            noteOffset = noteOffsets[noteIndex]
        end
        local svAt = nextScrollSpeed + frameTpDistance * multiplier
        if noteOffset == timeAt then
            local noteScrollIndex = noteOffsetToScrollIndex[noteOffset]
            local noteHeight = noteHeights[noteScrollIndex]
            local noteInOtherScroll = noteScrollIndex ~= scrollIndex
            local displacementBefore = noteHeight
            local displacementAt = -noteHeight
            if noteInOtherScroll then
                displacementBefore = displacementBefore + frameTpDistance
                if isLastFrame and noteScrollIndex == 2 then
                    displacementAt = displacementAt - frameTpDistance
                end
            elseif (not isLastFrame) or noteScrollIndex == 2 then
                displacementAt = displacementAt + frameTpDistance
            end
            local svBefore = currentScrollSpeed + displacementBefore * multiplier
            svAt = nextScrollSpeed + displacementAt * multiplier
            addSVToList(svsToAdd, timeBefore, svBefore, true)
            noteIndex = noteIndex + 1
        end
        addSVToList(svsToAdd, timeAt, svAt, true)
        addSVToList(svsToAdd, timeAfter, nextScrollSpeed, true)
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
