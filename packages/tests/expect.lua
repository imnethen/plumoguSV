function __toEqualFunction(obtainedValue, expectedValue)
    return obtainedValue == expectedValue
end

function expect(expr)
    return {
        toEqual = function(x) return __toEqualFunction(x, expr) end
    }
end

function expect(func)
    return {
        of = function(expr)
            if (type(expr) == "table") then
                return {
                    toEqual = function(tbl)
                        if (#tbl ~= #expr) then return false end
                        for i = 1, #tbl do
                            if (not __toEqualFunction(tbl[i], func(expr[i]))) then return false end
                        end
                        return true
                    end
                }
            else
                return {
                    toEqual = function(x) return __toEqualFunction(x, expr) end
                }
            end
        end
    }
end
