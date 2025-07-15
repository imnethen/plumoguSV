function copyItems(menuVars)
    menuVars.copiedLines = {}
    menuVars.copiedSVs = {}
    menuVars.copiedSSFs = {}
    menuVars.copiedBMs = {}
    local offsets = uniqueSelectedNoteOffsets()
    if (not truthy(offsets)) then return end
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
    if (#menuVars.copiedBMs > 0) then toggleablePrint("s!", "Copied " .. #menuVars.copiedBMs .. " Bookmarks.") end
    if (#menuVars.copiedSSFs > 0) then toggleablePrint("s!", "Copied " .. #menuVars.copiedSSFs .. " SSFs.") end
    if (#menuVars.copiedSVs > 0) then toggleablePrint("s!", "Copied " .. #menuVars.copiedSVs .. " SVs.") end
    if (#menuVars.copiedLines > 0) then toggleablePrint("s!", "Copied " .. #menuVars.copiedLines .. " Lines.") end
end

function clearCopiedItems(menuVars)
    menuVars.copiedLines = {}
    menuVars.copiedSVs = {}
    menuVars.copiedSSFs = {}
    menuVars.copiedBMs = {}
end

function pasteItems(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not truthy(offsets)) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local lastCopiedLine = menuVars.copiedLines[#menuVars.copiedLines]
    local lastCopiedSV = menuVars.copiedSVs[#menuVars.copiedSVs]
    local lastCopiedSSF = menuVars.copiedSSFs[#menuVars.copiedSSFs]
    local lastCopiedBM = menuVars.copiedBMs[#menuVars.copiedBMs]

    local lastCopiedValue = lastCopiedSV
    if (lastCopiedValue == nil) then
        lastCopiedValue = lastCopiedSSF
        lastCopiedValue = lastCopiedLine
        lastCopiedValue = lastCopiedBM
    end

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
    local hitObjectTimes = table.property(map.HitObjects, "StartTime")
    for i = 1, #offsets do
        local pasteOffset = offsets[i]
        local nextOffset = offsets[math.clamp(i + 1, 1, #offsets)]
        local ignoranceTolerance = 0.01
        for _, line in ipairs(menuVars.copiedLines) do
            local timeToPasteLine = pasteOffset + line.relativeOffset
            if (math.abs(timeToPasteLine - nextOffset) < ignoranceTolerance and i ~= #offsets) then
                goto skip1
            end
            table.insert(linesToAdd, utils.CreateTimingPoint(timeToPasteLine, line.bpm, line.signature, line.hidden))
            ::skip1::
        end
        for _, sv in ipairs(menuVars.copiedSVs) do
            local timeToPasteSV = pasteOffset + sv.relativeOffset
            if (math.abs(timeToPasteSV - nextOffset) < ignoranceTolerance and i ~= #offsets) then
                goto skip2
            end
            if menuVars.tryAlign then
                timeToPasteSV = tryAlignToHitObjects(timeToPasteSV, hitObjectTimes, menuVars.alignWindow)
            end
            table.insert(svsToAdd, createSV(timeToPasteSV, sv.multiplier))
            ::skip2::
        end
        for _, ssf in ipairs(menuVars.copiedSSFs) do
            local timeToPasteSSF = pasteOffset + ssf.relativeOffset
            if (math.abs(timeToPasteSSF - nextOffset) < ignoranceTolerance and i ~= #offsets) then
                goto skip3
            end
            table.insert(ssfsToAdd, createSSF(timeToPasteSSF, ssf.multiplier))
            ::skip3::
        end
        for _, bm in ipairs(menuVars.copiedBMs) do
            local timeToPasteBM = pasteOffset + bm.relativeOffset
            if (math.abs(timeToPasteBM - nextOffset) < ignoranceTolerance and i ~= #offsets) then
                goto skip4
            end
            table.insert(bmsToAdd, utils.CreateBookmark(timeToPasteBM, bm.note))
            ::skip4::
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
    if (truthy(#linesToRemove)) then
        toggleablePrint("e!", "Deleted " .. #linesToRemove .. pluralize(" timing point.", #linesToRemove, -2))
    end
    if (truthy(#svsToRemove)) then
        toggleablePrint("e!",
            "Deleted " .. #svsToRemove .. pluralize(" scroll velocity.", #svsToRemove, -2))
    end
    if (truthy(#ssfsToRemove)) then
        toggleablePrint("e!",
            "Deleted " .. #ssfsToRemove .. pluralize(" scroll speed factor.", #ssfsToRemove, -2))
    end
    if (truthy(#bmsToRemove)) then
        toggleablePrint("e!", "Deleted " .. #bmsToRemove .. pluralize(" bookmark.", #bmsToRemove, -2))
    end
    if (truthy(#linesToAdd)) then
        toggleablePrint("s!", "Created " .. #linesToAdd .. pluralize(" timing point.", #linesToAdd, -2))
    end
    if (truthy(#svsToAdd)) then
        toggleablePrint("s!",
            "Created " .. #svsToAdd .. pluralize(" scroll velocity.", #svsToAdd, -2))
    end
    if (truthy(#ssfsToAdd)) then
        toggleablePrint("s!",
            "Created " .. #ssfsToAdd .. pluralize(" scroll speed factor.", #ssfsToAdd, -2))
    end
    if (truthy(#bmsToAdd)) then
        toggleablePrint("s!", "Created " .. #bmsToAdd .. pluralize(" bookmark.", #bmsToAdd, -2))
    end
end

function tryAlignToHitObjects(time, hitObjectTimes, alignWindow)
    if not truthy(#hitObjectTimes) then
        return time
    end

    local closestTime = table.searchClosest(hitObjectTimes, time)

    if math.abs(closestTime - time) > alignWindow then
        return time
    end

    time = math.frac(time) + closestTime - 1
    if math.abs(closestTime - (time + 1)) < math.abs(closestTime - time) then
        time = time + 1
    end

    return time
end
