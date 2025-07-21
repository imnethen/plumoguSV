function checkForGlobalHotkeys()
    if (exclusiveKeyPressed(globalVars.hotkeyList[9])) then jumpToTg() end
    if (exclusiveKeyPressed(globalVars.hotkeyList[10])) then changeNoteLockMode() end
end
