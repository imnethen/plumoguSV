

-- Creates the scale (displace) menu
function scaleDisplaceMenu()
    local menuVars = {
        scaleSpotIndex = 1,
        scaleTypeIndex = 1,
        avgSV = 0.6,
        distance = 100,
        ratio = 0.6,
    }
    getVariables("scaleDisplaceMenu", menuVars)
    chooseScaleDisplaceSpot(menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleDisplaceMenu", menuVars)

    addSeparator()
    local buttonText = "Scale SVs between selected notes##displace"
    simpleActionMenu(buttonText, 2, scaleDisplaceSVs, nil, menuVars)
end

-- Creates the scale (multiply) menu
function scaleMultiplyMenu()
    local menuVars = {
        scaleTypeIndex = 1,
        avgSV = 0.6,
        distance = 100,
        ratio = 0.6
    }
    getVariables("scaleMultiplyMenu", menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleMultiplyMenu", menuVars)

    addSeparator()
    local buttonText = "Scale SVs between selected notes##multiply"
    simpleActionMenu(buttonText, 2, scaleMultiplySVs, nil, menuVars)
end
