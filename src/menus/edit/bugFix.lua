function tempBugFixMenu()
    imgui.PushTextWrapPos(200)
    imgui.TextWrapped(
        "note: this will not fix already broken regions, but will hopefully turn non-broken regions into things you can properly copy paste with no issues. ")
    imgui.NewLine()
    imgui.TextWrapped(
        "Copy paste bug is caused when two svs are on top of each other, because of the way Quaver handles dupe svs; the order in the .qua file determines rendering order. When duplicating stacked svs, the order has a chance to reverse, therefore making a different sv prioritized and messing up proper movement. Possible solutions include getting better at coding or merging SV before C+P.")
    imgui.NewLine()
    imgui.TextWrapped(
        " If you copy paste and the original SV gets broken, this likely means that the game changed the rendering order of duplicated svs on the original SV. Either try this tool, or use Edit SVs > Merge.")
    imgui.PopTextWrapPos()
    simpleActionMenu("Try to fix regions to become copy pastable", 0, tempBugFix, nil, nil)
end
