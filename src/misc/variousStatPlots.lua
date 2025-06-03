-- Updates stats for the current menu's SVs
-- Parameters
--    svGraphStats         : list of stats for the SV graphs [Table]
--    svStats              : list of stats for the current menu's SVs [Table]
--    svMultipliers        : list of sv multipliers [Table]
--    svMultipliersNoEndSV : list of sv multipliers, no end multiplier [Table]
--    svDistances          : list of distances calculated from SV multipliers [Table]
function updateSVStats(svGraphStats, svStats, svMultipliers, svMultipliersNoEndSV, svDistances)
    updateGraphStats(svGraphStats, svMultipliers, svDistances)
    svStats.minSV = math.round(calculateMinValue(svMultipliersNoEndSV), 2)
    svStats.maxSV = math.round(calculateMaxValue(svMultipliersNoEndSV), 2)
    svStats.avgSV = math.round(table.average(svMultipliersNoEndSV, true), 3)
end

-- Updates scale stats for SV graphs
-- Parameters
--    graphStats : list of graph scale numbers [Table]
--    svMultipliers : list of SV multipliers[Table]
--    svDistances : list of SV distances [Table]
function updateGraphStats(graphStats, svMultipliers, svDistances)
    graphStats.minScale, graphStats.maxScale = calculatePlotScale(svMultipliers)
    graphStats.distMinScale, graphStats.distMaxScale = calculatePlotScale(svDistances)
end

-- Creates a new window with plots/graphs and stats of the current menu's SVs
-- Parameters
--    windowText      : name of the window [String]
--    svGraphStats    : stats of the SV graphs [Table]
--    svStats         : stats of the SV multipliers [Table]
--    svDistances     : distance vs time list [Table]
--    svMultipliers   : multiplier values of the SVs [Table]
--    stutterDuration : percent duration of first stutter (nil if not stutter SV) [Int]
--    skipDistGraph   : whether or not to skip showing the distance graph [Boolean]
function makeSVInfoWindow(windowText, svGraphStats, svStats, svDistances, svMultipliers,
                          stutterDuration, skipDistGraph)
    if (state.GetValue("global_hideSVInfo") == true) then return end
    imgui.Begin(windowText, imgui_window_flags.AlwaysAutoResize)
    if not skipDistGraph then
        imgui.Text("Projected Note Motion:")
        helpMarker("Distance vs Time graph of notes")
        plotSVMotion(svDistances, svGraphStats.distMinScale, svGraphStats.distMaxScale)
        if imgui.CollapsingHeader("New All -w-") then
            for i = 1, #svDistances do
                local svDistance = svDistances[i]
                local content = tostring(svDistance)
                imgui.PushItemWidth(imgui.GetContentRegionAvailWidth())
                imgui.InputText("##" .. i, content, #content, imgui_input_text_flags.AutoSelectAll)
                imgui.PopItemWidth()
            end
        end
    end
    local projectedText = "Projected SVs:"
    if skipDistGraph then projectedText = "Projected Scaling (Avg SVs):" end
    imgui.Text(projectedText)
    plotSVs(svMultipliers, svGraphStats.minScale, svGraphStats.maxScale)
    if stutterDuration then
        displayStutterSVStats(svMultipliers, stutterDuration)
    else
        displaySVStats(svStats)
    end
    imgui.End()
end

-- Displays stats for stutter SVs
-- Parameters
--    svMultipliers   : stutter multipliers [Table]
--    stutterDuration : duration of the stutter (out of 100) [Int]
function displayStutterSVStats(svMultipliers, stutterDuration)
    local firstSV = math.round(svMultipliers[1], 3)
    local secondSV = math.round(svMultipliers[2], 3)
    local firstDuration = stutterDuration
    local secondDuration = 100 - stutterDuration
    imgui.Columns(2, "SV Stutter Stats", false)
    imgui.Text("First SV:")
    imgui.Text("Second SV:")
    imgui.NextColumn()
    local firstText = table.concat({ firstSV, "x  (", firstDuration, "%% duration)" })
    local secondText = table.concat({ secondSV, "x  (", secondDuration, "%% duration)" })
    imgui.Text(firstText)
    imgui.Text(secondText)
    imgui.Columns(1)
end

-- Displays stats for the current menu's SVs
-- Parameters
--    svStats : list of stats for the current menu [Table]
function displaySVStats(svStats)
    imgui.Columns(2, "SV Stats", false)
    imgui.Text("Max SV:")
    imgui.Text("Min SV:")
    imgui.Text("Average SV:")
    imgui.NextColumn()
    imgui.Text(svStats.maxSV .. "x")
    imgui.Text(svStats.minSV .. "x")
    imgui.Text(svStats.avgSV .. "x")
    helpMarker("Rounded to 3 decimal places")
    imgui.Columns(1)
end

-- Makes the next plugin window not collapsed on startup
-- Parameters
--    windowName : key name for the next plugin window that opens [String]
function startNextWindowNotCollapsed(windowName)
    if state.GetValue(windowName) then return end
    imgui.SetNextWindowCollapsed(false)
    state.SetValue(windowName, true)
end

-- Makes the SV info windows for stutter SV
-- Parameters
--    settingVars : list of variables used for the current menu [Table]
function displayStutterSVWindows(settingVars)
    if settingVars.linearlyChange then
        startNextWindowNotCollapsed("svInfo2AutoOpen")
        makeSVInfoWindow("SV Info (Starting first SV)", settingVars.svGraphStats, nil,
            settingVars.svDistances, settingVars.svMultipliers,
            settingVars.stutterDuration, false)
        startNextWindowNotCollapsed("svInfo3AutoOpen")
        makeSVInfoWindow("SV Info (Ending first SV)", settingVars.svGraph2Stats, nil,
            settingVars.svDistances2, settingVars.svMultipliers2,
            settingVars.stutterDuration, false)
    else
        startNextWindowNotCollapsed("svInfo1AutoOpen")
        makeSVInfoWindow("SV Info", settingVars.svGraphStats, nil, settingVars.svDistances,
            settingVars.svMultipliers, settingVars.stutterDuration, false)
    end
end
