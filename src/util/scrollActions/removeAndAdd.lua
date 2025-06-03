-- Removes and adds SVs
-- Parameters
--    svsToRemove : list of SVs to remove [Table]
--    svsToAdd    : list of SVs to add [Table]
function removeAndAddSVs(svsToRemove, svsToAdd)
    local tolerance = 0.035
    if #svsToAdd == 0 then return end
    for idx, sv in pairs(svsToRemove) do
        local baseSV = getSVStartTimeAt(sv.StartTime)
        if (math.abs(baseSV - sv.StartTime) > tolerance) then
            table.remove(svsToRemove, idx)
        end
    end
    local editorActions = {
        utils.CreateEditorAction(action_type.RemoveScrollVelocityBatch, svsToRemove),
        utils.CreateEditorAction(action_type.AddScrollVelocityBatch, svsToAdd)
    }
    actions.PerformBatch(editorActions)
    print("s!", "Created " .. #svsToAdd .. (#svsToAdd == 1 and " SV." or " SVs."))
end

function removeAndAddSSFs(ssfsToRemove, ssfsToAdd)
    if #ssfsToAdd == 0 then return end
    local editorActions = {
        utils.CreateEditorAction(action_type.RemoveScrollSpeedFactorBatch, ssfsToRemove),
        utils.CreateEditorAction(action_type.AddScrollSpeedFactorBatch, ssfsToAdd)
    }
    actions.PerformBatch(editorActions)
    print("s!", "Created " .. #ssfsToAdd .. (#ssfsToAdd == 1 and " SSF." or " SSFs."))
end
