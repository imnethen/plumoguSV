-- Draws the currently selected cursor trail
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function drawCursorTrail(globalVars)
    local o = imgui.GetOverlayDrawList()
    local m = getCurrentMousePosition()
    local t = imgui.GetTime()
    local sz = state.WindowSize
    local cursorTrail = CURSOR_TRAILS[globalVars.cursorTrailIndex]
    if cursorTrail ~= "Dust" then state.SetValue("initializeDustParticles", false) end
    if cursorTrail ~= "Sparkle" then state.SetValue("initializeSparkleParticles", false) end

    if cursorTrail == "None" then return end
    if cursorTrail == "Snake" then drawSnakeTrail(globalVars, o, m, t, sz) end
    if cursorTrail == "Dust" then drawDustTrail(globalVars, o, m, t, sz) end
    if cursorTrail == "Sparkle" then drawSparkleTrail(globalVars, o, m, t, sz) end
end

-- Draws the "Snake" cursor trail
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    o          : [imgui overlay drawlist]
--    m          : current (x, y) mouse position [Table]
--    t          : current in-game plugin time [Int/Float]
--    sz         : dimensions of the window for Quaver [Table]
function drawSnakeTrail(globalVars, o, m, t, _)
    local trailPoints = globalVars.cursorTrailPoints
    local snakeTrailPoints = {}
    initializeSnakeTrailPoints(snakeTrailPoints, m, MAX_CURSOR_TRAIL_POINTS)
    getVariables("snakeTrailPoints", snakeTrailPoints)
    local needTrailUpdate = checkIfFrameChanged(t, globalVars.effectFPS)
    updateSnakeTrailPoints(snakeTrailPoints, needTrailUpdate, m, trailPoints,
        globalVars.snakeSpringConstant)
    saveVariables("snakeTrailPoints", snakeTrailPoints)
    local trailShape = TRAIL_SHAPES[globalVars.cursorTrailShapeIndex]
    renderSnakeTrailPoints(o, m, snakeTrailPoints, trailPoints, globalVars.cursorTrailSize,
        globalVars.cursorTrailGhost, trailShape)
end

-- Initializes the points of the snake trail
-- Parameters
--    snakeTrailPoints : list of points used for the snake trail [Table]
--    m                : current (x, y) mouse position [Table]
--    trailPoints      : number of trail points for the snake trail [Int]
function initializeSnakeTrailPoints(snakeTrailPoints, m, trailPoints)
    if state.GetValue("initializeSnakeTrail") then
        for i = 1, trailPoints do
            snakeTrailPoints[i] = {}
        end
        return
    end
    for i = 1, trailPoints do
        snakeTrailPoints[i] = generate2DPoint(m.x, m.y)
    end
    state.SetValue("initializeSnakeTrail", true)
end

-- Updates the points of the snake trail
-- Parameters
--    snakeTrailPoints    : list of data used for the snake trail [Table]
--    needTrailUpdate     : whether or not the trail info needs to be updated [Boolean]
--    m                   : current (x, y) mouse position [Table]
--    trailPoints         : number of trail points to update [Int]
--    snakeSpringConstant : how much to update the trail points per frame (0.01 to 1) [Int/Float]
function updateSnakeTrailPoints(snakeTrailPoints, needTrailUpdate, m, trailPoints,
                                snakeSpringConstant)
    if not needTrailUpdate then return end
    for i = trailPoints, 1, -1 do
        local currentTrailPoint = snakeTrailPoints[i]
        if i == 1 then
            currentTrailPoint.x = m.x
            currentTrailPoint.y = m.y
        else
            local lastTrailPoint = snakeTrailPoints[i - 1]
            local xChange = lastTrailPoint.x - currentTrailPoint.x
            local yChange = lastTrailPoint.y - currentTrailPoint.y
            currentTrailPoint.x = currentTrailPoint.x + snakeSpringConstant * xChange
            currentTrailPoint.y = currentTrailPoint.y + snakeSpringConstant * yChange
        end
    end
end

-- Draws the points of the snake trail
-- Parameters
--    o                : [imgui overlay drawlist]
--    m                : current (x, y) mouse position [Table]
--    snakeTrailPoints : list of data used for the snake trail [Table]
--    trailPoints      : number of trail points to draw [Int]
--    cursorTrailSize  : size of the cursor trail points [Int]
--    cursorTrailGhost : whether or not to make later trail points more transparent [Boolean]
--    trailShape       : shape of the trail points to draw [String]
function renderSnakeTrailPoints(o, m, snakeTrailPoints, trailPoints, cursorTrailSize,
                                cursorTrailGhost, trailShape)
    for i = 1, trailPoints do
        local point = snakeTrailPoints[i]
        local alpha = 255
        if not cursorTrailGhost then
            alpha = math.floor(255 * (trailPoints - i) / (trailPoints - 1))
        end
        local color = rgbaToUint(255, 255, 255, alpha)
        if trailShape == "Circles" then
            local coords = { point.x, point.y }
            o.AddCircleFilled(coords, cursorTrailSize, color)
        elseif trailShape == "Triangles" then
            drawTriangleTrailPoint(o, m, point, cursorTrailSize, color)
        end
    end
