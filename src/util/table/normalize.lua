-- Normalizes a set of values to achieve a target average
-- Parameters
--    values                    : set of numbers [Table]
--    targetAverage             : average value that is aimed for [Int/Float]
--    includeLastValueInAverage : whether or not to include the last value in the average [Boolean]
function table.normalize(values, targetAverage, includeLastValueInAverage)
    local avgValue = table.average(values, includeLastValueInAverage)
    if avgValue == 0 then return end
    for i = 1, #values do
        values[i] = (values[i] * targetAverage) / avgValue
    end
end
