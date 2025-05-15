-- Creates an imgui combo
-- Returns the updated index of the item in the list that is selected [Int]
-- Parameters
--    label     : label for the combo [String]
--    list      : list for the combo to use [Table]
--    listIndex : current index of the item from the list being selected in the combo [Int]
function combo(label, list, listIndex, colorList)
    local newListIndex = listIndex
    local currentComboItem = list[listIndex]
    local comboFlag = imgui_combo_flags.HeightLarge
    rgb = {}
    colorList[listIndex]:gsub("(%d+)", function(c)
        table.insert(rgb, c)
    end)
    print(rgb[1], rgb[2], rgb[3])
    imgui.PushStyleColor(imgui_col.Text, { rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1 })
    if not imgui.BeginCombo(label, currentComboItem, comboFlag) then
        imgui.PopStyleColor()
        return listIndex
    end
    imgui.PopStyleColor()

    for i = 1, #list do
        rgb = {}
        colorList[i]:gsub("(%d+)", function(c)
            table.insert(rgb, c)
        end)
        imgui.PushStyleColor(imgui_col.Text, { rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1 })
        local listItem = list[i]
        if imgui.Selectable(listItem) then
            newListIndex = i
        end
        imgui.PopStyleColor()
    end
    imgui.EndCombo()
    return newListIndex
    --[[
    local oldComboIndex = listIndex - 1
    local _, newComboIndex = imgui.Combo(label, oldComboIndex, list, #list)
    return newComboIndex + 1
    --]]
end
