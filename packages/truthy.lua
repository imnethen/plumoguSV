---Returns `true` if given a string called "true", given a number greater than 0, given a table with an element, or is given `true`. Otherwise, returns `false`.
---@param param any The parameter to truthify.
---@return boolean truthy The truthy value of the parameter.
function truthy(param)
    local t = type(param)
    if (t == "string") then
        return param:lower() == "true" and true or false
    else
        if t == "number" then
            return param > 0 and true or false
        else
            if t == "table" or t == "userdata" then
                return #param > 0 and true or false
            else
                if t == "boolean" then
                    return param
                else
                    return false
                end
            end
        end
    end
end
