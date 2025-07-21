require("packages.table.duplicate")
---Concatenates two arrays together.
---@param t1 any[] The first table.
---@param t2 any[] The second table.
---@return any[] tbl The resultant table.
function table.combine(t1, t2)
    local newTbl = table.duplicate(t1)
    for i = 1, #t2 do
        table.insert(newTbl, t2[i])
    end
    return newTbl
end
