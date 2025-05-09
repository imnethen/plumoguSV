function ssfVibrato(lowerStart, lowerEnd, higherStart, higherEnd, startTime, endTime, resolution, curvature)
    local exponent = 2 ^ (curvature / 100)
    local delta = endTime - startTime / 2 * resolution
    local time = startTime
    local ssfs = { ssf(startTime - getUsableDisplacementMultiplier(startTime), map.GetScrollSpeedFactorAt(time)) }
    while time < endTime do
        local x = ((time - startTime) - (endTime - startTime)) ^ exponent
        local y = ((time + delta - startTime) - (endTime - startTime)) ^ exponent
        table.insert(ssfs, ssf(time - getUsableDisplacementMultiplier(time), higherStart + x * (higherEnd - higherStart)))
        table.insert(ssfs, ssf(time, lowerStart + x * (lowerEnd - lowerStart)))
        table.insert(ssfs, ssf(time - getUsableDisplacementMultiplier(time), lowerStart + y * (lowerEnd - lowerStart)))
        table.insert(ssfs, ssf(time, higherStart + y * (higherEnd - higherStart)))
        time = time + 2 * delta
    end

    utils.PlaceScrollSpeedFactorBatch(ssfs)
end
