function customVibratoMenu(menuVars, settingVars, separateWindow)
    local typingCode = false
    if (menuVars.vibratoMode == 1) then
        codeInput(settingVars, "code", "##code")
        if imgui.IsItemActive() then
            typingCode = true
        else
            typingCode = false
        end
        local func = eval(settingVars.code)
        addSeparator()

        simpleActionMenu("Vibrate", 2, function(v)
            svVibrato(v, func)
        end, menuVars, false, typingCode, separateWindow and GLOBAL_HOTKEY_LIST[8] or nil)
    else
        codeInput(settingVars, "code1", "##code1")
        if imgui.IsItemActive() then
            typingCode = true
        else
            typingCode = false
        end
        codeInput(settingVars, "code2", "##code2")
        if imgui.IsItemActive() then
            typingCode = true
        else
            typingCode = typingCode or false
        end
        local func1 = eval(settingVars.code1)
        local func2 = eval(settingVars.code2)
        addSeparator()

        simpleActionMenu("Vibrate", 2, function(v)
            ssfVibrato(v, func1, func2)
        end, menuVars, false, typingCode, separateWindow and GLOBAL_HOTKEY_LIST[8] or nil)
    end
end
