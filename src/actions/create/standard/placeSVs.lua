-- Places standard SVs between selected notes
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    menuVars   : list of variables used for the current menu [Table]
function placeSVs(globalVars, menuVars, place, optionalStart, optionalEnd, optionalDistance)
    local finalSVType = FINAL_SV_TYPES[menuVars.settingVars.finalSVIndex]
    local placingStillSVs = menuVars.noteSpacing ~= nil
    local numMultipliers = #menuVars.svMultipliers
    local offsets = uniqueSelectedNoteOffsets()
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
                table.sort(svsToAdd, sortAscendingStartTime), svsToAdd)
            svsToAdd = table.combine(svsToAdd, tbl.svsToAdd)
        end
        addFinalSV(svsToAdd, lastOffset, lastMultiplier, finalSVType == "Override")
        removeAndAddSVs(svsToRemove, svsToAdd)
        return
    end
    local tbl = getStillSVs(menuVars, firstOffset, lastOffset,
        table.sort(svsToAdd, sortAscendingStartTime), svsToAdd)
    svsToRemove = table.combine(svsToRemove, tbl.svsToRemove)
    svsToAdd = table.combine(svsToAdd, tbl.svsToAdd)
    return { svsToRemove = svsToRemove, svsToAdd = svsToAdd }
end
