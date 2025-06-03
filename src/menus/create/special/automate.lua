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
        imgui.SameLine(0, SAMELINE_SPACING)
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
    print("w!", "Automated.")
end
