<<<<<<< HEAD
function __toBeFunction(obtainedValue, expectedValue)
    if (type(obtainedValue) == "number" and type(expectedValue) == "number") then
        return math.abs(obtainedValue - expectedValue) < 1e-14
    end
=======
function __toEqualFunction(obtainedValue, expectedValue)
>>>>>>> performance
    return obtainedValue == expectedValue
end

function expect(expr)
<<<<<<< HEAD
    if (type(expr) ~= "function") then
        return {
            toBe = function(x) return __toBeFunction(x, expr), { x, expr } end
        }
    else
        local fn = expr
        return {
            of = function(x)
                if (type(x) == "table") then
                    return {
                        toBe = function(tbl)
                            if (#tbl ~= #x) then return false end
                            for i = 1, #tbl do
                                if (not __toBeFunction(tbl[i], fn(x[i]))) then return false, { i, tbl[i], fn(x[i]) } end
                            end
                            return true
                        end
                    }
                else
                    return {
                        toBe = function(y) return __toBeFunction(x, fn(y)) end
                    }
                end
=======
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
>>>>>>> performance
            end
        }
    end
end
