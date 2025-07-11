---Sorting function for sorting objects by their numerical value. Should be passed into [`table.sort`](lua://table.sort).
---@param a number
---@param b number
function sortAscending(a, b) return a < b end

---Sorting function for sorting objects by their `startTime` property. Should be passed into [`table.sort`](lua://table.sort).
---@param a { StartTime: number }
---@param b { StartTime: number }
function sortAscendingStartTime(a, b) return a.StartTime < b.StartTime end

---Sorting function for sorting objects by their `time` property. Should be passed into [`table.sort`](lua://table.sort).
---@param a { time: number }
---@param b { time: number }
---@return boolean
function sortAscendingTime(a, b) return a.time < b.time end

---Sorts a table given a sorting function. Should be passed into [`table.sort`](lua://table.sort).
---@generic T
---@param tbl T[] The table to sort.
---@param compFn fun(a: T, b: T): boolean A comparison function. Given two elements `a` and `b`, how should they be sorted?
---@return T[] sortedTbl A sorted table.
function sort(tbl, compFn)
    newTbl = table.duplicate(tbl)
    table.sort(newTbl, compFn)
    return newTbl
end
