-- ReplicatedStorage.Database.Components.Common.RemoveFromArray
-- Script path: ReplicatedStorage.Database.Components.Common.RemoveFromArray
-- Decompile time: 0.28 ms

return function(a1, a2) -- Line: 6 -- types: a1: table, a2: function
    local v1 = {}
    local v2 = #a1
    for i = 1, v2 do
        if a2(i, a1[i]) then
            table.insert(v1, i)
        end
    end
    for j = #v1, 1, -1 do
        table.remove(a1, v1[j])
    end
    return a1
end