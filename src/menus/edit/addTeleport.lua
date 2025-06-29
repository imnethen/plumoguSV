-- Creates the add teleport menu
function addTeleportMenu()
    local menuVars = getMenuVars("addTeleport")
    chooseDistance(menuVars)
    chooseHand(menuVars)
    saveVariables("addTeleportMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add teleport SVs at selected notes", 1, addTeleportSVs, nil, menuVars)
end
