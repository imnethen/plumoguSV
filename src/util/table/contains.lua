---Returns a boolean value corresponding to whether or not an element exists within a table.
---@param tbl table
---@param item any
---@return boolean
function table.contains(tbl, item)
    for _, v in pairs(tbl) do
        if (v == item) then return true end
    end
    return false
end
