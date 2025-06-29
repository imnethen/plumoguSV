-- Creates the fix LN ends menu
function fixLNEndsMenu()
    helpMarker("If there is a negative SV at an LN end, the LN end will be flipped. This is " ..
        "noticable especially for arrow skins and is jarring. This tool will fix that.")

    addSeparator()
    simpleActionMenu("Fix flipped LN ends", 0, fixFlippedLNEnds, nil, nil)
end
