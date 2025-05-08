
-- Copies SVs between selected notes
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function copyItems(menuVars)
    menuVars.copiedLines = {}
    menuVars.copiedSVs = {}
    menuVars.copiedSSFs = {}
    menuVars.copiedBMs = {}
    local offsets = uniqueSelectedNoteOffsets()
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

-- Clears all copied SVs
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function clearCopiedItems(menuVars)
    menuVars.copiedLines = {}
    menuVars.copiedSVs = {}
    menuVars.copiedSSFs = {}
    menuVars.copiedBMs = {}
end

-- Pastes copied SVs at selected notes
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    menuVars   : list of variables used for the current menu [Table]
function pasteItems(globalVars, menuVars)
    local offsets = uniqueSelectedNoteOffsets()
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