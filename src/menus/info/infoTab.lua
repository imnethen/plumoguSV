-- Creates the "Info" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function infoTab(globalVars)
    provideBasicPluginInfo()
    provideMorePluginInfo()
    listKeyboardShortcuts()
    choosePluginBehaviorSettings(globalVars)
    choosePluginAppearance(globalVars)
    chooseAdvancedMode(globalVars)
end