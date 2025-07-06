function sinusoidalVibratoMenu(menuVars, settingVars, separateWindow)
    if (menuVars.vibratoMode == 1) then
        swappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseMsxVerticalShift(settingVars, 0)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)
        local func = function(t)
            return math.sin(2 * math.pi * (settingVars.periods * t + settingVars.periodsShift)) * (settingVars.startMsx +
                t * (settingVars.endMsx - settingVars.startMsx)) + settingVars.verticalShift
        end

        addSeparator()

        simpleActionMenu("Vibrate", 2, function(v)
            svVibrato(v, func)
        end, nil, menuVars, false, false, separateWindow and GLOBAL_HOTKEY_LIST[8] or nil)
    else
        swappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        swappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")
        chooseConstantShift(settingVars)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)
        _, settingVars.applyToHigher = imgui.Checkbox("Apply Vibrato to Higher SSF?", settingVars.applyToHigher)

        local func1 = function(t)
            return math.sin(2 * math.pi * (settingVars.periods * t + settingVars.periodsShift)) *
                (settingVars.lowerStart + t * (settingVars.lowerEnd - settingVars.lowerStart)) +
                settingVars.verticalShift
        end
        local func2 = function(t)
            if (settingVars.applyToHigher) then
                return math.sin(2 * math.pi * (settingVars.periods * t + settingVars.periodsShift)) *
                    (settingVars.higherStart + t * (settingVars.higherEnd - settingVars.higherStart)) +
                    settingVars.verticalShift
            end
            return settingVars.higherStart + t * (settingVars.higherEnd - settingVars.higherStart)
        end
        addSeparator()

        simpleActionMenu("Vibrate", 2, function(v) ssfVibrato(v, func1, func2) end, nil, menuVars, false, false,
            separateWindow and GLOBAL_HOTKEY_LIST[8] or nil)
    end
end
