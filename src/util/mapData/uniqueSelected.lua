
-- Finds and returns a list of all unique offsets of notes between selected notes [Table]
function uniqueNoteOffsetsBetweenSelected()
    local selectedNoteOffsets = uniqueSelectedNoteOffsets()
    local startOffset = selectedNoteOffsets[1]
    local endOffset = selectedNoteOffsets[#selectedNoteOffsets]
    local offsets = uniqueNoteOffsetsBetween(startOffset, endOffset)
    if (#offsets < 2) then
        print("E!",
            "Warning: There are not enough notes in the current selection (within this timing group) to perform the action.")
    end
    return offsets
end

-- Finds unique offsets of all notes currently selected in the editor
-- Returns a list of unique offsets (in increasing order) of selected notes [Table]
function uniqueSelectedNoteOffsets()
    local offsets = {}
    for i, hitObject in pairs(state.SelectedHitObjects) do
        offsets[i] = hitObject.StartTime
    end
    offsets = dedupe(offsets)
    offsets = table.sort(offsets, sortAscending)
    return offsets
end