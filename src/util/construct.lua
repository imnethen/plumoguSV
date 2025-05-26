function table.construct(...)
    local tbl = {}
    for _, v in ipairs({ ... }) do
        table.insert(tbl, v)
    end
    setmetatable(tbl, { __index = table })
    return tbl
end
