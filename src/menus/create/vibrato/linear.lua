function linearVibratoMenu(menuVars, settingVars)
    if (menuVars.vibratoMode == 1) then
        customSwappableNegatableInputFloat2(settingVars, "startMsx", "endMsx", "Start/End", " msx", 0, 0.875)
        local func = function(t)
            return settingVars.endMsx * t + settingVars.startMsx * (1 - t)
        end
        simpleActionMenu("Vibrate", 2, function(v)
            svVibrato(v, func)
        end, nil, menuVars)
    else
        customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")

        local heightFunc1 = function(x)
            return settingVars.lowerStart + x * (settingVars.lowerEnd - settingVars.lowerStart)
        end
        local heightFunc2 = function(x)
            return settingVars.higherStart + x * (settingVars.higherEnd - settingVars.higherStart)
        end

        simpleActionMenu("Vibrate", 2, function(v) ssfVibrato(v, heightFunc1, heightFunc2) end, nil, menuVars)
    end
end
