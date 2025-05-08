function getVariables(listName, variables)
    for key, _ in pairs(variables) do
        if (state.GetValue(listName .. key) ~= nil) then
            variables[key] = state.GetValue(listName .. key) -- Changed because default setting of true would always override
        end
    end
end

function saveVariables(listName, variables)
    for key, value in pairs(variables) do
        state.SetValue(listName .. key, value)
    end
end

---------------------------------------------------------------------------------------------------
-- Plugin Convenience Functions -------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

-- Makes the next plugin window not collapsed on startup
-- Parameters
--    windowName : key name for the next plugin window that opens [String]
function startNextWindowNotCollapsed(windowName)
    if state.GetValue(windowName) then return end
    imgui.SetNextWindowCollapsed(false)
    state.SetValue(windowName, true)
end

-- Makes the main plugin window focused/active if Shift + Tab is pressed
function focusWindowIfHotkeysPressed()
    local shiftKeyPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local tabKeyPressed = utils.IsKeyPressed(keys.Tab)
    if shiftKeyPressedDown and tabKeyPressed then imgui.SetNextWindowFocus() end
end

-- Makes the main plugin window centered if Ctrl + Shift + Tab is pressed
function centerWindowIfHotkeysPressed()
    local ctrlPressedDown = utils.IsKeyDown(keys.LeftControl) or
        utils.IsKeyDown(keys.RightControl)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local tabPressed = utils.IsKeyPressed(keys.Tab)
    if not (ctrlPressedDown and shiftPressedDown and tabPressed) then return end

    local windowWidth, windowHeight = table.unpack(state.WindowSize)
    local pluginWidth, pluginHeight = table.unpack(imgui.GetWindowSize())
    local centeringX = (windowWidth - pluginWidth) / 2
    local centeringY = (windowHeight - pluginHeight) / 2
    local coordinatesToCenter = { centeringX, centeringY }
    imgui.SetWindowPos("plumoguSV", coordinatesToCenter)
end

-- Returns whether or not the corresponding menu tab shortcut keys were pressed [Boolean]
-- Parameters
--    tabName : name of the menu tab [String]
function keysPressedForMenuTab(tabName)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    if shiftPressedDown then return false end

    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local otherKey
    if tabName == "##info" then otherKey = keys.A end
    if tabName == "##placeStandard" then otherKey = keys.Z end
    if tabName == "##placeSpecial" then otherKey = keys.X end
    if tabName == "##placeStill" then otherKey = keys.C end
    if tabName == "##edit" then otherKey = keys.S end
    if tabName == "##delete" then otherKey = keys.D end
    local otherKeyPressed = utils.IsKeyPressed(otherKey)
    return altPressedDown and otherKeyPressed
end

