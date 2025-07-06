---Returns the factorial of an integer.
---@param n integer
---@return integer
function math.factorial(n)
    local product = 1
    for i = 2, n do
        product = product * i
    end
    return product
end
