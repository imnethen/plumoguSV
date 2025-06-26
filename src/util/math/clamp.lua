---Restricts a number to be within a chosen bound.
---@param number number
---@param lowerBound number
---@param upperBound number
---@return number
function math.clamp(number, lowerBound, upperBound)
    if number < lowerBound then return lowerBound end
    if number > upperBound then return upperBound end
    return number
end
