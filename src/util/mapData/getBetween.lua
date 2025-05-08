
function getNotesBetweenOffsets(startOffset, endOffset)
    local notesBetweenOffsets = {}
    for _, note in pairs(map.HitObjects) do
        local noteIsInRange = note.StartTime >= startOffset and note.StartTime <= endOffset
        if noteIsInRange then table.insert(notesBetweenOffsets, note) end
    end
    return table.sort(notesBetweenOffsets, sortAscendingStartTime)
end

function getLinesBetweenOffsets(startOffset, endOffset)
    local linesBetweenoffsets = {}
    for _, line in pairs(map.TimingPoints) do
        local lineIsInRange = line.StartTime >= startOffset and line.StartTime < endOffset
        if lineIsInRange then table.insert(linesBetweenoffsets, line) end
    end
    return table.sort(linesBetweenoffsets, sortAscendingStartTime)
end

function getSVsBetweenOffsets(startOffset, endOffset)
    local svsBetweenOffsets = {}
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset and sv.StartTime < endOffset
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return table.sort(svsBetweenOffsets, sortAscendingStartTime)
end

function getBookmarksBetweenOffsets(startOffset, endOffset)
    local bookmarksBetweenOffsets = {}
    for _, bm in pairs(map.Bookmarks) do
        local bmIsInRange = bm.StartTime >= startOffset and bm.StartTime < endOffset
        if bmIsInRange then table.insert(bookmarksBetweenOffsets, bm) end
    end
    return table.sort(bookmarksBetweenOffsets, sortAscendingStartTime)
end

function getHypotheticalSVsBetweenOffsets(svs, startOffset, endOffset)
    local svsBetweenOffsets = {}
    for _, sv in pairs(svs) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime < endOffset + 1
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return table.sort(svsBetweenOffsets, sortAscendingStartTime)
end

function getSSFsBetweenOffsets(startOffset, endOffset)
    local ssfsBetweenOffsets = {}
    local ssfs = map.ScrollSpeedFactors
    if (ssfs == nil) then
        ssfs = {}
    else
        for _, ssf in pairs(map.ScrollSpeedFactors) do
            local ssfIsInRange = ssf.StartTime >= startOffset and ssf.StartTime < endOffset
            if ssfIsInRange then table.insert(ssfsBetweenOffsets, ssf) end
        end
    end
    return table.sort(ssfsBetweenOffsets, sortAscendingStartTime)
end