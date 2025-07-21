function showKeybindSettings()
    local hotkeyList = table.duplicate(globalVars.hotkeyList or DEFAULT_HOTKEY_LIST)
    local awaitingIndex = state.GetValue("hotkey_awaitingIndex", 0)
    for hotkeyIndex, hotkeyCombo in pairs(hotkeyList) do
        if imgui.Button(awaitingIndex == hotkeyIndex and "Listening...##listening" or hotkeyCombo .. "##" .. hotkeyIndex) then
            if (awaitingIndex == hotkeyIndex) then
                awaitingIndex = 0
            else
                awaitingIndex = hotkeyIndex
            end
        end
        KeepSameLine()
        imgui.SetCursorPosX(95)
        imgui.Text("" .. HOTKEY_LABELS[hotkeyIndex])
    end
    AddSeparator()
    simpleActionMenu("Reset Hotkey Settings", 0, function()
        globalVars.hotkeyList = DEFAULT_HOTKEY_LIST
        write(globalVars)
        awaitingIndex = 0
    end, nil, true, true)
    state.SetValue("hotkey_awaitingIndex", awaitingIndex)
    if (awaitingIndex == 0) then return end
    local prefixes, key = listenForAnyKeyPressed()
    if (key == -1) then return end
    hotkeyList[awaitingIndex] = table.concat(prefixes, "+") .. (truthy(prefixes) and "+" or "") .. keyNumToKey(key)
    awaitingIndex = 0
    globalVars.hotkeyList = hotkeyList
    GLOBAL_HOTKEY_LIST = hotkeyList
    write(globalVars)
    state.SetValue("hotkey_awaitingIndex", awaitingIndex)
end
