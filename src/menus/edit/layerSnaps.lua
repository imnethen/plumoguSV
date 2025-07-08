function layerSnapMenu()
    simpleActionMenu("Layer snaps between selection", 2, layerSnaps, nil, nil)
    addSeparator()
    simpleActionMenu("Collapse snap layers", 0, collapseSnaps, nil, nil)
    simpleActionMenu("Clear unused snap layers", 0, clearSnappedLayers, nil, nil)
end