-- Creates the scale (displace) menu
function scaleDisplaceMenu()
    local menuVars = getMenuVars("scaleDisplace")
    chooseScaleDisplaceSpot(menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleDisplaceMenu", menuVars)

    addSeparator()
    local buttonText = "Scale SVs between selected notes##displace"
    simpleActionMenu(buttonText, 2, scaleDisplaceSVs, nil, menuVars)
end

-- Creates the scale (multiply) menu
function scaleMultiplyMenu()
    local menuVars = getMenuVars("scaleMultiply")
    chooseScaleType(menuVars)
    saveVariables("scaleMultiplyMenu", menuVars)

    addSeparator()
    local buttonText = "Scale SVs between selected notes##multiply"
    simpleActionMenu(buttonText, 2, scaleMultiplySVs, nil, menuVars)
end