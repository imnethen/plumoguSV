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
    if (state.GetValue("showSettingsWindow")) then
        showPluginSettingsWindow(globalVars)
    end
    if (imgui.Button("Click Here To Get Map Stats", ACTION_BUTTON_SIZE)) then
        local currentTg = state.SelectedScrollGroupId
        local tgList = map.GetTimingGroupIds()
        local svSum = 0
        local ssfSum = 0
        for _, tg in pairs(tgList) do
            state.SelectedScrollGroupId = tg
            svSum = svSum + #map.ScrollVelocities
            ssfSum = ssfSum + #map.ScrollSpeedFactors
        end
        print("s!",
            "That's an average of " ..
            math.round(svSum * 1000 / map.TrackLength, 2) ..
            " SVs per second, or " .. math.round(ssfSum * 1000 / map.TrackLength, 2) .. " SSFs per second.")
        print("s!", "This map also contains " .. #map.TimingPoints .. " timing points.")
        print("s!",
            "This map has " .. svSum .. " SVs and " .. ssfSum .. " SSFs across " .. #tgList .. " timing groups.")
        print("w!",
            "Remember that the quality of map has no correlation with the object count! Try to be optimal in your object usage.")
        state.SelectedScrollGroupId = currentTg
    end
end