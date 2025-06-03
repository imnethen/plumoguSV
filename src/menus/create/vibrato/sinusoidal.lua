function sinusoidalVibratoMenu(menuVars, settingVars)
    if (menuVars.vibratoMode == 1) then
        customSwappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseNumPeriods(settingVars)
        choosePeriodShift(settingVars)
        local func = function(t)
            return math.sin(2 * math.pi * (settingVars.periods * t + settingVars.periodsShift)) *
            (settingVars.startMsx + t * (settingVars.endMsx - settingVars.startMsx))
        end

        simpleActionMenu("Vibrate", 2, function(v)
            svVibrato(v, func)
        end, nil, menuVars)
    else
        imgui.TextColored(vector.New(1, 0, 0, 1), "this function is not yet supported.")
        -- customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        -- customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")

        -- simpleActionMenu("Vibrate", 2, linearSSFVibrato, nil, settingVars)
    end
end