end

-- Draws a point of the triangle snake trail
-- Parameters
--    o               : [imgui overlay drawlist]
--    m               : current (x, y) mouse position [Table]
--    point           : (x, y) coordinates [Table]
--    cursorTrailSize : size of the cursor trail points [Int]
--    color           : color of the triangle represented as a uint [Int]
function drawTriangleTrailPoint(o, m, point, cursorTrailSize, color)
    local dx = m.x - point.x
    local dy = m.y - point.y
    if dx == 0 and dy == 0 then return end
    local angle = math.pi / 2
    if dx ~= 0 then angle = math.atan(dy / dx) end
    if dx < 0 then angle = angle + math.pi end
    if dx == 0 and dy < 0 then angle = angle + math.pi end
    drawEquilateralTriangle(o, point, cursorTrailSize, angle, color)
end

-- Draws the "Dust" cursor trail
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    o          : [imgui overlay drawlist]
--    m          : current (x, y) mouse position [Table]
--    t          : current in-game plugin time [Int/Float]
--    sz         : dimensions of the window for Quaver [Table]
function drawDustTrail(globalVars, o, m, t, sz)
    local dustSize = math.floor(sz[2] / 120)
    local dustDuration = 0.4
    local numDustParticles = 20
    local dustParticles = {}
    initializeDustParticles(sz, t, dustParticles, numDustParticles, dustDuration)
    getVariables("dustParticles", dustParticles)
    updateDustParticles(t, m, dustParticles, dustDuration, dustSize)
    saveVariables("dustParticles", dustParticles)
    renderDustParticles(globalVars.rgbPeriod, o, t, dustParticles, dustDuration, dustSize)
end

-- Initializes the particles of the dust trail
-- Parameters
--    sz               : dimensions of the window for Quaver [Table]
--    t                : current in-game plugin time [Int/Float]
--    dustParticles    : list of dust particles [Table]
--    numDustParticles : total number of dust particles [Int]
--    dustDuration     : lifespan of a dust particle [Int/Float]
function initializeDustParticles(_, t, dustParticles, numDustParticles, dustDuration)
    if state.GetValue("initializeDustParticles") then
        for i = 1, numDustParticles do
            dustParticles[i] = {}
        end
        return
    end
    for i = 1, numDustParticles do
        local endTime = t + (i / numDustParticles) * dustDuration
        local showParticle = false
        dustParticles[i] = generateParticle(0, 0, 0, 0, endTime, showParticle)
    end
    state.SetValue("initializeDustParticles", true)
    saveVariables("dustParticles", dustParticles)
end

-- Updates the particles of the dust trail
-- Parameters
--    t             : current in-game plugin time [Int/Float]
--    m             : current (x, y) mouse position [Table]
--    dustParticles : list of dust particles [Table]
--    dustDuration  : lifespan of a dust particle [Int/Float]
--    dustSize      : size of a dust particle [Int/Float]
function updateDustParticles(t, m, dustParticles, dustDuration, dustSize)
    local yRange = 8 * dustSize * (math.random() - 0.5)
    local xRange = 8 * dustSize * (math.random() - 0.5)
    for i = 1, #dustParticles do
        local dustParticle = dustParticles[i]
        local timeLeft = dustParticle.endTime - t
        if timeLeft < 0 then
            local endTime = t + dustDuration
            local showParticle = checkIfMouseMoved(getCurrentMousePosition())
            dustParticles[i] = generateParticle(m.x, m.y, xRange, yRange, endTime, showParticle)
        end
    end
end

-- Draws the particles of the dust trail
-- Parameters
--    rgbPeriod     : length in seconds of one RGB color cycle [Int/Float]
--    o             : [imgui overlay drawlist]
--    t             : current in-game plugin time [Int/Float]
--    dustParticles : list of dust particles [Table]
--    dustDuration  : lifespan of a dust particle [Int/Float]
--    dustSize      : size of a dust particle [Int/Float]
function renderDustParticles(rgbPeriod, o, t, dustParticles, dustDuration, dustSize)
    local currentRGBColors = getCurrentRGBColors(rgbPeriod)
    local currentRed = math.round(255 * currentRGBColors.red, 0)
    local currentGreen = math.round(255 * currentRGBColors.green, 0)
    local currentBlue = math.round(255 * currentRGBColors.blue, 0)
    for i = 1, #dustParticles do
        local dustParticle = dustParticles[i]
        if dustParticle.showParticle then
            local time = 1 - ((dustParticle.endTime - t) / dustDuration)
            local dustX = dustParticle.x + dustParticle.xRange * time
            local dy = dustParticle.yRange * math.quadraticBezier(0, time)
            local dustY = dustParticle.y + dy
            local dustCoords = vector.New(dustX, dustY)
            local alpha = math.round(255 * (1 - time), 0)
            local dustColor = rgbaToUint(currentRed, currentGreen, currentBlue, alpha)
            o.AddCircleFilled(dustCoords, dustSize, dustColor)
        end
    end
