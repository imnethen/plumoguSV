-- Returns a set of stutter values [Table]
-- Parameters
--    stutterValue     : value of the stutter [Int/Float]
--    stutterDuration  : duration of the stutter (out of 100) [Int]
--    avgValue         : average value [Int/Float]
--    controlLastValue : whether or not the provided SV is the second SV [Boolean]
function generateStutterSet(stutterValue, stutterDuration, avgValue, controlLastValue)
    local durationPercent = stutterDuration / 100
    if controlLastValue then durationPercent = 1 - durationPercent end
    local otherValue = (avgValue - stutterValue * durationPercent) / (1 - durationPercent)
    local stutterSet = { stutterValue, otherValue, avgValue }
    if controlLastValue then stutterSet = { otherValue, stutterValue, avgValue } end
    return stutterSet
end