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
    local sv = getSVMultiplierAt(endOffset)
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

-- Removes and adds SVs
-- Parameters
--    svsToRemove : list of SVs to remove [Table]
--    svsToAdd    : list of SVs to add [Table]
function removeAndAddSVs(svsToRemove, svsToAdd)
    local tolerance = 0.035
    if #svsToAdd == 0 then return end
    for idx, sv in pairs(svsToRemove) do
        local baseSV = getSVMultiplierAt(sv.StartTime)
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
