---Normalizes a table of numbers to achieve a target average
---@param values number[]
---@param targetAverage number
---@param includeLastValueInAverage boolean
function table.normalize(values, targetAverage, includeLastValueInAverage)
    local avgValue = table.average(values, includeLastValueInAverage)
    if avgValue == 0 then return end
    for i = 1, #values do
        values[i] = (values[i] * targetAverage) / avgValue
    end
end
