function chooseAddComboMultipliers(settingVars)
    local oldValues = vector.New(settingVars.comboMultiplier1, settingVars.comboMultiplier2)
    local _, newValues = imgui.InputFloat2("ax + by", oldValues, "%.2f")
    HelpMarker("a = multiplier for SV Type 1, b = multiplier for SV Type 2")
    settingVars.comboMultiplier1 = newValues.x
    settingVars.comboMultiplier2 = newValues.y
    return oldValues ~= newValues
end

function chooseArcPercent(settingVars)
    local oldPercent = settingVars.arcPercent
    _, settingVars.arcPercent = imgui.SliderInt("Arc Percent", math.clamp(oldPercent, 1, 99), 1, 99, oldPercent .. "%%")
    return oldPercent ~= settingVars.arcPercent
end

function chooseAverageSV(menuVars)
    local outputValue, settingsChanged = NegatableComputableInputFloat("Average SV", menuVars.avgSV, 2, "x")
    menuVars.avgSV = outputValue
    return settingsChanged
end

function chooseBezierPoints(settingVars)
    local oldFirstPoint = settingVars.p1
    local oldSecondPoint = settingVars.p2
    local _, newFirstPoint = imgui.SliderFloat2("(x1, y1)", oldFirstPoint, 0, 1, "%.2f")
    HelpMarker("Coordinates of the first point of the cubic bezier")
    local _, newSecondPoint = imgui.SliderFloat2("(x2, y2)", oldSecondPoint, 0, 1, "%.2f")
    HelpMarker("Coordinates of the second point of the cubic bezier")
    settingVars.p1 = newFirstPoint
    settingVars.p2 = newSecondPoint

    return settingVars.p1 ~= oldFirstPoint or settingVars.p2 ~= oldSecondPoint
end

function chooseChinchillaIntensity(settingVars)
    local oldIntensity = settingVars.chinchillaIntensity
    local _, newIntensity = imgui.SliderFloat("Intensity##chinchilla", oldIntensity, 0, 10, "%.3f")
    HelpMarker("Ctrl + click slider to input a specific number")
    settingVars.chinchillaIntensity = math.clamp(newIntensity, 0, 727)
    return oldIntensity ~= settingVars.chinchillaIntensity
end

function chooseChinchillaType(settingVars)
    local oldIndex = settingVars.chinchillaTypeIndex
    settingVars.chinchillaTypeIndex = Combo("Chinchilla Type", CHINCHILLA_TYPES, oldIndex)
    return oldIndex ~= settingVars.chinchillaTypeIndex
end

function chooseColorTheme()
    local oldColorThemeIndex = globalVars.colorThemeIndex
    globalVars.colorThemeIndex = Combo("Color Theme", COLOR_THEMES, globalVars.colorThemeIndex, COLOR_THEME_COLORS)

    if (oldColorThemeIndex ~= globalVars.colorThemeIndex) then
        write(globalVars)
    end

    local currentTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local isRGBColorTheme = currentTheme:find("RGB") or currentTheme:find("BGR")

    if not isRGBColorTheme then return end

    chooseRGBPeriod()
end

function chooseComboSVOption(settingVars, maxComboPhase)
    local oldIndex = settingVars.comboTypeIndex
    settingVars.comboTypeIndex = Combo("Combo Type", COMBO_SV_TYPE, settingVars.comboTypeIndex)
    local currentComboType = COMBO_SV_TYPE[settingVars.comboTypeIndex]
    local addTypeChanged = false
    if currentComboType ~= "SV Type 1 Only" and currentComboType ~= "SV Type 2 Only" then
        addTypeChanged = BasicInputInt(settingVars, "comboPhase", "Combo Phase", { 0, maxComboPhase }) or addTypeChanged
    end
    if currentComboType == "Add" then
        addTypeChanged = chooseAddComboMultipliers(settingVars) or addTypeChanged
    end
    return (oldIndex ~= settingVars.comboTypeIndex) or addTypeChanged
end

