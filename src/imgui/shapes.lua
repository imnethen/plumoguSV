-- Draws an equilateral triangle
-- Parameters
--    o           : imgui overlay drawlist [imgui.GetOverlayDrawList()]
--    centerPoint : center point of the triangle [Table]
--    size        : radius from triangle center to tip [Int/Float]
--    angle       : rotation angle of the triangle [Int/Float]
--    color       : color of the triangle represented as a uint [Int]
function drawEquilateralTriangle(o, centerPoint, size, angle, color)
    local angle2 = 2 * math.pi / 3 + angle
    local angle3 = 4 * math.pi / 3 + angle
    local x1 = centerPoint.x + size * math.cos(angle)
    local y1 = centerPoint.y + size * math.sin(angle)
    local x2 = centerPoint.x + size * math.cos(angle2)
    local y2 = centerPoint.y + size * math.sin(angle2)
    local x3 = centerPoint.x + size * math.cos(angle3)
    local y3 = centerPoint.y + size * math.sin(angle3)
    local p1 = vector.New(x1, y1)
    local p2 = vector.New(x2, y2)
    local p3 = vector.New(x3, y3)
    o.AddTriangleFilled(p1, p2, p3, color)
end

-- Draws a single glare
-- Parameters
--    o          : [imgui overlay drawlist]
--    coords     : (x, y) coordinates of the glare [Int/Float]
--    size       : size of the glare [Int/Float]
--    glareColor : uint color of the glare [Int]
--    auraColor  : uint color of the aura of the glare [Int]
function drawGlare(o, coords, size, glareColor, auraColor)
    local outerRadius = size
    local innerRadius = outerRadius / 7
    local innerPoints = {}
    local outerPoints = {}
    for i = 1, 4 do
        local angle = math.pi * ((2 * i + 1) / 4)
        local innerX = innerRadius * math.cos(angle)
        local innerY = innerRadius * math.sin(angle)
        local outerX = outerRadius * innerX
        local outerY = outerRadius * innerY
        innerPoints[i] = { innerX + coords.x, innerY + coords.y }
        outerPoints[i] = { outerX + coords.x, outerY + coords.y }
    end
    o.AddQuadFilled(innerPoints[1], outerPoints[2], innerPoints[3], outerPoints[4], glareColor)
    o.AddQuadFilled(outerPoints[1], innerPoints[2], outerPoints[3], innerPoints[4], glareColor)
    local circlePoints = 20
    local circleSize1 = size / 1.2
    local circleSize2 = size / 3
    o.AddCircleFilled(coords, circleSize1, auraColor, circlePoints)
    o.AddCircleFilled(coords, circleSize2, auraColor, circlePoints)
end

-- Draws a horizontal pill shape
-- Parameters
--    o              : imgui overlay drawlist [imgui.GetOverlayDrawList()]
--    point1         : (x, y) coordiates of the center of the pill's first circle [Table]
--    point2         : (x, y) coordiates of the center of the pill's second circle [Table]
--    radius         : radius of the circle of the pill [Int/Float]
--    color          : color of the pill represented as a uint [Int]
--    circleSegments : number of segments to draw for the circles in the pill [Int]
function drawHorizontalPillShape(o, point1, point2, radius, color, circleSegments)
    o.AddCircleFilled(point1, radius, color, circleSegments)
    o.AddCircleFilled(point2, radius, color, circleSegments)
    local rectangleStartCoords = relativePoint(point1, 0, radius)
    local rectangleEndCoords = relativePoint(point2, 0, -radius)
    o.AddRectFilled(rectangleStartCoords, rectangleEndCoords, color)
end