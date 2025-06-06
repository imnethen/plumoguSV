-- Creates the flicker menu
function flickerMenu()
    local menuVars = {
        flickerTypeIndex = 1,
        distance = -69420.727,
        distance1 = 0,
        distance2 = -69420.727,
        numFlickers = 1,
        linearlyChange = false,
        flickerPosition = 0.5
    }
    getVariables("flickerMenu", menuVars)
    chooseFlickerType(menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    chooseNumFlickers(menuVars)
    chooseFlickerPosition(menuVars)
    saveVariables("flickerMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add flicker SVs between selected notes", 2, flickerSVs, nil, menuVars)
end
