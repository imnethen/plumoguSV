function saveSettingPropertiesButton(settingVars, label)
    local saveButtonClicked = imgui.Button("Save##setting" .. label)
    imgui.Separator()
    if (not saveButtonClicked) then return end
    label = label:charAt(1):lower() .. label:sub(2)
    if (not globalVars.defaultProperties) then globalVars.defaultProperties = {} end
    if (not globalVars.defaultProperties.settings) then globalVars.defaultProperties.settings = {} end
    globalVars.defaultProperties.settings[label] = settingVars
    loadDefaultProperties(globalVars.defaultProperties)
    write(globalVars)

    print("i!",
        "Default setting properties for " .. label .. " have been set. Changes will be shown on the next plugin refresh.")
end

function saveMenuPropertiesButton(menuVars, label)
    local saveButtonClicked = imgui.Button("Save##menu" .. label)
    imgui.Separator()
    if (not saveButtonClicked) then return end
    label = label:charAt(1):lower() .. label:sub(2)
    if (not globalVars.defaultProperties) then globalVars.defaultProperties = {} end
    if (not globalVars.defaultProperties.menu) then globalVars.defaultProperties.menu = {} end
    globalVars.defaultProperties.menu[label] = menuVars
    loadDefaultProperties(globalVars.defaultProperties)
    write(globalVars)

    print("i!",
        "Default menu properties for " .. label .. " have been set. Changes will be shown on the next plugin refresh.")
end

