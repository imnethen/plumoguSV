function tempBugFix()
    local ptr = 0
    local svsToRemove = {}
    for _, sv in pairs(map.ScrollVelocities) do
        if (math.abs(ptr - sv.StartTime) < 0.035) then
            table.insert(svsToRemove, sv)
        end
        ptr = sv.StartTime
    end
    actions.RemoveScrollVelocityBatch(svsToRemove)
end