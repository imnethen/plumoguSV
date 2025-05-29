-- Lets you choose the multipliers for adding combo SVs
-- Returns whether or not the multipliers changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseAddComboMultipliers(settingVars)
    local oldValues = { settingVars.comboMultiplier1, settingVars.comboMultiplier2 }
    local _, newValues = imgui.InputFloat2("ax + by", oldValues, "%.2f")
    helpMarker("a = multiplier for SV Type 1, b = multiplier for SV Type 2")
    settingVars.comboMultiplier1 = newValues[1]
    settingVars.comboMultiplier2 = newValues[2]
    return oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end

-- Lets you choose the arc percent
-- Returns whether or not the arc percent changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseArcPercent(settingVars)
    local oldPercent = settingVars.arcPercent
    local _, newPercent = imgui.SliderInt("Arc Percent", oldPercent, 1, 99, oldPercent .. "%%")
    newPercent = math.clamp(newPercent, 1, 99)
    settingVars.arcPercent = newPercent
    return oldPercent ~= newPercent
end

-- Lets you choose the average SV
-- Returns whether or not the average SV changed [Boolean]
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseAverageSV(menuVars)
    local oldAvg = menuVars.avgSV
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 6.5, 4 })
    local negateButtonPressed = imgui.Button("Neg.", SECONDARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    _, menuVars.avgSV = imgui.InputFloat("Average SV", menuVars.avgSV, 0, 0, "%.2fx")
    imgui.PopItemWidth()
    if ((negateButtonPressed or utils.IsKeyPressed("N")) and menuVars.avgSV ~= 0) then
        menuVars.avgSV = -menuVars.avgSV
    end
    return oldAvg ~= menuVars.avgSV
end

-- Lets you choose the bezier point coordinates
-- Returns whether or not any of the coordinates changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseBezierPoints(settingVars)
    local oldFirstPoint = { settingVars.x1, settingVars.y1 }
    local oldSecondPoint = { settingVars.x2, settingVars.y2 }
    local _, newFirstPoint = imgui.DragFloat2("(x1, y1)", oldFirstPoint, 0.01, -1, 2, "%.2f")
    helpMarker("Coordinates of the first point of the cubic bezier")
    local _, newSecondPoint = imgui.DragFloat2("(x2, y2)", oldSecondPoint, 0.01, -1, 2, "%.2f")
    helpMarker("Coordinates of the second point of the cubic bezier")
    settingVars.x1, settingVars.y1 = table.unpack(newFirstPoint)
    settingVars.x2, settingVars.y2 = table.unpack(newSecondPoint)
    settingVars.x1 = math.clamp(settingVars.x1, 0, 1)
    settingVars.y1 = math.clamp(settingVars.y1, -1, 2)
    settingVars.x2 = math.clamp(settingVars.x2, 0, 1)
    settingVars.y2 = math.clamp(settingVars.y2, -1, 2)
    local x1Changed = (oldFirstPoint[1] ~= settingVars.x1)
    local y1Changed = (oldFirstPoint[2] ~= settingVars.y1)
    local x2Changed = (oldSecondPoint[1] ~= settingVars.x2)
    local y2Changed = (oldSecondPoint[2] ~= settingVars.y2)
    return x1Changed or y1Changed or x2Changed or y2Changed
end

-- Lets you choose the chinchilla SV intensity
-- Returns whether or not the intensity changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseChinchillaIntensity(settingVars)
    local oldIntensity = settingVars.chinchillaIntensity
    local _, newIntensity = imgui.SliderFloat("Intensity##chinchilla", oldIntensity, 0, 10, "%.3f")
    helpMarker("Ctrl + click slider to input a specific number")
    settingVars.chinchillaIntensity = math.clamp(newIntensity, 0, 727)
    return oldIntensity ~= settingVars.chinchillaIntensity
end

-- Lets you choose the chinchilla SV type
-- Returns whether or not the SV type changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseChinchillaType(settingVars)
    local oldIndex = settingVars.chinchillaTypeIndex
    settingVars.chinchillaTypeIndex = combo("Chinchilla Type", CHINCHILLA_TYPES, oldIndex)
    return oldIndex ~= settingVars.chinchillaTypeIndex
end

-- Lets you choose the color theme of the plugin
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseColorTheme(globalVars)
    local oldColorThemeIndex = globalVars.colorThemeIndex
    globalVars.colorThemeIndex = combo("Color Theme", COLOR_THEMES, globalVars.colorThemeIndex)

    if (oldColorThemeIndex ~= globalVars.colorThemeIndex) then
        write(globalVars)
    end

    local currentTheme = COLOR_THEMES[globalVars.colorThemeIndex]
    local isRGBColorTheme = currentTheme == "Tobi's RGB Glass" or
        currentTheme == "Glass + RGB" or
        currentTheme == "Incognito + RGB" or
        currentTheme == "RGB Gamer Mode" or
        currentTheme == "edom remag BGR" or
        currentTheme == "BGR + otingocnI"
    if not isRGBColorTheme then return end

    chooseRGBPeriod(globalVars)
end

-- Lets you choose the combo SV phase number
-- Returns whether or not the phase number changed [Boolean]
-- Parameters
--    settingVars   : list of variables used for the current menu [Table]
--    maxComboPhase : maximum value allowed for combo phase [Int]
function chooseComboPhase(settingVars, maxComboPhase)
    local oldPhase = settingVars.comboPhase
    _, settingVars.comboPhase = imgui.InputInt("Combo Phase", oldPhase, 1, 1)
    settingVars.comboPhase = math.clamp(settingVars.comboPhase, 0, maxComboPhase)
    return oldPhase ~= settingVars.comboPhase
end

-- Lets you choose the combo SV combo interaction type
-- Returns whether or not the interaction type changed [Boolean]
-- Parameters
--    settingVars   : list of variables used for the current menu [Table]
--    maxComboPhase : maximum value allowed for combo phase [Int]
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

-- Lets you choose a constant amount to shift SVs
-- Returns whether or not the shift amount changed [Boolean]
-- Parameters
--    settingVars  : list of variables used for the current menu [Table]
--    defaultShift : default value for the shift when reset [Int/Float]
function chooseConstantShift(settingVars, defaultShift)
    local oldShift = settingVars.verticalShift

    imgui.PushStyleVar(imgui_style_var.FramePadding, { 7, 4 })
    local resetButtonPressed = imgui.Button("R", TERTIARY_BUTTON_SIZE)
    if (resetButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[5])) then
        settingVars.verticalShift = defaultShift
    end
    toolTip("Reset vertical shift to initial values")
    imgui.SameLine(0, SAMELINE_SPACING)

    imgui.PushStyleVar(imgui_style_var.FramePadding, { 6.5, 4 })
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)

    if negateButtonPressed and settingVars.verticalShift ~= 0 then
        settingVars.verticalShift = -settingVars.verticalShift
    end
    toolTip("Negate start/end SV values")

    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })

    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local inputText = "Vertical Shift"
    _, settingVars.verticalShift = imgui.InputFloat(inputText, settingVars.verticalShift, 0, 0, "%.3fx")
    imgui.PopItemWidth()

    return oldShift ~= settingVars.verticalShift
