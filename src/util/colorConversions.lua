HEXADECIMAL = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" }

function rgbaToUint(r, g, b, a)
    local flr = math.floor
    return flr(a) * 16 ^ 6 + flr(b) * 16 ^ 4 + flr(g) * 16 ^ 2 + flr(r)
end

function rgbaToHexa(r, g, b, a)
    local flr = math.floor
    local hexaStr = ""
    for _, col in ipairs({ r, g, b, a }) do
        hexaStr = hexaStr .. HEXADECIMAL[math.floor(col / 16) + 1] .. HEXADECIMAL[flr(col) % 16 + 1]
    end
    return hexaStr
end

function hexaToRgba(hexa)
    local rgbaTable = {}
    for i = 1, 8, 2 do
        table.insert(rgbaTable,
            table.indexOf(HEXADECIMAL, hexa:charAt(i)) * 16 + table.indexOf(HEXADECIMAL, hexa:charAt(i + 1)) - 17)
    end
    return table.vectorize4(rgbaTable)
end

function rgbaToHsva(r, g, b, a)
    local colPrime = { r / 255, g / 255, b / 255 }

    local cMax = math.max(table.unpack(colPrime))
    local cMin = math.min(table.unpack(colPrime))

    local delta = cMax - cMin

    local maxIdx = 1
    local higherVal = colPrime[2]
    local lowerVal = colPrime[3]
    for i = 2, 3 do
        if (colPrime[i] == cMax) then
            maxIdx = i
            higherVal = colPrime[i % 3 + 1]
            lowerVal = colPrime[(i + 1) % 3 + 1]
        end
    end

    local h = 60 * ((higherVal - lowerVal) / delta * (2 * maxIdx - 2)) % 6
    local s = truthy(cMax) and delta / cMax or 0
    local v = cMax

    return vector.New(h, s, v, a)
end