end

-- Draws the "Sparkle" cursor trail
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
--    o          : [imgui overlay drawlist]
--    m          : current (x, y) mouse position [Table]
--    t          : current in-game plugin time [Int/Float]
--    sz         : dimensions of the window for Quaver [Table]
function drawSparkleTrail(_, o, m, t, sz)
    local sparkleSize = 10
    local sparkleDuration = 0.3
    local numSparkleParticles = 10
    local sparkleParticles = {}
    initializeSparkleParticles(sz, t, sparkleParticles, numSparkleParticles, sparkleDuration)
    getVariables("sparkleParticles", sparkleParticles)
    updateSparkleParticles(t, m, sparkleParticles, sparkleDuration, sparkleSize)
    saveVariables("sparkleParticles", sparkleParticles)
    renderSparkleParticles(o, t, sparkleParticles, sparkleDuration, sparkleSize)
end

-- Initializes the particles of the sparkle trail
-- Parameters
--    sz                  : dimensions of the window for Quaver [Table]
--    t                   : current in-game plugin time [Int/Float]
--    sparkleParticles    : list of sparkle particles [Table]
--    numSparkleParticles : total number of sparkle particles [Int]
--    sparkleDuration     : lifespan of a sparkle particle [Int/Float]
function initializeSparkleParticles(_, t, sparkleParticles, numSparkleParticles, sparkleDuration)
    if state.GetValue("initializeSparkleParticles") then
        for i = 1, numSparkleParticles do
            sparkleParticles[i] = {}
        end
        return
    end
    for i = 1, numSparkleParticles do
        local endTime = t + (i / numSparkleParticles) * sparkleDuration
        local showParticle = false
        sparkleParticles[i] = generateParticle(0, 0, 0, 0, endTime, showParticle)
    end
    state.SetValue("initializeSparkleParticles", true)
    saveVariables("sparkleParticles", sparkleParticles)
end

-- Updates the particles of the sparkle trail
-- Parameters
--    t                : current in-game plugin time [Int/Float]
--    m                : current (x, y) mouse position [Table]
--    sparkleParticles : list of sparkle particles [Table]
--    sparkleDuration  : lifespan of a sparkle particle [Int/Float]
--    sparkleSize      : size of a sparkle particle [Int/Float]
function updateSparkleParticles(t, m, sparkleParticles, sparkleDuration, sparkleSize)
    for i = 1, #sparkleParticles do
        local sparkleParticle = sparkleParticles[i]
        local timeLeft = sparkleParticle.endTime - t
        if timeLeft < 0 then
            local endTime = t + sparkleDuration
            local showParticle = checkIfMouseMoved(getCurrentMousePosition())
            local randomX = m.x + sparkleSize * 3 * (math.random() - 0.5)
            local randomY = m.y + sparkleSize * 3 * (math.random() - 0.5)
            local yRange = 6 * sparkleSize
            sparkleParticles[i] = generateParticle(randomX, randomY, 0, yRange, endTime,
                showParticle)
        end
    end
end

-- Draws the particles of the sparkle trail
-- Parameters
--    o                : [imgui overlay drawlist]
--    t                : current in-game plugin time [Int/Float]
--    sparkleParticles : list of sparkle particles [Table]
--    sparkleDuration  : lifespan of a sparkle particle [Int/Float]
--    sparkleSize      : size of a sparkle particle [Int/Float]
function renderSparkleParticles(o, t, sparkleParticles, sparkleDuration, sparkleSize)
    for i = 1, #sparkleParticles do
        local sparkleParticle = sparkleParticles[i]
        if sparkleParticle.showParticle then
            local time = 1 - ((sparkleParticle.endTime - t) / sparkleDuration)
            local sparkleX = sparkleParticle.x + sparkleParticle.xRange * time
            local dy = -sparkleParticle.yRange * math.quadraticBezier(0, time)
            local sparkleY = sparkleParticle.y + dy
            local sparkleCoords = vector.New(sparkleX, sparkleY)
            -- local alpha = math.round(255 * (1 - time), 0)
            local white = rgbaToUint(255, 255, 255, 255)
            local actualSize = sparkleSize * (1 - math.quadraticBezier(0, time))
            local sparkleColor = rgbaToUint(255, 255, 100, 30)
            drawGlare(o, sparkleCoords, actualSize, white, sparkleColor)
        end
    end
end