-- Changes the SV type if certain keys are pressed
-- Returns whether or not the SV type has changed [Boolean]
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function changeSVTypeIfKeysPressed(menuVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return false end

    local maxSVTypes = #STANDARD_SVS
    local isSpecialType = menuVars.interlace == nil
    if isSpecialType then maxSVTypes = #SPECIAL_SVS end

    if xPressed then menuVars.svTypeIndex = menuVars.svTypeIndex + 1 end
    if zPressed then menuVars.svTypeIndex = menuVars.svTypeIndex - 1 end
    menuVars.svTypeIndex = wrapToInterval(menuVars.svTypeIndex, 1, maxSVTypes)
    return true
end

-- Changes the edit tool if certain keys are pressed
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function changeSelectToolIfKeysPressed(globalVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return end

    if xPressed then globalVars.selectTypeIndex = globalVars.selectTypeIndex + 1 end
    if zPressed then globalVars.selectTypeIndex = globalVars.selectTypeIndex - 1 end
    globalVars.selectTypeIndex = wrapToInterval(globalVars.selectTypeIndex, 1, #SELECT_TOOLS)
end

-- Changes the edit tool if certain keys are pressed
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function changeEditToolIfKeysPressed(globalVars)
    local altPressedDown = utils.IsKeyDown(keys.LeftAlt) or
        utils.IsKeyDown(keys.RightAlt)
    local shiftPressedDown = utils.IsKeyDown(keys.LeftShift) or
        utils.IsKeyDown(keys.RightShift)
    local xPressed = utils.IsKeyPressed(keys.X)
    local zPressed = utils.IsKeyPressed(keys.Z)
    if not (altPressedDown and shiftPressedDown and (xPressed or zPressed)) then return end

    if xPressed then globalVars.editToolIndex = globalVars.editToolIndex + 1 end
    if zPressed then globalVars.editToolIndex = globalVars.editToolIndex - 1 end
    globalVars.editToolIndex = wrapToInterval(globalVars.editToolIndex, 1, #EDIT_SV_TOOLS)
end

----------------------------------------------------------------------------------------- Tab stuff

function chooseDistanceMode(menuVars)
    local oldMode = menuVars.distanceMode
    menuVars.distanceMode = combo("Distance Type", DISTANCE_TYPES, menuVars.distanceMode)
    return oldMode ~= menuVars.distanceMode
end


function penisMenu(settingVars)
    _, settingVars.bWidth = imgui.InputInt("Ball Width", settingVars.bWidth)
    _, settingVars.sWidth = imgui.InputInt("Shaft Width", settingVars.sWidth)

    _, settingVars.sCurvature = imgui.SliderInt("S Curvature", settingVars.sCurvature, 1, 100,
        settingVars.sCurvature .. "%%")
    _, settingVars.bCurvature = imgui.SliderInt("B Curvature", settingVars.bCurvature, 1, 100,
        settingVars.bCurvature .. "%%")

    simpleActionMenu("Place SVs", 1, placePenisSV, nil, settingVars)
end

-- Creates the menu for stutter SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function stutterMenu(settingVars)
    local settingsChanged = #settingVars.svMultipliers == 0
    settingsChanged = chooseControlSecondSV(settingVars) or settingsChanged
    settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
    settingsChanged = chooseStutterDuration(settingVars) or settingsChanged
    settingsChanged = chooseLinearlyChange(settingVars) or settingsChanged

    addSeparator()
    settingsChanged = chooseStuttersPerSection(settingVars) or settingsChanged
    settingsChanged = chooseAverageSV(settingVars) or settingsChanged
    settingsChanged = chooseFinalSV(settingVars, false) or settingsChanged
    if settingsChanged then updateStutterMenuSVs(settingVars) end
    displayStutterSVWindows(settingVars)

    addSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeStutterSVs, nil, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeStutterSSFs, nil, settingVars, true)
end

-- Creates the menu for teleport stutter SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function teleportStutterMenu(settingVars)
    if settingVars.useDistance then
        chooseDistance(settingVars)
        helpMarker("Start SV teleport distance")
    else
        chooseStartSVPercent(settingVars)
    end
    chooseMainSV(settingVars)
    chooseAverageSV(settingVars)
    chooseFinalSV(settingVars, false)
    chooseUseDistance(settingVars)
    chooseLinearlyChange(settingVars)

    addSeparator()
    simpleActionMenu("Place SVs between selected notes", 2, placeTeleportStutterSVs, nil, settingVars)
    simpleActionMenu("Place SSFs between selected notes", 2, placeTeleportStutterSSFs, nil, settingVars, true)
end

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

-- Creates the 2nd version menu for advanced splitscroll SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function splitScrollAdvancedV2Menu(settingVars)
    chooseNumScrolls(settingVars)
    chooseMSPF(settingVars)

    addSeparator()
    chooseScrollIndex(settingVars)

    addSeparator()
    if settingVars.scrollIndex == 2 then
        chooseDistanceBack(settingVars)
    elseif settingVars.scrollIndex == 3 then
        chooseDistanceBack2(settingVars)
    elseif settingVars.scrollIndex == 4 then
        chooseDistanceBack3(settingVars)
    end
    if settingVars.scrollIndex ~= 1 then addSeparator() end

    chooseSplitscrollLayers(settingVars)
    if settingVars.splitscrollLayers[1] == nil then return end
    if settingVars.splitscrollLayers[2] == nil then return end
    if settingVars.numScrolls > 2 and settingVars.splitscrollLayers[3] == nil then return end
    if settingVars.numScrolls > 3 and settingVars.splitscrollLayers[4] == nil then return end

    addSeparator()
    local label = "Place Splitscroll SVs"
    simpleActionMenu(label, 0, placeAdvancedSplitScrollSVsV2, nil, settingVars)
end

-- Creates the menu for setting up animation frames
-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    settingVars : list of variables used for the current menu [Table]
function animationFramesSetupMenu(globalVars, settingVars)
    chooseMenuStep(settingVars)
    if settingVars.menuStep == 1 then
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Choose Frame Settings")
        addSeparator()
        chooseNumFrames(settingVars)
        chooseFrameSpacing(settingVars)
        chooseDistance(settingVars)
        helpMarker("Initial separating distance from selected note to the first frame")
        chooseFrameOrder(settingVars)
        addSeparator()
        chooseNoteSkinType(settingVars)
    elseif settingVars.menuStep == 2 then
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Adjust Notes/Frames")
        addSeparator()
        imgui.Columns(2, "Notes and Frames", false)
        addFrameTimes(settingVars)
        displayFrameTimes(settingVars)
        removeSelectedFrameTimeButton(settingVars)
        addPadding()
        chooseFrameTimeData(settingVars)
        imgui.NextColumn()
        chooseCurrentFrame(settingVars)
        drawCurrentFrame(globalVars, settingVars)
        imgui.Columns(1)
        local invisibleButtonSize = { 2 * (ACTION_BUTTON_SIZE[1] + 1.5 * SAMELINE_SPACING), 1 }
        imgui.invisibleButton("sv isnt a real skill", invisibleButtonSize)
    else
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.Text("Place SVs")
        addSeparator()
        if #settingVars.frameTimes == 0 then
            imgui.Text("No notes added in Step 2, so can't place SVs yet")
            return
        end
        helpMarker("This tool displaces notes into frames after the (first) selected note")
        helpMarker("Works with pre-existing SVs or no SVs in the map")
        helpMarker("This is technically an edit SV tool, but it replaces the old animate function")
        helpMarker("Make sure to prepare an empty area for the frames after the note you select")
        helpMarker("Note: frame positions and viewing them will break if SV distances change")
        addSeparator()
        local label = "Setup frames after selected note"
        simpleActionMenu(label, 1, displaceNotesForAnimationFrames, nil, settingVars)
    end
end

-- Makes the export and import menu for place SV settings
-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    menuVars    : list of setting variables for the current menu [Table]
--    settingVars : list of setting variables for the current sv type [Table]
function exportImportSettingsMenu(globalVars, menuVars, settingVars)
    local multilineWidgetSize = { ACTION_BUTTON_SIZE[1], 50 }
    local placeType = PLACE_TYPES[globalVars.placeTypeIndex]
    local isSpecialPlaceType = placeType == "Special"
    local svType
    if isSpecialPlaceType then
        svType = SPECIAL_SVS[menuVars.svTypeIndex]
    else
        svType = STANDARD_SVS[menuVars.svTypeIndex]
    end
    local isComboType = svType == "Combo"
    local noExportOption = svType == "Splitscroll (Basic)" or
        svType == "Splitscroll (Advanced)" or
        svType == "Frames Setup"
    imgui.Text("Paste exported data here to import")
    _, globalVars.importData = imgui.InputTextMultiline("##placeImport", globalVars.importData,
        MAX_IMPORT_CHARACTER_LIMIT,
        multilineWidgetSize)
    importPlaceSVButton(globalVars)
    addSeparator()
    if noExportOption then
        imgui.Text("No export option")
        return
    end

    if not isSpecialPlaceType then
        imgui.Text("Copy + paste exported data somewhere safe")
        imgui.InputTextMultiline("##customSVExport", globalVars.exportCustomSVData,
            #globalVars.exportCustomSVData, multilineWidgetSize,
            imgui_input_text_flags.ReadOnly)
        exportCustomSVButton(globalVars, menuVars)
        addSeparator()
    end
    if not isComboType then
        imgui.Text("Copy + paste exported data somewhere safe")
        imgui.InputTextMultiline("##placeExport", globalVars.exportData, #globalVars.exportData,
            multilineWidgetSize, imgui_input_text_flags.ReadOnly)
        exportPlaceSVButton(globalVars, menuVars, settingVars)
    end
end


-- Creates the add teleport menu
function addTeleportMenu()
    local menuVars = {
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

-- Creates the align timing lines menu
function alignTimingLinesMenu()
    simpleActionMenu("Align timing lines in this region", 0, alignTimingLines, nil, nil)
end

function tempBugFixMenu()
    imgui.PushTextWrapPos(200)
    imgui.TextWrapped(
        "note: this will not fix already broken regions, but will hopefully turn non-broken regions into things you can properly copy paste with no issues. ")
    imgui.NewLine()
    imgui.TextWrapped(
        "Copy paste bug is caused when two svs are on top of each other, because of the way Quaver handles dupe svs; the order in the .qua file determines rendering order. When duplicating stacked svs, the order has a chance to reverse, therefore making a different sv prioritized and messing up proper movement. Possible solutions include getting better at coding or merging SV before C+P.")
    imgui.NewLine()
    imgui.TextWrapped(
        " If you copy paste and the original SV gets broken, this likely means that the game changed the rendering order of duplicated svs on the original SV. Either try this tool, or use Edit SVs > Merge.")
    imgui.PopTextWrapPos()
    simpleActionMenu("Try to fix regions to become copy pastable", 0, tempBugFix, nil, nil)
end

function tempBugFix()
    local ptr = 0
    local svsToRemove = {}
    for _, sv in pairs(map.ScrollVelocities) do
        if (math.abs(ptr - sv.StartTime) < 0.035) then
            table.insert(svsToRemove, sv)
        end
        ptr = sv.StartTime
    end
    actions.RemoveScrollVelocityBatch(svsToRemove)
end

-- Creates the copy and paste menu
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function copyNPasteMenu(globalVars)
    local menuVars = {
        copyTable = { true, true, true, true }, -- 1: timing lines, 2: svs, 3: ssfs, 4: bookmarks
        copiedLines = {},
        copiedSVs = {},
        copiedSSFs = {},
        copiedBMs = {},
    }
    getVariables("copyMenu", menuVars)

    _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
    imgui.SameLine(0, SAMELINE_SPACING)
    _, menuVars.copyTable[2] = imgui.Checkbox("Copy SVs", menuVars.copyTable[2])
    _, menuVars.copyTable[3] = imgui.Checkbox("Copy SSFs", menuVars.copyTable[3])
    imgui.SameLine(0, SAMELINE_SPACING + 3.5)
    _, menuVars.copyTable[4] = imgui.Checkbox("Copy Bookmarks", menuVars.copyTable[4])

    addSeparator()

    local copiedItemCount = #menuVars.copiedLines + #menuVars.copiedSVs + #menuVars.copiedSSFs + #menuVars.copiedBMs

    if (copiedItemCount == 0) then
        simpleActionMenu("Copy items between selected notes", 2, copyItems, nil, menuVars)
    else
        button("Clear copied items", ACTION_BUTTON_SIZE, clearCopiedItems, nil, menuVars)
    end


    saveVariables("copyMenu", menuVars)

    if copiedItemCount == 0 then return end

    addSeparator()
    simpleActionMenu("Paste items at selected notes", 1, pasteItems, globalVars, menuVars)
end

-- Creates the displace note menu
function displaceNoteMenu()
    local menuVars = {
        distance = 200,
        distance1 = 0,
        distance2 = 200,
        linearlyChange = false
    }
    getVariables("displaceNoteMenu", menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    saveVariables("displaceNoteMenu", menuVars)

    addSeparator()
    simpleActionMenu("Displace selected notes", 1, displaceNoteSVsParent, nil, menuVars)
end

-- Creates the displace view menu
function displaceViewMenu()
    local menuVars = {
        distance = 200
    }
    getVariables("displaceViewMenu", menuVars)
    chooseDistance(menuVars)
    saveVariables("displaceViewMenu", menuVars)

    addSeparator()
    simpleActionMenu("Displace view between selected notes", 2, displaceViewSVs, nil, menuVars)
end

-- Creates the fix LN ends menu
function fixLNEndsMenu()
    local menuVars = {
        fixedText = "No flipped LN ends fixed yet"
    }
    getVariables("fixLNEndsMenu", menuVars)
    imgui.Text(menuVars.fixedText)
    helpMarker("If there is a negative SV at an LN end, the LN end will be flipped. This is " ..
        "noticable especially for arrow skins and is jarring. This tool will fix that.")

    addSeparator()
    simpleActionMenu("Fix flipped LN ends", 0, fixFlippedLNEnds, nil, menuVars)
    saveVariables("fixLNEndsMenu", menuVars)
end

-- Creates the dynamic scale menu
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function dynamicScaleMenu(globalVars)
    local menuVars = {
        noteTimes = {},
        svTypeIndex = 1,
        svMultipliers = {},
        svDistances = {},
        svGraphStats = createSVGraphStats(),
        svStats = createSVStats()
    }
    getVariables("dynamicScaleMenu", menuVars)
    local numNoteTimes = #menuVars.noteTimes
    imgui.Text(#menuVars.noteTimes .. " note times assigned to scale SVs between")
    addNoteTimesToDynamicScaleButton(menuVars)
    if numNoteTimes == 0 then
        saveVariables("dynamicScaleMenu", menuVars)
        return
    else
        clearNoteTimesButton(menuVars)
    end

    addSeparator()
    if #menuVars.noteTimes < 3 then
        imgui.Text("Not enough note times assigned")
        imgui.Text("Assign 3 or more note times instead")
        saveVariables("dynamicScaleMenu", menuVars)
        return
    end
    local numSVPoints = numNoteTimes - 1
    local needSVUpdate = #menuVars.svMultipliers == 0 or (#menuVars.svMultipliers ~= numSVPoints)
    imgui.AlignTextToFramePadding()
    imgui.Text("Shape:")
    imgui.SameLine(0, SAMELINE_SPACING)
    needSVUpdate = chooseStandardSVType(menuVars, true) or needSVUpdate

    addSeparator()
    local currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    if currentSVType == "Sinusoidal" then
        imgui.Text("Import sinusoidal values using 'Custom' instead")
        saveVariables("dynamicScaleMenu", menuVars)
        return
    end

    local settingVars = getSettingVars(currentSVType, "DynamicScale")
    needSVUpdate = showSettingsMenu(currentSVType, settingVars, true, numSVPoints) or needSVUpdate
    if needSVUpdate then updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, true) end

    startNextWindowNotCollapsed("svInfoAutoOpen")
    makeSVInfoWindow("SV Info", menuVars.svGraphStats, menuVars.svStats, menuVars.svDistances,
        menuVars.svMultipliers, nil, true)

    local labelText = table.concat({ currentSVType, "SettingsDynamicScale" })
    saveVariables(labelText, settingVars)
    saveVariables("dynamicScaleMenu", menuVars)

    addSeparator()
    simpleActionMenu("Scale spacing between assigned notes", 0, dynamicScaleSVs, nil, menuVars)
end

-- Creates the flicker menu
function flickerMenu()
    local menuVars = {
        flickerTypeIndex = 1,
        distance = -69420.727,
        distance1 = 0,
        distance2 = -69420.727,
        numFlickers = 1,
        linearlyChange = false
    }
    getVariables("flickerMenu", menuVars)
    chooseFlickerType(menuVars)
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    chooseNumFlickers(menuVars)
    saveVariables("flickerMenu", menuVars)

    addSeparator()
    simpleActionMenu("Add flicker SVs between selected notes", 2, flickerSVs, nil, menuVars)
end

-- Creates the measure menu
function measureMenu()
    local menuVars = {
        unrounded = false,
        nsvDistance = "",
        svDistance = "",
        avgSV = "",
        startDisplacement = "",
        endDisplacement = "",
        avgSVDisplaceless = "",
        roundedNSVDistance = 0,
        roundedSVDistance = 0,
        roundedAvgSV = 0,
        roundedStartDisplacement = 0,
        roundedEndDisplacement = 0,
        roundedAvgSVDisplaceless = 0
    }
    getVariables("measureMenu", menuVars)
    chooseMeasuredStatsView(menuVars)

    addSeparator()
    if menuVars.unrounded then
        displayMeasuredStatsUnrounded(menuVars)
    else
        displayMeasuredStatsRounded(menuVars)
    end
    addPadding()
    imgui.TextDisabled("*** Measuring disclaimer ***")
    toolTip("Measured values might not be 100%% accurate & may not work on older maps")

    addSeparator()
    simpleActionMenu("Measure SVs between selected notes", 2, measureSVs, nil, menuVars)
    saveVariables("measureMenu", menuVars)
end

-- Creates the merge menu
function mergeMenu()
    simpleActionMenu("Merge duplicate SVs between selected notes", 2, mergeSVs, nil, nil)
end

-- Creates the reverse scroll menu
function reverseScrollMenu()
    local menuVars = {
        distance = 400
    }
    getVariables("reverseScrollMenu", menuVars)
    chooseDistance(menuVars)
    helpMarker("Height at which reverse scroll notes are hit")
    saveVariables("reverseScrollMenu", menuVars)

    addSeparator()
    local buttonText = "Reverse scroll between selected notes"
    simpleActionMenu(buttonText, 2, reverseScrollSVs, nil, menuVars)
end

-- Creates the scale (displace) menu
function scaleDisplaceMenu()
    local menuVars = {
        scaleSpotIndex = 1,
        scaleTypeIndex = 1,
        avgSV = 0.6,
        distance = 100,
        ratio = 0.6,
    }
    getVariables("scaleDisplaceMenu", menuVars)
    chooseScaleDisplaceSpot(menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleDisplaceMenu", menuVars)

    addSeparator()
    local buttonText = "Scale SVs between selected notes##displace"
    simpleActionMenu(buttonText, 2, scaleDisplaceSVs, nil, menuVars)
end

-- Creates the scale (multiply) menu
function scaleMultiplyMenu()
    local menuVars = {
        scaleTypeIndex = 1,
        avgSV = 0.6,
        distance = 100,
        ratio = 0.6
    }
    getVariables("scaleMultiplyMenu", menuVars)
    chooseScaleType(menuVars)
    saveVariables("scaleMultiplyMenu", menuVars)

    addSeparator()
    local buttonText = "Scale SVs between selected notes##multiply"
    simpleActionMenu(buttonText, 2, scaleMultiplySVs, nil, menuVars)
end

-- Creates the menu for swapping notes
function swapNotesMenu()
    simpleActionMenu("Swap selected notes using SVs", 2, swapNoteSVs, nil, nil)
end

-- Creates the menu for vertical shifts of SVs
function verticalShiftMenu()
    local menuVars = {
        verticalShift = 1
    }
    getVariables("verticalShiftMenu", menuVars)
    chooseConstantShift(menuVars, 0)
    saveVariables("verticalShiftMenu", menuVars)

    addSeparator()
    local buttonText = "Vertically shift SVs between selected notes"
    simpleActionMenu(buttonText, 2, verticalShiftSVs, nil, menuVars)
end

-------------------------------------------------------------------------------------- Menu related

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

-- Lets you choose global plugin appearance settings
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function choosePluginAppearance(globalVars)
    if not imgui.CollapsingHeader("Plugin Appearance Settings") then return end
    addPadding()
    chooseStyleTheme(globalVars)
    chooseColorTheme(globalVars)
    addSeparator()
    chooseCursorTrail(globalVars)
    chooseCursorTrailShape(globalVars)
    chooseEffectFPS(globalVars)
    chooseCursorTrailPoints(globalVars)
    chooseCursorShapeSize(globalVars)
    chooseSnakeSpringConstant(globalVars)
    chooseCursorTrailGhost(globalVars)
    addSeparator()
    chooseDrawCapybara(globalVars)
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    chooseDrawCapybara2(globalVars)
    chooseDrawCapybara312(globalVars)
end

-- Gives basic info about how to use the plugin
function provideBasicPluginInfo()
    imgui.Text("Steps to use plumoguSV:")
    imgui.BulletText("Choose an SV tool")
    imgui.BulletText("Adjust the SV tool's settings")
    imgui.BulletText("Select notes to use the tool at/between")
    imgui.BulletText("Press 'T' on your keyboard")
    addPadding()
end

-- Gives more info about the plugin
function provideMorePluginInfo()
    if not imgui.CollapsingHeader("More Info") then return end
    addPadding()
    linkBox("Goofy SV mapping guide",
        "https://docs.google.com/document/d/1ug_WV_BI720617ybj4zuHhjaQMwa0PPekZyJoa17f-I")
    linkBox("GitHub repository", "https://github.com/ESV-Sweetplum/plumoguSV")
end

-- Lists keyboard shortcuts for the plugin
function listKeyboardShortcuts()
    if not imgui.CollapsingHeader("Keyboard Shortcuts") then return end
    local indentAmount = -6
    imgui.Indent(indentAmount)
    addPadding()
    imgui.BulletText("Ctrl + Shift + Tab = center plugin window")
    toolTip("Useful if the plugin begins or ends up offscreen")
    addSeparator()
    imgui.BulletText("Shift + Tab = focus plugin + navigate inputs")
    toolTip("Useful if you click off the plugin but want to quickly change an input value")
    addSeparator()
    imgui.BulletText("T = activate the big button doing SV stuff")
    toolTip("Use this to do SV stuff for a quick workflow")
    addSeparator()
    imgui.BulletText("Shift+T = activate the big button doing SSF stuff")
    toolTip("Use this to do SSF stuff for a quick workflow")
    addSeparator()
    imgui.BulletText("Alt + Shift + (Z or X) = switch tool type")
    toolTip("Use this to do SV stuff for a quick workflow")
    addPadding()
    imgui.Unindent(indentAmount)
end

-- Lets you choose plugin behavior settings
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function choosePluginBehaviorSettings(globalVars)
    if not imgui.CollapsingHeader("Plugin Behavior Settings") then return end
    addPadding()
    chooseKeyboardMode(globalVars)
    addSeparator()
    chooseUpscroll(globalVars)
    addSeparator()
    chooseDontReplaceSV(globalVars)
    chooseBetaIgnore(globalVars)
    chooseStepSize(globalVars)
    addPadding()
end

-- Displays measured SV stats rounded
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function displayMeasuredStatsRounded(menuVars)
    imgui.Columns(2, "Measured SV Stats", false)
    imgui.Text("NSV distance:")
    imgui.Text("SV distance:")
    imgui.Text("Average SV:")
    imgui.Text("Start displacement:")
    imgui.Text("End displacement:")
    imgui.Text("True average SV:")
    imgui.NextColumn()
    imgui.Text(table.concat({ menuVars.roundedNSVDistance, " msx" }))
    helpMarker("The normal distance between the start and the end, ignoring SVs")
    imgui.Text(table.concat({ menuVars.roundedSVDistance, " msx" }))
    helpMarker("The actual distance between the start and the end, calculated with SVs")
    imgui.Text(table.concat({ menuVars.roundedAvgSV, "x" }))
    imgui.Text(table.concat({ menuVars.roundedStartDisplacement, " msx" }))
    helpMarker("Calculated using plumoguSV displacement metrics, so might not always work")
    imgui.Text(table.concat({ menuVars.roundedEndDisplacement, " msx" }))
    helpMarker("Calculated using plumoguSV displacement metrics, so might not always work")
    imgui.Text(table.concat({ menuVars.roundedAvgSVDisplaceless, "x" }))
    helpMarker("Average SV calculated ignoring the start and end displacement")
    imgui.Columns(1)
end

-- Displays measured SV stats unrounded
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function displayMeasuredStatsUnrounded(menuVars)
    copiableBox("NSV distance", "##nsvDistance", menuVars.nsvDistance)
    copiableBox("SV distance", "##svDistance", menuVars.svDistance)
    copiableBox("Average SV", "##avgSV", menuVars.avgSV)
    copiableBox("Start displacement", "##startDisplacement", menuVars.startDisplacement)
    copiableBox("End displacement", "##endDisplacement", menuVars.endDisplacement)
    copiableBox("True average SV", "##avgSVDisplaceless", menuVars.avgSVDisplaceless)
end

-- Shows the settings menu for the current SV type
-- Returns whether or not any settings changed [Boolean]
-- Parameters
--    currentSVType : current SV type to choose the settings for [String]
--    settingVars   : list of variables used for the current menu [Table]
--    skipFinalSV   : whether or not to skip choosing the final SV [Boolean]
--    svPointsForce : number of SV points to force [Int or nil]
function showSettingsMenu(currentSVType, settingVars, skipFinalSV, svPointsForce)
    if currentSVType == "Linear" then
        return linearSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Exponential" then
        -- TODO: currently expo is the only one that needs globalVars so its parameters are different from the others thats  bad maybe
        return exponentialSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Bezier" then
        return bezierSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Hermite" then
        return hermiteSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Sinusoidal" then
        return sinusoidalSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Circular" then
        return circularSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Random" then
        return randomSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Custom" then
        return customSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Chinchilla" then
        return chinchillaSettingsMenu(settingVars, skipFinalSV, svPointsForce)
    elseif currentSVType == "Combo" then
        return comboSettingsMenu(settingVars)
    end
end

-- Provides a copy-pastable link to a cubic bezier website and also can parse inputted links
-- Returns whether new bezier coordinates were parsed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function provideBezierWebsiteLink(settingVars)
    local coordinateParsed = false
    local bezierText = state.GetValue("bezierText") or "https://cubic-bezier.com/"
    local imguiFlag = imgui_input_text_flags.AutoSelectAll
    _, bezierText = imgui.InputText("##bezierWebsite", bezierText, 100, imguiFlag)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.Button("Parse##beizerValues", SECONDARY_BUTTON_SIZE) then
        local regex = "(-?%d*%.?%d+)"
        local values = {}
        for value, _ in string.gmatch(bezierText, regex) do
            table.insert(values, tonumber(value))
        end
        if #values >= 4 then
            settingVars.x1, settingVars.y1, settingVars.x2, settingVars.y2 = table.unpack(values)
            coordinateParsed = true
        end
        bezierText = "https://cubic-bezier.com/"
    end
    state.SetValue("bezierText", bezierText)
    helpMarker("This site lets you play around with a cubic bezier whose graph represents the " ..
        "motion/path of notes. After finding a good shape for note motion, paste the " ..
        "resulting url into the input box and hit the parse button to import the " ..
        "coordinate values. Alternatively, enter 4 numbers and hit parse.")
    return coordinateParsed
end

-- Provides an import box to parse inputted custom SVs
-- Returns whether new custom SVs were parsed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function importCustomSVs(settingVars)
    local svsParsed = false
    local customSVText = state.GetValue("customSVText") or "Import SV values here"
    local imguiFlag = imgui_input_text_flags.AutoSelectAll
    _, customSVText = imgui.InputText("##customSVs", customSVText, 99999, imguiFlag)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.Button("Parse##customSVs", SECONDARY_BUTTON_SIZE) then
        local regex = "(-?%d*%.?%d+)"
        local values = {}
        for value, _ in string.gmatch(customSVText, regex) do
            table.insert(values, tonumber(value))
        end
        if #values >= 1 then
            settingVars.svMultipliers = values
            settingVars.selectedMultiplierIndex = 1
            settingVars.svPoints = #values
            svsParsed = true
        end
        customSVText = "Import SV values here"
    end
    state.SetValue("customSVText", customSVText)
    helpMarker("Paste custom SV values in the box then hit the parse button (ex. 2 -1 2 -1)")
    return svsParsed
end

-- Updates SVs and SV info stored in the menu
-- Parameters
--    currentSVType : current type of SV being updated [String]
--    globalVars    : list of variables used globally across all menus [Table]
--    menuVars      : list of variables used for the place SV menu [Table]
--    settingVars   : list of variables used for the current menu [Table]
--    skipFinalSV   : whether or not to skip the final SV for updating menu SVs [Boolean]
function updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, skipFinalSV)
    local interlaceMultiplier = nil
    if menuVars.interlace then interlaceMultiplier = menuVars.interlaceRatio end
    menuVars.svMultipliers = generateSVMultipliers(currentSVType, settingVars, interlaceMultiplier)
    local svMultipliersNoEndSV = makeDuplicateList(menuVars.svMultipliers)
    table.remove(svMultipliersNoEndSV)
    menuVars.svDistances = calculateDistanceVsTime(globalVars, svMultipliersNoEndSV)

    updateFinalSV(settingVars.finalSVIndex, menuVars.svMultipliers, settingVars.customSV,
        skipFinalSV)
    updateSVStats(menuVars.svGraphStats, menuVars.svStats, menuVars.svMultipliers,
        svMultipliersNoEndSV, menuVars.svDistances)
end

-- Updates the final SV of the precalculated menu SVs
-- Parameters
--    finalSVIndex  : index value for the type of final SV [Int]
--    svMultipliers : list of SV multipliers [Table]
--    customSV      : custom SV value [Int/Float]
--    skipFinalSV   : whether or not to skip the final SV for updating menu SVs [Boolean]
function updateFinalSV(finalSVIndex, svMultipliers, customSV, skipFinalSV)
    if skipFinalSV then
        table.remove(svMultipliers)
        return
    end

    local finalSVType = FINAL_SV_TYPES[finalSVIndex]
    if finalSVType == "Normal" then return end
    svMultipliers[#svMultipliers] = customSV
end

-- Updates stats for the current menu's SVs
-- Parameters
--    svGraphStats         : list of stats for the SV graphs [Table]
--    svStats              : list of stats for the current menu's SVs [Table]
--    svMultipliers        : list of sv multipliers [Table]
--    svMultipliersNoEndSV : list of sv multipliers, no end multiplier [Table]
--    svDistances          : list of distances calculated from SV multipliers [Table]
function updateSVStats(svGraphStats, svStats, svMultipliers, svMultipliersNoEndSV, svDistances)
    updateGraphStats(svGraphStats, svMultipliers, svDistances)
    svStats.minSV = round(calculateMinValue(svMultipliersNoEndSV), 2)
    svStats.maxSV = round(calculateMaxValue(svMultipliersNoEndSV), 2)
    svStats.avgSV = round(calculateAverage(svMultipliersNoEndSV, true), 3)
end

-- Updates scale stats for SV graphs
-- Parameters
--    graphStats : list of graph scale numbers [Table]
--    svMultipliers : list of SV multipliers[Table]
--    svDistances : list of SV distances [Table]
function updateGraphStats(graphStats, svMultipliers, svDistances)
    graphStats.minScale, graphStats.maxScale = calculatePlotScale(svMultipliers)
    graphStats.distMinScale, graphStats.distMaxScale = calculatePlotScale(svDistances)
end

-- Creates a new window with plots/graphs and stats of the current menu's SVs
-- Parameters
--    windowText      : name of the window [String]
--    svGraphStats    : stats of the SV graphs [Table]
--    svStats         : stats of the SV multipliers [Table]
--    svDistances     : distance vs time list [Table]
--    svMultipliers   : multiplier values of the SVs [Table]
--    stutterDuration : percent duration of first stutter (nil if not stutter SV) [Int]
--    skipDistGraph   : whether or not to skip showing the distance graph [Boolean]
function makeSVInfoWindow(windowText, svGraphStats, svStats, svDistances, svMultipliers,
                          stutterDuration, skipDistGraph)
    imgui.Begin(windowText, imgui_window_flags.AlwaysAutoResize)
    if not skipDistGraph then
        imgui.Text("Projected Note Motion:")
        helpMarker("Distance vs Time graph of notes")
        plotSVMotion(svDistances, svGraphStats.distMinScale, svGraphStats.distMaxScale)
        if imgui.CollapsingHeader("New All -w-") then
            for i = 1, #svDistances do
                local svDistance = svDistances[i]
                local content = tostring(svDistance)
                imgui.PushItemWidth(imgui.GetContentRegionAvailWidth())
                imgui.InputText("##" .. i, content, #content, imgui_input_text_flags.AutoSelectAll)
                imgui.PopItemWidth()
            end
        end
    end
    local projectedText = "Projected SVs:"
    if skipDistGraph then projectedText = "Projected Scaling (Avg SVs):" end
    imgui.Text(projectedText)
    plotSVs(svMultipliers, svGraphStats.minScale, svGraphStats.maxScale)
    if stutterDuration then
        displayStutterSVStats(svMultipliers, stutterDuration)
    else
        displaySVStats(svStats)
    end
    imgui.End()
end

-- Displays stats for stutter SVs
-- Parameters
--    svMultipliers   : stutter multipliers [Table]
--    stutterDuration : duration of the stutter (out of 100) [Int]
function displayStutterSVStats(svMultipliers, stutterDuration)
    local firstSV = round(svMultipliers[1], 3)
    local secondSV = round(svMultipliers[2], 3)
    local firstDuration = stutterDuration
    local secondDuration = 100 - stutterDuration
    imgui.Columns(2, "SV Stutter Stats", false)
    imgui.Text("First SV:")
    imgui.Text("Second SV:")
    imgui.NextColumn()
    local firstText = table.concat({ firstSV, "x  (", firstDuration, "%% duration)" })
    local secondText = table.concat({ secondSV, "x  (", secondDuration, "%% duration)" })
    imgui.Text(firstText)
    imgui.Text(secondText)
    imgui.Columns(1)
end

-- Displays stats for the current menu's SVs
-- Parameters
--    svStats : list of stats for the current menu [Table]
function displaySVStats(svStats)
    imgui.Columns(2, "SV Stats", false)
    imgui.Text("Max SV:")
    imgui.Text("Min SV:")
    imgui.Text("Average SV:")
    imgui.NextColumn()
    imgui.Text(svStats.maxSV .. "x")
    imgui.Text(svStats.minSV .. "x")
    imgui.Text(svStats.avgSV .. "x")
    helpMarker("Rounded to 3 decimal places")
    imgui.Columns(1)
end

-- Creates a new set of random SV multipliers for the random menu's SVs
-- Parameters
--    settingVars : list of variables used for the random SV menu [Table]
function generateRandomSetMenuSVs(settingVars)
    local randomType = RANDOM_TYPES[settingVars.randomTypeIndex]
    settingVars.svMultipliers = generateRandomSet(settingVars.svPoints + 1, randomType,
        settingVars.randomScale)
end

-- Adjusts the number of SV multipliers available for the custom SV menu
-- Parameters
--    settingVars : list of variables used for the custom SV menu [Table]
function adjustNumberOfMultipliers(settingVars)
    if settingVars.svPoints > #settingVars.svMultipliers then
        local difference = settingVars.svPoints - #settingVars.svMultipliers
        for i = 1, difference do
            table.insert(settingVars.svMultipliers, 1)
        end
    end
    if settingVars.svPoints >= #settingVars.svMultipliers then return end

    if settingVars.selectedMultiplierIndex > settingVars.svPoints then
        settingVars.selectedMultiplierIndex = settingVars.svPoints
    end
    local difference = #settingVars.svMultipliers - settingVars.svPoints
    for i = 1, difference do
        table.remove(settingVars.svMultipliers)
    end
end

-- Updates SVs and SV info stored in the stutter menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function updateStutterMenuSVs(settingVars)
    settingVars.svMultipliers = generateSVMultipliers("Stutter1", settingVars, nil)
    local svMultipliersNoEndSV = makeDuplicateList(settingVars.svMultipliers)
    table.remove(svMultipliersNoEndSV)

    settingVars.svMultipliers2 = generateSVMultipliers("Stutter2", settingVars, nil)
    local svMultipliersNoEndSV2 = makeDuplicateList(settingVars.svMultipliers2)
    table.remove(svMultipliersNoEndSV2)

    settingVars.svDistances = calculateStutterDistanceVsTime(svMultipliersNoEndSV,
        settingVars.stutterDuration,
        settingVars.stuttersPerSection)
    settingVars.svDistances2 = calculateStutterDistanceVsTime(svMultipliersNoEndSV2,
        settingVars.stutterDuration,
        settingVars.stuttersPerSection)

    if settingVars.linearlyChange then
        updateFinalSV(settingVars.finalSVIndex, settingVars.svMultipliers2, settingVars.customSV,
            false)
        table.remove(settingVars.svMultipliers)
    else
        updateFinalSV(settingVars.finalSVIndex, settingVars.svMultipliers, settingVars.customSV,
            false)
    end
    updateGraphStats(settingVars.svGraphStats, settingVars.svMultipliers, settingVars.svDistances)
    updateGraphStats(settingVars.svGraph2Stats, settingVars.svMultipliers2,
        settingVars.svDistances2)
end

-- Makes the SV info windows for stutter SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function displayStutterSVWindows(settingVars)
    if settingVars.linearlyChange then
        startNextWindowNotCollapsed("svInfo2AutoOpen")
        makeSVInfoWindow("SV Info (Starting first SV)", settingVars.svGraphStats, nil,
            settingVars.svDistances, settingVars.svMultipliers,
            settingVars.stutterDuration, false)
        startNextWindowNotCollapsed("svInfo3AutoOpen")
        makeSVInfoWindow("SV Info (Ending first SV)", settingVars.svGraph2Stats, nil,
            settingVars.svDistances2, settingVars.svMultipliers2,
            settingVars.stutterDuration, false)
    else
        startNextWindowNotCollapsed("svInfo1AutoOpen")
        makeSVInfoWindow("SV Info", settingVars.svGraphStats, nil, settingVars.svDistances,
            settingVars.svMultipliers, settingVars.stutterDuration, false)
    end
end

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
    settingVars.noteTimes2 = dedupe(settingVars.noteTimes2)
    settingVars.noteTimes2 = table.sort(settingVars.noteTimes2, sortAscending)
end

-- Creates a button that adds selected note times to the splitscroll 3rd scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes2(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes3, hitObject.StartTime)
    end
    settingVars.noteTimes3 = dedupe(settingVars.noteTimes3)
    settingVars.noteTimes3 = table.sort(settingVars.noteTimes3, sortAscending)
end

-- Creates a button that adds selected note times to the splitscroll 4th scroll list
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addSelectedNoteTimes3(settingVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(settingVars.noteTimes4, hitObject.StartTime)
    end
    settingVars.noteTimes4 = dedupe(settingVars.noteTimes4)
    settingVars.noteTimes4 = table.sort(settingVars.noteTimes4, sortAscending)
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

-- Creates the export button for Place SV settings
-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    menuVars    : list of setting variables for the current menu [Table]
--    settingVars : list of setting variables for the current sv type [Table]
function exportPlaceSVButton(globalVars, menuVars, settingVars)
    local buttonText = "Export current settings for current menu"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end

    local exportList = {}
    local placeType = PLACE_TYPES[globalVars.placeTypeIndex]
    local stillType = placeType == "Still"
    local regularType = placeType == "Standard" or stillType
    local specialType = placeType == "Special"
    local currentSVType
    if regularType then
        currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    elseif specialType then
        currentSVType = SPECIAL_SVS[menuVars.svTypeIndex]
    end
    exportList[1] = placeType
    exportList[2] = currentSVType
    if regularType then
        table.insert(exportList, tostring(menuVars.interlace))
        table.insert(exportList, menuVars.interlaceRatio)
    end
    if stillType then
        table.insert(exportList, menuVars.noteSpacing)
        table.insert(exportList, menuVars.stillTypeIndex)
        table.insert(exportList, menuVars.stillDistance)
    end
    if currentSVType == "Linear" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Exponential" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.intensity)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Bezier" then
        table.insert(exportList, settingVars.x1)
        table.insert(exportList, settingVars.y1)
        table.insert(exportList, settingVars.x2)
        table.insert(exportList, settingVars.y2)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Hermite" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Sinusoidal" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.curveSharpness)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.periods)
        table.insert(exportList, settingVars.periodsShift)
        table.insert(exportList, settingVars.svsPerQuarterPeriod)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Circular" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.arcPercent)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.dontNormalize))
    elseif currentSVType == "Random" then
        for i = 1, #settingVars.svMultipliers do
            table.insert(exportList, settingVars.svMultipliers[i])
        end
        table.insert(exportList, settingVars.randomTypeIndex)
        table.insert(exportList, settingVars.randomScale)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.dontNormalize))
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
    elseif currentSVType == "Custom" then
        for i = 1, #settingVars.svMultipliers do
            table.insert(exportList, settingVars.svMultipliers[i])
        end
        table.insert(exportList, settingVars.selectedMultiplierIndex)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Chinchilla" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.chinchillaTypeIndex)
        table.insert(exportList, settingVars.chinchillaIntensity)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Stutter" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.stutterDuration)
        table.insert(exportList, settingVars.stuttersPerSection)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.linearlyChange))
        table.insert(exportList, tostring(settingVars.controlLastSV))
    elseif currentSVType == "Teleport Stutter" then
        table.insert(exportList, settingVars.svPercent)
        table.insert(exportList, settingVars.svPercent2)
        table.insert(exportList, settingVars.distance)
        table.insert(exportList, settingVars.mainSV)
        table.insert(exportList, settingVars.mainSV2)
        table.insert(exportList, tostring(settingVars.useDistance))
        table.insert(exportList, tostring(settingVars.linearlyChange))
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Splitscroll (Adv v2)" then
        table.insert(exportList, settingVars.numScrolls)
        table.insert(exportList, settingVars.msPerFrame)
        table.insert(exportList, settingVars.scrollIndex)
        table.insert(exportList, settingVars.distanceBack)
        table.insert(exportList, settingVars.distanceBack2)
        table.insert(exportList, settingVars.distanceBack3)
        local splitscrollLayers = settingVars.splitscrollLayers
        local totalLayersSupported = 4
        for i = 1, totalLayersSupported do
            local currentLayer = settingVars.splitscrollLayers[i]
            if currentLayer ~= nil then
                local currentLayerSVs = currentLayer.svs
                local svsStringTable = {}
                for j = 1, #currentLayerSVs do
                    local currentSV = currentLayerSVs[j]
                    local svStringTable = {}
                    table.insert(svStringTable, currentSV.StartTime)
                    table.insert(svStringTable, currentSV.Multiplier)
                    local svString = table.concat(svStringTable, "+")
                    table.insert(svsStringTable, svString)
                end
                local svsString = table.concat(svsStringTable, " ")

                local currentLayerNotes = currentLayer.notes
                local notesStringTable = {}
                for j = 1, #currentLayerNotes do
                    local currentNote = currentLayerNotes[j]
                    local noteStringTable = {}
                    table.insert(noteStringTable, currentNote.StartTime)
                    table.insert(noteStringTable, currentNote.Lane)
                    -- could add other stuff like editor layer, but too much work
                    local noteString = table.concat(noteStringTable, "+")
                    table.insert(notesStringTable, noteString)
                end
                local notesString = table.concat(notesStringTable, " ")
                local layersDataTable = { i, svsString, notesString }
                local layersString = table.concat(layersDataTable, ":")
                table.insert(exportList, layersString)
            end
        end
    end
    globalVars.exportData = table.concat(exportList, "|")
end

-- Creates the export button for exporting as custom SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    menuVars   : list of setting variables for the current menu [Table]
function exportCustomSVButton(globalVars, menuVars)
    local buttonText = "Export current SVs as custom SV data"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end

    local multipliersCopy = makeDuplicateList(menuVars.svMultipliers)
    table.remove(multipliersCopy)
    globalVars.exportCustomSVData = table.concat(multipliersCopy, " ")
end

-- Creates the import button for Place SV settings
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function importPlaceSVButton(globalVars)
    local buttonText = "Import settings from pasted data"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end

    -- Variant of code based on
    -- https://stackoverflow.com/questions/6075262/
    --    lua-table-tostringtablename-and-table-fromstringstringtable-functions
    local settingsTable = {}
    for str in string.gmatch(globalVars.importData, "([^|]+)") do
        local num = tonumber(str)
        if num ~= nil then
            table.insert(settingsTable, num)
        elseif str == "false" then
            table.insert(settingsTable, false)
        elseif str == "true" then
            table.insert(settingsTable, true)
        else
            table.insert(settingsTable, str)
        end
    end
    if #settingsTable < 2 then return end

    local placeType         = table.remove(settingsTable, 1)
    local currentSVType     = table.remove(settingsTable, 1)

    local standardPlaceType = placeType == "Standard"
    local specialPlaceType  = placeType == "Special"
    local stillPlaceType    = placeType == "Still"

    local menuVars

    print(currentSVType)


    if standardPlaceType then menuVars = getStandardPlaceMenuVars() end
    if specialPlaceType then menuVars = getSpecialPlaceMenuVars() end
    if stillPlaceType then menuVars = getStillPlaceMenuVars() end

    local linearSVType      = currentSVType == "Linear"
    local exponentialSVType = currentSVType == "Exponential"
    local bezierSVType      = currentSVType == "Bezier"
    local hermiteSVType     = currentSVType == "Hermite"
    local sinusoidalSVType  = currentSVType == "Sinusoidal"
    local circularSVType    = currentSVType == "Circular"
    local randomSVType      = currentSVType == "Random"
    local customSVType      = currentSVType == "Custom"
    local chinchillaSVType  = currentSVType == "Chinchilla"
    local stutterSVType     = currentSVType == "Stutter"
    local tpStutterSVType   = currentSVType == "Teleport Stutter"
    local advSplitV2SVType  = currentSVType == "Splitscroll (Adv v2)"

    local settingVars
    if standardPlaceType then
        settingVars = getSettingVars(currentSVType, "Standard")
    elseif stillPlaceType then
        settingVars = getSettingVars(currentSVType, "Still")
    else
        settingVars = getSettingVars(currentSVType, "Special")
    end

    if standardPlaceType then globalVars.placeTypeIndex = 1 end
    if specialPlaceType then globalVars.placeTypeIndex = 2 end
    if stillPlaceType then globalVars.placeTypeIndex = 3 end

    if linearSVType then menuVars.svTypeIndex = 1 end
    if exponentialSVType then menuVars.svTypeIndex = 2 end
    if bezierSVType then menuVars.svTypeIndex = 3 end
    if hermiteSVType then menuVars.svTypeIndex = 4 end
    if sinusoidalSVType then menuVars.svTypeIndex = 5 end
    if circularSVType then menuVars.svTypeIndex = 6 end
    if randomSVType then menuVars.svTypeIndex = 7 end
    if customSVType then menuVars.svTypeIndex = 8 end
    if chinchillaSVType then menuVars.svTypeIndex = 9 end

    if stutterSVType then menuVars.svTypeIndex = 1 end
    if tpStutterSVType then menuVars.svTypeIndex = 2 end
    if advSplitV2SVType then menuVars.svTypeIndex = 5 end

    if standardPlaceType or stillPlaceType then
        menuVars.interlace = table.remove(settingsTable, 1)
        menuVars.interlaceRatio = table.remove(settingsTable, 1)
    end
    if stillPlaceType then
        menuVars.noteSpacing = table.remove(settingsTable, 1)
        menuVars.stillTypeIndex = table.remove(settingsTable, 1)
        menuVars.stillDistance = table.remove(settingsTable, 1)
    end
    if linearSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif exponentialSVType then
        settingVars.intensity = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif bezierSVType then
        settingVars.x1 = table.remove(settingsTable, 1)
        settingVars.y1 = table.remove(settingsTable, 1)
        settingVars.x2 = table.remove(settingsTable, 1)
        settingVars.y2 = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif hermiteSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif sinusoidalSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.curveSharpness = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.periods = table.remove(settingsTable, 1)
        settingVars.periodsShift = table.remove(settingsTable, 1)
        settingVars.svsPerQuarterPeriod = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif circularSVType then
        settingVars.behaviorIndex = table.remove(settingsTable, 1)
        settingVars.arcPercent = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
        settingVars.dontNormalize = table.remove(settingsTable, 1)
    elseif randomSVType then
        settingVars.verticalShift = table.remove(settingsTable)
        settingVars.avgSV = table.remove(settingsTable)
        settingVars.dontNormalize = table.remove(settingsTable)
        settingVars.customSV = table.remove(settingsTable)
        settingVars.finalSVIndex = table.remove(settingsTable)
        settingVars.svPoints = table.remove(settingsTable)
        settingVars.randomScale = table.remove(settingsTable)
        settingVars.randomTypeIndex = table.remove(settingsTable)
        settingVars.svMultipliers = settingsTable
    elseif customSVType then
        settingVars.customSV = table.remove(settingsTable)
        settingVars.finalSVIndex = table.remove(settingsTable)
        settingVars.svPoints = table.remove(settingsTable)
        settingVars.selectedMultiplierIndex = table.remove(settingsTable)
        settingVars.svMultipliers = settingsTable
    elseif chinchillaSVType then
        settingVars.behaviorIndex = table.remove(settingsTable, 1)
        settingVars.chinchillaTypeIndex = table.remove(settingsTable, 1)
        settingVars.chinchillaIntensity = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    end

    if stutterSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.stutterDuration = table.remove(settingsTable, 1)
        settingVars.stuttersPerSection = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
        settingVars.linearlyChange = table.remove(settingsTable, 1)
        settingVars.controlLastSV = table.remove(settingsTable, 1)
    elseif tpStutterSVType then
        settingVars.svPercent = table.remove(settingsTable, 1)
        settingVars.svPercent2 = table.remove(settingsTable, 1)
        settingVars.distance = table.remove(settingsTable, 1)
        settingVars.mainSV = table.remove(settingsTable, 1)
        settingVars.mainSV2 = table.remove(settingsTable, 1)
        settingVars.useDistance = table.remove(settingsTable, 1)
        settingVars.linearlyChange = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif advSplitV2SVType then
        settingVars.numScrolls = table.remove(settingsTable, 1)
        settingVars.msPerFrame = table.remove(settingsTable, 1)
        settingVars.scrollIndex = table.remove(settingsTable, 1)
        settingVars.distanceBack = table.remove(settingsTable, 1)
        settingVars.distanceBack2 = table.remove(settingsTable, 1)
        settingVars.distanceBack3 = table.remove(settingsTable, 1)
        settingVars.splitscrollLayers = {}
        while #settingsTable > 0 do
            local splitscrollLayerString = table.remove(settingsTable)
            local layerDataStringTable = {}
            for str in string.gmatch(splitscrollLayerString, "([^:]+)") do
                table.insert(layerDataStringTable, str)
            end
            local layerNumber = tonumber(layerDataStringTable[1])
            local layerSVs = {}
            local svDataString = layerDataStringTable[2]
            for str in string.gmatch(svDataString, "([^%s]+)") do
                local svDataTable = {}
                for svData in string.gmatch(str, "([^%+]+)") do
                    table.insert(svDataTable, tonumber(svData))
                end
                local svStartTime = svDataTable[1]
                local svMultiplier = svDataTable[2]
                addSVToList(layerSVs, svStartTime, svMultiplier, true)
            end
            local layerNotes = {}
            local noteDataString = layerDataStringTable[3]
            for str in string.gmatch(noteDataString, "([^%s]+)") do
                local noteDataTable = {}
                for noteData in string.gmatch(str, "([^%+]+)") do
                    table.insert(noteDataTable, tonumber(noteData))
                end
                local noteStartTime = noteDataTable[1]
                local noteLane = noteDataTable[2]
                table.insert(layerNotes, utils.CreateHitObject(noteStartTime, noteLane))
            end
            settingVars.splitscrollLayers[layerNumber] = {
                svs = layerSVs,
                notes = layerNotes
            }
        end
    end
    if standardPlaceType then
        updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false)
        local labelText = table.concat({ currentSVType, "SettingsStandard" })
        saveVariables(labelText, settingVars)
    elseif stillPlaceType then
        updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false)
        local labelText = table.concat({ currentSVType, "SettingsStill" })
        saveVariables(labelText, settingVars)
    elseif stutterSVType then
        updateStutterMenuSVs(settingVars)
        local labelText = table.concat({ currentSVType, "SettingsSpecial" })
        saveVariables(labelText, settingVars)
    else
        local labelText = table.concat({ currentSVType, "SettingsSpecial" })
        saveVariables(labelText, settingVars)
    end

    if standardPlaceType then saveVariables("placeStandardMenu", menuVars) end
    if specialPlaceType then saveVariables("placeSpecialMenu", menuVars) end
    if stillPlaceType then saveVariables("placeStillMenu", menuVars) end

    globalVars.importData = ""
    globalVars.showExportImportMenu = false