function chooseConstantShift(settingVars, defaultShift)
    local oldShift = settingVars.verticalShift

    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local resetButtonPressed = imgui.Button("R", TERTIARY_BUTTON_SIZE)
    if (resetButtonPressed or exclusiveKeyPressed(globalVars.hotkeyList[5])) then
        settingVars.verticalShift = defaultShift
    end
    ToolTip("Reset vertical shift to initial values")
    KeepSameLine()

    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)

    if negateButtonPressed and settingVars.verticalShift ~= 0 then
        settingVars.verticalShift = -settingVars.verticalShift
    end
    ToolTip("Negate vertical shift")

    KeepSameLine()
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))

    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local inputText = "Vertical Shift"
    _, settingVars.verticalShift = imgui.InputFloat(inputText, settingVars.verticalShift, 0, 0, "%.3fx")
    imgui.PopItemWidth()

    return oldShift ~= settingVars.verticalShift
end

function chooseMsxVerticalShift(settingVars, defaultShift)
    local oldShift = settingVars.verticalShift

    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local resetButtonPressed = imgui.Button("R", TERTIARY_BUTTON_SIZE)
    if (resetButtonPressed or exclusiveKeyPressed(globalVars.hotkeyList[5])) then
        settingVars.verticalShift = defaultShift or 0
    end
    ToolTip("Reset vertical shift to initial values")
    KeepSameLine()

    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)

    if negateButtonPressed and settingVars.verticalShift ~= 0 then
        settingVars.verticalShift = -settingVars.verticalShift
    end
    ToolTip("Negate vertical shift")

    KeepSameLine()
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))

    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local inputText = "Vertical Shift"
    _, settingVars.verticalShift = imgui.InputFloat(inputText, settingVars.verticalShift, 0, 0, "%.0f msx")
    imgui.PopItemWidth()

    return oldShift ~= settingVars.verticalShift
end

function chooseControlSecondSV(settingVars)
    local oldChoice = settingVars.controlLastSV
    local stutterControlsIndex = 1
    if oldChoice then stutterControlsIndex = 2 end
    local newStutterControlsIndex = Combo("Control SV", STUTTER_CONTROLS, stutterControlsIndex)
    settingVars.controlLastSV = newStutterControlsIndex == 2
    local choiceChanged = oldChoice ~= settingVars.controlLastSV
    if choiceChanged then settingVars.stutterDuration = 100 - settingVars.stutterDuration end
    return choiceChanged
end

