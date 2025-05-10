function deleteItems(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
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
    if (#linesToRemove > 0 or #svsToRemove > 0 or #ssfsToRemove > 0 or #bmsToRemove > 0) then
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
end
