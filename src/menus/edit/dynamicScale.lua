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
