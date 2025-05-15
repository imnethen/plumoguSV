-- Rounds a number to a given amount of decimal places
-- Returns the rounded number [Int/Float]
-- Parameters
--    number        : number to round [Int/Float]
--    decimalPlaces : number of decimal places to round the number to [Int]
function math.round(number, decimalPlaces)
    local multiplier = 10 ^ decimalPlaces
    return math.floor(multiplier * number + 0.5) / multiplier
end
