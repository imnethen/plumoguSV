---Forces a number to have a quarterly decimal part.
---@param number number
---@return number
function math.quarter(number)
    return math.floor(number * 4 + 0.5) / 4
end
