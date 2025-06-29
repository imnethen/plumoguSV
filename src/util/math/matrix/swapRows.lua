function matrix.swapRows(mtrx, rowIdx1, rowIdx2)
    local temp = mtrx[rowIdx1]
    mtrx[rowIdx1] = mtrx[rowIdx2]
    mtrx[rowIdx2] = temp
end
