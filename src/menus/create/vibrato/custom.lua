function customVibratoMenu(menuVars, settingVars, separateWindow)
    local typingCode = false
    if (menuVars.vibratoMode == 1) then
        chooseCode(settingVars)
        if imgui.IsItemActive() then
            typingCode = true
        else
            typingCode = false
        end
        local func = eval(settingVars.code)

        simpleActionMenu("Vibrate", 2, function(v)
            svVibrato(v, func)
        end, nil, menuVars, false, typingCode, separateWindow and GLOBAL_HOTKEY_LIST[8] or nil)
    else
        imgui.TextColored(vector.New(1, 0, 0, 1), "this function is not yet supported.")
        -- customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs", "x")
        -- customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs", "x")

        -- simpleActionMenu("Vibrate", 2, linearSSFVibrato, nil, settingVars)
    end
end
