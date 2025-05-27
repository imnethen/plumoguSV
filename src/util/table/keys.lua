---Returns a table of keys from a table.
---@param tbl { [string]: any }
---@return string[]
function table.keys(tbl)
    local resultsTbl = {}

    for k, _ in pairs(tbl) do
        if (not table.contains(resultsTbl, k)) then
            table.insert(resultsTbl, k)
        end
    end

    return resultsTbl
end
