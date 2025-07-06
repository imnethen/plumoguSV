---Evaluates a simplified one-dimensional hermite related (?) spline for SV purposes
---@param m1 number
---@param m2 number
---@param y2 number
---@param t number
---@return number
function math.hermite(m1, m2, y2, t)
    local a = m1 + m2 - 2 * y2
    local b = 3 * y2 - 2 * m1 - m2
    local c = m1
    return a * t ^ 3 + b * t ^ 2 + c * t
end
