function changeNoteLockMode()
    local mode = state.GetValue("note-lock-mode", 0)
    mode = (mode + 1) % 4
    if (mode == 0) then
        print("s", "Notes have been unlocked.")
    end
    if (mode == 1) then
        print("e", "Notes have been fully locked. To change the lock mode, press " .. GLOBAL_HOTKEY_LIST[10])
    end
    if (mode == 2) then
        print("w", "Notes can no longer be placed, only moved. To change the lock mode, press" .. GLOBAL_HOTKEY_LIST[10])
    end
    if (mode == 3) then
        print("w",
            "Notes can no longer be moved, only placed and deleted. To change the lock mode, press" ..
            GLOBAL_HOTKEY_LIST[10])
    end
end

function initializeNoteLockMode()
    state.SetValue("note-lock-mode", 0)
    listen(function(action, type, fromLua)
        if (fromLua) then return end
        actionIndex = tonumber(action.Type)
        local mode = state.GetValue("note-lock-mode", 0)
        if (mode == 1) then
            action.Undo()
        end
        if (mode == 3) then
            local allowedIndices = {}
        end
    end)
end
