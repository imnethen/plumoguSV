
-- Creates the select by snap menu
function selectBySnapMenu()
    local menuVars = {
        snap = 1,
    }
    getVariables("selectBySnapMenu", menuVars)
    chooseSnap(menuVars)
    saveVariables("selectBySnapMenu", menuVars)

    addSeparator()
    simpleActionMenu(
        "Select notes with 1/" .. menuVars.snap .. " snap",
        2,
        selectBySnap, nil, menuVars)
end