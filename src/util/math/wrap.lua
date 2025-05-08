-- Restricts a number to be within a closed interval that wraps around
-- Returns the result of the restriction [Int/Float]
-- Parameters
--    number     : number to keep within the interval [Int/Float]
--    lowerBound : lower bound of the interval [Int/Float]
--    upperBound : upper bound of the interval [Int/Float]
function wrapToInterval(number, lowerBound, upperBound)
    if number < lowerBound then return upperBound end
    if number > upperBound then return lowerBound end
    return number
end