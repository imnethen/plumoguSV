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
    local layerDict = {}
    for _, ho in pairs(uniqueNotesBetweenSelected()) do
        local color = COLOR_MAP[getSnapFromTime(ho.StartTime)]
        if (ho.EditorLayer == 0) then
            layer = { Name = "Default", ColorRgb = "255,255,255", Hidden = false }
        else
            layer = map.EditorLayers[ho.EditorLayer]
        end
        local newLayerName = layer.Name .. "-plumoguSV-snap-" .. color
        if (layerDict:includes(newLayerName)) then
            table.insert(layerDict[newLayerName].hos, ho)
        else
            layerDict[newLayerName] = { hos = { ho }, ColorRgb = layer.ColorRgb, Hidden = layer.Hidden }
        end
    end

    local createLayerActions = {}
    local moveNoteActions = {}

    for layerName, layerData in pairs(layerDict) do
        local layer = utils.CreateEditorLayer(layerName, layerData.ColorRgb, layerData.Hidden)
        table.insert(createLayerActions,
            utils.CreateEditorAction(action_type.CreateLayer, layer))
        table.insert(moveNoteActions, utils.CreateEditorAction(action_type.MoveToLayer, layerData.hos, layer))
    end
    actions.PerformBatch(createLayerActions)
    actions.PerformBatch(moveNoteActions)
end
