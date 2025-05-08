
-- Creates the displace view menu
function displaceViewMenu()
    local menuVars = {
        distance = 200
    }
    getVariables("displaceViewMenu", menuVars)
    chooseDistance(menuVars)
    saveVariables("displaceViewMenu", menuVars)

    addSeparator()
    simpleActionMenu("Displace view between selected notes", 2, displaceViewSVs, nil, menuVars)
end