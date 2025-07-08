function showGeneralSettings()
    globalCheckbox("advancedMode", "Enable Advanced Mode",
        "Advanced mode enables a few features that simplify SV creation, at the cost of making the plugin more cluttered.")
    if (not globalVars.advancedMode) then imgui.BeginDisabled() end
    globalCheckbox("hideAutomatic", "Hide Automatically Placed TGs",
        'Timing groups placed by the "Automatic" feature will not be shown in the plumoguSV timing group selector.')
    if (not globalVars.advancedMode) then imgui.EndDisabled() end
    addSeparator()
    chooseUpscroll()
    addSeparator()
    globalCheckbox("dontReplaceSV", "Don't Replace SVs When Placing Regular SVs",
        "Self-explanatory. Highly recommended to keep this setting disabled.")
    globalCheckbox("ignoreNotesOutsideTg", "Ignore Notes Outside Current Timing Group",
        "Notes that are in a timing group outside of the current one will be ignored by stills, selection checks, etc.")
    chooseStepSize()
    globalCheckbox("dontPrintCreation", "Don't Print SV Creation Messages",
        'Disables printing "Created __ SVs" messages.')
    globalCheckbox("equalizeLinear", "Equalize Linear SV",
        "Forces the standard > linear option to have an average sv of 0 if the start and end SVs are equal. For beginners, this should be enabled.")
end
