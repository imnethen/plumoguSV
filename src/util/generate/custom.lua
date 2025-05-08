
-- Returns a set of custom values [Table]
-- Parameters
--    values : list of custom values [Table]
function generateCustomSet(values)
    local newValues = makeDuplicateList(values)
    local averageMultiplier = calculateAverage(newValues, true)
    table.insert(newValues, averageMultiplier)
    return newValues
end