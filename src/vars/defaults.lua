function loadDefaultProperties(defaultProperties)
    STARTING_MENU_VARS = table.duplicate(DEFAULT_STARTING_MENU_VARS)
    STARTING_SETTING_VARS = table.duplicate(DEFAULT_STARTING_SETTING_VARS)
    if (not defaultProperties) then return end
    for menuName, tbl in pairs(STARTING_MENU_VARS) do
        for settingName, settingValue in pairs(tbl) do
            if (defaultProperties[menuName][settingName]) then
                STARTING_MENU_VARS[menuName][settingName] = settingValue
            end
        end
    end
    for label, tbl in pairs(STARTING_SETTING_VARS) do
        for settingName, settingValue in pairs(tbl) do
            if (defaultProperties[label][settingName]) then
                STARTING_SETTING_VARS[label][settingName] = settingValue
            end
        end
    end
end
