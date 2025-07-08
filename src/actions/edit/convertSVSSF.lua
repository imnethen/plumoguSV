function convertSVSSF(menuVars)
    local offsets = uniqueSelectedNoteOffsets()
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local objects = table.construct()
    local editorActions = table.construct()

    if (menuVars.conversionDirection) then
        local svs = getSVsBetweenOffsets(startOffset, endOffset, false)
        for _, sv in pairs(svs) do
            objects:insert({ StartTime = sv.StartTime, Multiplier = sv.Multiplier })
        end
        editorActions:insert(utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svs))
    else
        local ssfs = getSSFsBetweenOffsets(startOffset, endOffset, false)
        for _, ssf in pairs(ssfs) do
            objects:insert({ StartTime = ssf.StartTime, Multiplier = ssf.Multiplier })
        end
        editorActions:insert(utils.CreateEditorAction(action_type.RemoveScrollSpeedFactorBatch, ssfs))
    end
    local createTable = table.construct()
    for _, obj in pairs(objects) do
        if (menuVars.conversionDirection) then
            createTable:insert(utils.CreateScrollSpeedFactor(obj.StartTime,
                obj.Multiplier))
        else
            createTable:insert(utils.CreateScrollVelocity(obj.StartTime, obj.Multiplier))
        end
    end
    if (menuVars.conversionDirection) then
        editorActions:insert(utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, createTable))
    else
        editorActions:insert(utils.CreateEditorAction(action_type.AddScrollVelocityBatch, createTable))
    end
    actions.PerformBatch(editorActions)
    toggleablePrint("w!", "Successfully converted.")
end