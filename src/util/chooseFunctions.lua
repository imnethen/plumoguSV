function chooseAddComboMultipliers(settingVars)
    local oldValues = vector.New(settingVars.comboMultiplier1, settingVars.comboMultiplier2)
    local _, newValues = imgui.InputFloat2("ax + by", oldValues, "%.2f")
    helpMarker("a = multiplier for SV Type 1, b = multiplier for SV Type 2")
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
    local outputValue, settingsChanged = negatableComputableInputFloat("Average SV", menuVars.avgSV, 2, "x")
    menuVars.avgSV = outputValue
    return settingsChanged
end

function chooseBezierPoints(settingVars)
    local oldFirstPoint = settingVars.p1
    local oldSecondPoint = settingVars.p2
    local _, newFirstPoint = imgui.SliderFloat2("(x1, y1)", oldFirstPoint, 0, 1, "%.2f")
    helpMarker("Coordinates of the first point of the cubic bezier")
    local _, newSecondPoint = imgui.SliderFloat2("(x2, y2)", oldSecondPoint, 0, 1, "%.2f")
    helpMarker("Coordinates of the second point of the cubic bezier")
    settingVars.p1 = newFirstPoint
    settingVars.p2 = newSecondPoint

    return settingVars.p1 ~= oldFirstPoint or settingVars.p2 ~= oldSecondPoint
end

function chooseChinchillaIntensity(settingVars)
    local oldIntensity = settingVars.chinchillaIntensity
    local _, newIntensity = imgui.SliderFloat("Intensity##chinchilla", oldIntensity, 0, 10, "%.3f")
    helpMarker("Ctrl + click slider to input a specific number")
    settingVars.chinchillaIntensity = math.clamp(newIntensity, 0, 727)
    return oldIntensity ~= settingVars.chinchillaIntensity
end

function chooseChinchillaType(settingVars)
    local oldIndex = settingVars.chinchillaTypeIndex
    settingVars.chinchillaTypeIndex = combo("Chinchilla Type", CHINCHILLA_TYPES, oldIndex)
    return oldIndex ~= settingVars.chinchillaTypeIndex
end

function chooseColorTheme()
    local oldColorThemeIndex = globalVars.colorThemeIndex
    globalVars.colorThemeIndex = combo("Color Theme", COLOR_THEMES, globalVars.colorThemeIndex, COLOR_THEME_COLORS)

    if (oldColorThemeIndex ~= globalVars.colorThemeIndex) then
        write(globalVars)
    end

    local currentTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local isRGBColorTheme = currentTheme:find("RGB") or currentTheme:find("BGR")

    if not isRGBColorTheme then return end

    chooseRGBPeriod()
end

function chooseComboPhase(settingVars, maxComboPhase)
    local oldPhase = settingVars.comboPhase
    _, settingVars.comboPhase = imgui.InputInt("Combo Phase", oldPhase, 1, 1)
    settingVars.comboPhase = math.clamp(settingVars.comboPhase, 0, maxComboPhase)
    return oldPhase ~= settingVars.comboPhase
end

function chooseComboSVOption(settingVars, maxComboPhase)
    local oldIndex = settingVars.comboTypeIndex
    settingVars.comboTypeIndex = combo("Combo Type", COMBO_SV_TYPE, settingVars.comboTypeIndex)
    local currentComboType = COMBO_SV_TYPE[settingVars.comboTypeIndex]
    local addTypeChanged = false
    if currentComboType ~= "SV Type 1 Only" and currentComboType ~= "SV Type 2 Only" then
        addTypeChanged = chooseComboPhase(settingVars, maxComboPhase) or addTypeChanged
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
    if (resetButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[5])) then
        settingVars.verticalShift = defaultShift
    end
    toolTip("Reset vertical shift to initial values")
    imgui.SameLine(0, SAMELINE_SPACING)

    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)

    if negateButtonPressed and settingVars.verticalShift ~= 0 then
        settingVars.verticalShift = -settingVars.verticalShift
    end
    toolTip("Negate vertical shift")

    imgui.SameLine(0, SAMELINE_SPACING)
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
    if (resetButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[5])) then
        settingVars.verticalShift = defaultShift or 0
    end
    toolTip("Reset vertical shift to initial values")
    imgui.SameLine(0, SAMELINE_SPACING)

    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)

    if negateButtonPressed and settingVars.verticalShift ~= 0 then
        settingVars.verticalShift = -settingVars.verticalShift
    end
    toolTip("Negate vertical shift")

    imgui.SameLine(0, SAMELINE_SPACING)
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
    local newStutterControlsIndex = combo("Control SV", STUTTER_CONTROLS, stutterControlsIndex)
    settingVars.controlLastSV = newStutterControlsIndex == 2
    local choiceChanged = oldChoice ~= settingVars.controlLastSV
    if choiceChanged then settingVars.stutterDuration = 100 - settingVars.stutterDuration end
    return choiceChanged
