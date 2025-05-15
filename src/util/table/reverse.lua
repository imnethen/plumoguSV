-- Constructs a new reverse-order list from an existing list
-- Returns the reversed list [Table]
-- Parameters
--    list : list to be reversed [Table]
function table.reverse(list)
    local reverseList = {}
    for i = 1, #list do
        table.insert(reverseList, list[#list + 1 - i])
    end
    return reverseList
end
