
-- Returns a set of hermite spline related (?) values [Table]
-- Parameters
--    startValue    : intended first value of the set [Int/Float]
--    endValue      : intended last value of the set [Int/Float]
--    verticalShift : constant to add to each value in the set at very the end [Int/Float]
--    avgValue      : average value of the set [Int/Float]
--    numValues     : total number of values in the bezier set [Int]
function generateHermiteSet(startValue, endValue, verticalShift, avgValue, numValues)
    avgValue = avgValue - verticalShift
    local xCoords = generateLinearSet(0, 1, numValues)
    local yCoords = {}
    for i = 1, #xCoords do
        yCoords[i] = simplifiedHermite(startValue, endValue, avgValue, xCoords[i])
    end
    local hermiteSet = {}
    for i = 1, #yCoords - 1 do
        local startY = yCoords[i]
        local endY = yCoords[i + 1]
        hermiteSet[i] = (endY - startY) * (numValues - 1)
    end
    --normalizeValues(hermiteSet, avgValue, false)
    for i = 1, #hermiteSet do
        hermiteSet[i] = hermiteSet[i] + verticalShift
    end
    table.insert(hermiteSet, avgValue)
    return hermiteSet
end
