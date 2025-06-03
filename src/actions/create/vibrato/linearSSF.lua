function linearSSFVibrato(menuVars, settingVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startTime = offsets[1]
    local endTime = offsets[#offsets]
    local fps = VIBRATO_FRAME_RATES[menuVars.vibratoQuality]
    local delta = 1000 / fps
    local time = startTime
    local ssfs = { ssf(startTime - 1 / getUsableDisplacementMultiplier(startTime),
        getSSFMultiplierAt(time)) }
    while time < endTime do
        local x = ((time - startTime) / (endTime - startTime))
        local y = ((time + delta - startTime) / (endTime - startTime))
        table.insert(ssfs,
            ssf(time - 1 / getUsableDisplacementMultiplier(time),
                settingVars.higherStart + x * (settingVars.higherEnd - settingVars.higherStart)))
        table.insert(ssfs, ssf(time, settingVars.lowerStart + x * (settingVars.lowerEnd - settingVars.lowerStart)))
        table.insert(ssfs,
            ssf(time + delta - 1 / getUsableDisplacementMultiplier(time),
                settingVars.lowerStart + y * (settingVars.lowerEnd - settingVars.lowerStart)))
        table.insert(ssfs,
            ssf(time + delta, settingVars.higherStart + y * (settingVars.higherEnd - settingVars.higherStart)))
        time = time + 2 * delta
    end

    actions.PerformBatch({
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfs)
    })
    print("s!", "Created " .. #ssfs .. (#ssfs == 1 and "SSF." or "SSFs."))
end
