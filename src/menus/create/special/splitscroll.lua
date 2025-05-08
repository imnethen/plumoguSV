

-- Creates the menu for basic splitscroll SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function splitScrollBasicMenu(settingVars)
    chooseFirstScrollSpeed(settingVars)
    chooseFirstHeight(settingVars)
    chooseSecondScrollSpeed(settingVars)
    chooseSecondHeight(settingVars)
    chooseMSPF(settingVars)

    addSeparator()
    local noNoteTimesInitially = #settingVars.noteTimes2 == 0
    addOrClearNoteTimes(settingVars, noNoteTimesInitially)
    if noNoteTimesInitially then return end

    addSeparator()
    local label = "Place Splitscroll SVs at selected note(s)"
    simpleActionMenu(label, 1, placeSplitScrollSVs, nil, settingVars)
end