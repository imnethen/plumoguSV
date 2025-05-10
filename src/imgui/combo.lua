-- Creates an imgui combo
-- Returns the updated index of the item in the list that is selected [Int]
-- Parameters
--    label     : label for the combo [String]
--    list      : list for the combo to use [Table]
--    listIndex : current index of the item from the list being selected in the combo [Int]
function combo(label, list, listIndex)
    local newListIndex = listIndex
    local currentComboItem = list[listIndex]
    local comboFlag = imgui_combo_flags.HeightLarge
    if not imgui.BeginCombo(label, currentComboItem, comboFlag) then return listIndex end

    for i = 1, #list do
        local listItem = list[i]
        if imgui.Selectable(listItem) then
            newListIndex = i
        end
    end
    imgui.EndCombo()
    return newListIndex
    --[[
    local oldComboIndex = listIndex - 1
    local _, newComboIndex = imgui.Combo(label, oldComboIndex, list, #list)
    return newComboIndex + 1
    --]]
end