end

-- Creates a button that adds frameTime objects to the list in the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function addFrameTimes(settingVars)
    if not imgui.Button("Add selected notes to use for frames", ACTION_BUTTON_SIZE) then return end

    local hasAlreadyAddedLaneTime = {}
    for i = 1, map.GetKeyCount() do
        table.insert(hasAlreadyAddedLaneTime, {})
    end
    local frameTimeToIndex = {}
    local totalTimes = #settingVars.frameTimes
    for i = 1, totalTimes do
        local frameTime = settingVars.frameTimes[i]
        local time = frameTime.time
        local lanes = frameTime.lanes
        frameTimeToIndex[time] = i
        for j = 1, #lanes do
            local lane = lanes[j]
            hasAlreadyAddedLaneTime[lane][time] = true
        end
    end
    for _, hitObject in pairs(state.SelectedHitObjects) do
        local lane = hitObject.Lane
        local time = hitObject.StartTime
        if (not hasAlreadyAddedLaneTime[lane][time]) then
            hasAlreadyAddedLaneTime[lane][time] = true
            if frameTimeToIndex[time] then
                local index = frameTimeToIndex[time]
                local frameTime = settingVars.frameTimes[index]
                table.insert(frameTime.lanes, lane)
                frameTime.lanes = table.sort(frameTime.lanes, sortAscending)
            else
                local defaultFrame = settingVars.currentFrame
                local defaultPosition = 0
                local newFrameTime = createFrameTime(time, { lane }, defaultFrame, defaultPosition)
                table.insert(settingVars.frameTimes, newFrameTime)
                frameTimeToIndex[time] = #settingVars.frameTimes
            end
        end
    end
    settingVars.frameTimes = table.sort(settingVars.frameTimes, sortAscendingTime)
