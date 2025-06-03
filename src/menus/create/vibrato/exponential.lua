function exponentialVibratoMenu(menuVars, settingVars)
    if (menuVars.vibratoMode == 1) then
        customSwappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        chooseCurvatureCoefficient(settingVars)
        local func = function(t)
            local curvature = VIBRATO_CURVATURES[settingVars.curvatureIndex]
            if (curvature < 10) then
                t = 1 - (1 - t) ^ (1 / curvature)
            else
                t = t ^ curvature
            end
            return settingVars.endMsx * t +
                settingVars.startMsx * (1 - t)
        end

        simpleActionMenu("Vibrate", 2, function(v)
            svVibrato(v, func)
        end, nil, menuVars)
    else
        customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")

        simpleActionMenu("Vibrate", 2, linearSSFVibrato, nil, settingVars)
    end
end
