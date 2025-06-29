-- Creates the measure menu
function measureMenu()
    local menuVars = { -- TODO: CONVERT TO STATE
        unrounded = false,
        nsvDistance = "",
        svDistance = "",
        avgSV = "",
        startDisplacement = "",
        endDisplacement = "",
        avgSVDisplaceless = "",
        roundedNSVDistance = 0,
        roundedSVDistance = 0,
        roundedAvgSV = 0,
        roundedStartDisplacement = 0,
        roundedEndDisplacement = 0,
        roundedAvgSVDisplaceless = 0
    }
    getVariables("measureMenu", menuVars)
    chooseMeasuredStatsView(menuVars)

    addSeparator()
    if menuVars.unrounded then
        displayMeasuredStatsUnrounded(menuVars)
    else
        displayMeasuredStatsRounded(menuVars)
    end
    addPadding()
    imgui.TextDisabled("*** Measuring disclaimer ***")
    toolTip("Measured values might not be 100%% accurate & may not work on older maps")

    addSeparator()
    simpleActionMenu("Measure SVs between selected notes", 2, measureSVs, nil, menuVars)
    saveVariables("measureMenu", menuVars)
end

-- Displays measured SV stats rounded
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function displayMeasuredStatsRounded(menuVars)
    imgui.Columns(2, "Measured SV Stats", false)
    imgui.Text("NSV distance:")
    imgui.Text("SV distance:")
    imgui.Text("Average SV:")
    imgui.Text("Start displacement:")
    imgui.Text("End displacement:")
    imgui.Text("True average SV:")
    imgui.NextColumn()
    imgui.Text(table.concat({ menuVars.roundedNSVDistance, " msx" }))
    helpMarker("The normal distance between the start and the end, ignoring SVs")
    imgui.Text(table.concat({ menuVars.roundedSVDistance, " msx" }))
    helpMarker("The actual distance between the start and the end, calculated with SVs")
    imgui.Text(table.concat({ menuVars.roundedAvgSV, "x" }))
    imgui.Text(table.concat({ menuVars.roundedStartDisplacement, " msx" }))
    helpMarker("Calculated using plumoguSV displacement metrics, so might not always work")
    imgui.Text(table.concat({ menuVars.roundedEndDisplacement, " msx" }))
    helpMarker("Calculated using plumoguSV displacement metrics, so might not always work")
    imgui.Text(table.concat({ menuVars.roundedAvgSVDisplaceless, "x" }))
    helpMarker("Average SV calculated ignoring the start and end displacement")
    imgui.Columns(1)
end

-- Displays measured SV stats unrounded
-- Parameters
--    menuVars : list of variables used for the current menu [Table]
function displayMeasuredStatsUnrounded(menuVars)
    copiableBox("NSV distance", "##nsvDistance", menuVars.nsvDistance)
    copiableBox("SV distance", "##svDistance", menuVars.svDistance)
    copiableBox("Average SV", "##avgSV", menuVars.avgSV)
    copiableBox("Start displacement", "##startDisplacement", menuVars.startDisplacement)
    copiableBox("End displacement", "##endDisplacement", menuVars.endDisplacement)
    copiableBox("True average SV", "##avgSVDisplaceless", menuVars.avgSVDisplaceless)
end
