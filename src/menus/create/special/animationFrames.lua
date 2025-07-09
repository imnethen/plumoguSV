-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    settingVars : list of variables used for the current menu [Table]
function animationFramesSetupMenu(settingVars)
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
        drawCurrentFrame(settingVars)
        imgui.Columns(1)
        local invisibleButtonSize = { 2 * (ACTION_BUTTON_SIZE.x + 1.5 * SAMELINE_SPACING), 1 }
        imgui.InvisibleButton("sv isnt a real skill", invisibleButtonSize)
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
        simpleActionMenu(label, 1, displaceNotesForAnimationFrames, settingVars)
    end
end
