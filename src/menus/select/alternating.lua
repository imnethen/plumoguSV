function selectAlternatingMenu()
    local menuVars = getMenuVars("selectAlternating")
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
