---Returns a table of keys from a table.
---@param tbl { [string]: any } The table to search in.
---@return string[] keys A list of keys.
function table.values(tbl)
    local resultsTbl = {}

    for _, v in pairs(tbl) do
        if (not table.contains(resultsTbl, v)) then
            table.insert(resultsTbl, v)
        end
    end

    return resultsTbl
end
