-- Adds vertical blank space/padding on the GUI
function addPadding()
    imgui.Dummy(vector.New(0, 0))
end

function addSeparator()
    addPadding()
    imgui.Separator()
    addPadding()
end
