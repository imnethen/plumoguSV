---Given a matrix A and vector B, returns a vector x such that Ax=B.
---@param mtrx number[][]
---@param vctr number[]
function matrix.solve(mtrx, vctr)
    if (#vctr ~= #mtrx) then return end
    local augMtrx = table.duplicate(mtrx)
    for i, n in pairs(vctr) do
        table.insert(augMtrx[i], n)
    end

    for i = 1, #mtrx do
        matrix.scaleRow(augMtrx, i, 1 / augMtrx[i][i])
        for j = i + 1, #mtrx do
            matrix.rowLinComb(augMtrx, j, i, -augMtrx[j][i])
        end
    end

    for i = #mtrx, 2, -1 do
        for j = i - 1, 1, -1 do
            matrix.rowLinComb(augMtrx, j, i, -augMtrx[j][i])
        end
    end
end
