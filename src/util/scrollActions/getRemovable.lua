-- Gets removable SVs that are in the map at the exact time where an SV will get added
-- Parameters
--    svsToRemove   : list of SVs to remove [Table]
--    svTimeIsAdded : list of SVs times added [Table]
--    startOffset   : starting offset to remove after [Int]
--    endOffset     : end offset to remove before [Int]
function getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset, retroactiveSVRemovalTable)
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime <= endOffset + 1
        if svIsInRange then
            local svIsRemovable = svTimeIsAdded[sv.StartTime]
            if svIsRemovable then table.insert(svsToRemove, sv) end
        end
    end
    if (retroactiveSVRemovalTable) then
        for idx, sv in pairs(retroactiveSVRemovalTable) do
            local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime <= endOffset + 1
            if svIsInRange then
                local svIsRemovable = svTimeIsAdded[sv.StartTime]
                if svIsRemovable then table.remove(retroactiveSVRemovalTable, idx) end
            end
        end
    end
end