function saveSettingPropertiesButton(globalVars, settingVars, label)
    local saveButtonClicked = imgui.Button("Save##setting" .. label)
    imgui.Separator()
    if (not saveButtonClicked) then return end
    label = label:sub(1, 1):lower() .. label:sub(2)
    if (not globalVars.defaultProperties) then globalVars.defaultProperties = {} end
    if (not globalVars.defaultProperties.settings) then globalVars.defaultProperties.settings = {} end
    globalVars.defaultProperties.settings[label] = settingVars
    loadDefaultProperties(globalVars.defaultProperties)
    saveAndSyncGlobals(globalVars)

    print("i!",
        "Default setting properties for " .. label .. " have been set. Changes will be shown on the next plugin refresh.")
end

function saveMenuPropertiesButton(globalVars, menuVars, label)
    local saveButtonClicked = imgui.Button("Save##menu" .. label)
    imgui.Separator()
    if (not saveButtonClicked) then return end
    label = label:sub(1, 1):lower() .. label:sub(2)
    if (not globalVars.defaultProperties) then globalVars.defaultProperties = {} end
    if (not globalVars.defaultProperties.menu) then globalVars.defaultProperties.menu = {} end
    globalVars.defaultProperties.menu[label] = menuVars
    loadDefaultProperties(globalVars.defaultProperties)
    saveAndSyncGlobals(globalVars)

    print("i!",
        "Default menu properties for " .. label .. " have been set. Changes will be shown on the next plugin refresh.")
end

