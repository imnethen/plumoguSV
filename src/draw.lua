DEFAULT_HOTKEY_LIST = { "T", "Shift+T", "S", "N", "R", "B", "M", "V", "G" }
GLOBAL_HOTKEY_LIST = DEFAULT_HOTKEY_LIST
HOTKEY_LABELS = { "Execute Primary Action", "Execute Secondary Action", "Swap Primary Inputs",
    "Negate Primary Inputs", "Reset Secondary Input", "Go To Previous Scroll Group", "Go To Next Scroll Group",
    "Execute Vibrato Separately", "Use TG of Selected Note" }

imgui_disable_vector_packing = true

function draw()
    state.SetValue("computableInputFloatIndex", 1)

    local prevVal = state.GetValue("prevVal", 0)
    local colStatus = state.GetValue("colStatus", 0)

    local globalVars = loadGlobalVars()

    getVariables("globalVars", globalVars)

    drawCapybara(globalVars)
    drawCapybara2(globalVars)
    drawCapybara312(globalVars)
    drawCursorTrail(globalVars)
    setPluginAppearance(globalVars)
    startNextWindowNotCollapsed("plumoguSVAutoOpen")

    imgui.Begin("plumoguSV-dev", imgui_window_flags.AlwaysAutoResize)

    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    imgui.BeginTabBar("SV tabs")
    for i = 1, #TAB_MENUS do
        createMenuTab(globalVars, TAB_MENUS[i])
    end
    imgui.EndTabBar()
    state.IsWindowHovered = imgui.IsWindowHovered()

    if (globalVars.showVibratoWidget) then
        imgui.Begin("plumoguSV-Vibrato", imgui_window_flags.AlwaysAutoResize)
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
        placeVibratoSVMenu(globalVars, true)
        imgui.End()
    end
    if (globalVars.showNoteDataWidget) then
        if #state.SelectedHitObjects ~= 1 then goto noteDataContinue end

        imgui.BeginTooltip()
        imgui.Text("Note Info:")
        local selectedNote = state.SelectedHitObjects[1]
        imgui.Text(table.concat({ "StartTime = ", selectedNote.StartTime, " ms" }))
        local noteIsNotLN = selectedNote.EndTime == 0
        if noteIsNotLN then
            imgui.EndTooltip()
            goto noteDataContinue
        end

        local lnLength = selectedNote.EndTime - selectedNote.StartTime
        imgui.Text(table.concat({ "EndTime = ", selectedNote.EndTime, " ms" }))
        imgui.Text(table.concat({ "LN Length = ", lnLength, " ms" }))
        imgui.EndTooltip()
    end
    ::noteDataContinue::
    if (globalVars.showMeasureDataWidget) then
        if #state.SelectedHitObjects < 2 then goto measureDataContinue end
        local offsets = uniqueSelectedNoteOffsets()
        if (not truthy(offsets)) then goto measureDataContinue end
        local startOffset = offsets[1]
        local endOffset = offsets[#offsets]
        if (endOffset == startOffset) then goto measureDataContinue end
        if (endOffset ~= state.GetValue("oldEndOffset", -69) or startOffset ~= state.GetValue("oldStartOffset", -69) or #offsets ~= state.GetValue("oldOffsetCount", -1)) then
            svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
            addStartSVIfMissing(svsBetweenOffsets, startOffset)
            totalDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset, endOffset)
            roundedSVDistance = math.round(totalDistance, 3)
            avgSV = totalDistance / (endOffset - startOffset)
            roundedAvgSV = math.round(avgSV, 3)
            state.SetValue("tooltip_roundedSVDistance", roundedSVDistance)
            state.SetValue("tooltip_roundedAvgSV", roundedAvgSV)
        else
            roundedSVDistance = state.GetValue("tooltip_roundedSVDistance", 0)
            roundedAvgSV = state.GetValue("tooltip_roundedAvgSV", 0)
        end

        imgui.BeginTooltip()
        imgui.Text("Measure Info:")
        imgui.Text(table.concat({ "Distance = ", roundedSVDistance, " msx" }))
        imgui.Text(table.concat({ "Avg SV = ", roundedAvgSV, "x" }))
        imgui.EndTooltip()
        state.SetValue("oldStartOffset", startOffset)
        state.SetValue("oldEndOffset", endOffset)
        state.SetValue("oldOffsetCount", #offsets)
    end
    ::measureDataContinue::

    if (exclusiveKeyPressed("Ctrl+H")) then
        -- crash the game
        ---@diagnostic disable-next-line: param-type-mismatch
        imgui.Text(nil)
    end

    imgui.End()

    saveVariables("globalVars", globalVars)

    local timeOffset = 50 -- [`state.SongTime`](lua://state.SongTime) isn't entirely accurate while the song is playing, so this aims to correct that.

    local timeSinceLastPulse = ((state.SongTime + timeOffset) - getTimingPointAt(state.SongTime).StartTime) %
        ((60000 / getTimingPointAt(state.SongTime).Bpm))

    if ((timeSinceLastPulse < prevVal)) then
        colStatus = 1
    else
        colStatus = (colStatus - state.DeltaTime / (60000 / getTimingPointAt(state.SongTime).Bpm))
    end

    local futureTime = state.SongTime + state.DeltaTime * 2 + timeOffset

    if ((futureTime - getTimingPointAt(futureTime).StartTime) < 0) then
        colStatus = 0
    end

    state.SetValue("colStatus", math.max(colStatus, 0))
    state.SetValue("prevVal", timeSinceLastPulse)

    colStatus = colStatus * (globalVars.pulseCoefficient or 0)

    local borderColor = state.GetValue("global_baseBorderColor") or vector4(1)
    local negatedBorderColor = vector4(1) - borderColor

    local pulseColor = globalVars.useCustomPulseColor and globalVars.pulseColor or negatedBorderColor

    imgui.PushStyleColor(imgui_col.Border, pulseColor * colStatus + borderColor * (1 - colStatus))

    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[9])) then
        if (#state.SelectedHitObjects > 1) then return end
        state.SelectedScrollGroupId = state.SelectedHitObjects[1].TimingGroup
    end
end
