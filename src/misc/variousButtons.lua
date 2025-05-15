-- Creates a button that lets you clear all assigned note times for the current menu
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function clearNoteTimesButton(menuVars)
    if not imgui.Button("Clear all assigned note times", BEEG_BUTTON_SIZE) then return end
    menuVars.noteTimes = {}
end

-- Creates a button that adds note times for the dynamic scale menu
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function addNoteTimesToDynamicScaleButton(menuVars)
    local buttonText = "Assign selected note times"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimesToList, nil, menuVars)
end

-- Makes the button that removes the currently selected frame time for the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function removeSelectedFrameTimeButton(settingVars)
    if #settingVars.frameTimes == 0 then return end
    if not imgui.Button("Removed currently selected time", BEEG_BUTTON_SIZE) then return end
    table.remove(settingVars.frameTimes, settingVars.selectedTimeIndex)
    local maxIndex = math.max(1, #settingVars.frameTimes)
    settingVars.selectedTimeIndex = math.clamp(settingVars.selectedTimeIndex, 1, maxIndex)
end

-- Makes a button that places SVs assigned for a scroll for the splitscroll menu
-- Parameters
--    svList : list of SVs of the target scroll [Table]
--    buttonText : text for the button [String]
function buttonPlaceScrollSVs(svList, buttonText)
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    local svsToAdd = svList
    local startOffset = svsToAdd[1].StartTime
    local extraOffset = 1 / 128
    local endOffset = svsToAdd[#svsToAdd].StartTime + extraOffset
    local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end

-- Makes buttons for adding and clearing SVs for the 1st scroll for the splitscroll menu
-- Parameters
--    settingVars    : list of variables used for the current menu [Table]
--    noSVsInitially : whether or not there were SVs initially [Boolean]
function buttonsForSVsInScroll1(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll1 .. " SVs assigned for 1st scroll")
    local function addFirstScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 1st scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if #offsets < 2 then return end

        settingVars.svsInScroll1 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addFirstScrollSVs(settingVars)
        return
    end
    buttonClear1stScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll1, "Re-place assigned\n1st scroll SVs")
end

-- Makes buttons for adding and clearing SVs for the 2nd scroll for the splitscroll menu
-- Parameters
--    settingVars    : list of variables used for the current menu [Table]
--    noSVsInitially : whether or not there were SVs initially [Boolean]
function buttonsForSVsInScroll2(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll2 .. " SVs assigned for 2nd scroll")
    local function addSecondScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 2nd scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if #offsets < 2 then return end

        settingVars.svsInScroll2 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addSecondScrollSVs(settingVars)
        return
    end
    buttonClear2ndScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll2, "Re-place assigned\n2nd scroll SVs")
end

-- Makes buttons for adding and clearing SVs for the 3rd scroll for the splitscroll menu
-- Parameters
--    settingVars    : list of variables used for the current menu [Table]
--    noSVsInitially : whether or not there were SVs initially [Boolean]
function buttonsForSVsInScroll3(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll3 .. " SVs assigned for 3rd scroll")
    local function addThirdScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 3rd scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if #offsets < 2 then return end

        settingVars.svsInScroll3 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addThirdScrollSVs(settingVars)
        return
    end
    buttonClear3rdScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll3, "Re-place assigned\n3rd scroll SVs")
end

-- Makes buttons for adding and clearing SVs for the 4th scroll for the splitscroll menu
-- Parameters
--    settingVars    : list of variables used for the current menu [Table]
--    noSVsInitially : whether or not there were SVs initially [Boolean]
function buttonsForSVsInScroll4(settingVars, noSVsInitially)
    imgui.Text(#settingVars.svsInScroll4 .. " SVs assigned for 4th scroll")
    local function addFourthScrollSVs(settingVars)
        local buttonText = "Assign SVs between\nselected notes to 4th scroll"
        if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end
        local offsets = uniqueSelectedNoteOffsets()
        if #offsets < 2 then return end

        settingVars.svsInScroll4 = getSVsBetweenOffsets(offsets[1], offsets[#offsets])
    end
    if noSVsInitially then
        addFourthScrollSVs(settingVars)
        return
    end
    buttonClear4thScrollSVs(settingVars)
    imgui.SameLine(0, SAMELINE_SPACING)
    buttonPlaceScrollSVs(settingVars.svsInScroll4, "Re-place assigned\n4th scroll SVs")
end

-- Makes a button that clears SVs for the 1st scroll for the splitscroll menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function buttonClear1stScrollSVs(settingVars)
    local buttonText = "Clear assigned\n 1st scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll1 = {}
end

-- Makes a button that clears SVs for the 2nd scroll for the splitscroll menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function buttonClear2ndScrollSVs(settingVars)
    local buttonText = "Clear assigned\n2nd scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll2 = {}
end

-- Makes a button that clears SVs for the 3rd scroll for the splitscroll menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function buttonClear3rdScrollSVs(settingVars)
    local buttonText = "Clear assigned\n3rd scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll3 = {}
end

-- Makes a button that clears SVs for the 4th scroll for the splitscroll menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function buttonClear4thScrollSVs(settingVars)
    local buttonText = "Clear assigned\n4th scroll SVs"
    if not imgui.Button(buttonText, HALF_ACTION_BUTTON_SIZE) then return end
    settingVars.svsInScroll4 = {}
end

-- Creates the button for exporting/importing current menu settings
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function exportImportSettingsButton(globalVars)
    local buttonText = ": )"
    if globalVars.showExportImportMenu then buttonText = "X" end
    local buttonPressed = imgui.Button(buttonText, EXPORT_BUTTON_SIZE)
    toolTip("Export and import menu settings")
    imgui.SameLine(0, SAMELINE_SPACING)
    if not buttonPressed then return end

    globalVars.showExportImportMenu = not globalVars.showExportImportMenu
end
