---Reverses the order of an array.
---@param tbl table The original table.
---@return table tbl The original table, reversed.
function table.reverse(tbl)
    local reverseTbl = {}
    for i = 1, #tbl do
        table.insert(reverseTbl, tbl[#tbl + 1 - i])
    end
    return reverseTbl
end
