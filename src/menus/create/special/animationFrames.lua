function animationFramesSetupMenu(settingVars)
    chooseMenuStep(settingVars)
    if settingVars.menuStep == 1 then
        KeepSameLine()
        imgui.Text("Choose Frame Settings")
        AddSeparator()
        BasicInputInt(settingVars, "numFrames", "Total # Frames", { 1, MAX_ANIMATION_FRAMES })
        chooseFrameSpacing(settingVars)
        chooseDistance(settingVars)
        HelpMarker("Initial separating distance from selected note to the first frame")
        BasicCheckbox(settingVars, "reverseFrameOrder", "Reverse frame order when placing SVs")
        AddSeparator()
        chooseNoteSkinType(settingVars)
    elseif settingVars.menuStep == 2 then
        KeepSameLine()
        imgui.Text("Adjust Notes/Frames")
        AddSeparator()
        imgui.Columns(2, "Notes and Frames", false)
        addFrameTimes(settingVars)
        displayFrameTimes(settingVars)
        removeSelectedFrameTimeButton(settingVars)
        AddPadding()
        chooseFrameTimeData(settingVars)
        imgui.NextColumn()
        chooseCurrentFrame(settingVars)
        drawCurrentFrame(settingVars)
        imgui.Columns(1)
        local invisibleButtonSize = { 2 * (ACTION_BUTTON_SIZE.x + 1.5 * SAMELINE_SPACING), 1 }
        imgui.InvisibleButton("sv isnt a real skill", invisibleButtonSize)
    else
        KeepSameLine()
        imgui.Text("Place SVs")
        AddSeparator()
        if #settingVars.frameTimes == 0 then
            imgui.Text("No notes added in Step 2, so can't place SVs yet")
            return
        end
        HelpMarker("This tool displaces notes into frames after the (first) selected note")
        HelpMarker("Works with pre-existing SVs or no SVs in the map")
        HelpMarker("This is technically an edit SV tool, but it replaces the old animate function")
        HelpMarker("Make sure to prepare an empty area for the frames after the note you select")
        HelpMarker("Note: frame positions and viewing them will break if SV distances change")
        AddSeparator()
        local label = "Setup frames after selected note"
        simpleActionMenu(label, 1, displaceNotesForAnimationFrames, settingVars)
    end
end

function removeSelectedFrameTimeButton(settingVars)
    if #settingVars.frameTimes == 0 then return end
    if not imgui.Button("Removed currently selected time", BEEG_BUTTON_SIZE) then return end
    table.remove(settingVars.frameTimes, settingVars.selectedTimeIndex)
    local maxIndex = math.max(1, #settingVars.frameTimes)
    settingVars.selectedTimeIndex = math.clamp(settingVars.selectedTimeIndex, 1, maxIndex)
end
