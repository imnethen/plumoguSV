-- Evaluates a simplified one-dimensional hermite related (?) spline for SV purposes
-- Returns the result of the hermite evaluation [Int/Float]
-- Parameters
--    m1 : slope at first point [Int/Float]
--    m2 : slope at second point [Int/Float]
--    y2 : y coordinate of second point [Int/Float]
--    t  : time to evaluate the hermite spline at [Int/Float]
function simplifiedHermite(m1, m2, y2, t)
    local a = m1 + m2 - 2 * y2
    local b = 3 * y2 - 2 * m1 - m2
    local c = m1
    return a * t ^ 3 + b * t ^ 2 + c * t
end
