---Removes duplicate values from a table.
---@param tbl table
---@return table
function table.dedupe(tbl)
    local hash = {}
    local newTbl = {}
    for _, value in ipairs(tbl) do
        if (not hash[value]) then
            newTbl[#newTbl + 1] = value
            hash[value] = true
        end
    end
    return newTbl
end
