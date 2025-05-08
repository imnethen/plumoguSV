-- Evaluates a simplified one-dimensional cubic bezier expression with points (0, p2, p3, 1)
-- Returns the result of the bezier evaluation [Int/Float]
-- Parameters
--    p2 : second coordinate of the cubic bezier [Int/Float]
--    p3 : third coordinate of the cubic bezier [Int/Float]
--    t  : time to evaluate the cubic bezier at [Int/Float]
function simplifiedCubicBezier(p2, p3, t)
    return 3 * t * (1 - t) ^ 2 * p2 + 3 * t ^ 2 * (1 - t) * p3 + t ^ 3
end

-- Evaluates a simplified one-dimensional quadratic bezier expression with points (0, p2, 1)
-- Returns the result of the bezier evaluation [Int/Float]
-- Parameters
--    p2 : second coordinate of the quadratic bezier [Int/Float]
--    t  : time to evaluate the quadratic bezier at [Int/Float]
function simplifiedQuadraticBezier(p2, t)
    return 2 * t * (1 - t) * p2 + t ^ 2
end
