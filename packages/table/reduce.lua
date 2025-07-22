---Reduces an array element-wise using a given function.
---@generic T: string | number | boolean
---@generic V: string | number | boolean | string[] | number[] | boolean[] | { [string]: any }
---@param tbl T[]
---@param fn fun(accumulator: V, current: T): V
---@param initialValue V
---@return V
function table.reduce(tbl, fn, initialValue)
    local accumulator = initialValue
    for _, v in ipairs(tbl) do
        accumulator = fn(accumulator, v)
    end

    return accumulator
end
