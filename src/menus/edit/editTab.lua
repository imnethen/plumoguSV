EDIT_SV_TOOLS = { -- tools for editing SVs
    "Add Teleport",
    "Align Timing Lines",
    "bug fixing from <1.1.1",
    "Copy & Paste",
    "Direct SV",
    "Displace Note",
    "Displace View",
    "Dynamic Scale",
    "Fix LN Ends",
    "Flicker",
    "Measure",
    "Merge",
    "Reverse Scroll",
    "Scale (Displace)",
    "Scale (Multiply)",
    "Swap Notes",
    "Vertical Shift"
}

-- Creates the "Edit SVs" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function editSVTab(globalVars)
    if (globalVars.advancedMode) then chooseCurrentScrollGroup(globalVars) end
    chooseEditTool(globalVars)
    changeEditToolIfKeysPressed(globalVars)
    addSeparator()
    local toolName = EDIT_SV_TOOLS[globalVars.editToolIndex]
    if toolName == "Add Teleport" then addTeleportMenu() end
    if toolName == "Align Timing Lines" then alignTimingLinesMenu() end
    if toolName == "bug fixing from <1.1.1" then tempBugFixMenu() end
    if toolName == "Copy & Paste" then copyNPasteMenu(globalVars) end
    if toolName == "Direct SV" then directSVMenu() end
    if toolName == "Displace Note" then displaceNoteMenu() end
    if toolName == "Displace View" then displaceViewMenu() end
    if toolName == "Dynamic Scale" then dynamicScaleMenu(globalVars) end
    if toolName == "Fix LN Ends" then fixLNEndsMenu() end
    if toolName == "Flicker" then flickerMenu() end
    if toolName == "Measure" then measureMenu() end
    if toolName == "Merge" then mergeMenu() end
    if toolName == "Reverse Scroll" then reverseScrollMenu() end
    if toolName == "Scale (Displace)" then scaleDisplaceMenu() end
    if toolName == "Scale (Multiply)" then scaleMultiplyMenu() end
    if toolName == "Swap Notes" then swapNotesMenu() end
    if toolName == "Vertical Shift" then verticalShiftMenu() end
end