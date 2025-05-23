function table.contains(tbl, item)
    for _, v in pairs(tbl) do
        if (v == item) then return true end
    end
    return false
end
