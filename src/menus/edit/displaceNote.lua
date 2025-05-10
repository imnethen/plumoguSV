-- Creates the displace note menu
function displaceNoteMenu()
    local menuVars = {
        distance = 200,
        distance1 = 0,
        distance2 = 200,
        linearlyChange = false
    }
    getVariables("displaceNoteMenu", menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    saveVariables("displaceNoteMenu", menuVars)

    addSeparator()
    simpleActionMenu("Displace selected notes", 1, displaceNoteSVsParent, nil, menuVars)
end
