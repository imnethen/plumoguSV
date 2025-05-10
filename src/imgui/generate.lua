-- Returns a 2D (x, y) point [Table]
-- Parameters
--    x : x coordinate of the point [Int/Float]
--    y : y coordinate of the point [Int/Float]
function generate2DPoint(x, y) return { x = x, y = y } end

-- Generates and returns a particle [Table]
-- Parameters
--    x            : starting x coordiate of particle [Int/Float]
--    y            : starting y coordiate of particle [Int/Float]
--    xRange       : range of movement for the x coordiate of the particle [Int/Float]
--    yRange       : range of movement for the y coordiate of the particle [Int/Float]
--    endTime      : time to stop showing particle [Int/Float]
--    showParticle : whether or not to render/draw the particle [Boolean]
function generateParticle(x, y, xRange, yRange, endTime, showParticle)
    local particle = {
        x = x,
        y = y,
        xRange = xRange,
        yRange = yRange,
        endTime = endTime,
        showParticle = showParticle
    }
    return particle
end
