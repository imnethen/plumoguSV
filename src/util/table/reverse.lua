---Reverses the order of a numerically-indexed table.
---@param tbl table The original table.
---@return table tbl The original table, reversed.
function table.reverse(tbl)
    local reverseTbl = {}
    for i = 1, #tbl do
        table.insert(reverseTbl, tbl[#tbl + 1 - i])
    end
    return reverseTbl
end
