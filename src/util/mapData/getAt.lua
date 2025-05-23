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

-- Returns the SV multiplier at a specified offset in the map [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getSVMultiplierAt(offset)
    local sv = map.GetScrollVelocityAt(offset)
    if sv then return sv.Multiplier end
    return map.InitialScrollVelocity or 1
end

function getTimingPointAt(offset)
    local line = map.GetTimingPointAt(offset)
    if line then return line end
    return { StartTime = 0, Bpm = 100 }
end
