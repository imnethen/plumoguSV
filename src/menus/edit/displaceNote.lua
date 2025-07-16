function displaceNoteMenu()
    local menuVars = getMenuVars("displaceNote")
    chooseVaryingDistance(menuVars)
    chooseLinearlyChangeDist(menuVars)
    saveVariables("displaceNoteMenu", menuVars)

    AddSeparator()
    simpleActionMenu("Displace selected notes", 1, displaceNoteSVsParent, menuVars)
end
