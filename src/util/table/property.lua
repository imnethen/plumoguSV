---In a nested table `tbl`, returns a table of property values with key `property`.
---@param tbl table The table to search in.
---@param property string | integer The property name.
---@return table properties The resultant table.
function table.property(tbl, property)
    local resultsTbl = {}

    for _, v in pairs(tbl) do
        table.insert(resultsTbl, v[property])
    end

    return resultsTbl
end
