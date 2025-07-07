function saveSettingsButton(globalVars, settingVars, label)
    imgui.SameLine(0, SAMELINE_SPACING)
    if (not imgui.Button("Save")) then return end
    label = label:sub(1, 1):lower() .. label:sub(2)
    globalVars.defaultProperties[label] = settingVars
    loadDefaultProperties(globalVars.defaultProperties)
    saveAndSyncGlobals(globalVars)
end

function showDefaultPropertiesSettings(globalVars)
    do -- Linear, do/end pair to restrict local variables
        local settingVars = getSettingVars("Linear", "Settings")

        chooseStartEndSVs(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Linear")
    end
    do -- Exponential
        local settingVars = getSettingVars("Exponential", "Settings")

        chooseSVBehavior(settingVars)
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

        saveSettingsButton(globalVars, settingVars, "Exponential")
    end
    do -- Bezier
        local settingVars = getSettingVars("Bezier", "Settings")

        provideBezierWebsiteLink(settingVars)
        chooseBezierPoints(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseAverageSV(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Bezier")
    end
    do -- Hermite
        local settingVars = getSettingVars("Hermite", "Settings")

        chooseStartEndSVs(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseAverageSV(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Hermite")
    end
    do -- Sinusoidal
        local settingVars = getSettingVars("Sinusoidal", "Settings")

        imgui.Text("Amplitude:")
        chooseStartEndSVs(settingVars)
        chooseCurveSharpness(settingVars)
        chooseConstantShift(settingVars, 1)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)
        chooseSVPerQuarterPeriod(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Sinusoidal")
    end
    do -- Circular
        local settingVars = getSettingVars("Circular", "Settings")

        chooseSVBehavior(settingVars)
        chooseArcPercent(settingVars)
        chooseAverageSV(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)
        chooseNoNormalize(settingVars)

        saveSettingsButton(globalVars, settingVars, "Circular")
    end
    do -- Random
        local settingVars = getSettingVars("Random", "Settings")

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

        saveSettingsButton(globalVars, settingVars, "Random")
    end
    do -- Custom
        local settingVars = getSettingVars("Custom", "Settings")

        importCustomSVs(settingVars)
        chooseCustomMultipliers(settingVars)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Custom")
    end
    do -- Chinchilla
        local settingVars = getSettingVars("Chinchilla", "Settings")

        chooseSVBehavior(settingVars)
        chooseChinchillaType(settingVars)
        chooseChinchillaIntensity(settingVars)
        chooseAverageSV(settingVars)
        chooseConstantShift(settingVars, 0)
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Chinchilla")
    end
    do -- Combo
        local settingVars = getSettingVars("Combo", "Settings")

        chooseStandardSVTypes(settingVars)
        chooseComboSVOption(settingVars)
        addSeparator()
        chooseConstantShift(settingVars, 0)
        if not settingVars.dontNormalize then
            chooseAverageSV(settingVars)
        end
        chooseFinalSV(settingVars, false)
        chooseNoNormalize(settingVars)

        saveSettingsButton(globalVars, settingVars, "Combo")
    end
    do -- Code
        local settingVars = getSettingVars("Code", "Settings")

        codeInput(settingVars, "code", "##code")
        imgui.Separator()
        chooseSVPoints(settingVars)
        chooseFinalSV(settingVars)

        saveSettingsButton(globalVars, settingVars, "Code")
    end
end
