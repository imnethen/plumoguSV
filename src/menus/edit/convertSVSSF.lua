function convertSVSSFMenu()
    local menuVars = getMenuVars("convertSVSSF")

    chooseConvertSVSSFDirection(menuVars)

    saveVariables("convertSVSSFMenu", menuVars)

    simpleActionMenu(menuVars.conversionDirection and "Convert SVs -> SSFs" or "Convert SSFs -> SVs", 2, convertSVSSF,
        menuVars, false, false)
end
