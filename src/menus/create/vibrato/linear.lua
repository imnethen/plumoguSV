function linearVibratoMenu(settingVars)
    customSwappableNegatableInputFloat2(settingVars, "lowerStart", "lowerEnd", "Lower S/E SSFs")
    customSwappableNegatableInputFloat2(settingVars, "higherStart", "higherEnd", "Higher S/E SSFs")

    simpleActionMenu("Place SSFs", 2, linearSSFVibrato, nil, settingVars)
end
