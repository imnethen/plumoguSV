-- Returns menuVars for the menu at Place SVs > Standard
function getStandardPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1,
        svMultipliers = {},
        svDistances = {},
        svGraphStats = createSVGraphStats(),
        svStats = createSVStats(),
        interlace = false,
        interlaceRatio = -0.5
    }
    getVariables("placeStandardMenu", menuVars)
    return menuVars
end

-- Returns menuVars for the menu at Place SVs > Special
function getSpecialPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1
    }
    getVariables("placeSpecialMenu", menuVars)
    return menuVars
end

-- Returns menuVars for the menu at Place SVs > Still
function getStillPlaceMenuVars()
    local menuVars = {
        svTypeIndex = 1,
        noteSpacing = 1,
        stillTypeIndex = 1,
        stillDistance = 0,
        stillBehavior = 1,
        prePlaceDistances = {},
        svMultipliers = {},
        svDistances = {},
        svGraphStats = createSVGraphStats(),
        svStats = createSVStats(),
        interlace = false,
        interlaceRatio = -0.5
    }
    getVariables("placeStillMenu", menuVars)
    return menuVars
end
