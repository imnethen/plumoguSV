---Returns a deep copy of a table.
---@param tbl table The original table.
---@return table tbl The new table.
function table.duplicate(tbl)
    local dupeTbl = {}
    for _, value in ipairs(tbl) do
        table.insert(dupeTbl, value)
    end
    return dupeTbl
end
