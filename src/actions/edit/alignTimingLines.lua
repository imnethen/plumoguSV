function alignTimingLines()
    local timingpoint = state.CurrentTimingPoint
    local starttime = timingpoint.StartTime
    local length = map.GetTimingPointLength(timingpoint)
    local endtime = starttime + length
    local signature = tonumber(timingpoint.Signature)
    local bpm = timingpoint.Bpm

    local mspb = 60000 / bpm
    local msptl = mspb * signature

    local noteTimes = {}

    for _, n in pairs(map.HitObjects) do
        table.insert(noteTimes, n.StartTime)
    end

    local times = {}
    local timingpoints = {}
    for time = starttime, endtime, msptl do
        local originalTime = math.floor(time)
        while (noteTimes[1] < originalTime - 5) do
            table.remove(noteTimes, 1)
        end
        if (math.abs(noteTimes[1] - originalTime) <= 5) then
            table.insert(times, noteTimes[1])
        else
            table.insert(times, originalTime)
        end
    end
    for _, time in pairs(times) do
        table.insert(timingpoints, utils.CreateTimingPoint(time, bpm, signature))
    end
    actions.PerformBatch({
        utils.CreateEditorAction(action_type.AddTimingPointBatch, timingpoints),
        utils.CreateEditorAction(action_type.RemoveTimingPoint, timingpoint)
    })

    toggleablePrint("s!", "Created " .. #timingpoints .. pluralize(" timing point.", #timingpoints, -2))
end
