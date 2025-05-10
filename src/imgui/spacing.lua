-- Adds vertical blank space/padding on the GUI
function addPadding()
    imgui.Dummy({ 0, 0 })
end

-- Creates a horizontal line separator on the GUI
function addSeparator()
    addPadding()
    imgui.Separator()
    addPadding()
end
