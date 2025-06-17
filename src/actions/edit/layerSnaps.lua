function layerSnaps()
    for _, noteTime in pairs(uniqueNoteOffsetsBetweenSelected()) do
        print((noteTime - map.GetTimingPointAt(noteTime).StartTime) %
            (60000 / map.GetTimingPointAt(noteTime).Bpm))
    end
end
