function matrix.scaleRow(mtrx, rowIdx, factor)
    for k, v in pairs(mtrx[rowIdx]) do
        mtrx[rowIdx][k] = v * factor
    end
end
