function __toBeFunction(obtainedValue, expectedValue)
    return obtainedValue == expectedValue
end

function expect(expr)
    return {
        toBe = function(x) return __toBeFunction(x, expr) end
    }
end

function expect(func)
    return {
        of = function(expr)
            if (type(expr) == "table") then
                return {
                    toBe = function(tbl)
                        if (#tbl ~= #expr) then return false end
                        for i = 1, #tbl do
                            if (not __toBeFunction(tbl[i], func(expr[i]))) then return false end
                        end
                        return true
                    end
                }
            else
                return {
                    toBe = function(x) return __toBeFunction(x, expr) end
                }
            end
        end
    }
end