function chooseCurrentFrame(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Previewing frame:")
    KeepSameLine()
    imgui.PushItemWidth(35)
    if imgui.ArrowButton("##leftFrame", imgui_dir.Left) then
        settingVars.currentFrame = settingVars.currentFrame - 1
    end
    KeepSameLine()
    _, settingVars.currentFrame = imgui.InputInt("##currentFrame", settingVars.currentFrame, 0, 0)
    KeepSameLine()
    if imgui.ArrowButton("##rightFrame", imgui_dir.Right) then
        settingVars.currentFrame = settingVars.currentFrame + 1
    end
    settingVars.currentFrame = math.wrap(settingVars.currentFrame, 1, settingVars.numFrames)
    imgui.PopItemWidth()
end

function chooseCursorTrail()
    local oldCursorTrailIndex = globalVars.cursorTrailIndex
    globalVars.cursorTrailIndex = Combo("Cursor Trail", CURSOR_TRAILS, oldCursorTrailIndex)
    if (oldCursorTrailIndex ~= globalVars.cursorTrailIndex) then
        write(globalVars)
    end
end

function chooseCursorTrailGhost()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    GlobalCheckbox("cursorTrailGhost", "No Ghost")
end

function chooseCursorTrailPoints()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local settingChanged = BasicInputInt(globalVars, "cursorTrailPoints", "Trail Points")
    if (settingChanged) then
        write(globalVars)
    end
end

function chooseCursorTrailShape()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local label = "Trail Shape"
    local oldTrailShapeIndex = globalVars.cursorTrailShapeIndex
    globalVars.cursorTrailShapeIndex = Combo(label, TRAIL_SHAPES, oldTrailShapeIndex)
    if (oldTrailShapeIndex ~= globalVars.cursorTrailShapeIndex) then
        write(globalVars)
    end
end

function chooseCursorShapeSize()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local settingChanged = BasicInputInt(globalVars, "cursorTrailSize", "Shape Size")
    if (settingChanged) then
        write(globalVars)
    end
end

function chooseCurveSharpness(settingVars)
    local oldSharpness = settingVars.curveSharpness
    if imgui.Button("Reset##curveSharpness", SECONDARY_BUTTON_SIZE) then
        settingVars.curveSharpness = 50
    end
    KeepSameLine()
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newSharpness = imgui.SliderInt("Curve Sharpness", settingVars.curveSharpness, 1, 100, "%d%%")
    imgui.PopItemWidth()
    settingVars.curveSharpness = newSharpness
    return oldSharpness ~= newSharpness
end

function chooseCustomMultipliers(settingVars)
    imgui.BeginChild("Custom Multipliers", vector.New(imgui.GetContentRegionAvailWidth(), 90), 1)
    for i = 1, #settingVars.svMultipliers do
        local selectableText = i .. " )   " .. settingVars.svMultipliers[i]
        if imgui.Selectable(selectableText, settingVars.selectedMultiplierIndex == i) then
            settingVars.selectedMultiplierIndex = i
        end
    end
    imgui.EndChild()
    local index = settingVars.selectedMultiplierIndex
    local oldMultiplier = settingVars.svMultipliers[index]
    local _, newMultiplier = imgui.InputFloat("SV Multiplier", oldMultiplier, 0, 0, "%.2fx")
    settingVars.svMultipliers[index] = newMultiplier
    return oldMultiplier ~= newMultiplier
end

function chooseDistance(menuVars)
    local oldDistance = menuVars.distance
    menuVars.distance = NegatableComputableInputFloat("Distance", menuVars.distance, 3, " msx")
    return oldDistance ~= menuVars.distance
end

function chooseVaryingDistance(settingVars)
    if (not settingVars.linearlyChange) then
        settingVars.distance = ComputableInputFloat("Distance", settingVars.distance, 3, " msx")
        return
    end
    return SwappableNegatableInputFloat2(settingVars, "distance1", "distance2", "Dist.", "msx", 2)
end

function chooseSelectTool()
    imgui.AlignTextToFramePadding()
    imgui.Text("Current Type:")
    KeepSameLine()
    globalVars.selectTypeIndex = Combo("##selecttool", SELECT_TOOLS, globalVars.selectTypeIndex)

    local selectTool = SELECT_TOOLS[globalVars.selectTypeIndex]
    if selectTool == "Alternating" then ToolTip("Skip over notes then select one, and repeat") end
    if selectTool == "By Snap" then ToolTip("Select all notes with a certain snap color") end
    if selectTool == "Bookmark" then ToolTip("Jump to a bookmark") end
    if selectTool == "Chord Size" then ToolTip("Select all notes with a certain chord size") end
    if selectTool == "Note Type" then ToolTip("Select rice/ln notes") end
end

function chooseEditTool()
    imgui.AlignTextToFramePadding()
    imgui.Text("  Current Tool:")
    KeepSameLine()
    globalVars.editToolIndex = Combo("##edittool", EDIT_SV_TOOLS, globalVars.editToolIndex)

    local svTool = EDIT_SV_TOOLS[globalVars.editToolIndex]
    if svTool == "Add Teleport" then ToolTip("Add a large teleport SV to move far away") end
    if svTool == "Align Timing Lines" then ToolTip("Create timing lines at notes to avoid desync") end
    if svTool == "Change Timing Group" then ToolTip("Moves SVs and SSFs to a designated timing group.") end
    if svTool == "Convert SV <-> SSF" then ToolTip("Convert multipliers between SV/SSF") end
    if svTool == "Copy & Paste" then ToolTip("Copy SVs and SSFs and paste them somewhere else") end
    if svTool == "Direct SV" then ToolTip("Directly update SVs within your selection") end
    if svTool == "Displace Note" then ToolTip("Move where notes are hit on the screen") end
    if svTool == "Displace View" then ToolTip("Temporarily displace the playfield view") end
    if svTool == "Dynamic Scale" then ToolTip("Dynamically scale SVs across notes") end
    if svTool == "Fix LN Ends" then ToolTip("Fix flipped LN ends") end
    if svTool == "Flicker" then ToolTip("Flash notes on and off the screen") end
    if svTool == "Layer Snaps" then ToolTip("Transfer snap colors into layers, to be loaded later") end
    if svTool == "Measure" then ToolTip("Get stats about SVs in a section") end
    if svTool == "Merge" then ToolTip("Combine SVs that overlap") end
    if svTool == "Reverse Scroll" then ToolTip("Reverse the scroll direction using SVs") end
    if svTool == "Scale (Multiply)" then ToolTip("Scale SV values by multiplying") end
    if svTool == "Scale (Displace)" then ToolTip("Scale SV values by adding teleport SVs") end
    if svTool == "Swap Notes" then ToolTip("Swap positions of notes using SVs") end
    if svTool == "Vertical Shift" then ToolTip("Adds a constant value to SVs in a range") end
end

function chooseEffectFPS()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local settingChanged = BasicInputInt(globalVars, "effectFPS", "Effect FPS", { 2, 1000 },
        "Set this to a multiple of UPS or FPS to make cursor effects smooth")
    if (settingChanged) then
        write(globalVars)
    end
end

function chooseFinalSV(settingVars, skipFinalSV)
    if skipFinalSV then return false end

    local oldIndex = settingVars.finalSVIndex
    local oldCustomSV = settingVars.customSV
    local finalSVType = FINAL_SV_TYPES[settingVars.finalSVIndex]
    if finalSVType ~= "Normal" then
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.35)
        _, settingVars.customSV = imgui.InputFloat("SV", settingVars.customSV, 0, 0, "%.2fx")
        KeepSameLine()
        imgui.PopItemWidth()
    else
        imgui.Indent(DEFAULT_WIDGET_WIDTH * 0.35 + 25)
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    settingVars.finalSVIndex = Combo("Final SV", FINAL_SV_TYPES, settingVars.finalSVIndex)
    HelpMarker("Final SV won't be placed if there's already an SV at the end time")
    if finalSVType == "Normal" then
        imgui.Unindent(DEFAULT_WIDGET_WIDTH * 0.35 + 25)
    end
    imgui.PopItemWidth()
    return (oldIndex ~= settingVars.finalSVIndex) or (oldCustomSV ~= settingVars.customSV)
