-- Creates the scale (displace) menu
function scaleDisplaceMenu()
    local menuVars = getMenuVars("scaleDisplace")
    chooseScaleDisplaceSpot(menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleDisplaceMenu", menuVars)

    AddSeparator()
    local buttonText = "Scale SVs between selected notes##displace"
    simpleActionMenu(buttonText, 2, scaleDisplaceSVs, menuVars)
end

-- Creates the scale (multiply) menu
function scaleMultiplyMenu()
    local menuVars = getMenuVars("scaleMultiply")
    chooseScaleType(menuVars)
    saveVariables("scaleMultiplyMenu", menuVars)

    AddSeparator()
    local buttonText = "Scale SVs between selected notes##multiply"
    simpleActionMenu(buttonText, 2, scaleMultiplySVs, menuVars)
end
