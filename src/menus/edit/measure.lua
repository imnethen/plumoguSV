
-- Creates the measure menu
function measureMenu()
    local menuVars = {
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
