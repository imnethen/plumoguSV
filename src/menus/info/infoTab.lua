-- Creates the "Info" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function infoTab(globalVars)
    provideBasicPluginInfo()
    provideMorePluginInfo()
    listKeyboardShortcuts()
    choosePluginBehaviorSettings(globalVars)
    choosePluginAppearance(globalVars)
    chooseHotkeys(globalVars)
    chooseAdvancedMode(globalVars)
    if (globalVars.advancedMode) then
        chooseHideAutomatic(globalVars)
    end
end

-- Gives basic info about how to use the plugin
function provideBasicPluginInfo()
    imgui.Text("Steps to use plumoguSV:")
    imgui.BulletText("Choose an SV tool")
    imgui.BulletText("Adjust the SV tool's settings")
    imgui.BulletText("Select notes to use the tool at/between")
    imgui.BulletText("Press 'T' on your keyboard")
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

-- Lists keyboard shortcuts for the plugin
function listKeyboardShortcuts()
    if not imgui.CollapsingHeader("Keyboard Shortcuts") then return end
    local indentAmount = -6
    imgui.Indent(indentAmount)
    addPadding()
    imgui.BulletText("Ctrl + Shift + Tab = center plugin window")
    toolTip("Useful if the plugin begins or ends up offscreen")
    addSeparator()
    imgui.BulletText("Shift + Tab = focus plugin + navigate inputs")
    toolTip("Useful if you click off the plugin but want to quickly change an input value")
    addSeparator()
    imgui.BulletText("T = activate the big button doing SV stuff")
    toolTip("Use this to do SV stuff for a quick workflow")
    addSeparator()
    imgui.BulletText("Shift+T = activate the big button doing SSF stuff")
    toolTip("Use this to do SSF stuff for a quick workflow")
    addSeparator()
    imgui.BulletText("Alt + Shift + (Z or X) = switch tool type")
    toolTip("Use this to do SV stuff for a quick workflow")
    addPadding()
    imgui.Unindent(indentAmount)
end
