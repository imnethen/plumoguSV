-- Sorting function for numbers that returns whether a < b [Boolean]
-- Parameters
--    a : first number [Int/Float]
--    b : second number [Int/Float]
function sortAscending(a, b) return a < b end

-- Sorting function for SVs 'a' and 'b' that returns whether a.StartTime < b.StartTime [Boolean]
-- Parameters
--    a : first SV
--    b : second SV
function sortAscendingStartTime(a, b) return a.StartTime < b.StartTime end

-- Sorting function for objects 'a' and 'b' that returns whether a.time < b.time [Boolean]
-- Parameters
--    a : first object
--    b : second object
function sortAscendingTime(a, b) return a.time < b.time end
