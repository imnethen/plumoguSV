function layerSnapMenu()
    simpleActionMenu("Layer snaps between selection", 2, layerSnaps, nil)
    AddSeparator()
    simpleActionMenu("Collapse snap layers", 0, collapseSnaps, nil)
    simpleActionMenu("Clear unused snap layers", 0, clearSnappedLayers, nil)
end
