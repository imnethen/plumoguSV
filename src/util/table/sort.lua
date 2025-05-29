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

--- Sorts a table given a sorting function.
---@generic T
---@param tbl T[]
---@param compFn fun(a: T, b: T): boolean
---@return T[]
function sort(tbl, compFn)
    newTbl = table.duplicate(tbl)
    table.sort(newTbl, compFn)
    return newTbl
end
