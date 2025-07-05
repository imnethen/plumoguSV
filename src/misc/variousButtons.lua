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
