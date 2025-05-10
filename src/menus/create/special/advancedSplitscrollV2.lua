-- Creates the 2nd version menu for advanced splitscroll SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function splitScrollAdvancedV2Menu(settingVars)
    chooseNumScrolls(settingVars)
    chooseMSPF(settingVars)

    addSeparator()
    chooseScrollIndex(settingVars)

    addSeparator()
    if settingVars.scrollIndex == 2 then
        chooseDistanceBack(settingVars)
    elseif settingVars.scrollIndex == 3 then
        chooseDistanceBack2(settingVars)
    elseif settingVars.scrollIndex == 4 then
        chooseDistanceBack3(settingVars)
    end
    if settingVars.scrollIndex ~= 1 then addSeparator() end

    chooseSplitscrollLayers(settingVars)
    if settingVars.splitscrollLayers[1] == nil then return end
    if settingVars.splitscrollLayers[2] == nil then return end
    if settingVars.numScrolls > 2 and settingVars.splitscrollLayers[3] == nil then return end
    if settingVars.numScrolls > 3 and settingVars.splitscrollLayers[4] == nil then return end

    addSeparator()
    local label = "Place Splitscroll SVs"
    simpleActionMenu(label, 0, placeAdvancedSplitScrollSVsV2, nil, settingVars)
end