end

-- Lets you choose whether or not to control the second SV for stutter SV
-- Returns whether or not the choice changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
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

-- Lets you choose the current frame
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseCurrentFrame(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Previewing frame:")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(35)
    imgui.PushButtonRepeat(true)
    if imgui.ArrowButton("##leftFrame", imgui_dir.Left) then
        settingVars.currentFrame = settingVars.currentFrame - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.currentFrame = imgui.InputInt("##currentFrame", settingVars.currentFrame, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightFrame", imgui_dir.Right) then
        settingVars.currentFrame = settingVars.currentFrame + 1
    end
    imgui.PopButtonRepeat()
    settingVars.currentFrame = math.wrap(settingVars.currentFrame, 1, settingVars.numFrames)
    imgui.PopItemWidth()
end

-- Lets you choose the cursor trail of the mouse
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseCursorTrail(globalVars)
    local oldCursorTrailIndex = globalVars.cursorTrailIndex
    globalVars.cursorTrailIndex = combo("Cursor Trail", CURSOR_TRAILS, oldCursorTrailIndex)
    if (oldCursorTrailIndex ~= globalVars.cursorTrailIndex) then
        write(globalVars)
    end
end

-- Lets you choose whether or not the cursor trail will gradually become transparent
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseCursorTrailGhost(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local oldCursorTrailGhost = globalVars.cursorTrailGhost

    _, globalVars.cursorTrailGhost = imgui.Checkbox("No Ghost", oldCursorTrailGhost)

    if (oldCursorTrailGhost ~= globalVars.cursorTrailGhost) then
        write(globalVars)
    end
end

-- Lets you choose the number of points for the cursor trail
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseCursorTrailPoints(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local label = "Trail Points"
    local oldCursorTrailPoints = globalVars.cursorTrailPoints
    _, globalVars.cursorTrailPoints = imgui.InputInt(label, oldCursorTrailPoints, 1, 1)
    if (oldCursorTrailPoints ~= globalVars.cursorTrailPoints) then
        write(globalVars)
    end
end

-- Lets you choose the cursor trail shape type
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseCursorTrailShape(globalVars)
    local currentTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if currentTrail ~= "Snake" then return end

    local label = "Trail Shape"
    local oldTrailShapeIndex = globalVars.cursorTrailShapeIndex
    globalVars.cursorTrailShapeIndex = combo(label, TRAIL_SHAPES, oldTrailShapeIndex)
    if (oldTrailShapeIndex ~= globalVars.cursorTrailShapeIndex) then
        write(globalVars)
    end
end

-- Lets you choose the size of the cursor shapes
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseCursorShapeSize(globalVars)
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

-- Lets you choose SV curve sharpness
-- Returns whether or not the curve sharpness changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseCurveSharpness(settingVars)
    local oldSharpness = settingVars.curveSharpness
    if imgui.Button("Reset##curveSharpness", SECONDARY_BUTTON_SIZE) then
        settingVars.curveSharpness = 50
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newSharpness = imgui.DragInt("Curve Sharpness", settingVars.curveSharpness, 1, 1,
        100, "%d%%")
    imgui.PopItemWidth()
    newSharpness = math.clamp(newSharpness, 1, 100)
    settingVars.curveSharpness = newSharpness
    return oldSharpness ~= newSharpness
end

-- Lets you choose custom multipliers for custom SV
-- Returns whether or not any custom multipliers changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseCustomMultipliers(settingVars)
    imgui.BeginChild("Custom Multipliers", { imgui.GetContentRegionAvailWidth(), 90 }, true)
    for i = 1, #settingVars.svMultipliers do
        local selectableText = table.concat({ i, " )   ", settingVars.svMultipliers[i] })
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

-- Lets you choose a distance
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseDistance(menuVars)
    local oldDistance = menuVars.distance
    menuVars.distance = computableInputFloat("Distance", menuVars.distance, 3, " msx")
    return oldDistance ~= menuVars.distance
end

-- Lets you choose a distance
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseVaryingDistance(settingVars)
    if (not settingVars.linearlyChange) then
        settingVars.distance = computableInputFloat("Distance", settingVars.distance, 3, " msx")
        return
    end
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 7, 4 })
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = { settingVars.distance1, settingVars.distance2 }
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 6.5, 4 })
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.98 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2("Dist.", oldValues, "%.2f msx")
    imgui.PopItemWidth()
    settingVars.distance1 = newValues[1]
    settingVars.distance2 = newValues[2]
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.distance1 = oldValues[2]
        settingVars.distance2 = oldValues[1]
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars.distance1 = -oldValues[1]
        settingVars.distance2 = -oldValues[2]
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end

function chooseEvery(menuVars)
    _, menuVars.every = imgui.InputInt("Every __ notes", menuVars.every)
    menuVars.every = math.clamp(menuVars.every, 1, MAX_SV_POINTS)
end

function chooseOffset(menuVars)
    _, menuVars.offset = imgui.InputInt("From note #__", menuVars.offset)
    menuVars.offset = math.clamp(menuVars.offset, 1, menuVars.every)
end

