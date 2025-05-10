function placePenisSV(settingVars)
    local startTime = uniqueNoteOffsetsBetweenSelected()[1]

    local svs = {}

    for j = 0, 1 do
        for i = 0, 100 do
            local time = startTime + i * settingVars.bWidth / 100 + j * (settingVars.sWidth + settingVars.bWidth)
            local circVal = math.sqrt(1 - ((i / 50) - 1) ^ 2)
            local trueVal = settingVars.bCurvature / 100 * circVal + (1 - settingVars.bCurvature / 100)

            table.insert(svs, utils.CreateScrollVelocity(time, trueVal))
        end
    end

    for i = 0, 100 do
        local time = startTime + settingVars.bWidth + i * settingVars.sWidth / 100

        local circVal = math.sqrt(1 - ((i / 50) - 1) ^ 2)
        local trueVal = settingVars.sCurvature / 100 * circVal + (3.75 - settingVars.sCurvature / 100)

        table.insert(svs, utils.CreateScrollVelocity(time, trueVal))
    end

    removeAndAddSVs(getSVsBetweenOffsets(startTime, startTime + settingVars.sWidth + settingVars.bWidth * 2), svs)
end
