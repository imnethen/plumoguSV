-- Creates an imgui combo
-- Returns the updated index of the item in the list that is selected [Int]
-- Parameters
--    label     : label for the combo [String]
--    list      : list for the combo to use [Table]
--    listIndex : current index of the item from the list being selected in the combo [Int]
function combo(label, list, listIndex, colorList)
    local newListIndex = math.clamp(listIndex, 1, #list)
    local currentComboItem = list[listIndex]
    local comboFlag = imgui_combo_flags.HeightLarge
    rgb = {}

    if (colorList) then
        colorList[newListIndex]:gsub("(%d+)", function(c)
            table.insert(rgb, c)
        end)
        imgui.PushStyleColor(imgui_col.Text, vector.New(rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1))
    end

    if not imgui.BeginCombo(label, currentComboItem, comboFlag) then
        if (colorList) then imgui.PopStyleColor() end
        return newListIndex
    end
    if (colorList) then imgui.PopStyleColor() end

    for i = 1, #list do
        rgb = {}
        if (colorList) then
            colorList[i]:gsub("(%d+)", function(c)
                table.insert(rgb, c)
            end)
            imgui.PushStyleColor(imgui_col.Text, vector.New(rgb[1] / 255, rgb[2] / 255, rgb[3] / 255, 1))
        end
        local listItem = list[i]
        if imgui.Selectable(listItem) then
            newListIndex = i
        end
        if (colorList) then imgui.PopStyleColor() end
    end
    imgui.EndCombo()
    return newListIndex
end
