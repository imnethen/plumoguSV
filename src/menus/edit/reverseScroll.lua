-- Creates the reverse scroll menu
function reverseScrollMenu()
    local menuVars = {
        distance = 400
    }
    getVariables("reverseScrollMenu", menuVars)
    chooseDistance(menuVars)
    helpMarker("Height at which reverse scroll notes are hit")
    saveVariables("reverseScrollMenu", menuVars)

    addSeparator()
    local buttonText = "Reverse scroll between selected notes"
    simpleActionMenu(buttonText, 2, reverseScrollSVs, nil, menuVars)
end
