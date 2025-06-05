function showPluginSettingsWindow(globalVars)
    _, opened = imgui.Begin("plumoguSV Settings", true, imgui_window_flags.AlwaysAutoResize)
    choosePluginBehaviorSettings(globalVars)
    choosePluginAppearance(globalVars)
    chooseHotkeys(globalVars)
    chooseAdvancedMode(globalVars)
    if (globalVars.advancedMode) then
        chooseHideAutomatic(globalVars)
    end
    if (not opened) then
        state.SetValue("showSettingsWindow", false)
    end
    imgui.End()
end
