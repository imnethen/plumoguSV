function flickerMenu()
    local menuVars = getMenuVars("flicker")
    chooseFlickerType(menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    chooseNumFlickers(menuVars)
    if (globalVars.advancedMode) then chooseFlickerPosition(menuVars) end
    saveVariables("flickerMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add flicker SVs between selected notes", 2, flickerSVs, menuVars)
end