function showDefaultPropertiesSettings(globalVars)
    imgui.SeparatorText("Menu Settings")

    imgui.SeparatorText("Standard/Still Settings")
    if (imgui.CollapsingHeader("Linear Settings")) then
        local settingVars = getSettingVars("Linear", "Property")

        chooseStartEndSVs(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Linear")
        saveVariables("LinearPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Exponential Settings")) then -- Exponential
        local settingVars = getSettingVars("Exponential", "Property")

        chooseSVBehavior(settingVars)
        chooseIntensity(settingVars)
        if (globalVars.advancedMode) then
            chooseDistanceMode(settingVars)
        end
        if (settingVars.distanceMode ~= 3) then
            chooseConstantShift(settingVars, 0)
        end
        if (settingVars.distanceMode == 1) then
            chooseAverageSV(settingVars)
        elseif (settingVars.distanceMode == 2) then
            chooseDistance(settingVars)
        else
            chooseStartEndSVs(settingVars)
        end
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Exponential")
        saveVariables("ExponentialPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Bezier Settings")) then -- Bezier
        local settingVars = getSettingVars("Bezier", "Property")

        provideBezierWebsiteLink(settingVars)
        chooseBezierPoints(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseAverageSV(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Bezier")
        saveVariables("BezierPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Hermite Settings")) then -- Hermite
        local settingVars = getSettingVars("Hermite", "Property")

        chooseStartEndSVs(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseAverageSV(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Hermite")
        saveVariables("HermitePropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Sinusoidal Settings")) then -- Sinusoidal
        local settingVars = getSettingVars("Sinusoidal", "Property")

        imgui.Text("Amplitude:")
        chooseStartEndSVs(settingVars)
        chooseCurveSharpness(settingVars)
        chooseConstantShift(settingVars, 1)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)
        chooseSVPerQuarterPeriod(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Sinusoidal")
        saveVariables("SinusoidalPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Circular Settings")) then -- Circular
        local settingVars = getSettingVars("Circular", "Property")

        chooseSVBehavior(settingVars)
        chooseArcPercent(settingVars)
        chooseAverageSV(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)
        chooseNoNormalize(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Circular")
        saveVariables("CircularPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Random Settings")) then -- Random
        local settingVars = getSettingVars("Random", "Property")

        chooseRandomType(settingVars)
        chooseRandomScale(settingVars)
        chooseSVPoints(settingVars)
        addSeparator()
        chooseConstantShift(settingVars, 0)
        if not settingVars.dontNormalize then
            chooseAverageSV(settingVars)
        end
        chooseFinalSV(settingVars)
        chooseNoNormalize(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Random")
        saveVariables("RandomPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Chinchilla Settings")) then -- Chinchilla
        local settingVars = getSettingVars("Chinchilla", "Property")

        chooseSVBehavior(settingVars)
        chooseChinchillaType(settingVars)
        chooseChinchillaIntensity(settingVars)
        chooseAverageSV(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Chinchilla")
        saveVariables("ChinchillaPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Code Settings")) then
        local settingVars = getSettingVars("Code", "Property")

        codeInput(settingVars, "code", "##code")
        imgui.Separator()
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "Code")
        saveVariables("CodePropertySettings", settingVars)
    end

    imgui.SeparatorText("Special Settings")

    if (imgui.CollapsingHeader("Stutter Settings")) then
        local settingVars = getSettingVars("Stutter", "Property")

        settingsChanged = chooseControlSecondSV(settingVars) or settingsChanged
        settingsChanged = chooseStartEndSVs(settingVars) or settingsChanged
        settingsChanged = chooseStutterDuration(settingVars) or settingsChanged
        settingsChanged = chooseLinearlyChange(settingVars) or settingsChanged

        addSeparator()
        settingsChanged = chooseStuttersPerSection(settingVars) or settingsChanged
        settingsChanged = chooseAverageSV(settingVars) or settingsChanged
        settingsChanged = chooseFinalSV(settingVars, false) or settingsChanged

        saveSettingPropertiesButton(globalVars, settingVars, "Stutter")
        saveVariables("StutterPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Teleport Stutter Settings")) then
        local settingVars = getSettingVars("TeleportStutter", "Property")

        if settingVars.useDistance then
            chooseDistance(settingVars)
            helpMarker("Start SV teleport distance")
        else
            chooseStartSVPercent(settingVars)
        end
        chooseMainSV(settingVars)
        chooseAverageSV(settingVars)
        chooseFinalSV(settingVars, false)
        chooseUseDistance(settingVars)
        chooseLinearlyChange(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "TeleportStutter")
        saveVariables("TeleportStutterPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Automate Settings")) then
        local settingVars = getSettingVars("Automate", "Property")

        settingVars.initialSV = negatableComputableInputFloat("Initial SV", settingVars.initialSV, 2, "x")
        _, settingVars.scaleSVs = imgui.Checkbox("Scale SVs?", settingVars.scaleSVs)
        imgui.SameLine(0, SAMELINE_SPACING)
        _, settingVars.optimizeTGs = imgui.Checkbox("Optimize TGs?", settingVars.optimizeTGs)
        _, settingVars.maintainMs = imgui.Checkbox("Static Time?", settingVars.maintainMs)
        if (settingVars.maintainMs) then
            imgui.SameLine(0, SAMELINE_SPACING)
            imgui.PushItemWidth(71)
            settingVars.ms = computableInputFloat("Time", settingVars.ms, 2, "ms")
            imgui.PopItemWidth()
        end

        saveSettingPropertiesButton(globalVars, settingVars, "Automate")
        saveVariables("AutomatePropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Penis Settings")) then
        local settingVars = getSettingVars("Penis", "Property")

        _, settingVars.bWidth = imgui.InputInt("Ball Width", math.floor(settingVars.bWidth))
        _, settingVars.sWidth = imgui.InputInt("Shaft Width", math.floor(settingVars.sWidth))

        _, settingVars.sCurvature = imgui.SliderInt("S Curvature", settingVars.sCurvature, 1, 100,
            settingVars.sCurvature .. "%%")
        _, settingVars.bCurvature = imgui.SliderInt("B Curvature", settingVars.bCurvature, 1, 100,
            settingVars.bCurvature .. "%%")

        saveSettingPropertiesButton(globalVars, settingVars, "Penis")
        saveVariables("PenisPropertySettings", settingVars)
    end

    imgui.SeparatorText("SV Vibrato Settings")

    if (imgui.CollapsingHeader("LinearVibratoSV Settings")) then
        local settingVars = getSettingVars("LinearVibratoSV", "Property")

        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)

        saveSettingPropertiesButton(globalVars, settingVars, "LinearVibratoSV")
        saveVariables("LinearVibratoSVPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("ExponentialVibratoSV Settings")) then
        local settingVars = getSettingVars("ExponentialVibratoSV", "Property")

        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseCurvatureCoefficient(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "ExponentialVibratoSV")
        saveVariables("ExponentialVibratoSVPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("SinusoidalVibratoSV Settings")) then
        local settingVars = getSettingVars("SinusoidalVibratoSV", "Property")

        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseMsxVerticalShift(settingVars, 0)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "SinusoidalVibratoSV")
        saveVariables("SinusoidalVibratoSVPropertySettings", settingVars)
    end

    imgui.SeparatorText("SSF Vibrato Settings")

    if (imgui.CollapsingHeader("LinearVibratoSSF Settings")) then
        local settingVars = getSettingVars("LinearVibratoSSF", "Property")

        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")

        saveSettingPropertiesButton(globalVars, settingVars, "LinearVibratoSSF")
        saveVariables("LinearVibratoSSFPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("ExponentialVibratoSSF Settings")) then
        local settingVars = getSettingVars("ExponentialVibratoSSF", "Property")

        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")
        chooseCurvatureCoefficient(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "ExponentialVibratoSSF")
        saveVariables("ExponentialVibratoSSFPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("SinusoidalVibratoSSF Settings")) then
        local settingVars = getSettingVars("SinusoidalVibratoSSF", "Property")

        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")
        chooseConstantShift(settingVars)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)

        saveSettingPropertiesButton(globalVars, settingVars, "SinusoidalVibratoSSF")
        saveVariables("SinusoidalVibratoSSFPropertySettings", settingVars)
    end
end
