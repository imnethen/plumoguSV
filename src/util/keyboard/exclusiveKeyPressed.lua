function exclusiveKeyPressed(keyCombo)
    keyCombo = keyCombo:upper()
    local comboList = {}
    for v in keyCombo:gmatch("%u+") do
        table.insert(comboList, v)
    end
    local keyReq = comboList[#comboList]
    if (table.contains(comboList, "CTRL") and (utils.IsKeyUp(keys.LeftControl) and utils.IsKeyUp(keys.RightControl))) then
        return false
    end
    if (table.contains(comboList, "SHIFT") and (utils.IsKeyUp(keys.LeftShift) and utils.IsKeyUp(keys.RightShift))) then
        return false
    end
    if (table.contains(comboList, "ALT") and (utils.IsKeyUp(keys.LeftAlt) and utils.IsKeyUp(keys.RightAlt))) then
        return false
    end
    if (not table.contains(comboList, "CTRL") and not (utils.IsKeyUp(keys.LeftControl) and utils.IsKeyUp(keys.RightControl))) then
        return false
    end
    if (not table.contains(comboList, "SHIFT") and not (utils.IsKeyUp(keys.LeftShift) and utils.IsKeyUp(keys.RightShift))) then
        return false
    end
    if (not table.contains(comboList, "ALT") and not (utils.IsKeyUp(keys.LeftAlt) and utils.IsKeyUp(keys.RightAlt))) then
        return false
    end
    return utils.IsKeyPressed(keys[keyReq])
end
