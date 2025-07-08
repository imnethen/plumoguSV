function awake()
    local tempGlobalVars = read()
    if (not tempGlobalVars) then tempGlobalVars = table.construct() end

    syncGlobalVarsState(tempGlobalVars)
    loadDefaultProperties(tempGlobalVars.defaultProperties)

    state.SelectedScrollGroupId = "$Default" or map.GetTimingGroupIds()[1]
end

function syncGlobalVarsState(tempGlobalVars)
    globalVars.useCustomPulseColor = truthy(tempGlobalVars.useCustomPulseColor)
    globalVars.pulseColor = table.vectorize4(tempGlobalVars.pulseColor)
    globalVars.pulseCoefficient = math.toNumber(tempGlobalVars.pulseCoefficient)
    globalVars.stepSize = math.toNumber(tempGlobalVars.stepSize)
    globalVars.dontReplaceSV = truthy(tempGlobalVars.dontReplaceSV)
    globalVars.upscroll = truthy(tempGlobalVars.upscroll)
    globalVars.colorThemeIndex = math.toNumber(tempGlobalVars.colorThemeIndex)
    globalVars.styleThemeIndex = math.toNumber(tempGlobalVars.styleThemeIndex)
    globalVars.rgbPeriod = math.toNumber(tempGlobalVars.rgbPeriod)
    globalVars.cursorTrailIndex = math.toNumber(tempGlobalVars.cursorTrailIndex)
    globalVars.cursorTrailShapeIndex = math.toNumber(tempGlobalVars.cursorTrailShapeIndex)
    globalVars.effectFPS = math.toNumber(tempGlobalVars.effectFPS)
    globalVars.cursorTrailPoints = math.toNumber(tempGlobalVars.cursorTrailPoints)
    globalVars.cursorTrailSize = math.toNumber(tempGlobalVars.cursorTrailSize)
    globalVars.snakeSpringConstant = math.toNumber(tempGlobalVars.snakeSpringConstant)
    globalVars.cursorTrailGhost = truthy(tempGlobalVars.cursorTrailGhost)
    globalVars.drawCapybara = truthy(tempGlobalVars.drawCapybara)
    globalVars.drawCapybara2 = truthy(tempGlobalVars.drawCapybara2)
    globalVars.drawCapybara312 = truthy(tempGlobalVars.drawCapybara312)
    globalVars.ignoreNotes = truthy(tempGlobalVars.ignoreNotesOutsideTg)
    globalVars.hideSVInfo = truthy(tempGlobalVars.hideSVInfo)
    globalVars.showVibratoWidget = truthy(tempGlobalVars.showVibratoWidget)
    globalVars.showNoteDataWidget = truthy(tempGlobalVars.showNoteDataWidget)
    globalVars.showMeasureDataWidget = truthy(tempGlobalVars.showMeasureDataWidget)
    globalVars.advancedMode = truthy(tempGlobalVars.advancedMode)
    globalVars.hideAutomatic = truthy(tempGlobalVars.hideAutomatic)
    globalVars.dontPrintCreation = truthy(tempGlobalVars.dontPrintCreation)
    globalVars.hotkeyList = tempGlobalVars.hotkeyList
    GLOBAL_HOTKEY_LIST = tempGlobalVars.hotkeyList
    globalVars.customStyle = tempGlobalVars.customStyle or table.construct()
    globalVars.equalizeLinear = truthy(tempGlobalVars.equalizeLinear)
end
