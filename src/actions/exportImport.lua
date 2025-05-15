-- Creates the export button for Place SV settings
-- Parameters
--    globalVars  : list of variables used globally across all menus [Table]
--    menuVars    : list of setting variables for the current menu [Table]
--    settingVars : list of setting variables for the current sv type [Table]
function exportPlaceSVButton(globalVars, menuVars, settingVars)
    local buttonText = "Export current settings for current menu"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end

    local exportList = {}
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    local stillType = placeType == "Still"
    local regularType = placeType == "Standard" or stillType
    local specialType = placeType == "Special"
    local currentSVType
    if regularType then
        currentSVType = STANDARD_SVS[menuVars.svTypeIndex]
    elseif specialType then
        currentSVType = SPECIAL_SVS[menuVars.svTypeIndex]
    end
    exportList[1] = placeType
    exportList[2] = currentSVType
    if regularType then
        table.insert(exportList, tostring(menuVars.interlace))
        table.insert(exportList, menuVars.interlaceRatio)
    end
    if stillType then
        table.insert(exportList, menuVars.noteSpacing)
        table.insert(exportList, menuVars.stillTypeIndex)
        table.insert(exportList, menuVars.stillDistance)
    end
    if currentSVType == "Linear" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Exponential" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.intensity)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Bezier" then
        table.insert(exportList, settingVars.x1)
        table.insert(exportList, settingVars.y1)
        table.insert(exportList, settingVars.x2)
        table.insert(exportList, settingVars.y2)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Hermite" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Sinusoidal" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.curveSharpness)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.periods)
        table.insert(exportList, settingVars.periodsShift)
        table.insert(exportList, settingVars.svsPerQuarterPeriod)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Circular" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.arcPercent)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.dontNormalize))
    elseif currentSVType == "Random" then
        for i = 1, #settingVars.svMultipliers do
            table.insert(exportList, settingVars.svMultipliers[i])
        end
        table.insert(exportList, settingVars.randomTypeIndex)
        table.insert(exportList, settingVars.randomScale)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.dontNormalize))
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
    elseif currentSVType == "Custom" then
        for i = 1, #settingVars.svMultipliers do
            table.insert(exportList, settingVars.svMultipliers[i])
        end
        table.insert(exportList, settingVars.selectedMultiplierIndex)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Chinchilla" then
        table.insert(exportList, settingVars.behaviorIndex)
        table.insert(exportList, settingVars.chinchillaTypeIndex)
        table.insert(exportList, settingVars.chinchillaIntensity)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.verticalShift)
        table.insert(exportList, settingVars.svPoints)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Stutter" then
        table.insert(exportList, settingVars.startSV)
        table.insert(exportList, settingVars.endSV)
        table.insert(exportList, settingVars.stutterDuration)
        table.insert(exportList, settingVars.stuttersPerSection)
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
        table.insert(exportList, tostring(settingVars.linearlyChange))
        table.insert(exportList, tostring(settingVars.controlLastSV))
    elseif currentSVType == "Teleport Stutter" then
        table.insert(exportList, settingVars.svPercent)
        table.insert(exportList, settingVars.svPercent2)
        table.insert(exportList, settingVars.distance)
        table.insert(exportList, settingVars.mainSV)
        table.insert(exportList, settingVars.mainSV2)
        table.insert(exportList, tostring(settingVars.useDistance))
        table.insert(exportList, tostring(settingVars.linearlyChange))
        table.insert(exportList, settingVars.avgSV)
        table.insert(exportList, settingVars.finalSVIndex)
        table.insert(exportList, settingVars.customSV)
    elseif currentSVType == "Splitscroll (Adv v2)" then
        table.insert(exportList, settingVars.numScrolls)
        table.insert(exportList, settingVars.msPerFrame)
        table.insert(exportList, settingVars.scrollIndex)
        table.insert(exportList, settingVars.distanceBack)
        table.insert(exportList, settingVars.distanceBack2)
        table.insert(exportList, settingVars.distanceBack3)
        local splitscrollLayers = settingVars.splitscrollLayers
        local totalLayersSupported = 4
        for i = 1, totalLayersSupported do
            local currentLayer = settingVars.splitscrollLayers[i]
            if currentLayer ~= nil then
                local currentLayerSVs = currentLayer.svs
                local svsStringTable = {}
                for j = 1, #currentLayerSVs do
                    local currentSV = currentLayerSVs[j]
                    local svStringTable = {}
                    table.insert(svStringTable, currentSV.StartTime)
                    table.insert(svStringTable, currentSV.Multiplier)
                    local svString = table.concat(svStringTable, "+")
                    table.insert(svsStringTable, svString)
                end
                local svsString = table.concat(svsStringTable, " ")

                local currentLayerNotes = currentLayer.notes
                local notesStringTable = {}
                for j = 1, #currentLayerNotes do
                    local currentNote = currentLayerNotes[j]
                    local noteStringTable = {}
                    table.insert(noteStringTable, currentNote.StartTime)
                    table.insert(noteStringTable, currentNote.Lane)
                    -- could add other stuff like editor layer, but too much work
                    local noteString = table.concat(noteStringTable, "+")
                    table.insert(notesStringTable, noteString)
                end
                local notesString = table.concat(notesStringTable, " ")
                local layersDataTable = { i, svsString, notesString }
                local layersString = table.concat(layersDataTable, ":")
                table.insert(exportList, layersString)
            end
        end
    end
    globalVars.exportData = table.concat(exportList, "|")