end

function chooseCurrentFrame(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Previewing frame:")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(35)
    if imgui.ArrowButton("##leftFrame", imgui_dir.Left) then
        settingVars.currentFrame = settingVars.currentFrame - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.currentFrame = imgui.InputInt("##currentFrame", settingVars.currentFrame, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightFrame", imgui_dir.Right) then
        settingVars.currentFrame = settingVars.currentFrame + 1
    end
    settingVars.currentFrame = math.wrap(settingVars.currentFrame, 1, settingVars.numFrames)
    imgui.PopItemWidth()
end

function chooseCursorTrail()
    local oldCursorTrailIndex = globalVars.cursorTrailIndex
    globalVars.cursorTrailIndex = combo("Cursor Trail", CURSOR_TRAILS, oldCursorTrailIndex)
    if (oldCursorTrailIndex ~= globalVars.cursorTrailIndex) then
        write(globalVars)
    end
end

function chooseCursorTrailGhost()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local oldCursorTrailGhost = globalVars.cursorTrailGhost

    _, globalVars.cursorTrailGhost = imgui.Checkbox("No Ghost", oldCursorTrailGhost)

    if (oldCursorTrailGhost ~= globalVars.cursorTrailGhost) then
        write(globalVars)
    end
end

function chooseCursorTrailPoints()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local label = "Trail Points"
    local oldCursorTrailPoints = globalVars.cursorTrailPoints
    _, globalVars.cursorTrailPoints = imgui.InputInt(label, oldCursorTrailPoints, 1, 1)
    if (oldCursorTrailPoints ~= globalVars.cursorTrailPoints) then
        write(globalVars)
    end
end

function chooseCursorTrailShape()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local label = "Trail Shape"
    local oldTrailShapeIndex = globalVars.cursorTrailShapeIndex
    globalVars.cursorTrailShapeIndex = combo(label, TRAIL_SHAPES, oldTrailShapeIndex)
    if (oldTrailShapeIndex ~= globalVars.cursorTrailShapeIndex) then
        write(globalVars)
    end
end

function chooseCursorShapeSize()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    --Reference
    local label = "Shape Size"
    local oldCursorTrailSize = globalVars.cursorTrailSize
    _, globalVars.cursorTrailSize = imgui.InputInt(label, oldCursorTrailSize, 1, 1)
    if (oldCursorTrailSize ~= globalVars.cursorTrailSize) then
        write(globalVars)
    end
end

function chooseCurveSharpness(settingVars)
    local oldSharpness = settingVars.curveSharpness
    if imgui.Button("Reset##curveSharpness", SECONDARY_BUTTON_SIZE) then
        settingVars.curveSharpness = 50
    end
    imgui.SameLine(0, SAMELINE_SPACING)
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
    menuVars.distance = computableInputFloat("Distance", menuVars.distance, 3, " msx")
    return oldDistance ~= menuVars.distance
end

function chooseVaryingDistance(settingVars)
    if (not settingVars.linearlyChange) then
        settingVars.distance = computableInputFloat("Distance", settingVars.distance, 3, " msx")
        return
    end
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = vector.New(settingVars.distance1, settingVars.distance2)
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.98 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2("Dist.", oldValues, "%.2f msx")
    imgui.PopItemWidth()
    settingVars.distance1 = newValues.x
    settingVars.distance2 = newValues.y
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.distance1 = oldValues.y
        settingVars.distance2 = oldValues.x
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars.distance1 = -oldValues.x
        settingVars.distance2 = -oldValues.y
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues ~= newValues
end

function chooseEvery(menuVars)
    _, menuVars.every = imgui.InputInt("Every __ notes", math.floor(menuVars.every))
    menuVars.every = math.clamp(menuVars.every, 1, MAX_SV_POINTS)
end

function chooseOffset(menuVars)
    _, menuVars.offset = imgui.InputInt("From note #__", math.floor(menuVars.offset))
    menuVars.offset = math.clamp(menuVars.offset, 1, menuVars.every)
end

function chooseSnap(menuVars)
    _, menuVars.snap = imgui.InputInt("Snap", math.floor(menuVars.snap))
    menuVars.snap = math.clamp(menuVars.snap, 1, 100)
end

function chooseDrawCapybara()
    local oldDrawCapybara = globalVars.drawCapybara
    _, globalVars.drawCapybara = imgui.Checkbox("Capybara", oldDrawCapybara)
    helpMarker("Draws a capybara at the bottom right of the screen")
    if (oldDrawCapybara ~= globalVars.drawCapybara) then
        write(globalVars)
    end
end

function chooseDrawCapybara2()
    local oldDrawCapybara2 = globalVars.drawCapybara2
    _, globalVars.drawCapybara2 = imgui.Checkbox("Capybara 2", oldDrawCapybara2)
    helpMarker("Draws a capybara at the bottom left of the screen")
    if (oldDrawCapybara2 ~= globalVars.drawCapybara2) then
        write(globalVars)
    end
end

function chooseDrawCapybara312()
    local oldDrawCapybara312 = globalVars.drawCapybara312
    _, globalVars.drawCapybara312 = imgui.Checkbox("Capybara 312", oldDrawCapybara312)
    if (oldDrawCapybara312 ~= globalVars.drawCapybara312) then
        write(globalVars)
    end
    helpMarker("Draws a capybara???!?!??!!!!? AGAIN?!?!")
end

function chooseSelectTool()
    imgui.AlignTextToFramePadding()
    imgui.Text("Current Type:")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.selectTypeIndex = combo("##selecttool", SELECT_TOOLS, globalVars.selectTypeIndex)

    local selectTool = SELECT_TOOLS[globalVars.selectTypeIndex]
    if selectTool == "Alternating" then toolTip("Skip over notes then select one, and repeat") end
    if selectTool == "By Snap" then toolTip("Select all notes with a certain snap color") end
    if selectTool == "Bookmark" then toolTip("Jump to a bookmark") end
    if selectTool == "Chord Size" then toolTip("Select all notes with a certain chord size") end
    if selectTool == "Note Type" then toolTip("Select rice/ln notes") end
end

function chooseEditTool()
    imgui.AlignTextToFramePadding()
    imgui.Text("  Current Tool:")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.editToolIndex = combo("##edittool", EDIT_SV_TOOLS, globalVars.editToolIndex)

    local svTool = EDIT_SV_TOOLS[globalVars.editToolIndex]
    if svTool == "Add Teleport" then toolTip("Add a large teleport SV to move far away") end
    if svTool == "Align Timing Lines" then toolTip("Create timing lines at notes to avoid desync") end
    if svTool == "Change Timing Group" then toolTip("Moves SVs and SSFs to a designated timing group.") end
    if svTool == "Convert SV <-> SSF" then toolTip("Convert multipliers between SV/SSF") end
    if svTool == "Copy & Paste" then toolTip("Copy SVs and SSFs and paste them somewhere else") end
    if svTool == "Direct SV" then toolTip("Directly update SVs within your selection") end
    if svTool == "Displace Note" then toolTip("Move where notes are hit on the screen") end
    if svTool == "Displace View" then toolTip("Temporarily displace the playfield view") end
    if svTool == "Dynamic Scale" then toolTip("Dynamically scale SVs across notes") end
    if svTool == "Fix LN Ends" then toolTip("Fix flipped LN ends") end
    if svTool == "Flicker" then toolTip("Flash notes on and off the screen") end
    if svTool == "Layer Snaps" then toolTip("Transfer snap colors into layers, to be loaded later") end
    if svTool == "Measure" then toolTip("Get stats about SVs in a section") end
    if svTool == "Merge" then toolTip("Combine SVs that overlap") end
    if svTool == "Reverse Scroll" then toolTip("Reverse the scroll direction using SVs") end
    if svTool == "Scale (Multiply)" then toolTip("Scale SV values by multiplying") end
    if svTool == "Scale (Displace)" then toolTip("Scale SV values by adding teleport SVs") end
    if svTool == "Swap Notes" then toolTip("Swap positions of notes using SVs") end
    if svTool == "Vertical Shift" then toolTip("Adds a constant value to SVs in a range") end
end

function chooseEffectFPS()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end
    local oldEffectFPS = globalVars.effectFPS
    _, globalVars.effectFPS = imgui.InputInt("Effect FPS", oldEffectFPS, 1, 1)
    if (oldEffectFPS ~= globalVars.effectFPS) then
        write(globalVars)
    end
    helpMarker("Set this to a multiple of UPS or FPS to make cursor effects smooth")
    globalVars.effectFPS = math.clamp(globalVars.effectFPS, 2, 1000)
end

function chooseFinalSV(settingVars, skipFinalSV)
    if skipFinalSV then return false end

    local oldIndex = settingVars.finalSVIndex
    local oldCustomSV = settingVars.customSV
    local finalSVType = FINAL_SV_TYPES[settingVars.finalSVIndex]
    if finalSVType ~= "Normal" then
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.35)
        _, settingVars.customSV = imgui.InputFloat("SV", settingVars.customSV, 0, 0, "%.2fx")
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.PopItemWidth()
    else
        imgui.Indent(DEFAULT_WIDGET_WIDTH * 0.35 + 25)
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    settingVars.finalSVIndex = combo("Final SV", FINAL_SV_TYPES, settingVars.finalSVIndex)
    helpMarker("Final SV won't be placed if there's already an SV at the end time")
    if finalSVType == "Normal" then
        imgui.Unindent(DEFAULT_WIDGET_WIDTH * 0.35 + 25)
    end
    imgui.PopItemWidth()
    return (oldIndex ~= settingVars.finalSVIndex) or (oldCustomSV ~= settingVars.customSV)
end

function chooseFlickerType(menuVars)
    menuVars.flickerTypeIndex = combo("Flicker Type", FLICKER_TYPES, menuVars.flickerTypeIndex)
end

function chooseFrameOrder(settingVars)
    local checkBoxText = "Reverse frame order when placing SVs"
    _, settingVars.reverseFrameOrder = imgui.Checkbox(checkBoxText, settingVars.reverseFrameOrder)
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
    local oldInterlace = menuVars.interlace
    _, menuVars.interlace = imgui.Checkbox("Interlace", menuVars.interlace)
    local interlaceChanged = oldInterlace ~= menuVars.interlace
    if not menuVars.interlace then return interlaceChanged end
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    local oldRatio = menuVars.interlaceRatio
    _, menuVars.interlaceRatio = imgui.InputFloat("Ratio##interlace", menuVars.interlaceRatio,
        0, 0, "%.2f")
    imgui.PopItemWidth()
    return interlaceChanged or oldRatio ~= menuVars.interlaceRatio
end

function chooseLinearlyChange(settingVars)
    local oldChoice = settingVars.linearlyChange
    local _, newChoice = imgui.Checkbox("Change stutter over time", oldChoice)
    settingVars.linearlyChange = newChoice
    return oldChoice ~= newChoice
end

function chooseLinearlyChangeDist(settingVars)
    local oldChoice = settingVars.linearlyChange
    local _, newChoice = imgui.Checkbox("Change distance over time", oldChoice)
    settingVars.linearlyChange = newChoice
    return oldChoice ~= newChoice
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
    local helpMarkerText = "This SV will last ~99.99%% of the stutter"
    if not settingVars.linearlyChange then
        helpMarker(helpMarkerText)
        return
    end

    _, settingVars.mainSV2 = imgui.InputFloat("Main SV (end)", settingVars.mainSV2, 0, 0, "%.2fx")
end

function chooseMeasuredStatsView(menuVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("View values:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Rounded", not menuVars.unrounded) then
        menuVars.unrounded = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Unrounded", menuVars.unrounded) then
        menuVars.unrounded = true
    end
end

function chooseMenuStep(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Step # :")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(24)
    if imgui.ArrowButton("##leftMenuStep", imgui_dir.Left) then
        settingVars.menuStep = settingVars.menuStep - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.menuStep = imgui.InputInt("##currentMenuStep", settingVars.menuStep, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightMenuStep", imgui_dir.Right) then
        settingVars.menuStep = settingVars.menuStep + 1
    end
    imgui.PopItemWidth()
    settingVars.menuStep = math.wrap(settingVars.menuStep, 1, 3)
end

function chooseNoNormalize(settingVars)
    addPadding()
    local oldChoice = settingVars.dontNormalize
    local _, newChoice = imgui.Checkbox("Don't normalize to average SV", oldChoice)
    settingVars.dontNormalize = newChoice
    return oldChoice ~= newChoice
end

function chooseNoteSkinType(settingVars)
    settingVars.noteSkinTypeIndex = combo("Preview skin", NOTE_SKIN_TYPES,
        settingVars.noteSkinTypeIndex)
    helpMarker("Note skin type for the preview of the frames")
end

function chooseNoteSpacing(menuVars)
    _, menuVars.noteSpacing = imgui.InputFloat("Note Spacing", menuVars.noteSpacing, 0, 0, "%.2fx")
end

function chooseNumFlickers(menuVars)
    _, menuVars.numFlickers = imgui.InputInt("Flickers", menuVars.numFlickers, 1, 1)
    menuVars.numFlickers = math.clamp(menuVars.numFlickers, 1, 9999)
end

function chooseFlickerPosition(menuVars)
    _, menuVars.flickerPosition = imgui.SliderFloat("Flicker Position", menuVars.flickerPosition, 0.05, 0.95,
        math.round(menuVars.flickerPosition * 100) .. "%%")
    menuVars.flickerPosition = math.round(menuVars.flickerPosition * 2, 1) / 2
end

function chooseNumFrames(settingVars)
    _, settingVars.numFrames = imgui.InputInt("Total # Frames", math.floor(settingVars.numFrames))
    settingVars.numFrames = math.clamp(settingVars.numFrames, 1, MAX_ANIMATION_FRAMES)
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

function choosePlaceSVType()
    imgui.AlignTextToFramePadding()
    imgui.Text("  Type:  ")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.placeTypeIndex = combo("##placeType", CREATE_TYPES, globalVars.placeTypeIndex)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Still" then toolTip("Still keeps notes normal distance/spacing apart") end
end

function chooseCurrentScrollGroup()
    imgui.AlignTextToFramePadding()
    imgui.Text("  Timing Group: ")
    imgui.SameLine(0, SAMELINE_SPACING)
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
    globalVars.scrollGroupIndex = combo("##scrollGroup", groups, globalVars.scrollGroupIndex, cols, hiddenGroups)
    imgui.PopItemWidth()
    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[6])) then
        globalVars.scrollGroupIndex = math.clamp(globalVars.scrollGroupIndex - 1, 1, #groups)
    end
    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[7])) then
        globalVars.scrollGroupIndex = math.clamp(globalVars.scrollGroupIndex + 1, 1, #groups)
    end
    addSeparator()
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
    settingVars.randomTypeIndex = combo("Random Type", RANDOM_TYPES, settingVars.randomTypeIndex)
    return oldIndex ~= settingVars.randomTypeIndex
end

function chooseRatio(menuVars)
    _, menuVars.ratio = imgui.InputFloat("Ratio", menuVars.ratio, 0, 0, "%.3f")
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

function chooseScaleDisplaceSpot(menuVars)
    menuVars.scaleSpotIndex = combo("Displace Spot", DISPLACE_SCALE_SPOTS, menuVars.scaleSpotIndex)
end

function chooseScaleType(menuVars)
    local label = "Scale Type"
    menuVars.scaleTypeIndex = combo(label, SCALE_TYPES, menuVars.scaleTypeIndex)

    local scaleType = SCALE_TYPES[menuVars.scaleTypeIndex]
    if scaleType == "Average SV" then chooseAverageSV(menuVars) end
    if scaleType == "Absolute Distance" then chooseDistance(menuVars) end
    if scaleType == "Relative Ratio" then chooseRatio(menuVars) end
end

function chooseSnakeSpringConstant()
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local oldValue = globalVars.snakeSpringConstant
    _, globalVars.snakeSpringConstant = imgui.InputFloat("Reactiveness##snake", oldValue, 0, 0, "%.2f")
    helpMarker("Pick any number from 0.01 to 1")
    globalVars.snakeSpringConstant = math.clamp(globalVars.snakeSpringConstant, 0.01, 1)
    if (globalVars.snakeSpringConstant ~= oldValue) then
        write(globalVars)
    end
end

function chooseSpecialSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #STANDARD_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = combo(label, SPECIAL_SVS, menuVars.svTypeIndex)
end

function chooseVibratoSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #VIBRATO_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = combo(label, VIBRATO_SVS, menuVars.svTypeIndex)
end

function chooseVibratoMode(menuVars)
    menuVars.vibratoMode = combo("Vibrato Mode", VIBRATO_TYPES, menuVars.vibratoMode)
end

function chooseVibratoQuality(menuVars)
    menuVars.vibratoQuality = combo("Vibrato Quality", VIBRATO_DETAILED_QUALITIES, menuVars.vibratoQuality)
    toolTip("Note that higher FPS will look worse on lower refresh rate monitors.")
end

function chooseCurvatureCoefficient(settingVars)
    imgui.PushItemWidth(28)
    imgui.PushStyleColor(imgui_col.FrameBg, 0)
    local RESOLUTION = 16
    local values = table.construct()
    for i = 0, RESOLUTION do
        local curvature = VIBRATO_CURVATURES[settingVars.curvatureIndex]
        local t = i / RESOLUTION
        local value = t
        if (curvature >= 1) then
            value = t ^ curvature
        else
            value = (1 - (1 - t) ^ (1 / curvature))
        end
        if ((settingVars.startMsx or settingVars.lowerStart) > (settingVars.endMsx or settingVars.lowerEnd)) then
            value = 1 - value
        elseif ((settingVars.startMsx or settingVars.lowerStart) == (settingVars.endMsx or settingVars.lowerEnd)) then
            value = 0.5
        end
        values:insert(value)
    end
    imgui.PlotLines("##CurvaturePlot", values, #values, 0, "", 0, 1)
    imgui.PopStyleColor()
    imgui.PopItemWidth()
    imgui.SameLine(0, 0)
    _, settingVars.curvatureIndex = imgui.SliderInt("Curvature", settingVars.curvatureIndex, 1, #VIBRATO_CURVATURES,
        tostring(VIBRATO_CURVATURES[settingVars.curvatureIndex]))
end

function chooseStandardSVType(menuVars, excludeCombo)
    local oldIndex = menuVars.svTypeIndex
    local label = " " .. EMOTICONS[oldIndex]
    local svTypeList = STANDARD_SVS
    if excludeCombo then svTypeList = STANDARD_SVS_NO_COMBO end
    menuVars.svTypeIndex = combo(label, svTypeList, menuVars.svTypeIndex)
    return oldIndex ~= menuVars.svTypeIndex
end

function chooseStandardSVTypes(settingVars)
    local oldIndex1 = settingVars.svType1Index
    local oldIndex2 = settingVars.svType2Index
    settingVars.svType1Index = combo("SV Type 1", STANDARD_SVS_NO_COMBO, settingVars.svType1Index)
    settingVars.svType2Index = combo("SV Type 2", STANDARD_SVS_NO_COMBO, settingVars.svType2Index)
    return (oldIndex2 ~= settingVars.svType2Index) or (oldIndex1 ~= settingVars.svType1Index)
end

function chooseStartEndSVs(settingVars)
    if settingVars.linearlyChange == false then
        local oldValue = settingVars.startSV
        _, settingVars.startSV = imgui.InputFloat("SV Value", oldValue, 0, 0, "%.2fx")
        return oldValue ~= settingVars.startSV
    end
    return swappableNegatableInputFloat2(settingVars, "startSV", "endSV", "Start/End SV")
end

function chooseStartSVPercent(settingVars)
    local label1 = "Start SV %"
    if settingVars.linearlyChange then label1 = label1 .. " (start)" end
    _, settingVars.svPercent = imgui.InputFloat(label1, settingVars.svPercent, 1, 1, "%.2f%%")
    local helpMarkerText = "%% distance between notes"
    if not settingVars.linearlyChange then
        helpMarker(helpMarkerText)
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
        imgui.SameLine(0, SAMELINE_SPACING)
        imgui.PopItemWidth()
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.4)
    menuVars.stillTypeIndex = combo("Displacement", STILL_TYPES, menuVars.stillTypeIndex)

    if stillType == "No" then toolTip("Don't use an initial or end displacement") end
    if stillType == "Start" then toolTip("Use an initial starting displacement for the still") end
    if stillType == "End" then toolTip("Have a displacement to end at for the still") end
    if stillType == "Auto" then toolTip("Use last displacement of the previous still to start") end
    if stillType == "Otua" then toolTip("Use next displacement of the next still to end at") end

    if dontChooseDistance then
        imgui.Unindent(indentWidth)
    end
    imgui.PopItemWidth()
end

function chooseStillBehavior(menuVars)
    menuVars.stillBehavior = combo("Still Behavior", STILL_BEHAVIOR_TYPES, menuVars.stillBehavior)
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

function chooseStuttersPerSection(settingVars)
    local oldNumber = settingVars.stuttersPerSection
    local _, newNumber = imgui.InputInt("Stutters", oldNumber, 1, 1)
    helpMarker("Number of stutters per section")
    newNumber = math.clamp(newNumber, 1, 1000)
    settingVars.stuttersPerSection = newNumber
    return oldNumber ~= newNumber
end

function chooseStyleTheme()
    local oldStyleTheme = globalVars.styleThemeIndex
    globalVars.styleThemeIndex = combo("Style Theme", STYLE_THEMES, oldStyleTheme)
    if (oldStyleTheme ~= globalVars.styleThemeIndex) then
        write(globalVars)
    end
end

function chooseSVBehavior(settingVars)
    local swapButtonPressed = imgui.Button("Swap", SECONDARY_BUTTON_SIZE)
    toolTip("Switch between slow down/speed up")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local oldBehaviorIndex = settingVars.behaviorIndex
    settingVars.behaviorIndex = combo("Behavior", SV_BEHAVIORS, oldBehaviorIndex)
    imgui.PopItemWidth()
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.behaviorIndex = oldBehaviorIndex == 1 and 2 or 1
    end
    return oldBehaviorIndex ~= settingVars.behaviorIndex
end

function chooseSVPerQuarterPeriod(settingVars)
    local oldPoints = settingVars.svsPerQuarterPeriod
    local _, newPoints = imgui.InputInt("SV Points##perQuarter", oldPoints, 1, 1)
    helpMarker("Number of SV points per 0.25 period/cycle")
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

    local oldPoints = settingVars.svPoints
    _, settingVars.svPoints = imgui.InputInt("SV Points##regular", oldPoints, 1, 1)
    settingVars.svPoints = math.clamp(settingVars.svPoints, 1, MAX_SV_POINTS)
    return oldPoints ~= settingVars.svPoints
end

function chooseUpscroll()
    imgui.AlignTextToFramePadding()
    imgui.Text("Scroll Direction:")
    toolTip("Orientation for distance graphs and visuals")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    local oldUpscroll = globalVars.upscroll
    if imgui.RadioButton("Down", not globalVars.upscroll) then
        globalVars.upscroll = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Up         ", globalVars.upscroll) then
        globalVars.upscroll = true
    end
    if (oldUpscroll ~= globalVars.upscroll) then
        write(globalVars)
    end
end

function chooseUseDistance(settingVars)
    local label = "Use distance for start SV"
    _, settingVars.useDistance = imgui.Checkbox(label, settingVars.useDistance)
end

function chooseHand(settingVars)
    local label = "Add teleport before note"
    _, settingVars.teleportBeforeHand = imgui.Checkbox(label, settingVars.teleportBeforeHand)
end

function chooseDistanceMode(menuVars)
    local oldMode = menuVars.distanceMode
    menuVars.distanceMode = combo("Distance Type", DISTANCE_TYPES, menuVars.distanceMode)
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

function computableInputFloat(label, var, decimalPlaces, suffix)
    local computableStateIndex = state.GetValue("computableInputFloatIndex") or 1
    local previousValue = var

    _, var = imgui.InputText(label,
        string.format("%." .. decimalPlaces .. "f" .. suffix,
            math.toNumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+") or tostring(var):match("%d*[%-]?%d+")) or 0),
        4096,
        imgui_input_text_flags.AutoSelectAll)
    if (not imgui.IsItemActive() and state.GetValue("previouslyActiveImguiFloat" .. computableStateIndex, false)) then
        local desiredComp = tostring(var):gsub(" ", "")
        var = expr(desiredComp)
    end
    state.SetValue("previouslyActiveImguiFloat" .. computableStateIndex, imgui.IsItemActive())
    state.SetValue("computableInputFloatIndex", computableStateIndex + 1)

    return math.toNumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+") or tostring(var):match("%d*[%-]?%d+")),
        previousValue ~= var
end

function negatableComputableInputFloat(label, var, decimalPlaces, suffix)
    local oldValue = var
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("Neg.", SECONDARY_BUTTON_SIZE)
    toolTip("Negate SV value")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local newValue = computableInputFloat(label, var, decimalPlaces, suffix)
    imgui.PopItemWidth()
    if ((negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) and newValue ~= 0) then
        newValue = -newValue
    end
    return newValue, oldValue ~= newValue
end

function swappableNegatableInputFloat2(settingVars, lowerName, higherName, label, suffix, digits, widthFactor)
    digits = digits or 2
    suffix = suffix or "x"
    widthFactor = widthFactor or 0.7
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(7, 4))
    local swapButtonPressed = imgui.Button("S##" .. lowerName, TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end values")
    local oldValues = vector.New(settingVars[lowerName], settingVars[higherName])
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(6.5, 4))
    local negateButtonPressed = imgui.Button("N##" .. higherName, TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, vector.New(PADDING_WIDTH, 5))
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * widthFactor - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2(label, oldValues, "%." .. digits .. "f" .. suffix)
    imgui.PopItemWidth()
    settingVars[lowerName] = newValues.x
    settingVars[higherName] = newValues.y
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars[lowerName] = oldValues.y
        settingVars[higherName] = oldValues.x
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars[lowerName] = -oldValues.x
        settingVars[higherName] = -oldValues.y
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues ~= newValues
end

function globalCheckbox(parameterName, label, tooltipText)
    local oldValue = globalVars[parameterName]
    ---@cast oldValue boolean
    _, globalVars[parameterName] = imgui.Checkbox(label, oldValue)
    if (tooltipText) then toolTip(tooltipText) end
    if (oldValue ~= globalVars[parameterName]) then write(globalVars) end
end

function codeInput(settingVars, parameterName, label, tooltipText)
    local oldCode = settingVars[parameterName]
    _, settingVars[parameterName] = imgui.InputTextMultiline(label, settingVars[parameterName], 16384,
        vector.New(240, 120))
    if (tooltipText) then toolTip(tooltipText) end
    return oldCode ~= settingVars[parameterName]
end

function colorInput(customStyle, parameterName, label, tooltipText)
    addSeparator()
    local oldCode = customStyle[parameterName]
    _, customStyle[parameterName] = imgui.ColorPicker4(label, customStyle[parameterName] or DEFAULT_STYLE[parameterName])
    if (tooltipText) then toolTip(tooltipText) end
    return oldCode ~= customStyle[parameterName]
end

function chooseVibratoSides(menuVars)
    imgui.AlignTextToFramePadding()
    imgui.Dummy(vector.New(27, 0))
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.Text("Sides:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("1", menuVars.sides == 1) then
        menuVars.sides = 1
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("2", menuVars.sides == 2) then
        menuVars.sides = 2
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("3", menuVars.sides == 3) then
        menuVars.sides = 3
    end
end

function chooseConvertSVSSFDirection(menuVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Direction:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("SSF -> SV", not menuVars.conversionDirection) then
        menuVars.conversionDirection = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("SV -> SSF", menuVars.conversionDirection) then
        menuVars.conversionDirection = true
    end
end
