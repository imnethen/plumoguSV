-- Creates a copy-pastable text box
-- Parameters
--    text    : text to put above the box [String]
--    label   : label of the input text [String]
--    content : content to put in the box [String]
function CopiableBox(text, label, content)
    imgui.TextWrapped(text)
    imgui.PushItemWidth(imgui.GetContentRegionAvailWidth())
    imgui.InputText(label, content, #content, imgui_input_text_flags.AutoSelectAll)
    imgui.PopItemWidth()
    AddPadding()
end
