CREATE_TYPES = { -- general categories of SVs to place
    "Standard",
    "Special",
    "Still",
    "Vibrato",
}


function createSVTab(globalVars)
    if (globalVars.advancedMode) then chooseCurrentScrollGroup(globalVars) end
    choosePlaceSVType(globalVars)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Standard" then placeStandardSVMenu(globalVars) end
    if placeType == "Special" then placeSpecialSVMenu(globalVars) end
    if placeType == "Still" then placeStillSVMenu(globalVars) end
    if placeType == "Vibrato" then placeVibratoSVMenu(globalVars, false) end
end
