-- Places advanced splitscroll SVs from the 2nd version of the menu
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function placeAdvancedSplitScrollSVsV2(settingVars)
    local splitscrollLayers = settingVars.splitscrollLayers
    local convertedSettingVars = {
        numScrolls = settingVars.numScrolls,
        msPerFrame = settingVars.msPerFrame,
        scrollIndex = settingVars.scrollIndex,
        distanceBack = settingVars.distanceBack,
        distanceBack2 = settingVars.distanceBack2,
        distanceBack3 = settingVars.distanceBack3,
        noteTimes2 = {},
        noteTimes3 = {},
        noteTimes4 = {},
        svsInScroll1 = {},
        svsInScroll2 = {},
        svsInScroll3 = {},
        svsInScroll4 = {}
    }
    local allLayerNotes = {}
    if splitscrollLayers[1] ~= nil then
        local layerNotes = splitscrollLayers[1].notes
        convertedSettingVars.svsInScroll1 = splitscrollLayers[1].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
        end
    end
    if splitscrollLayers[2] ~= nil then
        local layerNotes = splitscrollLayers[2].notes
        convertedSettingVars.svsInScroll2 = splitscrollLayers[2].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
            table.insert(convertedSettingVars.noteTimes2, layerNotes[i].StartTime)
        end
        convertedSettingVars.noteTimes2 = table.dedupe(convertedSettingVars.noteTimes2)
        convertedSettingVars.noteTimes2 = sort(convertedSettingVars.noteTimes2, sortAscending)
    end
    if splitscrollLayers[3] ~= nil then
        local layerNotes = splitscrollLayers[3].notes
        convertedSettingVars.svsInScroll3 = splitscrollLayers[3].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
            table.insert(convertedSettingVars.noteTimes3, layerNotes[i].StartTime)
        end
        convertedSettingVars.noteTimes3 = table.dedupe(convertedSettingVars.noteTimes3)
        convertedSettingVars.noteTimes3 = sort(convertedSettingVars.noteTimes3, sortAscending)
    end
    if splitscrollLayers[4] ~= nil then
        local layerNotes = splitscrollLayers[4].notes
        convertedSettingVars.noteTimes4 = layerNotes
        convertedSettingVars.svsInScroll4 = splitscrollLayers[4].svs
        for i = 1, #layerNotes do
            table.insert(allLayerNotes, layerNotes[i])
            table.insert(convertedSettingVars.noteTimes4, layerNotes[i].StartTime)
        end
        convertedSettingVars.noteTimes4 = table.dedupe(convertedSettingVars.noteTimes4)
        convertedSettingVars.noteTimes4 = sort(convertedSettingVars.noteTimes4, sortAscending)
    end
    allLayerNotes = sort(allLayerNotes, sortAscendingStartTime)
    local startOffset = allLayerNotes[1].StartTime
    local endOffset = allLayerNotes[#allLayerNotes].StartTime
    local hasAddedLaneTime = {}
    for i = 1, map.GetKeyCount() do
        table.insert(hasAddedLaneTime, {})
    end
    local notesToPlace = {}
    local allNoteTimes = {}
    for i = 1, #allLayerNotes do
        local note = allLayerNotes[i]
        local lane = note.Lane
        local startTime = note.startTime
        if hasAddedLaneTime[lane][startTime] == nil then
            table.insert(notesToPlace, note)
            table.insert(allNoteTimes, startTime)
            hasAddedLaneTime[lane][startTime] = true
        end
    end
    allNoteTimes = table.dedupe(allNoteTimes)
    allNoteTimes = sort(allNoteTimes, sortAscending)
    local editorActions = {
        actionRemoveNotesBetween(startOffset, endOffset),
        utils.CreateEditorAction(action_type.PlaceHitObjectBatch, notesToPlace)
    }
    actions.PerformBatch(editorActions)
    actions.SetHitObjectSelection(notesToPlace)
    placeAdvancedSplitScrollSVsActual(convertedSettingVars, allNoteTimes)
end
