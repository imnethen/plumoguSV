CONSONANTS = { "B", "C", "D", "F", "G", "H", "J", "K", "L", "M", "N", "P", "Q", "R", "S", "T", "V", "W", "X", "Z" }

---Very rudimentary function that returns a string depending on whether or not it should be plural.
---@param str string The inital string, which should be a noun (e.g. `bookmark`)
---@param val number The value, or count, of the noun, which will determine if it should be plural.
---@return string pluralizedStr A new string that is pluralized if `val ~= 1`.
function pluralize(str, val, pos)
    if (pos) then
        strEnding = str:sub(pos + 1, -1)
        str = str:sub(1, pos)
    end
    local finalStr = str .. "s"
    if (val == 1) then return str .. (strEnding or "") end
    local lastLetter = str:sub(-1):upper()
    local secondToLastLetter = str:sub(-2, -2):upper()
    if (lastLetter == "Y" and table.contains(CONSONANTS, secondToLastLetter)) then
        finalStr = str:sub(1, -2) .. "ies"
    end
    if (str:sub(-3):lower() == "quy") then
        finalStr = str:sub(1, -2) .. "ies"
    end
    if (table.contains({ "J", "S", "X", "Z" }, lastLetter) or table.contains({ "SH", "CH" }, str:sub(-2))) then
        finalStr = str .. "es"
    end

    return finalStr .. (strEnding or "")
end
