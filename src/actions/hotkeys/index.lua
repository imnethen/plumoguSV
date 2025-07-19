function checkForGlobalHotkeys()
    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[9])) then jumpToTg() end
    if (exclusiveKeyPressed(GLOBAL_HOTKEY_LIST[10])) then changeNoteLockMode() end
end
