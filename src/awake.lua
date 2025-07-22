function awake()
    local tempGlobalVars = read()
    if (not tempGlobalVars) then tempGlobalVars = table.construct() end

    setGlobalVars(tempGlobalVars)
    loadDefaultProperties(tempGlobalVars.defaultProperties)
    setPresets(tempGlobalVars.presets or {})
    initializeNoteLockMode()

    state.SelectedScrollGroupId = "$Default" or map.GetTimingGroupIds()[1]
end
