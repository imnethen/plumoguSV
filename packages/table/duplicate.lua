---Returns a deep copy of a table.
---@param tbl table The original table.
---@return table tbl The new table.
function table.duplicate(tbl)
    local dupeTbl = {}
    if (tbl[1]) then
        for _, value in ipairs(tbl) do
            table.insert(dupeTbl, type(value) == "table" and table.duplicate(value) or value)
        end
    else
        for _, key in pairs(table.keys(tbl)) do
            local value = tbl[key]
            dupeTbl[key] = type(value) == "table" and table.duplicate(value) or value
        end
    end
    return dupeTbl
end
