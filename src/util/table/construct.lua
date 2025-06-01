---Creates a new numerical table with a custom metatable, allowing for `:` syntactic sugar.
---@param ... any Any entries to put into the table.
---@return table tbl A table with the given entries.
function table.construct(...)
    local tbl = {}
    for _, v in ipairs({ ... }) do
        table.insert(tbl, v)
    end
    setmetatable(tbl, { __index = table })
    return tbl
end

---Creates a new numerical table with a custom metatable, allowing for `:` syntactic sugar. All elements will be the given item.
---@param item any The entry to use.
---@param num integer The number of entries to put into the table.
---@return table tbl A table with the given entries.
function table.constructRepeating(item, num)
    local tbl = table.construct()
    for _ = 1, num do
        tbl:insert(item)
    end
    return tbl
end
