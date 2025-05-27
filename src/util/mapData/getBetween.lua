--- Returns a list of [hit objects](lua://HitObject) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return HitObject[] objs All of the [hit objects](lua://HitObject) within the area.
function getNotesBetweenOffsets(startOffset, endOffset)
    local notesBetweenOffsets = {} ---@type HitObject[]
    for _, note in pairs(map.HitObjects) do
        local noteIsInRange = note.StartTime >= startOffset and note.StartTime <= endOffset
        if noteIsInRange then table.insert(notesBetweenOffsets, note) end
    end
    return sort(notesBetweenOffsets, sortAscendingStartTime)
end

--- Returns a list of [timing points](lua://TimingPoint) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return TimingPoint[] tps All of the [timing points](lua://TimingPoint) within the area.
function getLinesBetweenOffsets(startOffset, endOffset)
    local linesBetweenoffsets = {} ---@type TimingPoint[]
    for _, line in pairs(map.TimingPoints) do
        local lineIsInRange = line.StartTime >= startOffset and line.StartTime < endOffset
        if lineIsInRange then table.insert(linesBetweenoffsets, line) end
    end
    return sort(linesBetweenoffsets, sortAscendingStartTime)
end

--- Returns a list of [scroll velocities](lua://ScrollVelocity) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return ScrollVelocity[] svs All of the [scroll velocities](lua://ScrollVelocity) within the area.
function getSVsBetweenOffsets(startOffset, endOffset)
    local svsBetweenOffsets = {} ---@type ScrollVelocity[]
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset and sv.StartTime < endOffset
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return sort(svsBetweenOffsets, sortAscendingStartTime)
end

--- Returns a list of [bookmarks](lua://Bookmark) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return Bookmark[] bms All of the [bookmarks](lua://Bookmark) within the area.
function getBookmarksBetweenOffsets(startOffset, endOffset)
    local bookmarksBetweenOffsets = {} ---@type Bookmark[]
    for _, bm in pairs(map.Bookmarks) do
        local bmIsInRange = bm.StartTime >= startOffset and bm.StartTime < endOffset
        if bmIsInRange then table.insert(bookmarksBetweenOffsets, bm) end
    end
    return sort(bookmarksBetweenOffsets, sortAscendingStartTime)
end

--- Given a predetermined set of SVs, returns a list of [scroll velocities](lua://ScrollVelocity) within a temporal boundary.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return ScrollVelocity[] svs All of the [scroll velocities](lua://ScrollVelocity) within the area.
function getHypotheticalSVsBetweenOffsets(svs, startOffset, endOffset)
    local svsBetweenOffsets = {} --- @type ScrollVelocity[]
    for _, sv in pairs(svs) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime < endOffset + 1
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return sort(svsBetweenOffsets, sortAscendingStartTime)
end

--- Returns a list of [scroll speed factors](lua://ScrollSpeedFactor) between two times, inclusive.
---@param startOffset number The lower bound of the search area.
---@param endOffset number The upper bound of the search area.
---@return ScrollSpeedFactor[] ssfs All of the [scroll speed factors](lua://ScrollSpeedFactor) within the area.
function getSSFsBetweenOffsets(startOffset, endOffset)
    local ssfsBetweenOffsets = {} ---@type ScrollSpeedFactor[]
    local ssfs = map.ScrollSpeedFactors
    if (ssfs == nil) then
        ssfs = {}
    else
        for _, ssf in pairs(map.ScrollSpeedFactors) do
            local ssfIsInRange = ssf.StartTime >= startOffset and ssf.StartTime < endOffset
            if ssfIsInRange then table.insert(ssfsBetweenOffsets, ssf) end
        end
    end
    return sort(ssfsBetweenOffsets, sortAscendingStartTime)
end
