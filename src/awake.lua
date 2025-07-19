function awake()
    local tempGlobalVars = read()
    if (not tempGlobalVars) then tempGlobalVars = table.construct() end

    setGlobalVars(tempGlobalVars)
    loadDefaultProperties(tempGlobalVars.defaultProperties)
    setPresets(table.map(tempGlobalVars.presets or {}, table.parse))
    initializeNoteLockMode()

    state.SelectedScrollGroupId = "$Default" or map.GetTimingGroupIds()[1]
end
