---Concatenates two numeric tables together.
---@param t1 { [number]: any } The first table.
---@param t2 { [number]: any } The second table.
---@return { [number]: any } tbl The resultant table.
function table.combine(t1, t2)
    local newTbl = table.duplicate(t1)
    for i = 1, #t2 do
        table.insert(newTbl, t2[i])
    end
    return newTbl
end
