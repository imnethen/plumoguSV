function convertSVSSFMenu()
    local menuVars = getMenuVars("convertSVSSF")

    imgui.AlignTextToFramePadding()
    imgui.Text("Direction:")
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("SSF -> SV", not menuVars.conversionDirection) then
        menuVars.conversionDirection = false
    end
    imgui.SameLine(0, RADIO_BUTTON_SPACING)
    if imgui.RadioButton("SV -> SSF", menuVars.conversionDirection) then
        menuVars.conversionDirection = true
    end

    saveVariables("convertSVSSFMenu", menuVars)

    simpleActionMenu(menuVars.conversionDirection and "Convert SVs -> SSFs" or "Convert SSFs -> SVs", 2, convertSVSSF,
        nil, menuVars, false, false)
end