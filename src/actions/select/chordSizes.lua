function selectByChordSizes(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]

    local notes = getNotesBetweenOffsets(startOffset, endOffset)

    local noteTimeTable = {}

    for _, note in pairs(notes) do
        table.insert(noteTimeTable, note.StartTime)
    end

    noteTimeTable = table.dedupe(noteTimeTable)

    local sizeDict = {
        {},
        {},
        {},
        {}
    }

    for _, time in pairs(noteTimeTable) do
        local size = 0
        local totalNotes = {}
        for _, note in pairs(notes) do
            if (math.abs(note.StartTime - time) < 3) then
                size = size + 1
                table.insert(totalNotes, note)
            end
        end
        sizeDict[size] = table.combine(sizeDict[size], totalNotes)
    end

    local notesToSelect = {}

    if (menuVars.single) then notesToSelect = table.combine(notesToSelect, sizeDict[1]) end
    if (menuVars.jump) then notesToSelect = table.combine(notesToSelect, sizeDict[2]) end
    if (menuVars.hand) then notesToSelect = table.combine(notesToSelect, sizeDict[3]) end
    if (menuVars.quad) then notesToSelect = table.combine(notesToSelect, sizeDict[4]) end

    actions.SetHitObjectSelection(notesToSelect)
    print(#notesToSelect > 0 and "S!" or "W!", #notesToSelect .. " notes selected")
end
