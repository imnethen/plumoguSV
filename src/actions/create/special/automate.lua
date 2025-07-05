function automateCopySVs(settingVars)
    settingVars.copiedSVs = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not truthy(offsets)) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svs = getSVsBetweenOffsets(startOffset, endOffset)
    if (not #svs or #svs == 0) then
        toggleablePrint("w!", "No SVs found within the copiable region.")
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
    if (#settingVars.copiedSVs > 0) then toggleablePrint("s!", "Copied " .. #settingVars.copiedSVs .. " SVs.") end
end

function clearAutomateSVs(settingVars)
    settingVars.copiedSVs = {}
end

function automateSVs(settingVars)
    local selected = state.SelectedHitObjects

    local timeDict = {}
    local noteTimes = {}

    for _, ho in pairs(selected) do
        if (not table.contains(table.keys(timeDict), "t_" .. ho.StartTime)) then
            timeDict["t_" .. ho.StartTime] = { ho }
            table.insert(noteTimes, ho.StartTime)
        else
            table.insert(timeDict["t_" .. ho.StartTime], ho)
        end
    end

    local ids = utils.GenerateTimingGroupIds(#table.keys(timeDict), "automate_")
    local actionList = {}
    noteTimes = sort(noteTimes, sortAscending)
    local timeSinceLastTgRefresh = 0
    local maintainedTgId = 0
    local timeCodedSVDict = {}

    for noteIndex, noteTime in ipairs(noteTimes) do
        timeSinceLastTgRefresh = timeSinceLastTgRefresh +
            (noteTimes[noteIndex] - noteTimes[math.clamp(noteIndex - 1, 1, 1e69)])
        if (timeSinceLastTgRefresh > settingVars.ms and settingVars.maintainMs) then
            timeSinceLastTgRefresh = timeSinceLastTgRefresh - settingVars.ms
            maintainedTgId         = 1
        else
            maintainedTgId = maintainedTgId + 1
        end
        for i, sv in ipairs(settingVars.copiedSVs) do
            if (settingVars.maintainMs) then
                local timeDistance = settingVars.copiedSVs[#settingVars.copiedSVs].relativeOffset -
                    settingVars.copiedSVs[1].relativeOffset
                local progress = sv.relativeOffset / timeDistance
                local timeToPasteSV = noteTime - settingVars.ms * (1 - progress)
                local multiplier = sv.multiplier * (settingVars.scaleSVs and noteIndex or 1)
                if (not timeCodedSVDict["t_" .. noteTime]) then timeCodedSVDict["t_" .. noteTime] = {} end
                table.insert(timeCodedSVDict["t_" .. noteTime], utils.CreateScrollVelocity(timeToPasteSV, multiplier))
                id = ids[maintainedTgId]
            else
                local timeToPasteSV = noteTime -
                    (#settingVars.copiedSVs - i) / (#settingVars.copiedSVs - 1) * (noteTime - selected[1].StartTime)
                local multiplier = sv.multiplier * (settingVars.scaleSVs and 1 / noteIndex or 1)
                if (not timeCodedSVDict["t_" .. noteTime]) then timeCodedSVDict["t_" .. noteTime] = {} end
                table.insert(timeCodedSVDict["t_" .. noteTime], utils.CreateScrollVelocity(timeToPasteSV, multiplier))
                id = ids[noteIndex]
            end
        end
    end

    for timeCode, svs in ipairs(timeCodedSVDict) do
        local r = math.random(255)
        local g = math.random(255)
        local b = math.random(255)
        local tg = utils.CreateScrollGroup(svs, 1, r .. "," .. g .. "," .. b)

        table.insert(actionList, utils.CreateEditorAction(action_type.CreateTimingGroup, id, tg, timeDict[timeCode]))
    end

    actions.PerformBatch(actionList)
    toggleablePrint("w!", "Automated.")
end
