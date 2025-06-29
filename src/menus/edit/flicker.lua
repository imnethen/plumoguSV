-- Creates the flicker menu
function flickerMenu()
    local menuVars = getMenuVars("flicker")
    chooseFlickerType(menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    chooseNumFlickers(menuVars)
    if (state.GetValue("global_advancedMode")) then chooseFlickerPosition(menuVars) end
    saveVariables("flickerMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add flicker SVs between selected notes", 2, flickerSVs, nil, menuVars)
end
