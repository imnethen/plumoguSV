-- Returns a set of exponential values [Table]
-- Parameters
--    behavior      : behavior of the values (increase/speed up, or decrease/slow down) [String]
--    numValues     : total number of values in the exponential set [Int]
--    avgValue      : average value of the set [Int/Float]
--    intensity     : value determining sharpness/rapidness of exponential change [Int/Float]
--    verticalShift : constant to add to each value in the set at very the end [Int/Float]
function generateExponentialSet(behavior, numValues, avgValue, intensity, verticalShift)
    avgValue = avgValue - verticalShift
    local exponentialIncrease = (behavior == "Speed up")
    local exponentialSet = {}
    -- reduce intensity scaling to produce more useful/practical values
    intensity = intensity / 5
    for i = 0, numValues - 1 do
        local x
        if exponentialIncrease then
            x = (i + 0.5) * intensity / numValues
        else
            x = (numValues - i - 0.5) * intensity / numValues
        end
        local y = math.exp(x - 1) / intensity
        table.insert(exponentialSet, y)
    end
    normalizeValues(exponentialSet, avgValue, false)
    for i = 1, #exponentialSet do
        exponentialSet[i] = exponentialSet[i] + verticalShift
    end
    return exponentialSet
end

function generateExponentialSet2(behavior, numValues, startValue, endValue, intensity)
    local exponentialSet = {}
    -- reduce intensity scaling to produce more useful/practical values
    intensity = intensity / 5
    for i = 0, numValues - 1 do
        fx = startValue
        local x = i / (numValues - 1)
        if (behavior == "Slow down" and startValue ~= endValue) then
            local k = 1 / (math.exp(intensity * math.abs(endValue - startValue)) - 1)
            fx = 1 / intensity * math.log((x + k) / (1 + k))
            if (startValue > endValue) then
                fx = -fx
            end
            fx = fx + endValue
        else
            local k = (endValue - startValue) / (math.exp(intensity) - 1)
            fx = k * math.exp(intensity * x) + startValue - k
        end
        table.insert(exponentialSet, fx)
    end
    return exponentialSet
end
