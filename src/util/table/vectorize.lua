---@diagnostic disable: return-type-mismatch
---Because we want the functions to be identity functions when passing in vectors instead of tables.

--- Converts a table of length 4 into a [`Vector4`](lua://Vector4).
---@param tbl number[] The table to convert.
---@return Vector4 vctr The output vector.
function table.vectorize4(tbl)
    if (type(tbl) == "userdata") then return tbl end
    return vector.New(tbl[1], tbl[2], tbl[3], tbl[4])
end

--- Converts a table of length 3 into a [`Vector3`](lua://Vector3).
---@param tbl number[] The table to convert.
---@return Vector3 vctr The output vector.
function table.vectorize3(tbl)
    if (type(tbl) == "userdata") then return tbl end
    return vector.New(tbl[1], tbl[2], tbl[3])
end

--- Converts a table of length 2 into a [`Vector2`](lua://Vector2).
---@param tbl number[] The table to convert.
---@return Vector2 vctr The output vector.
function table.vectorize2(tbl)
    if (type(tbl) == "userdata") then return tbl end
    return vector.New(tbl[1], tbl[2])
end
