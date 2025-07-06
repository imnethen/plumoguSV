---Normalizes a table of numbers to achieve a target average (NOT PURE)
---@param values number[] The table to normalize.
---@param targetAverage number The desired average value.
---@param includeLastValueInAverage boolean Whether or not to include the last value in the average.
function table.normalize(values, targetAverage, includeLastValueInAverage)
    local avgValue = table.average(values, includeLastValueInAverage)
    if avgValue == 0 then return end
    for i = 1, #values do
        values[i] = (values[i] * targetAverage) / avgValue
    end
end
