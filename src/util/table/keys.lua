---In a nested table `tbl`, returns a table of keys.
---@param tbl table
---@return table
function table.keys(tbl)
    local resultsTbl = {}

    for k, _ in pairs(tbl) do
        if (not table.contains(resultsTbl, k)) then
            table.insert(resultsTbl, k)
        end
    end

    return resultsTbl
end
