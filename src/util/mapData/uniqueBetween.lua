-- Finds and returns a list of all unique offsets of notes between a start and an end time [Table]
-- Parameters
--    startOffset : start time in milliseconds [Int/Float]
--    endOffset   : end time in milliseconds [Int/Float]
function uniqueNoteOffsetsBetween(startOffset, endOffset, includeLN)
    local noteOffsetsBetween = {}
    for _, hitObject in pairs(map.HitObjects) do
        if hitObject.StartTime >= startOffset and hitObject.StartTime <= endOffset and ((state.SelectedScrollGroupId == hitObject.TimingGroup) or not state.GetValue("global_ignoreNotes", false)) then
            table.insert(noteOffsetsBetween, hitObject.StartTime)
            if (hitObject.EndTime ~= 0 and hitObject.EndTime <= endOffset and includeLN) then
                table.insert(noteOffsetsBetween,
                    hitObject.EndTime)
            end
        end
    end
    noteOffsetsBetween = table.dedupe(noteOffsetsBetween)
    noteOffsetsBetween = sort(noteOffsetsBetween, sortAscending)
    return noteOffsetsBetween
end
