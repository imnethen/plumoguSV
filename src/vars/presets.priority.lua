function setPresets(presetList)
<<<<<<< HEAD:src/vars/presets.priority.lua
    globalVars.presets = {}
    for _, preset in pairs(presetList) do
=======
    for _, preset in ipairs(presetList) do
>>>>>>> performance:src/vars/presets.lua
        local presetIsValid, presetData = checkPresetValidity(preset)
        if (not presetIsValid) then goto continue end
        table.insert(globalVars.presets,
            { name = preset.name, type = preset.type, menu = preset.menu, data = presetData })
        ::continue::
    end
end

function checkPresetValidity(preset)
    if (not table.contains(CREATE_TYPES, preset.type)) then return false, nil end
    local validMenus = {}
    if (preset.type == "Standard" or preset.type == "Still") then
        validMenus = table.duplicate(STANDARD_SVS)
    end
    if (preset.type == "Special") then
        validMenus = table.duplicate(SPECIAL_SVS)
    end
    if (preset.type == "Vibrato") then
        validMenus = table.duplicate(VIBRATO_SVS)
    end
    if (not truthy(#validMenus)) then return false, nil end
    if (not table.includes(validMenus, preset.menu)) then return false, nil end

    local menuVars = table.validate(DEFAULT_STARTING_MENU_VARS[preset.type][preset.menu], preset.data.menuVars)
    local settingVars = table.validate(DEFAULT_STARTING_SETTING_VARS[preset.type][preset.menu], preset.data.settingVars)

    return true, { menuVars, settingVars }
end
