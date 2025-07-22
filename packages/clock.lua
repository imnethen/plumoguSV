clock = {}

---Returns true every `interval` ms.
---@param id string The unique identifier of the clock.
---@param interval integer The interval at which the clock should run.
---@return boolean ev True if the clock has reached its interval time.
function clock.listen(id, interval)
    local currentTime = state
        .UnixTime -- Avoid calling state global multiple times, which causes a heavy load on performance
    if (not state.GetValue(table.concat({ "clock-", id }))) then
        state.SetValue(table.concat({ "clock-", id }),
            currentTime)
    end
    local previousExecutionTime = state.GetValue("clock-" .. id)
    if (currentTime - previousExecutionTime > interval) then
        state.SetValue("clock-" .. id, currentTime)
        return true
    end
    return false
end
