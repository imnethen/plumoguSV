-- Returns the average value from a list of values [Int/Float]
-- Parameters
--    values           : list of numerical values [Table]
--    includeLastValue : whether or not to include the last value for the average [Boolean]
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
