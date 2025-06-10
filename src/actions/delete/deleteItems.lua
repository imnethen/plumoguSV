function deleteItems(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not truthy(offsets)) then return end
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
    if (truthy(linesToRemove) or truthy(svsToRemove) or truthy(ssfsToRemove) or truthy(bmsToRemove)) then
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
    if (truthy(#linesToRemove)) then
        print("error!", "Deleted " .. #linesToRemove .. (#linesToRemove == 1 and " timing point." or " timing points."))
    end
    if (truthy(#svsToRemove)) then
        print("error!",
            "Deleted " .. #svsToRemove .. (#svsToRemove == 1 and " scroll velocity." or " scroll velocities."))
    end
    if (truthy(#ssfsToRemove)) then
        print("error!",
            "Deleted " .. #ssfsToRemove .. (#ssfsToRemove == 1 and " scroll speed factor." or " scroll speed factors."))
    end
    if (truthy(#bmsToRemove)) then
        print("error!", "Deleted " .. #bmsToRemove .. (#bmsToRemove == 1 and " bookmark." or " bookmarks."))
    end
end
