function linearSSFVibrato(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    local startTime = offsets[1]
    local endTime = offsets[#offsets]
    local exponent = 2 ^ (menuVars.curvature / 100)
    local delta = 500 / menuVars.resolution
    local time = startTime
    local ssfs = { ssf(startTime - 1 / getUsableDisplacementMultiplier(startTime),
        map.GetScrollSpeedFactorAt(time).Multiplier or 1) }
    while time < endTime do
        local x = ((time - startTime) / (endTime - startTime)) ^ exponent
        local y = ((time + delta - startTime) / (endTime - startTime)) ^ exponent
        table.insert(ssfs,
            ssf(time - 1 / getUsableDisplacementMultiplier(time),
                menuVars.higherStart + x * (menuVars.higherEnd - menuVars.higherStart)))
        table.insert(ssfs, ssf(time, menuVars.lowerStart + x * (menuVars.lowerEnd - menuVars.lowerStart)))
        table.insert(ssfs,
            ssf(time + delta - 1 / getUsableDisplacementMultiplier(time),
                menuVars.lowerStart + y * (menuVars.lowerEnd - menuVars.lowerStart)))
        table.insert(ssfs, ssf(time + delta, menuVars.higherStart + y * (menuVars.higherEnd - menuVars.higherStart)))
        time = time + 2 * delta
    end

    actions.PerformBatch({
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfs)
    })
end
