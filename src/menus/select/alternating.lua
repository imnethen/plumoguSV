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

    local text = ""
    if (menuVars.every > 1) then text = "s" end

    addSeparator()
    simpleActionMenu(
        "Select a note every " .. menuVars.every .. " note" .. text .. ", from note #" .. menuVars.offset,
        2,
        selectAlternating, nil, menuVars)
end
