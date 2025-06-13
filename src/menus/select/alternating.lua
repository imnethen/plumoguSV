-- Creates the select alternating menu
function selectAlternatingMenu()
    local menuVars = {
        every = 1,
        offset = 0
    }
    getVariables("selectAlternatingMenu", menuVars)
    chooseEvery(menuVars)
    chooseOffset(menuVars)
    saveVariables("selectAlternatingMenu", menuVars)

    addSeparator()
    simpleActionMenu(
        "Select a note every " ..
        menuVars.every .. pluralize(" note, from note #", menuVars.every, 5) .. menuVars.offset,
        2,
        selectAlternating, nil, menuVars)
end