end

function chooseFrameSpacing(settingVars)
    _, settingVars.frameDistance = imgui.InputFloat("Frame Spacing", settingVars.frameDistance,
        0, 0, "%.0f msx")
    settingVars.frameDistance = math.clamp(settingVars.frameDistance, 2000, 100000)
end

function chooseFrameTimeData(settingVars)
    if #settingVars.frameTimes == 0 then return end
    local frameTime = settingVars.frameTimes[settingVars.selectedTimeIndex]
    _, frameTime.frame = imgui.InputInt("Frame #", math.floor(frameTime.frame))
    frameTime.frame = math.clamp(frameTime.frame, 1, settingVars.numFrames)
    _, frameTime.position = imgui.InputInt("Note height", math.floor(frameTime.position))
end

function chooseIntensity(settingVars)
    local userStepSize = globalVars.stepSize or 5
    local totalSteps = math.ceil(100 / userStepSize)

    local oldIntensity = settingVars.intensity

    local stepIndex = math.floor((oldIntensity - 0.01) / userStepSize)

    local _, newStepIndex = imgui.SliderInt(
        "Intensity",
        stepIndex,
        0,
        totalSteps - 1,
        settingVars.intensity .. "%%"
    )

    local newIntensity = newStepIndex * userStepSize + 99 % userStepSize + 1
    settingVars.intensity = math.clamp(newIntensity, 1, 100)

    return oldIntensity ~= settingVars.intensity
end

function chooseInterlace(menuVars)
    local interlaceChanged = BasicCheckbox(menuVars, "interlace", "Interlace")
    if not menuVars.interlace then return interlaceChanged end
    KeepSameLine()
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    local oldRatio = menuVars.interlaceRatio
    _, menuVars.interlaceRatio = imgui.InputFloat("Ratio##interlace", menuVars.interlaceRatio,
        0, 0, "%.2f")
    imgui.PopItemWidth()
    return interlaceChanged or oldRatio ~= menuVars.interlaceRatio