function chooseSnap(menuVars)
    _, menuVars.snap = imgui.InputInt("Snap", menuVars.snap)
    menuVars.snap = math.clamp(menuVars.snap, 1, 100)
end

-- Lets you choose the distance back for splitscroll between scroll1 and scroll2
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseDistanceBack(settingVars)
    _, settingVars.distanceBack = imgui.InputFloat("Split Distance", settingVars.distanceBack,
        0, 0, "%.3f msx")
    helpMarker("Splitscroll distance separating scroll1 and scroll2 planes")
end

-- Lets you choose the distance back for splitscroll between scroll2 and scroll3
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseDistanceBack2(settingVars)
    _, settingVars.distanceBack2 = imgui.InputFloat("Split Dist 2", settingVars.distanceBack2,
        0, 0, "%.3f msx")
    helpMarker("Splitscroll distance separating scroll2 and scroll3 planes")
end

-- Lets you choose the distance back for splitscroll between scroll3 and scroll4
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseDistanceBack3(settingVars)
    _, settingVars.distanceBack3 = imgui.InputFloat("Split Dist 3", settingVars.distanceBack3,
        0, 0, "%.3f msx")
    helpMarker("Splitscroll distance separating scroll3 and scroll4 planes")
end

-- Lets you choose whether or not to replace SVs when placing SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseDontReplaceSV(globalVars)
    local label = "Dont replace SVs when placing regular SVs"
    local oldDontReplaceSV = globalVars.dontReplaceSV
    _, globalVars.dontReplaceSV = imgui.Checkbox(label, oldDontReplaceSV)
    if (oldDontReplaceSV ~= globalVars.dontReplaceSV) then
        write(globalVars)
    end
end

-- Lets you choose whether or not to replace SVs when placing SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseBetaIgnore(globalVars)
    local oldIgnore = globalVars.BETA_IGNORE_NOTES_OUTSIDE_TG
    _, globalVars.BETA_IGNORE_NOTES_OUTSIDE_TG = imgui.Checkbox("Ignore notes outside current timing group",
        oldIgnore)
    if (oldIgnore ~= globalVars.BETA_IGNORE_NOTES_OUTSIDE_TG) then
        write(globalVars)
    end
end

-- Lets you choose whether or not to draw a capybara on screen
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseDrawCapybara(globalVars)
    local oldDrawCapybara = globalVars.drawCapybara
    _, globalVars.drawCapybara = imgui.Checkbox("Capybara", oldDrawCapybara)
    helpMarker("Draws a capybara at the bottom right of the screen")
    if (oldDrawCapybara ~= globalVars.drawCapybara) then
        write(globalVars)
    end
end

-- Lets you choose whether or not to draw the second capybara on screen
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseDrawCapybara2(globalVars)
    local oldDrawCapybara2 = globalVars.drawCapybara2
    _, globalVars.drawCapybara2 = imgui.Checkbox("Capybara 2", oldDrawCapybara2)
    helpMarker("Draws a capybara at the bottom left of the screen")
    if (oldDrawCapybara2 ~= globalVars.drawCapybara2) then
        write(globalVars)
    end
end

-- Lets you choose whether or not to draw capybara 312 on screen
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseDrawCapybara312(globalVars)
    local oldDrawCapybara312 = globalVars.drawCapybara312
    _, globalVars.drawCapybara312 = imgui.Checkbox("Capybara 312", oldDrawCapybara312)
    if (oldDrawCapybara312 ~= globalVars.drawCapybara312) then
        write(globalVars)
    end
    helpMarker("Draws a capybara???!?!??!!!!? AGAIN?!?!")
end

