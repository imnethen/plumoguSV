---Reverses the order of a numerically-indexed table.
---@param tbl table
---@return table
function table.reverse(tbl)
    local reverseTbl = {}
    for i = 1, #tbl do
        table.insert(reverseTbl, tbl[#tbl + 1 - i])
    end
    return reverseTbl
end
