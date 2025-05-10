-- Creates the flicker menu
function flickerMenu()
    local menuVars = {
        flickerTypeIndex = 1,
        distance = -69420.727,
        distance1 = 0,
        distance2 = -69420.727,
        numFlickers = 1,
        linearlyChange = false
    }
    getVariables("flickerMenu", menuVars)
    chooseFlickerType(menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    chooseNumFlickers(menuVars)
    saveVariables("flickerMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add flicker SVs between selected notes", 2, flickerSVs, nil, menuVars)
end