-- Lets you choose which select tool to use
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseSelectTool(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Current Type:")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.selectTypeIndex = combo("##selecttool", SELECT_TOOLS, globalVars.selectTypeIndex)

    local selectTool = SELECT_TOOLS[globalVars.selectTypeIndex]
    if selectTool == "Alternating" then toolTip("Skip over notes then select one, and repeat") end
    if selectTool == "By Snap" then toolTip("Select all notes with a certain snap color") end
    if selectTool == "Bookmark" then toolTip("Jump to a bookmark") end
    if selectTool == "Chord Size" then toolTip("Select all notes with a certain chord size") end
end

-- Lets you choose which edit tool to use
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseEditTool(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("  Current Tool:")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.editToolIndex = combo("##edittool", EDIT_SV_TOOLS, globalVars.editToolIndex)

    local svTool = EDIT_SV_TOOLS[globalVars.editToolIndex]
    if svTool == "Add Teleport" then toolTip("Add a large teleport SV to move far away") end
    if svTool == "Align Timing Lines" then toolTip("Create timing lines at notes to avoid desync") end
    if svTool == "Copy & Paste" then toolTip("Copy SVs and SSFs and paste them somewhere else") end
    if svTool == "Direct SV" then toolTip("Directly update SVs within your selection") end
    if svTool == "Displace Note" then toolTip("Move where notes are hit on the screen") end
    if svTool == "Displace View" then toolTip("Temporarily displace the playfield view") end
    if svTool == "Dynamic Scale" then toolTip("Dynamically scale SVs across notes") end
    if svTool == "Fix LN Ends" then toolTip("Fix flipped LN ends") end
    if svTool == "Flicker" then toolTip("Flash notes on and off the screen") end
    if svTool == "Measure" then toolTip("Get stats about SVs in a section") end
    if svTool == "Merge" then toolTip("Combine SVs that overlap") end
    if svTool == "Reverse Scroll" then toolTip("Reverse the scroll direction using SVs") end
    if svTool == "Scale (Multiply)" then toolTip("Scale SV values by multiplying") end
    if svTool == "Scale (Displace)" then toolTip("Scale SV values by adding teleport SVs") end
    if svTool == "Swap Notes" then toolTip("Swap positions of notes using SVs") end
    if svTool == "Vertical Shift" then toolTip("Adds a constant value to SVs in a range") end
end

-- Lets you choose the frames per second of a plugin cursor effect
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseEffectFPS(globalVars)
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

-- Lets you choose the final SV to place at the end of SV sets
-- Returns whether or not the final SV type/value changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
--    skipFinalSV : whether or not to skip choosing the final SV [Boolean]
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
        imgui.Indent(DEFAULT_WIDGET_WIDTH * 0.35 + 24)
    end
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.5)
    settingVars.finalSVIndex = combo("Final SV", FINAL_SV_TYPES, settingVars.finalSVIndex)
    helpMarker("Final SV won't be placed if there's already an SV at the end time")
    if finalSVType == "Normal" then
        imgui.Unindent(DEFAULT_WIDGET_WIDTH * 0.35 + 24)
    end
    imgui.PopItemWidth()
    return (oldIndex ~= settingVars.finalSVIndex) or (oldCustomSV ~= settingVars.customSV)
end

-- Lets you choose the first height/displacement for splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseFirstHeight(settingVars)
    _, settingVars.height1 = imgui.InputFloat("1st Height", settingVars.height1, 0, 0, "%.3f msx")
    helpMarker("Height at which notes are hit at on screen for the 1st scroll speed")
end

-- Lets you choose the first scroll speed for splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseFirstScrollSpeed(settingVars)
    local text = "1st Scroll Speed"
    _, settingVars.scrollSpeed1 = imgui.InputFloat(text, settingVars.scrollSpeed1, 0, 0, "%.2fx")
end

-- Lets you choose the flicker type
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseFlickerType(menuVars)
    menuVars.flickerTypeIndex = combo("Flicker Type", FLICKER_TYPES, menuVars.flickerTypeIndex)
end

-- Lets you choose whether or not to reverse the frame order for the frame setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseFrameOrder(settingVars)
    local checkBoxText = "Reverse frame order when placing SVs"
    _, settingVars.reverseFrameOrder = imgui.Checkbox(checkBoxText, settingVars.reverseFrameOrder)
end

-- Lets you choose the distance between frames
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseFrameSpacing(settingVars)
    _, settingVars.frameDistance = imgui.InputFloat("Frame Spacing", settingVars.frameDistance,
        0, 0, "%.0f msx")
    settingVars.frameDistance = math.clamp(settingVars.frameDistance, 2000, 100000)
end

-- Lets you choose the values for the selected frameTime
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseFrameTimeData(settingVars)
    if #settingVars.frameTimes == 0 then return end
    local frameTime = settingVars.frameTimes[settingVars.selectedTimeIndex]
    _, frameTime.frame = imgui.InputInt("Frame #", frameTime.frame)
    frameTime.frame = math.clamp(frameTime.frame, 1, settingVars.numFrames)
    _, frameTime.position = imgui.InputInt("Note height", frameTime.position)
end

-- Lets you choose the intensity in customizable steps (1 to 100)
-- Returns whether or not the intensity changed [Boolean]
-- Parameters:
--    settingVars : table of variables used for the current menu
--    stepSize    : number representing the increment size (e.g., 1, 5, 10)
function chooseIntensity(settingVars)
    local userStepSize = state.GetValue("global_stepSize") or 5
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

-- Lets you choose the interlace
-- Returns whether or not the interlace settings changed [Boolean]
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
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

-- Lets you choose whether or not to linearly change a stutter over time
-- Returns whether or not the choice changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseLinearlyChange(settingVars)
    local oldChoice = settingVars.linearlyChange
    local _, newChoice = imgui.Checkbox("Change stutter over time", oldChoice)
    settingVars.linearlyChange = newChoice
    return oldChoice ~= newChoice
end

-- Lets you choose whether or not to linearly change a stutter over time
-- Returns whether or not the choice changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseLinearlyChangeDist(settingVars)
    local oldChoice = settingVars.linearlyChange
    local _, newChoice = imgui.Checkbox("Change distance over time", oldChoice)
    settingVars.linearlyChange = newChoice
    return oldChoice ~= newChoice
end

-- Lets you choose whether or not the plugin will be in keyboard mode
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseKeyboardMode(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Plugin Mode:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    local oldKeyboardMode = globalVars.keyboardMode
    if imgui.RadioButton("Default", not globalVars.keyboardMode) then
        globalVars.keyboardMode = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("Keyboard", globalVars.keyboardMode) then
        globalVars.keyboardMode = true
    end
    if (oldKeyboardMode ~= globalVars.keyboardMode) then
        write(globalVars)
    end
end

-- Lets you choose whether to activate or deactivate "Advanced Mode"
function chooseAdvancedMode(globalVars)
    local oldAdvancedMode = globalVars.advancedMode
    imgui.AlignTextToFramePadding()
    imgui.Text("Advanced Mode:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("OFF", not globalVars.advancedMode) then
        globalVars.advancedMode = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("ON", globalVars.advancedMode) then
        globalVars.advancedMode = true
    end
    if (oldAdvancedMode ~= globalVars.advancedMode) then
        write(globalVars)
        state.SetValue("global_advancedMode", globalVars.advancedMode)
    end
end

-- Lets you choose whether to activate or deactivate hiding automated timing groups.
function chooseHideAutomatic(globalVars)
    local oldHideAutomatic = globalVars.hideAutomatic
    imgui.AlignTextToFramePadding()
    imgui.Text("Hide Automatic TGs?:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("NO", not globalVars.hideAutomatic) then
        globalVars.hideAutomatic = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("YES", globalVars.hideAutomatic) then
        globalVars.hideAutomatic = true
    end
    if (oldHideAutomatic ~= globalVars.hideAutomatic) then
        write(globalVars)
        state.SetValue("globalVars.hideAutomatic", globalVars.hideAutomatic)
    end
end

-- Lets you choose the increments the Intensity slider goes by (e.g. Exponential Intensity Slider)
function chooseStepSize(globalVars)
    imgui.PushItemWidth(40)
    local oldStepSize = globalVars.stepSize
    local _, tempStepSize = imgui.InputFloat("Exponential Intensity Step Size", oldStepSize, 0, 0, "%.0f %%")
    globalVars.stepSize = math.clamp(tempStepSize, 1, 100)
    imgui.PopItemWidth()
    if (oldStepSize ~= globalVars.stepSize) then
        write(globalVars)
        state.SetValue("global_stepSize", globalVars.stepSize)
    end
end

-- Lets you choose the main SV multiplier of a teleport stutter
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
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

-- Lets you choose a rounded or unrounded view of SV stats on the measure SV menu
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
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

-- Lets you choose the menu step # for the frames setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseMenuStep(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Step # :")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(24)
    imgui.PushButtonRepeat(true)
    if imgui.ArrowButton("##leftMenuStep", imgui_dir.Left) then
        settingVars.menuStep = settingVars.menuStep - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    _, settingVars.menuStep = imgui.InputInt("##currentMenuStep", settingVars.menuStep, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightMenuStep", imgui_dir.Right) then
        settingVars.menuStep = settingVars.menuStep + 1
    end
    imgui.PopButtonRepeat()
    imgui.PopItemWidth()
    settingVars.menuStep = math.wrap(settingVars.menuStep, 1, 3)
end

-- Lets you choose the mspf (milliseconds per frame) for splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseMSPF(settingVars)
    local _, newMSPF = imgui.InputFloat("ms Per Frame", settingVars.msPerFrame, 0.5, 0.5, "%.1f")
    newMSPF = math.clamp(newMSPF, 4, 10000)
    settingVars.msPerFrame = newMSPF
    helpMarker("Number of milliseconds splitscroll will display a set of SVs before jumping to " ..
        "the next set of SVs")
end

-- Lets you choose to not normalize values
-- Returns whether or not the setting changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseNoNormalize(settingVars)
    addPadding()
    local oldChoice = settingVars.dontNormalize
    local _, newChoice = imgui.Checkbox("Don't normalize to average SV", oldChoice)
    settingVars.dontNormalize = newChoice
    return oldChoice ~= newChoice
end

-- Lets you choose the note skin type for the preview of the frames in the frame setup menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseNoteSkinType(settingVars)
    settingVars.noteSkinTypeIndex = combo("Preview skin", NOTE_SKIN_TYPES,
        settingVars.noteSkinTypeIndex)
    helpMarker("Note skin type for the preview of the frames")
end

-- Lets you choose the note spacing
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseNoteSpacing(menuVars)
    _, menuVars.noteSpacing = imgui.InputFloat("Note Spacing", menuVars.noteSpacing, 0, 0, "%.2fx")
end

-- Lets you choose the number of flickers
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseNumFlickers(menuVars)
    _, menuVars.numFlickers = imgui.InputInt("Flickers", menuVars.numFlickers, 1, 1)
    menuVars.numFlickers = math.clamp(menuVars.numFlickers, 1, 9999)
end

-- Lets you choose the number of frames
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseNumFrames(settingVars)
    _, settingVars.numFrames = imgui.InputInt("Total # Frames", settingVars.numFrames)
    settingVars.numFrames = math.clamp(settingVars.numFrames, 1, MAX_ANIMATION_FRAMES)
end

-- Lets you choose the number of periods for a sinusoidal wave
-- Returns whether or not the number of periods changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseNumPeriods(settingVars)
    local oldPeriods = settingVars.periods
    local _, newPeriods = imgui.InputFloat("Periods/Cycles", oldPeriods, 0.25, 0.25, "%.2f")
    newPeriods = math.quarter(newPeriods)
    newPeriods = math.clamp(newPeriods, 0.25, 69420)
    settingVars.periods = newPeriods
    return oldPeriods ~= newPeriods
end

-- Lets you choose the number of scrolls for advanced splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseNumScrolls(settingVars)
    _, settingVars.numScrolls = imgui.InputInt("# of scrolls", settingVars.numScrolls, 1, 1)
    settingVars.numScrolls = math.wrap(settingVars.numScrolls, 2, 4)
end

-- Lets you choose the number of periods to shift over for a sinusoidal wave
-- Returns whether or not the period shift value changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function choosePeriodShift(settingVars)
    local oldShift = settingVars.periodsShift
    local _, newShift = imgui.InputFloat("Phase Shift", oldShift, 0.25, 0.25, "%.2f")
    newShift = math.quarter(newShift)
    newShift = math.wrap(newShift, -0.75, 1)
    settingVars.periodsShift = newShift
    return oldShift ~= newShift
end

-- Lets you choose the place SV type
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function choosePlaceSVType(globalVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("  Type:  ")
    imgui.SameLine(0, SAMELINE_SPACING)
    globalVars.placeTypeIndex = combo("##placeType", CREATE_TYPES, globalVars.placeTypeIndex)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Still" then toolTip("Still keeps notes normal distance/spacing apart") end
end

-- Lets you choose the place SV type
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseCurrentScrollGroup(globalVars)
    function indexOf(tbl, var)
        for k, v in pairs(tbl) do
            if v == var then
                return k
            end
        end
        return nil
    end

    imgui.AlignTextToFramePadding()
    imgui.Text("  Timing Group: ")
    imgui.SameLine(0, SAMELINE_SPACING)
    local groups = { "$Default", "$Global" }
    local cols = { map.TimingGroups["$Default"].ColorRgb or "255,255,255", map.TimingGroups["$Global"].ColorRgb or
    "255,255,255" }
    for k, v in pairs(map.TimingGroups) do
        if string.find(k, "%$") then goto continue end
        if (globalVars.hideAutomatic and string.find(k, "automate_")) then goto continue end
        table.insert(groups, k)
        table.insert(cols, v.ColorRgb or "255,255,255")
        ::continue::
    end
    local prevIndex = globalVars.scrollGroupIndex
    imgui.PushItemWidth(155)
    globalVars.scrollGroupIndex = combo("##scrollGroup", groups, globalVars.scrollGroupIndex, cols)
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
        globalVars.scrollGroupIndex = indexOf(groups, state.SelectedScrollGroupId)
    end
end

-- Lets you choose the variability scale of randomness
-- Returns whether or not the variability value changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseRandomScale(settingVars)
    local oldScale = settingVars.randomScale
    local _, newScale = imgui.InputFloat("Random Scale", oldScale, 0, 0, "%.2fx")
    settingVars.randomScale = newScale
    return oldScale ~= newScale
end

-- Lets you choose the type of random generation
-- Returns whether or not the type of random generation changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseRandomType(settingVars)
    local oldIndex = settingVars.randomTypeIndex
    settingVars.randomTypeIndex = combo("Random Type", RANDOM_TYPES, settingVars.randomTypeIndex)
    return oldIndex ~= settingVars.randomTypeIndex
end

-- Lets you choose a ratio
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseRatio(menuVars)
    _, menuVars.ratio = imgui.InputFloat("Ratio", menuVars.ratio, 0, 0, "%.3f")
end

-- Lets you choose the length in seconds of one RGB color cycle
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseRGBPeriod(globalVars)
    local oldRGBPeriod = globalVars.rgbPeriod
    _, globalVars.rgbPeriod = imgui.InputFloat("RGB cycle length", oldRGBPeriod, 0, 0,
        "%.0f seconds")
    globalVars.rgbPeriod = math.clamp(globalVars.rgbPeriod, MIN_RGB_CYCLE_TIME,
        MAX_RGB_CYCLE_TIME)
    if (oldRGBPeriod ~= globalVars.rgbPeriod) then
        write(globalVars)
    end
end

-- Lets you choose the second height/displacement for splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseSecondHeight(settingVars)
    _, settingVars.height2 = imgui.InputFloat("2nd Height", settingVars.height2, 0, 0, "%.3f msx")
    helpMarker("Height at which notes are hit at on screen for the 2nd scroll speed")
end

-- Lets you choose the second scroll speed for splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseSecondScrollSpeed(settingVars)
    local text = "2nd Scroll Speed"
    _, settingVars.scrollSpeed2 = imgui.InputFloat(text, settingVars.scrollSpeed2, 0, 0, "%.2fx")
end

-- Lets you choose the spot to displace when adding scaling SVs
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseScaleDisplaceSpot(menuVars)
    menuVars.scaleSpotIndex = combo("Displace Spot", DISPLACE_SCALE_SPOTS, menuVars.scaleSpotIndex)
end

-- Lets you choose how to scale SVs
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseScaleType(menuVars)
    local label = "Scale Type"
    menuVars.scaleTypeIndex = combo(label, SCALE_TYPES, menuVars.scaleTypeIndex)

    local scaleType = SCALE_TYPES[menuVars.scaleTypeIndex]
    if scaleType == "Average SV" then chooseAverageSV(menuVars) end
    if scaleType == "Absolute Distance" then chooseDistance(menuVars) end
    if scaleType == "Relative Ratio" then chooseRatio(menuVars) end
end

-- Lets you choose a scroll to make changes to for advanced splitscroll
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseScrollIndex(settingVars)
    imgui.AlignTextToFramePadding()
    imgui.Text("Currently viewing scroll #:")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushItemWidth(35)
    if imgui.ArrowButton("##leftScrollIndex", imgui_dir.Left) then
        settingVars.scrollIndex = settingVars.scrollIndex - 1
    end
    imgui.SameLine(0, SAMELINE_SPACING)
    local inputText = "##currentScrollIndex"
    _, settingVars.scrollIndex = imgui.InputInt(inputText, settingVars.scrollIndex, 0, 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    if imgui.ArrowButton("##rightScrollIndex", imgui_dir.Right) then
        settingVars.scrollIndex = settingVars.scrollIndex + 1
    end
    helpMarker("Assign notes and SVs for every single scroll in order to place splitscroll SVs")
    settingVars.scrollIndex = math.wrap(settingVars.scrollIndex, 1, settingVars.numScrolls)
    imgui.PopItemWidth()
end

-- Lets you choose the "spring constant" for the snake
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseSnakeSpringConstant(globalVars)
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

-- Lets you choose the special SV type
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseSpecialSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #STANDARD_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = combo(label, SPECIAL_SVS, menuVars.svTypeIndex)
end

-- Lets you choose the special SV type
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function chooseVibratoSVType(menuVars)
    local emoticonIndex = menuVars.svTypeIndex + #VIBRATO_SVS
    local label = "  " .. EMOTICONS[emoticonIndex]
    menuVars.svTypeIndex = combo(label, VIBRATO_SVS, menuVars.svTypeIndex)
end

-- Lets you choose the current splitscroll layer
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseSplitscrollLayers(settingVars)
    local currentLayerNum = settingVars.scrollIndex
    local currentLayer = settingVars.splitscrollLayers[currentLayerNum]
    if currentLayer == nil then
        imgui.Text("0 SVs, 0 notes assigned")
        local buttonText = "Assign SVs and notes between\nselected notes to scroll " .. currentLayerNum
        if imgui.Button(buttonText, ACTION_BUTTON_SIZE) then
            local offsets = uniqueSelectedNoteOffsets()
            local startOffset = offsets[1]
            local endOffset = offsets[#offsets]
            local svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
            addStartSVIfMissing(svsBetweenOffsets, startOffset)
            local newNotes = {}
            for i, hitObject in pairs(state.SelectedHitObjects) do
                local newNote = utils.CreateHitObject(hitObject.StartTime, hitObject.Lane,
                    hitObject.EndTime, hitObject.HitSound,
                    hitObject.EditorLayer)
                table.insert(newNotes, newNote)
            end
            newNotes = table.sort(newNotes, sortAscendingStartTime)
            settingVars.splitscrollLayers[currentLayerNum] = {
                svs = svsBetweenOffsets,
                notes = newNotes
            }
            local svsToRemove = getSVsBetweenOffsets(startOffset, endOffset)
            local editorActions = {
                actionRemoveNotesBetween(startOffset, endOffset),
                utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove)
            }
            actions.PerformBatch(editorActions)
        end
    else
        local currentLayerSVs = currentLayer.svs
        local currentLayerNotes = currentLayer.notes
        imgui.Text(table.concat({ #currentLayerSVs, " SVs, ", #currentLayerNotes, " notes assigned" }))
        if imgui.Button("Clear assigned\nnotes and SVs", HALF_ACTION_BUTTON_SIZE) then
            settingVars.splitscrollLayers[currentLayerNum] = nil
        end
        imgui.SameLine(0, SAMELINE_SPACING)
        if imgui.Button("Re-place assigned\nnotes and SVs", HALF_ACTION_BUTTON_SIZE) then
            local svStartOffset = currentLayerSVs[1].StartTime
            local svEndOffset = currentLayerSVs[#currentLayerSVs].StartTime
            local svsToRemove = getSVsBetweenOffsets(svStartOffset, svEndOffset)
            local noteStartOffset = currentLayerNotes[1].StartTime
            local noteEndOffset = currentLayerNotes[#currentLayerNotes].StartTime
            local editorActions = {
                actionRemoveNotesBetween(noteStartOffset, noteEndOffset),
                utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
                utils.CreateEditorAction(action_type.AddScrollVelocityBatch, currentLayerSVs),
                utils.CreateEditorAction(action_type.PlaceHitObjectBatch, currentLayerNotes)
            }
            actions.PerformBatch(editorActions)
        end
    end
end

function actionRemoveNotesBetween(startOffset, endOffset)
    local notesToRemove = {}
    for _, hitObject in pairs(map.HitObjects) do
        if hitObject.StartTime >= startOffset and hitObject.StartTime <= endOffset then
            table.insert(notesToRemove, hitObject)
        end
    end
    return utils.CreateEditorAction(action_type.RemoveHitObjectBatch, notesToRemove)
end

-- Lets you choose the standard SV type
-- Returns whether or not the SV type changed [Boolean]
-- Parameters
--    menuVars     : list of variables used for the current menu [Table]
--    excludeCombo : whether or not to exclude the combo option from SV types [Boolean]
function chooseStandardSVType(menuVars, excludeCombo)
    local oldIndex = menuVars.svTypeIndex
    local label = " " .. EMOTICONS[oldIndex]
    local svTypeList = STANDARD_SVS
    if excludeCombo then svTypeList = STANDARD_SVS_NO_COMBO end
    menuVars.svTypeIndex = combo(label, svTypeList, menuVars.svTypeIndex)
    return oldIndex ~= menuVars.svTypeIndex
end

-- Lets you choose the standard SV types
-- Returns whether or not any of the SV types changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseStandardSVTypes(settingVars)
    local oldIndex1 = settingVars.svType1Index
    local oldIndex2 = settingVars.svType2Index
    settingVars.svType1Index = combo("SV Type 1", STANDARD_SVS_NO_COMBO, settingVars.svType1Index)
    settingVars.svType2Index = combo("SV Type 2", STANDARD_SVS_NO_COMBO, settingVars.svType2Index)
    return (oldIndex2 ~= settingVars.svType2Index) or (oldIndex1 ~= settingVars.svType1Index)
end

-- Lets you choose a start and an end SV
-- Returns whether or not the start or end SVs changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseStartEndSVs(settingVars)
    if settingVars.linearlyChange == false then
        local oldValue = settingVars.startSV
        local _, newValue = imgui.InputFloat("SV Value", oldValue, 0, 0, "%.2fx")
        settingVars.startSV = newValue
        return oldValue ~= newValue
    end
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 7, 4 })
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = { settingVars.startSV, settingVars.endSV }
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 6.5, 4 })
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2("Start/End SV", oldValues, "%.2fx")
    imgui.PopItemWidth()
    settingVars.startSV = newValues[1]
    settingVars.endSV = newValues[2]
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.startSV = oldValues[2]
        settingVars.endSV = oldValues[1]
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars.startSV = -oldValues[1]
        settingVars.endSV = -oldValues[2]
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end

-- Lets you choose a start SV percent
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
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

-- Lets you choose the still type
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
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

-- Lets you choose the duration of a stutter SV
-- Returns whether or not the duration changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
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

-- Lets you choose the number of stutters per section
-- Returns whether or not the number of stutters changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseStuttersPerSection(settingVars)
    local oldNumber = settingVars.stuttersPerSection
    local _, newNumber = imgui.InputInt("Stutters", oldNumber, 1, 1)
    helpMarker("Number of stutters per section")
    newNumber = math.clamp(newNumber, 1, 1000)
    settingVars.stuttersPerSection = newNumber
    return oldNumber ~= newNumber
end

-- Lets you choose the style theme of the plugin
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseStyleTheme(globalVars)
    local oldStyleTheme = globalVars.styleThemeIndex
    globalVars.styleThemeIndex = combo("Style Theme", STYLE_THEMES, oldStyleTheme)
    if (oldStyleTheme ~= globalVars.styleThemeIndex) then
        write(globalVars)
    end
end

-- Lets you choose the behavior of SVs
-- Returns whether or not the behavior changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseSVBehavior(settingVars)
    local swapButtonPressed = imgui.Button("Swap", SECONDARY_BUTTON_SIZE)
    toolTip("Switch between slow down/speed up")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local oldBehaviorIndex = settingVars.behaviorIndex
    settingVars.behaviorIndex = combo("Behavior", SV_BEHAVIORS, oldBehaviorIndex)
    imgui.PopItemWidth()
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars.behaviorIndex = oldBehaviorIndex == 1 and 2 or 1
    end
    return oldBehaviorIndex ~= settingVars.behaviorIndex
end

-- Lets you choose the number of SV points per quarter period of a sinusoidal wave
-- Returns whether or not the number of SV points changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseSVPerQuarterPeriod(settingVars)
    local oldPoints = settingVars.svsPerQuarterPeriod
    local _, newPoints = imgui.InputInt("SV Points##perQuarter", oldPoints, 1, 1)
    helpMarker("Number of SV points per 0.25 period/cycle")
    local maxSVsPerQuarterPeriod = MAX_SV_POINTS / (4 * settingVars.periods)
    newPoints = math.clamp(newPoints, 1, maxSVsPerQuarterPeriod)
    settingVars.svsPerQuarterPeriod = newPoints
    return oldPoints ~= newPoints
end

-- Lets you choose the number of SV points
-- Returns whether or not the number of SV points changed [Boolean]
-- Parameters
--    settingVars  : list of variables used for the current menu [Table]
--   svPointsForce : number of SV points to force [Int or nil]
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

-- Lets you choose whether or not the plugin will do things upscroll
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function chooseUpscroll(globalVars)
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

-- Lets you choose whether to use distance or not
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseUseDistance(settingVars)
    local label = "Use distance for start SV"
    _, settingVars.useDistance = imgui.Checkbox(label, settingVars.useDistance)
end

-- Lets you choose whether to use distance or not
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function chooseHand(settingVars)
    local label = "Add teleport before note"
    _, settingVars.teleportBeforeHand = imgui.Checkbox(label, settingVars.teleportBeforeHand)
end

function chooseDistanceMode(menuVars)
    local oldMode = menuVars.distanceMode
    menuVars.distanceMode = combo("Distance Type", DISTANCE_TYPES, menuVars.distanceMode)
    return oldMode ~= menuVars.distanceMode
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
    addSeparator()
    choosePulseCoefficient(globalVars)
    _, globalVars.useCustomPulseColor = imgui.Checkbox("Use Custom Color?", globalVars.useCustomPulseColor)
    if (globalVars.useCustomPulseColor) then
        imgui.SameLine()
        if (imgui.Button("Edit Color")) then
            globalVars.showColorPicker = true
        end
        choosePulseColor(globalVars)
    else
        globalVars.showColorPicker = false
    end
end

function chooseHotkeys(globalVars)
    local hotkeyList = table.duplicate(globalVars.hotkeyList or DEFAULT_HOTKEY_LIST)
    local awaitingIndex = state.GetValue("hotkey_awaitingIndex", 0)
    if not imgui.CollapsingHeader("Plugin Hotkey Settings") then return end
    for k, v in pairs(hotkeyList) do
        if imgui.Button(awaitingIndex == k and "Listening...##listening" or v .. "##" .. k) then
            if (awaitingIndex == k) then
                awaitingIndex = 0
            else
                awaitingIndex = k
            end
        end
        imgui.SameLine()
        imgui.SetCursorPosX(85)
        imgui.Text("// " .. HOTKEY_LABELS[k])
    end
    addSeparator()
    simpleActionMenu("Reset Hotkey Settings", 0, function()
        globalVars.hotkeyList = DEFAULT_HOTKEY_LIST
        write(globalVars)
        awaitingIndex = 0
    end, nil, nil, true, true)
    state.SetValue("hotkey_awaitingIndex", awaitingIndex)
    if (awaitingIndex == 0) then return end
    local prefixes, key = listenForAnyKeyPressed()
    if (key == -1) then return end
    hotkeyList[awaitingIndex] = table.concat(prefixes, "+") .. (truthy(prefixes) and "+" or "") .. keyNumToKey(key)
    awaitingIndex = 0
    globalVars.hotkeyList = hotkeyList
    GLOBAL_HOTKEY_LIST = hotkeyList
    write(globalVars)
    state.SetValue("hotkey_awaitingIndex", awaitingIndex)
end

function choosePulseCoefficient(globalVars)
    local oldCoefficient = globalVars.pulseCoefficient
    _, globalVars.pulseCoefficient = imgui.SliderFloat("Pulse Strength", oldCoefficient, 0, 1,
        math.round(globalVars.pulseCoefficient * 100) .. "%%")
    globalVars.pulseCoefficient = math.clamp(globalVars.pulseCoefficient, 0, 1)
    if (oldCoefficient ~= globalVars.pulseCoefficient) then
        write(globalVars)
    end
end

function choosePulseColor(globalVars)
    if (globalVars.showColorPicker) then
        _, opened = imgui.Begin("plumoguSV Pulse Color Picker", globalVars.showColorPicker,
            imgui_window_flags.AlwaysAutoResize)
        local oldColor = globalVars.pulseColor
        _, globalVars.pulseColor = imgui.ColorPicker4("Pulse Color", globalVars.pulseColor)
        if (oldColor ~= globalVars.pulseColor) then
            write(globalVars)
        end
        if (not opened) then
            globalVars.showColorPicker = false
            write(globalVars)
        end
        imgui.End()
    end
end

function computableInputFloat(label, var, decimalPlaces, suffix)
    local computableStateIndex = state.GetValue("computableInputFloatIndex") or 1

    _, var = imgui.InputText(label,
        string.format("%." .. decimalPlaces .. "f" .. suffix, tonumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+")) or 0),
        4096,
        imgui_input_text_flags.AutoSelectAll)
    if (not imgui.IsItemActive() and (state.GetValue("previouslyActiveImguiFloat" .. computableStateIndex) or false)) then
        local desiredComp = tostring(var):gsub("[ ]*msx[ ]*", "")
        var = expr(desiredComp)
    end
    state.SetValue("previouslyActiveImguiFloat" .. computableStateIndex, imgui.IsItemActive())
    state.SetValue("computableInputFloatIndex", computableStateIndex + 1)

    return tonumber(tostring(var):match("%d*[%-]?%d+[%.]?%d+"))
end

-- sum shit idk
-- Returns whether or not the start or end SVs changed [Boolean]
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function customSwappableNegatableInputFloat2(settingVars, lowerName, higherName, tag)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 7, 4 })
    local swapButtonPressed = imgui.Button("S", TERTIARY_BUTTON_SIZE)
    toolTip("Swap start/end SV values")
    local oldValues = { settingVars[lowerName], settingVars[higherName] }
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { 6.5, 4 })
    local negateButtonPressed = imgui.Button("N", TERTIARY_BUTTON_SIZE)
    toolTip("Negate start/end SV values")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.PushStyleVar(imgui_style_var.FramePadding, { PADDING_WIDTH, 5 })
    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH * 0.7 - SAMELINE_SPACING)
    local _, newValues = imgui.InputFloat2(tag, oldValues, "%.2fx")
    imgui.PopItemWidth()
    settingVars[lowerName] = newValues[1]
    settingVars[higherName] = newValues[2]
    if (swapButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3])) then
        settingVars[lowerName] = oldValues[2]
        settingVars[higherName] = oldValues[1]
    end
    if (negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4])) then
        settingVars[lowerName] = -oldValues[1]
        settingVars[higherName] = -oldValues[2]
    end
    return swapButtonPressed or negateButtonPressed or exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[3]) or
        exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[4]) or
        oldValues[1] ~= newValues[1] or oldValues[2] ~= newValues[2]
end
