-- Creates the add teleport menu
function addTeleportMenu()
    local menuVars = { -- TODO: CONVERT TO STATE
        distance = 10727,
        teleportBeforeHand = false
    }
    getVariables("addTeleportMenu", menuVars)
    chooseDistance(menuVars)
    chooseHand(menuVars)
    saveVariables("addTeleportMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add teleport SVs at selected notes", 1, addTeleportSVs, nil, menuVars)
end
