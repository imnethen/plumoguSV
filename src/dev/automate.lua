function automateSVMenu(globalVars)
    local menuVars = {
        copiedSVs = {},
        maintainMs = true,
        ms = 1000
    }
    addSeparator()
    getVariables("copyMenu", menuVars)
    local copiedSVCount = #menuVars.copiedSVs

    if (copiedSVCount == 0) then
        simpleActionMenu("Copy SVs between selected notes", 2, automateCopySVs, nil, menuVars)
        saveVariables("copyMenu", menuVars)
        return
    end

    button("Clear copied items", ACTION_BUTTON_SIZE, clearAutomateSVs, nil, menuVars)
    addSeparator()
    _, menuVars.maintainMs = imgui.Checkbox("Maintain Time?", true)
    if (menuVars.maintainMs) then
        imgui.SameLine()
        imgui.PushItemWidth(90)
        menuVars.ms = computableInputFloat("Time", menuVars.ms, 2, "ms")
        imgui.PopItemWidth()
    end
    addSeparator()
    simpleActionMenu("Automate SVs for selected notes", 1, automateSVs, nil, menuVars)

    saveVariables("copyMenu", menuVars)
end

function automateCopySVs(menuVars)
    menuVars.copiedSVs = {}
    local offsets = uniqueSelectedNoteOffsets()
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svs = getSVsBetweenOffsets(startOffset, endOffset)
    if (not #svs) then
        print("W!", "No SVs found within the copiable region.")
        return
    end
    local firstSVTime = svs[1].StartTime
    for _, sv in pairs(getSVsBetweenOffsets(startOffset, endOffset)) do
        local copiedSV = {
            relativeOffset = sv.StartTime - firstSVTime,
            multiplier = sv.Multiplier
        }
        table.insert(menuVars.copiedSVs, copiedSV)
    end
    if (#menuVars.copiedSVs > 0) then print("S!", "Copied " .. #menuVars.copiedSVs .. " SVs") end
end

function clearAutomateSVs(menuVars)
    menuVars.copiedSVs = {}
end

function automateSVs(menuVars)
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
        for _, sv in ipairs(menuVars.copiedSVs) do
            local timeDistance = menuVars.copiedSVs[#menuVars.copiedSVs].relativeOffset -
                menuVars.copiedSVs[1].relativeOffset
            local progress = sv.relativeOffset / timeDistance
            local timeToPasteSV = startTime - menuVars.ms * (1 - progress)
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
