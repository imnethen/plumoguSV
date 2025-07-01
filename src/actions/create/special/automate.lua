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

    for _, ho in pairs(selected) do
        if (not table.contains(table.keys(timeDict), "t_" .. ho.StartTime)) then
            timeDict["t_" .. ho.StartTime] = { ho }
        else
            table.insert(timeDict["t_" .. ho.StartTime], ho)
        end
    end

    local ids = utils.GenerateTimingGroupIds(#table.keys(timeDict), "automate_")
    local index = 1

    local actionList = {}

    for timeCode, hos in pairs(timeDict) do
        local noteTime = tonumber(timeCode:sub(3))
        local svsToAdd = {}
        for i, sv in ipairs(settingVars.copiedSVs) do
            if (settingVars.maintainMs) then
                local timeDistance = settingVars.copiedSVs[#settingVars.copiedSVs].relativeOffset -
                    settingVars.copiedSVs[1].relativeOffset
                local progress = sv.relativeOffset / timeDistance
                local timeToPasteSV = noteTime - settingVars.ms * (1 - progress)
                table.insert(svsToAdd, utils.CreateScrollVelocity(timeToPasteSV, sv.multiplier))
            else
                local timeToPasteSV = noteTime -
                    (#settingVars.copiedSVs - i) / (#settingVars.copiedSVs - 1) * (noteTime - selected[1].StartTime)
                table.insert(svsToAdd, utils.CreateScrollVelocity(timeToPasteSV, sv.multiplier))
            end
        end
        local r = math.random(255)
        local g = math.random(255)
        local b = math.random(255)
        local tg = utils.CreateScrollGroup(svsToAdd, 1, r .. "," .. g .. "," .. b)
        local id = ids[index]
        table.insert(actionList, utils.CreateEditorAction(action_type.CreateTimingGroup, id, tg, hos))
        index = index + 1
    end
    actions.PerformBatch(actionList)
    toggleablePrint("w!", "Automated.")
end
