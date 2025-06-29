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

    local createLayerQueue = {}
    local moveNoteQueue = {}

    for layerName, layerData in pairs(layerDict) do
        local layer = utils.CreateEditorLayer(layerName, layerData.ColorRgb, layerData.Hidden)
        table.insert(createLayerQueue,
            utils.CreateEditorAction(action_type.CreateLayer, layer))
        table.insert(moveNoteQueue, utils.CreateEditorAction(action_type.MoveToLayer, layerData.hos, layer))
    end
    actions.PerformBatch(createLayerQueue)
    actions.PerformBatch(moveNoteQueue)
end
