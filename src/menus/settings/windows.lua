function showWindowSettings()
    globalCheckbox("hideSVInfo", "Hide SV Info Window",
        "Disables the window that shows note distances when placing Standard, Special, or Still SVs.")
    globalCheckbox("showVibratoWidget", "Separate Vibrato Into New Window",
        "For those who are used to having Vibrato as a separate plugin, this option makes a new, independent window with vibrato only.")
    addSeparator()
    globalCheckbox("showNoteDataWidget", "Show Note Data Of Selection",
        "If one note is selected, shows simple data about that note.")
    globalCheckbox("showMeasureDataWidget", "Show Measure Data Of Selection",
        "If two notes are selected, shows measure data within the selected region.")
end