end

-- Creates the export button for exporting as custom SVs
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    menuVars   : list of setting variables for the current menu [Table]
function exportCustomSVButton(globalVars, menuVars)
    local buttonText = "Export current SVs as custom SV data"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end

    local multipliersCopy = table.duplicate(menuVars.svMultipliers)
    table.remove(multipliersCopy)
    globalVars.exportCustomSVData = table.concat(multipliersCopy, " ")
end

-- Creates the import button for Place SV settings
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function importPlaceSVButton(globalVars)
    local buttonText = "Import settings from pasted data"
    if not imgui.Button(buttonText, ACTION_BUTTON_SIZE) then return end

    -- Variant of code based on
    -- https://stackoverflow.com/questions/6075262/
    --    lua-table-tostringtablename-and-table-fromstringstringtable-functions
    local settingsTable = {}
    for str in string.gmatch(globalVars.importData, "([^|]+)") do
        local num = tonumber(str)
        if num ~= nil then
            table.insert(settingsTable, num)
        elseif str == "false" then
            table.insert(settingsTable, false)
        elseif str == "true" then
            table.insert(settingsTable, true)
        else
            table.insert(settingsTable, str)
        end
    end
    if #settingsTable < 2 then return end

    local placeType         = table.remove(settingsTable, 1)
    local currentSVType     = table.remove(settingsTable, 1)

    local standardPlaceType = placeType == "Standard"
    local specialPlaceType  = placeType == "Special"
    local stillPlaceType    = placeType == "Still"

    local menuVars

    print(currentSVType)


    if standardPlaceType then menuVars = getStandardPlaceMenuVars() end
    if specialPlaceType then menuVars = getSpecialPlaceMenuVars() end
    if stillPlaceType then menuVars = getStillPlaceMenuVars() end

    local linearSVType      = currentSVType == "Linear"
    local exponentialSVType = currentSVType == "Exponential"
    local bezierSVType      = currentSVType == "Bezier"
    local hermiteSVType     = currentSVType == "Hermite"
    local sinusoidalSVType  = currentSVType == "Sinusoidal"
    local circularSVType    = currentSVType == "Circular"
    local randomSVType      = currentSVType == "Random"
    local customSVType      = currentSVType == "Custom"
    local chinchillaSVType  = currentSVType == "Chinchilla"
    local stutterSVType     = currentSVType == "Stutter"
    local tpStutterSVType   = currentSVType == "Teleport Stutter"
    local advSplitV2SVType  = currentSVType == "Splitscroll (Adv v2)"

    local settingVars
    if standardPlaceType then
        settingVars = getSettingVars(currentSVType, "Standard")
    elseif stillPlaceType then
        settingVars = getSettingVars(currentSVType, "Still")
    else
        settingVars = getSettingVars(currentSVType, "Special")
    end

    if standardPlaceType then globalVars.placeTypeIndex = 1 end
    if specialPlaceType then globalVars.placeTypeIndex = 2 end
    if stillPlaceType then globalVars.placeTypeIndex = 3 end

    if linearSVType then menuVars.svTypeIndex = 1 end
    if exponentialSVType then menuVars.svTypeIndex = 2 end
    if bezierSVType then menuVars.svTypeIndex = 3 end
    if hermiteSVType then menuVars.svTypeIndex = 4 end
    if sinusoidalSVType then menuVars.svTypeIndex = 5 end
    if circularSVType then menuVars.svTypeIndex = 6 end
    if randomSVType then menuVars.svTypeIndex = 7 end
    if customSVType then menuVars.svTypeIndex = 8 end
    if chinchillaSVType then menuVars.svTypeIndex = 9 end

    if stutterSVType then menuVars.svTypeIndex = 1 end
    if tpStutterSVType then menuVars.svTypeIndex = 2 end
    if advSplitV2SVType then menuVars.svTypeIndex = 5 end

    if standardPlaceType or stillPlaceType then
        menuVars.interlace = table.remove(settingsTable, 1)
        menuVars.interlaceRatio = table.remove(settingsTable, 1)
    end
    if stillPlaceType then
        menuVars.noteSpacing = table.remove(settingsTable, 1)
        menuVars.stillTypeIndex = table.remove(settingsTable, 1)
        menuVars.stillDistance = table.remove(settingsTable, 1)
    end
    if linearSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif exponentialSVType then
        settingVars.intensity = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif bezierSVType then
        settingVars.x1 = table.remove(settingsTable, 1)
        settingVars.y1 = table.remove(settingsTable, 1)
        settingVars.x2 = table.remove(settingsTable, 1)
        settingVars.y2 = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif hermiteSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif sinusoidalSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.curveSharpness = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.periods = table.remove(settingsTable, 1)
        settingVars.periodsShift = table.remove(settingsTable, 1)
        settingVars.svsPerQuarterPeriod = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif circularSVType then
        settingVars.behaviorIndex = table.remove(settingsTable, 1)
        settingVars.arcPercent = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
        settingVars.dontNormalize = table.remove(settingsTable, 1)
    elseif randomSVType then
        settingVars.verticalShift = table.remove(settingsTable)
        settingVars.avgSV = table.remove(settingsTable)
        settingVars.dontNormalize = table.remove(settingsTable)
        settingVars.customSV = table.remove(settingsTable)
        settingVars.finalSVIndex = table.remove(settingsTable)
        settingVars.svPoints = table.remove(settingsTable)
        settingVars.randomScale = table.remove(settingsTable)
        settingVars.randomTypeIndex = table.remove(settingsTable)
        settingVars.svMultipliers = settingsTable
    elseif customSVType then
        settingVars.customSV = table.remove(settingsTable)
        settingVars.finalSVIndex = table.remove(settingsTable)
        settingVars.svPoints = table.remove(settingsTable)
        settingVars.selectedMultiplierIndex = table.remove(settingsTable)
        settingVars.svMultipliers = settingsTable
    elseif chinchillaSVType then
        settingVars.behaviorIndex = table.remove(settingsTable, 1)
        settingVars.chinchillaTypeIndex = table.remove(settingsTable, 1)
        settingVars.chinchillaIntensity = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.verticalShift = table.remove(settingsTable, 1)
        settingVars.svPoints = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    end

    if stutterSVType then
        settingVars.startSV = table.remove(settingsTable, 1)
        settingVars.endSV = table.remove(settingsTable, 1)
        settingVars.stutterDuration = table.remove(settingsTable, 1)
        settingVars.stuttersPerSection = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
        settingVars.linearlyChange = table.remove(settingsTable, 1)
        settingVars.controlLastSV = table.remove(settingsTable, 1)
    elseif tpStutterSVType then
        settingVars.svPercent = table.remove(settingsTable, 1)
        settingVars.svPercent2 = table.remove(settingsTable, 1)
        settingVars.distance = table.remove(settingsTable, 1)
        settingVars.mainSV = table.remove(settingsTable, 1)
        settingVars.mainSV2 = table.remove(settingsTable, 1)
        settingVars.useDistance = table.remove(settingsTable, 1)
        settingVars.linearlyChange = table.remove(settingsTable, 1)
        settingVars.avgSV = table.remove(settingsTable, 1)
        settingVars.finalSVIndex = table.remove(settingsTable, 1)
        settingVars.customSV = table.remove(settingsTable, 1)
    elseif advSplitV2SVType then
        settingVars.numScrolls = table.remove(settingsTable, 1)
        settingVars.msPerFrame = table.remove(settingsTable, 1)
        settingVars.scrollIndex = table.remove(settingsTable, 1)
        settingVars.distanceBack = table.remove(settingsTable, 1)
        settingVars.distanceBack2 = table.remove(settingsTable, 1)
        settingVars.distanceBack3 = table.remove(settingsTable, 1)
        settingVars.splitscrollLayers = {}
        while #settingsTable > 0 do
            local splitscrollLayerString = table.remove(settingsTable)
            local layerDataStringTable = {}
            for str in string.gmatch(splitscrollLayerString, "([^:]+)") do
                table.insert(layerDataStringTable, str)
            end
            local layerNumber = tonumber(layerDataStringTable[1])
            local layerSVs = {}
            local svDataString = layerDataStringTable[2]
            for str in string.gmatch(svDataString, "([^%s]+)") do
                local svDataTable = {}
                for svData in string.gmatch(str, "([^%+]+)") do
                    table.insert(svDataTable, tonumber(svData))
                end
                local svStartTime = svDataTable[1]
                local svMultiplier = svDataTable[2]
                addSVToList(layerSVs, svStartTime, svMultiplier, true)
            end
            local layerNotes = {}
            local noteDataString = layerDataStringTable[3]
            for str in string.gmatch(noteDataString, "([^%s]+)") do
                local noteDataTable = {}
                for noteData in string.gmatch(str, "([^%+]+)") do
                    table.insert(noteDataTable, tonumber(noteData))
                end
                local noteStartTime = noteDataTable[1]
                local noteLane = noteDataTable[2]
                table.insert(layerNotes, utils.CreateHitObject(noteStartTime, noteLane))
            end
            settingVars.splitscrollLayers[layerNumber] = {
                svs = layerSVs,
                notes = layerNotes
            }
        end
    end
    if standardPlaceType then
        updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false)
        local labelText = table.concat({ currentSVType, "SettingsStandard" })
        saveVariables(labelText, settingVars)
    elseif stillPlaceType then
        updateMenuSVs(currentSVType, globalVars, menuVars, settingVars, false)
        local labelText = table.concat({ currentSVType, "SettingsStill" })
        saveVariables(labelText, settingVars)
    elseif stutterSVType then
        updateStutterMenuSVs(settingVars)
        local labelText = table.concat({ currentSVType, "SettingsSpecial" })
        saveVariables(labelText, settingVars)
    else
        local labelText = table.concat({ currentSVType, "SettingsSpecial" })
        saveVariables(labelText, settingVars)
    end

    if standardPlaceType then saveVariables("placeStandardMenu", menuVars) end
    if specialPlaceType then saveVariables("placeSpecialMenu", menuVars) end
    if stillPlaceType then saveVariables("placeStillMenu", menuVars) end

    globalVars.importData = ""
    globalVars.showExportImportMenu = false
end
