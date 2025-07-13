---When given a dictionary and table of keys, returns a new table with only the specified keys and values.
---@param tbl { [string]: any } The base table in which to lint the data from.
---@param keyList string[] The list of keys to include in the new table.
---@return { [string]: any } outputTable
function table.validate(tbl, keyList)
    local tableKeys = table.keys(tbl)
    local outputTable = table.construct()
    for _, key in pairs(keyList) do
        if (table.contains(tableKeys, key)) then
            outputTable:insert(tbl[key])
        end
    end
    return outputTable
end
