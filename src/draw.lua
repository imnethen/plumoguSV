imgui_disable_vector_packing = true

function draw()
    state.SetValue("computableInputFloatIndex", 1)
    state.IsWindowHovered = imgui.IsWindowHovered()

    drawCapybara()
    drawCapybara2()
    drawCapybara312()
    drawCursorTrail()
    setPluginAppearance()

    startNextWindowNotCollapsed("plumoguSVAutoOpen")
    imgui.Begin("plumoguSV-dev", imgui_window_flags.AlwaysAutoResize)

    renderBackground()

    imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
    imgui.BeginTabBar("SV tabs")
    for i = 1, #TAB_MENUS do
        createMenuTab(TAB_MENUS[i])
    end
    imgui.EndTabBar()

    if (globalVars.showVibratoWidget) then
        imgui.Begin("plumoguSV-Vibrato", imgui_window_flags.AlwaysAutoResize)
        imgui.PushItemWidth(DEFAULT_WIDGET_WIDTH)
        placeVibratoSVMenu(true)
        imgui.End()
    end
    if (globalVars.showNoteDataWidget) then
        renderNoteDataWidget()
    end
    if (globalVars.showMeasureDataWidget) then
        renderMeasureDataWidget()
    end

    imgui.End()

    pulseController()

    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[9])) then
        local tgId = state.SelectedHitObjects[1].TimingGroup
        for _, ho in pairs(state.SelectedHitObjects) do
            if (ho.TimingGroup ~= tgId) then return end
        end
        state.SelectedScrollGroupId = tgId
    end
end

function renderNoteDataWidget()
    if (#state.SelectedHitObjects ~= 1) then return end
    imgui.BeginTooltip()
    imgui.Text("Note Info:")
    local selectedNote = state.SelectedHitObjects[1]
    imgui.Text("StartTime = " .. selectedNote.StartTime .. " ms")
    local noteIsNotLN = selectedNote.EndTime == 0
    if noteIsNotLN then
        imgui.EndTooltip()
        return
    end

    local lnLength = selectedNote.EndTime - selectedNote.StartTime
    imgui.Text("EndTime = " .. selectedNote.EndTime .. " ms")
    imgui.Text("LN Length = " .. lnLength .. " ms")
    imgui.EndTooltip()
end

function renderMeasureDataWidget()
    if #state.SelectedHitObjects < 2 then return end
    local uniqueDict = {}
    for _, ho in pairs(state.SelectedHitObjects) do -- uniqueSelectedNoteOffsets was not used here because this approach exits the function faster
        if (not table.contains(uniqueDict, ho.StartTime)) then
            table.insert(uniqueDict, ho.StartTime)
        end
        if (#uniqueDict > 2) then return end
    end
    uniqueDict = table.sort(uniqueDict, sortAscending) ---@cast uniqueDict number[]
    local startOffset = uniqueDict[1]
    local endOffset = uniqueDict[2] or uniqueDict[1]
    if (endOffset == startOffset) then return end
    if (endOffset ~= state.GetValue("oldEndOffset", -69) or startOffset ~= state.GetValue("oldStartOffset", -69)) then
        svsBetweenOffsets = getSVsBetweenOffsets(startOffset, endOffset)
        nsvDistance = endOffset - startOffset
        addStartSVIfMissing(svsBetweenOffsets, startOffset)
        totalDistance = calculateDisplacementFromSVs(svsBetweenOffsets, startOffset, endOffset)
        roundedSVDistance = math.round(totalDistance, 3)
        avgSV = totalDistance / (endOffset - startOffset)
        roundedAvgSV = math.round(avgSV, 3)
        state.SetValue("tooltip_nsvDistance", nsvDistance)
        state.SetValue("tooltip_roundedSVDistance", roundedSVDistance)
        state.SetValue("tooltip_roundedAvgSV", roundedAvgSV)
    else
        nsvDistance = state.GetValue("tooltip_nsvDistance", 0)
        roundedSVDistance = state.GetValue("tooltip_roundedSVDistance", 0)
        roundedAvgSV = state.GetValue("tooltip_roundedAvgSV", 0)
    end

    imgui.BeginTooltip()
    imgui.Text("Measure Info:")
    imgui.Text("NSV Distance = " .. nsvDistance .. " ms")
    imgui.Text("SV Distance = " .. roundedSVDistance .. " msx")
    imgui.Text("Avg SV = " .. roundedAvgSV .. "x")
    imgui.EndTooltip()
    state.SetValue("oldStartOffset", startOffset)
    state.SetValue("oldEndOffset", endOffset)
end

function pulseController()
    local prevVal = state.GetValue("prevVal", 0)
    local colStatus = state.GetValue("colStatus", 0)

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

    local borderColor = state.GetValue("baseBorderColor") or vector4(1)
    local negatedBorderColor = vector4(1) - borderColor

    local pulseColor = globalVars.useCustomPulseColor and globalVars.pulseColor or negatedBorderColor

    imgui.PushStyleColor(imgui_col.Border, pulseColor * colStatus + borderColor * (1 - colStatus))
end
