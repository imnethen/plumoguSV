function verticalShiftSVs(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not truthy(offsets)) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsToAdd = {}
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
    local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
    addStartSVIfMissing(svsBetweenOffsets, startOffset)
    for _, sv in ipairs(svsBetweenOffsets) do
        local newSVMultiplier = sv.Multiplier + menuVars.verticalShift
        addSVToList(svsToAdd, sv.StartTime, newSVMultiplier, true)
    end
    removeAndAddSVs(svsToRemove, svsToAdd)
end
