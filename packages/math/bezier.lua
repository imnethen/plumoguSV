---Evaluates a simplified one-dimensional cubic bezier expression with points (0, p2, p3, 1).
---@param p2 number The second point in the cubic bezier.
---@param p3 number The third point in the cubic bezier.
---@param t number The time in which to evaluate the cubic bezier.
---@return number cBez The result.
function math.cubicBezier(p2, p3, t)
    return 3 * t * (1 - t) ^ 2 * p2 + 3 * t ^ 2 * (1 - t) * p3 + t ^ 3
end

---Evaluates a simplified one-dimensional quadratic bezier expression with points (0, p2, 1).
---@param p2 number The second point in the quadratic bezier.
---@param t number The time in which to evaluate the quadratic bezier.
---@return number qBez The result.
function math.quadraticBezier(p2, t)
    return 2 * t * (1 - t) * p2 + t ^ 2
end
