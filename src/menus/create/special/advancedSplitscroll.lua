-- Creates the menu for advanced splitscroll SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function splitScrollAdvancedMenu(settingVars)
    chooseNumScrolls(settingVars)
    chooseMSPF(settingVars)

    addSeparator()
    chooseScrollIndex(settingVars)

    addSeparator()
    local no1stSVsInitially = #settingVars.svsInScroll1 == 0
    local no2ndSVsInitially = #settingVars.svsInScroll2 == 0
    local no3rdSVsInitially = #settingVars.svsInScroll3 == 0
    local no4thSVsInitially = #settingVars.svsInScroll4 == 0
    local noNoteTimesInitially = #settingVars.noteTimes2 == 0
    local noNoteTimesInitially2 = #settingVars.noteTimes3 == 0
    local noNoteTimesInitially3 = #settingVars.noteTimes4 == 0
    if settingVars.scrollIndex == 1 then
        imgui.TextWrapped("Notes not assigned to the other scrolls will be used for 1st scroll")
        addSeparator()
        buttonsForSVsInScroll1(settingVars, no1stSVsInitially)
    elseif settingVars.scrollIndex == 2 then
        chooseDistanceBack(settingVars)
        addSeparator()
        addOrClearNoteTimes(settingVars, noNoteTimesInitially)
        addSeparator()
        buttonsForSVsInScroll2(settingVars, no2ndSVsInitially)
    elseif settingVars.scrollIndex == 3 then
        chooseDistanceBack2(settingVars)
        addSeparator()
        addOrClearNoteTimes2(settingVars, noNoteTimesInitially2)
        addSeparator()
        buttonsForSVsInScroll3(settingVars, no3rdSVsInitially)
    elseif settingVars.scrollIndex == 4 then
        chooseDistanceBack3(settingVars)
        addSeparator()
        addOrClearNoteTimes3(settingVars, noNoteTimesInitially3)
        addSeparator()
        buttonsForSVsInScroll4(settingVars, no4thSVsInitially)
    end
    if noNoteTimesInitially or no1stSVsInitially or no2ndSVsInitially then return end
    if settingVars.numScrolls > 2 and (noNoteTimesInitially2 or no3rdSVsInitially) then return end
    if settingVars.numScrolls > 3 and (noNoteTimesInitially3 or no4thSVsInitially) then return end

    addSeparator()
    local label = "Place Splitscroll SVs at selected note(s)"
    simpleActionMenu(label, 1, placeAdvancedSplitScrollSVs, nil, settingVars)
end
