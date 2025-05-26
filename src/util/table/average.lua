---Returns the average value of a numeric table.
---@param values number[]
---@param includeLastValue boolean
---@return number | nil
function table.average(values, includeLastValue)
    if #values == 0 then return nil end
    local sum = 0
    for _, value in pairs(values) do
        sum = sum + value
    end
    if not includeLastValue then
        sum = sum - values[#values]
        return sum / (#values - 1)
    end
    return sum / #values
end