end

-- Displays all existing frameTimes for the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function displayFrameTimes(settingVars)
    if #settingVars.frameTimes == 0 then
        imgui.Text("Add notes to fill the selection box below")
    else
        imgui.Text("time | lanes | frame # | position")
    end
    helpMarker("Make sure to select ALL lanes from a chord with multiple notes, not just one lane")
    addPadding()
    local frameTimeSelectionArea = { ACTION_BUTTON_SIZE[1], 120 }
    imgui.BeginChild("FrameTimes", frameTimeSelectionArea, true)
    for i = 1, #settingVars.frameTimes do
        local frameTimeData = {}
        local frameTime = settingVars.frameTimes[i]
        frameTimeData[1] = frameTime.time
        frameTimeData[2] = table.concat(frameTime.lanes, ", ")
        frameTimeData[3] = frameTime.frame
        frameTimeData[4] = frameTime.position
        local selectableText = table.concat(frameTimeData, " | ")
        if imgui.Selectable(selectableText, settingVars.selectedTimeIndex == i) then
            settingVars.selectedTimeIndex = i
        end
    end
    imgui.EndChild()
end

-- Makes the button that removes the currently selected frame time for the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function removeSelectedFrameTimeButton(settingVars)
    if #settingVars.frameTimes == 0 then return end
    if not imgui.Button("Removed currently selected time", BEEG_BUTTON_SIZE) then return end
    table.remove(settingVars.frameTimes, settingVars.selectedTimeIndex)
    local maxIndex = math.max(1, #settingVars.frameTimes)
    settingVars.selectedTimeIndex = clampToInterval(settingVars.selectedTimeIndex, 1, maxIndex)
end

-- Draws notes from the currently selected frame for the frames setup menu
-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    settingVars : list of variables used for the current menu [Table]
function drawCurrentFrame(globalVars, settingVars)
    local mapKeyCount = map.GetKeyCount()
    local noteWidth = 200 / mapKeyCount
    local noteSpacing = 5
    local barNoteHeight = round(2 * noteWidth / 5, 0)
    local noteColor = rgbaToUint(117, 117, 117, 255)
    local noteSkinType = NOTE_SKIN_TYPES[settingVars.noteSkinTypeIndex]
    local drawlist = imgui.GetWindowDrawList()
    local childHeight = 250
    imgui.BeginChild("Current Frame", { 255, childHeight }, true)
    for _, frameTime in pairs(settingVars.frameTimes) do
        if frameTime.frame == settingVars.currentFrame then
            for _, lane in pairs(frameTime.lanes) do
                if noteSkinType == "Bar" then
                    local x1 = 2 * noteSpacing + (noteWidth + noteSpacing) * (lane - 1)
                    local y1 = (childHeight - 2 * noteSpacing) - (frameTime.position / 2)
                    local x2 = x1 + noteWidth
                    local y2 = y1 - barNoteHeight
                    if globalVars.upscroll then
                        y1 = childHeight - y1
                        y2 = y1 + barNoteHeight
                    end
                    local p1 = coordsRelativeToWindow(x1, y1)
                    local p2 = coordsRelativeToWindow(x2, y2)
                    drawlist.AddRectFilled(p1, p2, noteColor)
                elseif noteSkinType == "Circle" then
                    local circleRadius = noteWidth / 2
                    local leftBlankSpace = 2 * noteSpacing + circleRadius
                    local yBlankSpace = 2 * noteSpacing + circleRadius + frameTime.position / 2
                    local x1 = leftBlankSpace + (noteWidth + noteSpacing) * (lane - 1)
                    local y1 = childHeight - yBlankSpace
                    if globalVars.upscroll then
                        y1 = childHeight - y1
                    end
                    local p1 = coordsRelativeToWindow(x1, y1)
                    drawlist.AddCircleFilled(p1, circleRadius, noteColor, 20)
                elseif noteSkinType == "Arrow" then
                    local fuckArrows
                end
            end
        end
    end
    imgui.EndChild()
end

-- Creates a button that adds note times for the dynamic scale menu
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function addNoteTimesToDynamicScaleButton(menuVars)
    local buttonText = "Assign selected note times"
    button(buttonText, ACTION_BUTTON_SIZE, addSelectedNoteTimesToList, nil, menuVars)
end

-- Adds selected note times to the noteTimes list in menuVars
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function addSelectedNoteTimesToList(menuVars)
    for _, hitObject in pairs(state.SelectedHitObjects) do
        table.insert(menuVars.noteTimes, hitObject.StartTime)
    end
    menuVars.noteTimes = dedupe(menuVars.noteTimes)
    menuVars.noteTimes = table.sort(menuVars.noteTimes, sortAscending)
end

-- Creates a button that lets you clear all assigned note times for the current menu
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function clearNoteTimesButton(menuVars)
    if not imgui.Button("Clear all assigned note times", BEEG_BUTTON_SIZE) then return end
    menuVars.noteTimes = {}
end

---------------------------------------------------------------------------------------------------
-- General Utility Functions ----------------------------------------------------------------------
---------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------- Drawing

-- Checks and returns whether or not the frame number has changed [Boolean]
-- Parameters
--    currentTime : current in-game time of the plugin [Int/Float]
--    fps         : frames per second set by the user/plugin [Int]
function checkIfFrameChanged(currentTime, fps)
    local oldFrameInfo = {
        frameNumber = 0
    }
    getVariables("oldFrameInfo", oldFrameInfo)
    local newFrameNumber = math.floor(currentTime * fps) % fps
    local frameChanged = oldFrameInfo.frameNumber ~= newFrameNumber
    oldFrameInfo.frameNumber = newFrameNumber
    saveVariables("oldFrameInfo", oldFrameInfo)
    return frameChanged
end

--[[ may implement in the future when making mouse click effects
-- Checks and returns whether or not the mouse has been clicked [Boolean]
function checkIfMouseClicked()
    local mouseDownBefore = state.GetValue("wasMouseDown")
    local mouseDownNow = imgui.IsAnyMouseDown()
    state.SetValue("wasMouseDown", mouseDownNow)
    return (not mouseDownBefore) and mouseDownNow
end
--]]
-- Checks and returns whether or not the mouse position has changed [Boolean]
-- Parameters
--    currentMousePosition : current (x, y) coordinates of the mouse [Table]
function checkIfMouseMoved(currentMousePosition)
    local oldMousePosition = {
        x = 0,
        y = 0
    }
    getVariables("oldMousePosition", oldMousePosition)
    local xChanged = currentMousePosition.x ~= oldMousePosition.x
    local yChanged = currentMousePosition.y ~= oldMousePosition.y
    local mousePositionChanged = xChanged or yChanged
    oldMousePosition.x = currentMousePosition.x
    oldMousePosition.y = currentMousePosition.y
    saveVariables("oldMousePosition", oldMousePosition)
    return mousePositionChanged
end

-- Returns coordinates relative to the plugin window [Table]
-- Parameters
--    x : x coordinate relative to the plugin window [Int]
--    y : y coordinate relative to the plugin window [Int]
function coordsRelativeToWindow(x, y)
    local newX = x + imgui.GetWindowPos()[1]
    local newY = y + imgui.GetWindowPos()[2]
    return { newX, newY }
end

-- Draws an equilateral triangle
-- Parameters
--    o           : imgui overlay drawlist [imgui.GetOverlayDrawList()]
--    centerPoint : center point of the triangle [Table]
--    size        : radius from triangle center to tip [Int/Float]
--    angle       : rotation angle of the triangle [Int/Float]
--    color       : color of the triangle represented as a uint [Int]
function drawEquilateralTriangle(o, centerPoint, size, angle, color)
    local angle2 = 2 * math.pi / 3 + angle
    local angle3 = 4 * math.pi / 3 + angle
    local x1 = centerPoint.x + size * math.cos(angle)
    local y1 = centerPoint.y + size * math.sin(angle)
    local x2 = centerPoint.x + size * math.cos(angle2)
    local y2 = centerPoint.y + size * math.sin(angle2)
    local x3 = centerPoint.x + size * math.cos(angle3)
    local y3 = centerPoint.y + size * math.sin(angle3)
    local p1 = { x1, y1 }
    local p2 = { x2, y2 }
    local p3 = { x3, y3 }
    o.AddTriangleFilled(p1, p2, p3, color)
end

-- Draws a single glare
-- Parameters
--    o          : [imgui overlay drawlist]
--    coords     : (x, y) coordinates of the glare [Int/Float]
--    size       : size of the glare [Int/Float]
--    glareColor : uint color of the glare [Int]
--    auraColor  : uint color of the aura of the glare [Int]
function drawGlare(o, coords, size, glareColor, auraColor)
    local outerRadius = size
    local innerRadius = outerRadius / 7
    local innerPoints = {}
    local outerPoints = {}
    for i = 1, 4 do
        local angle = math.pi * ((2 * i + 1) / 4)
        local innerX = innerRadius * math.cos(angle)
        local innerY = innerRadius * math.sin(angle)
        local outerX = outerRadius * innerX
        local outerY = outerRadius * innerY
        innerPoints[i] = { innerX + coords[1], innerY + coords[2] }
        outerPoints[i] = { outerX + coords[1], outerY + coords[2] }
    end
    o.AddQuadFilled(innerPoints[1], outerPoints[2], innerPoints[3], outerPoints[4], glareColor)
    o.AddQuadFilled(outerPoints[1], innerPoints[2], outerPoints[3], innerPoints[4], glareColor)
    local circlePoints = 20
    local circleSize1 = size / 1.2
    local circleSize2 = size / 3
    o.AddCircleFilled(coords, circleSize1, auraColor, circlePoints)
    o.AddCircleFilled(coords, circleSize2, auraColor, circlePoints)
end

-- Draws a horizontal pill shape
-- Parameters
--    o              : imgui overlay drawlist [imgui.GetOverlayDrawList()]
--    point1         : (x, y) coordiates of the center of the pill's first circle [Table]
--    point2         : (x, y) coordiates of the center of the pill's second circle [Table]
--    radius         : radius of the circle of the pill [Int/Float]
--    color          : color of the pill represented as a uint [Int]
--    circleSegments : number of segments to draw for the circles in the pill [Int]
function drawHorizontalPillShape(o, point1, point2, radius, color, circleSegments)
    o.AddCircleFilled(point1, radius, color, circleSegments)
    o.AddCircleFilled(point2, radius, color, circleSegments)
    local rectangleStartCoords = relativePoint(point1, 0, radius)
    local rectangleEndCoords = relativePoint(point2, 0, -radius)
    o.AddRectFilled(rectangleStartCoords, rectangleEndCoords, color)
end

-- Returns a 2D (x, y) point [Table]
-- Parameters
--    x : x coordinate of the point [Int/Float]
--    y : y coordinate of the point [Int/Float]
function generate2DPoint(x, y) return { x = x, y = y } end

-- Generates and returns a particle [Table]
-- Parameters
--    x            : starting x coordiate of particle [Int/Float]
--    y            : starting y coordiate of particle [Int/Float]
--    xRange       : range of movement for the x coordiate of the particle [Int/Float]
--    yRange       : range of movement for the y coordiate of the particle [Int/Float]
--    endTime      : time to stop showing particle [Int/Float]
--    showParticle : whether or not to render/draw the particle [Boolean]
function generateParticle(x, y, xRange, yRange, endTime, showParticle)
    local particle = {
        x = x,
        y = y,
        xRange = xRange,
        yRange = yRange,
        endTime = endTime,
        showParticle = showParticle
    }
    return particle
end

-- Returns the current (x, y) coordinates of the mouse [Table]
function getCurrentMousePosition()
    local mousePosition = imgui.GetMousePos()
    return { x = mousePosition[1], y = mousePosition[2] }
end

-- Returns a point relative to a given point [Table]
-- Parameters
--    point   : (x, y) coordinates [Table]
--    xChange : change in x coordinate [Int]
--    yChange : change in y coordinate [Int]
function relativePoint(point, xChange, yChange)
    return { point[1] + xChange, point[2] + yChange }
end

-- Converts an RGBA color value into uint (unsigned integer) and returns the converted value [Int]
-- Parameters
--    r : red value [Int]
--    g : green value [Int]
--    b : blue value [Int]
--    a : alpha value [Int]
function rgbaToUint(r, g, b, a) return a * 16 ^ 6 + b * 16 ^ 4 + g * 16 ^ 2 + r end

------------------------------------------------------------------------------- Notes, SVs, Offsets

-- Adds the final SV to the "svsToAdd" list if there isn't an SV at the end offset already
-- Parameters
--    svsToAdd     : list of SVs to add [Table]
--    endOffset    : millisecond time of the final SV [Int]
--    svMultiplier : the final SV's multiplier [Int/Float]
function addFinalSV(svsToAdd, endOffset, svMultiplier, force)
    local sv = map.GetScrollVelocityAt(endOffset)
    local svExistsAtEndOffset = sv and (sv.StartTime == endOffset)
    if svExistsAtEndOffset and not force then return end

    addSVToList(svsToAdd, endOffset, svMultiplier, true)
end

function addFinalSSF(ssfsToAdd, endOffset, ssfMultiplier)
    local ssf = map.GetScrollSpeedFactorAt(endOffset)
    local ssfExistsAtEndOffset = ssf and (ssf.StartTime == endOffset)
    if ssfExistsAtEndOffset then return end

    addSSFToList(ssfsToAdd, endOffset, ssfMultiplier, true)
end

function addInitialSSF(ssfsToAdd, startOffset)
    local ssf = map.GetScrollSpeedFactorAt(startOffset)
    if (ssf == nil) then return end
    local ssfExistsAtStartOffset = ssf and (ssf.StartTime == startOffset)
    if ssfExistsAtStartOffset then return end

    addSSFToList(ssfsToAdd, startOffset, ssf.Multiplier, true)
end

-- Adds an SV with the start offset into the list if there isn't an SV there already
-- Parameters
--    svs         : list of SVs [Table]
--    startOffset : start offset in milliseconds for the list of SVs [Int]
function addStartSVIfMissing(svs, startOffset)
    if #svs ~= 0 and svs[1].StartTime == startOffset then return end
    addSVToList(svs, startOffset, getSVMultiplierAt(startOffset), false)
end

-- Creates and adds a new SV to an existing list of SVs
-- Parameters
--    svList     : list of SVs [Table]
--    offset     : offset in milliseconds for the new SV [Int/Float]
--    multiplier : multiplier for the new SV [Int/Float]
--    endOfList  : whether or not to add the SV to the end of the list (else, the front) [Boolean]
function addSVToList(svList, offset, multiplier, endOfList)
    local newSV = utils.CreateScrollVelocity(offset, multiplier)
    if endOfList then
        table.insert(svList, newSV)
        return
    end
    table.insert(svList, 1, newSV)
end

function addSSFToList(ssfList, offset, multiplier, endOfList)
    local newSSF = utils.CreateScrollSpeedFactor(offset, multiplier)
    if endOfList then
        table.insert(ssfList, newSSF)
        return
    end
    table.insert(ssfList, 1, newSSF)
end

-- Calculates the total msx displacements over time at offsets
-- Returns a table of total displacements [Table]
-- Parameters
--    noteOffsets : list of offsets (milliseconds) to calculate displacement at [Table]
--    noteSpacing : SV multiplier determining spacing [Int/Float]
function calculateDisplacementsFromNotes(noteOffsets, noteSpacing)
    local totalDisplacement = 0
    local displacements = { 0 }
    for i = 1, #noteOffsets - 1 do
        local noteOffset1 = noteOffsets[i]
        local noteOffset2 = noteOffsets[i + 1]
        local time = (noteOffsets[i + 1] - noteOffsets[i])
        local distance = time * noteSpacing
        totalDisplacement = totalDisplacement + distance
        table.insert(displacements, totalDisplacement)
    end
    return displacements
end

-- Calculates the total msx displacement over time for a given set of SVs
-- Returns a table of total displacements [Table]
-- Parameters
--    svs         : list of ordered svs to calculate displacement with [Table]
--    startOffset : starting time for displacement calculation [Int/Float]
--    endOffset   : ending time for displacement calculation [Int/Float]
function calculateDisplacementFromSVs(svs, startOffset, endOffset)
    return calculateDisplacementsFromSVs(svs, { startOffset, endOffset })[2]
end

-- Calculates the total msx displacements over time at offsets for a given set of SVs
-- Returns a table of total displacements [Table]
-- Parameters
--    svs     : list of ordered svs to calculate displacement with [Table]
--    offsets : list of offsets (milliseconds) to calculate displacement at [Table]
function calculateDisplacementsFromSVs(svs, offsets)
    local totalDisplacement = 0
    local displacements = {}
    local lastOffset = offsets[#offsets]
    addSVToList(svs, lastOffset, 0, true)
    local j = 1
    for i = 1, (#svs - 1) do
        local lastSV = svs[i]
        local nextSV = svs[i + 1]
        local svTimeDifference = nextSV.StartTime - lastSV.StartTime
        while nextSV.StartTime > offsets[j] do
            local svToOffsetTime = offsets[j] - lastSV.StartTime
            local displacement = totalDisplacement
            if svToOffsetTime > 0 then
                displacement = displacement + lastSV.Multiplier * svToOffsetTime
            end
            table.insert(displacements, displacement)
            j = j + 1
        end
        if svTimeDifference > 0 then
            local thisDisplacement = svTimeDifference * lastSV.Multiplier
            totalDisplacement = totalDisplacement + thisDisplacement
        end
    end
    table.remove(svs)
    table.insert(displacements, totalDisplacement)
    return displacements
end

-- Calculates still displacements
-- Returns the still displacements [Table]
-- Parameters
--    stillType        : type of still [String]
--    stillDistance    : distance of the still according to the still type [Int/Float]
--    svDisplacements  : list of displacements of notes based on svs [Table]
--    nsvDisplacements : list of displacements of notes based on notes only, no sv [Table]
function calculateStillDisplacements(stillType, stillDistance, svDisplacements, nsvDisplacements)
    local finalDisplacements = {}
    for i = 1, #svDisplacements do
        local difference = nsvDisplacements[i] - svDisplacements[i]
        table.insert(finalDisplacements, difference)
    end
    local extraDisplacement = stillDistance
    if stillType == "End" or stillType == "Otua" then
        extraDisplacement = stillDistance - finalDisplacements[#finalDisplacements]
    end
    if stillType ~= "No" then
        for i = 1, #finalDisplacements do
            finalDisplacements[i] = finalDisplacements[i] + extraDisplacement
        end
    end
    return finalDisplacements
end

-- Checks to see if enough notes are selected (ONLY works for minimumNotes = 0, 1, or 2)
-- Returns whether or not there are enough notes [Boolean]
-- Parameters
--    minimumNotes : minimum number of notes needed to be selected [Int]
function checkEnoughSelectedNotes(minimumNotes)
    if minimumNotes == 0 then return true end
    local selectedNotes = state.SelectedHitObjects
    local numSelectedNotes = #selectedNotes
    if numSelectedNotes == 0 then return false end
    if minimumNotes == 1 then return true end
    if numSelectedNotes > map.GetKeyCount() then return true end
    return selectedNotes[1].StartTime ~= selectedNotes[numSelectedNotes].StartTime
end

-- Gets removable SVs that are in the map at the exact time where an SV will get added
-- Parameters
--    svsToRemove   : list of SVs to remove [Table]
--    svTimeIsAdded : list of SVs times added [Table]
--    startOffset   : starting offset to remove after [Int]
--    endOffset     : end offset to remove before [Int]
function getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset, retroactiveSVRemovalTable)
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime <= endOffset + 1
        if svIsInRange then
            local svIsRemovable = svTimeIsAdded[sv.StartTime]
            if svIsRemovable then table.insert(svsToRemove, sv) end
        end
    end
    if (retroactiveSVRemovalTable) then
        for idx, sv in pairs(retroactiveSVRemovalTable) do
            local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime <= endOffset + 1
            if svIsInRange then
                local svIsRemovable = svTimeIsAdded[sv.StartTime]
                if svIsRemovable then table.remove(retroactiveSVRemovalTable, idx) end
            end
        end
    end
end

-- Returns the SV multiplier at a specified offset in the map [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getHypotheticalSVMultiplierAt(svs, offset)
    if (#svs == 1) then return svs[1].Multiplier end
    local index = #svs
    while (index >= 1) do
        if (svs[index].StartTime > offset) then
            index = index - 1
        else
            return svs[index].Multiplier
        end
    end
    return 1
end

function getHypotheticalSVTimeAt(svs, offset)
    if (#svs == 1) then return svs[1].StartTime end
    local index = #svs
    while (index >= 1) do
        if (svs[index].StartTime > offset) then
            index = index - 1
        else
            return svs[index].StartTime
        end
    end
    return 1
end

-- Returns the SV multiplier at a specified offset in the map [Int/Float]
-- Parameters
--    offset : millisecond time [Int/Float]
function getSVMultiplierAt(offset)
    local sv = map.GetScrollVelocityAt(offset)
    if sv then return sv.Multiplier end
    return 1
end

function getNotesBetweenOffsets(startOffset, endOffset)
    local notesBetweenOffsets = {}
    for _, note in pairs(map.HitObjects) do
        local noteIsInRange = note.StartTime >= startOffset and note.StartTime <= endOffset
        if noteIsInRange then table.insert(notesBetweenOffsets, note) end
    end
    return table.sort(notesBetweenOffsets, sortAscendingStartTime)
end

function getLinesBetweenOffsets(startOffset, endOffset)
    local linesBetweenoffsets = {}
    for _, line in pairs(map.TimingPoints) do
        local lineIsInRange = line.StartTime >= startOffset and line.StartTime < endOffset
        if lineIsInRange then table.insert(linesBetweenoffsets, line) end
    end
    return table.sort(linesBetweenoffsets, sortAscendingStartTime)
end

function getSVsBetweenOffsets(startOffset, endOffset)
    local svsBetweenOffsets = {}
    for _, sv in pairs(map.ScrollVelocities) do
        local svIsInRange = sv.StartTime >= startOffset and sv.StartTime < endOffset
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return table.sort(svsBetweenOffsets, sortAscendingStartTime)
end

function getBookmarksBetweenOffsets(startOffset, endOffset)
    local bookmarksBetweenOffsets = {}
    for _, bm in pairs(map.Bookmarks) do
        local bmIsInRange = bm.StartTime >= startOffset and bm.StartTime < endOffset
        if bmIsInRange then table.insert(bookmarksBetweenOffsets, bm) end
    end
    return table.sort(bookmarksBetweenOffsets, sortAscendingStartTime)
end

function getHypotheticalSVsBetweenOffsets(svs, startOffset, endOffset)
    local svsBetweenOffsets = {}
    for _, sv in pairs(svs) do
        local svIsInRange = sv.StartTime >= startOffset - 1 and sv.StartTime < endOffset + 1
        if svIsInRange then table.insert(svsBetweenOffsets, sv) end
    end
    return table.sort(svsBetweenOffsets, sortAscendingStartTime)
end

function getSSFsBetweenOffsets(startOffset, endOffset)
    local ssfsBetweenOffsets = {}
    local ssfs = map.ScrollSpeedFactors
    if (ssfs == nil) then
        ssfs = {}
    else
        for _, ssf in pairs(map.ScrollSpeedFactors) do
            local ssfIsInRange = ssf.StartTime >= startOffset and ssf.StartTime < endOffset
            if ssfIsInRange then table.insert(ssfsBetweenOffsets, ssf) end
        end
    end
    return table.sort(ssfsBetweenOffsets, sortAscendingStartTime)
end

-- Returns a usable displacement multiplier for a given offset [Int/Float]
--[[
-- Current implementation:
-- 64 until 2^18 = 262144 ms ~4.3 min, then —> 32
-- 32 until 2^19 = 524288 ms ~8.7 min, then —> 16
-- 16 until 2^20 = 1048576 ms ~17.4 min, then —> 8
-- 8 until 2^21 = 2097152 ms ~34.9 min, then —> 4
-- 4 until 2^22 = 4194304 ms ~69.9 min, then —> 2
-- 2 until 2^23 = 8388608 ms ~139.8 min, then —> 1
--]]
-- Parameters
--    offset: time in milliseconds [Int]
function getUsableDisplacementMultiplier(offset)
    local exponent = 23 - math.floor(math.log(math.abs(offset) + 1) / math.log(2))
    if exponent > 6 then exponent = 6 end
    return 2 ^ exponent
end

-- Adds a new displacing SV to a list of SVs to place and adds that SV time to a hash list
-- Parameters
--    svsToAdd               : list of displacing SVs to add to [Table]
--    svTimeIsAdded          : hash list indicating whether an SV time exists already [Table]
--    svTime                 : time to add the displacing SV at [Int/Float]
--    displacement           : amount that the SV will displace [Int/Float]
--    displacementMultiplier : displacement multiplier value [Int/Float]
function prepareDisplacingSV(svsToAdd, svTimeIsAdded, svTime, displacement, displacementMultiplier, hypothetical, svs)
    svTimeIsAdded[svTime] = true
    local currentSVMultiplier = getSVMultiplierAt(svTime)
    if (hypothetical == true) then
        currentSVMultiplier = getHypotheticalSVMultiplierAt(svs, svTime)
        -- local quantumSVMultiplier = map.GetScrollVelocityAt(svTime) or {StartTime = -1}
        -- if (quantumSVMultiplier.StartTime > getHypotheticalSVTimeAt(svs, svTime)) then
        --     currentSVMultiplier = quantumSVMultiplier.Multiplier
        -- end
    end
    local newSVMultiplier = displacementMultiplier * displacement + currentSVMultiplier
    addSVToList(svsToAdd, svTime, newSVMultiplier, true)
end

-- Adds new displacing SVs to a list of SVs to place and adds removable SV times to another list
-- Parameters
--    offset             : general offset in milliseconds to displace SVs at [Int]
--    svsToAdd           : list of displacing SVs to add to [Table]
--    svTimeIsAdded      : hash list indicating whether an SV time exists already [Table]
--    beforeDisplacement : amount to displace before (nil value if not) [Int/Float]
--    atDisplacement     : amount to displace at (nil value if not) [Int/Float]
--    afterDisplacement  : amount to displace after (nil value if not) [Int/Float]
function prepareDisplacingSVs(offset, svsToAdd, svTimeIsAdded, beforeDisplacement, atDisplacement,
                              afterDisplacement, hypothetical, baseSVs)
    local displacementMultiplier = getUsableDisplacementMultiplier(offset)
    local duration = 1 / displacementMultiplier
    if beforeDisplacement then
        local timeBefore = offset - duration
        prepareDisplacingSV(svsToAdd, svTimeIsAdded, timeBefore, beforeDisplacement,
            displacementMultiplier, hypothetical, baseSVs)
    end
    if atDisplacement then
        local timeAt = offset
        prepareDisplacingSV(svsToAdd, svTimeIsAdded, timeAt, atDisplacement,
            displacementMultiplier, hypothetical, baseSVs)
    end
    if afterDisplacement then
        local timeAfter = offset + duration
        prepareDisplacingSV(svsToAdd, svTimeIsAdded, timeAfter, afterDisplacement,
            displacementMultiplier, hypothetical, baseSVs)
    end
end

-- Removes and adds SVs
-- Parameters
--    svsToRemove : list of SVs to remove [Table]
--    svsToAdd    : list of SVs to add [Table]
function removeAndAddSVs(svsToRemove, svsToAdd)
    local tolerance = 0.035
    if #svsToAdd == 0 then return end
    for idx, sv in pairs(svsToRemove) do
        local baseSV = map.GetScrollVelocityAt(sv.StartTime)
        if (math.abs(baseSV.StartTime - sv.StartTime) > tolerance) then
            table.remove(svsToRemove, idx)
        end
    end
    local editorActions = {
        utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
        utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd)
    }
    actions.PerformBatch(editorActions)
end

function removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
    if #ssfsToAdd == 0 then return end
    local editorActions = {
        utils.CreateEditorAction(action_type.RemoveScrollSpeedFactorBatch, ssfsToRemove),
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfsToAdd)
    }
    actions.PerformBatch(editorActions)
end

-- Finds and returns a list of all unique offsets of notes between a start and an end time [Table]
-- Parameters
--    startOffset : start time in milliseconds [Int/Float]
--    endOffset   : end time in milliseconds [Int/Float]
function uniqueNoteOffsetsBetween(startOffset, endOffset)
    local noteOffsetsBetween = {}
    for _, hitObject in pairs(map.HitObjects) do
        if hitObject.StartTime >= startOffset and hitObject.StartTime <= endOffset and ((state.SelectedScrollGroupId == hitObject.TimingGroup) or not BETA_IGNORE_NOTES_OUTSIDE_TG) then
            table.insert(noteOffsetsBetween, hitObject.StartTime)
            if (hitObject.EndTime ~= 0 and hitObject.EndTime <= endOffset) then
                table.insert(noteOffsetsBetween,
                    hitObject.EndTime)
            end
        end
    end
    noteOffsetsBetween = dedupe(noteOffsetsBetween)
    noteOffsetsBetween = table.sort(noteOffsetsBetween, sortAscending)
    return noteOffsetsBetween
end

-- Finds and returns a list of all unique offsets of notes between selected notes [Table]
function uniqueNoteOffsetsBetweenSelected()
    local selectedNoteOffsets = uniqueSelectedNoteOffsets()
    local startOffset = selectedNoteOffsets[1]
    local endOffset = selectedNoteOffsets[#selectedNoteOffsets]
    local offsets = uniqueNoteOffsetsBetween(startOffset, endOffset)
    if (#offsets < 2) then
        print("E!",
            "Warning: There are not enough notes in the current selection (within this timing group) to perform the action.")
    end
    return offsets
end

-- Finds unique offsets of all notes currently selected in the editor
-- Returns a list of unique offsets (in increasing order) of selected notes [Table]
function uniqueSelectedNoteOffsets()
    local offsets = {}
    for i, hitObject in pairs(state.SelectedHitObjects) do
        offsets[i] = hitObject.StartTime
    end
    offsets = dedupe(offsets)
    offsets = table.sort(offsets, sortAscending)
    return offsets
end

---------------------------------------------------------------------------------------------- Math

-- Returns the average value from a list of values [Int/Float]
-- Parameters
--    values           : list of numerical values [Table]
--    includeLastValue : whether or not to include the last value for the average [Boolean]
function calculateAverage(values, includeLastValue)
    if #values == 0 then return nil end
    local sum = 0
    for _, value in pairs(values) do
        sum = sum + value
    end
    if not includeLastValue then
        sum = sum - values[#values]
        return sum / (#values - 1)
    end
    return sum / #values
end

-- Restricts a number to be within a closed interval
-- Returns the result of the restriction [Int/Float]
-- Parameters
--    number     : number to keep within the interval [Int/Float]
--    lowerBound : lower bound of the interval [Int/Float]
--    upperBound : upper bound of the interval [Int/Float]
function clampToInterval(number, lowerBound, upperBound)
    if number < lowerBound then return lowerBound end
    if number > upperBound then return upperBound end
    return number
end

-- Forces a number to be a multiple of a quarter (0.25)
-- Returns the result of the force [Int/Float]
-- Parameters
--    number : number to force to be a multiple of one quarter [Int/Float]
function forceQuarter(number)
    return math.floor(number * 4 + 0.5) / 4
end

-- Returns the sign of a number: +1 if the number is non-negative, -1 if negative [Int]
-- Parameters
--    number : number to get the sign of
function getSignOfNumber(number)
    if number >= 0 then return 1 end
    return -1
end

-- Normalizes a set of values to achieve a target average
-- Parameters
--    values                    : set of numbers [Table]
--    targetAverage             : average value that is aimed for [Int/Float]
--    includeLastValueInAverage : whether or not to include the last value in the average [Boolean]
function normalizeValues(values, targetAverage, includeLastValueInAverage)
    local avgValue = calculateAverage(values, includeLastValueInAverage)
    if avgValue == 0 then return end
    for i = 1, #values do
        values[i] = (values[i] * targetAverage) / avgValue
    end
end

-- Rounds a number to a given amount of decimal places
-- Returns the rounded number [Int/Float]
-- Parameters
--    number        : number to round [Int/Float]
--    decimalPlaces : number of decimal places to round the number to [Int]
function round(number, decimalPlaces)
    local multiplier = 10 ^ decimalPlaces
    return math.floor(multiplier * number + 0.5) / multiplier
end

-- Evaluates a simplified one-dimensional cubic bezier expression with points (0, p2, p3, 1)
-- Returns the result of the bezier evaluation [Int/Float]
-- Parameters
--    p2 : second coordinate of the cubic bezier [Int/Float]
--    p3 : third coordinate of the cubic bezier [Int/Float]
--    t  : time to evaluate the cubic bezier at [Int/Float]
function simplifiedCubicBezier(p2, p3, t)
    return 3 * t * (1 - t) ^ 2 * p2 + 3 * t ^ 2 * (1 - t) * p3 + t ^ 3
end

-- Evaluates a simplified one-dimensional quadratic bezier expression with points (0, p2, 1)
-- Returns the result of the bezier evaluation [Int/Float]
-- Parameters
--    p2 : second coordinate of the quadratic bezier [Int/Float]
--    t  : time to evaluate the quadratic bezier at [Int/Float]
function simplifiedQuadraticBezier(p2, t)
    return 2 * t * (1 - t) * p2 + t ^ 2
end

-- Evaluates a simplified one-dimensional hermite related (?) spline for SV purposes
-- Returns the result of the hermite evaluation [Int/Float]
-- Parameters
--    m1 : slope at first point [Int/Float]
--    m2 : slope at second point [Int/Float]
--    y2 : y coordinate of second point [Int/Float]
--    t  : time to evaluate the hermite spline at [Int/Float]
function simplifiedHermite(m1, m2, y2, t)
    local a = m1 + m2 - 2 * y2
    local b = 3 * y2 - 2 * m1 - m2
    local c = m1
    return a * t ^ 3 + b * t ^ 2 + c * t
end

-- Sorting function for numbers that returns whether a < b [Boolean]
-- Parameters
--    a : first number [Int/Float]
--    b : second number [Int/Float]
function sortAscending(a, b) return a < b end

-- Sorting function for SVs 'a' and 'b' that returns whether a.StartTime < b.StartTime [Boolean]
-- Parameters
--    a : first SV
--    b : second SV
function sortAscendingStartTime(a, b) return a.StartTime < b.StartTime end

-- Sorting function for objects 'a' and 'b' that returns whether a.time < b.time [Boolean]
-- Parameters
--    a : first object
--    b : second object
function sortAscendingTime(a, b) return a.time < b.time end

-- Restricts a number to be within a closed interval that wraps around
-- Returns the result of the restriction [Int/Float]
-- Parameters
--    number     : number to keep within the interval [Int/Float]
--    lowerBound : lower bound of the interval [Int/Float]
--    upperBound : upper bound of the interval [Int/Float]
function wrapToInterval(number, lowerBound, upperBound)
    if number < lowerBound then return upperBound end
    if number > upperBound then return lowerBound end
    return number
end

-------------------------------------------------------------------------------------- Abstractions

-- Executes a function if a key is pressed
-- Parameters
--    key        : key to be pressed [keys.~, from Quaver's MonoGame.Framework.Input.Keys enum]
--    func       : function to execute once key is pressed [Function]
--    globalVars : list of variables used globally across all menus [Table]
--    menuVars   : list of variables used for the current menu [Table]
function executeFunctionIfKeyPressed(key, func, globalVars, menuVars)
    if not utils.IsKeyPressed(key) then return end
    if globalVars and menuVars then
        func(globalVars, menuVars)
        return
    end
    if globalVars then
        func(globalVars)
        return
    end
    if menuVars then
        func(menuVars)
        return
    end
    func()
end

------------------------------------------------------------------------------------- Acting on SVs

function ssf(startTime, multiplier)
    return utils.CreateScrollSpeedFactor(startTime, multiplier)
end

function ssfVibrato(lowerStart, lowerEnd, higherStart, higherEnd, startTime, endTime, resolution, curvature)
    local exponent = 2 ^ (curvature / 100)
    local delta = endTime - startTime / 2 * resolution
    local time = startTime
    local ssfs = { ssf(startTime - getUsableDisplacementMultiplier(startTime), map.GetScrollSpeedFactorAt(time)) }
    while time < endTime do
        local x = ((time - startTime) - (endTime - startTime)) ^ exponent
        local y = ((time + delta - startTime) - (endTime - startTime)) ^ exponent
        table.insert(ssfs, ssf(time - getUsableDisplacementMultiplier(time), higherStart + x * (higherEnd - higherStart)))
        table.insert(ssfs, ssf(time, lowerStart + x * (lowerEnd - lowerStart)))
        table.insert(ssfs, ssf(time - getUsableDisplacementMultiplier(time), lowerStart + y * (lowerEnd - lowerStart)))
        table.insert(ssfs, ssf(time, higherStart + y * (higherEnd - higherStart)))
        time = time + 2 * delta
    end

    utils.PlaceScrollSpeedFactorBatch(ssfs)
end
