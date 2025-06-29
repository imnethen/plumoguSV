function updateDirectEdit()
    local offsets = uniqueSelectedNoteOffsets()
    if (not truthy(offsets)) then return end
    local firstOffset = offsets[1]
    local lastOffset = offsets[#offsets]

    if (#offsets < 2) then
        state.SetValue("directSVList", {})
        return
    end

    local svs = getSVsBetweenOffsets(firstOffset, lastOffset)

    state.SetValue("directSVList", svs)
end

function directSVMenu()
    local menuVars = { -- TODO: CONVERT TO STATE
        selectableIndex = 1,
        startTime = 0,
        multiplier = 0,
        pageNumber = 1
    }

    getVariables("directSVMenu", menuVars)
    local clockTime = 0.2
    if ((state.UnixTime or 0) - (state.GetValue("lastRecordedTime") or 0) >= clockTime) then
        state.SetValue("lastRecordedTime", state.UnixTime or 0)
        updateDirectEdit()
    end
    local svs = state.GetValue("directSVList") or {}
    if (#svs == 0) then
        menuVars.selectableIndex = 1
        imgui.TextWrapped("Select two notes to view SVs.")
        return
    end

    if (menuVars.selectableIndex > #svs) then menuVars.selectableIndex = #svs end

    local oldStartTime = svs[menuVars.selectableIndex].StartTime
    local oldMultiplier = svs[menuVars.selectableIndex].Multiplier
    local primeStartTime = state.GetValue("primeStartTime") or false
    local primeMultiplier = state.GetValue("primeMultiplier") or false

    _, menuVars.startTime = imgui.InputFloat("Start Time", oldStartTime)
    _, menuVars.multiplier = imgui.InputFloat("Multiplier", oldMultiplier)

    if (oldStartTime ~= menuVars.startTime) then
        primeStartTime = true
    else
        if (not primeStartTime) then goto continue1 end
        primeStartTime = false
        local newSV = utils.CreateScrollVelocity(state.GetValue("savedStartTime") or 0, menuVars.multiplier)
        actions.PerformBatch({ utils.CreateEditorAction(action_type.RemoveScrollVelocity, svs[menuVars.selectableIndex]),
            utils.CreateEditorAction(action_type.AddScrollVelocity, newSV) })
    end

    ::continue1::

    if (oldMultiplier ~= menuVars.multiplier) then
        primeMultiplier = true
    else
        if (not primeMultiplier) then goto continue2 end
        primeMultiplier = false
        local newSV = utils.CreateScrollVelocity(menuVars.startTime, state.GetValue("savedMultiplier") or 1)
        actions.PerformBatch({ utils.CreateEditorAction(action_type.RemoveScrollVelocity, svs[menuVars.selectableIndex]),
            utils.CreateEditorAction(action_type.AddScrollVelocity, newSV) })
    end

    ::continue2::

    state.SetValue("primeStartTime", primeStartTime)
    state.SetValue("primeMultiplier", primeMultiplier)
    state.SetValue("savedStartTime", menuVars.startTime)
    state.SetValue("savedMultiplier", menuVars.multiplier)
    imgui.Separator()

    if (imgui.Button("<##DirectSV")) then
        menuVars.pageNumber = math.clamp(menuVars.pageNumber - 1, 1, math.ceil(#svs / 10))
    end

    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.Text("Page ")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.SetNextItemWidth(100)
    _, menuVars.pageNumber = imgui.InputInt("##PageNum", math.clamp(menuVars.pageNumber, 1, math.ceil(#svs / 10)), 0)
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.Text(" of " .. math.ceil(#svs / 10))
    imgui.SameLine(0, SAMELINE_SPACING)
    if (imgui.Button(">##DirectSV")) then
        menuVars.pageNumber = math.clamp(menuVars.pageNumber + 1, 1, math.ceil(#svs / 10))
    end


    imgui.Separator()
    imgui.Text("Start Time")
    imgui.SameLine(0, SAMELINE_SPACING)
    imgui.SetCursorPosX(150)
    imgui.Text("Multiplier")
    imgui.Separator()

    imgui.BeginTable("Test", 2)
    for idx, v in pairs({ table.unpack(svs, 1 + 10 * (menuVars.pageNumber - 1), 10 * menuVars.pageNumber) }) do
        imgui.PushID(idx)
        imgui.TableNextRow()
        imgui.TableSetColumnIndex(0)
        imgui.Selectable(tostring(math.round(v.StartTime, 2)), menuVars.selectableIndex == idx,
            imgui_selectable_flags.SpanAllColumns)
        if (imgui.IsItemClicked()) then
            menuVars.selectableIndex = idx
        end
        imgui.TableSetColumnIndex(1)
        imgui.SetCursorPosX(150)
        imgui.Text(tostring(math.round(v.Multiplier, 2)));
        imgui.PopID()
    end

    imgui.EndTable()

    saveVariables("directSVMenu", menuVars)
end
