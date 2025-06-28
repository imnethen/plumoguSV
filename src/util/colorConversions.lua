-- Converts an RGBA color value into uint (unsigned integer) and returns the converted value [Int]
-- Parameters
--    r : red value [Int]
--    g : green value [Int]
--    b : blue value [Int]
--    a : alpha value [Int]
function rgbaToUint(r, g, b, a) return a * 16 ^ 6 + b * 16 ^ 4 + g * 16 ^ 2 + r end

function rgbaToHexa(r, g, b, a)
  local hexadecimal = { "0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f" }
  local hexaStr = "#"
  for _, col in pairs({ r, g, b, a }) do
    hexaStr = hexaStr .. hexadecimal[math.floor(col / 16) + 1] .. hexadecimal[col % 16 + 1]
  end
  return hexaStr
end
