function svVibrato(menuVars, heightFunc)
    local offsets = uniqueNoteOffsetsBetweenSelected()
    local startOffset = offsets[1]
    local endOffset = offsets[#offsets]
    local svsToAdd = {} ---@type ScrollVelocity[]
    local svsToRemove = {} ---@type ScrollVelocity[]
    local svTimeIsAdded = {}

    local fps = VIBRATO_FRAME_RATES[menuVars.vibratoQuality]
    local fpsList = {}

    for i = 1, #offsets - 1 do
        local start = offsets[i]
        local next = offsets[i + 1]
        local startPos = (start - startOffset) / (endOffset - startOffset)
        local endPos = (next - startOffset) / (endOffset - startOffset)
        local posDifference = endPos - startPos
        local trueFPS = fps
        local lowestDecimal = 1e10
        for t = fps - 3, fps + 3 do
            local decimal = ((next - start) / 1000 * fps / 2) % 1
            if (decimal < lowestDecimal) then
                trueFPS = t
                lowestDecimal = decimal
            end
        end

        table.insert(fpsList, trueFPS)

        local teleportCount = math.floor((next - start) / 1000 * trueFPS / 2) * 2

        if (menuVars.oneSided) then
            for tp = 1, teleportCount do
                local x = (tp - 1) / (teleportCount)
                local offset = next * x + start * (1 - x)
                local height = heightFunc(((math.floor((tp - 1) / 2) * 2) / (teleportCount - 2)) * posDifference +
                    startPos)
                if (tp % 2 == 1) then
                    height = -height
                end
                prepareDisplacingSVs(offset, svsToAdd, svTimeIsAdded, nil,
                    height, 0)
            end
        else
            prepareDisplacingSVs(start, svsToAdd, svTimeIsAdded, nil,
                -heightFunc(startPos), 0)
            for tp = 2, teleportCount - 1 do
                local x = (tp - 1) / (teleportCount)
                local offset = next * x + start * (1 - x)
                local initHeight = heightFunc(((math.floor((tp - 2) / 2) * 2) / (teleportCount - 2)) * posDifference +
                    startPos)
                local newHeight = heightFunc(((math.floor((tp - 1) / 2) * 2) / (teleportCount - 2)) * posDifference +
                    startPos)
                local height = initHeight + newHeight
                if (tp % 2 == 1) then
                    height = -height
                end
                prepareDisplacingSVs(offset, svsToAdd, svTimeIsAdded, nil,
                    height, 0)
            end
            prepareDisplacingSVs(next, svsToAdd, svTimeIsAdded,
                heightFunc(((math.floor((teleportCount - 2) / 2) * 2) / teleportCount) * posDifference + startPos),
                nil, 0)
        end
    end

    print("s!", "Created " .. #svsToAdd .. " SVs at a frame rate of " .. table.average(fpsList, true) .. "fps.")

    getRemovableSVs(svsToRemove, svTimeIsAdded, startOffset, endOffset)
    removeAndAddSVs(svsToRemove, svsToAdd)
end
