function selectByNoteType(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    if (not offsets) then return end
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]

    local totalNotes = getNotesBetweenOffsets(startOffset, endOffset)

    local notesToSelect = {}

    for _, note in pairs(totalNotes) do
        if (note.EndTime == 0 and menuVars.rice) then table.insert(notesToSelect, note) end
        if (note.EndTime ~= 0 and menuVars.ln) then table.insert(notesToSelect, note) end
    end

    actions.SetHitObjectSelection(notesToSelect)
    print(truthy(notesToSelect) and "S!" or "W!", #notesToSelect .. " notes selected")
end
