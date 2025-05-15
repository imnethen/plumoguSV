-- Creates a button that adds or clears note times for the 2nd scroll for the splitscroll menu
-- Parameters
--    settingVars          : list of variables used for the current menu [Table]
--    noNoteTimesInitially : whether or not there were note times initially [Boolean]
function addOrClearNoteTimes(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes2 .. " note times assigned for 2nd scroll")

    local buttonText = "Assign selected note times to 2nd scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes, nil, settingVars)

    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 2nd scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes2 = {}
end

-- Creates a button that adds or clears note times for the 3rd scroll for the splitscroll menu
-- Parameters
--    settingVars          : list of variables used for the current menu [Table]
--    noNoteTimesInitially : whether or not there were note times initially [Boolean]
function addOrClearNoteTimes2(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes3 .. " note times assigned for 3rd scroll")

    local buttonText = "Assign selected note times to 3rd scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes2, nil, settingVars)

    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 3rd scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes3 = {}
end

-- Creates a button that adds or clears note times for the 4th scroll for the splitscroll menu
-- Parameters
--    settingVars          : list of variables used for the current menu [Table]
--    noNoteTimesInitially : whether or not there were note times initially [Boolean]
function addOrClearNoteTimes3(settingVars, noNoteTimesInitially)
    imgui.Text(#settingVars.noteTimes4 .. " note times assigned for 4th scroll")

    local buttonText = "Assign selected note times to 4th scroll"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimes3, nil, settingVars)

    if noNoteTimesInitially then return end
    if not imgui.Button("Clear all 4th scroll note times", BEEG_BUTTON_SIZE) then return end
    settingVars.noteTimes4 = {}
end

-- Creates a button that adds selected note times to the splitscroll 2nd scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes2, hitObject.StartTime)
    end
    settingVars.noteTimes2 = table.dedupe(settingVars.noteTimes2)
    settingVars.noteTimes2 = table.sort(settingVars.noteTimes2, sortAscending)
end

-- Creates a button that adds selected note times to the splitscroll 3rd scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes2(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes3, hitObject.StartTime)
    end
    settingVars.noteTimes3 = table.dedupe(settingVars.noteTimes3)
    settingVars.noteTimes3 = table.sort(settingVars.noteTimes3, sortAscending)
end

-- Creates a button that adds selected note times to the splitscroll 4th scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes3(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes4, hitObject.StartTime)
    end
    settingVars.noteTimes4 = table.dedupe(settingVars.noteTimes4)
    settingVars.noteTimes4 = table.sort(settingVars.noteTimes4, sortAscending)
end
