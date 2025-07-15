function awake()
    local tempGlobalVars = read()
    if (not tempGlobalVars) then tempGlobalVars = table.construct() end

    setGlobalVars(tempGlobalVars)
    loadDefaultProperties(tempGlobalVars.defaultProperties)
    setPresets(table.map(tempGlobalVars.presets, table.parse))

    state.SelectedScrollGroupId = "$Default" or map.GetTimingGroupIds()[1]
end
