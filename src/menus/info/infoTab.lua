-- Creates the "Info" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function infoTab(globalVars)
    imgui.SeparatorText("Welcome to plumoguSV!")
    imgui.TextWrapped("This plugin is your one-stop shop for all of \nyour SV needs. Using it is quick and easy:")
    addPadding()
    imgui.BulletText("Choose an SV tool in the Create tab.")
    imgui.BulletText("Adjust the tool's settings to your liking.")
    imgui.BulletText("Select notes to use the tool at.")
    imgui.BulletText("Press the '" .. GLOBAL_HOTKEY_LIST[1] .. "' hotkey.")
    addPadding()
    imgui.SeparatorText("Special thanks to:")
    addPadding()
    imgui.BulletText("kloi34, for being the original dev.")
    imgui.BulletText("kusa, for some handy widgets.")
    imgui.BulletText("7xbi + nethen for some useful PRs.")
    imgui.BulletText("Emik + William for plugin help.")
    imgui.BulletText("ESV members for constant support.")
    addPadding()
    addPadding()
    if (imgui.Button("Click Here To Edit Settings", ACTION_BUTTON_SIZE)) then
        state.SetValue("showSettingsWindow", true)
        local windowDim = state.WindowSize
        local pluginDim = imgui.GetWindowSize()
        local centeringX = (windowDim[1] - pluginDim.x) / 2
        local centeringY = (windowDim[2] - pluginDim.y) / 2
        local coordinatesToCenter = vector.New(centeringX, centeringY)
        imgui.SetWindowPos("plumoguSV Settings", coordinatesToCenter)
    end
    if (state.GetValue("showSettingsWindow", false)) then
        showPluginSettingsWindow(globalVars)
    end
end

-- Gives basic info about how to use the plugin
function provideBasicPluginInfo()
    imgui.SeparatorText("Welcome to plumoguSV!")
    imgui.TextWrapped("This plugin is your one-stop shop for all of your SV needs. Using it is quick and easy:")
    imgui.BulletText("Choose an SV tool in the Create tab.")
    imgui.BulletText("Adjust the tool's settings to your liking.")
    imgui.BulletText("Select notes to use the tool at.")
    imgui.BulletText("Press the '" .. GLOBAL_HOTKEY_LIST[1] .. "' hotkey.")
    addPadding()
end

-- Gives more info about the plugin
function provideMorePluginInfo()
    if not imgui.CollapsingHeader("More Info") then return end
    addPadding()
    linkBox("Goofy SV mapping guide",
        "https://docs.google.com/document/d/1ug_WV_BI720617ybj4zuHhjaQMwa0PPekZyJoa17f-I")
    linkBox("GitHub repository", "https://github.com/ESV-Sweetplum/plumoguSV")
end
