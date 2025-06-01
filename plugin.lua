
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
    tempOffsets[1] = sort(tempOffsets[1], sortAscending)
    local firstOffset = tempOffsets[1][1]
    local lastOffset = tempOffsets[1][#tempOffsets[1]]
    local allNoteOffsets = uniqueNoteOffsetsBetween(firstOffset, lastOffset)
    placeAdvancedSplitScrollSVsActual(settingVars, allNoteOffsets)
end
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
function placeAdvancedSplitScrollSVsV2(settingVars)
    local splitscrollLayers = settingVars.splitscrollLayers
    local convertedSettingVars = {
        numScrolls = settingVars.numScrolls,
        msPerFrame = settingVars.msPerFrame,
        scrollIndex = settingVars.scrollIndex,
        distanceBack = settingVars.distanceBack,
        distanceBack2 = settingVars.distanceBack2,
        distanceBack3 = settingVars.distanceBack3,
        noteTimes2 = {},
        noteTimes3 = {},
        noteTimes4 = {},
        svsInScroll1 = {},
        svsInScroll2 = {},
        svsInScroll3 = {},
        svsInScroll4 = {}
    }
    local allLayerNotes = {}
    if splitscrollLayers[1] ~= nil then
        local layerNotes = splitscrollLayers[1].notes
        convertedSettingVars.svsInScroll1 = splitscrollLayers[1].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
        end
    end
    if splitscrollLayers[2] ~= nil then
        local layerNotes = splitscrollLayers[2].notes
        convertedSettingVars.svsInScroll2 = splitscrollLayers[2].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
            table.insert(convertedSettingVars.noteTimes2, layerNotes[i].StartTime)
        end
        convertedSettingVars.noteTimes2 = table.dedupe(convertedSettingVars.noteTimes2)
        convertedSettingVars.noteTimes2 = sort(convertedSettingVars.noteTimes2, sortAscending)
    end
    if splitscrollLayers[3] ~= nil then
        local layerNotes = splitscrollLayers[3].notes
        convertedSettingVars.svsInScroll3 = splitscrollLayers[3].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
            table.insert(convertedSettingVars.noteTimes3, layerNotes[i].StartTime)
        end
        convertedSettingVars.noteTimes3 = table.dedupe(convertedSettingVars.noteTimes3)
        convertedSettingVars.noteTimes3 = sort(convertedSettingVars.noteTimes3, sortAscending)
    end
    if splitscrollLayers[4] ~= nil then
        local layerNotes = splitscrollLayers[4].notes
        convertedSettingVars.noteTimes4 = layerNotes
        convertedSettingVars.svsInScroll4 = splitscrollLayers[4].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
            table.insert(convertedSettingVars.noteTimes4, layerNotes[i].StartTime)
        end
        convertedSettingVars.noteTimes4 = table.dedupe(convertedSettingVars.noteTimes4)
        convertedSettingVars.noteTimes4 = sort(convertedSettingVars.noteTimes4, sortAscending)
    end
    allLayerNotes = sort(allLayerNotes, sortAscendingStartTime)
    local startOffset = allLayerNotes[1].StartTime
    local endOffset = allLayerNotes[#allLayerNotes].StartTime
    local hasAddedLaneTime = {}
    for _ = 1, map.GetKeyCount() do
        table.insert(hasAddedLaneTime, {})
    end
    local notesToPlace = {}
    local allNoteTimes = {}
    for i = 1, #allLayerNotes do
        local note = allLayerNotes[i]
        local lane = note.Lane
        local startTime = note.startTime
        if hasAddedLaneTime[lane][startTime] == nil then
            table.insert(notesToPlace, note)
            table.insert(allNoteTimes, startTime)
            hasAddedLaneTime[lane][startTime] = true
        end
    end
    allNoteTimes = table.dedupe(allNoteTimes)
    allNoteTimes = sort(allNoteTimes, sortAscending)
    local editorActions = {
        actionRemoveNotesBetween(startOffset, endOffset),
        utils.CreateEditorAction(action_type.PlaceHitObjectBatch, notesToPlace)
    }
    actions.PerformBatch(editorActions)
    actions.SetHitObjectSelection(notesToPlace)
    placeAdvancedSplitScrollSVsActual(convertedSettingVars, allNoteTimes)
end
function displaceNotesForAnimationFrames(settingVars)
    local frameDistance = settingVars.frameDistance
    local initialDistance = settingVars.distance
    local numFrames = settingVars.numFrames
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local selectedStartTime = uniqueSelectedNoteOffsets()[1]
    local firstFrameTimeTime = settingVars.frameTimes[1].time
    local lastFrameTimeTime = settingVars.frameTimes[#settingVars.frameTimes].time
    local firstOffset = math.min(selectedStartTime, firstFrameTimeTime)
    local lastOffset = math.max(selectedStartTime, lastFrameTimeTime)
    for i = 1, #settingVars.frameTimes do
        local frameTime = settingVars.frameTimes[i]
        local noteOffset = frameTime.time
        local frame = frameTime.frame
        local position = frameTime.position
        local startOffset = math.min(selectedStartTime, noteOffset)
        local endOffset = math.max(selectedStartTime, noteOffset)
        local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
        addStartSVIfMissing(svsBetweenOffsets, startOffset)
        local distanceBetweenOffsets = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset,
            endOffset)
        local distanceToTargetNote = distanceBetweenOffsets
        if selectedStartTime < noteOffset then distanceToTargetNote = -distanceBetweenOffsets end
        local numFrameDistances = frame - 1
        if settingVars.reverseFrameOrder then numFrameDistances = numFrames - frame end
        local totalFrameDistances = frameDistance * numFrameDistances
        local distanceAfterTargetNote = initialDistance + totalFrameDistances + position
        local noteDisplaceAmount = distanceToTargetNote + distanceAfterTargetNote
        local beforeDisplacement = noteDisplaceAmount
        local atDisplacement = -noteDisplaceAmount
        local afterDisplacement = 0
        prepareDisplacingSVs(noteOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement)
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, firstOffset, lastOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function placePenisSV(settingVars)
    local startTime = uniqueNoteOffsetsBetweenSelected()[1]
    local svs = {}
    for j = 0, 1 do
        for i = 0, 100 do
            local time = startTime + i * settingVars.bWidth / 100 + j * (settingVars.sWidth + settingVars.bWidth)
            local circVal = math.sqrt(1 - ((i / 50) - 1) ^ 2)
            local trueVal = settingVars.bCurvature / 100 * circVal + (1 - settingVars.bCurvature / 100)
            table.insert(svs, utils.CreateScrollVelocity(time, trueVal))
        end
    end
    for i = 0, 100 do
        local time = startTime + settingVars.bWidth + i * settingVars.sWidth / 100
        local circVal = math.sqrt(1 - ((i / 50) - 1) ^ 2)
        local trueVal = settingVars.sCurvature / 100 * circVal + (3.75 - settingVars.sCurvature / 100)
        table.insert(svs, utils.CreateScrollVelocity(time, trueVal))
    end
    removeAndAddSVs(getSVsBetweenOffsets(startTime, startTime + settingVars.sWidth + settingVars.bWidth * 2), svs)
end
function placeSplitScrollSVs(settingVars)
    local noteOffsetToScrollIndex = {}
    local offsets = uniqueNoteOffsetsBetweenSelected()
    for _, offset in pairs(settingVars.noteTimes2) do
        table.insert(offsets, offset)
    end
    offsets = sort(offsets, sortAscending)
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
function placeStutterSVs(settingVars)
    local finalSVType = FINAL_SV_TYPES[settingVars.finalSVIndex]
    local lastFirstStutter = settingVars.startSV
    local lastMultiplier = settingVars.svMultipliers[3]
    if settingVars.linearlyChange then
        lastFirstStutter = settingVars.endSV
        lastMultiplier = settingVars.svMultipliers2[3]
    end
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    local totalNumStutters = (#offsets - 1) * settingVars.stuttersPerSection
    local firstStutterSVs = generateLinearSet(settingVars.startSV, lastFirstStutter,
        totalNumStutters)
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(firstOffset, lastOffset, finalSVType == "Override")
    local stutterIndex = 1
    for i = 1, #offsets - 1 do
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local stutterOffsets = generateLinearSet(startOffset, endOffset,
            settingVars.stuttersPerSection + 1)
        for j = 1, #stutterOffsets - 1 do
            local svMultipliers = generateStutterSet(firstStutterSVs[stutterIndex],
                settingVars.stutterDuration,
                settingVars.avgSV,
                settingVars.controlLastSV)
            local stutterStart = stutterOffsets[j]
            local stutterEnd = stutterOffsets[j + 1]
            local timeInterval = stutterEnd - stutterStart
            local secondSVOffset = stutterStart + timeInterval * settingVars.stutterDuration / 100
            addSVToList(svsToAdd, stutterStart, svMultipliers[1], true)
            addSVToList(svsToAdd, secondSVOffset, svMultipliers[2], true)
            stutterIndex = stutterIndex + 1
        end
    end
    addFinalSV(svsToAdd, lastOffset, lastMultiplier, finalSVType == "Override")
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function placeStutterSSFs(settingVars)
    local lastFirstStutter = settingVars.startSV
    local lastMultiplier = settingVars.svMultipliers[3]
    if settingVars.linearlyChange then
        lastFirstStutter = settingVars.endSV
        lastMultiplier = settingVars.svMultipliers2[3]
    end
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    local totalNumStutters = (#offsets - 1) * settingVars.stuttersPerSection
    local firstStutterSVs = generateLinearSet(settingVars.startSV, lastFirstStutter,
        totalNumStutters)
    local ssfsToAdd = {}
    local ssfsToRemove = getSSFsBetweenOffsets(firstOffset, lastOffset)
    local stutterIndex = 1
    for i = 1, #offsets - 1 do
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local stutterOffsets = generateLinearSet(startOffset, endOffset,
            settingVars.stuttersPerSection + 1)
        for j = 1, #stutterOffsets - 1 do
            local ssfMultipliers = generateStutterSet(firstStutterSVs[stutterIndex],
                settingVars.stutterDuration,
                settingVars.avgSV,
                settingVars.controlLastSV)
            local stutterStart = stutterOffsets[j]
            local stutterEnd = stutterOffsets[j + 1]
            local timeInterval = stutterEnd - stutterStart
            local secondSVOffset = stutterStart + timeInterval * settingVars.stutterDuration / 100
            addSSFToList(ssfsToAdd, stutterStart, ssfMultipliers[1], true)
            addSSFToList(ssfsToAdd, secondSVOffset, ssfMultipliers[2], true)
            stutterIndex = stutterIndex + 1
        end
    end
    addFinalSSF(ssfsToAdd, lastOffset, lastMultiplier)
    removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
end
function placeTeleportStutterSVs(settingVars)
    local finalSVType = FINAL_SV_TYPES[settingVars.finalSVIndex]
    local svPercent = settingVars.svPercent / 100
    local lastSVPercent = svPercent
    local lastMainSV = settingVars.mainSV
    if settingVars.linearlyChange then
        lastSVPercent = settingVars.svPercent2 / 100
        lastMainSV = settingVars.mainSV2
    end
    local offsets = uniqueNoteOffsetsBetweenSelected()
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    local numTeleportSets = #offsets - 1
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(firstOffset, lastOffset, finalSVType == "Override")
    local svPercents = generateLinearSet(svPercent, lastSVPercent, numTeleportSets)
    local mainSVs = generateLinearSet(settingVars.mainSV, lastMainSV, numTeleportSets)
    removeAndAddSVs(svsToRemove, svsToAdd)
    for i = 1, numTeleportSets do
        local thisMainSV = mainSVs[i]
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local offsetInterval = endOffset - startOffset
        local startMultiplier = getUsableDisplacementMultiplier(startOffset)
        local startDuration = 1 / startMultiplier
        local endMultiplier = getUsableDisplacementMultiplier(endOffset)
        local endDuration = 1 / endMultiplier
        local startDistance = offsetInterval * svPercents[i]
        if settingVars.useDistance then startDistance = settingVars.distance end
        local expectedDistance = offsetInterval * settingVars.avgSV
        local traveledDistance = offsetInterval * thisMainSV
        local endDistance = expectedDistance - startDistance - traveledDistance
        local sv1 = thisMainSV + startDistance * startMultiplier
        local sv2 = thisMainSV
        local sv3 = thisMainSV + endDistance * endMultiplier
        addSVToList(svsToAdd, startOffset, sv1, true)
        if sv2 ~= sv1 then addSVToList(svsToAdd, startOffset + startDuration, sv2, true) end
        if sv3 ~= sv2 then addSVToList(svsToAdd, endOffset - endDuration, sv3, true) end
    end
    local finalMultiplier = settingVars.avgSV
    if finalSVType ~= "Normal" then
        finalMultiplier = settingVars.customSV
    end
    addFinalSV(svsToAdd, lastOffset, finalMultiplier, finalSVType == "Override")
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function placeTeleportStutterSSFs(settingVars)
    local finalSVType = FINAL_SV_TYPES[settingVars.finalSVIndex]
    local svPercent = settingVars.svPercent / 100
    local lastSVPercent = svPercent
    local lastMainSV = settingVars.mainSV
    if settingVars.linearlyChange then
        lastSVPercent = settingVars.svPercent2 / 100
        lastMainSV = settingVars.mainSV2
    end
    local offsets = uniqueNoteOffsetsBetweenSelected()
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    local numTeleportSets = #offsets - 1
    local ssfsToAdd = {}
    local ssfsToRemove = getSSFsBetweenOffsets(firstOffset, lastOffset, finalSVType == "Override")
    local ssfPercents = generateLinearSet(svPercent, lastSVPercent, numTeleportSets)
    local mainSSFs = generateLinearSet(settingVars.mainSV, lastMainSV, numTeleportSets)
    removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
    for i = 1, numTeleportSets do
        local thisMainSSF = mainSSFs[i]
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local offsetInterval = endOffset - startOffset
        local startMultiplier = getUsableDisplacementMultiplier(startOffset)
        local startDuration = 1 / startMultiplier
        local endMultiplier = getUsableDisplacementMultiplier(endOffset)
        local endDuration = 1 / endMultiplier
        local startDistance = offsetInterval * ssfPercents[i]
        if settingVars.useDistance then startDistance = settingVars.distance end
        local expectedDistance = offsetInterval * settingVars.avgSV
        local traveledDistance = offsetInterval * thisMainSSF
        local endDistance = expectedDistance - startDistance - traveledDistance
        local ssf1 = thisMainSSF + startDistance * startMultiplier
        local ssf2 = thisMainSSF
        local ssf3 = thisMainSSF + endDistance * endMultiplier
        addSSFToList(ssfsToAdd, startOffset, ssf1, true)
        if ssf2 ~= ssf1 then addSSFToList(ssfsToAdd, startOffset + startDuration, ssf2, true) end
        if ssf3 ~= ssf2 then addSSFToList(ssfsToAdd, endOffset - endDuration, ssf3, true) end
    end
    local finalMultiplier = settingVars.avgSV
    if finalSVType ~= "Normal" then
        finalMultiplier = settingVars.customSV
    end
    addFinalSSF(ssfsToAdd, lastOffset, finalMultiplier, finalSVType == "Override")
    removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
end
function placeExponentialSpecialSVs(globalVars, menuVars)
    if (menuVars.settingVars.distanceMode == 2) then
        placeSVs(globalVars, menuVars, nil, nil, nil, menuVars.settingVars.distance)
    end
end
function placeSSFs(globalVars, menuVars)
    local numMultipliers = #menuVars.svMultipliers
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    local ssfsToAdd = {}
    local ssfsToRemove = getSSFsBetweenOffsets(firstOffset, lastOffset)
    if globalVars.dontReplaceSV then
        ssfsToRemove = {}
    end
    for i = 1, #offsets - 1 do
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local ssfOffsets = generateLinearSet(startOffset, endOffset, #menuVars.svDistances)
        for j = 1, #ssfOffsets - 1 do
            local offset = ssfOffsets[j]
            local multiplier = menuVars.svMultipliers[j]
            addSSFToList(ssfsToAdd, offset, multiplier, true)
        end
    end
    local lastMultiplier = menuVars.svMultipliers[numMultipliers]
    addFinalSSF(ssfsToAdd, lastOffset, lastMultiplier)
    addInitialSSF(ssfsToAdd, firstOffset - 1 / getUsableDisplacementMultiplier(firstOffset))
    removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
end
function placeSVs(globalVars, menuVars, place, optionalStart, optionalEnd, optionalDistance)
    local finalSVType = FINAL_SV_TYPES[menuVars.settingVars.finalSVIndex]
    local placingStillSVs = menuVars.noteSpacing ~= nil
    local numMultipliers = #menuVars.svMultipliers
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    if placingStillSVs then
        offsets = uniqueNoteOffsetsBetweenSelected()
        if (place == false) then
            offsets = uniqueNoteOffsetsBetween(optionalStart, optionalEnd)
        end
    end
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    if placingStillSVs then offsets = { firstOffset, lastOffset } end
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(firstOffset, lastOffset, finalSVType == "Override")
    if (not placingStillSVs) and globalVars.dontReplaceSV then
        svsToRemove = {}
    end
    for i = 1, #offsets - 1 do
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local svOffsets = generateLinearSet(startOffset, endOffset, #menuVars.svDistances)
        for j = 1, #svOffsets - 1 do
            local offset = svOffsets[j]
            local multiplier = menuVars.svMultipliers[j]
            if (optionalDistance ~= nil) then
                multiplier = optionalDistance / (endOffset - startOffset) * math.abs(multiplier)
            end
            addSVToList(svsToAdd, offset, multiplier, true)
        end
    end
    local lastMultiplier = menuVars.svMultipliers[numMultipliers]
    if (place == nil or place == true) then
        if placingStillSVs then
            local tbl = getStillSVs(menuVars, firstOffset, lastOffset,
                sort(svsToAdd, sortAscendingStartTime), svsToAdd)
            svsToAdd = table.combine(svsToAdd, tbl.svsToAdd)
        end
        addFinalSV(svsToAdd, lastOffset, lastMultiplier, finalSVType == "Override")
        removeAndAddSVs(svsToRemove, svsToAdd)
        return
    end
    local tbl = getStillSVs(menuVars, firstOffset, lastOffset,
        sort(svsToAdd, sortAscendingStartTime), svsToAdd)
    svsToRemove = table.combine(svsToRemove, tbl.svsToRemove)
    svsToAdd = table.combine(svsToAdd, tbl.svsToAdd)
    return { svsToRemove = svsToRemove, svsToAdd = svsToAdd }
end
function placeStillSVsParent(globalVars, menuVars)
    local svsToRemove = {}
    local svsToAdd = {}
    if (menuVars.stillBehavior == 1) then
        if (STANDARD_SVS[menuVars.svTypeIndex] == "Exponential" and menuVars.settingVars.distanceMode == 2) then
            placeSVs(globalVars, menuVars, nil, nil, nil, menuVars.settingVars.distance)
        else
            placeSVs(globalVars, menuVars)
        end
        return
    end
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    for i = 1, (#offsets - 1) do
        if (STANDARD_SVS[menuVars.svTypeIndex] == "Exponential" and menuVars.settingVars.distanceMode == 2) then
            tbl = placeSVs(globalVars, menuVars, false, offsets[i], offsets[i + 1], menuVars.settingVars.distance)
        else
            tbl = placeSVs(globalVars, menuVars, false, offsets[i], offsets[i + 1])
        end
        svsToRemove = table.combine(svsToRemove, tbl.svsToRemove)
        svsToAdd = table.combine(svsToAdd, tbl.svsToAdd)
    end
    addFinalSV(svsToAdd, offsets[#offsets], menuVars.svMultipliers[#menuVars.svMultipliers], true)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function getStillSVs(menuVars, optionalStart, optionalEnd, svs, retroactiveSVRemovalTable)
    local stillType = STILL_TYPES[menuVars.stillTypeIndex]
    local noteSpacing = menuVars.noteSpacing
    local stillDistance = menuVars.stillDistance
    local noteOffsets = uniqueNoteOffsetsBetween(optionalStart, optionalEnd)
    local firstOffset = noteOffsets[1]
    local lastOffset = noteOffsets[#noteOffsets]
    if stillType == "Auto" then
        local multiplier = getUsableDisplacementMultiplier(firstOffset)
        local duration = 1 / multiplier
        local timeBefore = firstOffset - duration
        multiplierBefore = getSVMultiplierAt(timeBefore)
        stillDistance = multiplierBefore * duration
    elseif stillType == "Otua" then
        local multiplier = getUsableDisplacementMultiplier(lastOffset)
        local duration = 1 / multiplier
        local timeAt = lastOffset
        local multiplierAt = getSVMultiplierAt(timeAt)
        stillDistance = -multiplierAt * duration
    end
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local svsBetweenOffsets = getHypotheticalSVsBetweenOffsets(svs, firstOffset, lastOffset)
    local svDisplacements = calculateDisplacementsFromSVs(svsBetweenOffsets, noteOffsets)
    local nsvDisplacements = calculateDisplacementsFromNotes(noteOffsets, noteSpacing)
    local finalDisplacements = calculateStillDisplacements(stillType, stillDistance,
        svDisplacements, nsvDisplacements)
    for i = 1, #noteOffsets do
        local noteOffset = noteOffsets[i]
        local beforeDisplacement = nil
        local atDisplacement = 0
        local afterDisplacement = nil
        if i ~= #noteOffsets then
            atDisplacement = -finalDisplacements[i]
            afterDisplacement = 0
        end
        if i ~= 1 then
            beforeDisplacement = finalDisplacements[i]
        end
        local baseSVs = table.duplicate(svs)
        prepareDisplacingSVs(noteOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement, true, baseSVs)
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, firstOffset, lastOffset, retroactiveSVRemovalTable)
    while (svsToAdd[#svsToAdd].StartTime == optionalEnd) do
        table.remove(svsToAdd, #svsToAdd)
    end
    return { svsToRemove = svsToRemove, svsToAdd = svsToAdd }
end
function linearSSFVibrato(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startTime = offsets[1]
    local endTime = offsets[#offsets]
    local exponent = 2 ^ (menuVars.curvature / 100)
    local delta = 500 / menuVars.resolution
    local time = startTime
    local ssfs = { ssf(startTime - 1 / getUsableDisplacementMultiplier(startTime),
        getSSFMultiplierAt(time)) }
    while time < endTime do
        local x = ((time - startTime) / (endTime - startTime)) ^ exponent
        local y = ((time + delta - startTime) / (endTime - startTime)) ^ exponent
        table.insert(ssfs,
            ssf(time - 1 / getUsableDisplacementMultiplier(time),
                menuVars.higherStart + x * (menuVars.higherEnd - menuVars.higherStart)))
        table.insert(ssfs, ssf(time, menuVars.lowerStart + x * (menuVars.lowerEnd - menuVars.lowerStart)))
        table.insert(ssfs,
            ssf(time + delta - 1 / getUsableDisplacementMultiplier(time),
                menuVars.lowerStart + y * (menuVars.lowerEnd - menuVars.lowerStart)))
        table.insert(ssfs, ssf(time + delta, menuVars.higherStart + y * (menuVars.higherEnd - menuVars.higherStart)))
        time = time + 2 * delta
    end
    actions.PerformBatch({
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfs)
    })
end
function deleteItems(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local linesToRemove = getLinesBetweenOffsets(startOffset, endOffset)
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
    local ssfsToRemove = getSSFsBetweenOffsets(startOffset, endOffset)
    local bmsToRemove = getBookmarksBetweenOffsets(startOffset, endOffset)
    if (not menuVars.deleteTable[1]) then linesToRemove = {} end
    if (not menuVars.deleteTable[2]) then svsToRemove = {} end
    if (not menuVars.deleteTable[3]) then ssfsToRemove = {} end
    if (not menuVars.deleteTable[4]) then bmsToRemove = {} end
    if (truthy(linesToRemove) or truthy(svsToRemove) or truthy(ssfsToRemove) or truthy(bmsToRemove)) then
        actions.PerformBatch({
            utils.CreateEditorAction(
                action_type.RemoveTimingPointBatch, linesToRemove),
            utils.CreateEditorAction(
                action_type.RemoveScrollVelocityBatch, svsToRemove),
            utils.CreateEditorAction(
                action_type.RemoveScrollSpeedFactorBatch, ssfsToRemove),
            utils.CreateEditorAction(
                action_type.RemoveBookmarkBatch, bmsToRemove) })
    end
    if (truthy(#linesToRemove)) then
        print("error!", "Deleted " .. #linesToRemove .. (#linesToRemove == 1 and " timing point." or " timing points."))
    end
    if (truthy(#svsToRemove)) then
        print("error!",
            "Deleted " .. #svsToRemove .. (#svsToRemove == 1 and " scroll velocity." or " scroll velocities."))
    end
    if (truthy(#ssfsToRemove)) then
        print("error!",
            "Deleted " .. #ssfsToRemove .. (#ssfsToRemove == 1 and " scroll speed factor." or " scroll speed factors."))
    end
    if (truthy(#bmsToRemove)) then
        print("error!", "Deleted " .. #bmsToRemove .. (#bmsToRemove == 1 and " bookmark." or " bookmarks."))
    end
end
function addTeleportSVs(menuVars)
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local displaceAmount = menuVars.distance
    for i = 1, #offsets do
        local noteOffset = offsets[i]
        if (menuVars.teleportBeforeHand) then
            noteOffset = noteOffset - 1 / getUsableDisplacementMultiplier(noteOffset)
        end
        local beforeDisplacement = nil
        local atDisplacement = displaceAmount
        local afterDisplacement = 0
        prepareDisplacingSVs(noteOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement)
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function alignTimingLines()
    local timingpoint = state.CurrentTimingPoint
    local starttime = timingpoint.StartTime
    local length = map.GetTimingPointLength(timingpoint)
    local endtime = starttime + length
    local signature = tonumber(timingpoint.Signature)
    local bpm = timingpoint.Bpm
    local mspb = 60000 / bpm
    local msptl = mspb * signature
    local noteTimes = {}
    for _, n in pairs(map.HitObjects) do
        table.insert(noteTimes, n.StartTime)
    end
    local times = {}
    local timingpoints = {}
    for time = starttime, endtime, msptl do
        local originalTime = math.floor(time)
        while (noteTimes[1] < originalTime - 5) do
            table.remove(noteTimes, 1)
        end
        if (math.abs(noteTimes[1] - originalTime) <= 5) then
            table.insert(times, noteTimes[1])
        else
            table.insert(times, originalTime)
        end
    end
    for _, time in pairs(times) do
        table.insert(timingpoints, utils.CreateTimingPoint(time, bpm, signature))
    end
    actions.PerformBatch({
        utils.CreateEditorAction(action_type.AddTimingPointBatch, timingpoints),
        utils.CreateEditorAction(action_type.RemoveTimingPoint, timingpoint)
    })
end
function copyItems(menuVars)
    menuVars.copiedLines = {}
    menuVars.copiedSVs = {}
    menuVars.copiedSSFs = {}
    menuVars.copiedBMs = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    if (not menuVars.copyTable[1]) then goto continue1 end
    for _, line in pairs(getLinesBetweenOffsets(startOffset, endOffset)) do
        local copiedLine = {
            relativeOffset = line.StartTime - startOffset,
            bpm = line.Bpm,
            signature = line.Signature,
            hidden = line.Hidden,
        }
        table.insert(menuVars.copiedLines, copiedLine)
    end
    ::continue1::
    if (not menuVars.copyTable[2]) then goto continue2 end
    for _, sv in pairs(getSVsBetweenOffsets(startOffset, endOffset)) do
        local copiedSV = {
            relativeOffset = sv.StartTime - startOffset,
            multiplier = sv.Multiplier
        }
        table.insert(menuVars.copiedSVs, copiedSV)
    end
    ::continue2::
    if (not menuVars.copyTable[3]) then goto continue3 end
    for _, ssf in pairs(getSSFsBetweenOffsets(startOffset, endOffset)) do
        local copiedSSF = {
            relativeOffset = ssf.StartTime - startOffset,
            multiplier = ssf.Multiplier
        }
        table.insert(menuVars.copiedSSFs, copiedSSF)
    end
    ::continue3::
    if (not menuVars.copyTable[4]) then goto continue4 end
    for _, bm in pairs(getBookmarksBetweenOffsets(startOffset, endOffset)) do
        local copiedBM = {
            relativeOffset = bm.StartTime - startOffset,
            note = bm.Note
        }
        table.insert(menuVars.copiedBMs, copiedBM)
    end
    ::continue4::
    if (#menuVars.copiedBMs > 0) then print("S!", "Copied " .. #menuVars.copiedBMs .. " Bookmarks") end
    if (#menuVars.copiedSSFs > 0) then print("S!", "Copied " .. #menuVars.copiedSSFs .. " SSFs") end
    if (#menuVars.copiedSVs > 0) then print("S!", "Copied " .. #menuVars.copiedSVs .. " SVs") end
    if (#menuVars.copiedLines > 0) then print("S!", "Copied " .. #menuVars.copiedLines .. " Lines") end
end
function clearCopiedItems(menuVars)
    menuVars.copiedLines = {}
    menuVars.copiedSVs = {}
    menuVars.copiedSSFs = {}
    menuVars.copiedBMs = {}
end
function pasteItems(globalVars, menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local lastCopiedLine = menuVars.copiedLines[#menuVars.copiedLines]
    local lastCopiedSV = menuVars.copiedSVs[#menuVars.copiedSVs]
    local lastCopiedSSF = menuVars.copiedSSFs[#menuVars.copiedSSFs]
    local lastCopiedBM = menuVars.copiedBMs[#menuVars.copiedBMs]
    local lastCopiedValue = lastCopiedSV
    if (lastCopiedValue == nil) then lastCopiedValue = lastCopiedSSF end
    if (lastCopiedValue == nil) then lastCopiedValue = lastCopiedLine end
    if (lastCopiedValue == nil) then lastCopiedValue = lastCopiedBM end
    local endRemoveOffset = endOffset + lastCopiedValue.relativeOffset + 1 / 128
    local linesToRemove = menuVars.copyTable[1] and getLinesBetweenOffsets(startOffset, endRemoveOffset) or {}
    local svsToRemove = menuVars.copyTable[2] and getSVsBetweenOffsets(startOffset, endRemoveOffset) or {}
    local ssfsToRemove = menuVars.copyTable[3] and getSSFsBetweenOffsets(startOffset, endRemoveOffset) or {}
    local bmsToRemove = menuVars.copyTable[4] and getBookmarksBetweenOffsets(startOffset, endRemoveOffset) or {}
    if globalVars.dontReplaceSV then
        linesToRemove = {}
        svsToRemove = {}
        ssfsToRemove = {}
        bmsToRemove = {}
    end
    local linesToAdd = {}
    local svsToAdd = {}
    local ssfsToAdd = {}
    local bmsToAdd = {}
    for i = 1, #offsets do
        local pasteOffset = offsets[i]
        for _, line in ipairs(menuVars.copiedLines) do
            local timeToPasteLine = pasteOffset + line.relativeOffset
            table.insert(linesToAdd, utils.CreateTimingPoint(timeToPasteLine, line.bpm, line.signature, line.hidden))
        end
        for _, sv in ipairs(menuVars.copiedSVs) do
            local timeToPasteSV = pasteOffset + sv.relativeOffset
            table.insert(svsToAdd, utils.CreateScrollVelocity(timeToPasteSV, sv.multiplier))
        end
        for _, ssf in ipairs(menuVars.copiedSSFs) do
            local timeToPasteSSF = pasteOffset + ssf.relativeOffset
            table.insert(ssfsToAdd, utils.CreateScrollSpeedFactor(timeToPasteSSF, ssf.multiplier))
        end
        for _, bm in ipairs(menuVars.copiedBMs) do
            local timeToPasteBM = pasteOffset + bm.relativeOffset
            table.insert(bmsToAdd, utils.CreateBookmark(timeToPasteBM, bm.note))
        end
    end
    actions.PerformBatch({
        utils.CreateEditorAction(action_type.RemoveTimingPointBatch, linesToRemove),
        utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
        utils.CreateEditorAction(action_type.RemoveScrollSpeedFactorBatch, ssfsToRemove),
        utils.CreateEditorAction(action_type.RemoveBookmarkBatch, bmsToRemove),
        utils.CreateEditorAction(action_type.AddTimingPointBatch, linesToAdd),
        utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd),
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfsToAdd),
        utils.CreateEditorAction(action_type.AddBookmarkBatch, bmsToAdd),
    })
end
function displaceNoteSVsParent(menuVars)
    if (not menuVars.linearlyChange) then
        displaceNoteSVs(menuVars)
        return
    end
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local svsToRemove = {}
    local svsToAdd = {}
    for _, offset in pairs(offsets) do
        local tbl = displaceNoteSVs(
            {
                distance = (offset - offsets[1]) / (offsets[#offsets] - offsets[1]) *
                    (menuVars.distance2 - menuVars.distance1) + menuVars.distance1
            },
            false, offset)
        table.combine(svsToRemove, tbl.svsToRemove)
        table.combine(svsToAdd, tbl.svsToAdd)
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function displaceNoteSVs(menuVars, place, optionalOffset)
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return { svsToRemove = {}, svsToAdd = {} } end
    if (place == false) then offsets = { optionalOffset } end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local displaceAmount = menuVars.distance
    for i = 1, #offsets do
        local noteOffset = offsets[i]
        local beforeDisplacement = displaceAmount
        local atDisplacement = -displaceAmount
        local afterDisplacement = 0
        prepareDisplacingSVs(noteOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement)
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    if (place ~= false) then
        removeAndAddSVs(svsToRemove, svsToAdd)
        return { svsToRemove = svsToRemove, svsToAdd = svsToAdd }
    end
    return { svsToRemove = svsToRemove, svsToAdd = svsToAdd }
end
function displaceViewSVs(menuVars)
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local offsets = uniqueNoteOffsetsBetweenSelected()
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local displaceAmount = menuVars.distance
    for i = 1, #offsets do
        local noteOffset = offsets[i]
        local beforeDisplacement = nil
        local atDisplacement = displaceAmount
        local afterDisplacement = 0 ---@type number|nil
        if i ~= 1 then beforeDisplacement = -displaceAmount end
        if i == #offsets then
            atDisplacement = 0
            afterDisplacement = nil
        end
        prepareDisplacingSVs(noteOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement)
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function dynamicScaleSVs(menuVars)
    local offsets = menuVars.noteTimes
    local targetAvgSVs = menuVars.svMultipliers
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    for i = 1, (#offsets - 1) do
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local targetAvgSV = targetAvgSVs[i]
        local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
        addStartSVIfMissing(svsBetweenOffsets, startOffset)
        local currentDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset,
            endOffset)
        local targetDistance = targetAvgSV * (endOffset - startOffset)
        local scalingFactor = targetDistance / currentDistance
        for _, sv in pairs(svsBetweenOffsets) do
            local newSVMultiplier = scalingFactor * sv.Multiplier
            addSVToList(svsToAdd, sv.StartTime, newSVMultiplier, true)
        end
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function fixFlippedLNEnds(menuVars)
    local svsToRemove = {}
    local svsToAdd = {}
    local svTimeIsAdded = {}
    local lnEndTimeFixed = {}
    local fixedLNEndsCount = 0
    for _, hitObject in pairs(map.HitObjects) do
        local lnEndTime = hitObject.EndTime
        local isLN = lnEndTime ~= 0
        local endHasNegativeSV = (getSVMultiplierAt(lnEndTime) <= 0)
        local hasntAlreadyBeenFixed = lnEndTimeFixed[lnEndTime] == nil
        if isLN and endHasNegativeSV and hasntAlreadyBeenFixed then
            lnEndTimeFixed[lnEndTime] = true
            local multiplier = getUsableDisplacementMultiplier(lnEndTime)
            local duration = 1 / multiplier
            local timeAt = lnEndTime
            local timeAfter = lnEndTime + duration
            local timeAfterAfter = lnEndTime + duration + duration
            svTimeIsAdded[timeAt] = true
            svTimeIsAdded[timeAfter] = true
            svTimeIsAdded[timeAfterAfter] = true
            local svMultiplierAt = getSVMultiplierAt(timeAt)
            local svMultiplierAfter = getSVMultiplierAt(timeAfter)
            local svMultiplierAfterAfter = getSVMultiplierAt(timeAfterAfter)
            local newMultiplierAt = 0.001
            local newMultiplierAfter = svMultiplierAt + svMultiplierAfter
            local newMultiplierAfterAfter = svMultiplierAfterAfter
            addSVToList(svsToAdd, timeAt, newMultiplierAt, true)
            addSVToList(svsToAdd, timeAfter, newMultiplierAfter, true)
            addSVToList(svsToAdd, timeAfterAfter, newMultiplierAfterAfter, true)
            fixedLNEndsCount = fixedLNEndsCount + 1
        end
    end
    local startOffset = map.HitObjects[1].StartTime
    local endOffset = map.HitObjects[#map.HitObjects].EndTime
    if endOffset == 0 then endOffset = map.HitObjects[#map.HitObjects].StartTime end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
    local type = "S!"
    if (fixedLNEndsCount == 0) then type = "I!" end
    print(type, "Fixed " .. fixedLNEndsCount .. " flipped LN ends")
    menuVars.fixedText = table.concat({ "Fixed ", fixedLNEndsCount, " flipped LN ends" })
end
function flickerSVs(menuVars)
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local numTeleports = 2 * menuVars.numFlickers
    local isDelayedFlicker = FLICKER_TYPES[menuVars.flickerTypeIndex] == "Delayed"
    for i = 1, (#offsets - 1) do
        local flickerStartOffset = offsets[i]
        local flickerEndOffset = offsets[i + 1]
        local teleportOffsets = generateLinearSet(flickerStartOffset, flickerEndOffset,
            numTeleports + 1)
        for j = 1, numTeleports do
            local offsetIndex = j
            if isDelayedFlicker then offsetIndex = offsetIndex + 1 end
            local teleportOffset = math.floor(teleportOffsets[offsetIndex])
            local isTeleportBack = j % 2 == 0
            if isDelayedFlicker then
                local beforeDisplacement = menuVars.distance
                local atDisplacement = 0
                if isTeleportBack then beforeDisplacement = -beforeDisplacement end
                prepareDisplacingSVs(teleportOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
                    atDisplacement, 0)
            else
                local atDisplacement = menuVars.distance
                local afterDisplacement = 0
                if isTeleportBack then atDisplacement = -atDisplacement end
                prepareDisplacingSVs(teleportOffset, svsToAdd, svTimeIsAdded, nil, atDisplacement,
                    afterDisplacement)
            end
        end
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function measureSVs(menuVars)
    local roundingDecimalPlaces = 5
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
    addStartSVIfMissing(svsBetweenOffsets, startOffset)
    menuVars.roundedNSVDistance = endOffset - startOffset
    menuVars.nsvDistance = tostring(menuVars.roundedNSVDistance)
    local totalDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset, endOffset)
    menuVars.roundedSVDistance = math.round(totalDistance, roundingDecimalPlaces)
    menuVars.svDistance = tostring(totalDistance)
    local avgSV = totalDistance / menuVars.roundedNSVDistance
    menuVars.roundedAvgSV = math.round(avgSV, roundingDecimalPlaces)
    menuVars.avgSV = tostring(avgSV)
    local durationStart = 1 / getUsableDisplacementMultiplier(startOffset)
    local timeAt = startOffset
    local timeAfter = startOffset + durationStart
    local multiplierAt = getSVMultiplierAt(timeAt)
    local multiplierAfter = getSVMultiplierAt(timeAfter)
    local startDisplacement = -(multiplierAt - multiplierAfter) * durationStart
    menuVars.roundedStartDisplacement = math.round(startDisplacement, roundingDecimalPlaces)
    menuVars.startDisplacement = tostring(startDisplacement)
    local durationEnd = 1 / getUsableDisplacementMultiplier(startOffset)
    local timeBefore = endOffset - durationEnd
    local timeBeforeBefore = timeBefore - durationEnd
    local multiplierBefore = getSVMultiplierAt(timeBefore)
    local multiplierBeforeBefore = getSVMultiplierAt(timeBeforeBefore)
    local endDisplacement = (multiplierBefore - multiplierBeforeBefore) * durationEnd
    menuVars.roundedEndDisplacement = math.round(endDisplacement, roundingDecimalPlaces)
    menuVars.endDisplacement = tostring(endDisplacement)
    local trueDistance = totalDistance - endDisplacement + startDisplacement
    local trueAvgSV = trueDistance / menuVars.roundedNSVDistance
    menuVars.roundedAvgSVDisplaceless = math.round(trueAvgSV, roundingDecimalPlaces)
    menuVars.avgSVDisplaceless = tostring(trueAvgSV)
end
function mergeSVs()
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
    local svTimeToMultiplier = {}
    for _, sv in pairs(svsToRemove) do
        local currentMultiplier = svTimeToMultiplier[sv.StartTime]
        if currentMultiplier then
            svTimeToMultiplier[sv.StartTime] = currentMultiplier + sv.Multiplier
        else
            svTimeToMultiplier[sv.StartTime] = sv.Multiplier
        end
    end
    for svTime, svMultiplier in pairs(svTimeToMultiplier) do
        addSVToList(svsToAdd, svTime, svMultiplier, true)
    end
    local noSVsMerged = #svsToAdd == #svsToRemove
    if noSVsMerged then return end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function reverseScrollSVs(menuVars)
    local offsets = uniqueNoteOffsetsBetweenSelected()
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsToAdd = {}
    local almostSVsToAdd = {}
    local extraOffset = 2 / getUsableDisplacementMultiplier(endOffset)
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset + extraOffset)
    local svTimeIsAdded = {}
    local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
    addStartSVIfMissing(svsBetweenOffsets, startOffset)
    local sectionDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset, endOffset)
    local msxSeparatingDistance = -10000
    local teleportDistance = -sectionDistance + msxSeparatingDistance
    local noteDisplacement = -menuVars.distance
    for i = 1, #offsets do
        local noteOffset = offsets[i]
        local beforeDisplacement = nil
        local atDisplacement = 0
        local afterDisplacement = 0
        if i ~= 1 then
            beforeDisplacement = noteDisplacement
            atDisplacement = -noteDisplacement
        end
        if i == 1 or i == #offsets then
            atDisplacement = atDisplacement + teleportDistance
        end
        prepareDisplacingSVs(noteOffset, almostSVsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement)
    end
    for _, sv in ipairs(svsBetweenOffsets) do
        if (not svTimeIsAdded[sv.StartTime]) then
            table.insert(almostSVsToAdd, sv)
        end
    end
    for _, sv in ipairs(almostSVsToAdd) do
        local newSVMultiplier = -sv.Multiplier
        if sv.StartTime > endOffset then newSVMultiplier = sv.Multiplier end
        addSVToList(svsToAdd, sv.StartTime, newSVMultiplier, true)
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function scaleDisplaceSVs(menuVars)
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local isStartDisplace = DISPLACE_SCALE_SPOTS[menuVars.scaleSpotIndex] == "Start"
    for i = 1, (#offsets - 1) do
        local note1Offset = offsets[i]
        local note2Offset = offsets[i + 1]
        local svsBetweenOffsets = getSVsBetweenOffsets(note1Offset, note2Offset)
        addStartSVIfMissing(svsBetweenOffsets, note1Offset)
        local scaleType = SCALE_TYPES[menuVars.scaleTypeIndex]
        local currentDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset,
            endOffset)
        local scalingDistance
        if scaleType == "Average SV" then
            local targetDistance = menuVars.avgSV * (note2Offset - note1Offset)
            scalingDistance = targetDistance - currentDistance
        elseif scaleType == "Absolute Distance" then
            scalingDistance = menuVars.distance - currentDistance
        elseif scaleType == "Relative Ratio" then
            scalingDistance = (menuVars.ratio - 1) * currentDistance
        end
        if isStartDisplace then
            local atDisplacement = scalingDistance
            local afterDisplacement = 0
            prepareDisplacingSVs(note1Offset, svsToAdd, svTimeIsAdded, nil, atDisplacement,
                afterDisplacement)
        else
            local beforeDisplacement = scalingDistance
            local atDisplacement = 0
            prepareDisplacingSVs(note2Offset, svsToAdd, svTimeIsAdded, beforeDisplacement,
                atDisplacement, nil)
        end
    end
    if isStartDisplace then addFinalSV(svsToAdd, endOffset, getSVMultiplierAt(endOffset)) end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function scaleMultiplySVs(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    for i = 1, (#offsets - 1) do
        local startOffset = offsets[i]
        local endOffset = offsets[i + 1]
        local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
        addStartSVIfMissing(svsBetweenOffsets, startOffset)
        local scalingFactor = menuVars.ratio
        local currentDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset,
            endOffset)
        local scaleType = SCALE_TYPES[menuVars.scaleTypeIndex]
        if scaleType == "Average SV" then
            local currentAvgSV = currentDistance / (endOffset - startOffset)
            scalingFactor = menuVars.avgSV / currentAvgSV
        elseif scaleType == "Absolute Distance" then
            scalingFactor = menuVars.distance / currentDistance
        end
        for _, sv in pairs(svsBetweenOffsets) do
            local newSVMultiplier = scalingFactor * sv.Multiplier
            addSVToList(svsToAdd, sv.StartTime, newSVMultiplier, true)
        end
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function swapNoteSVs()
    local svsToAdd = {}
    local svsToRemove = {}
    local svTimeIsAdded = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
    addStartSVIfMissing(svsBetweenOffsets, startOffset)
    local oldSVDisplacements = calculateDisplacementsFromSVs(svsBetweenOffsets, offsets)
    for i = 1, #offsets do
        local noteOffset = offsets[i]
        local currentDisplacement = oldSVDisplacements[i]
        local nextDisplacement = oldSVDisplacements[i + 1] or oldSVDisplacements[1]
        local newDisplacement = nextDisplacement - currentDisplacement
        local beforeDisplacement = newDisplacement
        local atDisplacement = -newDisplacement
        local afterDisplacement = 0
        prepareDisplacingSVs(noteOffset, svsToAdd, svTimeIsAdded, beforeDisplacement,
            atDisplacement, afterDisplacement)
    end
    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
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
function verticalShiftSVs(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
    local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
    addStartSVIfMissing(svsBetweenOffsets, startOffset)
    for _, sv in pairs(svsBetweenOffsets) do
        local newSVMultiplier = sv.Multiplier + menuVars.verticalShift
        addSVToList(svsToAdd, sv.StartTime, newSVMultiplier, true)
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function exportPlaceSVButton(globalVars, menuVars, settingVars)
    local buttonText = "Export current settings for current menu"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
    local exportList = {}
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    local stillType = placeType == "Still"
    local regularType = placeType == "Standard" or stillType
    local specialType = placeType == "Special"
    local currentSVType
    if regularType then
        currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    elseif specialType then
        currentSVType = SPECIAL_SVS[menuVars.svTypeIndex]
    end
    exportList[1] = placeType
    exportList[2] = currentSVType
    if regularType then
        table.insert(exportList, tostring(menuVars.interlace))
        table.insert(exportList, menuVars.interlaceRatio)
    end
    if stillType then
        table.insert(exportList, menuVars.noteSpacing)
        table.insert(exportList, menuVars.stillTypeIndex)
        table.insert(exportList, menuVars.stillDistance)
    end
    if currentSVType == "Linear" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Exponential" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.intensity)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Bezier" then
        table.insert(exportList, settingVars.x1)
        table.insert(exportList, settingVars.y1)
        table.insert(exportList, settingVars.x2)
        table.insert(exportList, settingVars.y2)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Hermite" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Sinusoidal" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.curveSharpness)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.periods)
        table.insert(exportList, settingVars.periodsShift)
        table.insert(exportList, settingVars.svsPerQuarterPeriod)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Circular" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.arcPercent)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.dontNormalize))
    elseif currentSVType == "Random" then
        for i = 1, #settingVars.svMultipliers do
            table.insert(exportList, settingVars.svMultipliers[i])
        end
        table.insert(exportList, settingVars.randomTypeIndex)
        table.insert(exportList, settingVars.randomScale)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.dontNormalize))
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
    elseif currentSVType == "Custom" then
        for i = 1, #settingVars.svMultipliers do
            table.insert(exportList, settingVars.svMultipliers[i])
        end
        table.insert(exportList, settingVars.selectedMultiplierIndex)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Chinchilla" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.chinchillaTypeIndex)
        table.insert(exportList, settingVars.chinchillaIntensity)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Stutter" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.stutterDuration)
        table.insert(exportList, settingVars.stuttersPerSection)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.linearlyChange))
        table.insert(exportList, tostring(settingVars.controlLastSV))
    elseif currentSVType == "Teleport Stutter" then
        table.insert(exportList, settingVars.svPercent)
        table.insert(exportList, settingVars.svPercent2)
        table.insert(exportList, settingVars.distance)
        table.insert(exportList, settingVars.mainSV)
        table.insert(exportList, settingVars.mainSV2)
        table.insert(exportList, tostring(settingVars.useDistance))
        table.insert(exportList, tostring(settingVars.linearlyChange))
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Splitscroll (Adv v2)" then
        table.insert(exportList, settingVars.numScrolls)
        table.insert(exportList, settingVars.msPerFrame)
        table.insert(exportList, settingVars.scrollIndex)
        table.insert(exportList, settingVars.distanceBack)
        table.insert(exportList, settingVars.distanceBack2)
        table.insert(exportList, settingVars.distanceBack3)
        local totalLayersSupported = 4
        for i = 1, totalLayersSupported do
            local currentLayer = settingVars.splitscrollLayers[i]
            if currentLayer ~= nil then
                local currentLayerSVs = currentLayer.svs
                local svsStringTable = {}
                for j = 1, #currentLayerSVs do
                    local currentSV = currentLayerSVs[j]
                    local svStringTable = {}
                    table.insert(svStringTable, currentSV.StartTime)
                    table.insert(svStringTable, currentSV.Multiplier)
                    local svString = table.concat(svStringTable, "+")
                    table.insert(svsStringTable, svString)
                end
                local svsString = table.concat(svsStringTable, " ")
                local currentLayerNotes = currentLayer.notes
                local notesStringTable = {}
                for j = 1, #currentLayerNotes do
                    local currentNote = currentLayerNotes[j]
                    local noteStringTable = {}
                    table.insert(noteStringTable, currentNote.StartTime)
                    table.insert(noteStringTable, currentNote.Lane)
                    local noteString = table.concat(noteStringTable, "+")
                    table.insert(notesStringTable, noteString)
                end
                local notesString = table.concat(notesStringTable, " ")
                local layersDataTable = { i, svsString, notesString }
                local layersString = table.concat(layersDataTable, ":")
                table.insert(exportList, layersString)
            end
        end
    end
    globalVars.exportData = table.concat(exportList, "|")
end
function exportCustomSVButton(globalVars, menuVars)
    local buttonText = "Export current SVs as custom SV data"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
    local multipliersCopy = table.duplicate(menuVars.svMultipliers)
    table.remove(multipliersCopy)
    globalVars.exportCustomSVData = table.concat(multipliersCopy, " ")
end
function importPlaceSVButton(globalVars)
    local buttonText = "Import settings from pasted data"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
    local settingsTable = {}
    for str in string.gmatch(globalVars.importData, "([^|]+)") do
        local num = tonumber(str)
        if num ~= nil then
            table.insert(settingsTable, num)
        elseif str == "false" then
            table.insert(settingsTable, false)
        elseif str == "true" then
            table.insert(settingsTable, true)
        else
            table.insert(settingsTable, str)
        end
    end
    if #settingsTable < 2 then return end
    local placeType         = table.remove(settingsTable, 1)
    local currentSVType     = table.remove(settingsTable, 1)
    local standardPlaceType = placeType == "Standard"
    local specialPlaceType  = placeType == "Special"
    local stillPlaceType    = placeType == "Still"
    local menuVars
    if standardPlaceType then menuVars = getStandardPlaceMenuVars() end
    if specialPlaceType then menuVars = getSpecialPlaceMenuVars() end
    if stillPlaceType then menuVars = getStillPlaceMenuVars() end
    local linearSVType      = currentSVType == "Linear"
    local exponentialSVType = currentSVType == "Exponential"
    local bezierSVType      = currentSVType == "Bezier"
    local hermiteSVType     = currentSVType == "Hermite"
    local sinusoidalSVType  = currentSVType == "Sinusoidal"
    local circularSVType    = currentSVType == "Circular"
    local randomSVType      = currentSVType == "Random"
    local customSVType      = currentSVType == "Custom"
    local chinchillaSVType  = currentSVType == "Chinchilla"
    local stutterSVType     = currentSVType == "Stutter"
    local tpStutterSVType   = currentSVType == "Teleport Stutter"
    local advSplitV2SVType  = currentSVType == "Splitscroll (Adv v2)"
    local settingVars
    if standardPlaceType then
        settingVars = getSettingVars(currentSVType, "Standard")
    elseif stillPlaceType then
        settingVars = getSettingVars(currentSVType, "Still")
    else
        settingVars = getSettingVars(currentSVType, "Special")
    end
    if standardPlaceType then globalVars.placeTypeIndex = 1 end
    if specialPlaceType then globalVars.placeTypeIndex = 2 end
    if stillPlaceType then globalVars.placeTypeIndex = 3 end
    if linearSVType then menuVars.svTypeIndex = 1 end
    if exponentialSVType then menuVars.svTypeIndex = 2 end
    if bezierSVType then menuVars.svTypeIndex = 3 end
    if hermiteSVType then menuVars.svTypeIndex = 4 end
    if sinusoidalSVType then menuVars.svTypeIndex = 5 end
    if circularSVType then menuVars.svTypeIndex = 6 end
    if randomSVType then menuVars.svTypeIndex = 7 end
    if customSVType then menuVars.svTypeIndex = 8 end
    if chinchillaSVType then menuVars.svTypeIndex = 9 end
    if stutterSVType then menuVars.svTypeIndex = 1 end
    if tpStutterSVType then menuVars.svTypeIndex = 2 end
    if advSplitV2SVType then menuVars.svTypeIndex = 5 end
    if standardPlaceType or stillPlaceType then
        menuVars.interlace = table.remove(settingsTable, 1)
        menuVars.interlaceRatio = table.remove(settingsTable, 1)
    end
    if stillPlaceType then
        menuVars.noteSpacing = table.remove(settingsTable, 1)
        menuVars.stillTypeIndex = table.remove(settingsTable, 1)
        menuVars.stillDistance = table.remove(settingsTable, 1)
    end
    if linearSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif exponentialSVType then
        settingVars.intensity = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif bezierSVType then
        settingVars.x1 = table.remove(settingsTable, 1)
        settingVars.y1 = table.remove(settingsTable, 1)
        settingVars.x2 = table.remove(settingsTable, 1)
        settingVars.y2 = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif hermiteSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif sinusoidalSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.curveSharpness = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.periods = table.remove(settingsTable, 1)
        settingVars.periodsShift = table.remove(settingsTable, 1)
        settingVars.svsPerQuarterPeriod = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif circularSVType then
        settingVars.behaviorIndex = table.remove(settingsTable, 1)
        settingVars.arcPercent = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
        settingVars.dontNormalize = table.remove(settingsTable, 1)
    elseif randomSVType then
        settingVars.verticalShift = table.remove(settingsTable)
        settingVars.avgSV = table.remove(settingsTable)
        settingVars.dontNormalize = table.remove(settingsTable)
        settingVars.customSV = table.remove(settingsTable)
        settingVars.finalSVIndex = table.remove(settingsTable)
        settingVars.svPoints = table.remove(settingsTable)
        settingVars.randomScale = table.remove(settingsTable)
        settingVars.randomTypeIndex = table.remove(settingsTable)
        settingVars.svMultipliers = settingsTable
    elseif customSVType then
        settingVars.customSV = table.remove(settingsTable)
        settingVars.finalSVIndex = table.remove(settingsTable)
        settingVars.svPoints = table.remove(settingsTable)
        settingVars.selectedMultiplierIndex = table.remove(settingsTable)
        settingVars.svMultipliers = settingsTable
    elseif chinchillaSVType then
        settingVars.behaviorIndex = table.remove(settingsTable, 1)
        settingVars.chinchillaTypeIndex = table.remove(settingsTable, 1)
        settingVars.chinchillaIntensity = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    end
    if stutterSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.stutterDuration = table.remove(settingsTable, 1)
        settingVars.stuttersPerSection = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
        settingVars.linearlyChange = table.remove(settingsTable, 1)
        settingVars.controlLastSV = table.remove(settingsTable, 1)
    elseif tpStutterSVType then
        settingVars.svPercent = table.remove(settingsTable, 1)
        settingVars.svPercent2 = table.remove(settingsTable, 1)
        settingVars.distance = table.remove(settingsTable, 1)
        settingVars.mainSV = table.remove(settingsTable, 1)
        settingVars.mainSV2 = table.remove(settingsTable, 1)
        settingVars.useDistance = table.remove(settingsTable, 1)
        settingVars.linearlyChange = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif advSplitV2SVType then
        settingVars.numScrolls = table.remove(settingsTable, 1)
        settingVars.msPerFrame = table.remove(settingsTable, 1)
        settingVars.scrollIndex = table.remove(settingsTable, 1)
        settingVars.distanceBack = table.remove(settingsTable, 1)
        settingVars.distanceBack2 = table.remove(settingsTable, 1)
        settingVars.distanceBack3 = table.remove(settingsTable, 1)
        settingVars.splitscrollLayers = {}
        while truthy(settingsTable) do
            local splitscrollLayerString = table.remove(settingsTable)
            local layerDataStringTable = {}
            for str in string.gmatch(splitscrollLayerString, "([^:]+)") do
                table.insert(layerDataStringTable, str)
            end
            local layerNumber = tonumber(layerDataStringTable[1])
            local layerSVs = {}
            local svDataString = layerDataStringTable[2]
            for str in string.gmatch(svDataString, "([^%s]+)") do
                local svDataTable = {}
                for svData in string.gmatch(str, "([^%+]+)") do
                    table.insert(svDataTable, tonumber(svData))
                end
                local svStartTime = svDataTable[1]
                local svMultiplier = svDataTable[2]
                addSVToList(layerSVs, svStartTime, svMultiplier, true)
            end
            local layerNotes = {}
            local noteDataString = layerDataStringTable[3]
            for str in string.gmatch(noteDataString, "([^%s]+)") do
                local noteDataTable = {}
                for noteData in string.gmatch(str, "([^%+]+)") do
                    table.insert(noteDataTable, tonumber(noteData))
                end
                local noteStartTime = noteDataTable[1]
                local noteLane = noteDataTable[2]
                table.insert(layerNotes, utils.CreateHitObject(noteStartTime, noteLane))
            end
            if (not layerNumber) then goto continue end
            settingVars.splitscrollLayers[layerNumber] = {
                svs = layerSVs,
                notes = layerNotes
            }
            ::continue::
        end
    end
    if standardPlaceType then
        updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false)
        local labelText = table.concat({ currentSVType, "SettingsStandard" })
        saveVariables(labelText, settingVars)
    elseif stillPlaceType then
        updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false)
        local labelText = table.concat({ currentSVType, "SettingsStill" })
        saveVariables(labelText, settingVars)
    elseif stutterSVType then
        updateStutterMenuSVs(settingVars)
        local labelText = table.concat({ currentSVType, "SettingsSpecial" })
        saveVariables(labelText, settingVars)
    else
        local labelText = table.concat({ currentSVType, "SettingsSpecial" })
        saveVariables(labelText, settingVars)
    end
    if standardPlaceType then saveVariables("placeStandardMenu", menuVars) end
    if specialPlaceType then saveVariables("placeSpecialMenu", menuVars) end
    if stillPlaceType then saveVariables("placeStillMenu", menuVars) end
    globalVars.importData = ""
    globalVars.showExportImportMenu = false
end
function selectAlternating(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local notes = getNotesBetweenOffsets(startOffset, endOffset)
    local times = {}
    for _, v in pairs(notes) do
        table.insert(times, v.StartTime)
    end
    times = table.dedupe(times)
    local allowedTimes = {}
    for i, time in pairs(times) do
        if ((i - 2 + menuVars.offset) % menuVars.every == 0) then
            table.insert(allowedTimes, time)
        end
    end
    local notesToSelect = {}
    local currentTime = allowedTimes[1]
    local index = 2
    for _, note in pairs(notes) do
        if (note.StartTime > currentTime and index <= #allowedTimes) then
            currentTime = allowedTimes[index]
            index = index + 1
        end
        if (note.StartTime == currentTime) then
            table.insert(notesToSelect, note)
        end
    end
    actions.SetHitObjectSelection(notesToSelect)
    print(truthy(notesToSelect) and "S!" or "W!", #notesToSelect .. " notes selected")
end
function selectByChordSizes(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local notes = getNotesBetweenOffsets(startOffset, endOffset)
    local noteTimeTable = {}
    for _, note in pairs(notes) do
        table.insert(noteTimeTable, note.StartTime)
    end
    noteTimeTable = table.dedupe(noteTimeTable)
    local sizeDict = {
        {},
        {},
        {},
        {}
    }
    for _, time in pairs(noteTimeTable) do
        local size = 0
        local totalNotes = {}
        for _, note in pairs(notes) do
            if (math.abs(note.StartTime - time) < 3) then
                size = size + 1
                table.insert(totalNotes, note)
            end
        end
        sizeDict[size] = table.combine(sizeDict[size], totalNotes)
    end
    local notesToSelect = {}
    if (menuVars.single) then notesToSelect = table.combine(notesToSelect, sizeDict[1]) end
    if (menuVars.jump) then notesToSelect = table.combine(notesToSelect, sizeDict[2]) end
    if (menuVars.hand) then notesToSelect = table.combine(notesToSelect, sizeDict[3]) end
    if (menuVars.quad) then notesToSelect = table.combine(notesToSelect, sizeDict[4]) end
    actions.SetHitObjectSelection(notesToSelect)
    print(truthy(notesToSelect) and "S!" or "W!", #notesToSelect .. " notes selected")
end
function selectByNoteType(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local totalNotes = getNotesBetweenOffsets(startOffset, endOffset)
    local notesToSelect = {}
    for _, note in pairs(totalNotes) do
        if (note.EndTime == 0 and menuVars.rice) then table.insert(notesToSelect, note) end
        if (note.EndTime ~= 0 and menuVars.ln) then table.insert(notesToSelect, note) end
    end
    actions.SetHitObjectSelection(notesToSelect)
    print(truthy(notesToSelect) and "S!" or "W!", #notesToSelect .. " notes selected")
end
function selectBySnap(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local notes = getNotesBetweenOffsets(startOffset, endOffset)
    local timingPoint = getTimingPointAt(startOffset)
    local bpm = timingPoint.Bpm
    local times = {}
    local disallowedTimes = {}
    local pointer = timingPoint.StartTime
    local counter = 0
    local factors = {}
    for i = 2, (menuVars.snap - 1) do
        if (menuVars.snap % i == 0) then table.insert(factors, i) end
    end
    for _, factor in pairs(factors) do
        while (pointer <= endOffset + 10) do
            if ((counter ~= 0 or factor == 1) and pointer >= startOffset) then table.insert(disallowedTimes, pointer) end
            counter = (counter + 1) % factor
            pointer = pointer + (60000 / bpm) / (factor)
        end
        pointer = timingPoint.StartTime
        counter = 0
    end
    while (pointer <= endOffset + 10) do
        if ((counter ~= 0 or menuVars.snap == 1) and pointer >= startOffset) then table.insert(times, pointer) end
        counter = (counter + 1) % menuVars.snap
        pointer = pointer + (60000 / bpm) / (menuVars.snap)
    end
    for _, bannedTime in pairs(disallowedTimes) do
        for idx, time in pairs(times) do
            if (math.abs(time - bannedTime) < 10) then table.remove(times, idx) end
        end
    end
    local notesToSelect = {}
    local currentTime = times[1]
    local index = 2
    for _, note in pairs(notes) do
        if (note.StartTime > currentTime + 10 and index <= #times) then
            currentTime = times[index]
            index = index + 1
        end
        if (math.abs(note.StartTime - currentTime) < 10) then
            table.insert(notesToSelect, note)
        end
    end
    actions.SetHitObjectSelection(notesToSelect)
    print(truthy(notesToSelect) and "S!" or "W!", #notesToSelect .. " notes selected")
end
function awake()
    local tempGlobalVars = read()
    if (not tempGlobalVars) then tempGlobalVars = {} end
    state.SetValue("global_useCustomPulseColor", truthy(tempGlobalVars.useCustomPulseColor))
    state.SetValue("global_pulseColor", table.vectorize4(tempGlobalVars.pulseColor))
    state.SetValue("global_pulseCoefficient", tonumber(tempGlobalVars.pulseCoefficient))
    state.SetValue("global_stepSize", tonumber(tempGlobalVars.stepSize))
    state.SetValue("global_keyboardMode", truthy(tempGlobalVars.keyboardMode))
    state.SetValue("global_dontReplaceSV", truthy(tempGlobalVars.dontReplaceSV))
    state.SetValue("global_upscroll", truthy(tempGlobalVars.upscroll))
    state.SetValue("global_colorThemeIndex", tonumber(tempGlobalVars.colorThemeIndex))
    state.SetValue("global_styleThemeIndex", tonumber(tempGlobalVars.styleThemeIndex))
    state.SetValue("global_rgbPeriod", tonumber(tempGlobalVars.rgbPeriod))
    state.SetValue("global_cursorTrailIndex", tonumber(tempGlobalVars.cursorTrailIndex))
    state.SetValue("global_cursorTrailShapeIndex", tonumber(tempGlobalVars.cursorTrailShapeIndex))
    state.SetValue("global_effectFPS", tonumber(tempGlobalVars.effectFPS))
    state.SetValue("global_cursorTrailPoints", tonumber(tempGlobalVars.cursorTrailPoints))
    state.SetValue("global_cursorTrailSize", tonumber(tempGlobalVars.cursorTrailSize))
    state.SetValue("global_snakeSpringConstant", tonumber(tempGlobalVars.snakeSpringConstant))
    state.SetValue("global_cursorTrailGhost", truthy(tempGlobalVars.cursorTrailGhost))
    state.SetValue("global_drawCapybara", truthy(tempGlobalVars.drawCapybara))
    state.SetValue("global_drawCapybara2", truthy(tempGlobalVars.drawCapybara2))
    state.SetValue("global_drawCapybara312", truthy(tempGlobalVars.drawCapybara312))
    state.SetValue("global_ignoreNotes", truthy(tempGlobalVars.BETA_IGNORE_NOTES_OUTSIDE_TG))
    state.SetValue("global_advancedMode", truthy(tempGlobalVars.advancedMode))
    state.SetValue("global_hideAutomatic", truthy(tempGlobalVars.hideAutomatic))
    state.SetValue("global_hotkeyList", tempGlobalVars.hotkeyList)
    state.SelectedScrollGroupId = "$Default" or map.GetTimingGroupIds()[1]
end
DEFAULT_WIDGET_HEIGHT = 26
DEFAULT_WIDGET_WIDTH = 160
PADDING_WIDTH = 8
RADIO_BUTTON_SPACING = 7.5
SAMELINE_SPACING = 5
ACTION_BUTTON_SIZE = vector.New(255, 42)
PLOT_GRAPH_SIZE = vector.New(255, 100)
HALF_ACTION_BUTTON_SIZE = vector.New(125, 42)
SECONDARY_BUTTON_SIZE = vector.New(48, 24)
TERTIARY_BUTTON_SIZE = vector.New(21.5, 24)
EXPORT_BUTTON_SIZE = vector.New(40, 24)
BEEG_BUTTON_SIZE = vector.New(255, 24)
MIN_RGB_CYCLE_TIME = 0.1
MAX_RGB_CYCLE_TIME = 300
MAX_CURSOR_TRAIL_POINTS = 100
MAX_SV_POINTS = 1000
MAX_ANIMATION_FRAMES = 999
MAX_IMPORT_CHARACTER_LIMIT = 999999
CHINCHILLA_TYPES = {
    "Exponential",
    "Polynomial",
    "Circular",
    "Sine Power",
    "Arc Sine Power",
    "Inverse Power",
    "Peter Stock"
}
COLOR_THEMES = {
    "Classic",
    "Strawberry",
    "Amethyst",
    "Tree",
    "Barbie",
    "Incognito",
    "Incognito + RGB",
    "Tobi's Glass",
    "Tobi's RGB Glass",
    "Glass",
    "Glass + RGB",
    "RGB Gamer Mode",
    "edom remag BGR",
    "BGR + otingocnI",
    "otingocnI"
}
COMBO_SV_TYPE = {
    "Add",
    "Cross Multiply",
    "Remove",
    "Min",
    "Max",
    "SV Type 1 Only",
    "SV Type 2 Only"
}
CURSOR_TRAILS = {
    "None",
    "Snake",
    "Dust",
    "Sparkle"
}
DISPLACE_SCALE_SPOTS = {
    "Start",
    "End"
}
EMOTICONS = {
    "( - _ - )",
    "( e . e )",
    "( * o * )",
    "( h . m )",
    "( ~ _ ~ )",
    "( - . - )",
    "( C | D )",
    "( w . w )",
    "( ^ w ^ )",
    "( > . < )",
    "( + x + )",
    "( o _ 0 )",
    "[ m w m ]",
    "( v . ^ )",
    "( ^ o v )",
    "( ^ o v )",
    "( ; A ; )",
    "[ . _ . ]",
    "[ ' = ' ]",
}
FINAL_SV_TYPES = {
    "Normal",
    "Custom",
    "Override"
}
FLICKER_TYPES = {
    "Normal",
    "Delayed"
}
NOTE_SKIN_TYPES = {
    "Bar",
    "Circle"
}
RANDOM_TYPES = {
    "Normal",
    "Uniform"
}
SCALE_TYPES = {
    "Average SV",
    "Absolute Distance",
    "Relative Ratio"
}
STANDARD_SVS_NO_COMBO = {
    "Linear",
    "Exponential",
    "Bezier",
    "Hermite",
    "Sinusoidal",
    "Circular",
    "Random",
    "Custom",
    "Chinchilla"
}
STILL_TYPES = {
    "No",
    "Start",
    "End",
    "Auto",
    "Otua"
}
STUTTER_CONTROLS = {
    "First SV",
    "Second SV"
}
STYLE_THEMES = {
    "Rounded",
    "Boxed",
    "Rounded + Border",
    "Boxed + Border"
}
SV_BEHAVIORS = {
    "Slow down",
    "Speed up"
}
TRAIL_SHAPES = {
    "Circles",
    "Triangles"
}
BETA_IGNORE_NOTES_OUTSIDE_TG = false
STILL_BEHAVIOR_TYPES = {
    "Entire Region",
    "Per Note Group",
}
DISTANCE_TYPES = {
    "Average SV + Shift",
    "Distance + Shift",
    "Start / End"
}
DEFAULT_HOTKEY_LIST = { "T", "Shift+T", "S", "N", "R", "B", "M" }
GLOBAL_HOTKEY_LIST = DEFAULT_HOTKEY_LIST
HOTKEY_LABELS = { "Execute Primary Action", "Execute Secondary Action", "Swap Primary Inputs",
    "Negate Primary Inputs", "Reset Secondary Input", "Go To Previous Scroll Group", "Go To Next Scroll Group" }
imgui_disable_vector_packing = true
function draw()
    state.SetValue("computableInputFloatIndex", 1)
    local prevVal = state.GetValue("prevVal", 0)
    local colStatus = state.GetValue("colStatus", 0)
    local globalVars = {
        stepSize = state.GetValue("global_stepSize", 5),
        keyboardMode = state.GetValue("global_keyboardMode", false),
        dontReplaceSV = state.GetValue("global_dontReplaceSV", false),
        upscroll = state.GetValue("global_upscroll", false),
        colorThemeIndex = state.GetValue("global_colorThemeIndex", 9),
        styleThemeIndex = state.GetValue("global_styleThemeIndex", 1),
        effectFPS = state.GetValue("global_effectFPS", 90),
        cursorTrailIndex = state.GetValue("global_cursorTrailIndex", 1),
        cursorTrailShapeIndex = state.GetValue("global_cursorTrailShapeIndex", 1),
        cursorTrailPoints = state.GetValue("global_cursorTrailPoints", 10),
        cursorTrailSize = state.GetValue("global_cursorTrailSize", 5),
        snakeSpringConstant = state.GetValue("global_snakeSpringConstant", 1),
        cursorTrailGhost = state.GetValue("global_cursorTrailGhost", false),
        rgbPeriod = state.GetValue("global_rgbPeriod", 2),
        drawCapybara = state.GetValue("global_drawCapybara", false),
        drawCapybara2 = state.GetValue("global_drawCapybara2", false),
        drawCapybara312 = state.GetValue("global_drawCapybara312", false),
        selectTypeIndex = 1,
        placeTypeIndex = 1,
        editToolIndex = 1,
        showExportImportMenu = false,
        importData = "",
        exportCustomSVData = "",
        exportData = "",
        debugText = "debug",
        scrollGroupIndex = 1,
        showColorPicker = false,
        BETA_IGNORE_NOTES_OUTSIDE_TG = state.GetValue("global_ignoreNotes", false),
        advancedMode = state.GetValue("global_advancedMode", false),
        hideAutomatic = state.GetValue("global_hideAutomatic", false),
        pulseCoefficient = state.GetValue("global_pulseCoefficient", 0),
        pulseColor = state.GetValue("global_pulseColor", vector4(1)),
        useCustomPulseColor = state.GetValue("global_useCustomPulseColor", false),
        hotkeyList = state.GetValue("global_hotkeyList", DEFAULT_HOTKEY_LIST)
    }
    getVariables("globalVars", globalVars)
    drawCapybara(globalVars)
    drawCapybara2(globalVars)
    drawCapybara312(globalVars)
    drawCursorTrail(globalVars)
    setPluginAppearance(globalVars)
    startNextWindowNotCollapsed("plumoguSVAutoOpen")
    focusWindowIfHotkeysPressed()
    centerWindowIfHotkeysPressed()
    imgui.Begin("plumoguSV-dev", imgui_window_flags.AlwaysAutoResize)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    if globalVars.keyboardMode then
        imgui.BeginTabBar("Quick tabs")
        createQuickTabs(globalVars)
        imgui.EndTabBar()
    else
        imgui.BeginTabBar("SV tabs")
        for i = 1, #TAB_MENUS do
            createMenuTab(globalVars, TAB_MENUS[i])
        end
        imgui.EndTabBar()
    end
    state.IsWindowHovered = imgui.IsWindowHovered()
    imgui.End()
    saveVariables("globalVars", globalVars)
    local timeOffset = 50
    local timeSinceLastPulse = ((state.SongTime + timeOffset) - getTimingPointAt(state.SongTime).StartTime) %
        ((60000 / getTimingPointAt(state.SongTime).Bpm))
    if ((timeSinceLastPulse < prevVal)) then
        colStatus = 1
    else
        colStatus = (colStatus - state.DeltaTime / (60000 / getTimingPointAt(state.SongTime).Bpm))
    end
    local futureTime = state.SongTime + state.DeltaTime * 2 + timeOffset
    if ((futureTime - getTimingPointAt(futureTime).StartTime) < 0) then
        colStatus = 0
    end
    state.SetValue("colStatus", math.max(colStatus, 0))
    state.SetValue("prevVal", timeSinceLastPulse)
    colStatus = colStatus * globalVars
        .pulseCoefficient
    local borderColor = state.GetValue("global_baseBorderColor", vector4(1))
    local negatedBorderColor = vector4(1) - borderColor
    local pulseColor = globalVars.useCustomPulseColor and globalVars.pulseColor or negatedBorderColor
    imgui.PushStyleColor(imgui_col.Border, pulseColor * colStatus + borderColor * (1 - colStatus))
end
function infoTabKeyboard(globalVars)
    provideMorePluginInfo()
    listKeyboardShortcuts()
    choosePluginBehaviorSettings(globalVars)
    choosePluginAppearance(globalVars)
end
function createQuickTabs(globalVars)
    local tabMenus = {
        "##info",
        "##placeStandard",
        "##placeSpecial",
        "##placeStill",
        "##edit",
        "##delete"
    }
    local tabMenuFunctions = {
        infoTabKeyboard,
        placeStandardSVMenu,
        placeSpecialSVMenu,
        placeStillSVMenu,
        editSVTab,
        deleteTab
    }
    for i = 1, #tabMenus do
        local tabName = tabMenus[i]
        local tabItemFlag = imgui_tab_item_flags.None
        if keysPressedForMenuTab(tabName) then tabItemFlag = imgui_tab_item_flags.SetSelected end
        if imgui.BeginTabItem(tabName, true, tabItemFlag) then
            imgui.InvisibleButton("SV stands for sv veleocity", vector.New(255, 1))
            if tabName == "##info" then
                imgui.Text("This is keyboard mode (for pro users)")
                imgui.Text("Tab navigation: Alt + (Z, X, C, A, S, D)")
                imgui.Text("Tool naviation: Alt + Shift + (Z, X)")
            end
            tabMenuFunctions[i](globalVars)
            imgui.EndTabItem()
        end
    end
end
function focusWindowIfHotkeysPressed()
    local shiftKeyPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local tabKeyPressed = utils.IsKeyPressed(keys.Tab)
    if shiftKeyPressedDown and tabKeyPressed then imgui.SetNextWindowFocus() end
end
function centerWindowIfHotkeysPressed()
    local ctrlPressedDown = utils.IsKeyDown(keys.LeftControl) or
        utils.IsKeyDown(keys.RightControl)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local tabPressed = utils.IsKeyPressed(keys.Tab)
    if not (ctrlPressedDown and shiftPressedDown and tabPressed) then return end
    local windowDim = state.WindowSize
    local pluginDim = imgui.GetWindowSize()
    local centeringX = (windowDim.x - pluginDim.x) / 2
    local centeringY = (windowDim.y - pluginDim.y) / 2
    local coordinatesToCenter = { centeringX, centeringY }
    imgui.SetWindowPos("plumoguSV", coordinatesToCenter)
end
function keysPressedForMenuTab(tabName)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    if shiftPressedDown then return false end
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local otherKey
    if tabName == "##info" then otherKey = keys.A end
    if tabName == "##placeStandard" then otherKey = keys.Z end
    if tabName == "##placeSpecial" then otherKey = keys.X end
    if tabName == "##placeStill" then otherKey = keys.C end
    if tabName == "##edit" then otherKey = keys.S end
    if tabName == "##delete" then otherKey = keys.D end
    local otherKeyPressed = utils.IsKeyPressed(otherKey)
    return altPressedDown and otherKeyPressed
end
function changeSVTypeIfKeysPressed(menuVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return false end
    local maxSVTypes = #STANDARD_SVS
    local isSpecialType = menuVars.interlace == nil
    if isSpecialType then maxSVTypes = #SPECIAL_SVS end
    if xPressed then menuVars.svTypeIndex = menuVars.svTypeIndex + 1 end
    if zPressed then menuVars.svTypeIndex = menuVars.svTypeIndex - 1 end
    menuVars.svTypeIndex = math.wrap(menuVars.svTypeIndex, 1, maxSVTypes)
    return true
end
function changeSelectToolIfKeysPressed(globalVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return end
    if xPressed then globalVars.selectTypeIndex = globalVars.selectTypeIndex + 1 end
    if zPressed then globalVars.selectTypeIndex = globalVars.selectTypeIndex - 1 end
    globalVars.selectTypeIndex = math.wrap(globalVars.selectTypeIndex, 1, #SELECT_TOOLS)
end
function changeEditToolIfKeysPressed(globalVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return end
    if xPressed then globalVars.editToolIndex = globalVars.editToolIndex + 1 end
    if zPressed then globalVars.editToolIndex = globalVars.editToolIndex - 1 end
    globalVars.editToolIndex = math.wrap(globalVars.editToolIndex, 1, #EDIT_SV_TOOLS)
end
function copiableBox(text, label, content)
    imgui.TextWrapped(text)
    imgui.PushItemWidth(imgui.GetContentRegionAvailWidth())
    imgui.InputText(label, content, #content, imgui_input_text_flags.AutoSelectAll)
    imgui.PopItemWidth()
    addPadding()
end
function linkBox(text, url)
    copiableBox(text, "##" .. url, url)
end
function button(text, size, func, globalVars, menuVars)
    if not imgui.Button(text, size) then return end
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
function rgbaToUint(r, g, b, a) return a * 16 ^ 6 + b * 16 ^ 4 + g * 16 ^ 2 + r end
function combo(label, list, listIndex, colorList)
    local newListIndex = listIndex
    local currentComboItem = list[listIndex]
    local comboFlag = imgui_combo_flags.HeightLarge
    rgb = {}
    if (colorList) then
        colorList[listIndex]:gsub("(%d+)", function(c)
            table.insert(rgb, c)
        end)
        imgui.PushStyleColor(imgui_col.Text, vector.New(rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1))
    end
    if not imgui.BeginCombo(label, currentComboItem, comboFlag) then
        if (colorList) then imgui.PopStyleColor() end
        return listIndex
    end
    if (colorList) then imgui.PopStyleColor() end
    for i = 1, #list do
        rgb = {}
        if (colorList) then
            colorList[i]:gsub("(%d+)", function(c)
                table.insert(rgb, c)
            end)
            imgui.PushStyleColor(imgui_col.Text, vector.New(rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1))
        end
        local listItem = list[i]
        if imgui.Selectable(listItem) then
            newListIndex = i
        end
        if (colorList) then imgui.PopStyleColor() end
    end
    imgui.EndCombo()
    return newListIndex
end
function coordsRelativeToWindow(x, y)
    local newX = x + imgui.GetWindowPos()[1]
    local newY = y + imgui.GetWindowPos()[2]
    return { newX, newY }
end
function relativePoint(point, xChange, yChange)
    return { point[1] + xChange, point[2] + yChange }
end
function checkIfFrameChanged(currentTime, fps)
    local oldFrameInfo = {
        frameNumber = 0
    }
    getVariables("oldFrameInfo", oldFrameInfo)
    local newFrameNumber = math.floor(currentTime * fps) % fps
    local frameChanged = oldFrameInfo.frameNumber ~= newFrameNumber
    oldFrameInfo.frameNumber = newFrameNumber
    saveVariables("oldFrameInfo", oldFrameInfo)
    return frameChanged
end
function generate2DPoint(x, y) return { x = x, y = y } end
function generateParticle(x, y, xRange, yRange, endTime, showParticle)
    local particle = {
        x = x,
        y = y,
        xRange = xRange,
        yRange = yRange,
        endTime = endTime,
        showParticle = showParticle
    }
    return particle
end
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
function getCurrentMousePosition()
    return imgui.GetMousePos()
end
function drawEquilateralTriangle(o, centerPoint, size, angle, color)
    local angle2 = 2 * math.pi / 3 + angle
    local angle3 = 4 * math.pi / 3 + angle
    local x1 = centerPoint.x + size * math.cos(angle)
    local y1 = centerPoint.y + size * math.sin(angle)
    local x2 = centerPoint.x + size * math.cos(angle2)
    local y2 = centerPoint.y + size * math.sin(angle2)
    local x3 = centerPoint.x + size * math.cos(angle3)
    local y3 = centerPoint.y + size * math.sin(angle3)
    local p1 = vector.New(x1, y1)
    local p2 = vector.New(x2, y2)
    local p3 = vector.New(x3, y3)
    o.AddTriangleFilled(p1, p2, p3, color)
end
function drawGlare(o, coords, size, glareColor, auraColor)
    local outerRadius = size
    local innerRadius = outerRadius / 7
    local innerPoints = {}
    local outerPoints = {}
    for i = 1, 4 do
        local angle = math.pi * ((2 * i + 1) / 4)
        local innerX = innerRadius * math.cos(angle)
        local innerY = innerRadius * math.sin(angle)
        local outerX = outerRadius * innerX
        local outerY = outerRadius * innerY
        innerPoints[i] = { innerX + coords[1], innerY + coords[2] }
        outerPoints[i] = { outerX + coords[1], outerY + coords[2] }
    end
    o.AddQuadFilled(innerPoints[1], outerPoints[2], innerPoints[3], outerPoints[4], glareColor)
    o.AddQuadFilled(outerPoints[1], innerPoints[2], outerPoints[3], innerPoints[4], glareColor)
    local circlePoints = 20
    local circleSize1 = size / 1.2
    local circleSize2 = size / 3
    o.AddCircleFilled(coords, circleSize1, auraColor, circlePoints)
    o.AddCircleFilled(coords, circleSize2, auraColor, circlePoints)
end
function drawHorizontalPillShape(o, point1, point2, radius, color, circleSegments)
    o.AddCircleFilled(point1, radius, color, circleSegments)
    o.AddCircleFilled(point2, radius, color, circleSegments)
    local rectangleStartCoords = relativePoint(point1, 0, radius)
    local rectangleEndCoords = relativePoint(point2, 0, -radius)
    o.AddRectFilled(rectangleStartCoords, rectangleEndCoords, color)
end
function addPadding()
    imgui.Dummy(vector.New(0, 0))
end
function addSeparator()
    addPadding()
    imgui.Separator()
    addPadding()
end
function toolTip(text)
    if not imgui.IsItemHovered() then return end
    imgui.BeginTooltip()
    imgui.PushTextWrapPos(imgui.GetFontSize() * 20)
    imgui.Text(text)
    imgui.PopTextWrapPos()
    imgui.EndTooltip()
end
function helpMarker(text)
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.TextDisabled("(?)")
    toolTip(text)
end
CREATE_TYPES = {
    "Standard",
    "Special",
    "Still",
    "Vibrato",
}
function createSVTab(globalVars)
    if (globalVars.advancedMode) then chooseCurrentScrollGroup(globalVars) end
    choosePlaceSVType(globalVars)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Standard" then placeStandardSVMenu(globalVars) end
    if placeType == "Special" then placeSpecialSVMenu(globalVars) end
    if placeType == "Still" then placeStillSVMenu(globalVars) end
    if placeType == "Vibrato" then placeVibratoSVMenu(globalVars) end
end
function splitScrollAdvancedMenu(settingVars)
    chooseNumScrolls(settingVars)
    chooseMSPF(settingVars)
    addSeparator()
    chooseScrollIndex(settingVars)
    addSeparator()
    local no1stSVsInitially = #settingVars.svsInScroll1 == 0
    local no2ndSVsInitially = #settingVars.svsInScroll2 == 0
    local no3rdSVsInitially = #settingVars.svsInScroll3 == 0
    local no4thSVsInitially = #settingVars.svsInScroll4 == 0
    local noNoteTimesInitially = #settingVars.noteTimes2 == 0
    local noNoteTimesInitially2 = #settingVars.noteTimes3 == 0
    local noNoteTimesInitially3 = #settingVars.noteTimes4 == 0
    if settingVars.scrollIndex == 1 then
        imgui.TextWrapped("Notes not assigned to the other scrolls will be used for 1st scroll")
        addSeparator()
        buttonsForSVsInScroll1(settingVars, no1stSVsInitially)
    elseif settingVars.scrollIndex == 2 then
        chooseDistanceBack(settingVars)
        addSeparator()
        addOrClearNoteTimes(settingVars, noNoteTimesInitially)
        addSeparator()
        buttonsForSVsInScroll2(settingVars, no2ndSVsInitially)
    elseif settingVars.scrollIndex == 3 then
        chooseDistanceBack2(settingVars)
        addSeparator()
        addOrClearNoteTimes2(settingVars, noNoteTimesInitially2)
        addSeparator()
        buttonsForSVsInScroll3(settingVars, no3rdSVsInitially)
    elseif settingVars.scrollIndex == 4 then
        chooseDistanceBack3(settingVars)
        addSeparator()
        addOrClearNoteTimes3(settingVars, noNoteTimesInitially3)
        addSeparator()
        buttonsForSVsInScroll4(settingVars, no4thSVsInitially)
    end
    if noNoteTimesInitially or no1stSVsInitially or no2ndSVsInitially then return end
    if settingVars.numScrolls > 2 and (noNoteTimesInitially2 or no3rdSVsInitially) then return end
    if settingVars.numScrolls > 3 and (noNoteTimesInitially3 or no4thSVsInitially) then return end
    addSeparator()
    local label = "Place Splitscroll SVs at selected note(s)"
    simpleActionMenu(label, 1, placeAdvancedSplitScrollSVs, nil, settingVars)
end
function splitScrollAdvancedV2Menu(settingVars)
    chooseNumScrolls(settingVars)
    chooseMSPF(settingVars)
    addSeparator()
    chooseScrollIndex(settingVars)
    addSeparator()
    if settingVars.scrollIndex == 2 then
        chooseDistanceBack(settingVars)
    elseif settingVars.scrollIndex == 3 then
        chooseDistanceBack2(settingVars)
    elseif settingVars.scrollIndex == 4 then
        chooseDistanceBack3(settingVars)
    end
    if settingVars.scrollIndex ~= 1 then addSeparator() end
    chooseSplitscrollLayers(settingVars)
    if settingVars.splitscrollLayers[1] == nil then return end
    if settingVars.splitscrollLayers[2] == nil then return end
    if settingVars.numScrolls > 2 and settingVars.splitscrollLayers[3] == nil then return end
    if settingVars.numScrolls > 3 and settingVars.splitscrollLayers[4] == nil then return end
    addSeparator()
    local label = "Place Splitscroll SVs"
    simpleActionMenu(label, 0, placeAdvancedSplitScrollSVsV2, nil, settingVars)
end
function animationFramesSetupMenu(globalVars, settingVars)
    chooseMenuStep(settingVars)
    if settingVars.menuStep == 1 then
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Choose Frame Settings")
        addSeparator()
        chooseNumFrames(settingVars)
        chooseFrameSpacing(settingVars)
        chooseDistance(settingVars)
        helpMarker("Initial separating distance from selected note to the first frame")
        chooseFrameOrder(settingVars)
        addSeparator()
        chooseNoteSkinType(settingVars)
    elseif settingVars.menuStep == 2 then
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Adjust Notes/Frames")
        addSeparator()
        imgui.Columns(2, "Notes and Frames", false)
        addFrameTimes(settingVars)
        displayFrameTimes(settingVars)
        removeSelectedFrameTimeButton(settingVars)
        addPadding()
        chooseFrameTimeData(settingVars)
        imgui.NextColumn()
        chooseCurrentFrame(settingVars)
        drawCurrentFrame(globalVars, settingVars)
        imgui.Columns(1)
        local invisibleButtonSize = { 2 * (ACTION_BUTTON_SIZE.x + 1.5 * SAMELINE_SPACING), 1 }
        imgui.invisibleButton("sv isnt a real skill", invisibleButtonSize)
    else
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Place SVs")
        addSeparator()
        if #settingVars.frameTimes == 0 then
            imgui.Text("No notes added in Step 2, so can't place SVs yet")
            return
        end
        helpMarker("This tool displaces notes into frames after the (first) selected note")
        helpMarker("Works with pre-existing SVs or no SVs in the map")
        helpMarker("This is technically an edit SV tool, but it replaces the old animate function")
        helpMarker("Make sure to prepare an empty area for the frames after the note you select")
        helpMarker("Note: frame positions and viewing them will break if SV distances change")
        addSeparator()
        local label = "Setup frames after selected note"
        simpleActionMenu(label, 1, displaceNotesForAnimationFrames, nil, settingVars)
    end
end
function automateSVMenu(settingVars)
    local copiedSVCount = #settingVars.copiedSVs
    if (copiedSVCount == 0) then
        simpleActionMenu("Copy SVs between selected notes", 2, automateCopySVs, nil, settingVars)
        saveVariables("copyMenu", settingVars)
        return
    end
    button("Clear copied items", ACTION_BUTTON_SIZE, clearAutomateSVs, nil, settingVars)
    addSeparator()
    _, settingVars.maintainMs = imgui.Checkbox("Maintain Time?", true)
    if (settingVars.maintainMs) then
        imgui.SameLine()
        imgui.PushItemWidth(90)
        settingVars.ms = computableInputFloat("Time", settingVars.ms, 2, "ms")
        imgui.PopItemWidth()
    end
    addSeparator()
    simpleActionMenu("Automate SVs for selected notes", 1, automateSVs, nil, settingVars)
end
function automateCopySVs(settingVars)
    settingVars.copiedSVs = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svs = getSVsBetweenOffsets(startOffset, endOffset)
    if (not #svs or #svs == 0) then
        print("W!", "No SVs found within the copiable region.")
        return
    end
    local firstSVTime = svs[1].StartTime
    for _, sv in pairs(getSVsBetweenOffsets(startOffset, endOffset)) do
        local copiedSV = {
            relativeOffset = sv.StartTime - firstSVTime,
            multiplier = sv.Multiplier
        }
        table.insert(settingVars.copiedSVs, copiedSV)
    end
    if (#settingVars.copiedSVs > 0) then print("S!", "Copied " .. #settingVars.copiedSVs .. " SVs") end
end
function clearAutomateSVs(settingVars)
    settingVars.copiedSVs = {}
end
function automateSVs(settingVars)
    local selected = state.SelectedHitObjects
    local timeDict = {}
    for _, v in pairs(selected) do
        if (not table.contains(table.keys(timeDict), "t_" .. v.StartTime)) then
            timeDict["t_" .. v.StartTime] = { v }
        else
            table.insert(timeDict["t_" .. v.StartTime], v)
        end
    end
    local ids = utils.GenerateTimingGroupIds(#table.keys(timeDict), "automate_")
    local index = 1
    local actionList = {}
    for k, v in pairs(timeDict) do
        local startTime = tonumber(k:sub(3))
        local svsToAdd = {}
        for _, sv in ipairs(settingVars.copiedSVs) do
            local timeDistance = settingVars.copiedSVs[#settingVars.copiedSVs].relativeOffset -
                settingVars.copiedSVs[1].relativeOffset
            local progress = sv.relativeOffset / timeDistance
            local timeToPasteSV = startTime - settingVars.ms * (1 - progress)
            table.insert(svsToAdd, utils.CreateScrollVelocity(timeToPasteSV, sv.multiplier))
        end
        local r = math.random(255)
        local g = math.random(255)
        local b = math.random(255)
        local tg = utils.CreateScrollGroup(svsToAdd, 1, r .. "," .. g .. "," .. b)
        local id = ids[index]
        table.insert(actionList, utils.CreateEditorAction(action_type.CreateTimingGroup, id, tg, v))
        index = index + 1
    end
    actions.PerformBatch(actionList)
end
function penisMenu(settingVars)
    _, settingVars.bWidth = imgui.InputInt("Ball Width", settingVars.bWidth)
    _, settingVars.sWidth = imgui.InputInt("Shaft Width", settingVars.sWidth)
    _, settingVars.sCurvature = imgui.SliderInt("S Curvature", settingVars.sCurvature, 1, 100,
        settingVars.sCurvature .. "%%")
    _, settingVars.bCurvature = imgui.SliderInt("B Curvature", settingVars.bCurvature, 1, 100,
        settingVars.bCurvature .. "%%")
    simpleActionMenu("Place SVs", 1, placePenisSV, nil, settingVars)
end
SPECIAL_SVS = {
    "Stutter",
    "Teleport Stutter",
    "Splitscroll (Basic)",
    "Splitscroll (Advanced)",
    "Splitscroll (Adv v2)",
    "Penis",
    "Frames Setup",
    "Automate"
}
function placeSpecialSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getSpecialPlaceMenuVars()
    changeSVTypeIfKeysPressed(menuVars)
    chooseSpecialSVType(menuVars)
    addSeparator()
    local currentSVType = SPECIAL_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Special")
    if globalVars.showExportImportMenu then
        exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end
    if currentSVType == "Stutter" then stutterMenu(settingVars) end
    if currentSVType == "Teleport Stutter" then teleportStutterMenu(settingVars) end
    if currentSVType == "Splitscroll (Basic)" then splitScrollBasicMenu(settingVars) end
    if currentSVType == "Splitscroll (Advanced)" then splitScrollAdvancedMenu(settingVars) end
    if currentSVType == "Splitscroll (Adv v2)" then splitScrollAdvancedV2Menu(settingVars) end
    if currentSVType == "Penis" then penisMenu(settingVars) end
    if currentSVType == "Frames Setup" then
        animationFramesSetupMenu(globalVars, settingVars)
    end
    if currentSVType == "Automate" then automateSVMenu(settingVars) end
    local labelText = table.concat({ currentSVType, "SettingsSpecial" })
    saveVariables(labelText, settingVars)
    saveVariables("placeSpecialMenu", menuVars)
end
function getSpecialPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1
    }
    getVariables("placeSpecialMenu", menuVars)
    return menuVars
end
function splitScrollBasicMenu(settingVars)
    chooseFirstScrollSpeed(settingVars)
    chooseFirstHeight(settingVars)
    chooseSecondScrollSpeed(settingVars)
    chooseSecondHeight(settingVars)
    chooseMSPF(settingVars)
    addSeparator()
    local noNoteTimesInitially = #settingVars.noteTimes2 == 0
    addOrClearNoteTimes(settingVars, noNoteTimesInitially)
    if noNoteTimesInitially then return end
    addSeparator()
    local label = "Place Splitscroll SVs at selected note(s)"
    simpleActionMenu(label, 1, placeSplitScrollSVs, nil, settingVars)
end
function stutterMenu(settingVars)
    local settingsChanged = #settingVars.svMultipliers == 0
    settingsChanged = chooseControlSecondSV(settingVars) or settingsChanged
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseStutterDuration(settingVars) or settingsChanged
    settingsChanged = chooseLinearlyChange(settingVars) or settingsChanged
    addSeparator()
    settingsChanged = chooseStuttersPerSection(settingVars) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, false) or settingsChanged
    if settingsChanged then updateStutterMenuSVs(settingVars) end
    displayStutterSVWindows(settingVars)
    addSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeStutterSVs, nil, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeStutterSSFs, nil, settingVars, true)
end
function teleportStutterMenu(settingVars)
    if settingVars.useDistance then
        chooseDistance(settingVars)
        helpMarker("Start SV teleport distance")
    else
        chooseStartSVPercent(settingVars)
    end
    chooseMainSV(settingVars)
    chooseAverageSV(settingVars)
    chooseFinalSV(settingVars, false)
    chooseUseDistance(settingVars)
    chooseLinearlyChange(settingVars)
    addSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeTeleportStutterSVs, nil, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeTeleportStutterSSFs, nil, settingVars, true)
end
STANDARD_SVS = {
    "Linear",
    "Exponential",
    "Bezier",
    "Hermite",
    "Sinusoidal",
    "Circular",
    "Random",
    "Custom",
    "Chinchilla",
    "Combo"
}
function placeStandardSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getStandardPlaceMenuVars()
    local needSVUpdate = changeSVTypeIfKeysPressed(menuVars)
    needSVUpdate = needSVUpdate or #menuVars.svMultipliers == 0
    needSVUpdate = chooseStandardSVType(menuVars, false) or needSVUpdate
    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Standard")
    if globalVars.showExportImportMenu then
        exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end
    needSVUpdate = showSettingsMenu(currentSVType, settingVars, false, nil) or needSVUpdate
    addSeparator()
    needSVUpdate = chooseInterlace(menuVars) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false) end
    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, false)
    menuVars.settingVars = settingVars
    addSeparator()
    if (STANDARD_SVS[menuVars.svTypeIndex] == "Exponential" and settingVars.distanceMode == 2) then
        simpleActionMenu("Place SVs between selected notes##Exponential", 2, placeExponentialSpecialSVs, globalVars,
            menuVars)
    else
        simpleActionMenu("Place SVs between selected notes", 2, placeSVs, globalVars, menuVars)
    end
    simpleActionMenu("Place SSFs between selected notes", 2, placeSSFs, globalVars, menuVars, true)
    local labelText = table.concat({ currentSVType, "SettingsStandard" })
    saveVariables(labelText, settingVars)
    saveVariables("placeStandardMenu", menuVars)
end
function getStandardPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1,
        svMultipliers = {},
        svDistances = {},
        svGraphStats = createSVGraphStats(),
        svStats = createSVStats(),
        interlace = false,
        interlaceRatio = -0.5,
        overrideFinal = false
    }
    getVariables("placeStandardMenu", menuVars)
    return menuVars
end
function placeStillSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getStillPlaceMenuVars()
    local needSVUpdate = changeSVTypeIfKeysPressed(menuVars)
    needSVUpdate = needSVUpdate or #menuVars.svMultipliers == 0
    needSVUpdate = chooseStandardSVType(menuVars, false) or needSVUpdate
    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Still")
    if globalVars.showExportImportMenu then
        exportImportSettingsMenu(globalVars, menuVars, settingVars)
        return
    end
    imgui.Text("Still Settings:")
    chooseNoteSpacing(menuVars)
    chooseStillBehavior(menuVars)
    chooseStillType(menuVars)
    addSeparator()
    needSVUpdate = showSettingsMenu(currentSVType, settingVars, false, nil) or needSVUpdate
    addSeparator()
    needSVUpdate = chooseInterlace(menuVars) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false) end
    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, false)
    addSeparator()
    menuVars.settingVars = settingVars
    simpleActionMenu("Place SVs between selected notes", 2, placeStillSVsParent, globalVars, menuVars)
    local labelText = table.concat({ currentSVType, "SettingsStill" })
    saveVariables(labelText, settingVars)
    saveVariables("placeStillMenu", menuVars)
end
function getStillPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1,
        noteSpacing = 1,
        stillTypeIndex = 1,
        stillDistance = 0,
        stillBehavior = 1,
        prePlaceDistances = {},
        svMultipliers = {},
        svDistances = {},
        svGraphStats = createSVGraphStats(),
        svStats = createSVStats(),
        interlace = false,
        interlaceRatio = -0.5,
        overrideFinal = false
    }
    getVariables("placeStillMenu", menuVars)
    return menuVars
end
function linearVibratoMenu(settingVars)
    customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs")
    customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs")
    simpleActionMenu("Place SSFs", 2, linearSSFVibrato, nil, settingVars)
end
VIBRATO_SVS = {
    "Linear SSF"
}
function placeVibratoSVMenu(globalVars)
    exportImportSettingsButton(globalVars)
    local menuVars = getVibratoPlaceMenuVars()
    changeSVTypeIfKeysPressed(menuVars)
    chooseVibratoSVType(menuVars)
    addSeparator()
    local currentSVType = VIBRATO_SVS[menuVars.svTypeIndex]
    local settingVars = getSettingVars(currentSVType, "Vibrato")
    if globalVars.showExportImportMenu then
        return
    end
    if currentSVType == "Linear SSF" then linearVibratoMenu(settingVars) end
    local labelText = table.concat({ currentSVType, "SettingsVibrato" })
    saveVariables(labelText, settingVars)
    saveVariables("placeVibratoMenu", menuVars)
end
function getVibratoPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1
    }
    getVariables("placeVibratoMenu", menuVars)
    return menuVars
end
function deleteTab(_)
    local menuVars = {
        deleteTable = { true, true, true, true }
    }
    getVariables("deleteMenu", menuVars)
    _, menuVars.deleteTable[1] = imgui.Checkbox("Delete Lines", menuVars.deleteTable[1])
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.deleteTable[2] = imgui.Checkbox("Delete SVs", menuVars.deleteTable[2])
    _, menuVars.deleteTable[3] = imgui.Checkbox("Delete SSFs", menuVars.deleteTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.deleteTable[4] = imgui.Checkbox("Delete Bookmarks", menuVars.deleteTable[4])
    saveVariables("deleteMenu", menuVars)
    for i = 1, 4 do
        if (menuVars.deleteTable[i]) then goto continue end
    end
    do return 69 end
    ::continue::
    simpleActionMenu("Delete items between selected notes", 2, deleteItems, nil, menuVars)
end
function addTeleportMenu()
    local menuVars = {
        distance = 10727,
        teleportBeforeHand = false
    }
    getVariables("addTeleportMenu", menuVars)
    chooseDistance(menuVars)
    chooseHand(menuVars)
    saveVariables("addTeleportMenu", menuVars)
    addSeparator()
    simpleActionMenu("Add teleport SVs at selected notes", 1, addTeleportSVs, nil, menuVars)
end
function alignTimingLinesMenu()
    simpleActionMenu("Align timing lines in this region", 0, alignTimingLines, nil, nil)
end
function tempBugFixMenu()
    imgui.PushTextWrapPos(200)
    imgui.TextWrapped(
        "note: this will not fix already broken regions, but will hopefully turn non-broken regions into things you can properly copy paste with no issues. ")
    imgui.NewLine()
    imgui.TextWrapped(
        "Copy paste bug is caused when two svs are on top of each other, because of the way Quaver handles dupe svs; the order in the .qua file determines rendering order. When duplicating stacked svs, the order has a chance to reverse, therefore making a different sv prioritized and messing up proper movement. Possible solutions include getting better at coding or merging SV before C+P.")
    imgui.NewLine()
    imgui.TextWrapped(
        " If you copy paste and the original SV gets broken, this likely means that the game changed the rendering order of duplicated svs on the original SV. Either try this tool, or use Edit SVs > Merge.")
    imgui.PopTextWrapPos()
    simpleActionMenu("Try to fix regions to become copy pastable", 0, tempBugFix, nil, nil)
end
function copyNPasteMenu(globalVars)
    local menuVars = {
        copyTable = { true, true, true, true },
        copiedLines = {},
        copiedSVs = {},
        copiedSSFs = {},
        copiedBMs = {},
    }
    getVariables("copyMenu", menuVars)
    _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.copyTable[2] = imgui.Checkbox("Copy SVs", menuVars.copyTable[2])
    _, menuVars.copyTable[3] = imgui.Checkbox("Copy SSFs", menuVars.copyTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.copyTable[4] = imgui.Checkbox("Copy Bookmarks", menuVars.copyTable[4])
    addSeparator()
    local copiedItemCount = #menuVars.copiedLines + #menuVars.copiedSVs + #menuVars.copiedSSFs + #menuVars.copiedBMs
    if (copiedItemCount == 0) then
        simpleActionMenu("Copy items between selected notes", 2, copyItems, nil, menuVars)
    else
        button("Clear copied items", ACTION_BUTTON_SIZE, clearCopiedItems, nil, menuVars)
    end
    saveVariables("copyMenu", menuVars)
    if copiedItemCount == 0 then return end
    addSeparator()
    simpleActionMenu("Paste items at selected notes", 1, pasteItems, globalVars, menuVars)
end
function updateDirectEdit()
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]
    if (#offsets < 2) then
        state.SetValue("directSVList", {})
        return
    end
    local svs = getSVsBetweenOffsets(firstOffset, lastOffset)
    state.SetValue("directSVList", svs)
end
function directSVMenu()
    local menuVars = {
        selectableIndex = 1,
        startTime = 0,
        multiplier = 0,
        pageNumber = 1
    }
    getVariables("directSVMenu", menuVars)
    local clockTime = 0.2
    if ((state.UnixTime or 0) - (state.GetValue("lastRecordedTime") or 0) >= clockTime) then
        state.SetValue("lastRecordedTime", state.UnixTime or 0)
        updateDirectEdit()
    end
    local svs = state.GetValue("directSVList") or {}
    if (#svs == 0) then
        menuVars.selectableIndex = 1
        imgui.TextWrapped("Select two notes to view SVs.")
        return
    end
    if (menuVars.selectableIndex > #svs) then menuVars.selectableIndex = #svs end
    local oldStartTime = svs[menuVars.selectableIndex].StartTime
    local oldMultiplier = svs[menuVars.selectableIndex].Multiplier
    local primeStartTime = state.GetValue("primeStartTime") or false
    local primeMultiplier = state.GetValue("primeMultiplier") or false
    _, menuVars.startTime = imgui.InputFloat("Start Time", oldStartTime)
    _, menuVars.multiplier = imgui.InputFloat("Multiplier", oldMultiplier)
    if (oldStartTime ~= menuVars.startTime) then
        primeStartTime = true
    else
        if (not primeStartTime) then goto continue1 end
        primeStartTime = false
        local newSV = utils.CreateScrollVelocity(state.GetValue("savedStartTime") or 0, menuVars.multiplier)
        actions.PerformBatch({ utils.CreateEditorAction(action_type.RemoveScrollVelocity, svs[menuVars.selectableIndex]),
            utils.CreateEditorAction(action_type.AddScrollVelocity, newSV) })
    end
    ::continue1::
    if (oldMultiplier ~= menuVars.multiplier) then
        primeMultiplier = true
    else
        if (not primeMultiplier) then goto continue2 end
        primeMultiplier = false
        local newSV = utils.CreateScrollVelocity(menuVars.startTime, state.GetValue("savedMultiplier") or 1)
        actions.PerformBatch({ utils.CreateEditorAction(action_type.RemoveScrollVelocity, svs[menuVars.selectableIndex]),
            utils.CreateEditorAction(action_type.AddScrollVelocity, newSV) })
    end
    ::continue2::
    state.SetValue("primeStartTime", primeStartTime)
    state.SetValue("primeMultiplier", primeMultiplier)
    state.SetValue("savedStartTime", menuVars.startTime)
    state.SetValue("savedMultiplier", menuVars.multiplier)
    imgui.Separator()
    if (imgui.Button("<##DirectSV")) then
        menuVars.pageNumber = math.clamp(menuVars.pageNumber - 1, 1, math.ceil(#svs / 10))
    end
    imgui.SameLine()
    imgui.Text("Page ")
    imgui.SameLine()
    imgui.SetNextItemWidth(100)
    _, menuVars.pageNumber = imgui.InputInt("##PageNum", math.clamp(menuVars.pageNumber, 1, math.ceil(#svs / 10)), 0)
    imgui.SameLine()
    imgui.Text(" of " .. math.ceil(#svs / 10))
    imgui.SameLine()
    if (imgui.Button(">##DirectSV")) then
        menuVars.pageNumber = math.clamp(menuVars.pageNumber + 1, 1, math.ceil(#svs / 10))
    end
    imgui.Separator()
    imgui.Text("Start Time")
    imgui.SameLine()
    imgui.SetCursorPosX(150)
    imgui.Text("Multiplier")
    imgui.Separator()
    imgui.BeginTable("Test", 2)
    for idx, v in pairs({ table.unpack(svs, 1 + 10 * (menuVars.pageNumber - 1), 10 * menuVars.pageNumber) }) do
        imgui.PushID(idx)
        imgui.TableNextRow()
        imgui.TableSetColumnIndex(0)
        imgui.Selectable(tostring(math.round(v.StartTime, 2)), menuVars.selectableIndex == idx,
            imgui_selectable_flags.SpanAllColumns)
        if (imgui.IsItemClicked()) then
            menuVars.selectableIndex = idx
        end
        imgui.TableSetColumnIndex(1)
        imgui.SetCursorPosX(150)
        imgui.Text(tostring(math.round(v.Multiplier, 2)));
        imgui.PopID()
    end
    imgui.EndTable()
    saveVariables("directSVMenu", menuVars)
end
function displaceNoteMenu()
    local menuVars = {
        distance = 200,
        distance1 = 0,
        distance2 = 200,
        linearlyChange = false
    }
    getVariables("displaceNoteMenu", menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    saveVariables("displaceNoteMenu", menuVars)
    addSeparator()
    simpleActionMenu("Displace selected notes", 1, displaceNoteSVsParent, nil, menuVars)
end
function displaceViewMenu()
    local menuVars = {
        distance = 200
    }
    getVariables("displaceViewMenu", menuVars)
    chooseDistance(menuVars)
    saveVariables("displaceViewMenu", menuVars)
    addSeparator()
    simpleActionMenu("Displace view between selected notes", 2, displaceViewSVs, nil, menuVars)
end
function dynamicScaleMenu(globalVars)
    local menuVars = {
        noteTimes = {},
        svTypeIndex = 1,
        svMultipliers = {},
        svDistances = {},
        svGraphStats = createSVGraphStats(),
        svStats = createSVStats()
    }
    getVariables("dynamicScaleMenu", menuVars)
    local numNoteTimes = #menuVars.noteTimes
    imgui.Text(#menuVars.noteTimes .. " note times assigned to scale SVs between")
    addNoteTimesToDynamicScaleButton(menuVars)
    if numNoteTimes == 0 then
        saveVariables("dynamicScaleMenu", menuVars)
        return
    else
        clearNoteTimesButton(menuVars)
    end
    addSeparator()
    if #menuVars.noteTimes < 3 then
        imgui.Text("Not enough note times assigned")
        imgui.Text("Assign 3 or more note times instead")
        saveVariables("dynamicScaleMenu", menuVars)
        return
    end
    local numSVPoints = numNoteTimes - 1
    local needSVUpdate = #menuVars.svMultipliers == 0 or (#menuVars.svMultipliers ~= numSVPoints)
    imgui.AlignTextToFramePadding()
    imgui.Text("Shape:")
    imgui.SameLine(0, SAMELINE_SPACING)
    needSVUpdate = chooseStandardSVType(menuVars, true) or needSVUpdate
    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    if currentSVType == "Sinusoidal" then
        imgui.Text("Import sinusoidal values using 'Custom' instead")
        saveVariables("dynamicScaleMenu", menuVars)
        return
    end
    local settingVars = getSettingVars(currentSVType, "DynamicScale")
    needSVUpdate = showSettingsMenu(currentSVType, settingVars, true, numSVPoints) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, true) end
    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, true)
    local labelText = table.concat({ currentSVType, "SettingsDynamicScale" })
    saveVariables(labelText, settingVars)
    saveVariables("dynamicScaleMenu", menuVars)
    addSeparator()
    simpleActionMenu("Scale spacing between assigned notes", 0, dynamicScaleSVs, nil, menuVars)
end
EDIT_SV_TOOLS = {
    "Add Teleport",
    "Align Timing Lines",
    "bug fixing from <1.1.2",
    "Copy & Paste",
    "Direct SV",
    "Displace Note",
    "Displace View",
    "Dynamic Scale",
    "Fix LN Ends",
    "Flicker",
    "Measure",
    "Merge",
    "Reverse Scroll",
    "Scale (Displace)",
    "Scale (Multiply)",
    "Swap Notes",
    "Vertical Shift"
}
function editSVTab(globalVars)
    if (globalVars.advancedMode) then chooseCurrentScrollGroup(globalVars) end
    chooseEditTool(globalVars)
    changeEditToolIfKeysPressed(globalVars)
    addSeparator()
    local toolName = EDIT_SV_TOOLS[globalVars.editToolIndex]
    if toolName == "Add Teleport" then addTeleportMenu() end
    if toolName == "Align Timing Lines" then alignTimingLinesMenu() end
    if toolName == "bug fixing from <1.1.2" then tempBugFixMenu() end
    if toolName == "Copy & Paste" then copyNPasteMenu(globalVars) end
    if toolName == "Direct SV" then directSVMenu() end
    if toolName == "Displace Note" then displaceNoteMenu() end
    if toolName == "Displace View" then displaceViewMenu() end
    if toolName == "Dynamic Scale" then dynamicScaleMenu(globalVars) end
    if toolName == "Fix LN Ends" then fixLNEndsMenu() end
    if toolName == "Flicker" then flickerMenu() end
    if toolName == "Measure" then measureMenu() end
    if toolName == "Merge" then mergeMenu() end
    if toolName == "Reverse Scroll" then reverseScrollMenu() end
    if toolName == "Scale (Displace)" then scaleDisplaceMenu() end
    if toolName == "Scale (Multiply)" then scaleMultiplyMenu() end
    if toolName == "Swap Notes" then swapNotesMenu() end
    if toolName == "Vertical Shift" then verticalShiftMenu() end
end
function fixLNEndsMenu()
    local menuVars = {
        fixedText = "No flipped LN ends fixed yet"
    }
    getVariables("fixLNEndsMenu", menuVars)
    imgui.Text(menuVars.fixedText)
    helpMarker("If there is a negative SV at an LN end, the LN end will be flipped. This is " ..
        "noticable especially for arrow skins and is jarring. This tool will fix that.")
    addSeparator()
    simpleActionMenu("Fix flipped LN ends", 0, fixFlippedLNEnds, nil, menuVars)
    saveVariables("fixLNEndsMenu", menuVars)
end
function flickerMenu()
    local menuVars = {
        flickerTypeIndex = 1,
        distance = -69420.727,
        distance1 = 0,
        distance2 = -69420.727,
        numFlickers = 1,
        linearlyChange = false
    }
    getVariables("flickerMenu", menuVars)
    chooseFlickerType(menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    chooseNumFlickers(menuVars)
    saveVariables("flickerMenu", menuVars)
    addSeparator()
    simpleActionMenu("Add flicker SVs between selected notes", 2, flickerSVs, nil, menuVars)
end
function measureMenu()
    local menuVars = {
        unrounded = false,
        nsvDistance = "",
        svDistance = "",
        avgSV = "",
        startDisplacement = "",
        endDisplacement = "",
        avgSVDisplaceless = "",
        roundedNSVDistance = 0,
        roundedSVDistance = 0,
        roundedAvgSV = 0,
        roundedStartDisplacement = 0,
        roundedEndDisplacement = 0,
        roundedAvgSVDisplaceless = 0
    }
    getVariables("measureMenu", menuVars)
    chooseMeasuredStatsView(menuVars)
    addSeparator()
    if menuVars.unrounded then
        displayMeasuredStatsUnrounded(menuVars)
    else
        displayMeasuredStatsRounded(menuVars)
    end
    addPadding()
    imgui.TextDisabled("*** Measuring disclaimer ***")
    toolTip("Measured values might not be 100%% accurate & may not work on older maps")
    addSeparator()
    simpleActionMenu("Measure SVs between selected notes", 2, measureSVs, nil, menuVars)
    saveVariables("measureMenu", menuVars)
end
function displayMeasuredStatsRounded(menuVars)
    imgui.Columns(2, "Measured SV Stats", false)
    imgui.Text("NSV distance:")
    imgui.Text("SV distance:")
    imgui.Text("Average SV:")
    imgui.Text("Start displacement:")
    imgui.Text("End displacement:")
    imgui.Text("True average SV:")
    imgui.NextColumn()
    imgui.Text(table.concat({ menuVars.roundedNSVDistance, " msx" }))
    helpMarker("The normal distance between the start and the end, ignoring SVs")
    imgui.Text(table.concat({ menuVars.roundedSVDistance, " msx" }))
    helpMarker("The actual distance between the start and the end, calculated with SVs")
    imgui.Text(table.concat({ menuVars.roundedAvgSV, "x" }))
    imgui.Text(table.concat({ menuVars.roundedStartDisplacement, " msx" }))
    helpMarker("Calculated using plumoguSV displacement metrics, so might not always work")
    imgui.Text(table.concat({ menuVars.roundedEndDisplacement, " msx" }))
    helpMarker("Calculated using plumoguSV displacement metrics, so might not always work")
    imgui.Text(table.concat({ menuVars.roundedAvgSVDisplaceless, "x" }))
    helpMarker("Average SV calculated ignoring the start and end displacement")
    imgui.Columns(1)
end
function displayMeasuredStatsUnrounded(menuVars)
    copiableBox("NSV distance", "##nsvDistance", menuVars.nsvDistance)
    copiableBox("SV distance", "##svDistance", menuVars.svDistance)
    copiableBox("Average SV", "##avgSV", menuVars.avgSV)
    copiableBox("Start displacement", "##startDisplacement", menuVars.startDisplacement)
    copiableBox("End displacement", "##endDisplacement", menuVars.endDisplacement)
    copiableBox("True average SV", "##avgSVDisplaceless", menuVars.avgSVDisplaceless)
end
function mergeMenu()
    simpleActionMenu("Merge duplicate SVs between selected notes", 2, mergeSVs, nil, nil)
end
function reverseScrollMenu()
    local menuVars = {
        distance = 400
    }
    getVariables("reverseScrollMenu", menuVars)
    chooseDistance(menuVars)
    helpMarker("Height at which reverse scroll notes are hit")
    saveVariables("reverseScrollMenu", menuVars)
    addSeparator()
    local buttonText = "Reverse scroll between selected notes"
    simpleActionMenu(buttonText, 2, reverseScrollSVs, nil, menuVars)
end
function scaleDisplaceMenu()
    local menuVars = {
        scaleSpotIndex = 1,
        scaleTypeIndex = 1,
        avgSV = 0.6,
        distance = 100,
        ratio = 0.6,
    }
    getVariables("scaleDisplaceMenu", menuVars)
    chooseScaleDisplaceSpot(menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleDisplaceMenu", menuVars)
    addSeparator()
    local buttonText = "Scale SVs between selected notes##displace"
    simpleActionMenu(buttonText, 2, scaleDisplaceSVs, nil, menuVars)
end
function scaleMultiplyMenu()
    local menuVars = {
        scaleTypeIndex = 1,
        avgSV = 0.6,
        distance = 100,
        ratio = 0.6
    }
    getVariables("scaleMultiplyMenu", menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleMultiplyMenu", menuVars)
    addSeparator()
    local buttonText = "Scale SVs between selected notes##multiply"
    simpleActionMenu(buttonText, 2, scaleMultiplySVs, nil, menuVars)
end
function swapNotesMenu()
    simpleActionMenu("Swap selected notes using SVs", 2, swapNoteSVs, nil, nil)
end
function verticalShiftMenu()
    local menuVars = {
        verticalShift = 1
    }
    getVariables("verticalShiftMenu", menuVars)
    chooseConstantShift(menuVars, 0)
    saveVariables("verticalShiftMenu", menuVars)
    addSeparator()
    local buttonText = "Vertically shift SVs between selected notes"
    simpleActionMenu(buttonText, 2, verticalShiftSVs, nil, menuVars)
end
function infoTab(globalVars)
    provideBasicPluginInfo()
    provideMorePluginInfo()
    listKeyboardShortcuts()
    choosePluginBehaviorSettings(globalVars)
    choosePluginAppearance(globalVars)
    chooseHotkeys(globalVars)
    chooseAdvancedMode(globalVars)
    if (globalVars.advancedMode) then
        chooseHideAutomatic(globalVars)
    end
end
function provideBasicPluginInfo()
    imgui.Text("Steps to use plumoguSV:")
    imgui.BulletText("Choose an SV tool")
    imgui.BulletText("Adjust the SV tool's settings")
    imgui.BulletText("Select notes to use the tool at/between")
    imgui.BulletText("Press '" .. GLOBAL_HOTKEY_LIST[1] .. "' on your keyboard")
    addPadding()
end
function provideMorePluginInfo()
    if not imgui.CollapsingHeader("More Info") then return end
    addPadding()
    linkBox("Goofy SV mapping guide",
        "https://docs.google.com/document/d/1ug_WV_BI720617ybj4zuHhjaQMwa0PPekZyJoa17f-I")
    linkBox("GitHub repository", "https://github.com/ESV-Sweetplum/plumoguSV")
end
function listKeyboardShortcuts()
    if not imgui.CollapsingHeader("Keyboard Shortcuts") then return end
    local indentAmount = -6
    imgui.Indent(indentAmount)
    addPadding()
    imgui.BulletText("Ctrl + Shift + Tab = center plugin window")
    toolTip("Useful if the plugin begins or ends up offscreen")
    addSeparator()
    imgui.BulletText("Shift + Tab = focus plugin + navigate inputs")
    toolTip("Useful if you click off the plugin but want to quickly change an input value")
    addSeparator()
    imgui.BulletText("T = activate the big button doing SV stuff")
    toolTip("Use this to do SV stuff for a quick workflow")
    addSeparator()
    imgui.BulletText("Shift+T = activate the big button doing SSF stuff")
    toolTip("Use this to do SSF stuff for a quick workflow")
    addSeparator()
    imgui.BulletText("Alt + Shift + (Z or X) = switch tool type")
    toolTip("Use this to do SV stuff for a quick workflow")
    addPadding()
    imgui.Unindent(indentAmount)
end
TAB_MENUS = {
    "Info",
    "Select",
    "Create",
    "Edit",
    "Delete"
}
function createMenuTab(globalVars, tabName)
    if not imgui.BeginTabItem(tabName) then return end
    addPadding()
    if tabName == "Info" then infoTab(globalVars) end
    if tabName == "Select" then selectTab(globalVars) end
    if tabName == "Create" then createSVTab(globalVars) end
    if tabName == "Edit" then editSVTab(globalVars) end
    if tabName == "Delete" then deleteTab(globalVars) end
    imgui.EndTabItem()
end
function selectAlternatingMenu()
    local menuVars = {
        every = 1,
        offset = 0
    }
    getVariables("selectAlternatingMenu", menuVars)
    chooseEvery(menuVars)
    chooseOffset(menuVars)
    saveVariables("selectAlternatingMenu", menuVars)
    local text = ""
    if (menuVars.every > 1) then text = "s" end
    addSeparator()
    simpleActionMenu(
        "Select a note every " .. menuVars.every .. " note" .. text .. ", from note #" .. menuVars.offset,
        2,
        selectAlternating, nil, menuVars)
end
function selectBookmarkMenu()
    local bookmarks = map.bookmarks
    local selectedIndex = state.GetValue("selectedIndex") or 0
    local searchTerm = state.GetValue("searchTerm") or ""
    local filterTerm = state.GetValue("filterTerm") or ""
    local times = {}
    if (#bookmarks == 0) then
        imgui.TextWrapped("There are no bookmarks! Add one to navigate.")
    else
        imgui.PushItemWidth(70)
        _, searchTerm = imgui.InputText("Search", searchTerm, 4096)
        imgui.SameLine()
        _, filterTerm = imgui.InputText("Ignore", filterTerm, 4096)
        imgui.Columns(3)
        imgui.Text("Time")
        imgui.NextColumn()
        imgui.Text("Bookmark Label")
        imgui.NextColumn()
        imgui.Text("Leap")
        imgui.NextColumn()
        imgui.Separator()
        local skippedBookmarks = 0
        local skippedIndices = 0
        for idx, v in pairs(bookmarks) do
            if (v.StartTime < 0) then
                skippedBookmarks = skippedBookmarks + 1
                skippedIndices = skippedIndices + 1
                goto continue
            end
            if (searchTerm:len() > 0) and (not v.Note:find(searchTerm)) then
                skippedBookmarks = skippedBookmarks + 1
                goto continue
            end
            if (filterTerm:len() > 0) and (v.Note:find(filterTerm)) then
                skippedBookmarks = skippedBookmarks + 1
                goto continue
            end
            vPos = 126.5 + (idx - skippedBookmarks) * 32
            imgui.SetCursorPosY(vPos)
            table.insert(times, v.StartTime)
            imgui.Text(v.StartTime)
            imgui.NextColumn()
            imgui.SetCursorPosY(vPos)
            if (imgui.CalcTextSize(v.Note)[1] > 110) then
                local note = v.Note
                while (imgui.CalcTextSize(note)[1] > 85) do
                    note = note:sub(1, #note - 1)
                end
                imgui.Text(note .. "...")
            else
                imgui.Text(v.Note)
            end
            imgui.NextColumn()
            if (imgui.Button("Go to #" .. idx - skippedIndices, vector.New(65, 24))) then
                actions.GoToObjects(v.StartTime)
            end
            imgui.NextColumn()
            if (idx ~= #bookmarks) then imgui.Separator() end
            ::continue::
        end
        local maxTimeLength = #tostring(math.max(table.unpack(times) or 0))
        imgui.SetColumnWidth(0, maxTimeLength * 10.25)
        imgui.SetColumnWidth(1, 110)
        imgui.SetColumnWidth(2, 80)
        imgui.PopItemWidth()
        imgui.Columns(1)
    end
    state.SetValue("selectedIndex", selectedIndex)
    state.SetValue("searchTerm", searchTerm)
    state.SetValue("filterTerm", filterTerm)
end
function selectChordSizeMenu()
    local menuVars = {
        single = false,
        jump = true,
        hand = true,
        quad = false
    }
    getVariables("selectChordSizeMenu", menuVars)
    _, menuVars.single = imgui.Checkbox("Select Singles", menuVars.single)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.jump = imgui.Checkbox("Select Jumps", menuVars.jump)
    _, menuVars.hand = imgui.Checkbox("Select Hands", menuVars.hand)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.quad = imgui.Checkbox("Select Quads", menuVars.quad)
    simpleActionMenu("Select chords within region", 2, selectByChordSizes, nil, menuVars)
    saveVariables("selectChordSizeMenu", menuVars)
end
function selectNoteTypeMenu()
    local menuVars = {
        rice = true,
        ln = true
    }
    getVariables("selectNoteTypeMenu", menuVars)
    _, menuVars.rice = imgui.Checkbox("Select Rice Notes", menuVars.rice)
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.ln = imgui.Checkbox("Select LNs", menuVars.ln)
    simpleActionMenu("Select notes within region", 2, selectByNoteType, nil, menuVars)
    saveVariables("selectNoteTypeMenu", menuVars)
end
SELECT_TOOLS = {
    "Alternating",
    "By Snap",
    "Chord Size",
    "Note Type",
    "Bookmark",
}
function selectTab(globalVars)
    chooseSelectTool(globalVars)
    changeSelectToolIfKeysPressed(globalVars)
    addSeparator()
    local toolName = SELECT_TOOLS[globalVars.selectTypeIndex]
    if toolName == "Alternating" then selectAlternatingMenu() end
    if toolName == "By Snap" then selectBySnapMenu() end
    if toolName == "Bookmark" then selectBookmarkMenu() end
    if toolName == "Chord Size" then selectChordSizeMenu() end
    if toolName == "Note Type" then selectNoteTypeMenu() end
end
function selectBySnapMenu()
    local menuVars = {
        snap = 1,
    }
    getVariables("selectBySnapMenu", menuVars)
    chooseSnap(menuVars)
    saveVariables("selectBySnapMenu", menuVars)
    addSeparator()
    simpleActionMenu(
        "Select notes with 1/" .. menuVars.snap .. " snap",
        2,
        selectBySnap, nil, menuVars)
end
function bezierSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = provideBezierWebsiteLink(settingVars) or settingsChanged
    settingsChanged = chooseBezierPoints(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
function chinchillaSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseSVBehavior(settingVars) or settingsChanged
    settingsChanged = chooseChinchillaType(settingVars) or settingsChanged
    settingsChanged = chooseChinchillaIntensity(settingVars) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
function circularSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseSVBehavior(settingVars) or settingsChanged
    settingsChanged = chooseArcPercent(settingVars) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    settingsChanged = chooseNoNormalize(settingVars) or settingsChanged
    return settingsChanged
end
function comboSettingsMenu(settingVars)
    local settingsChanged = false
    startNextWindowNotCollapsed("svType1AutoOpen")
    imgui.Begin("SV Type 1 Settings", imgui_window_flags.AlwaysAutoResize)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    local svType1 = STANDARD_SVS[settingVars.svType1Index]
    local settingVars1 = getSettingVars(svType1, "Combo1")
    settingsChanged = showSettingsMenu(svType1, settingVars1, true, nil) or settingsChanged
    local labelText1 = table.concat({ svType1, "SettingsCombo1" })
    saveVariables(labelText1, settingVars1)
    imgui.End()
    startNextWindowNotCollapsed("svType2AutoOpen")
    imgui.Begin("SV Type 2 Settings", imgui_window_flags.AlwaysAutoResize)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    local svType2 = STANDARD_SVS[settingVars.svType2Index]
    local settingVars2 = getSettingVars(svType2, "Combo2")
    settingsChanged = showSettingsMenu(svType2, settingVars2, true, nil) or settingsChanged
    local labelText2 = table.concat({ svType2, "SettingsCombo2" })
    saveVariables(labelText2, settingVars2)
    imgui.End()
    local maxComboPhase = settingVars1.svPoints + settingVars2.svPoints
    settingsChanged = chooseStandardSVTypes(settingVars) or settingsChanged
    settingsChanged = chooseComboSVOption(settingVars, maxComboPhase) or settingsChanged
    addSeparator()
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    if not settingVars.dontNormalize then
        settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    end
    settingsChanged = chooseFinalSV(settingVars, false) or settingsChanged
    settingsChanged = chooseNoNormalize(settingVars) or settingsChanged
    return settingsChanged
end
function customSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = importCustomSVs(settingVars) or settingsChanged
    settingsChanged = chooseCustomMultipliers(settingVars) or settingsChanged
    if not (svPointsForce and skipFinalSV) then addSeparator() end
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    adjustNumberOfMultipliers(settingVars)
    return settingsChanged
end
function exponentialSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseSVBehavior(settingVars) or settingsChanged
    settingsChanged = chooseIntensity(settingVars) or settingsChanged
    if (state.GetValue("global_advancedMode")) then
        settingsChanged = chooseDistanceMode(settingVars) or settingsChanged
    end
    if (settingVars.distanceMode ~= 3) then
        settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    end
    if (settingVars.distanceMode == 1) then
        settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    elseif (settingVars.distanceMode == 2) then
        settingsChanged = chooseDistance(settingVars) or settingsChanged
    else
        settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    end
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
function exportImportSettingsMenu(globalVars, menuVars, settingVars)
    local multilineWidgetSize = { ACTION_BUTTON_SIZE.x, 50 }
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    local isSpecialPlaceType = placeType == "Special"
    local svType
    if isSpecialPlaceType then
        svType = SPECIAL_SVS[menuVars.svTypeIndex]
    else
        svType = STANDARD_SVS[menuVars.svTypeIndex]
    end
    local isComboType = svType == "Combo"
    local noExportOption = svType == "Splitscroll (Basic)" or
        svType == "Splitscroll (Advanced)" or
        svType == "Frames Setup"
    imgui.Text("Paste exported data here to import")
    _, globalVars.importData = imgui.InputTextMultiline("##placeImport", globalVars.importData,
        MAX_IMPORT_CHARACTER_LIMIT,
        multilineWidgetSize)
    importPlaceSVButton(globalVars)
    addSeparator()
    if noExportOption then
        imgui.Text("No export option")
        return
    end
    if not isSpecialPlaceType then
        imgui.Text("Copy + paste exported data somewhere safe")
        imgui.InputTextMultiline("##customSVExport", globalVars.exportCustomSVData,
            #globalVars.exportCustomSVData, multilineWidgetSize,
            imgui_input_text_flags.ReadOnly)
        exportCustomSVButton(globalVars, menuVars)
        addSeparator()
    end
    if not isComboType then
        imgui.Text("Copy + paste exported data somewhere safe")
        imgui.InputTextMultiline("##placeExport", globalVars.exportData, #globalVars.exportData,
            multilineWidgetSize, imgui_input_text_flags.ReadOnly)
        exportPlaceSVButton(globalVars, menuVars, settingVars)
    end
end
function hermiteSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
function linearSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    if (settingVars.startSV < 0 and settingVars.endSV > 0 and math.abs(settingVars.startSV / settingVars.endSV) < 5) then
        height = state.GetValue("JumpHeight") or 0
        if settingsChanged then
            linearSet = generateLinearSet(settingVars.startSV, settingVars.endSV, settingVars.svPoints + 1)
            local sum = 0
            for i = 1, #linearSet - 1 do
                if (linearSet[i] >= 0) then break end
                sum = sum - linearSet[i] / settingVars.svPoints
            end
            height = sum
            state.SetValue("JumpHeight", sum)
        end
        imgui.TextColored(vector.New(1, 0, 0, 1), "Jump detected. The maximum \nheight of the jump is " .. height .. "x.")
    end
    return settingsChanged
end
function randomSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    local settingsChanged = false
    settingsChanged = chooseRandomType(settingVars) or settingsChanged
    settingsChanged = chooseRandomScale(settingVars) or settingsChanged
    settingsChanged = chooseSVPoints(settingVars, svPointsForce) or settingsChanged
    if imgui.Button("Generate New Random Set", BEEG_BUTTON_SIZE) then
        generateRandomSetMenuSVs(settingVars)
        settingsChanged = true
    end
    addSeparator()
    settingsChanged = chooseConstantShift(settingVars, 0) or settingsChanged
    if not settingVars.dontNormalize then
        settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    end
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    settingsChanged = chooseNoNormalize(settingVars) or settingsChanged
    return settingsChanged
end
function generateRandomSetMenuSVs(settingVars)
    local randomType = RANDOM_TYPES[settingVars.randomTypeIndex]
    settingVars.svMultipliers = generateRandomSet(settingVars.svPoints + 1, randomType,
        settingVars.randomScale)
end
function sinusoidalSettingsMenu(settingVars, skipFinalSV, _)
    local settingsChanged = false
    imgui.Text("Amplitude:")
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseCurveSharpness(settingVars) or settingsChanged
    settingsChanged = chooseConstantShift(settingVars, 1) or settingsChanged
    settingsChanged = chooseNumPeriods(settingVars) or settingsChanged
    settingsChanged = choosePeriodShift(settingVars) or settingsChanged
    settingsChanged = chooseSVPerQuarterPeriod(settingVars) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, skipFinalSV) or settingsChanged
    return settingsChanged
end
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
            settingVars.x1 = values.x
            settingVars.y1 = values.y
            settingVars.x2 = values.z
            settingVars.y2 = values.w
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
function checkEnoughSelectedNotes(minimumNotes)
    if minimumNotes == 0 then return true end
    local selectedNotes = state.SelectedHitObjects
    local numSelectedNotes = #selectedNotes
    if numSelectedNotes == 0 then return false end
    if minimumNotes == 1 then return true end
    if numSelectedNotes > map.GetKeyCount() then return true end
    return selectedNotes[1].StartTime ~= selectedNotes[numSelectedNotes].StartTime
end
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
function adjustNumberOfMultipliers(settingVars)
    if settingVars.svPoints > #settingVars.svMultipliers then
        local difference = settingVars.svPoints - #settingVars.svMultipliers
        for _ = 1, difference do
            table.insert(settingVars.svMultipliers, 1)
        end
    end
    if settingVars.svPoints >= #settingVars.svMultipliers then return end
    if settingVars.selectedMultiplierIndex > settingVars.svPoints then
        settingVars.selectedMultiplierIndex = settingVars.svPoints
    end
    local difference = #settingVars.svMultipliers - settingVars.svPoints
    for _ = 1, difference do
        table.remove(settingVars.svMultipliers)
    end
end
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
    for _, hitObject in pairs(state.SelectedHitObjects) do
        local lane = hitObject.Lane
        local time = hitObject.StartTime
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
function addSelectedNoteTimesToList(menuVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(menuVars.noteTimes, hitObject.StartTime)
    end
    menuVars.noteTimes = table.dedupe(menuVars.noteTimes)
    menuVars.noteTimes = sort(menuVars.noteTimes, sortAscending)
end
function showSettingsMenu(currentSVType, settingVars, skipFinalSV, svPointsForce)
    if currentSVType == "Linear" then
        return linearSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Exponential" then
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
function addOrClearNoteTimes(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes2 .. " note times assigned for 2nd scroll")
    local buttonText = "Assign selected note times to 2nd scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes, nil, settingVars)
    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 2nd scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes2 = {}
end
function addOrClearNoteTimes2(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes3 .. " note times assigned for 3rd scroll")
    local buttonText = "Assign selected note times to 3rd scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes2, nil, settingVars)
    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 3rd scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes3 = {}
end
function addOrClearNoteTimes3(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes4 .. " note times assigned for 4th scroll")
    local buttonText = "Assign selected note times to 4th scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes3, nil, settingVars)
    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 4th scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes4 = {}
end
function addSelectedNoteTimes(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes2, hitObject.StartTime)
    end
    settingVars.noteTimes2 = table.dedupe(settingVars.noteTimes2)
    settingVars.noteTimes2 = sort(settingVars.noteTimes2, sortAscending)
end
function addSelectedNoteTimes2(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes3, hitObject.StartTime)
    end
    settingVars.noteTimes3 = table.dedupe(settingVars.noteTimes3)
    settingVars.noteTimes3 = sort(settingVars.noteTimes3, sortAscending)
end
function addSelectedNoteTimes3(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes4, hitObject.StartTime)
    end
    settingVars.noteTimes4 = table.dedupe(settingVars.noteTimes4)
    settingVars.noteTimes4 = sort(settingVars.noteTimes4, sortAscending)
end
function clearNoteTimesButton(menuVars)
    if not imgui.Button("Clear all assigned note times", BEEG_BUTTON_SIZE) then return end
    menuVars.noteTimes = {}
end
function addNoteTimesToDynamicScaleButton(menuVars)
    local buttonText = "Assign selected note times"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimesToList, nil, menuVars)
end
function removeSelectedFrameTimeButton(settingVars)
    if #settingVars.frameTimes == 0 then return end
    if not imgui.Button("Removed currently selected time", BEEG_BUTTON_SIZE) then return end
    table.remove(settingVars.frameTimes, settingVars.selectedTimeIndex)
    local maxIndex = math.max(1, #settingVars.frameTimes)
    settingVars.selectedTimeIndex = math.clamp(settingVars.selectedTimeIndex, 1, maxIndex)
end
function buttonPlaceScrollSVs(svList, buttonText)
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    local svsToAdd = svList
    local startOffset = svsToAdd[1].StartTime
    local extraOffset = 1 / 128
    local endOffset = svsToAdd[#svsToAdd].StartTime + extraOffset
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
function buttonsForSVsInScroll1(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll1 .. " SVs assigned for 1st scroll")
    local function addFirstScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 1st scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if (not offsets) then return end
        if #offsets < 2 then return end
        settingVars.svsInScroll1 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addFirstScrollSVs(settingVars)
        return
    end
    buttonClear1stScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll1, "Re-place assigned\n1st scroll SVs")
end
function buttonsForSVsInScroll2(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll2 .. " SVs assigned for 2nd scroll")
    local function addSecondScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 2nd scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if (not offsets) then return end
        if #offsets < 2 then return end
        settingVars.svsInScroll2 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addSecondScrollSVs(settingVars)
        return
    end
    buttonClear2ndScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll2, "Re-place assigned\n2nd scroll SVs")
end
function buttonsForSVsInScroll3(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll3 .. " SVs assigned for 3rd scroll")
    local function addThirdScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 3rd scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if (not offsets) then return end
        if #offsets < 2 then return end
        settingVars.svsInScroll3 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addThirdScrollSVs(settingVars)
        return
    end
    buttonClear3rdScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll3, "Re-place assigned\n3rd scroll SVs")
end
function buttonsForSVsInScroll4(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll4 .. " SVs assigned for 4th scroll")
    local function addFourthScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 4th scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if (not offsets) then return end
        if #offsets < 2 then return end
        settingVars.svsInScroll4 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addFourthScrollSVs(settingVars)
        return
    end
    buttonClear4thScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll4, "Re-place assigned\n4th scroll SVs")
end
function buttonClear1stScrollSVs(settingVars)
    local buttonText = "Clear assigned\n 1st scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll1 = {}
end
function buttonClear2ndScrollSVs(settingVars)
    local buttonText = "Clear assigned\n2nd scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll2 = {}
end
function buttonClear3rdScrollSVs(settingVars)
    local buttonText = "Clear assigned\n3rd scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll3 = {}
end
function buttonClear4thScrollSVs(settingVars)
    local buttonText = "Clear assigned\n4th scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll4 = {}
end
function exportImportSettingsButton(globalVars)
    local buttonText = ": )"
    if globalVars.showExportImportMenu then buttonText = "X" end
    local buttonPressed = imgui.Button(buttonText, EXPORT_BUTTON_SIZE)
    toolTip("Export and import menu settings")
    imgui.SameLine(0, SAMELINE_SPACING)
    if not buttonPressed then return end
    globalVars.showExportImportMenu = not globalVars.showExportImportMenu
end
function updateSVStats(svGraphStats, svStats, svMultipliers, svMultipliersNoEndSV, svDistances)
    updateGraphStats(svGraphStats, svMultipliers, svDistances)
    svStats.minSV = math.round(calculateMinValue(svMultipliersNoEndSV), 2)
    svStats.maxSV = math.round(calculateMaxValue(svMultipliersNoEndSV), 2)
    svStats.avgSV = math.round(table.average(svMultipliersNoEndSV, true), 3)
end
function updateGraphStats(graphStats, svMultipliers, svDistances)
    graphStats.minScale, graphStats.maxScale = calculatePlotScale(svMultipliers)
    graphStats.distMinScale, graphStats.distMaxScale = calculatePlotScale(svDistances)
end
function makeSVInfoWindow(windowText, svGraphStats, svStats, svDistances, svMultipliers,
                          stutterDuration, skipDistGraph)
    imgui.Begin(windowText, imgui_window_flags.AlwaysAutoResize)
    if not skipDistGraph then
        imgui.Text("Projected Note Motion:")
        helpMarker("Distance vs Time graph of notes")
        plotSVMotion(svDistances, svGraphStats.distMinScale, svGraphStats.distMaxScale)
        if imgui.CollapsingHeader("New All -w-") then
            for i = 1, #svDistances do
                local svDistance = svDistances[i]
                local content = tostring(svDistance)
                imgui.PushItemWidth(imgui.GetContentRegionAvailWidth())
                imgui.InputText("##" .. i, content, #content, imgui_input_text_flags.AutoSelectAll)
                imgui.PopItemWidth()
            end
        end
    end
    local projectedText = "Projected SVs:"
    if skipDistGraph then projectedText = "Projected Scaling (Avg SVs):" end
    imgui.Text(projectedText)
    plotSVs(svMultipliers, svGraphStats.minScale, svGraphStats.maxScale)
    if stutterDuration then
        displayStutterSVStats(svMultipliers, stutterDuration)
    else
        displaySVStats(svStats)
    end
    imgui.End()
end
function displayStutterSVStats(svMultipliers, stutterDuration)
    local firstSV = math.round(svMultipliers[1], 3)
    local secondSV = math.round(svMultipliers[2], 3)
    local firstDuration = stutterDuration
    local secondDuration = 100 - stutterDuration
    imgui.Columns(2, "SV Stutter Stats", false)
    imgui.Text("First SV:")
    imgui.Text("Second SV:")
    imgui.NextColumn()
    local firstText = table.concat({ firstSV, "x  (", firstDuration, "%% duration)" })
    local secondText = table.concat({ secondSV, "x  (", secondDuration, "%% duration)" })
    imgui.Text(firstText)
    imgui.Text(secondText)
    imgui.Columns(1)
end
function displaySVStats(svStats)
    imgui.Columns(2, "SV Stats", false)
    imgui.Text("Max SV:")
    imgui.Text("Min SV:")
    imgui.Text("Average SV:")
    imgui.NextColumn()
    imgui.Text(svStats.maxSV .. "x")
    imgui.Text(svStats.minSV .. "x")
    imgui.Text(svStats.avgSV .. "x")
    helpMarker("Rounded to 3 decimal places")
    imgui.Columns(1)
end
function startNextWindowNotCollapsed(windowName)
    if state.GetValue(windowName) then return end
    imgui.SetNextWindowCollapsed(false)
    state.SetValue(windowName, true)
end
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
function drawCapybara(globalVars)
    if not globalVars.drawCapybara then return end
    local o = imgui.GetOverlayDrawList()
    local sz = state.WindowSize
    local headWidth = 50
    local headRadius = 20
    local eyeWidth = 10
    local eyeRadius = 3
    local earRadius = 12
    local headCoords1 = relativePoint(sz, -100, -100)
    local headCoords2 = relativePoint(headCoords1, -headWidth, 0)
    local eyeCoords1 = relativePoint(headCoords1, -10, -10)
    local eyeCoords2 = relativePoint(eyeCoords1, -eyeWidth, 0)
    local earCoords = relativePoint(headCoords1, 12, -headRadius + 5)
    local stemCoords = relativePoint(headCoords1, 50, -headRadius + 5)
    local bodyColor = rgbaToUint(122, 70, 212, 255)
    local eyeColor = rgbaToUint(30, 20, 35, 255)
    local earColor = rgbaToUint(62, 10, 145, 255)
    local stemColor = rgbaToUint(0, 255, 0, 255)
    o.AddCircleFilled(earCoords, earRadius, earColor)
    drawHorizontalPillShape(o, headCoords1, headCoords2, headRadius, bodyColor, 12)
    drawHorizontalPillShape(o, eyeCoords1, eyeCoords2, eyeRadius, eyeColor, 12)
    o.AddRectFilled(sz, headCoords1, bodyColor)
    o.AddRectFilled(vector.New(stemCoords[1], stemCoords[2]), { stemCoords[1] + 10, stemCoords[2] + 20 }, stemColor)
    o.AddRectFilled({ stemCoords[1] - 10, stemCoords[2] }, { stemCoords[1] + 20, stemCoords[2] - 5 }, stemColor)
end
function drawCapybara2(globalVars)
    if not globalVars.drawCapybara2 then return end
    local o = imgui.GetOverlayDrawList()
    local sz = state.WindowSize
    local topLeftCapyPoint = { 0, sz[2] - 165 }
    local p1 = relativePoint(topLeftCapyPoint, 0, 95)
    local p2 = relativePoint(topLeftCapyPoint, 0, 165)
    local p3 = relativePoint(topLeftCapyPoint, 58, 82)
    local p3b = relativePoint(topLeftCapyPoint, 108, 82)
    local p4 = relativePoint(topLeftCapyPoint, 58, 165)
    local p5 = relativePoint(topLeftCapyPoint, 66, 29)
    local p6 = relativePoint(topLeftCapyPoint, 105, 10)
    local p7 = relativePoint(topLeftCapyPoint, 122, 126)
    local p7b = relativePoint(topLeftCapyPoint, 133, 107)
    local p8 = relativePoint(topLeftCapyPoint, 138, 11)
    local p9 = relativePoint(topLeftCapyPoint, 145, 82)
    local p10 = relativePoint(topLeftCapyPoint, 167, 82)
    local p10b = relativePoint(topLeftCapyPoint, 172, 80)
    local p11 = relativePoint(topLeftCapyPoint, 172, 50)
    local p12 = relativePoint(topLeftCapyPoint, 179, 76)
    local p12b = relativePoint(topLeftCapyPoint, 176, 78)
    local p12c = relativePoint(topLeftCapyPoint, 176, 70)
    local p13 = relativePoint(topLeftCapyPoint, 185, 50)
    local p14 = relativePoint(topLeftCapyPoint, 113, 10)
    local p15 = relativePoint(topLeftCapyPoint, 116, 0)
    local p16 = relativePoint(topLeftCapyPoint, 125, 2)
    local p17 = relativePoint(topLeftCapyPoint, 129, 11)
    local p17b = relativePoint(topLeftCapyPoint, 125, 11)
    local p18 = relativePoint(topLeftCapyPoint, 91, 0)
    local p19 = relativePoint(topLeftCapyPoint, 97, 0)
    local p20 = relativePoint(topLeftCapyPoint, 102, 1)
    local p21 = relativePoint(topLeftCapyPoint, 107, 11)
    local p22 = relativePoint(topLeftCapyPoint, 107, 19)
    local p23 = relativePoint(topLeftCapyPoint, 103, 24)
    local p24 = relativePoint(topLeftCapyPoint, 94, 17)
    local p25 = relativePoint(topLeftCapyPoint, 88, 9)
    local p26 = relativePoint(topLeftCapyPoint, 123, 33)
    local p27 = relativePoint(topLeftCapyPoint, 132, 30)
    local p28 = relativePoint(topLeftCapyPoint, 138, 38)
    local p29 = relativePoint(topLeftCapyPoint, 128, 40)
    local p30 = relativePoint(topLeftCapyPoint, 102, 133)
    local p31 = relativePoint(topLeftCapyPoint, 105, 165)
    local p32 = relativePoint(topLeftCapyPoint, 113, 165)
    local p33 = relativePoint(topLeftCapyPoint, 102, 131)
    local p34 = relativePoint(topLeftCapyPoint, 82, 138)
    local p35 = relativePoint(topLeftCapyPoint, 85, 165)
    local p36 = relativePoint(topLeftCapyPoint, 93, 165)
    local p37 = relativePoint(topLeftCapyPoint, 50, 80)
    local p38 = relativePoint(topLeftCapyPoint, 80, 40)
    local p39 = relativePoint(topLeftCapyPoint, 115, 30)
    local p40 = relativePoint(topLeftCapyPoint, 40, 92)
    local p41 = relativePoint(topLeftCapyPoint, 80, 53)
    local p42 = relativePoint(topLeftCapyPoint, 107, 43)
    local p43 = relativePoint(topLeftCapyPoint, 40, 104)
    local p44 = relativePoint(topLeftCapyPoint, 70, 56)
    local p45 = relativePoint(topLeftCapyPoint, 100, 53)
    local p46 = relativePoint(topLeftCapyPoint, 45, 134)
    local p47 = relativePoint(topLeftCapyPoint, 50, 80)
    local p48 = relativePoint(topLeftCapyPoint, 70, 87)
    local p49 = relativePoint(topLeftCapyPoint, 54, 104)
    local p50 = relativePoint(topLeftCapyPoint, 50, 156)
    local p51 = relativePoint(topLeftCapyPoint, 79, 113)
    local p52 = relativePoint(topLeftCapyPoint, 55, 24)
    local p53 = relativePoint(topLeftCapyPoint, 85, 25)
    local p54 = relativePoint(topLeftCapyPoint, 91, 16)
    local p55 = relativePoint(topLeftCapyPoint, 45, 33)
    local p56 = relativePoint(topLeftCapyPoint, 75, 36)
    local p57 = relativePoint(topLeftCapyPoint, 81, 22)
    local p58 = relativePoint(topLeftCapyPoint, 45, 43)
    local p59 = relativePoint(topLeftCapyPoint, 73, 38)
    local p60 = relativePoint(topLeftCapyPoint, 61, 32)
    local p61 = relativePoint(topLeftCapyPoint, 33, 55)
    local p62 = relativePoint(topLeftCapyPoint, 73, 45)
    local p63 = relativePoint(topLeftCapyPoint, 55, 36)
    local p64 = relativePoint(topLeftCapyPoint, 32, 95)
    local p65 = relativePoint(topLeftCapyPoint, 53, 42)
    local p66 = relativePoint(topLeftCapyPoint, 15, 75)
    local p67 = relativePoint(topLeftCapyPoint, 0, 125)
    local p68 = relativePoint(topLeftCapyPoint, 53, 62)
    local p69 = relativePoint(topLeftCapyPoint, 0, 85)
    local p70 = relativePoint(topLeftCapyPoint, 0, 165)
    local p71 = relativePoint(topLeftCapyPoint, 29, 112)
    local p72 = relativePoint(topLeftCapyPoint, 0, 105)
    local p73 = relativePoint(topLeftCapyPoint, 73, 70)
    local p74 = relativePoint(topLeftCapyPoint, 80, 74)
    local p75 = relativePoint(topLeftCapyPoint, 92, 64)
    local p76 = relativePoint(topLeftCapyPoint, 60, 103)
    local p77 = relativePoint(topLeftCapyPoint, 67, 83)
    local p78 = relativePoint(topLeftCapyPoint, 89, 74)
    local p79 = relativePoint(topLeftCapyPoint, 53, 138)
    local p80 = relativePoint(topLeftCapyPoint, 48, 120)
    local p81 = relativePoint(topLeftCapyPoint, 73, 120)
    local p82 = relativePoint(topLeftCapyPoint, 46, 128)
    local p83 = relativePoint(topLeftCapyPoint, 48, 165)
    local p84 = relativePoint(topLeftCapyPoint, 74, 150)
    local p85 = relativePoint(topLeftCapyPoint, 61, 128)
    local p86 = relativePoint(topLeftCapyPoint, 83, 100)
    local p87 = relativePoint(topLeftCapyPoint, 90, 143)
    local p88 = relativePoint(topLeftCapyPoint, 73, 143)
    local p89 = relativePoint(topLeftCapyPoint, 120, 107)
    local p90 = relativePoint(topLeftCapyPoint, 116, 133)
    local p91 = relativePoint(topLeftCapyPoint, 106, 63)
    local p92 = relativePoint(topLeftCapyPoint, 126, 73)
    local p93 = relativePoint(topLeftCapyPoint, 127, 53)
    local p94 = relativePoint(topLeftCapyPoint, 91, 98)
    local p95 = relativePoint(topLeftCapyPoint, 101, 76)
    local p96 = relativePoint(topLeftCapyPoint, 114, 99)
    local p97 = relativePoint(topLeftCapyPoint, 126, 63)
    local p98 = relativePoint(topLeftCapyPoint, 156, 73)
    local p99 = relativePoint(topLeftCapyPoint, 127, 53)
    local color1 = rgbaToUint(250, 250, 225, 255)
    local color2 = rgbaToUint(240, 180, 140, 255)
    local color3 = rgbaToUint(195, 90, 120, 255)
    local color4 = rgbaToUint(115, 5, 65, 255)
    local color5 = rgbaToUint(100, 5, 45, 255)
    local color6 = rgbaToUint(200, 115, 135, 255)
    local color7 = rgbaToUint(175, 10, 70, 255)
    local color8 = rgbaToUint(200, 90, 110, 255)
    local color9 = rgbaToUint(125, 10, 75, 255)
    local color10 = rgbaToUint(220, 130, 125, 255)
    o.AddQuadFilled(p18, p19, p24, p25, color4)
    o.AddQuadFilled(p19, p20, p21, p22, color1)
    o.AddQuadFilled(p19, p22, p23, p24, color4)
    o.AddQuadFilled(p14, p15, p16, p17, color4)
    o.AddTriangleFilled(p17b, p16, p17, color1)
    o.AddQuadFilled(p1, p2, p4, p3, color3)
    o.AddQuadFilled(p1, p3, p6, p5, color3)
    o.AddQuadFilled(p3, p4, p7, p9, color2)
    o.AddQuadFilled(p3, p6, p11, p10, color2)
    o.AddQuadFilled(p6, p8, p13, p11, color1)
    o.AddQuadFilled(p13, p12, p10, p11, color6)
    o.AddTriangleFilled(p10b, p12b, p12c, color7)
    o.AddTriangleFilled(p9, p7b, p3b, color8)
    o.AddQuadFilled(p26, p27, p28, p29, color5)
    o.AddQuadFilled(p7, p30, p31, p32, color5)
    o.AddQuadFilled(p33, p34, p35, p36, color5)
    o.AddTriangleFilled(p37, p38, p39, color8)
    o.AddTriangleFilled(p40, p41, p42, color8)
    o.AddTriangleFilled(p43, p44, p45, color8)
    o.AddTriangleFilled(p46, p47, p48, color8)
    o.AddTriangleFilled(p49, p50, p51, color2)
    o.AddTriangleFilled(p52, p53, p54, color9)
    o.AddTriangleFilled(p55, p56, p57, color9)
    o.AddTriangleFilled(p58, p59, p60, color9)
    o.AddTriangleFilled(p61, p62, p63, color9)
    o.AddTriangleFilled(p64, p65, p66, color9)
    o.AddTriangleFilled(p67, p68, p69, color9)
    o.AddTriangleFilled(p70, p71, p72, color9)
    o.AddTriangleFilled(p73, p74, p75, color10)
    o.AddTriangleFilled(p76, p77, p78, color10)
    o.AddTriangleFilled(p79, p80, p81, color10)
    o.AddTriangleFilled(p82, p83, p84, color10)
    o.AddTriangleFilled(p85, p86, p87, color10)
    o.AddTriangleFilled(p88, p89, p90, color10)
    o.AddTriangleFilled(p91, p92, p93, color10)
    o.AddTriangleFilled(p94, p95, p96, color10)
    o.AddTriangleFilled(p97, p98, p99, color10)
end
function drawCapybara312(globalVars)
    if not globalVars.drawCapybara312 then return end
    local o = imgui.GetOverlayDrawList()
    local rgbColors = getCurrentRGBColors(globalVars.rgbPeriod)
    local redRounded = math.round(255 * rgbColors.red, 0)
    local greenRounded = math.round(255 * rgbColors.green, 0)
    local blueRounded = math.round(255 * rgbColors.blue, 0)
    local outlineColor = rgbaToUint(redRounded, greenRounded, blueRounded, 255)
    local p1 = vector.New(42, 32)
    local p2 = vector.New(100, 78)
    local p3 = vector.New(141, 32)
    local p4 = vector.New(83, 63)
    local p5 = vector.New(83, 78)
    local p6 = vector.New(70, 82)
    local p7 = vector.New(85, 88)
    local hairlineThickness = 1
    o.AddTriangleFilled(p1, p2, p3, outlineColor)
    o.AddTriangleFilled(p1, p4, p5, outlineColor)
    o.AddLine(p5, p6, outlineColor, hairlineThickness)
    o.AddLine(p6, p7, outlineColor, hairlineThickness)
    local p8 = vector.New(21, 109)
    local p9 = vector.New(0, 99)
    local p10 = vector.New(16, 121)
    local p11 = vector.New(5, 132)
    local p12 = vector.New(162, 109)
    local p13 = vector.New(183, 99)
    local p14 = vector.New(167, 121)
    local p15 = vector.New(178, 132)
    o.AddTriangleFilled(p1, p8, p9, outlineColor)
    o.AddTriangleFilled(p9, p10, p11, outlineColor)
    o.AddTriangleFilled(p3, p12, p13, outlineColor)
    o.AddTriangleFilled(p13, p14, p15, outlineColor)
    local p16 = vector.New(25, 139)
    local p17 = vector.New(32, 175)
    local p18 = vector.New(158, 139)
    local p19 = vector.New(151, 175)
    local p20 = vector.New(150, 215)
    o.AddTriangleFilled(p11, p16, p17, outlineColor)
    o.AddTriangleFilled(p15, p18, p19, outlineColor)
    o.AddTriangleFilled(p17, p19, p20, outlineColor)
    local p21 = vector.New(84, 148)
    local p22 = vector.New(88, 156)
    local p23 = vector.New(92, 153)
    local p24 = vector.New(96, 156)
    local p25 = vector.New(100, 148)
    local mouthLineThickness = 2
    o.AddLine(p21, p22, outlineColor, mouthLineThickness)
    o.AddLine(p22, p23, outlineColor, mouthLineThickness)
    o.AddLine(p23, p24, outlineColor, mouthLineThickness)
    o.AddLine(p24, p25, outlineColor, mouthLineThickness)
    local p26 = vector.New(61, 126)
    local p27 = vector.New(122, 126)
    local eyeRadius = 9
    local numSements = 16
    o.AddCircleFilled(p26, eyeRadius, outlineColor, numSements)
    o.AddCircleFilled(p27, eyeRadius, outlineColor, numSements)
end
function setPluginAppearanceColors(colorTheme, rgbPeriod)
    local borderColor = vector4(1)
    if colorTheme == "Classic" then borderColor = setClassicColors() end
    if colorTheme == "Strawberry" then borderColor = setStrawberryColors() end
    if colorTheme == "Amethyst" then borderColor = setAmethystColors() end
    if colorTheme == "Tree" then borderColor = setTreeColors() end
    if colorTheme == "Barbie" then borderColor = setBarbieColors() end
    if colorTheme == "Incognito" then borderColor = setIncognitoColors() end
    if colorTheme == "Incognito + RGB" then borderColor = setIncognitoRGBColors(rgbPeriod) end
    if colorTheme == "Tobi's Glass" then borderColor = setTobiGlassColors() end
    if colorTheme == "Tobi's RGB Glass" then borderColor = setTobiRGBGlassColors(rgbPeriod) end
    if colorTheme == "Glass" then borderColor = setGlassColors() end
    if colorTheme == "Glass + RGB" then borderColor = setGlassRGBColors(rgbPeriod) end
    if colorTheme == "RGB Gamer Mode" then borderColor = setRGBGamerColors(rgbPeriod) end
    if colorTheme == "edom remag BGR" then borderColor = setInvertedRGBGamerColors(rgbPeriod) end
    if colorTheme == "BGR + otingocnI" then borderColor = setInvertedIncognitoRGBColors(rgbPeriod) end
    if colorTheme == "otingocnI" then borderColor = setInvertedIncognitoColors() end
    state.SetValue("global_baseBorderColor", borderColor)
end
function setClassicColors()
    local borderColor = vector.New(0.81, 0.88, 1.00, 0.30)
    imgui.PushStyleColor(imgui_col.WindowBg, vector.New(0.00, 0.00, 0.00, 1.00))
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, vector.New(0.14, 0.24, 0.28, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgHovered, vector.New(0.24, 0.34, 0.38, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgActive, vector.New(0.29, 0.39, 0.43, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBg, vector.New(0.41, 0.48, 0.65, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgActive, vector.New(0.51, 0.58, 0.75, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, vector.New(0.51, 0.58, 0.75, 0.50))
    imgui.PushStyleColor(imgui_col.CheckMark, vector.New(0.81, 0.88, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrab, vector.New(0.56, 0.63, 0.75, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrabActive, vector.New(0.61, 0.68, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.Button, vector.New(0.31, 0.38, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonHovered, vector.New(0.41, 0.48, 0.60, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonActive, vector.New(0.51, 0.58, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.Tab, vector.New(0.31, 0.38, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.TabHovered, vector.New(0.51, 0.58, 0.75, 1.00))
    imgui.PushStyleColor(imgui_col.TabActive, vector.New(0.51, 0.58, 0.75, 1.00))
    imgui.PushStyleColor(imgui_col.Header, vector.New(0.81, 0.88, 1.00, 0.40))
    imgui.PushStyleColor(imgui_col.HeaderHovered, vector.New(0.81, 0.88, 1.00, 0.50))
    imgui.PushStyleColor(imgui_col.HeaderActive, vector.New(0.81, 0.88, 1.00, 0.54))
    imgui.PushStyleColor(imgui_col.Separator, vector.New(0.81, 0.88, 1.00, 0.30))
    imgui.PushStyleColor(imgui_col.Text, vector.New(1.00, 1.00, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.TextSelectedBg, vector.New(0.81, 0.88, 1.00, 0.40))
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, vector.New(0.31, 0.38, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, vector.New(0.41, 0.48, 0.60, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, vector.New(0.51, 0.58, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLines, vector.New(0.61, 0.61, 0.61, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, vector.New(1.00, 0.43, 0.35, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogram, vector.New(0.90, 0.70, 0.00, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, vector.New(1.00, 0.60, 0.00, 1.00))
    return borderColor
end
function setStrawberryColors()
    local borderColor = vector.New(1.00, 0.81, 0.88, 0.30)
    imgui.PushStyleColor(imgui_col.WindowBg, vector.New(0.00, 0.00, 0.00, 1.00))
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, vector.New(0.28, 0.14, 0.24, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgHovered, vector.New(0.38, 0.24, 0.34, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgActive, vector.New(0.43, 0.29, 0.39, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBg, vector.New(0.65, 0.41, 0.48, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgActive, vector.New(0.75, 0.51, 0.58, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, vector.New(0.75, 0.51, 0.58, 0.50))
    imgui.PushStyleColor(imgui_col.CheckMark, vector.New(1.00, 0.81, 0.88, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrab, vector.New(0.75, 0.56, 0.63, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrabActive, vector.New(0.80, 0.61, 0.68, 1.00))
    imgui.PushStyleColor(imgui_col.Button, vector.New(0.50, 0.31, 0.38, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonHovered, vector.New(0.60, 0.41, 0.48, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonActive, vector.New(0.70, 0.51, 0.58, 1.00))
    imgui.PushStyleColor(imgui_col.Tab, vector.New(0.50, 0.31, 0.38, 1.00))
    imgui.PushStyleColor(imgui_col.TabHovered, vector.New(0.75, 0.51, 0.58, 1.00))
    imgui.PushStyleColor(imgui_col.TabActive, vector.New(0.75, 0.51, 0.58, 1.00))
    imgui.PushStyleColor(imgui_col.Header, vector.New(1.00, 0.81, 0.88, 0.40))
    imgui.PushStyleColor(imgui_col.HeaderHovered, vector.New(1.00, 0.81, 0.88, 0.50))
    imgui.PushStyleColor(imgui_col.HeaderActive, vector.New(1.00, 0.81, 0.88, 0.54))
    imgui.PushStyleColor(imgui_col.Separator, vector.New(1.00, 0.81, 0.88, 0.30))
    imgui.PushStyleColor(imgui_col.Text, vector.New(1.00, 1.00, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.TextSelectedBg, vector.New(1.00, 0.81, 0.88, 0.40))
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, vector.New(0.50, 0.31, 0.38, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, vector.New(0.60, 0.41, 0.48, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, vector.New(0.70, 0.51, 0.58, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLines, vector.New(0.61, 0.61, 0.61, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, vector.New(1.00, 0.43, 0.35, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogram, vector.New(0.90, 0.70, 0.00, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, vector.New(1.00, 0.60, 0.00, 1.00))
    return borderColor
end
function setAmethystColors()
    local borderColor = vector.New(0.90, 0.00, 0.81, 0.30)
    imgui.PushStyleColor(imgui_col.WindowBg, vector.New(0.16, 0.00, 0.20, 1.00))
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, vector.New(0.40, 0.20, 0.40, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgHovered, vector.New(0.50, 0.30, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgActive, vector.New(0.55, 0.35, 0.55, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBg, vector.New(0.31, 0.11, 0.35, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgActive, vector.New(0.41, 0.21, 0.45, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, vector.New(0.41, 0.21, 0.45, 0.50))
    imgui.PushStyleColor(imgui_col.CheckMark, vector.New(1.00, 0.80, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrab, vector.New(0.95, 0.75, 0.95, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrabActive, vector.New(1.00, 0.80, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.Button, vector.New(0.60, 0.40, 0.60, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonHovered, vector.New(0.70, 0.50, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonActive, vector.New(0.80, 0.60, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.Tab, vector.New(0.50, 0.30, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.TabHovered, vector.New(0.70, 0.50, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.TabActive, vector.New(0.70, 0.50, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.Header, vector.New(1.00, 0.80, 1.00, 0.40))
    imgui.PushStyleColor(imgui_col.HeaderHovered, vector.New(1.00, 0.80, 1.00, 0.50))
    imgui.PushStyleColor(imgui_col.HeaderActive, vector.New(1.00, 0.80, 1.00, 0.54))
    imgui.PushStyleColor(imgui_col.Separator, vector.New(1.00, 0.80, 1.00, 0.30))
    imgui.PushStyleColor(imgui_col.Text, vector.New(1.00, 1.00, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.TextSelectedBg, vector.New(1.00, 0.80, 1.00, 0.40))
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, vector.New(0.60, 0.40, 0.60, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, vector.New(0.70, 0.50, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, vector.New(0.80, 0.60, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLines, vector.New(1.00, 0.80, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, vector.New(1.00, 0.70, 0.30, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogram, vector.New(1.00, 0.80, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, vector.New(1.00, 0.70, 0.30, 1.00))
    return borderColor
end
function setTreeColors()
    local borderColor = vector.New(0.81, 0.90, 0.00, 0.30)
    imgui.PushStyleColor(imgui_col.WindowBg, vector.New(0.20, 0.16, 0.00, 1.00))
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, vector.New(0.40, 0.40, 0.20, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgHovered, vector.New(0.50, 0.50, 0.30, 1.00))
    imgui.PushStyleColor(imgui_col.FrameBgActive, vector.New(0.55, 0.55, 0.35, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBg, vector.New(0.35, 0.31, 0.11, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgActive, vector.New(0.45, 0.41, 0.21, 1.00))
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, vector.New(0.45, 0.41, 0.21, 0.50))
    imgui.PushStyleColor(imgui_col.CheckMark, vector.New(1.00, 1.00, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrab, vector.New(0.95, 0.95, 0.75, 1.00))
    imgui.PushStyleColor(imgui_col.SliderGrabActive, vector.New(1.00, 1.00, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.Button, vector.New(0.60, 0.60, 0.40, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonHovered, vector.New(0.70, 0.70, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.ButtonActive, vector.New(0.80, 0.80, 0.60, 1.00))
    imgui.PushStyleColor(imgui_col.Tab, vector.New(0.50, 0.50, 0.30, 1.00))
    imgui.PushStyleColor(imgui_col.TabHovered, vector.New(0.70, 0.70, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.TabActive, vector.New(0.70, 0.70, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.Header, vector.New(1.00, 1.00, 0.80, 0.40))
    imgui.PushStyleColor(imgui_col.HeaderHovered, vector.New(1.00, 1.00, 0.80, 0.50))
    imgui.PushStyleColor(imgui_col.HeaderActive, vector.New(1.00, 1.00, 0.80, 0.54))
    imgui.PushStyleColor(imgui_col.Separator, vector.New(1.00, 1.00, 0.80, 0.30))
    imgui.PushStyleColor(imgui_col.Text, vector.New(1.00, 1.00, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.TextSelectedBg, vector.New(1.00, 1.00, 0.80, 0.40))
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, vector.New(0.60, 0.60, 0.40, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, vector.New(0.70, 0.70, 0.50, 1.00))
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, vector.New(0.80, 0.80, 0.60, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLines, vector.New(1.00, 1.00, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, vector.New(0.30, 1.00, 0.70, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogram, vector.New(1.00, 1.00, 0.80, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, vector.New(0.30, 1.00, 0.70, 1.00))
    return borderColor
end
function setBarbieColors()
    local pink = vector.New(0.79, 0.31, 0.55, 1.00)
    local white = vector.New(0.95, 0.85, 0.87, 1.00)
    local blue = vector.New(0.37, 0.64, 0.84, 1.00)
    local pinkTint = vector.New(1.00, 0.86, 0.86, 0.40)
    imgui.PushStyleColor(imgui_col.WindowBg, pink)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, blue)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, pinkTint)
    imgui.PushStyleColor(imgui_col.TitleBg, blue)
    imgui.PushStyleColor(imgui_col.TitleBgActive, blue)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, pink)
    imgui.PushStyleColor(imgui_col.CheckMark, blue)
    imgui.PushStyleColor(imgui_col.SliderGrab, blue)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Button, blue)
    imgui.PushStyleColor(imgui_col.ButtonHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Tab, blue)
    imgui.PushStyleColor(imgui_col.TabHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.TabActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Header, blue)
    imgui.PushStyleColor(imgui_col.HeaderHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, pinkTint)
    imgui.PushStyleColor(imgui_col.Separator, pinkTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, pinkTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, pinkTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, white)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, white)
    imgui.PushStyleColor(imgui_col.PlotLines, pink)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, pinkTint)
    imgui.PushStyleColor(imgui_col.PlotHistogram, pink)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, pinkTint)
    return pinkTint
end
function setIncognitoColors()
    local black = vector.New(0.00, 0.00, 0.00, 1.00)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local grey = vector.New(0.20, 0.20, 0.20, 1.00)
    local whiteTint = vector.New(1.00, 1.00, 1.00, 0.40)
    local red = vector.New(1.00, 0.00, 0.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, black)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, whiteTint)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, black)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Separator, whiteTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, white)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, white)
    imgui.PushStyleColor(imgui_col.PlotLines, white)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, red)
    imgui.PushStyleColor(imgui_col.PlotHistogram, white)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, red)
    return whiteTint
end
function setIncognitoRGBColors(rgbPeriod)
    local black = vector.New(0.00, 0.00, 0.00, 1.00)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local grey = vector.New(0.20, 0.20, 0.20, 1.00)
    local whiteTint = vector.New(1.00, 1.00, 1.00, 0.40)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local rgbColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.8)
    imgui.PushStyleColor(imgui_col.WindowBg, black)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, rgbColor)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, black)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Separator, rgbColor)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, rgbColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, white)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotLines, white)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotHistogram, white)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, rgbColor)
    return rgbColor
end
function setTobiGlassColors()
    local transparentBlack = vector.New(0.00, 0.00, 0.00, 0.70)
    local transparentWhite = vector.New(0.30, 0.30, 0.30, 0.50)
    local whiteTint = vector.New(1.00, 1.00, 1.00, 0.30)
    local buttonColor = vector.New(0.14, 0.24, 0.28, 0.80)
    local frameColor = vector.New(0.24, 0.34, 0.38, 1.00)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, buttonColor)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, whiteTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparentBlack)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, frameColor)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, buttonColor)
    imgui.PushStyleColor(imgui_col.Button, buttonColor)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Tab, transparentBlack)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Header, transparentBlack)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Separator, whiteTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotLines, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotHistogram, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, transparentWhite)
    return frameColor
end
function setTobiRGBGlassColors(rgbPeriod)
    local transparent = vector.New(0.00, 0.00, 0.00, 0.85)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.8)
    local colorTint = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.3)
    imgui.PushStyleColor(imgui_col.WindowBg, transparent)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, transparent)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, colorTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, colorTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparent)
    imgui.PushStyleColor(imgui_col.CheckMark, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrab, colorTint)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Button, transparent)
    imgui.PushStyleColor(imgui_col.ButtonHovered, colorTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, colorTint)
    imgui.PushStyleColor(imgui_col.Tab, transparent)
    imgui.PushStyleColor(imgui_col.TabHovered, colorTint)
    imgui.PushStyleColor(imgui_col.TabActive, colorTint)
    imgui.PushStyleColor(imgui_col.Header, transparent)
    imgui.PushStyleColor(imgui_col.HeaderHovered, colorTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, colorTint)
    imgui.PushStyleColor(imgui_col.Separator, colorTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, colorTint)
    imgui.PushStyleColor(imgui_col.PlotHistogram, activeColor)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, colorTint)
    return activeColor
end
function setGlassColors()
    local transparentBlack = vector.New(0.00, 0.00, 0.00, 0.25)
    local transparentWhite = vector.New(1.00, 1.00, 1.00, 0.70)
    local whiteTint = vector.New(1.00, 1.00, 1.00, 0.30)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, whiteTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparentBlack)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparentBlack)
    imgui.PushStyleColor(imgui_col.CheckMark, transparentWhite)
    imgui.PushStyleColor(imgui_col.SliderGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, transparentWhite)
    imgui.PushStyleColor(imgui_col.Button, transparentBlack)
    imgui.PushStyleColor(imgui_col.ButtonHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Tab, transparentBlack)
    imgui.PushStyleColor(imgui_col.TabHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.TabActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Header, transparentBlack)
    imgui.PushStyleColor(imgui_col.HeaderHovered, whiteTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, whiteTint)
    imgui.PushStyleColor(imgui_col.Separator, whiteTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, whiteTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotLines, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, transparentWhite)
    imgui.PushStyleColor(imgui_col.PlotHistogram, whiteTint)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, transparentWhite)
    return transparentWhite
end
function setGlassRGBColors(rgbPeriod)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.8)
    local colorTint = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.3)
    local transparent = vector.New(0.00, 0.00, 0.00, 0.25)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, transparent)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, transparent)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, colorTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, colorTint)
    imgui.PushStyleColor(imgui_col.TitleBg, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgActive, transparent)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, transparent)
    imgui.PushStyleColor(imgui_col.CheckMark, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrab, colorTint)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Button, transparent)
    imgui.PushStyleColor(imgui_col.ButtonHovered, colorTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, colorTint)
    imgui.PushStyleColor(imgui_col.Tab, transparent)
    imgui.PushStyleColor(imgui_col.TabHovered, colorTint)
    imgui.PushStyleColor(imgui_col.TabActive, colorTint)
    imgui.PushStyleColor(imgui_col.Header, transparent)
    imgui.PushStyleColor(imgui_col.HeaderHovered, colorTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, colorTint)
    imgui.PushStyleColor(imgui_col.Separator, colorTint)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, colorTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, colorTint)
    imgui.PushStyleColor(imgui_col.PlotHistogram, activeColor)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, colorTint)
    return activeColor
end
function setRGBGamerColors(rgbPeriod)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.8)
    local inactiveColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.5)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local clearWhite = vector.New(1.00, 1.00, 1.00, 0.40)
    local black = vector.New(0.00, 0.00, 0.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, black)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.08, 0.08, 0.08, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, activeColor)
    imgui.PushStyleColor(imgui_col.FrameBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.TitleBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, inactiveColor)
    imgui.PushStyleColor(imgui_col.CheckMark, white)
    imgui.PushStyleColor(imgui_col.SliderGrab, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, white)
    imgui.PushStyleColor(imgui_col.Button, inactiveColor)
    imgui.PushStyleColor(imgui_col.ButtonHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ButtonActive, activeColor)
    imgui.PushStyleColor(imgui_col.Tab, inactiveColor)
    imgui.PushStyleColor(imgui_col.TabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.TabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Header, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderHovered, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderActive, activeColor)
    imgui.PushStyleColor(imgui_col.Separator, inactiveColor)
    imgui.PushStyleColor(imgui_col.Text, white)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, clearWhite)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, inactiveColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, vector.New(0.61, 0.61, 0.61, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, vector.New(1.00, 0.43, 0.35, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogram, vector.New(0.90, 0.70, 0.00, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, vector.New(1.00, 0.60, 0.00, 1.00))
    return inactiveColor
end
function setInvertedRGBGamerColors(rgbPeriod)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local activeColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.8)
    local inactiveColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.5)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local clearBlack = vector.New(0.00, 0.00, 0.00, 0.40)
    local black = vector.New(0.00, 0.00, 0.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, white)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.92, 0.92, 0.92, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, activeColor)
    imgui.PushStyleColor(imgui_col.FrameBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBg, inactiveColor)
    imgui.PushStyleColor(imgui_col.TitleBgActive, activeColor)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, inactiveColor)
    imgui.PushStyleColor(imgui_col.CheckMark, black)
    imgui.PushStyleColor(imgui_col.SliderGrab, activeColor)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, black)
    imgui.PushStyleColor(imgui_col.Button, inactiveColor)
    imgui.PushStyleColor(imgui_col.ButtonHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ButtonActive, activeColor)
    imgui.PushStyleColor(imgui_col.Tab, inactiveColor)
    imgui.PushStyleColor(imgui_col.TabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.TabActive, activeColor)
    imgui.PushStyleColor(imgui_col.Header, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderHovered, inactiveColor)
    imgui.PushStyleColor(imgui_col.HeaderActive, activeColor)
    imgui.PushStyleColor(imgui_col.Separator, inactiveColor)
    imgui.PushStyleColor(imgui_col.Text, black)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, clearBlack)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, inactiveColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, activeColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, activeColor)
    imgui.PushStyleColor(imgui_col.PlotLines, vector.New(0.39, 0.39, 0.39, 1.00))
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, vector.New(0.00, 0.57, 0.65, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogram, vector.New(0.10, 0.30, 1.00, 1.00))
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, vector.New(0.00, 0.40, 1.00, 1.00))
    return inactiveColor
end
function setInvertedIncognitoRGBColors(rgbPeriod)
    local black = vector.New(0.00, 0.00, 0.00, 1.00)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local grey = vector.New(0.80, 0.80, 0.80, 1.00)
    local blackTint = vector.New(0.00, 0.00, 0.00, 0.40)
    local currentRGB = getCurrentRGBColors(rgbPeriod)
    local rgbColor = vector.New(currentRGB.red, currentRGB.green, currentRGB.blue, 0.8)
    imgui.PushStyleColor(imgui_col.WindowBg, white)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.92, 0.92, 0.92, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, blackTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, rgbColor)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, white)
    imgui.PushStyleColor(imgui_col.CheckMark, black)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, blackTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, blackTint)
    imgui.PushStyleColor(imgui_col.TabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, blackTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, rgbColor)
    imgui.PushStyleColor(imgui_col.Separator, rgbColor)
    imgui.PushStyleColor(imgui_col.Text, black)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, rgbColor)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, blackTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, black)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotLines, black)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, rgbColor)
    imgui.PushStyleColor(imgui_col.PlotHistogram, black)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, rgbColor)
    return rgbColor
end
function setInvertedIncognitoColors()
    local black = vector.New(0.00, 0.00, 0.00, 1.00)
    local white = vector.New(1.00, 1.00, 1.00, 1.00)
    local grey = vector.New(0.80, 0.80, 0.80, 1.00)
    local blackTint = vector.New(0.00, 0.00, 0.00, 0.40)
    local notRed = vector.New(0.00, 1.00, 1.00, 1.00)
    imgui.PushStyleColor(imgui_col.WindowBg, white)
    imgui.PushStyleColor(imgui_col.PopupBg, vector.New(0.92, 0.92, 0.92, 0.94))
    imgui.PushStyleColor(imgui_col.FrameBg, grey)
    imgui.PushStyleColor(imgui_col.FrameBgHovered, blackTint)
    imgui.PushStyleColor(imgui_col.FrameBgActive, blackTint)
    imgui.PushStyleColor(imgui_col.TitleBg, grey)
    imgui.PushStyleColor(imgui_col.TitleBgActive, grey)
    imgui.PushStyleColor(imgui_col.TitleBgCollapsed, white)
    imgui.PushStyleColor(imgui_col.CheckMark, black)
    imgui.PushStyleColor(imgui_col.SliderGrab, grey)
    imgui.PushStyleColor(imgui_col.SliderGrabActive, blackTint)
    imgui.PushStyleColor(imgui_col.Button, grey)
    imgui.PushStyleColor(imgui_col.ButtonHovered, blackTint)
    imgui.PushStyleColor(imgui_col.ButtonActive, blackTint)
    imgui.PushStyleColor(imgui_col.Tab, grey)
    imgui.PushStyleColor(imgui_col.TabHovered, blackTint)
    imgui.PushStyleColor(imgui_col.TabActive, blackTint)
    imgui.PushStyleColor(imgui_col.Header, grey)
    imgui.PushStyleColor(imgui_col.HeaderHovered, blackTint)
    imgui.PushStyleColor(imgui_col.HeaderActive, blackTint)
    imgui.PushStyleColor(imgui_col.Separator, blackTint)
    imgui.PushStyleColor(imgui_col.Text, black)
    imgui.PushStyleColor(imgui_col.TextSelectedBg, blackTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrab, blackTint)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabHovered, black)
    imgui.PushStyleColor(imgui_col.ScrollbarGrabActive, black)
    imgui.PushStyleColor(imgui_col.PlotLines, black)
    imgui.PushStyleColor(imgui_col.PlotLinesHovered, notRed)
    imgui.PushStyleColor(imgui_col.PlotHistogram, black)
    imgui.PushStyleColor(imgui_col.PlotHistogramHovered, notRed)
    return blackTint
end
function getCurrentRGBColors(rgbPeriod)
    local currentTime = imgui.GetTime()
    local percentIntoRGBCycle = (currentTime % rgbPeriod) / rgbPeriod
    local stagesElapsed = 6 * percentIntoRGBCycle
    local currentStageNumber = math.floor(stagesElapsed)
    local percentIntoStage = math.clamp(stagesElapsed - currentStageNumber, 0, 1)
    local red = 0
    local green = 0
    local blue = 0
    if currentStageNumber == 0 then
        green = 1 - percentIntoStage
        blue = 1
    elseif currentStageNumber == 1 then
        blue = 1
        red = percentIntoStage
    elseif currentStageNumber == 2 then
        blue = 1 - percentIntoStage
        red = 1
    elseif currentStageNumber == 3 then
        green = percentIntoStage
        red = 1
    elseif currentStageNumber == 4 then
        green = 1
        red = 1 - percentIntoStage
    else
        blue = percentIntoStage
        green = 1
    end
    return { red = red, green = green, blue = blue }
end
function setPluginAppearance(globalVars)
    local colorTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local styleTheme = STYLE_THEMES[globalVars.styleThemeIndex]
    setPluginAppearanceStyles(styleTheme)
    setPluginAppearanceColors(colorTheme, globalVars.rgbPeriod)
end
function setPluginAppearanceStyles(styleTheme)
    local boxedStyle = styleTheme == "Boxed" or
        styleTheme == "Boxed + Border"
    local cornerRoundnessValue = 5
    if boxedStyle then cornerRoundnessValue = 0 end
    local borderedStyle = styleTheme == "Rounded + Border" or
        styleTheme == "Boxed + Border"
    local borderSize = 0
    if borderedStyle then borderSize = 1 end
    imgui.PushStyleVar(imgui_style_var.FrameBorderSize, borderSize)
    imgui.PushStyleVar(imgui_style_var.WindowPadding, vector.New(PADDING_WIDTH, 8))
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushStyleVar(imgui_style_var.ItemSpacing, vector.New(DEFAULT_WIDGET_HEIGHT / 2 - 1, 4))
    imgui.PushStyleVar(imgui_style_var.ItemInnerSpacing, vector.New(SAMELINE_SPACING, 6))
    imgui.PushStyleVar(imgui_style_var.WindowRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.ChildRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.FrameRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.GrabRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.ScrollbarRounding, cornerRoundnessValue)
    imgui.PushStyleVar(imgui_style_var.TabRounding, cornerRoundnessValue)
end
function drawCursorTrail(globalVars)
    local o = imgui.GetOverlayDrawList()
    local m = getCurrentMousePosition()
    local t = imgui.GetTime()
    local sz = state.WindowSize
    local cursorTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if cursorTrail ~= "Dust" then state.SetValue("initializeDustParticles", false) end
    if cursorTrail ~= "Sparkle" then state.SetValue("initializeSparkleParticles", false) end
    if cursorTrail == "None" then return end
    if cursorTrail == "Snake" then drawSnakeTrail(globalVars, o, m, t, sz) end
    if cursorTrail == "Dust" then drawDustTrail(globalVars, o, m, t, sz) end
    if cursorTrail == "Sparkle" then drawSparkleTrail(globalVars, o, m, t, sz) end
end
function drawSnakeTrail(globalVars, o, m, t, _)
    local trailPoints = globalVars.cursorTrailPoints
    local snakeTrailPoints = {}
    initializeSnakeTrailPoints(snakeTrailPoints, m, MAX_CURSOR_TRAIL_POINTS)
    getVariables("snakeTrailPoints", snakeTrailPoints)
    local needTrailUpdate = checkIfFrameChanged(t, globalVars.effectFPS)
    updateSnakeTrailPoints(snakeTrailPoints, needTrailUpdate, m, trailPoints,
        globalVars.snakeSpringConstant)
    saveVariables("snakeTrailPoints", snakeTrailPoints)
    local trailShape = TRAIL_SHAPES[globalVars.cursorTrailShapeIndex]
    renderSnakeTrailPoints(o, m, snakeTrailPoints, trailPoints, globalVars.cursorTrailSize,
        globalVars.cursorTrailGhost, trailShape)
end
function initializeSnakeTrailPoints(snakeTrailPoints, m, trailPoints)
    if state.GetValue("initializeSnakeTrail") then
        for i = 1, trailPoints do
            snakeTrailPoints[i] = {}
        end
        return
    end
    for i = 1, trailPoints do
        snakeTrailPoints[i] = generate2DPoint(m.x, m.y)
    end
    state.SetValue("initializeSnakeTrail", true)
end
function updateSnakeTrailPoints(snakeTrailPoints, needTrailUpdate, m, trailPoints,
                                snakeSpringConstant)
    if not needTrailUpdate then return end
    for i = trailPoints, 1, -1 do
        local currentTrailPoint = snakeTrailPoints[i]
        if i == 1 then
            currentTrailPoint.x = m.x
            currentTrailPoint.y = m.y
        else
            local lastTrailPoint = snakeTrailPoints[i - 1]
            local xChange = lastTrailPoint.x - currentTrailPoint.x
            local yChange = lastTrailPoint.y - currentTrailPoint.y
            currentTrailPoint.x = currentTrailPoint.x + snakeSpringConstant * xChange
            currentTrailPoint.y = currentTrailPoint.y + snakeSpringConstant * yChange
        end
    end
end
function renderSnakeTrailPoints(o, m, snakeTrailPoints, trailPoints, cursorTrailSize,
                                cursorTrailGhost, trailShape)
    for i = 1, trailPoints do
        local point = snakeTrailPoints[i]
        local alpha = 255
        if not cursorTrailGhost then
            alpha = math.floor(255 * (trailPoints - i) / (trailPoints - 1))
        end
        local color = rgbaToUint(255, 255, 255, alpha)
        if trailShape == "Circles" then
            local coords = { point.x, point.y }
            o.AddCircleFilled(coords, cursorTrailSize, color)
        elseif trailShape == "Triangles" then
            drawTriangleTrailPoint(o, m, point, cursorTrailSize, color)
        end
    end
end
function drawTriangleTrailPoint(o, m, point, cursorTrailSize, color)
    local dx = m.x - point.x
    local dy = m.y - point.y
    if dx == 0 and dy == 0 then return end
    local angle = math.pi / 2
    if dx ~= 0 then angle = math.atan(dy / dx) end
    if dx < 0 then angle = angle + math.pi end
    if dx == 0 and dy < 0 then angle = angle + math.pi end
    drawEquilateralTriangle(o, point, cursorTrailSize, angle, color)
end
function drawDustTrail(globalVars, o, m, t, sz)
    local dustSize = math.floor(sz[2] / 120)
    local dustDuration = 0.4
    local numDustParticles = 20
    local dustParticles = {}
    initializeDustParticles(sz, t, dustParticles, numDustParticles, dustDuration)
    getVariables("dustParticles", dustParticles)
    updateDustParticles(t, m, dustParticles, dustDuration, dustSize)
    saveVariables("dustParticles", dustParticles)
    renderDustParticles(globalVars.rgbPeriod, o, t, dustParticles, dustDuration, dustSize)
end
function initializeDustParticles(_, t, dustParticles, numDustParticles, dustDuration)
    if state.GetValue("initializeDustParticles") then
        for i = 1, numDustParticles do
            dustParticles[i] = {}
        end
        return
    end
    for i = 1, numDustParticles do
        local endTime = t + (i / numDustParticles) * dustDuration
        local showParticle = false
        dustParticles[i] = generateParticle(0, 0, 0, 0, endTime, showParticle)
    end
    state.SetValue("initializeDustParticles", true)
    saveVariables("dustParticles", dustParticles)
end
function updateDustParticles(t, m, dustParticles, dustDuration, dustSize)
    local yRange = 8 * dustSize * (math.random() - 0.5)
    local xRange = 8 * dustSize * (math.random() - 0.5)
    for i = 1, #dustParticles do
        local dustParticle = dustParticles[i]
        local timeLeft = dustParticle.endTime - t
        if timeLeft < 0 then
            local endTime = t + dustDuration
            local showParticle = checkIfMouseMoved(getCurrentMousePosition())
            dustParticles[i] = generateParticle(m.x, m.y, xRange, yRange, endTime, showParticle)
        end
    end
end
function renderDustParticles(rgbPeriod, o, t, dustParticles, dustDuration, dustSize)
    local currentRGBColors = getCurrentRGBColors(rgbPeriod)
    local currentRed = math.round(255 * currentRGBColors.red, 0)
    local currentGreen = math.round(255 * currentRGBColors.green, 0)
    local currentBlue = math.round(255 * currentRGBColors.blue, 0)
    for i = 1, #dustParticles do
        local dustParticle = dustParticles[i]
        if dustParticle.showParticle then
            local time = 1 - ((dustParticle.endTime - t) / dustDuration)
            local dustX = dustParticle.x + dustParticle.xRange * time
            local dy = dustParticle.yRange * math.quadraticBezier(0, time)
            local dustY = dustParticle.y + dy
            local dustCoords = vector.New(dustX, dustY)
            local alpha = math.round(255 * (1 - time), 0)
            local dustColor = rgbaToUint(currentRed, currentGreen, currentBlue, alpha)
            o.AddCircleFilled(dustCoords, dustSize, dustColor)
        end
    end
end
function drawSparkleTrail(_, o, m, t, sz)
    local sparkleSize = 10
    local sparkleDuration = 0.3
    local numSparkleParticles = 10
    local sparkleParticles = {}
    initializeSparkleParticles(sz, t, sparkleParticles, numSparkleParticles, sparkleDuration)
    getVariables("sparkleParticles", sparkleParticles)
    updateSparkleParticles(t, m, sparkleParticles, sparkleDuration, sparkleSize)
    saveVariables("sparkleParticles", sparkleParticles)
    renderSparkleParticles(o, t, sparkleParticles, sparkleDuration, sparkleSize)
end
function initializeSparkleParticles(_, t, sparkleParticles, numSparkleParticles, sparkleDuration)
    if state.GetValue("initializeSparkleParticles") then
        for i = 1, numSparkleParticles do
            sparkleParticles[i] = {}
        end
        return
    end
    for i = 1, numSparkleParticles do
        local endTime = t + (i / numSparkleParticles) * sparkleDuration
        local showParticle = false
        sparkleParticles[i] = generateParticle(0, 0, 0, 0, endTime, showParticle)
    end
    state.SetValue("initializeSparkleParticles", true)
    saveVariables("sparkleParticles", sparkleParticles)
end
function updateSparkleParticles(t, m, sparkleParticles, sparkleDuration, sparkleSize)
    for i = 1, #sparkleParticles do
        local sparkleParticle = sparkleParticles[i]
        local timeLeft = sparkleParticle.endTime - t
        if timeLeft < 0 then
            local endTime = t + sparkleDuration
            local showParticle = checkIfMouseMoved(getCurrentMousePosition())
            local randomX = m.x + sparkleSize * 3 * (math.random() - 0.5)
            local randomY = m.y + sparkleSize * 3 * (math.random() - 0.5)
            local yRange = 6 * sparkleSize
            sparkleParticles[i] = generateParticle(randomX, randomY, 0, yRange, endTime,
                showParticle)
        end
    end
end
function renderSparkleParticles(o, t, sparkleParticles, sparkleDuration, sparkleSize)
    for i = 1, #sparkleParticles do
        local sparkleParticle = sparkleParticles[i]
        if sparkleParticle.showParticle then
            local time = 1 - ((sparkleParticle.endTime - t) / sparkleDuration)
            local sparkleX = sparkleParticle.x + sparkleParticle.xRange * time
            local dy = -sparkleParticle.yRange * math.quadraticBezier(0, time)
            local sparkleY = sparkleParticle.y + dy
            local sparkleCoords = vector.New(sparkleX, sparkleY)
            local white = rgbaToUint(255, 255, 255, 255)
            local actualSize = sparkleSize * (1 - math.quadraticBezier(0, time))
            local sparkleColor = rgbaToUint(255, 255, 100, 30)
            drawGlare(o, sparkleCoords, actualSize, white, sparkleColor)
        end
    end
end
function chooseAddComboMultipliers(settingVars)
    local oldValues = vector.New(settingVars.comboMultiplier1, settingVars.comboMultiplier2)
    local _, newValues = imgui.InputFloat2("ax + by", oldValues, "%.2f")
    helpMarker("a = multiplier for SV Type 1, b = multiplier for SV Type 2")
    settingVars.comboMultiplier1 = newValues.x
    settingVars.comboMultiplier2 = newValues.y
    return oldValues ~= newValues
end
function chooseArcPercent(settingVars)
    local oldPercent = settingVars.arcPercent
    local _, newPercent = imgui.SliderInt("Arc Percent", oldPercent, 1, 99, oldPercent .. "%%")
    newPercent = math.clamp(newPercent, 1, 99)
    settingVars.arcPercent = newPercent
    return oldPercent ~= newPercent
end
function chooseAverageSV(menuVars)
    local oldAvg = menuVars.avgSV
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("Neg.", SECONDARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    _, menuVars.avgSV = imgui.InputFloat("Average SV", menuVars.avgSV, 0, 0, "%.2fx")
    imgui.PopItemWidth()
    if ((negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) and menuVars.avgSV ~= 0) then
        menuVars.avgSV = -menuVars.avgSV
    end
    return oldAvg ~= menuVars.avgSV
end
function chooseBezierPoints(settingVars)
    local oldFirstPoint = vector.New(settingVars.x1, settingVars.y1)
    local oldSecondPoint = vector.New(settingVars.x2, settingVars.y2)
    local _, newFirstPoint = imgui.DragFloat2("(x1, y1)", oldFirstPoint, 0.01, -1, 2, "%.2f")
    helpMarker("Coordinates of the first point of the cubic bezier")
    local _, newSecondPoint = imgui.DragFloat2("(x2, y2)", oldSecondPoint, 0.01, -1, 2, "%.2f")
    helpMarker("Coordinates of the second point of the cubic bezier")
    settingVars.x1 = newFirstPoint.x
    settingVars.y1 = newFirstPoint.y
    settingVars.x2 = newSecondPoint.x
    settingVars.y2 = newSecondPoint.y
    settingVars.x1 = math.clamp(settingVars.x1, 0, 1)
    settingVars.y1 = math.clamp(settingVars.y1, -1, 2)
    settingVars.x2 = math.clamp(settingVars.x2, 0, 1)
    settingVars.y2 = math.clamp(settingVars.y2, -1, 2)
    local x1Changed = (oldFirstPoint.x ~= settingVars.x1)
    local y1Changed = (oldFirstPoint.y ~= settingVars.y1)
    local x2Changed = (oldSecondPoint.x ~= settingVars.x2)
    local y2Changed = (oldSecondPoint.y ~= settingVars.y2)
    return x1Changed or y1Changed or x2Changed or y2Changed
end
function chooseChinchillaIntensity(settingVars)
    local oldIntensity = settingVars.chinchillaIntensity
    local _, newIntensity = imgui.SliderFloat("Intensity##chinchilla", oldIntensity, 0, 10, "%.3f")
    helpMarker("Ctrl + click slider to input a specific number")
    settingVars.chinchillaIntensity = math.clamp(newIntensity, 0, 727)
    return oldIntensity ~= settingVars.chinchillaIntensity
end
function chooseChinchillaType(settingVars)
    local oldIndex = settingVars.chinchillaTypeIndex
    settingVars.chinchillaTypeIndex = combo("Chinchilla Type", CHINCHILLA_TYPES, oldIndex)
    return oldIndex ~= settingVars.chinchillaTypeIndex
end
function chooseColorTheme(globalVars)
    local oldColorThemeIndex = globalVars.colorThemeIndex
    globalVars.colorThemeIndex = combo("Color Theme", COLOR_THEMES, globalVars.colorThemeIndex)
    if (oldColorThemeIndex ~= globalVars.colorThemeIndex) then
        write(globalVars)
    end
    local currentTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local isRGBColorTheme = currentTheme == "Tobi's RGB Glass" or
        currentTheme == "Glass + RGB" or
        currentTheme == "Incognito + RGB" or
        currentTheme == "RGB Gamer Mode" or
        currentTheme == "edom remag BGR" or
        currentTheme == "BGR + otingocnI"
    if not isRGBColorTheme then return end
    chooseRGBPeriod(globalVars)
end
function chooseComboPhase(settingVars, maxComboPhase)
    local oldPhase = settingVars.comboPhase
    _, settingVars.comboPhase = imgui.InputInt("Combo Phase", oldPhase, 1, 1)
    settingVars.comboPhase = math.clamp(settingVars.comboPhase, 0, maxComboPhase)
    return oldPhase ~= settingVars.comboPhase
end
function chooseComboSVOption(settingVars, maxComboPhase)
    local oldIndex = settingVars.comboTypeIndex
    settingVars.comboTypeIndex = combo("Combo Type", COMBO_SV_TYPE, settingVars.comboTypeIndex)
    local currentComboType = COMBO_SV_TYPE[settingVars.comboTypeIndex]
    local addTypeChanged = false
    if currentComboType ~= "SV Type 1 Only" and currentComboType ~= "SV Type 2 Only" then
        addTypeChanged = chooseComboPhase(settingVars, maxComboPhase) or addTypeChanged
    end
    if currentComboType == "Add" then
        addTypeChanged = chooseAddComboMultipliers(settingVars) or addTypeChanged
    end
    return (oldIndex ~= settingVars.comboTypeIndex) or addTypeChanged
end
function chooseConstantShift(settingVars, defaultShift)
    local oldShift = settingVars.verticalShift
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local resetButtonPressed = imgui.Button("R", TERTIARY_BUTTON_SIZE)
    if (resetButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[5])) then
        settingVars.verticalShift = defaultShift
    end
    toolTip("Reset vertical shift to initial values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    if negateButtonPressed and settingVars.verticalShift ~= 0 then
        settingVars.verticalShift = -settingVars.verticalShift
    end
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local inputText = "Vertical Shift"
    _, settingVars.verticalShift = imgui.InputFloat(inputText, settingVars.verticalShift, 0, 0, "%.3fx")
    imgui.PopItemWidth()
    return oldShift ~= settingVars.verticalShift
end
function chooseControlSecondSV(settingVars)
    local oldChoice = settingVars.controlLastSV
    local stutterControlsIndex = 1
    if oldChoice then stutterControlsIndex = 2 end
    local newStutterControlsIndex = combo("Control SV", STUTTER_CONTROLS, stutterControlsIndex)
    settingVars.controlLastSV = newStutterControlsIndex == 2
    local choiceChanged = oldChoice ~= settingVars.controlLastSV
    if choiceChanged then settingVars.stutterDuration = 100 - settingVars.stutterDuration end
    return choiceChanged
end
function chooseCurrentFrame(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Previewing frame:")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(35)
    if imgui.ArrowButton("##leftFrame", imgui_dir.Left) then
        settingVars.currentFrame = settingVars.currentFrame - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.currentFrame = imgui.InputInt("##currentFrame", settingVars.currentFrame, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightFrame", imgui_dir.Right) then
        settingVars.currentFrame = settingVars.currentFrame + 1
    end
    settingVars.currentFrame = math.wrap(settingVars.currentFrame, 1, settingVars.numFrames)
    imgui.PopItemWidth()
end
function chooseCursorTrail(globalVars)
    local oldCursorTrailIndex = globalVars.cursorTrailIndex
    globalVars.cursorTrailIndex = combo("Cursor Trail", CURSOR_TRAILS, oldCursorTrailIndex)
    if (oldCursorTrailIndex ~= globalVars.cursorTrailIndex) then
        write(globalVars)
    end
end
function chooseCursorTrailGhost(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local oldCursorTrailGhost = globalVars.cursorTrailGhost
    _, globalVars.cursorTrailGhost = imgui.Checkbox("No Ghost", oldCursorTrailGhost)
    if (oldCursorTrailGhost ~= globalVars.cursorTrailGhost) then
        write(globalVars)
    end
end
function chooseCursorTrailPoints(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local label = "Trail Points"
    local oldCursorTrailPoints = globalVars.cursorTrailPoints
    _, globalVars.cursorTrailPoints = imgui.InputInt(label, oldCursorTrailPoints, 1, 1)
    if (oldCursorTrailPoints ~= globalVars.cursorTrailPoints) then
        write(globalVars)
    end
end
function chooseCursorTrailShape(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local label = "Trail Shape"
    local oldTrailShapeIndex = globalVars.cursorTrailShapeIndex
    globalVars.cursorTrailShapeIndex = combo(label, TRAIL_SHAPES, oldTrailShapeIndex)
    if (oldTrailShapeIndex ~= globalVars.cursorTrailShapeIndex) then
        write(globalVars)
    end
end
function chooseCursorShapeSize(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local label = "Shape Size"
    local oldCursorTrailSize = globalVars.cursorTrailSize
    _, globalVars.cursorTrailSize = imgui.InputInt(label, oldCursorTrailSize, 1, 1)
    if (oldCursorTrailSize ~= globalVars.cursorTrailSize) then
        write(globalVars)
    end
end
function chooseCurveSharpness(settingVars)
    local oldSharpness = settingVars.curveSharpness
    if imgui.Button("Reset##curveSharpness", SECONDARY_BUTTON_SIZE) then
        settingVars.curveSharpness = 50
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newSharpness = imgui.DragInt("Curve Sharpness", settingVars.curveSharpness, 1, 1,
        100, "%d%%")
    imgui.PopItemWidth()
    newSharpness = math.clamp(newSharpness, 1, 100)
    settingVars.curveSharpness = newSharpness
    return oldSharpness ~= newSharpness
end
function chooseCustomMultipliers(settingVars)
    imgui.BeginChild("Custom Multipliers", vector.New(imgui.GetContentRegionAvailWidth(), 90), 1)
    for i = 1, #settingVars.svMultipliers do
        local selectableText = table.concat({ i, " )   ", settingVars.svMultipliers[i] })
        if imgui.Selectable(selectableText, settingVars.selectedMultiplierIndex == i) then
            settingVars.selectedMultiplierIndex = i
        end
    end
    imgui.EndChild()
    local index = settingVars.selectedMultiplierIndex
    local oldMultiplier = settingVars.svMultipliers[index]
    local _, newMultiplier = imgui.InputFloat("SV Multiplier", oldMultiplier, 0, 0, "%.2fx")
    settingVars.svMultipliers[index] = newMultiplier
    return oldMultiplier ~= newMultiplier
end
function chooseDistance(menuVars)
    local oldDistance = menuVars.distance
    menuVars.distance = computableInputFloat("Distance", menuVars.distance, 3, " msx")
    return oldDistance ~= menuVars.distance
end
function chooseVaryingDistance(settingVars)
    if (not settingVars.linearlyChange) then
        settingVars.distance = computableInputFloat("Distance", settingVars.distance, 3, " msx")
        return
    end
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = vector.New(settingVars.distance1, settingVars.distance2)
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.98 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2("Dist.", oldValues, "%.2f msx")
    imgui.PopItemWidth()
    settingVars.distance1 = newValues.x
    settingVars.distance2 = newValues.y
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.distance1 = oldValues.y
        settingVars.distance2 = oldValues.x
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars.distance1 = -oldValues.x
        settingVars.distance2 = -oldValues.y
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end
function chooseEvery(menuVars)
    _, menuVars.every = imgui.InputInt("Every __ notes", menuVars.every)
    menuVars.every = math.clamp(menuVars.every, 1, MAX_SV_POINTS)
end
function chooseOffset(menuVars)
    _, menuVars.offset = imgui.InputInt("From note #__", menuVars.offset)
    menuVars.offset = math.clamp(menuVars.offset, 1, menuVars.every)
end
function chooseSnap(menuVars)
    _, menuVars.snap = imgui.InputInt("Snap", menuVars.snap)
    menuVars.snap = math.clamp(menuVars.snap, 1, 100)
end
function chooseDistanceBack(settingVars)
    _, settingVars.distanceBack = imgui.InputFloat("Split Distance", settingVars.distanceBack,
        0, 0, "%.3f msx")
    helpMarker("Splitscroll distance separating scroll1 and scroll2 planes")
end
function chooseDistanceBack2(settingVars)
    _, settingVars.distanceBack2 = imgui.InputFloat("Split Dist 2", settingVars.distanceBack2,
        0, 0, "%.3f msx")
    helpMarker("Splitscroll distance separating scroll2 and scroll3 planes")
end
function chooseDistanceBack3(settingVars)
    _, settingVars.distanceBack3 = imgui.InputFloat("Split Dist 3", settingVars.distanceBack3,
        0, 0, "%.3f msx")
    helpMarker("Splitscroll distance separating scroll3 and scroll4 planes")
end
function chooseDontReplaceSV(globalVars)
    local label = "Dont replace SVs when placing regular SVs"
    local oldDontReplaceSV = globalVars.dontReplaceSV
    _, globalVars.dontReplaceSV = imgui.Checkbox(label, oldDontReplaceSV)
    if (oldDontReplaceSV ~= globalVars.dontReplaceSV) then
        write(globalVars)
    end
end
function chooseBetaIgnore(globalVars)
    local oldIgnore = globalVars.BETA_IGNORE_NOTES_OUTSIDE_TG
    _, globalVars.BETA_IGNORE_NOTES_OUTSIDE_TG = imgui.Checkbox("Ignore notes outside current timing group",
        oldIgnore)
    if (oldIgnore ~= globalVars.BETA_IGNORE_NOTES_OUTSIDE_TG) then
        write(globalVars)
    end
end
function chooseDrawCapybara(globalVars)
    local oldDrawCapybara = globalVars.drawCapybara
    _, globalVars.drawCapybara = imgui.Checkbox("Capybara", oldDrawCapybara)
    helpMarker("Draws a capybara at the bottom right of the screen")
    if (oldDrawCapybara ~= globalVars.drawCapybara) then
        write(globalVars)
    end
end
function chooseDrawCapybara2(globalVars)
    local oldDrawCapybara2 = globalVars.drawCapybara2
    _, globalVars.drawCapybara2 = imgui.Checkbox("Capybara 2", oldDrawCapybara2)
    helpMarker("Draws a capybara at the bottom left of the screen")
    if (oldDrawCapybara2 ~= globalVars.drawCapybara2) then
        write(globalVars)
    end
end
function chooseDrawCapybara312(globalVars)
    local oldDrawCapybara312 = globalVars.drawCapybara312
    _, globalVars.drawCapybara312 = imgui.Checkbox("Capybara 312", oldDrawCapybara312)
    if (oldDrawCapybara312 ~= globalVars.drawCapybara312) then
        write(globalVars)
    end
    helpMarker("Draws a capybara???!?!??!!!!? AGAIN?!?!")
end
function chooseSelectTool(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Current Type:")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.selectTypeIndex = combo("##selecttool", SELECT_TOOLS, globalVars.selectTypeIndex)
    local selectTool = SELECT_TOOLS[globalVars.selectTypeIndex]
    if selectTool == "Alternating" then toolTip("Skip over notes then select one, and repeat") end
    if selectTool == "By Snap" then toolTip("Select all notes with a certain snap color") end
    if selectTool == "Bookmark" then toolTip("Jump to a bookmark") end
    if selectTool == "Chord Size" then toolTip("Select all notes with a certain chord size") end
end
function chooseEditTool(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("  Current Tool:")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.editToolIndex = combo("##edittool", EDIT_SV_TOOLS, globalVars.editToolIndex)
    local svTool = EDIT_SV_TOOLS[globalVars.editToolIndex]
    if svTool == "Add Teleport" then toolTip("Add a large teleport SV to move far away") end
    if svTool == "Align Timing Lines" then toolTip("Create timing lines at notes to avoid desync") end
    if svTool == "Copy & Paste" then toolTip("Copy SVs and SSFs and paste them somewhere else") end
    if svTool == "Direct SV" then toolTip("Directly update SVs within your selection") end
    if svTool == "Displace Note" then toolTip("Move where notes are hit on the screen") end
    if svTool == "Displace View" then toolTip("Temporarily displace the playfield view") end
    if svTool == "Dynamic Scale" then toolTip("Dynamically scale SVs across notes") end
    if svTool == "Fix LN Ends" then toolTip("Fix flipped LN ends") end
    if svTool == "Flicker" then toolTip("Flash notes on and off the screen") end
    if svTool == "Measure" then toolTip("Get stats about SVs in a section") end
    if svTool == "Merge" then toolTip("Combine SVs that overlap") end
    if svTool == "Reverse Scroll" then toolTip("Reverse the scroll direction using SVs") end
    if svTool == "Scale (Multiply)" then toolTip("Scale SV values by multiplying") end
    if svTool == "Scale (Displace)" then toolTip("Scale SV values by adding teleport SVs") end
    if svTool == "Swap Notes" then toolTip("Swap positions of notes using SVs") end
    if svTool == "Vertical Shift" then toolTip("Adds a constant value to SVs in a range") end
end
function chooseEffectFPS(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local oldEffectFPS = globalVars.effectFPS
    _, globalVars.effectFPS = imgui.InputInt("Effect FPS", oldEffectFPS, 1, 1)
    if (oldEffectFPS ~= globalVars.effectFPS) then
        write(globalVars)
    end
    helpMarker("Set this to a multiple of UPS or FPS to make cursor effects smooth")
    globalVars.effectFPS = math.clamp(globalVars.effectFPS, 2, 1000)
end
function chooseFinalSV(settingVars, skipFinalSV)
    if skipFinalSV then return false end
    local oldIndex = settingVars.finalSVIndex
    local oldCustomSV = settingVars.customSV
    local finalSVType = FINAL_SV_TYPES[settingVars.finalSVIndex]
    if finalSVType ~= "Normal" then
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.35)
        _, settingVars.customSV = imgui.InputFloat("SV", settingVars.customSV, 0, 0, "%.2fx")
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.PopItemWidth()
    else
        imgui.Indent(DEFAULT_WIDGET_WIDTH * 0.35 + 24)
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    settingVars.finalSVIndex = combo("Final SV", FINAL_SV_TYPES, settingVars.finalSVIndex)
    helpMarker("Final SV won't be placed if there's already an SV at the end time")
    if finalSVType == "Normal" then
        imgui.Unindent(DEFAULT_WIDGET_WIDTH * 0.35 + 24)
    end
    imgui.PopItemWidth()
    return (oldIndex ~= settingVars.finalSVIndex) or (oldCustomSV ~= settingVars.customSV)
end
function chooseFirstHeight(settingVars)
    _, settingVars.height1 = imgui.InputFloat("1st Height", settingVars.height1, 0, 0, "%.3f msx")
    helpMarker("Height at which notes are hit at on screen for the 1st scroll speed")
end
function chooseFirstScrollSpeed(settingVars)
    local text = "1st Scroll Speed"
    _, settingVars.scrollSpeed1 = imgui.InputFloat(text, settingVars.scrollSpeed1, 0, 0, "%.2fx")
end
function chooseFlickerType(menuVars)
    menuVars.flickerTypeIndex = combo("Flicker Type", FLICKER_TYPES, menuVars.flickerTypeIndex)
end
function chooseFrameOrder(settingVars)
    local checkBoxText = "Reverse frame order when placing SVs"
    _, settingVars.reverseFrameOrder = imgui.Checkbox(checkBoxText, settingVars.reverseFrameOrder)
end
function chooseFrameSpacing(settingVars)
    _, settingVars.frameDistance = imgui.InputFloat("Frame Spacing", settingVars.frameDistance,
        0, 0, "%.0f msx")
    settingVars.frameDistance = math.clamp(settingVars.frameDistance, 2000, 100000)
end
function chooseFrameTimeData(settingVars)
    if #settingVars.frameTimes == 0 then return end
    local frameTime = settingVars.frameTimes[settingVars.selectedTimeIndex]
    _, frameTime.frame = imgui.InputInt("Frame #", frameTime.frame)
    frameTime.frame = math.clamp(frameTime.frame, 1, settingVars.numFrames)
    _, frameTime.position = imgui.InputInt("Note height", frameTime.position)
end
function chooseIntensity(settingVars)
    local userStepSize = state.GetValue("global_stepSize") or 5
    local totalSteps = math.ceil(100 / userStepSize)
    local oldIntensity = settingVars.intensity
    local stepIndex = math.floor((oldIntensity - 0.01) / userStepSize)
    local _, newStepIndex = imgui.SliderInt(
        "Intensity",
        stepIndex,
        0,
        totalSteps - 1,
        settingVars.intensity .. "%%"
    )
    local newIntensity = newStepIndex * userStepSize + 99 % userStepSize + 1
    settingVars.intensity = math.clamp(newIntensity, 1, 100)
    return oldIntensity ~= settingVars.intensity
end
function chooseInterlace(menuVars)
    local oldInterlace = menuVars.interlace
    _, menuVars.interlace = imgui.Checkbox("Interlace", menuVars.interlace)
    local interlaceChanged = oldInterlace ~= menuVars.interlace
    if not menuVars.interlace then return interlaceChanged end
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    local oldRatio = menuVars.interlaceRatio
    _, menuVars.interlaceRatio = imgui.InputFloat("Ratio##interlace", menuVars.interlaceRatio,
        0, 0, "%.2f")
    imgui.PopItemWidth()
    return interlaceChanged or oldRatio ~= menuVars.interlaceRatio
end
function chooseLinearlyChange(settingVars)
    local oldChoice = settingVars.linearlyChange
    local _, newChoice = imgui.Checkbox("Change stutter over time", oldChoice)
    settingVars.linearlyChange = newChoice
    return oldChoice ~= newChoice
end
function chooseLinearlyChangeDist(settingVars)
    local oldChoice = settingVars.linearlyChange
    local _, newChoice = imgui.Checkbox("Change distance over time", oldChoice)
    settingVars.linearlyChange = newChoice
    return oldChoice ~= newChoice
end
function chooseKeyboardMode(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Plugin Mode:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    local oldKeyboardMode = globalVars.keyboardMode
    if imgui.RadioButton("Default", not globalVars.keyboardMode) then
        globalVars.keyboardMode = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Keyboard", globalVars.keyboardMode) then
        globalVars.keyboardMode = true
    end
    if (oldKeyboardMode ~= globalVars.keyboardMode) then
        write(globalVars)
    end
end
function chooseAdvancedMode(globalVars)
    local oldAdvancedMode = globalVars.advancedMode
    imgui.AlignTextToFramePadding()
    imgui.Text("Advanced Mode:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("OFF", not globalVars.advancedMode) then
        globalVars.advancedMode = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("ON", globalVars.advancedMode) then
        globalVars.advancedMode = true
    end
    if (oldAdvancedMode ~= globalVars.advancedMode) then
        write(globalVars)
        state.SetValue("global_advancedMode", globalVars.advancedMode)
    end
end
function chooseHideAutomatic(globalVars)
    local oldHideAutomatic = globalVars.hideAutomatic
    imgui.AlignTextToFramePadding()
    imgui.Text("Hide Automatic TGs?:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("NO", not globalVars.hideAutomatic) then
        globalVars.hideAutomatic = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("YES", globalVars.hideAutomatic) then
        globalVars.hideAutomatic = true
    end
    if (oldHideAutomatic ~= globalVars.hideAutomatic) then
        write(globalVars)
        state.SetValue("globalVars.hideAutomatic", globalVars.hideAutomatic)
    end
end
function chooseStepSize(globalVars)
    imgui.PushItemWidth(40)
    local oldStepSize = globalVars.stepSize
    local _, tempStepSize = imgui.InputFloat("Exponential Intensity Step Size", oldStepSize, 0, 0, "%.0f %%")
    globalVars.stepSize = math.clamp(tempStepSize, 1, 100)
    imgui.PopItemWidth()
    if (oldStepSize ~= globalVars.stepSize) then
        write(globalVars)
        state.SetValue("global_stepSize", globalVars.stepSize)
    end
end
function chooseMainSV(settingVars)
    local label = "Main SV"
    if settingVars.linearlyChange then label = label .. " (start)" end
    _, settingVars.mainSV = imgui.InputFloat(label, settingVars.mainSV, 0, 0, "%.2fx")
    local helpMarkerText = "This SV will last ~99.99%% of the stutter"
    if not settingVars.linearlyChange then
        helpMarker(helpMarkerText)
        return
    end
    _, settingVars.mainSV2 = imgui.InputFloat("Main SV (end)", settingVars.mainSV2, 0, 0, "%.2fx")
end
function chooseMeasuredStatsView(menuVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("View values:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Rounded", not menuVars.unrounded) then
        menuVars.unrounded = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Unrounded", menuVars.unrounded) then
        menuVars.unrounded = true
    end
end
function chooseMenuStep(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Step # :")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(24)
    if imgui.ArrowButton("##leftMenuStep", imgui_dir.Left) then
        settingVars.menuStep = settingVars.menuStep - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.menuStep = imgui.InputInt("##currentMenuStep", settingVars.menuStep, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightMenuStep", imgui_dir.Right) then
        settingVars.menuStep = settingVars.menuStep + 1
    end
    imgui.PopItemWidth()
    settingVars.menuStep = math.wrap(settingVars.menuStep, 1, 3)
end
function chooseMSPF(settingVars)
    local _, newMSPF = imgui.InputFloat("ms Per Frame", settingVars.msPerFrame, 0.5, 0.5, "%.1f")
    newMSPF = math.clamp(newMSPF, 4, 10000)
    settingVars.msPerFrame = newMSPF
    helpMarker("Number of milliseconds splitscroll will display a set of SVs before jumping to " ..
        "the next set of SVs")
end
function chooseNoNormalize(settingVars)
    addPadding()
    local oldChoice = settingVars.dontNormalize
    local _, newChoice = imgui.Checkbox("Don't normalize to average SV", oldChoice)
    settingVars.dontNormalize = newChoice
    return oldChoice ~= newChoice
end
function chooseNoteSkinType(settingVars)
    settingVars.noteSkinTypeIndex = combo("Preview skin", NOTE_SKIN_TYPES,
        settingVars.noteSkinTypeIndex)
    helpMarker("Note skin type for the preview of the frames")
end
function chooseNoteSpacing(menuVars)
    _, menuVars.noteSpacing = imgui.InputFloat("Note Spacing", menuVars.noteSpacing, 0, 0, "%.2fx")
end
function chooseNumFlickers(menuVars)
    _, menuVars.numFlickers = imgui.InputInt("Flickers", menuVars.numFlickers, 1, 1)
    menuVars.numFlickers = math.clamp(menuVars.numFlickers, 1, 9999)
end
function chooseNumFrames(settingVars)
    _, settingVars.numFrames = imgui.InputInt("Total # Frames", settingVars.numFrames)
    settingVars.numFrames = math.clamp(settingVars.numFrames, 1, MAX_ANIMATION_FRAMES)
end
function chooseNumPeriods(settingVars)
    local oldPeriods = settingVars.periods
    local _, newPeriods = imgui.InputFloat("Periods/Cycles", oldPeriods, 0.25, 0.25, "%.2f")
    newPeriods = math.quarter(newPeriods)
    newPeriods = math.clamp(newPeriods, 0.25, 69420)
    settingVars.periods = newPeriods
    return oldPeriods ~= newPeriods
end
function chooseNumScrolls(settingVars)
    _, settingVars.numScrolls = imgui.InputInt("# of scrolls", settingVars.numScrolls, 1, 1)
    settingVars.numScrolls = math.wrap(settingVars.numScrolls, 2, 4)
end
function choosePeriodShift(settingVars)
    local oldShift = settingVars.periodsShift
    local _, newShift = imgui.InputFloat("Phase Shift", oldShift, 0.25, 0.25, "%.2f")
    newShift = math.quarter(newShift)
    newShift = math.wrap(newShift, -0.75, 1)
    settingVars.periodsShift = newShift
    return oldShift ~= newShift
end
function choosePlaceSVType(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("  Type:  ")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.placeTypeIndex = combo("##placeType", CREATE_TYPES, globalVars.placeTypeIndex)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Still" then toolTip("Still keeps notes normal distance/spacing apart") end
end
function chooseCurrentScrollGroup(globalVars)
    function indexOf(tbl, var)
        for k, v in pairs(tbl) do
            if v == var then
                return k
            end
        end
        return nil
    end
    imgui.AlignTextToFramePadding()
    imgui.Text("  Timing Group: ")
    imgui.SameLine(0, SAMELINE_SPACING)
    local groups = { "$Default", "$Global" }
    local cols = { map.TimingGroups["$Default"].ColorRgb or "255,255,255", map.TimingGroups["$Global"].ColorRgb or
    "255,255,255" }
    for k, v in pairs(map.TimingGroups) do
        if string.find(k, "%$") then goto continue end
        if (globalVars.hideAutomatic and string.find(k, "automate_")) then goto continue end
        table.insert(groups, k)
        table.insert(cols, v.ColorRgb or "255,255,255")
        ::continue::
    end
    local prevIndex = globalVars.scrollGroupIndex
    imgui.PushItemWidth(155)
    globalVars.scrollGroupIndex = combo("##scrollGroup", groups, globalVars.scrollGroupIndex, cols)
    imgui.PopItemWidth()
    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[6])) then
        globalVars.scrollGroupIndex = math.clamp(globalVars.scrollGroupIndex - 1, 1, #groups)
    end
    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[7])) then
        globalVars.scrollGroupIndex = math.clamp(globalVars.scrollGroupIndex + 1, 1, #groups)
    end
    addSeparator()
    if (prevIndex ~= globalVars.scrollGroupIndex) then
        state.SelectedScrollGroupId = groups[globalVars.scrollGroupIndex]
    end
    if (state.SelectedScrollGroupId ~= groups[globalVars.scrollGroupIndex]) then
        globalVars.scrollGroupIndex = indexOf(groups, state.SelectedScrollGroupId)
    end
end
function chooseRandomScale(settingVars)
    local oldScale = settingVars.randomScale
    local _, newScale = imgui.InputFloat("Random Scale", oldScale, 0, 0, "%.2fx")
    settingVars.randomScale = newScale
    return oldScale ~= newScale
end
function chooseRandomType(settingVars)
    local oldIndex = settingVars.randomTypeIndex
    settingVars.randomTypeIndex = combo("Random Type", RANDOM_TYPES, settingVars.randomTypeIndex)
    return oldIndex ~= settingVars.randomTypeIndex
end
function chooseRatio(menuVars)
    _, menuVars.ratio = imgui.InputFloat("Ratio", menuVars.ratio, 0, 0, "%.3f")
end
function chooseRGBPeriod(globalVars)
    local oldRGBPeriod = globalVars.rgbPeriod
    _, globalVars.rgbPeriod = imgui.InputFloat("RGB cycle length", oldRGBPeriod, 0, 0,
        "%.0f seconds")
    globalVars.rgbPeriod = math.clamp(globalVars.rgbPeriod, MIN_RGB_CYCLE_TIME,
        MAX_RGB_CYCLE_TIME)
    if (oldRGBPeriod ~= globalVars.rgbPeriod) then
        write(globalVars)
    end
end
function chooseSecondHeight(settingVars)
    _, settingVars.height2 = imgui.InputFloat("2nd Height", settingVars.height2, 0, 0, "%.3f msx")
    helpMarker("Height at which notes are hit at on screen for the 2nd scroll speed")
end
function chooseSecondScrollSpeed(settingVars)
    local text = "2nd Scroll Speed"
    _, settingVars.scrollSpeed2 = imgui.InputFloat(text, settingVars.scrollSpeed2, 0, 0, "%.2fx")
end
function chooseScaleDisplaceSpot(menuVars)
    menuVars.scaleSpotIndex = combo("Displace Spot", DISPLACE_SCALE_SPOTS, menuVars.scaleSpotIndex)
end
function chooseScaleType(menuVars)
    local label = "Scale Type"
    menuVars.scaleTypeIndex = combo(label, SCALE_TYPES, menuVars.scaleTypeIndex)
    local scaleType = SCALE_TYPES[menuVars.scaleTypeIndex]
    if scaleType == "Average SV" then chooseAverageSV(menuVars) end
    if scaleType == "Absolute Distance" then chooseDistance(menuVars) end
    if scaleType == "Relative Ratio" then chooseRatio(menuVars) end
end
function chooseScrollIndex(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Currently viewing scroll #:")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(35)
    if imgui.ArrowButton("##leftScrollIndex", imgui_dir.Left) then
        settingVars.scrollIndex = settingVars.scrollIndex - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    local inputText = "##currentScrollIndex"
    _, settingVars.scrollIndex = imgui.InputInt(inputText, settingVars.scrollIndex, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightScrollIndex", imgui_dir.Right) then
        settingVars.scrollIndex = settingVars.scrollIndex + 1
    end
    helpMarker("Assign notes and SVs for every single scroll in order to place splitscroll SVs")
    settingVars.scrollIndex = math.wrap(settingVars.scrollIndex, 1, settingVars.numScrolls)
    imgui.PopItemWidth()
end
function chooseSnakeSpringConstant(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local oldValue = globalVars.snakeSpringConstant
    _, globalVars.snakeSpringConstant = imgui.InputFloat("Reactiveness##snake", oldValue, 0, 0, "%.2f")
    helpMarker("Pick any number from 0.01 to 1")
    globalVars.snakeSpringConstant = math.clamp(globalVars.snakeSpringConstant, 0.01, 1)
    if (globalVars.snakeSpringConstant ~= oldValue) then
        write(globalVars)
    end
end
function chooseSpecialSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #STANDARD_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = combo(label, SPECIAL_SVS, menuVars.svTypeIndex)
end
function chooseVibratoSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #VIBRATO_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = combo(label, VIBRATO_SVS, menuVars.svTypeIndex)
end
function chooseSplitscrollLayers(settingVars)
    local currentLayerNum = settingVars.scrollIndex
    local currentLayer = settingVars.splitscrollLayers[currentLayerNum]
    if currentLayer == nil then
        imgui.Text("0 SVs, 0 notes assigned")
        local buttonText = "Assign SVs and notes between\nselected notes to scroll " .. currentLayerNum
        if imgui.Button(buttonText, ACTION_BUTTON_SIZE) then
            local offsets = uniqueSelectedNoteOffsets()
            if (not offsets) then return end
            local startOffset = offsets[1]
            local endOffset = offsets[#offsets]
            local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
            addStartSVIfMissing(svsBetweenOffsets, startOffset)
            local newNotes = {}
            for _, hitObject in pairs(state.SelectedHitObjects) do
                local newNote = utils.CreateHitObject(hitObject.StartTime, hitObject.Lane,
                    hitObject.EndTime, hitObject.HitSound,
                    hitObject.EditorLayer)
                table.insert(newNotes, newNote)
            end
            newNotes = sort(newNotes, sortAscendingStartTime)
            settingVars.splitscrollLayers[currentLayerNum] = {
                svs = svsBetweenOffsets,
                notes = newNotes
            }
            local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
            local editorActions = {
                actionRemoveNotesBetween(startOffset, endOffset),
                utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove)
            }
            actions.PerformBatch(editorActions)
        end
    else
        local currentLayerSVs = currentLayer.svs
        local currentLayerNotes = currentLayer.notes
        imgui.Text(table.concat({ #currentLayerSVs, " SVs, ", #currentLayerNotes, " notes assigned" }))
        if imgui.Button("Clear assigned\nnotes and SVs", HALF_ACTION_BUTTON_SIZE) then
            settingVars.splitscrollLayers[currentLayerNum] = nil
        end
        imgui.SameLine(0, SAMELINE_SPACING)
        if imgui.Button("Re-place assigned\nnotes and SVs", HALF_ACTION_BUTTON_SIZE) then
            local svStartOffset = currentLayerSVs[1].StartTime
            local svEndOffset = currentLayerSVs[#currentLayerSVs].StartTime
            local svsToRemove = getSVsBetweenOffsets(svStartOffset, svEndOffset)
            local noteStartOffset = currentLayerNotes[1].StartTime
            local noteEndOffset = currentLayerNotes[#currentLayerNotes].StartTime
            local editorActions = {
                actionRemoveNotesBetween(noteStartOffset, noteEndOffset),
                utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
                utils.CreateEditorAction(action_type.AddScrollVelocityBatch, currentLayerSVs),
                utils.CreateEditorAction(action_type.PlaceHitObjectBatch, currentLayerNotes)
            }
            actions.PerformBatch(editorActions)
        end
    end
end
function actionRemoveNotesBetween(startOffset, endOffset)
    local notesToRemove = {}
    for _, hitObject in pairs(map.HitObjects) do
        if hitObject.StartTime >= startOffset and hitObject.StartTime <= endOffset then
            table.insert(notesToRemove, hitObject)
        end
    end
    return utils.CreateEditorAction(action_type.RemoveHitObjectBatch, notesToRemove)
end
function chooseStandardSVType(menuVars, excludeCombo)
    local oldIndex = menuVars.svTypeIndex
    local label = " " .. EMOTICONS[oldIndex]
    local svTypeList = STANDARD_SVS
    if excludeCombo then svTypeList = STANDARD_SVS_NO_COMBO end
    menuVars.svTypeIndex = combo(label, svTypeList, menuVars.svTypeIndex)
    return oldIndex ~= menuVars.svTypeIndex
end
function chooseStandardSVTypes(settingVars)
    local oldIndex1 = settingVars.svType1Index
    local oldIndex2 = settingVars.svType2Index
    settingVars.svType1Index = combo("SV Type 1", STANDARD_SVS_NO_COMBO, settingVars.svType1Index)
    settingVars.svType2Index = combo("SV Type 2", STANDARD_SVS_NO_COMBO, settingVars.svType2Index)
    return (oldIndex2 ~= settingVars.svType2Index) or (oldIndex1 ~= settingVars.svType1Index)
end
function chooseStartEndSVs(settingVars)
    if settingVars.linearlyChange == false then
        local oldValue = settingVars.startSV
        local _, newValue = imgui.InputFloat("SV Value", oldValue, 0, 0, "%.2fx")
        settingVars.startSV = newValue
        return oldValue ~= newValue
    end
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = vector.New(settingVars.startSV, settingVars.endSV)
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2("Start/End SV", oldValues, "%.2fx")
    imgui.PopItemWidth()
    settingVars.startSV = newValues.x
    settingVars.endSV = newValues.y
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.startSV = oldValues.y
        settingVars.endSV = oldValues.x
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars.startSV = -oldValues.x
        settingVars.endSV = -oldValues.y
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues ~= newValues
end
function chooseStartSVPercent(settingVars)
    local label1 = "Start SV %"
    if settingVars.linearlyChange then label1 = label1 .. " (start)" end
    _, settingVars.svPercent = imgui.InputFloat(label1, settingVars.svPercent, 1, 1, "%.2f%%")
    local helpMarkerText = "%% distance between notes"
    if not settingVars.linearlyChange then
        helpMarker(helpMarkerText)
        return
    end
    local label2 = "Start SV % (end)"
    _, settingVars.svPercent2 = imgui.InputFloat(label2, settingVars.svPercent2, 1, 1, "%.2f%%")
end
function chooseStillType(menuVars)
    local stillType = STILL_TYPES[menuVars.stillTypeIndex]
    local dontChooseDistance = stillType == "No" or
        stillType == "Auto" or
        stillType == "Otua"
    local indentWidth = DEFAULT_WIDGET_WIDTH * 0.5 + 16
    if dontChooseDistance then
        imgui.Indent(indentWidth)
    else
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.6 - 5)
        _, menuVars.stillDistance = imgui.InputFloat("##still", menuVars.stillDistance, 0, 0,
            "%.2f msx")
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.PopItemWidth()
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.4)
    menuVars.stillTypeIndex = combo("Displacement", STILL_TYPES, menuVars.stillTypeIndex)
    if stillType == "No" then toolTip("Don't use an initial or end displacement") end
    if stillType == "Start" then toolTip("Use an initial starting displacement for the still") end
    if stillType == "End" then toolTip("Have a displacement to end at for the still") end
    if stillType == "Auto" then toolTip("Use last displacement of the previous still to start") end
    if stillType == "Otua" then toolTip("Use next displacement of the next still to end at") end
    if dontChooseDistance then
        imgui.Unindent(indentWidth)
    end
    imgui.PopItemWidth()
end
function chooseStillBehavior(menuVars)
    menuVars.stillBehavior = combo("Still Behavior", STILL_BEHAVIOR_TYPES, menuVars.stillBehavior)
end
function chooseStutterDuration(settingVars)
    local oldDuration = settingVars.stutterDuration
    if settingVars.controlLastSV then oldDuration = 100 - oldDuration end
    local _, newDuration = imgui.SliderInt("Duration", oldDuration, 1, 99, oldDuration .. "%%")
    newDuration = math.clamp(newDuration, 1, 99)
    local durationChanged = oldDuration ~= newDuration
    if settingVars.controlLastSV then newDuration = 100 - newDuration end
    settingVars.stutterDuration = newDuration
    return durationChanged
end
function chooseStuttersPerSection(settingVars)
    local oldNumber = settingVars.stuttersPerSection
    local _, newNumber = imgui.InputInt("Stutters", oldNumber, 1, 1)
    helpMarker("Number of stutters per section")
    newNumber = math.clamp(newNumber, 1, 1000)
    settingVars.stuttersPerSection = newNumber
    return oldNumber ~= newNumber
end
function chooseStyleTheme(globalVars)
    local oldStyleTheme = globalVars.styleThemeIndex
    globalVars.styleThemeIndex = combo("Style Theme", STYLE_THEMES, oldStyleTheme)
    if (oldStyleTheme ~= globalVars.styleThemeIndex) then
        write(globalVars)
    end
end
function chooseSVBehavior(settingVars)
    local swapButtonPressed = imgui.Button("Swap", SECONDARY_BUTTON_SIZE)
    toolTip("Switch between slow down/speed up")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local oldBehaviorIndex = settingVars.behaviorIndex
    settingVars.behaviorIndex = combo("Behavior", SV_BEHAVIORS, oldBehaviorIndex)
    imgui.PopItemWidth()
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.behaviorIndex = oldBehaviorIndex == 1 and 2 or 1
    end
    return oldBehaviorIndex ~= settingVars.behaviorIndex
end
function chooseSVPerQuarterPeriod(settingVars)
    local oldPoints = settingVars.svsPerQuarterPeriod
    local _, newPoints = imgui.InputInt("SV Points##perQuarter", oldPoints, 1, 1)
    helpMarker("Number of SV points per 0.25 period/cycle")
    local maxSVsPerQuarterPeriod = MAX_SV_POINTS / (4 * settingVars.periods)
    newPoints = math.clamp(newPoints, 1, maxSVsPerQuarterPeriod)
    settingVars.svsPerQuarterPeriod = newPoints
    return oldPoints ~= newPoints
end
function chooseSVPoints(settingVars, svPointsForce)
    if svPointsForce then
        settingVars.svPoints = svPointsForce
        return false
    end
    local oldPoints = settingVars.svPoints
    _, settingVars.svPoints = imgui.InputInt("SV Points##regular", oldPoints, 1, 1)
    settingVars.svPoints = math.clamp(settingVars.svPoints, 1, MAX_SV_POINTS)
    return oldPoints ~= settingVars.svPoints
end
function chooseUpscroll(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Scroll Direction:")
    toolTip("Orientation for distance graphs and visuals")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    local oldUpscroll = globalVars.upscroll
    if imgui.RadioButton("Down", not globalVars.upscroll) then
        globalVars.upscroll = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Up         ", globalVars.upscroll) then
        globalVars.upscroll = true
    end
    if (oldUpscroll ~= globalVars.upscroll) then
        write(globalVars)
    end
end
function chooseUseDistance(settingVars)
    local label = "Use distance for start SV"
    _, settingVars.useDistance = imgui.Checkbox(label, settingVars.useDistance)
end
function chooseHand(settingVars)
    local label = "Add teleport before note"
    _, settingVars.teleportBeforeHand = imgui.Checkbox(label, settingVars.teleportBeforeHand)
end
function chooseDistanceMode(menuVars)
    local oldMode = menuVars.distanceMode
    menuVars.distanceMode = combo("Distance Type", DISTANCE_TYPES, menuVars.distanceMode)
    return oldMode ~= menuVars.distanceMode
end
function choosePluginBehaviorSettings(globalVars)
    if not imgui.CollapsingHeader("Plugin Behavior Settings") then return end
    addPadding()
    chooseKeyboardMode(globalVars)
    addSeparator()
    chooseUpscroll(globalVars)
    addSeparator()
    chooseDontReplaceSV(globalVars)
    chooseBetaIgnore(globalVars)
    chooseStepSize(globalVars)
    addPadding()
end
function choosePluginAppearance(globalVars)
    if not imgui.CollapsingHeader("Plugin Appearance Settings") then return end
    addPadding()
    chooseStyleTheme(globalVars)
    chooseColorTheme(globalVars)
    addSeparator()
    chooseCursorTrail(globalVars)
    chooseCursorTrailShape(globalVars)
    chooseEffectFPS(globalVars)
    chooseCursorTrailPoints(globalVars)
    chooseCursorShapeSize(globalVars)
    chooseSnakeSpringConstant(globalVars)
    chooseCursorTrailGhost(globalVars)
    addSeparator()
    chooseDrawCapybara(globalVars)
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    chooseDrawCapybara2(globalVars)
    chooseDrawCapybara312(globalVars)
    addSeparator()
    choosePulseCoefficient(globalVars)
    _, globalVars.useCustomPulseColor = imgui.Checkbox("Use Custom Color?", globalVars.useCustomPulseColor)
    if (globalVars.useCustomPulseColor) then
        imgui.SameLine()
        if (imgui.Button("Edit Color")) then
            globalVars.showColorPicker = true
        end
        choosePulseColor(globalVars)
    else
        globalVars.showColorPicker = false
    end
end
function chooseHotkeys(globalVars)
    local hotkeyList = table.duplicate(globalVars.hotkeyList or DEFAULT_HOTKEY_LIST)
    local awaitingIndex = state.GetValue("hotkey_awaitingIndex", 0)
    if not imgui.CollapsingHeader("Plugin Hotkey Settings") then return end
    for k, v in pairs(hotkeyList) do
        if imgui.Button(awaitingIndex == k and "Listening...##listening" or v .. "##" .. k) then
            if (awaitingIndex == k) then
                awaitingIndex = 0
            else
                awaitingIndex = k
            end
        end
        imgui.SameLine()
        imgui.SetCursorPosX(85)
        imgui.Text("// " .. HOTKEY_LABELS[k])
    end
    addSeparator()
    simpleActionMenu("Reset Hotkey Settings", 0, function()
        globalVars.hotkeyList = DEFAULT_HOTKEY_LIST
        write(globalVars)
        awaitingIndex = 0
    end, nil, nil, true, true)
    state.SetValue("hotkey_awaitingIndex", awaitingIndex)
    if (awaitingIndex == 0) then return end
    local prefixes, key = listenForAnyKeyPressed()
    if (key == -1) then return end
    hotkeyList[awaitingIndex] = table.concat(prefixes, "+") .. (truthy(prefixes) and "+" or "") .. keyNumToKey(key)
    awaitingIndex = 0
    globalVars.hotkeyList = hotkeyList
    GLOBAL_HOTKEY_LIST = hotkeyList
    write(globalVars)
    state.SetValue("hotkey_awaitingIndex", awaitingIndex)
end
function choosePulseCoefficient(globalVars)
    local oldCoefficient = globalVars.pulseCoefficient
    _, globalVars.pulseCoefficient = imgui.SliderFloat("Pulse Strength", oldCoefficient, 0, 1,
        math.round(globalVars.pulseCoefficient * 100) .. "%%")
    globalVars.pulseCoefficient = math.clamp(globalVars.pulseCoefficient, 0, 1)
    if (oldCoefficient ~= globalVars.pulseCoefficient) then
        write(globalVars)
    end
end
function choosePulseColor(globalVars)
    if (globalVars.showColorPicker) then
        _, opened = imgui.Begin("plumoguSV Pulse Color Picker", globalVars.showColorPicker,
            imgui_window_flags.AlwaysAutoResize)
        local oldColor = globalVars.pulseColor
        _, globalVars.pulseColor = imgui.ColorPicker4("Pulse Color", globalVars.pulseColor)
        if (oldColor ~= globalVars.pulseColor) then
            write(globalVars)
        end
        if (not opened) then
            globalVars.showColorPicker = false
            write(globalVars)
        end
        imgui.End()
    end
end
function computableInputFloat(label, var, decimalPlaces, suffix)
    local computableStateIndex = state.GetValue("computableInputFloatIndex") or 1
    _, var = imgui.InputText(label,
        string.format("%." .. decimalPlaces .. "f" .. suffix, tonumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+")) or 0),
        4096,
        imgui_input_text_flags.AutoSelectAll)
    if (not imgui.IsItemActive() and (state.GetValue("previouslyActiveImguiFloat" .. computableStateIndex) or false)) then
        local desiredComp = tostring(var):gsub("[ ]*msx[ ]*", "")
        var = expr(desiredComp)
    end
    state.SetValue("previouslyActiveImguiFloat" .. computableStateIndex, imgui.IsItemActive())
    state.SetValue("computableInputFloatIndex", computableStateIndex + 1)
    return tonumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+"))
end
function customSwappableNegatableInputFloat2(settingVars, lowerName, higherName, tag)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local swapButtonPressed = imgui.Button("S##" .. lowerName, TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = { settingVars[lowerName], settingVars[higherName] }
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N##" .. higherName, TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2(tag, oldValues, "%.2fx")
    imgui.PopItemWidth()
    settingVars[lowerName] = newValues[1]
    settingVars[higherName] = newValues[2]
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars[lowerName] = oldValues[2]
        settingVars[higherName] = oldValues[1]
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars[lowerName] = -oldValues[1]
        settingVars[higherName] = -oldValues[2]
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end
function calculateDisplacementsFromNotes(noteOffsets, noteSpacing)
    local totalDisplacement = 0
    local displacements = { 0 }
    for i = 1, #noteOffsets - 1 do
        local time = (noteOffsets[i + 1] - noteOffsets[i])
        local distance = time * noteSpacing
        totalDisplacement = totalDisplacement + distance
        table.insert(displacements, totalDisplacement)
    end
    return displacements
end
function calculateDisplacementFromSVs(svs, startOffset, endOffset)
    return calculateDisplacementsFromSVs(svs, { startOffset, endOffset })[2]
end
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
function getUsableDisplacementMultiplier(offset)
    local exponent = 23 - math.floor(math.log(math.abs(offset) + 1) / math.log(2))
    if exponent > 6 then exponent = 6 end
    return 2 ^ exponent
end
function prepareDisplacingSV(svsToAdd, svTimeIsAdded, svTime, displacement, displacementMultiplier, hypothetical, svs)
    svTimeIsAdded[svTime] = true
    local currentSVMultiplier = getSVMultiplierAt(svTime)
    if (hypothetical == true) then
        currentSVMultiplier = getHypotheticalSVMultiplierAt(svs, svTime)
    end
    local newSVMultiplier = displacementMultiplier * displacement + currentSVMultiplier
    addSVToList(svsToAdd, svTime, newSVMultiplier, true)
end
function prepareDisplacingSVs(offset, svsToAdd, svTimeIsAdded, beforeDisplacement, atDisplacement,
                              afterDisplacement, hypothetical, baseSVs)
    local displacementMultiplier = getUsableDisplacementMultiplier(offset)
    local duration = 1 / displacementMultiplier
    if beforeDisplacement then
        local timeBefore = offset - duration
        prepareDisplacingSV(svsToAdd, svTimeIsAdded, timeBefore, beforeDisplacement,
            displacementMultiplier, hypothetical, baseSVs)
    end
    if atDisplacement then
        local timeAt = offset
        prepareDisplacingSV(svsToAdd, svTimeIsAdded, timeAt, atDisplacement,
            displacementMultiplier, hypothetical, baseSVs)
    end
    if afterDisplacement then
        local timeAfter = offset + duration
        prepareDisplacingSV(svsToAdd, svTimeIsAdded, timeAfter, afterDisplacement,
            displacementMultiplier, hypothetical, baseSVs)
    end
end
function generateBezierSet(x1, y1, x2, y2, avgValue, numValues, verticalShift)
    avgValue = avgValue - verticalShift
    local startingTimeGuess = 0.5
    local timeGuesses = {}
    local targetXPositions = {}
    local iterations = 20
    for i = 1, numValues do
        table.insert(timeGuesses, startingTimeGuess)
        table.insert(targetXPositions, i / numValues)
    end
    for i = 1, iterations do
        local timeIncrement = 0.5 ^ (i + 1)
        for j = 1, numValues do
            local xPositionGuess = math.cubicBezier(x1, x2, timeGuesses[j])
            if xPositionGuess < targetXPositions[j] then
                timeGuesses[j] = timeGuesses[j] + timeIncrement
            elseif xPositionGuess > targetXPositions[j] then
                timeGuesses[j] = timeGuesses[j] - timeIncrement
            end
        end
    end
    local yPositions = { 0 }
    for i = 1, #timeGuesses do
        local yPosition = math.cubicBezier(y1, y2, timeGuesses[i])
        table.insert(yPositions, yPosition)
    end
    local bezierSet = {}
    for i = 1, #yPositions - 1 do
        local slope = (yPositions[i + 1] - yPositions[i]) * numValues
        table.insert(bezierSet, slope)
    end
    table.normalize(bezierSet, avgValue, false)
    for i = 1, #bezierSet do
        bezierSet[i] = bezierSet[i] + verticalShift
    end
    return bezierSet
end
function generateChinchillaSet(settingVars)
    if settingVars.svPoints == 1 then return { settingVars.avgSV, settingVars.avgSV } end
    local avgValue = settingVars.avgSV - settingVars.verticalShift
    local chinchillaSet = {}
    local percents = generateLinearSet(0, 1, settingVars.svPoints + 1)
    local newPercents = {}
    for i = 1, #percents do
        local currentPercent = percents[i]
        local newPercent = scalePercent(settingVars, currentPercent) --
        table.insert(newPercents, newPercent)
    end
    local numValues = settingVars.svPoints
    for i = 1, numValues do
        local distance = newPercents[i + 1] - newPercents[i]
        local slope = distance * numValues
        chinchillaSet[i] = slope
    end
    table.normalize(chinchillaSet, avgValue, true)
    for i = 1, #chinchillaSet do
        chinchillaSet[i] = chinchillaSet[i] + settingVars.verticalShift
    end
    table.insert(chinchillaSet, settingVars.avgSV)
    return chinchillaSet
end
function scalePercent(settingVars, percent)
    local behaviorType = SV_BEHAVIORS[settingVars.behaviorIndex]
    local slowDownType = behaviorType == "Slow down"
    local workingPercent = percent
    if slowDownType then workingPercent = 1 - percent end
    local newPercent
    local a = settingVars.chinchillaIntensity
    local scaleType = CHINCHILLA_TYPES[settingVars.chinchillaTypeIndex]
    if scaleType == "Exponential" then
        local exponent = a * (workingPercent - 1)
        newPercent = (workingPercent * math.exp(exponent))
    elseif scaleType == "Polynomial" then
        local exponent = a + 1
        newPercent = workingPercent ^ exponent
    elseif scaleType == "Circular" then
        if a == 0 then return percent end
        local b = 1 / (a ^ (a + 1))
        local radicand = (b + 1) ^ 2 + b ^ 2 - (workingPercent + b) ^ 2
        newPercent = b + 1 - math.sqrt(radicand)
    elseif scaleType == "Sine Power" then
        local exponent = math.log(a + 1)
        local base = math.sin(math.pi * (workingPercent - 1) / 2) + 1
        newPercent = workingPercent * (base ^ exponent)
    elseif scaleType == "Arc Sine Power" then
        local exponent = math.log(a + 1)
        local base = 2 * math.asin(workingPercent) / math.pi
        newPercent = workingPercent * (base ^ exponent)
    elseif scaleType == "Inverse Power" then
        local denominator = 1 + (workingPercent ^ -a)
        newPercent = 2 * workingPercent / denominator
    elseif "Peter Stock" then
        if a == 0 then return percent end
        local c = a / (1 - a)
        newPercent = (workingPercent ^ 2) * (1 + c) / (workingPercent + c)
    end
    if slowDownType then newPercent = 1 - newPercent end
    return math.clamp(newPercent, 0, 1)
end
function generateCircularSet(behavior, arcPercent, avgValue, verticalShift, numValues,
                             dontNormalize)
    local increaseValues = (behavior == "Speed up")
    avgValue = avgValue - verticalShift
    local startingAngle = math.pi * (arcPercent / 100)
    local angles = generateLinearSet(startingAngle, 0, numValues)
    local yCoords = {}
    for i = 1, #angles do
        local angle = math.round(angles[i], 8)
        local x = math.cos(angle)
        yCoords[i] = -avgValue * math.sqrt(1 - x ^ 2)
    end
    local circularSet = {}
    for i = 1, #yCoords - 1 do
        local startY = yCoords[i]
        local endY = yCoords[i + 1]
        circularSet[i] = (endY - startY) * (numValues - 1)
    end
    if not increaseValues then circularSet = table.reverse(circularSet) end
    if not dontNormalize then table.normalize(circularSet, avgValue, true) end
    for i = 1, #circularSet do
        circularSet[i] = circularSet[i] + verticalShift
    end
    table.insert(circularSet, avgValue)
    return circularSet
end
function generateComboSet(values1, values2, comboPhase, comboType, comboMultiplier1,
                          comboMultiplier2, dontNormalize, avgValue, verticalShift)
    local comboValues = {}
    if comboType == "SV Type 1 Only" then
        comboValues = table.duplicate(values1)
    elseif comboType == "SV Type 2 Only" then
        comboValues = table.duplicate(values2)
    else
        local lastValue1 = table.remove(values1)
        local lastValue2 = table.remove(values2)
        local endIndex1 = #values1 - comboPhase
        local startIndex1 = comboPhase + 1
        local endIndex2 = comboPhase - #values1
        local startIndex2 = #values1 + #values2 + 1 - comboPhase
        for i = 1, endIndex1 do
            table.insert(comboValues, values1[i])
        end
        for i = 1, endIndex2 do
            table.insert(comboValues, values2[i])
        end
        if comboType ~= "Remove" then
            local comboValues1StartIndex = endIndex1 + 1
            local comboValues1EndIndex = startIndex2 - 1
            local comboValues2StartIndex = endIndex2 + 1
            local comboValues2EndIndex = startIndex1 - 1
            local comboValues1 = {}
            for i = comboValues1StartIndex, comboValues1EndIndex do
                table.insert(comboValues1, values1[i])
            end
            local comboValues2 = {}
            for i = comboValues2StartIndex, comboValues2EndIndex do
                table.insert(comboValues2, values2[i])
            end
            for i = 1, #comboValues1 do
                local comboValue1 = comboValues1[i]
                local comboValue2 = comboValues2[i]
                local finalValue
                if comboType == "Add" then
                    finalValue = comboMultiplier1 * comboValue1 + comboMultiplier2 * comboValue2
                elseif comboType == "Cross Multiply" then
                    finalValue = comboValue1 * comboValue2
                elseif comboType == "Min" then
                    finalValue = math.min(comboValue1, comboValue2)
                elseif comboType == "Max" then
                    finalValue = math.max(comboValue1, comboValue2)
                end
                table.insert(comboValues, finalValue)
            end
        end
        for i = startIndex1, #values2 do
            table.insert(comboValues, values2[i])
        end
        for i = startIndex2, #values1 do
            table.insert(comboValues, values1[i])
        end
        if #comboValues == 0 then table.insert(comboValues, 1) end
        if (comboPhase - #values2 >= 0) then
            table.insert(comboValues, lastValue1)
        else
            table.insert(comboValues, lastValue2)
        end
    end
    avgValue = avgValue - verticalShift
    if not dontNormalize then
        table.normalize(comboValues, avgValue, false)
    end
    for i = 1, #comboValues do
        comboValues[i] = comboValues[i] + verticalShift
    end
    return comboValues
end
function generateCustomSet(values)
    local newValues = table.duplicate(values)
    local averageMultiplier = table.average(newValues, true)
    table.insert(newValues, averageMultiplier)
    return newValues
end
function generateExponentialSet(behavior, numValues, avgValue, intensity, verticalShift)
    avgValue = avgValue - verticalShift
    local exponentialIncrease = (behavior == "Speed up")
    local exponentialSet = {}
    intensity = intensity / 5
    for i = 0, numValues - 1 do
        local x
        if exponentialIncrease then
            x = (i + 0.5) * intensity / numValues
        else
            x = (numValues - i - 0.5) * intensity / numValues
        end
        local y = math.exp(x - 1) / intensity
        table.insert(exponentialSet, y)
    end
    table.normalize(exponentialSet, avgValue, false)
    for i = 1, #exponentialSet do
        exponentialSet[i] = exponentialSet[i] + verticalShift
    end
    return exponentialSet
end
function generateExponentialSet2(behavior, numValues, startValue, endValue, intensity)
    local exponentialSet = {}
    intensity = intensity / 5
    if (behavior == "Slow down" and startValue ~= endValue) then
        local temp = startValue
        startValue = endValue
        endValue = temp
    end
    for i = 0, numValues - 1 do
        fx = startValue
        local x = i / (numValues - 1)
        local k = (endValue - startValue) / (math.exp(intensity) - 1)
        fx = k * math.exp(intensity * x) + startValue - k
        table.insert(exponentialSet, fx)
    end
    if (behavior == "Slow down" and startValue ~= endValue) then
        exponentialSet = table.reverse(exponentialSet)
    end
    return exponentialSet
end
function generateHermiteSet(startValue, endValue, verticalShift, avgValue, numValues)
    avgValue = avgValue - verticalShift
    local xCoords = generateLinearSet(0, 1, numValues)
    local yCoords = {}
    for i = 1, #xCoords do
        yCoords[i] = math.hermite(startValue, endValue, avgValue, xCoords[i])
    end
    local hermiteSet = {}
    for i = 1, #yCoords - 1 do
        local startY = yCoords[i]
        local endY = yCoords[i + 1]
        hermiteSet[i] = (endY - startY) * (numValues - 1)
    end
    for i = 1, #hermiteSet do
        hermiteSet[i] = hermiteSet[i] + verticalShift
    end
    table.insert(hermiteSet, avgValue)
    return hermiteSet
end
function generateLinearSet(startValue, endValue, numValues)
    local linearSet = { startValue }
    if numValues < 2 then return linearSet end
    local increment = (endValue - startValue) / (numValues - 1)
    for i = 1, (numValues - 1) do
        table.insert(linearSet, startValue + i * increment)
    end
    return linearSet
end
function getRandomSet(values, avgValue, verticalShift, dontNormalize)
    avgValue = avgValue - verticalShift
    local randomSet = {}
    for i = 1, #values do
        table.insert(randomSet, values[i])
    end
    if not dontNormalize then
        table.normalize(randomSet, avgValue, false)
    end
    for i = 1, #randomSet do
        randomSet[i] = randomSet[i] + verticalShift
    end
    return randomSet
end
function generateRandomSet(numValues, randomType, randomScale)
    local randomSet = {}
    for _ = 1, numValues do
        if randomType == "Uniform" then
            local randomValue = randomScale * 2 * (0.5 - math.random())
            table.insert(randomSet, randomValue)
        elseif randomType == "Normal" then
            local u1 = math.random()
            local u2 = math.random()
            local randomIncrement = math.sqrt(-2 * math.log(u1)) * math.cos(2 * math.pi * u2)
            local randomValue = randomScale * randomIncrement
            table.insert(randomSet, randomValue)
        end
    end
    return randomSet
end
function generateSinusoidalSet(startAmplitude, endAmplitude, periods, periodsShift,
                               valuesPerQuarterPeriod, verticalShift, curveSharpness)
    local sinusoidalSet = {}
    local quarterPeriods = 4 * periods
    local quarterPeriodsShift = 4 * periodsShift
    local totalValues = valuesPerQuarterPeriod * quarterPeriods
    local amplitudes = generateLinearSet(startAmplitude, endAmplitude, totalValues + 1)
    local normalizedSharpness
    if curveSharpness > 50 then
        normalizedSharpness = math.sqrt((curveSharpness - 50) * 2)
    else
        normalizedSharpness = (curveSharpness / 50) ^ 2
    end
    for i = 0, totalValues do
        local angle = (math.pi / 2) * ((i / valuesPerQuarterPeriod) + quarterPeriodsShift)
        local value = amplitudes[i + 1] * (math.abs(math.sin(angle)) ^ (normalizedSharpness))
        value = value * math.sign(math.sin(angle)) + verticalShift
        table.insert(sinusoidalSet, value)
    end
    return sinusoidalSet
end
function generateStutterSet(stutterValue, stutterDuration, avgValue, controlLastValue)
    local durationPercent = stutterDuration / 100
    if controlLastValue then durationPercent = 1 - durationPercent end
    local otherValue = (avgValue - stutterValue * durationPercent) / (1 - durationPercent)
    local stutterSet = { stutterValue, otherValue, avgValue }
    if controlLastValue then stutterSet = { otherValue, stutterValue, avgValue } end
    return stutterSet
end
function generateSVMultipliers(svType, settingVars, interlaceMultiplier)
    local multipliers = vector.New(727, 69)
    if svType == "Linear" then
        multipliers = generateLinearSet(settingVars.startSV, settingVars.endSV,
            settingVars.svPoints + 1)
    elseif svType == "Exponential" then
        local behavior = SV_BEHAVIORS[settingVars.behaviorIndex]
        if (settingVars.distanceMode == 3) then
            multipliers = generateExponentialSet2(behavior, settingVars.svPoints + 1, settingVars.startSV,
                settingVars.endSV,
                settingVars.intensity)
        else
            multipliers = generateExponentialSet(behavior, settingVars.svPoints + 1, settingVars.avgSV,
                settingVars.intensity, settingVars.verticalShift)
        end
    elseif svType == "Bezier" then
        multipliers = generateBezierSet(settingVars.x1, settingVars.y1, settingVars.x2,
            settingVars.y2, settingVars.avgSV,
            settingVars.svPoints + 1, settingVars.verticalShift)
    elseif svType == "Hermite" then
        multipliers = generateHermiteSet(settingVars.startSV, settingVars.endSV,
            settingVars.verticalShift, settingVars.avgSV,
            settingVars.svPoints + 1)
    elseif svType == "Sinusoidal" then
        multipliers = generateSinusoidalSet(settingVars.startSV, settingVars.endSV,
            settingVars.periods, settingVars.periodsShift,
            settingVars.svsPerQuarterPeriod,
            settingVars.verticalShift, settingVars.curveSharpness)
    elseif svType == "Circular" then
        local behavior = SV_BEHAVIORS[settingVars.behaviorIndex]
        multipliers = generateCircularSet(behavior, settingVars.arcPercent, settingVars.avgSV,
            settingVars.verticalShift, settingVars.svPoints + 1,
            settingVars.dontNormalize)
    elseif svType == "Random" then
        if #settingVars.svMultipliers == 0 then
            generateRandomSetMenuSVs(settingVars)
        end
        multipliers = getRandomSet(settingVars.svMultipliers, settingVars.avgSV,
            settingVars.verticalShift, settingVars.dontNormalize)
    elseif svType == "Custom" then
        multipliers = generateCustomSet(settingVars.svMultipliers)
    elseif svType == "Chinchilla" then
        multipliers = generateChinchillaSet(settingVars)
    elseif svType == "Combo" then
        local svType1 = STANDARD_SVS[settingVars.svType1Index]
        local settingVars1 = getSettingVars(svType1, "Combo1")
        local multipliers1 = generateSVMultipliers(svType1, settingVars1, nil)
        local labelText1 = table.concat({ svType1, "SettingsCombo1" })
        saveVariables(labelText1, settingVars1)
        local svType2 = STANDARD_SVS[settingVars.svType2Index]
        local settingVars2 = getSettingVars(svType2, "Combo2")
        local multipliers2 = generateSVMultipliers(svType2, settingVars2, nil)
        local labelText2 = table.concat({ svType2, "SettingsCombo2" })
        saveVariables(labelText2, settingVars2)
        local comboType = COMBO_SV_TYPE[settingVars.comboTypeIndex]
        multipliers = generateComboSet(multipliers1, multipliers2, settingVars.comboPhase,
            comboType, settingVars.comboMultiplier1,
            settingVars.comboMultiplier2, settingVars.dontNormalize,
            settingVars.avgSV, settingVars.verticalShift)
    elseif svType == "Stutter1" then
        multipliers = generateStutterSet(settingVars.startSV, settingVars.stutterDuration,
            settingVars.avgSV, settingVars.controlLastSV)
    elseif svType == "Stutter2" then
        multipliers = generateStutterSet(settingVars.endSV, settingVars.stutterDuration,
            settingVars.avgSV, settingVars.controlLastSV)
    end
    if interlaceMultiplier then
        local newMultipliers = {}
        for i = 1, #multipliers do
            table.insert(newMultipliers, multipliers[i])
            table.insert(newMultipliers, multipliers[i] * interlaceMultiplier)
        end
        if settingVars.avgSV and not settingVars.dontNormalize then
            table.normalize(newMultipliers, settingVars.avgSV, false)
        end
        multipliers = newMultipliers
    end
    return multipliers
end
function calculateDistanceVsTime(globalVars, svValues)
    local distance = 0
    local multiplier = 1
    if globalVars.upscroll then multiplier = -1 end
    local distancesBackwards = { multiplier * distance }
    local svValuesBackwards = table.reverse(svValues)
    for i = 1, #svValuesBackwards do
        distance = distance + (multiplier * svValuesBackwards[i])
        table.insert(distancesBackwards, distance)
    end
    return table.reverse(distancesBackwards)
end
function calculateMinValue(values) return math.min(table.unpack(values)) end
function calculateMaxValue(values) return math.max(table.unpack(values)) end
function calculatePlotScale(plotValues)
    local min = math.min(table.unpack(plotValues))
    local max = math.max(table.unpack(plotValues))
    local absMax = math.max(math.abs(min), math.abs(max))
    local minScale = -absMax
    local maxScale = absMax
    if max <= 0 then maxScale = 0 end
    if min >= 0 then minScale = 0 end
    return minScale, maxScale
end
function calculateStutterDistanceVsTime(svValues, stutterDuration, stuttersPerSection)
    local distance = 0
    local distancesBackwards = { distance }
    local iterations = stuttersPerSection * 100
    if iterations > 1000 then iterations = 1000 end
    for i = 1, iterations do
        local x = ((i - 1) % 100) + 1
        if x <= (100 - stutterDuration) then
            distance = distance + svValues[2]
        else
            distance = distance + svValues[1]
        end
        table.insert(distancesBackwards, distance)
    end
    return table.reverse(distancesBackwards)
end
function plotSVMotion(noteDistances, minScale, maxScale)
    local plotSize = PLOT_GRAPH_SIZE
    imgui.PlotLines("##motion", noteDistances, #noteDistances, 0, "", minScale, maxScale, plotSize)
end
function plotSVs(svVals, minScale, maxScale)
    local plotSize = PLOT_GRAPH_SIZE
    imgui.PlotHistogram("##svplot", svVals, #svVals, 0, "", minScale, maxScale, plotSize)
end
function createFrameTime(thisTime, thisLanes, thisFrame, thisPosition)
    local frameTime = {
        time = thisTime,
        lanes = thisLanes,
        frame = thisFrame,
        position = thisPosition
    }
    return frameTime
end
function createSVGraphStats()
    local svGraphStats = {
        minScale = 0,
        maxScale = 0,
        distMinScale = 0,
        distMaxScale = 0
    }
    return svGraphStats
end
function createSVStats()
    local svStats = {
        minSV = 0,
        maxSV = 0,
        avgSV = 0
    }
    return svStats
end
function exclusiveKeyPressed(keyCombo)
    keyCombo = keyCombo:upper()
    local comboList = {}
    for v in keyCombo:gmatch("%u+") do
        table.insert(comboList, v)
    end
    local keyReq = comboList[#comboList]
    if (table.contains(comboList, "CTRL") and (utils.IsKeyUp(keys.LeftControl) and utils.IsKeyUp(keys.RightControl))) then
        return false
    end
    if (table.contains(comboList, "SHIFT") and (utils.IsKeyUp(keys.LeftShift) and utils.IsKeyUp(keys.RightShift))) then
        return false
    end
    if (table.contains(comboList, "ALT") and (utils.IsKeyUp(keys.LeftAlt) and utils.IsKeyUp(keys.RightAlt))) then
        return false
    end
    if (not table.contains(comboList, "CTRL") and not (utils.IsKeyUp(keys.LeftControl) and utils.IsKeyUp(keys.RightControl))) then
        return false
    end
    if (not table.contains(comboList, "SHIFT") and not (utils.IsKeyUp(keys.LeftShift) and utils.IsKeyUp(keys.RightShift))) then
        return false
    end
    if (not table.contains(comboList, "ALT") and not (utils.IsKeyUp(keys.LeftAlt) and utils.IsKeyUp(keys.RightAlt))) then
        return false
    end
    return utils.IsKeyPressed(keys[keyReq])
end
function keyNumToKey(num)
    local ALPHABET = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local ALPHABET_LIST = {}
    for k in ALPHABET:gmatch("%S") do
        table.insert(ALPHABET_LIST, k)
    end
    return ALPHABET_LIST[num - 64]
end
function listenForAnyKeyPressed()
    local isCtrlHeld = utils.IsKeyDown(keys.LeftControl) or utils.IsKeyDown(keys.RightControl)
    local isShiftHeld = utils.IsKeyDown(keys.LeftShift) or utils.IsKeyDown(keys.RightShift)
    local isAltHeld = utils.IsKeyDown(keys.LeftAlt) or utils.IsKeyDown(keys.RightAlt)
    local key = -1
    local prefixes = {}
    if (isCtrlHeld) then table.insert(prefixes, "Ctrl") end
    if (isShiftHeld) then table.insert(prefixes, "Shift") end
    if (isAltHeld) then table.insert(prefixes, "Alt") end
    for i = 65, 90 do
        if (utils.IsKeyPressed(i)) then
            key = i
        end
    end
    return prefixes, key
end
function getHypotheticalSVMultiplierAt(svs, offset)
    if (#svs == 1) then return svs[1].Multiplier end
    local index = #svs
    while (index >= 1) do
        if (svs[index].StartTime > offset) then
            index = index - 1
        else
            return svs[index].Multiplier
        end
    end
    return 1
end
function getHypotheticalSVTimeAt(svs, offset)
    if (#svs == 1) then return svs[1].StartTime end
    local index = #svs
    while (index >= 1) do
        if (svs[index].StartTime > offset) then
            index = index - 1
        else
            return svs[index].StartTime
        end
    end
    return 1
end
function getSVStartTimeAt(offset)
    local sv = map.GetScrollVelocityAt(offset)
    if sv then return sv.StartTime end
    return -1
end
function getSVMultiplierAt(offset)
    local sv = map.GetScrollVelocityAt(offset)
    if sv then return sv.Multiplier end
    return map.InitialScrollVelocity or 1
end
function getSSFMultiplierAt(offset)
    local ssf = map.GetScrollSpeedFactorAt(offset)
    if ssf then return ssf.Multiplier end
    return 1
end
function getTimingPointAt(offset)
    local line = map.GetTimingPointAt(offset)
    if line then return line end
    return { StartTime = -69420, Bpm = 42.69 }
end
--- Returns a list of [hit objects](lua://HitObject) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return HitObject[] objs All of the [hit objects](lua://HitObject) within the area.
function getNotesBetweenOffsets(startOffset, endOffset)
    local notesBetweenOffsets = {} ---@type HitObject[]
    for _, note in pairs(map.HitObjects) do
        local noteIsInRange = note.StartTime >= startOffset and note.StartTime <= endOffset
        if noteIsInRange then table.insert(notesBetweenOffsets, note) end
    end
    return sort(notesBetweenOffsets, sortAscendingStartTime)
end
--- Returns a list of [timing points](lua://TimingPoint) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return TimingPoint[] tps All of the [timing points](lua://TimingPoint) within the area.
function getLinesBetweenOffsets(startOffset, endOffset)
    local linesBetweenoffsets = {} ---@type TimingPoint[]
    for _, line in pairs(map.TimingPoints) do
        local lineIsInRange = line.StartTime >= startOffset and line.StartTime < endOffset
        if lineIsInRange then table.insert(linesBetweenoffsets, line) end
    end
    return sort(linesBetweenoffsets, sortAscendingStartTime)
end
--- Returns a list of [scroll velocities](lua://ScrollVelocity) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@param includeEnd? boolean Whether or not to include any SVs on the end time.
---@return ScrollVelocity[] svs All of the [scroll velocities](lua://ScrollVelocity) within the area.
function getSVsBetweenOffsets(startOffset, endOffset, includeEnd)
    local svsBetweenOffsets = {} ---@type ScrollVelocity[]
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset and sv.StartTime < endOffset
        if (includeEnd and sv.StartTime == endOffset) then svIsInRange = true end
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return sort(svsBetweenOffsets, sortAscendingStartTime)
end
--- Returns a list of [bookmarks](lua://Bookmark) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return Bookmark[] bms All of the [bookmarks](lua://Bookmark) within the area.
function getBookmarksBetweenOffsets(startOffset, endOffset)
    local bookmarksBetweenOffsets = {} ---@type Bookmark[]
    for _, bm in pairs(map.Bookmarks) do
        local bmIsInRange = bm.StartTime >= startOffset and bm.StartTime < endOffset
        if bmIsInRange then table.insert(bookmarksBetweenOffsets, bm) end
    end
    return sort(bookmarksBetweenOffsets, sortAscendingStartTime)
end
--- Given a predetermined set of SVs, returns a list of [scroll velocities](lua://ScrollVelocity) within a temporal boundary.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return ScrollVelocity[] svs All of the [scroll velocities](lua://ScrollVelocity) within the area.
function getHypotheticalSVsBetweenOffsets(svs, startOffset, endOffset)
    local svsBetweenOffsets = {} --- @type ScrollVelocity[]
    for _, sv in pairs(svs) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime < endOffset + 1
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return sort(svsBetweenOffsets, sortAscendingStartTime)
end
--- Returns a list of [scroll speed factors](lua://ScrollSpeedFactor) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@param includeEnd? boolean Whether or not to include any SVs on the end time.
---@return ScrollSpeedFactor[] ssfs All of the [scroll speed factors](lua://ScrollSpeedFactor) within the area.
function getSSFsBetweenOffsets(startOffset, endOffset, includeEnd)
    local ssfsBetweenOffsets = {} ---@type ScrollSpeedFactor[]
    local ssfs = map.ScrollSpeedFactors
    if (ssfs == nil) then
        ssfs = {}
    else
        for _, ssf in pairs(map.ScrollSpeedFactors) do
            local ssfIsInRange = ssf.StartTime >= startOffset and ssf.StartTime < endOffset
            if (includeEnd and ssf.StartTime == endOffset) then ssfIsInRange = true end
            if ssfIsInRange then table.insert(ssfsBetweenOffsets, ssf) end
        end
    end
    return sort(ssfsBetweenOffsets, sortAscendingStartTime)
end
function uniqueNoteOffsetsBetween(startOffset, endOffset)
    local noteOffsetsBetween = {}
    for _, hitObject in pairs(map.HitObjects) do
        if hitObject.StartTime >= startOffset and hitObject.StartTime <= endOffset and ((state.SelectedScrollGroupId == hitObject.TimingGroup) or not BETA_IGNORE_NOTES_OUTSIDE_TG) then
            table.insert(noteOffsetsBetween, hitObject.StartTime)
            if (hitObject.EndTime ~= 0 and hitObject.EndTime <= endOffset) then
                table.insert(noteOffsetsBetween,
                    hitObject.EndTime)
            end
        end
    end
    noteOffsetsBetween = table.dedupe(noteOffsetsBetween)
    noteOffsetsBetween = sort(noteOffsetsBetween, sortAscending)
    return noteOffsetsBetween
end
function uniqueNoteOffsetsBetweenSelected()
    local selectedNoteOffsets = uniqueSelectedNoteOffsets()
    local startOffset = selectedNoteOffsets[1]
    local endOffset = selectedNoteOffsets[#selectedNoteOffsets]
    local offsets = uniqueNoteOffsetsBetween(startOffset, endOffset)
    if (#offsets < 2) then
        print("E!",
            "Warning: There are not enough notes in the current selection (within this timing group) to perform the action.")
    end
    return offsets
end
function uniqueSelectedNoteOffsets()
    local offsets = {}
    for i, hitObject in pairs(state.SelectedHitObjects) do
        offsets[i] = hitObject.StartTime
    end
    offsets = table.dedupe(offsets)
    offsets = sort(offsets, sortAscending)
    return offsets
end
function updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, skipFinalSV)
    local interlaceMultiplier = nil
    if menuVars.interlace then interlaceMultiplier = menuVars.interlaceRatio end
    menuVars.svMultipliers = generateSVMultipliers(currentSVType, settingVars, interlaceMultiplier)
    local svMultipliersNoEndSV = table.duplicate(menuVars.svMultipliers)
    table.remove(svMultipliersNoEndSV)
    menuVars.svDistances = calculateDistanceVsTime(globalVars, svMultipliersNoEndSV)
    updateFinalSV(settingVars.finalSVIndex, menuVars.svMultipliers, settingVars.customSV,
        skipFinalSV)
    updateSVStats(menuVars.svGraphStats, menuVars.svStats, menuVars.svMultipliers,
        svMultipliersNoEndSV, menuVars.svDistances)
end
function updateFinalSV(finalSVIndex, svMultipliers, customSV, skipFinalSV)
    if skipFinalSV then
        table.remove(svMultipliers)
        return
    end
    local finalSVType = FINAL_SV_TYPES[finalSVIndex]
    if finalSVType == "Normal" then return end
    svMultipliers[#svMultipliers] = customSV
end
function updateStutterMenuSVs(settingVars)
    settingVars.svMultipliers = generateSVMultipliers("Stutter1", settingVars, nil)
    local svMultipliersNoEndSV = table.duplicate(settingVars.svMultipliers)
    table.remove(svMultipliersNoEndSV)
    settingVars.svMultipliers2 = generateSVMultipliers("Stutter2", settingVars, nil)
    local svMultipliersNoEndSV2 = table.duplicate(settingVars.svMultipliers2)
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
function math.cubicBezier(p2, p3, t)
    return 3 * t * (1 - t) ^ 2 * p2 + 3 * t ^ 2 * (1 - t) * p3 + t ^ 3
end
function math.quadraticBezier(p2, t)
    return 2 * t * (1 - t) * p2 + t ^ 2
end
function math.clamp(number, lowerBound, upperBound)
    if number < lowerBound then return lowerBound end
    if number > upperBound then return upperBound end
    return number
end
function math.quarter(number)
    return math.floor(number * 4 + 0.5) / 4
end
function math.hermite(m1, m2, y2, t)
    local a = m1 + m2 - 2 * y2
    local b = 3 * y2 - 2 * m1 - m2
    local c = m1
    return a * t ^ 3 + b * t ^ 2 + c * t
end
---Returns a number that is `(weight * 100)%` of the way from travelling between `lowerBound` and `upperBound`.
---@param weight number
---@param lowerBound number
---@param upperBound number
---@return number
function math.lerp(weight, lowerBound, upperBound)
    return upperBound * weight + lowerBound * (1 - weight)
end
---Returns the weight of a number between `lowerBound` and `upperBound`.
---@param num number
---@param lowerBound number
---@param upperBound number
---@return number
function math.inverseLerp(num, lowerBound, upperBound)
    return (num - lowerBound) / (upperBound - lowerBound)
end
function math.round(number, decimalPlaces)
    if (not decimalPlaces) then decimalPlaces = 0 end
    local multiplier = 10 ^ decimalPlaces
    return math.floor(multiplier * number + 0.5) / multiplier
end
function math.sign(number)
    if number >= 0 then return 1 end
    return -1
end
function math.wrap(number, lowerBound, upperBound)
    if number < lowerBound then return upperBound end
    if number > upperBound then return lowerBound end
    return number
end
function addFinalSV(svsToAdd, endOffset, svMultiplier, force)
    local sv = map.GetScrollVelocityAt(endOffset)
    local svExistsAtEndOffset = sv and (sv.StartTime == endOffset)
    if svExistsAtEndOffset and not force then return end
    addSVToList(svsToAdd, endOffset, svMultiplier, true)
end
function addFinalSSF(ssfsToAdd, endOffset, ssfMultiplier, force)
    local ssf = map.GetScrollSpeedFactorAt(endOffset)
    local ssfExistsAtEndOffset = ssf and (ssf.StartTime == endOffset)
    if ssfExistsAtEndOffset and not force then return end
    addSSFToList(ssfsToAdd, endOffset, ssfMultiplier, true)
end
function addInitialSSF(ssfsToAdd, startOffset)
    local ssf = map.GetScrollSpeedFactorAt(startOffset)
    if (ssf == nil) then return end
    local ssfExistsAtStartOffset = ssf and (ssf.StartTime == startOffset)
    if ssfExistsAtStartOffset then return end
    addSSFToList(ssfsToAdd, startOffset, ssf.Multiplier, true)
end
function addStartSVIfMissing(svs, startOffset)
    if #svs ~= 0 and svs[1].StartTime == startOffset then return end
    addSVToList(svs, startOffset, getSVMultiplierAt(startOffset), false)
end
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
function removeAndAddSVs(svsToRemove, svsToAdd)
    local tolerance = 0.035
    if #svsToAdd == 0 then return end
    for idx, sv in pairs(svsToRemove) do
        local baseSV = getSVStartTimeAt(sv.StartTime)
        if (math.abs(baseSV - sv.StartTime) > tolerance) then
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
function ssf(startTime, multiplier)
    return utils.CreateScrollSpeedFactor(startTime, multiplier)
end
function simpleActionMenu(buttonText, minimumNotes, actionfunc, globalVars, menuVars, hideNoteReq, disableKeyInput)
    local enoughSelectedNotes = checkEnoughSelectedNotes(minimumNotes)
    local infoText = table.concat({ "Select ", minimumNotes, " or more notes" })
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
        toolTip("Press \'" .. GLOBAL_HOTKEY_LIST[1] .. "\' on your keyboard to do the same thing as this button")
        executeFunctionIfTrue(exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[1]), actionfunc, globalVars, menuVars)
    end
end
function executeFunctionIfTrue(boolean, func, globalVars, menuVars)
    if not boolean then return end
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
function getVariables(listName, variables)
    for key, _ in pairs(variables) do
        if (state.GetValue(listName .. key) ~= nil) then
            variables[key] = state.GetValue(listName .. key)
        end
    end
end
function saveVariables(listName, variables)
    for key, value in pairs(variables) do
        state.SetValue(listName .. key, value)
    end
end
---Returns the average value of a numeric table.
---@param values number[] The list of numbers.
---@param includeLastValue boolean Whether or not to include the last value in the table.
---@return number avg The arithmetic mean of the table.
function table.average(values, includeLastValue)
    if #values == 0 then return 0 end
    local sum = 0
    for _, value in pairs(values) do
        sum = sum + value
    end
    if not includeLastValue then
        sum = sum - values[#values]
        return sum / (#values - 1)
    end
    return sum / #values
end
---Concatenates two numeric tables together.
---@param t1 { [number]: any } The first table.
---@param t2 { [number]: any } The second table.
---@return { [number]: any } tbl The resultant table.
function table.combine(t1, t2)
    local newTbl = table.duplicate(t1)
    for i = 1, #t2 do
        table.insert(newTbl, t2[i])
    end
    return newTbl
end
---Creates a new numerical table with a custom metatable, allowing for `:` syntactic sugar.
---@vararg any Any entries to put into the table.
---@return table tbl A table with the given entries.
function table.construct(...)
    local tbl = {}
    for _, v in ipairs({ ... }) do
        table.insert(tbl, v)
    end
    setmetatable(tbl, { __index = table })
    return tbl
end
---Creates a new numerical table with a custom metatable, allowing for `:` syntactic sugar. All elements will be the given item.
---@param item any The entry to use.
---@param num integer The number of entries to put into the table.
---@return table tbl A table with the given entries.
function table.constructRepeating(item, num)
    local tbl = table.construct()
    for _ = 1, num do
        tbl:insert(item)
    end
    return tbl
end
---Returns a boolean value corresponding to whether or not an element exists within a table.
---@param tbl table The table to search in.
---@param item any The item to search for.
---@return boolean contains Whether or not the item given is within the table.
function table.contains(tbl, item)
    for _, v in pairs(tbl) do
        if (v == item) then return true end
    end
    return false
end
---Removes duplicate values from a table.
---@param tbl table The original table.
---@return table tbl A new table with no duplicates.
function table.dedupe(tbl)
    local hash = {}
    local newTbl = {}
    for _, value in ipairs(tbl) do
        if (not hash[value]) then
            newTbl[#newTbl + 1] = value
            hash[value] = true
        end
    end
    return newTbl
end
---Returns a deep copy of a table.
---@param tbl table The original table.
---@return table tbl The new table.
function table.duplicate(tbl)
    local dupeTbl = {}
    for _, value in ipairs(tbl) do
        table.insert(dupeTbl, value)
    end
    return dupeTbl
end
---Returns a table of keys from a table.
---@param tbl { [string]: any } The table to search in.
---@return string[] keys A list of keys.
function table.keys(tbl)
    local resultsTbl = {}
    for k, _ in pairs(tbl) do
        if (not table.contains(resultsTbl, k)) then
            table.insert(resultsTbl, k)
        end
    end
    return resultsTbl
end
---Normalizes a table of numbers to achieve a target average (NOT PURE)
---@param values number[] The table to normalize.
---@param targetAverage number The desired average value.
---@param includeLastValueInAverage boolean Whether or not to include the last value in the average.
function table.normalize(values, targetAverage, includeLastValueInAverage)
    local avgValue = table.average(values, includeLastValueInAverage)
    if avgValue == 0 then return end
    for i = 1, #values do
        values[i] = (values[i] * targetAverage) / avgValue
    end
end
---In a nested table `tbl`, returns a table of property values with key `property`.
---@param tbl { [string]: any } The table to search in.
---@param property string The property name.
---@return table properties The resultant table.
function table.property(tbl, property)
    local resultsTbl = {}
    for _, v in pairs(tbl) do
        table.insert(resultsTbl, v[property])
    end
    return resultsTbl
end
---Reverses the order of a numerically-indexed table.
---@param tbl table The original table.
---@return table tbl The original table, reversed.
function table.reverse(tbl)
    local reverseTbl = {}
    for i = 1, #tbl do
        table.insert(reverseTbl, tbl[#tbl + 1 - i])
    end
    return reverseTbl
end
function sortAscending(a, b) return a < b end
function sortAscendingStartTime(a, b) return a.StartTime < b.StartTime end
function sortAscendingTime(a, b) return a.time < b.time end
--- Sorts a table given a sorting function.
---@generic T
---@param tbl T[] The table to sort.
---@param compFn fun(a: T, b: T): boolean A comparison function. Given two elements `a` and `b`, how should they be sorted?
---@return T[] sortedTbl A sorted table.
function sort(tbl, compFn)
    newTbl = table.duplicate(tbl)
    table.sort(newTbl, compFn)
    return newTbl
end
--- Converts a table of length 4 into a [`Vector4`](lua://Vector4).
---@param tbl number[] The table to convert.
---@return Vector4 vctr The output vector.
function table.vectorize4(tbl)
    return vector.New(tbl[1], tbl[2], tbl[3], tbl[4])
end
--- Converts a table of length 3 into a [`Vector3`](lua://Vector3).
---@param tbl number[] The table to convert.
---@return Vector3 vctr The output vector.
function table.vectorize3(tbl)
    return vector.New(tbl[1], tbl[2], tbl[3])
end
--- Converts a table of length 2 into a [`Vector2`](lua://Vector2).
---@param tbl number[] The table to convert.
---@return Vector2 vctr The output vector.
function table.vectorize2(tbl)
    return vector.New(tbl[1], tbl[2])
end
---Creates a new [`Vector4`](lua://Vector4) with all elements being the given number.
---@param n number The number to use as the entries.
---@return Vector4 vctr The resultant vector of style `<n, n, n, n>`.
function vector4(n)
    return vector.New(n, n, n, n)
end
---Creates a new [`Vector3`](lua://Vector4) with all elements being the given number.
---@param n number The number to use as the entries.
---@return Vector3 vctr The resultant vector of style `<n, n, n>`.
function vector3(n)
    return vector.New(n, n, n)
end
---Creates a new [`Vector2`](lua://Vector2) with all elements being the given number.
---@param n number The number to use as the entries.
---@return Vector2 vctr The resultant vector of style `<n, n>`.
function vector2(n)
    return vector.New(n, n)
end
---Gets the current menu's setting variables.
---@param svType string The SV type - that is, the shape of the SV once plotted.
---@param label string A delineator to separate two categories with similar SV types (Standard/Still, etc).
---@return table
function getSettingVars(svType, label)
    local settingVars
    if svType == "Linear" then
        settingVars = {
            startSV = 1.5,
            endSV = 0.5,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Linear SSF" then
        settingVars = {
            lowerStart = 0.5,
            lowerEnd = 0.5,
            higherStart = 1,
            higherEnd = 1,
            resolution = 90,
            curvature = 0,
        }
    elseif svType == "Exponential" then
        settingVars = {
            behaviorIndex = 1,
            intensity = 30,
            verticalShift = 0,
            distance = 100,
            startSV = 0.01,
            endSV = 1,
            avgSV = 1,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1,
            distanceMode = 1
        }
    elseif svType == "Bezier" then
        settingVars = {
            x1 = 0,
            y1 = 0,
            x2 = 0,
            y2 = 1,
            verticalShift = 0,
            avgSV = 1,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Hermite" then
        settingVars = {
            startSV = 0,
            endSV = 0,
            verticalShift = 0,
            avgSV = 1,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Sinusoidal" then
        settingVars = {
            startSV = 2,
            endSV = 2,
            curveSharpness = 50,
            verticalShift = 1,
            periods = 1,
            periodsShift = 0.25,
            svsPerQuarterPeriod = 8,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Circular" then
        settingVars = {
            behaviorIndex = 1,
            arcPercent = 50,
            avgSV = 1,
            verticalShift = 0,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1,
            dontNormalize = false
        }
    elseif svType == "Random" then
        settingVars = {
            svMultipliers = {},
            randomTypeIndex = 1,
            randomScale = 2,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1,
            dontNormalize = false,
            avgSV = 1,
            verticalShift = 0
        }
    elseif svType == "Custom" then
        settingVars = {
            svMultipliers = { 0 },
            selectedMultiplierIndex = 1,
            svPoints = 1,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Chinchilla" then
        settingVars = {
            behaviorIndex = 1,
            chinchillaTypeIndex = 1,
            chinchillaIntensity = 0.5,
            avgSV = 1,
            verticalShift = 0,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Combo" then
        settingVars = {
            svType1Index = 1,
            svType2Index = 2,
            comboPhase = 0,
            comboTypeIndex = 1,
            comboMultiplier1 = 1,
            comboMultiplier2 = 1,
            finalSVIndex = 2,
            customSV = 1,
            dontNormalize = false,
            avgSV = 1,
            verticalShift = 0
        }
    elseif svType == "Stutter" then
        settingVars = {
            startSV = 1.5,
            endSV = 0.5,
            stutterDuration = 50,
            stuttersPerSection = 1,
            avgSV = 1,
            finalSVIndex = 2,
            customSV = 1,
            linearlyChange = false,
            controlLastSV = false,
            svMultipliers = {},
            svDistances = {},
            svGraphStats = createSVGraphStats(),
            svMultipliers2 = {},
            svDistances2 = {},
            svGraph2Stats = createSVGraphStats()
        }
    elseif svType == "Teleport Stutter" then
        settingVars = {
            svPercent = 50,
            svPercent2 = 0,
            distance = 50,
            mainSV = 0.5,
            mainSV2 = 0,
            useDistance = false,
            linearlyChange = false,
            avgSV = 1,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Splitscroll (Basic)" then
        settingVars = {
            scrollSpeed1 = 0.9,
            height1 = 0,
            scrollSpeed2 = -0.9,
            height2 = 400,
            distanceBack = 1000000,
            msPerFrame = 16,
            noteTimes2 = {},
        }
    elseif svType == "Splitscroll (Advanced)" then
        settingVars = {
            numScrolls = 2,
            msPerFrame = 16,
            scrollIndex = 1,
            distanceBack = 1000000,
            distanceBack2 = 1000000,
            distanceBack3 = 1000000,
            noteTimes2 = {},
            noteTimes3 = {},
            noteTimes4 = {},
            svsInScroll1 = {},
            svsInScroll2 = {},
            svsInScroll3 = {},
            svsInScroll4 = {}
        }
    elseif svType == "Splitscroll (Adv v2)" then
        settingVars = {
            numScrolls = 2,
            msPerFrame = 16,
            scrollIndex = 1,
            distanceBack = 1000000,
            distanceBack2 = 1000000,
            distanceBack3 = 1000000,
            splitscrollLayers = {}
        }
    elseif svType == "Frames Setup" then
        settingVars = {
            menuStep = 1,
            numFrames = 5,
            frameDistance = 2000,
            distance = 2000,
            reverseFrameOrder = false,
            noteSkinTypeIndex = 1,
            frameTimes = {},
            selectedTimeIndex = 1,
            currentFrame = 1
        }
    elseif svType == "Penis" then
        settingVars = {
            bWidth = 50,
            sWidth = 100,
            sCurvature = 100,
            bCurvature = 100
        }
    elseif svType == "Automate" then
        settingVars = {
            copiedSVs = {},
            maintainMs = true,
            ms = 1000
        }
    end
    local labelText = table.concat({ svType, "Settings", label })
    getVariables(labelText, settingVars)
    return settingVars
end
function truthy(param)
    local t = type(param)
    if (t == "string") then
        return param:lower() == "true" and true or false
    else
        if t == "number" then
            return param > 0 and true or false
        else
            if t == "table" or t == "userdata" then
                return #param > 0 and true or false
            else
                if t == "boolean" then
                    return param
                else
                    return false
                end
            end
        end
    end
end