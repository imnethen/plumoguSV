-- Returns a set of cubic bezier values [Table]
-- Parameters
--    x1            : x-coordinate of the first (inputted) cubic bezier point [Int/Float]
--    y1            : y-coordinate of the first (inputted) cubic bezier point [Int/Float]
--    x2            : x-coordinate of the second (inputted) cubic bezier point [Int/Float]
--    y2            : y-coordinate of the second (inputted) cubic bezier point [Int/Float]
--    avgValue      : average value of the set [Int/Float]
--    numValues     : total number of values in the bezier set [Int]
--    verticalShift : constant to add to each value in the set at very the end [Int/Float]
function generateBezierSet(x1, y1, x2, y2, avgValue, numValues, verticalShift)
    avgValue = avgValue - verticalShift
    local startingTimeGuess = 0.5
    local timeGuesses = {}
    local targetXPositions = {}
    local iterations = 20
    for i = 1, numValues do
        table.insert(timeGuesses, startingTimeGuess)
        table.insert(targetXPositions, i / numValues)
    end
    for i = 1, iterations do
        local timeIncrement = 0.5 ^ (i + 1)
        for j = 1, numValues do
            local xPositionGuess = math.cubicBezier(x1, x2, timeGuesses[j])
            if xPositionGuess < targetXPositions[j] then
                timeGuesses[j] = timeGuesses[j] + timeIncrement
            elseif xPositionGuess > targetXPositions[j] then
                timeGuesses[j] = timeGuesses[j] - timeIncrement
            end
        end
    end
    local yPositions = { 0 }
    for i = 1, #timeGuesses do
        local yPosition = math.cubicBezier(y1, y2, timeGuesses[i])
        table.insert(yPositions, yPosition)
    end
    local bezierSet = {}
    for i = 1, #yPositions - 1 do
        local slope = (yPositions[i + 1] - yPositions[i]) * numValues
        table.insert(bezierSet, slope)
    end
    table.normalize(bezierSet, avgValue, false)
    for i = 1, #bezierSet do
        bezierSet[i] = bezierSet[i] + verticalShift
    end
    return bezierSet
end
