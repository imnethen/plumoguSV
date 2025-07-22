function loadDefaultProperties(defaultProperties)
    if (not defaultProperties) then return end
    if (not defaultProperties.menu) then goto skipMenu end
    for label, tbl in pairs(defaultProperties.menu) do
        for settingName, settingValue in pairs(tbl) do
            local defaultTable = DEFAULT_STARTING_MENU_VARS[label]
            if (not defaultTable) then break end
            local defaultSetting = defaultTable[settingName]
            if (not defaultSetting or type(defaultSetting) == "table" or type(defaultSetting) == "userdata") then
                goto skipSetting
            end
            if (type(defaultSetting) == "number") then
                settingValue = math.toNumber(settingValue)
            end
            if (type(defaultSetting) == "boolean") then
                settingValue = truthy(settingValue)
            end
            DEFAULT_STARTING_MENU_VARS[label][settingName] = settingValue
            ::skipSetting::
        end
    end
    ::skipMenu::
    for label, tbl in pairs(defaultProperties.settings) do
        for settingName, settingValue in pairs(tbl) do
            local defaultTable = DEFAULT_STARTING_SETTING_VARS[label]
            if (not defaultTable) then break end
            local defaultSetting = defaultTable[settingName]
            if (not defaultSetting or type(defaultSetting) == "table" or type(defaultSetting) == "userdata") then
                goto skipSetting
            end
            if (type(defaultSetting) == "number") then
                settingValue = math.toNumber(settingValue)
            end
            if (type(defaultSetting) == "boolean") then
                settingValue = truthy(settingValue)
            end
            DEFAULT_STARTING_SETTING_VARS[label][settingName] = settingValue
            ::skipSetting::
        end
    end
    globalVars.defaultProperties = { settings = DEFAULT_STARTING_SETTING_VARS, menu = DEFAULT_STARTING_MENU_VARS }
end
