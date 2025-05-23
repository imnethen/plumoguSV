CREATE_TYPES = { -- general categories of SVs to place
    "Standard",
    "Special",
    "Still",
    "Vibrato",
}

-- Creates the "Place SVs" tab
-- Parameters
--    globalVars : list of variables used globally across all menus [Table]
function createSVTab(globalVars)
    if (globalVars.advancedMode) then chooseCurrentScrollGroup(globalVars) end
    if (devMode and not CREATE_TYPES[5]) then
        table.insert(CREATE_TYPES, "Automate")
    end
    choosePlaceSVType(globalVars)
    local placeType = CREATE_TYPES[globalVars.placeTypeIndex]
    if placeType == "Standard" then placeStandardSVMenu(globalVars) end
    if placeType == "Special" then placeSpecialSVMenu(globalVars) end
    if placeType == "Still" then placeStillSVMenu(globalVars) end
    if placeType == "Vibrato" then placeVibratoSVMenu(globalVars) end
    if placeType == "Automate" and devMode then automateSVMenu(globalVars) end
end
