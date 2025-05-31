-- Returns the SV multiplier at a specified offset in the map [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getHypotheticalSVMultiplierAt(svs, offset)
    if (#svs == 1) then return svs[1].Multiplier end
    local index = #svs
    while (index >= 1) do
        if (svs[index].StartTime > offset) then
            index = index - 1
        else
            return svs[index].Multiplier
        end
    end
    return 1
end

function getHypotheticalSVTimeAt(svs, offset)
    if (#svs == 1) then return svs[1].StartTime end
    local index = #svs
    while (index >= 1) do
        if (svs[index].StartTime > offset) then
            index = index - 1
        else
            return svs[index].StartTime
        end
    end
    return 1
end

-- Returns the most recent SV's starttime [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getSVStartTimeAt(offset)
    local sv = map.GetScrollVelocityAt(offset)
    if sv then return sv.StartTime end
    return -1
end

-- Returns the SV multiplier at a specified offset in the map [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getSVMultiplierAt(offset)
    local sv = map.GetScrollVelocityAt(offset)
    if sv then return sv.Multiplier end
    return map.InitialScrollVelocity or 1
end

-- Returns the SSF multiplier at a specified offset in the map [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getSSFMultiplierAt(offset)
    local ssf = map.GetScrollSpeedFactorAt(offset)
    if ssf then return ssf.Multiplier end
    return 1
end

function getTimingPointAt(offset)
    local line = map.GetTimingPointAt(offset)
    if line then return line end
    return { StartTime = -69420, Bpm = 42.69 }
end
