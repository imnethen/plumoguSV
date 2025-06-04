---Gets the current menu's setting variables.
---@param svType string The SV type - that is, the shape of the SV once plotted.
---@param label string A delineator to separate two categories with similar SV types (Standard/Still, etc).
---@return table
function getSettingVars(svType, label)
    local settingVars
    if svType == "Linear" then
        settingVars = {
            startSV = 1.5,
            endSV = 0.5,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Linear##Vibrato" and label == "Vibrato1" then
        settingVars = {
            startMsx = 100,
            endMsx = 0
        }
    elseif svType == "Exponential##Vibrato" and label == "Vibrato1" then
        settingVars = {
            startMsx = 100,
            endMsx = 0,
            curvatureIndex = 5
        }
    elseif svType == "Sinusoidal##Vibrato" and label == "Vibrato1" then
        settingVars = {
            startMsx = 100,
            endMsx = 0,
            verticalShift = 0,
            periods = 1,
            periodsShift = 0.25
        }
    elseif svType == "Custom##Vibrato" and label == "Vibrato1" then
        settingVars = {
            code = [[return function (x)
    local maxHeight = 150

    heightFactor = maxHeight * math.exp((1 - math.sqrt(17)) / 2) / (31 - 7 * math.sqrt(17)) * 16
    primaryCoefficient = (x^2 - x^3) * math.exp(2 * x)
    sinusoidalCoefficient = math.sin(8 * math.pi * x)
    return heightFactor * primaryCoefficient * sinusoidalCoefficient
end]]
        }
    elseif svType == "Linear##Vibrato" and label == "Vibrato2" then
        settingVars = {
            lowerStart = 0.5,
            lowerEnd = 0.5,
            higherStart = 1,
            higherEnd = 1,
        }
    elseif svType == "Exponential##Vibrato" and label == "Vibrato2" then
        settingVars = {
            lowerStart = 0.5,
            lowerEnd = 0.5,
            higherStart = 1,
            higherEnd = 1,
            curvatureIndex = 10
        }
    elseif svType == "Sinusoidal##Vibrato" and label == "Vibrato2" then
        settingVars = {
            lowerStart = 0.5,
            lowerEnd = 0.5,
            higherStart = 1,
            higherEnd = 1,
            verticalShift = 0,
            periods = 1,
            periodsShift = 0.25
        }
    elseif svType == "Exponential" then
        settingVars = {
            behaviorIndex = 1,
            intensity = 30,
            verticalShift = 0,
            distance = 100,
            startSV = 0.01,
            endSV = 1,
            avgSV = 1,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1,
            distanceMode = 1
        }
    elseif svType == "Bezier" then
        settingVars = {
            x1 = 0,
            y1 = 0,
            x2 = 0,
            y2 = 1,
            verticalShift = 0,
            avgSV = 1,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Hermite" then
        settingVars = {
            startSV = 0,
            endSV = 0,
            verticalShift = 0,
            avgSV = 1,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Sinusoidal" then
        settingVars = {
            startSV = 2,
            endSV = 2,
            curveSharpness = 50,
            verticalShift = 1,
            periods = 1,
            periodsShift = 0.25,
            svsPerQuarterPeriod = 8,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Circular" then
        settingVars = {
            behaviorIndex = 1,
            arcPercent = 50,
            avgSV = 1,
            verticalShift = 0,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1,
            dontNormalize = false
        }
    elseif svType == "Random" then
        settingVars = {
            svMultipliers = {},
            randomTypeIndex = 1,
            randomScale = 2,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1,
            dontNormalize = false,
            avgSV = 1,
            verticalShift = 0
        }
    elseif svType == "Custom" then
        settingVars = {
            svMultipliers = { 0 },
            selectedMultiplierIndex = 1,
            svPoints = 1,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Chinchilla" then
        settingVars = {
            behaviorIndex = 1,
            chinchillaTypeIndex = 1,
            chinchillaIntensity = 0.5,
            avgSV = 1,
            verticalShift = 0,
            svPoints = 16,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Combo" then
        settingVars = {
            svType1Index = 1,
            svType2Index = 2,
            comboPhase = 0,
            comboTypeIndex = 1,
            comboMultiplier1 = 1,
            comboMultiplier2 = 1,
            finalSVIndex = 2,
            customSV = 1,
            dontNormalize = false,
            avgSV = 1,
            verticalShift = 0
        }
    elseif svType == "Code" then
        settingVars = {
            code = [[return function (x)
    local startPeriod = 4
    local endPeriod = -1
    local height = 1.5

    return height * math.sin(2 * math.pi * (startPeriod * x + (endPeriod - startPeriod) / 2 * x^2))
end]],
            svPoints = 64,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Stutter" then
        settingVars = {
            startSV = 1.5,
            endSV = 0.5,
            stutterDuration = 50,
            stuttersPerSection = 1,
            avgSV = 1,
            finalSVIndex = 2,
            customSV = 1,
            linearlyChange = false,
            controlLastSV = false,
            svMultipliers = {},
            svDistances = {},
            svGraphStats = createSVGraphStats(),
            svMultipliers2 = {},
            svDistances2 = {},
            svGraph2Stats = createSVGraphStats()
        }
    elseif svType == "Teleport Stutter" then
        settingVars = {
            svPercent = 50,
            svPercent2 = 0,
            distance = 50,
            mainSV = 0.5,
            mainSV2 = 0,
            useDistance = false,
            linearlyChange = false,
            avgSV = 1,
            finalSVIndex = 2,
            customSV = 1
        }
    elseif svType == "Splitscroll (Basic)" then
        settingVars = {
            scrollSpeed1 = 0.9,
            height1 = 0,
            scrollSpeed2 = -0.9,
            height2 = 400,
            distanceBack = 1000000,
            msPerFrame = 16,
            noteTimes2 = {},
        }
    elseif svType == "Splitscroll (Advanced)" then
        settingVars = {
            numScrolls = 2,
            msPerFrame = 16,
            scrollIndex = 1,
            distanceBack = 1000000,
            distanceBack2 = 1000000,
            distanceBack3 = 1000000,
            noteTimes2 = {},
            noteTimes3 = {},
            noteTimes4 = {},
            svsInScroll1 = {},
            svsInScroll2 = {},
            svsInScroll3 = {},
            svsInScroll4 = {}
        }
    elseif svType == "Splitscroll (Adv v2)" then
        settingVars = {
            numScrolls = 2,
            msPerFrame = 16,
            scrollIndex = 1,
            distanceBack = 1000000,
            distanceBack2 = 1000000,
            distanceBack3 = 1000000,
            splitscrollLayers = {}
        }
    elseif svType == "Frames Setup" then
        settingVars = {
            menuStep = 1,
            numFrames = 5,
            frameDistance = 2000,
            distance = 2000,
            reverseFrameOrder = false,
            noteSkinTypeIndex = 1,
            frameTimes = {},
            selectedTimeIndex = 1,
            currentFrame = 1
        }
    elseif svType == "Penis" then
        settingVars = {
            bWidth = 50,
            sWidth = 100,
            sCurvature = 100,
            bCurvature = 100
        }
    elseif svType == "Automate" then
        settingVars = {
            copiedSVs = {},
            maintainMs = true,
            ms = 1000
        }
    end
    local labelText = table.concat({ svType, "Settings", label })
    getVariables(labelText, settingVars)
    return settingVars
end
