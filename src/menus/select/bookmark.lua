
function selectBookmarkMenu()
    local bookmarks = map.bookmarks

    local selectedIndex = state.GetValue("selectedIndex") or 0
    local searchTerm = state.GetValue("searchTerm") or ""
    local filterTerm = state.GetValue("filterTerm") or ""
    local times = {}


    if (#bookmarks == 0) then
        imgui.TextWrapped("There are no bookmarks! Add one to navigate.")
    else
        imgui.PushItemWidth(70)

        _, searchTerm = imgui.InputText("Search", searchTerm, 4096)
        imgui.SameLine()
        _, filterTerm = imgui.InputText("Ignore", filterTerm, 4096)

        imgui.Columns(3)

        imgui.Text("Time")
        imgui.NextColumn()
        imgui.Text("Bookmark Label")
        imgui.NextColumn()
        imgui.Text("Leap")
        imgui.NextColumn()

        imgui.Separator()


        local skippedBookmarks = 0
        local skippedIndices = 0

        for idx, v in pairs(bookmarks) do
            if (v.StartTime < 0) then
                skippedBookmarks = skippedBookmarks + 1
                skippedIndices = skippedIndices + 1
                goto continue
            end

            if (searchTerm:len() > 0) and (not v.Note:find(searchTerm)) then
                skippedBookmarks = skippedBookmarks + 1
                goto continue
            end
            if (filterTerm:len() > 0) and (v.Note:find(filterTerm)) then
                skippedBookmarks = skippedBookmarks + 1
                goto continue
            end

            vPos = 126.5 + (idx - skippedBookmarks) * 32

            imgui.SetCursorPosY(vPos)

            table.insert(times, v.StartTime)
            imgui.Text(v.StartTime)
            imgui.NextColumn()

            imgui.SetCursorPosY(vPos)

            if (imgui.CalcTextSize(v.Note)[1] > 110) then
                local note = v.Note
                while (imgui.CalcTextSize(note)[1] > 85) do
                    note = note:sub(1, #note - 1)
                end
                imgui.Text(note .. "...")
            else
                imgui.Text(v.Note)
            end
            imgui.NextColumn()


            if (imgui.Button("Go to #" .. idx - skippedIndices, { 65, 24 })) then
                actions.GoToObjects(v.StartTime)
            end
            imgui.NextColumn()

            if (idx ~= #bookmarks) then imgui.Separator() end
            ::continue::
        end

        local maxTimeLength = #tostring(math.max(table.unpack(times) or 0))

        imgui.SetColumnWidth(0, maxTimeLength * 10.25)
        imgui.SetColumnWidth(1, 110)
        imgui.SetColumnWidth(2, 80)

        imgui.PopItemWidth()
        imgui.Columns(1)
    end


    state.SetValue("selectedIndex", selectedIndex)
    state.SetValue("searchTerm", searchTerm)
    state.SetValue("filterTerm", filterTerm)
end
