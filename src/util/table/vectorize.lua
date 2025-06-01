--- Converts a table of length 4 into a [`Vector4`](lua://Vector4).
---@param tbl number[]
---@return Vector4
function table.vectorize4(tbl)
    return vector.New(tbl[1], tbl[2], tbl[3], tbl[4])
end

--- Converts a table of length 3 into a [`Vector3`](lua://Vector3).
---@param tbl number[]
---@return Vector3
function table.vectorize3(tbl)
    return vector.New(tbl[1], tbl[2], tbl[3])
end

--- Converts a table of length 2 into a [`Vector2`](lua://Vector2).
---@param tbl number[]
---@return Vector2
function table.vectorize2(tbl)
    return vector.New(tbl[1], tbl[2])
end
