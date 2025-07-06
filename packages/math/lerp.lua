---Returns a number that is `(weight * 100)%` of the way from travelling between `lowerBound` and `upperBound`.
---@param weight number
---@param lowerBound number
---@param upperBound number
---@return number
function math.lerp(weight, lowerBound, upperBound)
    return upperBound * weight + lowerBound * (1 - weight)
end

---Returns the weight of a number between `lowerBound` and `upperBound`.
---@param num number
---@param lowerBound number
---@param upperBound number
---@return number
function math.inverseLerp(num, lowerBound, upperBound)
    return (num - lowerBound) / (upperBound - lowerBound)
end
