---Returns the sign of a number: `1` if the number is non-negative, `-1` if negative.
---@param number number
---@return 1|-1
function math.sign(number)
    if number >= 0 then return 1 end
    return -1
end
