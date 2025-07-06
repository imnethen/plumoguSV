function matrix.rowLinComb(mtrx, rowIdx1, rowIdx2, row2Factor)
    for k, v in pairs(mtrx[rowIdx1]) do
        mtrx[rowIdx1][k] = v + mtrx[rowIdx2][k] * row2Factor
    end
end
