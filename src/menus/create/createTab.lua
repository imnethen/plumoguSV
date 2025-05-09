CREATE_TYPES = { -- general categories of SVs to place
    "Standard",
    "Special",
    "Still"
}

-- Creates the "Place SVs" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function createSVTab(globalVars)
    if (globalVars.advancedMode) then chooseCurrentScrollGroup(globalVars) end
    choosePlaceSVType(globalVars)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Standard" then placeStandardSVMenu(globalVars) end
    if placeType == "Special" then placeSpecialSVMenu(globalVars) end
    if placeType == "Still" then placeStillSVMenu(globalVars) end
end