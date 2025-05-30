-- Merges overlapping SVs between selected notes
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
