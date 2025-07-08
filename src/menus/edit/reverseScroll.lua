function reverseScrollMenu()
    local menuVars = getMenuVars("reverseScroll")
    chooseDistance(menuVars)
    helpMarker("Height at which reverse scroll notes are hit")
    saveVariables("reverseScrollMenu", menuVars)

    addSeparator()
    local buttonText = "Reverse scroll between selected notes"
    simpleActionMenu(buttonText, 2, reverseScrollSVs, nil, menuVars)
end
