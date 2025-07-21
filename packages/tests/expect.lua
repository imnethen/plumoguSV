function __toBeFunction(obtainedValue, expectedValue)
    return obtainedValue == expectedValue
end

function expect(expr)
    if (type(expr) ~= "function") then
        return {
            toBe = function(x) return __toBeFunction(x, expr) end
        }
    else
        local fn = expr
        return {
            of = function(expr)
                if (type(expr) == "table") then
                    return {
                        toBe = function(tbl)
                            if (#tbl ~= #expr) then return false end
                            for i = 1, #tbl do
                                if (not __toBeFunction(tbl[i], fn(expr[i]))) then return false end
                            end
                            return true
                        end
                    }
                else
                    return {
                        toBe = function(x) return __toBeFunction(x, fn(expr)) end
                    }
                end
            end
        }
    end
end
