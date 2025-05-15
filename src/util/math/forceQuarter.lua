-- Forces a number to be a multiple of a quarter (0.25)
-- Returns the result of the force [Int/Float]
-- Parameters
--    number : number to force to be a multiple of one quarter [Int/Float]
function math.quarter(number)
    return math.floor(number * 4 + 0.5) / 4
end
