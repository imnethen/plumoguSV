local COLOR_MAP = {
    [1] = "Red",
    [2] = "Blue",
    [3] = "Purple",
    [4] = "Yellow",
    [5] = "White",
    [6] = "Pink",
    [8] =
    "Orange",
    [12] = "Cyan",
    [16] = "Green"
}

function layerSnaps()
    local bmsToAdd = {}
    for _, noteTime in pairs(uniqueNoteOffsetsBetweenSelected(false)) do
        local color = COLOR_MAP[getSnapFromTime(noteTime)]
        local bm = utils.CreateBookmark(noteTime, "plumoguSV-snap-" .. color)
        table.insert(bmsToAdd, bm)
    end
    actions.Perform(utils.CreateEditorAction(action_type.AddBookmarkBatch, bmsToAdd))
end