end

-- Lets you choose the increments the Intensity slider goes by (e.g. Exponential Intensity Slider)
function chooseStepSize()
    imgui.PushItemWidth(40)
    local oldStepSize = globalVars.stepSize
    local _, tempStepSize = imgui.InputFloat("Exponential Intensity Step Size", oldStepSize, 0, 0, "%.0f%%")
    globalVars.stepSize = math.clamp(tempStepSize, 1, 100)
    imgui.PopItemWidth()
    if (oldStepSize ~= globalVars.stepSize) then
        write(globalVars)
    end
end

function chooseMainSV(settingVars)
    local label = "Main SV"
    if settingVars.linearlyChange then label = label .. " (start)" end
    _, settingVars.mainSV = imgui.InputFloat(label, settingVars.mainSV, 0, 0, "%.2fx")
    local HelpMarkerText = "This SV will last ~99.99%% of the stutter"
    if not settingVars.linearlyChange then
        HelpMarker(HelpMarkerText)
        return
    end

    _, settingVars.mainSV2 = imgui.InputFloat("Main SV (end)", settingVars.mainSV2, 0, 0, "%.2fx")
end

function chooseMenuStep(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Step # :")
    KeepSameLine()
    imgui.PushItemWidth(24)
    if imgui.ArrowButton("##leftMenuStep", imgui_dir.Left) then
        settingVars.menuStep = settingVars.menuStep - 1
    end
    KeepSameLine()
    _, settingVars.menuStep = imgui.InputInt("##currentMenuStep", settingVars.menuStep, 0, 0)
    KeepSameLine()
    if imgui.ArrowButton("##rightMenuStep", imgui_dir.Right) then
        settingVars.menuStep = settingVars.menuStep + 1
    end
    imgui.PopItemWidth()
    settingVars.menuStep = math.wrap(settingVars.menuStep, 1, 3)
end

function chooseNoNormalize(settingVars)
    AddPadding()
    return BasicCheckbox(settingVars, "dontNormalize", "Don't normalize to average SV")
end

function chooseNoteSkinType(settingVars)
    settingVars.noteSkinTypeIndex = Combo("Preview skin", NOTE_SKIN_TYPES,
        settingVars.noteSkinTypeIndex)
    HelpMarker("Note skin type for the preview of the frames")
end

function chooseFlickerPosition(menuVars)
    _, menuVars.flickerPosition = imgui.SliderFloat("Flicker Position", menuVars.flickerPosition, 0.05, 0.95,
        math.round(menuVars.flickerPosition * 100) .. "%%")
    menuVars.flickerPosition = math.round(menuVars.flickerPosition * 2, 1) * 0.5
end

function chooseNumPeriods(settingVars)
    local oldPeriods = settingVars.periods
    local _, newPeriods = imgui.InputFloat("Periods/Cycles", oldPeriods, 0.25, 0.25, "%.2f")
    newPeriods = math.quarter(newPeriods)
    newPeriods = math.clamp(newPeriods, 0.25, 69420)
    settingVars.periods = newPeriods
    return oldPeriods ~= newPeriods
end

function choosePeriodShift(settingVars)
    local oldShift = settingVars.periodsShift
    local _, newShift = imgui.InputFloat("Phase Shift", oldShift, 0.25, 0.25, "%.2f")
    newShift = math.quarter(newShift)
    newShift = math.wrap(newShift, -0.75, 1)
    settingVars.periodsShift = newShift
    return oldShift ~= newShift
end

function chooseCreateTool()
    imgui.AlignTextToFramePadding()
    imgui.Text("  Type:  ")
    KeepSameLine()
    globalVars.placeTypeIndex = Combo("##placeType", CREATE_TYPES, globalVars.placeTypeIndex)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Still" then ToolTip("Still keeps notes normal distance/spacing apart") end
end

function chooseCurrentScrollGroup()
    imgui.AlignTextToFramePadding()
    imgui.Text("  Timing Group: ")
    KeepSameLine()
    local groups = { "$Default", "$Global" }
    local cols = { map.TimingGroups["$Default"].ColorRgb or "86,253,110", map.TimingGroups["$Global"].ColorRgb or
    "255,255,255" }
    local hiddenGroups = {}
    for tgId, tg in pairs(map.TimingGroups) do
        if string.find(tgId, "%$") then goto cont end
        if (globalVars.hideAutomatic and string.find(tgId, "automate_")) then table.insert(hiddenGroups, tgId) end
        table.insert(groups, tgId)
        table.insert(cols, tg.ColorRgb or "255,255,255")
        ::cont::
    end
    local prevIndex = globalVars.scrollGroupIndex
    imgui.PushItemWidth(155)
    globalVars.scrollGroupIndex = Combo("##scrollGroup", groups, globalVars.scrollGroupIndex, cols, hiddenGroups)
    imgui.PopItemWidth()
    if (exclusiveKeyPressed(globalVars.hotkeyList[6])) then
        globalVars.scrollGroupIndex = math.clamp(globalVars.scrollGroupIndex - 1, 1, #groups)
    end
    if (exclusiveKeyPressed(globalVars.hotkeyList[7])) then
        globalVars.scrollGroupIndex = math.clamp(globalVars.scrollGroupIndex + 1, 1, #groups)
    end
    AddSeparator()
    if (prevIndex ~= globalVars.scrollGroupIndex) then
        state.SelectedScrollGroupId = groups[globalVars.scrollGroupIndex]
    end
    if (state.SelectedScrollGroupId ~= groups[globalVars.scrollGroupIndex]) then
        globalVars.scrollGroupIndex = table.indexOf(groups, state.SelectedScrollGroupId)
    end
end

function chooseRandomScale(settingVars)
    local oldScale = settingVars.randomScale
    local _, newScale = imgui.InputFloat("Random Scale", oldScale, 0, 0, "%.2fx")
    settingVars.randomScale = newScale
    return oldScale ~= newScale
end

function chooseRandomType(settingVars)
    local oldIndex = settingVars.randomTypeIndex
    settingVars.randomTypeIndex = Combo("Random Type", RANDOM_TYPES, settingVars.randomTypeIndex)
    return oldIndex ~= settingVars.randomTypeIndex
end

function chooseRGBPeriod()
    local oldRGBPeriod = globalVars.rgbPeriod
    _, globalVars.rgbPeriod = imgui.InputFloat("RGB cycle length", oldRGBPeriod, 0, 0,
        "%.0f seconds")
    globalVars.rgbPeriod = math.clamp(globalVars.rgbPeriod, MIN_RGB_CYCLE_TIME,
        MAX_RGB_CYCLE_TIME)
    if (oldRGBPeriod ~= globalVars.rgbPeriod) then
        write(globalVars)
    end
end

function chooseScaleType(menuVars)
    local label = "Scale Type"
    menuVars.scaleTypeIndex = Combo(label, SCALE_TYPES, menuVars.scaleTypeIndex)

    local scaleType = SCALE_TYPES[menuVars.scaleTypeIndex]
    if scaleType == "Average SV" then chooseAverageSV(menuVars) end
    if scaleType == "Absolute Distance" then chooseDistance(menuVars) end
    if scaleType == "Relative Ratio" then ComputableInputFloat("Ratio", menuVars.ratio, 3) end
end

function chooseSnakeSpringConstant()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local oldValue = globalVars.snakeSpringConstant
    _, globalVars.snakeSpringConstant = imgui.InputFloat("Reactiveness##snake", oldValue, 0, 0, "%.2f")
    HelpMarker("Pick any number from 0.01 to 1")
    globalVars.snakeSpringConstant = math.clamp(globalVars.snakeSpringConstant, 0.01, 1)
    if (globalVars.snakeSpringConstant ~= oldValue) then
        write(globalVars)
    end
end

function chooseSpecialSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #STANDARD_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = Combo(label, SPECIAL_SVS, menuVars.svTypeIndex)
end

function chooseVibratoSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #VIBRATO_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = Combo(label, VIBRATO_SVS, menuVars.svTypeIndex)
end

function chooseVibratoQuality(menuVars)
    menuVars.vibratoQuality = Combo("Vibrato Quality", VIBRATO_DETAILED_QUALITIES, menuVars.vibratoQuality)
    ToolTip("Note that higher FPS will look worse on lower refresh rate monitors.")
end

function chooseCurvatureCoefficient(settingVars)
    plotExponentialCurvature(settingVars)
    imgui.SameLine(0, 0)
    _, settingVars.curvatureIndex = imgui.SliderInt("Curvature", settingVars.curvatureIndex, 1, #VIBRATO_CURVATURES,
        tostring(VIBRATO_CURVATURES[settingVars.curvatureIndex]))
end

function chooseStandardSVType(menuVars, excludeCombo)
    local oldIndex = menuVars.svTypeIndex
    local label = " " .. EMOTICONS[oldIndex]
    local svTypeList = STANDARD_SVS
    if excludeCombo then svTypeList = STANDARD_SVS_NO_COMBO end
    menuVars.svTypeIndex = Combo(label, svTypeList, menuVars.svTypeIndex)
    return oldIndex ~= menuVars.svTypeIndex
end

function chooseStandardSVTypes(settingVars)
    local oldIndex1 = settingVars.svType1Index
    local oldIndex2 = settingVars.svType2Index
    settingVars.svType1Index = Combo("SV Type 1", STANDARD_SVS_NO_COMBO, settingVars.svType1Index)
    settingVars.svType2Index = Combo("SV Type 2", STANDARD_SVS_NO_COMBO, settingVars.svType2Index)
    return (oldIndex2 ~= settingVars.svType2Index) or (oldIndex1 ~= settingVars.svType1Index)
end

function chooseStartEndSVs(settingVars)
    if settingVars.linearlyChange == false then
        local oldValue = settingVars.startSV
        _, settingVars.startSV = imgui.InputFloat("SV Value", oldValue, 0, 0, "%.2fx")
        return oldValue ~= settingVars.startSV
    end
    return SwappableNegatableInputFloat2(settingVars, "startSV", "endSV", "Start/End SV")
end

function chooseStartSVPercent(settingVars)
    local label1 = "Start SV %"
    if settingVars.linearlyChange then label1 = label1 .. " (start)" end
    _, settingVars.svPercent = imgui.InputFloat(label1, settingVars.svPercent, 1, 1, "%.2f%%")
    local HelpMarkerText = "%% distance between notes"
    if not settingVars.linearlyChange then
        HelpMarker(HelpMarkerText)
        return
    end

    local label2 = "Start SV % (end)"
    _, settingVars.svPercent2 = imgui.InputFloat(label2, settingVars.svPercent2, 1, 1, "%.2f%%")
end

function chooseStillType(menuVars)
    local stillType = STILL_TYPES[menuVars.stillTypeIndex]
    local dontChooseDistance = stillType == "No" or
        stillType == "Auto" or
        stillType == "Otua"
    local indentWidth = DEFAULT_WIDGET_WIDTH * 0.5 + 16
    if dontChooseDistance then
        imgui.Indent(indentWidth)
    else
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.6 - 5)
        _, menuVars.stillDistance = imgui.InputFloat("##still", menuVars.stillDistance, 0, 0,
            "%.2f msx")
        KeepSameLine()
        imgui.PopItemWidth()
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.4)
    menuVars.stillTypeIndex = Combo("Displacement", STILL_TYPES, menuVars.stillTypeIndex)

    if stillType == "No" then ToolTip("Don't use an initial or end displacement") end
    if stillType == "Start" then ToolTip("Use an initial starting displacement for the still") end
    if stillType == "End" then ToolTip("Have a displacement to end at for the still") end
    if stillType == "Auto" then ToolTip("Use last displacement of the previous still to start") end
    if stillType == "Otua" then ToolTip("Use next displacement of the next still to end at") end

    if dontChooseDistance then
        imgui.Unindent(indentWidth)
    end
    imgui.PopItemWidth()
end

function chooseStutterDuration(settingVars)
    local oldDuration = settingVars.stutterDuration
    if settingVars.controlLastSV then oldDuration = 100 - oldDuration end
    local _, newDuration = imgui.SliderInt("Duration", oldDuration, 1, 99, oldDuration .. "%%")
    newDuration = math.clamp(newDuration, 1, 99)
    local durationChanged = oldDuration ~= newDuration
    if settingVars.controlLastSV then newDuration = 100 - newDuration end
    settingVars.stutterDuration = newDuration
    return durationChanged
end

function chooseStyleTheme()
    local oldStyleTheme = globalVars.styleThemeIndex
    globalVars.styleThemeIndex = Combo("Style Theme", STYLE_THEMES, oldStyleTheme)
    if (oldStyleTheme ~= globalVars.styleThemeIndex) then
        write(globalVars)
    end
end

function chooseSVBehavior(settingVars)
    local swapButtonPressed = imgui.Button("Swap", SECONDARY_BUTTON_SIZE)
    ToolTip("Switch between slow down/speed up")
    KeepSameLine()
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local oldBehaviorIndex = settingVars.behaviorIndex
    settingVars.behaviorIndex = Combo("Behavior", SV_BEHAVIORS, oldBehaviorIndex)
    imgui.PopItemWidth()
    if (swapButtonPressed or exclusiveKeyPressed(globalVars.hotkeyList[3])) then
        settingVars.behaviorIndex = oldBehaviorIndex == 1 and 2 or 1
    end
    return oldBehaviorIndex ~= settingVars.behaviorIndex
end

function chooseSVPerQuarterPeriod(settingVars)
    local oldPoints = settingVars.svsPerQuarterPeriod
    local _, newPoints = imgui.InputInt("SV Points##perQuarter", oldPoints, 1, 1)
    HelpMarker("Number of SV points per 0.25 period/cycle")
    local maxSVsPerQuarterPeriod = MAX_SV_POINTS / (4 * settingVars.periods)
    newPoints = math.clamp(newPoints, 1, maxSVsPerQuarterPeriod)
    settingVars.svsPerQuarterPeriod = newPoints
    return oldPoints ~= newPoints
end

function chooseSVPoints(settingVars, svPointsForce)
    if svPointsForce then
        settingVars.svPoints = svPointsForce
        return false
    end

    return BasicInputInt(settingVars, "svPoints", "SV Points##regular", { 1, MAX_SV_POINTS })
end

function chooseDistanceMode(menuVars)
    local oldMode = menuVars.distanceMode
    menuVars.distanceMode = Combo("Distance Type", DISTANCE_TYPES, menuVars.distanceMode)
    return oldMode ~= menuVars.distanceMode
end

function choosePulseCoefficient()
    local oldCoefficient = globalVars.pulseCoefficient
    _, globalVars.pulseCoefficient = imgui.SliderFloat("Pulse Strength", oldCoefficient, 0, 1,
        math.round(globalVars.pulseCoefficient * 100) .. "%%")
    globalVars.pulseCoefficient = math.clamp(globalVars.pulseCoefficient, 0, 1)
    if (oldCoefficient ~= globalVars.pulseCoefficient) then
        write(globalVars)
    end
end

function choosePulseColor()
    _, colorPickerOpened = imgui.Begin("plumoguSV Pulse Color Picker", true,
        imgui_window_flags.AlwaysAutoResize)
    local oldColor = globalVars.pulseColor
    _, globalVars.pulseColor = imgui.ColorPicker4("Pulse Color", globalVars.pulseColor)
    if (oldColor ~= globalVars.pulseColor) then
        write(globalVars)
    end
    if (not colorPickerOpened) then
        state.SetValue("showColorPicker", false)
    end
    imgui.End()
end

function chooseVibratoSides(menuVars)
    imgui.Dummy(vector.New(27, 0))
    KeepSameLine()
    menuVars.sides = RadioButtons("Sides:", menuVars.sides, { "1", "2", "3" }, { 1, 2, 3 })
end

function chooseConvertSVSSFDirection(menuVars)
    menuVars.conversionDirection = RadioButtons("Direction:", menuVars.conversionDirection, { "SSF -> SV", "SV -> SSF" },
        { false, true })
end
