function awake()
    local tempGlobalVars = read()
    if (not tempGlobalVars) then tempGlobalVars = {} end

    setGlobalVars(tempGlobalVars)
    loadDefaultProperties(tempGlobalVars.defaultProperties)
    setPresets(table.map(tempGlobalVars.presets or {}, table.parse))

    state.SelectedScrollGroupId = "$Default" or map.GetTimingGroupIds()[1]
end
