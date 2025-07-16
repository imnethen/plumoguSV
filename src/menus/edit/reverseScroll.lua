function reverseScrollMenu()
    local menuVars = getMenuVars("reverseScroll")
    chooseDistance(menuVars)
    HelpMarker("Height at which reverse scroll notes are hit")
    saveVariables("reverseScrollMenu", menuVars)

    AddSeparator()
    local buttonText = "Reverse scroll between selected notes"
    simpleActionMenu(buttonText, 2, reverseScrollSVs, menuVars)
end