function showDefaultPropertiesSettings()
    imgui.SeparatorText("Create Tab Settings")

    if (imgui.CollapsingHeader("General Standard Settings")) then
        local menuVars = getMenuVars("placeStandard", "Property")

        chooseStandardSVType(menuVars, false)
        addSeparator()
        chooseInterlace(menuVars)

        saveMenuPropertiesButton(menuVars, "placeStandard")
        saveVariables("placeStandardPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("General Special Settings")) then
        local menuVars = getMenuVars("placeSpecial", "Property")

        chooseSpecialSVType(menuVars)

        saveMenuPropertiesButton(menuVars, "placeSpecial")
        saveVariables("placeSpecialPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("General Still Settings")) then
        local menuVars = getMenuVars("placeStill", "Property")

        chooseStandardSVType(menuVars, false)
        addSeparator()
        chooseNoteSpacing(menuVars)
        chooseStillBehavior(menuVars)
        chooseStillType(menuVars)
        chooseInterlace(menuVars)

        saveMenuPropertiesButton(menuVars, "placeStill")
        saveVariables("placeStillPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("General Vibrato Settings")) then
        local menuVars = getMenuVars("placeVibrato", "Property")

        chooseVibratoSVType(menuVars)
        addSeparator()
        imgui.Text("Vibrato Settings:")
        chooseVibratoMode(menuVars)
        chooseVibratoQuality(menuVars)
        if (menuVars.vibratoMode ~= 2) then
            chooseVibratoSides(menuVars)
        end

        saveMenuPropertiesButton(menuVars, "placeVibrato")
        saveVariables("placeVibratoPropertyMenu", menuVars)
    end

    imgui.SeparatorText("Edit Tab Settings")

    if (imgui.CollapsingHeader("Add Teleport Settings")) then
        local menuVars = getMenuVars("addTeleport", "Property")

        chooseDistance(menuVars)
        chooseHand(menuVars)

        saveMenuPropertiesButton(menuVars, "addTeleport")
        saveVariables("addTeleportPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Change Group Settings")) then
        local menuVars = getMenuVars("changeGroup", "Property")

        _, menuVars.changeSVs = imgui.Checkbox("Change SVs?", menuVars.changeSVs)
        keepSameLine()
        _, menuVars.changeSSFs = imgui.Checkbox("Change SSFs?", menuVars.changeSSFs)

        saveMenuPropertiesButton(menuVars, "changeGroup")
        saveVariables("changeGroupPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Convert SV <-> SSF Settings")) then
        local menuVars = getMenuVars("convertSVSSF", "Property")

        chooseConvertSVSSFDirection(menuVars)

        saveMenuPropertiesButton(menuVars, "convertSVSSF")
        saveVariables("convertSVSSFPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Copy Settings")) then
        local menuVars = getMenuVars("copy", "Property")

        _, menuVars.copyTable[1] = imgui.Checkbox("Copy Lines", menuVars.copyTable[1])
        keepSameLine()
        _, menuVars.copyTable[2] = imgui.Checkbox("Copy SVs", menuVars.copyTable[2])
        _, menuVars.copyTable[3] = imgui.Checkbox("Copy SSFs", menuVars.copyTable[3])
        imgui.SameLine(0, SAMELINE_SPACING + 3.5)
        _, menuVars.copyTable[4] = imgui.Checkbox("Copy Bookmarks", menuVars.copyTable[4])

        _, menuVars.tryAlign = imgui.Checkbox("Try to fix misalignments", menuVars.tryAlign)
        imgui.PushItemWidth(100)
        _, menuVars.alignWindow = imgui.SliderInt("Alignment window (ms)", menuVars.alignWindow, 1, 10)
        imgui.PopItemWidth()

        saveMenuPropertiesButton(menuVars, "copy")
        saveVariables("copyPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Displace Note Settings")) then
        local menuVars = getMenuVars("displaceNote", "Property")

        chooseVaryingDistance(menuVars)
        chooseLinearlyChangeDist(menuVars)

        saveMenuPropertiesButton(menuVars, "displaceNote")
        saveVariables("displaceNotePropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Displace View Settings")) then
        local menuVars = getMenuVars("displaceView", "Property")

        chooseDistance(menuVars)

        saveMenuPropertiesButton(menuVars, "displaceView")
        saveVariables("displaceViewPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Flicker Settings")) then
        local menuVars = getMenuVars("flicker", "Property")

        chooseFlickerType(menuVars)
        chooseVaryingDistance(menuVars)
        chooseLinearlyChangeDist(menuVars)
        chooseNumFlickers(menuVars)
        if (globalVars.advancedMode) then chooseFlickerPosition(menuVars) end

        saveMenuPropertiesButton(menuVars, "flicker")
        saveVariables("flickerPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Reverse Scroll Settings")) then
        local menuVars = getMenuVars("reverseScroll", "Property")

        chooseDistance(menuVars)
        helpMarker("Height at which reverse scroll notes are hit")

        saveMenuPropertiesButton(menuVars, "reverseScroll")
        saveVariables("reverseScrollPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Scale (Displace) Settings")) then
        local menuVars = getMenuVars("scaleDisplace", "Property")

        chooseScaleDisplaceSpot(menuVars)
        chooseScaleType(menuVars)

        saveMenuPropertiesButton(menuVars, "scaleDisplace")
        saveVariables("scaleDisplacePropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Scale (Multiply) Settings")) then
        local menuVars = getMenuVars("scaleMultiply", "Property")

        chooseScaleType(menuVars)

        saveMenuPropertiesButton(menuVars, "scaleMultiply")
        saveVariables("scaleMultiplyPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Vertical Shift Settings")) then
        local menuVars = getMenuVars("verticalShift", "Property")

        chooseConstantShift(menuVars, 0)

        saveMenuPropertiesButton(menuVars, "verticalShift")
        saveVariables("verticalShiftPropertyMenu", menuVars)
    end

    imgui.SeparatorText("Delete Tab Settings")

    if (imgui.CollapsingHeader("Delete Menu Settings")) then
        local menuVars = getMenuVars("delete", "Property")

        _, menuVars.deleteTable[1] = imgui.Checkbox("Delete Lines", menuVars.deleteTable[1])
        keepSameLine()
        _, menuVars.deleteTable[2] = imgui.Checkbox("Delete SVs", menuVars.deleteTable[2])
        _, menuVars.deleteTable[3] = imgui.Checkbox("Delete SSFs", menuVars.deleteTable[3])
        imgui.SameLine(0, SAMELINE_SPACING + 3.5)
        _, menuVars.deleteTable[4] = imgui.Checkbox("Delete Bookmarks", menuVars.deleteTable[4])

        saveMenuPropertiesButton(menuVars, "delete")
        saveVariables("deletePropertyMenu", menuVars)
    end

    imgui.SeparatorText("Select Tab Settings")

    if (imgui.CollapsingHeader("Select Alternating Settings")) then
        local menuVars = getMenuVars("selectAlternating", "Property")

        chooseEvery(menuVars)
        chooseOffset(menuVars)

        saveMenuPropertiesButton(menuVars, "selectAlternating")
        saveVariables("selectAlternatingPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Select By Snap Settings")) then
        local menuVars = getMenuVars("selectBySnap", "Property")

        chooseSnap(menuVars)

        saveMenuPropertiesButton(menuVars, "selectBySnap")
        saveVariables("selectBySnapPropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Select Chord Size Settings")) then
        local menuVars = getMenuVars("selectChordSize", "Property")

        _, menuVars.single = imgui.Checkbox("Select Singles", menuVars.single)
        keepSameLine()
        _, menuVars.jump = imgui.Checkbox("Select Jumps", menuVars.jump)
        _, menuVars.hand = imgui.Checkbox("Select Hands", menuVars.hand)
        keepSameLine()
        _, menuVars.quad = imgui.Checkbox("Select Quads", menuVars.quad)

        saveMenuPropertiesButton(menuVars, "selectChordSize")
        saveVariables("selectChordSizePropertyMenu", menuVars)
    end
    if (imgui.CollapsingHeader("Select Note Type Settings")) then
        local menuVars = getMenuVars("selectNoteType", "Property")

        _, menuVars.rice = imgui.Checkbox("Select Rice Notes", menuVars.rice)
        keepSameLine()
        _, menuVars.ln = imgui.Checkbox("Select LNs", menuVars.ln)

        saveMenuPropertiesButton(menuVars, "selectNoteType")
        saveVariables("selectNoteTypePropertyMenu", menuVars)
    end

    imgui.SeparatorText("Standard/Still Settings")

    if (imgui.CollapsingHeader("Linear Settings")) then
        local settingVars = getSettingVars("Linear", "Property")

        chooseStartEndSVs(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(settingVars, "Linear")
        saveVariables("LinearPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Exponential Settings")) then
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

        saveSettingPropertiesButton(settingVars, "Exponential")
        saveVariables("ExponentialPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Bezier Settings")) then
        local settingVars = getSettingVars("Bezier", "Property")

        provideBezierWebsiteLink(settingVars)
        chooseBezierPoints(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseAverageSV(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(settingVars, "Bezier")
        saveVariables("BezierPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Hermite Settings")) then
        local settingVars = getSettingVars("Hermite", "Property")

        chooseStartEndSVs(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseAverageSV(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(settingVars, "Hermite")
        saveVariables("HermitePropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Sinusoidal Settings")) then
        local settingVars = getSettingVars("Sinusoidal", "Property")

        imgui.Text("Amplitude:")
        chooseStartEndSVs(settingVars)
        chooseCurveSharpness(settingVars)
        chooseConstantShift(settingVars, 1)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)
        chooseSVPerQuarterPeriod(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(settingVars, "Sinusoidal")
        saveVariables("SinusoidalPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Circular Settings")) then
        local settingVars = getSettingVars("Circular", "Property")

        chooseSVBehavior(settingVars)
        chooseArcPercent(settingVars)
        chooseAverageSV(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)
        chooseNoNormalize(settingVars)

        saveSettingPropertiesButton(settingVars, "Circular")
        saveVariables("CircularPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Random Settings")) then
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

        saveSettingPropertiesButton(settingVars, "Random")
        saveVariables("RandomPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Chinchilla Settings")) then
        local settingVars = getSettingVars("Chinchilla", "Property")

        chooseSVBehavior(settingVars)
        chooseChinchillaType(settingVars)
        chooseChinchillaIntensity(settingVars)
        chooseAverageSV(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(settingVars, "Chinchilla")
        saveVariables("ChinchillaPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Code Settings")) then
        local settingVars = getSettingVars("Code", "Property")

        codeInput(settingVars, "code", "##code")
        imgui.Separator()
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingPropertiesButton(settingVars, "Code")
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

        saveSettingPropertiesButton(settingVars, "Stutter")
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

        saveSettingPropertiesButton(settingVars, "TeleportStutter")
        saveVariables("TeleportStutterPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Automate Settings")) then
        local settingVars = getSettingVars("Automate", "Property")

        settingVars.initialSV = negatableComputableInputFloat("Initial SV", settingVars.initialSV, 2, "x")
        _, settingVars.scaleSVs = imgui.Checkbox("Scale SVs?", settingVars.scaleSVs)
        keepSameLine()
        _, settingVars.optimizeTGs = imgui.Checkbox("Optimize TGs?", settingVars.optimizeTGs)
        _, settingVars.maintainMs = imgui.Checkbox("Static Time?", settingVars.maintainMs)
        if (settingVars.maintainMs) then
            keepSameLine()
            imgui.PushItemWidth(71)
            settingVars.ms = computableInputFloat("Time", settingVars.ms, 2, "ms")
            imgui.PopItemWidth()
        end

        saveSettingPropertiesButton(settingVars, "Automate")
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

        saveSettingPropertiesButton(settingVars, "Penis")
        saveVariables("PenisPropertySettings", settingVars)
    end

    imgui.SeparatorText("SV Vibrato Settings")

    if (imgui.CollapsingHeader("Linear Vibrato SV Settings")) then
        local settingVars = getSettingVars("LinearVibratoSV", "Property")

        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)

        saveSettingPropertiesButton(settingVars, "LinearVibratoSV")
        saveVariables("LinearVibratoSVPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Exponential Vibrato SV Settings")) then
        local settingVars = getSettingVars("ExponentialVibratoSV", "Property")

        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseCurvatureCoefficient(settingVars)

        saveSettingPropertiesButton(settingVars, "ExponentialVibratoSV")
        saveVariables("ExponentialVibratoSVPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Sinusoidal Vibrato SV Settings")) then
        local settingVars = getSettingVars("SinusoidalVibratoSV", "Property")

        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseMsxVerticalShift(settingVars, 0)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)

        saveSettingPropertiesButton(settingVars, "SinusoidalVibratoSV")
        saveVariables("SinusoidalVibratoSVPropertySettings", settingVars)
    end

    imgui.SeparatorText("SSF Vibrato Settings")

    if (imgui.CollapsingHeader("Linear Vibrato SSF Settings")) then
        local settingVars = getSettingVars("LinearVibratoSSF", "Property")

        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")

        saveSettingPropertiesButton(settingVars, "LinearVibratoSSF")
        saveVariables("LinearVibratoSSFPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Exponential Vibrato SSF Settings")) then
        local settingVars = getSettingVars("ExponentialVibratoSSF", "Property")

        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")
        chooseCurvatureCoefficient(settingVars)

        saveSettingPropertiesButton(settingVars, "ExponentialVibratoSSF")
        saveVariables("ExponentialVibratoSSFPropertySettings", settingVars)
    end
    if (imgui.CollapsingHeader("Sinusoidal Vibrato SSF Settings")) then
        local settingVars = getSettingVars("SinusoidalVibratoSSF", "Property")

        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")
        chooseConstantShift(settingVars)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)

        saveSettingPropertiesButton(settingVars, "SinusoidalVibratoSSF")
        saveVariables("SinusoidalVibratoSSFPropertySettings", settingVars)
    end
end
