---Returns the average value of a numeric table.
---@param values number[] The list of numbers.
---@param includeLastValue boolean Whether or not to include the last value in the table.
---@return number avg The arithmetic mean of the table.
function table.average(values, includeLastValue)
    if #values == 0 then return 0 end
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
