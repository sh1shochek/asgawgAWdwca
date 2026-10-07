-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeIndices
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeIndices
-- Decompile time: 0.36 ms

return function(a1, ...) -- Line: 19 -- types: a1: table
    local v1 = #a1
    local v2 = {}
    local v3 = {}
    for i, v in ipairs({...}) do
        if v < 1 then
            v = v + v1
        end
        v2[v] = true
    end
    for i2, i3 in ipairs(a1) do
        if not v2[i2] then
            table.insert(v3, i3)
        end
    end
    return v3
end