---Rounds a number to a given amount of decimal places.
---@param number number
---@param decimalPlaces integer
---@return number
function math.round(number, decimalPlaces)
    if (not decimalPlaces) then decimalPlaces = 0 end
    local multiplier = 10 ^ decimalPlaces
    return math.floor(multiplier * number + 0.5) / multiplier
end
