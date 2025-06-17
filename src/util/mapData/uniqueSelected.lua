-- Finds and returns a list of all unique offsets of notes between selected notes [Table]
function uniqueNoteOffsetsBetweenSelected()
    local selectedNoteOffsets = uniqueSelectedNoteOffsets()
    if (not selectedNoteOffsets) then
        toggleablePrint("e!",
            "Warning: There are not enough notes in the current selection (within this timing group) to perform the action.")
        return {}
    end
    local startOffset = selectedNoteOffsets[1]
    local endOffset = selectedNoteOffsets[#selectedNoteOffsets]
    local offsets = uniqueNoteOffsetsBetween(startOffset, endOffset)
    if (#offsets < 2) then
        toggleablePrint("e!",
            "Warning: There are not enough notes in the current selection (within this timing group) to perform the action.")
        return {}
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
    offsets = table.dedupe(offsets)
    offsets = sort(offsets, sortAscending)
    if (#offsets == 0) then return {} end
    return offsets
end
