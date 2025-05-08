function getVariables(listName, variables)
    for key, _ in pairs(variables) do
        if (state.GetValue(listName .. key) ~= nil) then
            variables[key] = state.GetValue(listName .. key) -- Changed because default setting of true would always override
        end
    end
end

function saveVariables(listName, variables)
    for key, value in pairs(variables) do
        state.SetValue(listName .. key, value)
    end
end