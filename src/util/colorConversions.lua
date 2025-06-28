-- Converts an RGBA color value into uint (unsigned integer) and returns the converted value [Int]
-- Parameters
--    r : red value [Int]
--    g : green value [Int]
--    b : blue value [Int]
--    a : alpha value [Int]
function rgbaToUint(r, g, b, a) return a * 16 ^ 6 + b * 16 ^ 4 + g * 16 ^ 2 + r end

function rgbaToHexa(r, g, b, a)
  local hexaStr = ""
  for _, col in pairs({ r, g, b, a }) do
    hexaStr = hexaStr .. HEXADECIMAL[math.floor(col / 16) + 1] .. HEXADECIMAL[col % 16 + 1]
  end
  return hexaStr
end

function hexaToRgba(hexa)
  local rgbaTable = {}
  for i = 1, 8, 2 do
    table.insert(rgbaTable,
      table.indexOf(HEXADECIMAL, hexa:sub(i, i)) * 16 + table.indexOf(HEXADECIMAL, hexa:sub(i + 1, i + 1)) - 17)
  end
  return table.vectorize4(rgbaTable)
end
