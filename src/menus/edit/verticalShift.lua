-- Creates the menu for vertical shifts of SVs
function verticalShiftMenu()
    local menuVars = { -- TODO: CONVERT TO STATE
        verticalShift = 1
    }
    getVariables("verticalShiftMenu", menuVars)
    chooseConstantShift(menuVars, 0)
    saveVariables("verticalShiftMenu", menuVars)

    addSeparator()
    local buttonText = "Vertically shift SVs between selected notes"
    simpleActionMenu(buttonText, 2, verticalShiftSVs, nil, menuVars)
end
