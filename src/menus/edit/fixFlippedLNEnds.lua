-- Creates the fix LN ends menu
function fixLNEndsMenu()
    local menuVars = { -- TODO: CONVERT TO STATE
        fixedText = "No flipped LN ends fixed yet"
    }
    getVariables("fixLNEndsMenu", menuVars)
    imgui.Text(menuVars.fixedText)
    helpMarker("If there is a negative SV at an LN end, the LN end will be flipped. This is " ..
        "noticable especially for arrow skins and is jarring. This tool will fix that.")

    addSeparator()
    simpleActionMenu("Fix flipped LN ends", 0, fixFlippedLNEnds, nil, menuVars)
    saveVariables("fixLNEndsMenu", menuVars)
end
