-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.reverse
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.reverse
-- Decompile time: 0.18 ms

return function(a1) -- Line: 17 -- types: a1: table
    local v1 = {}
    for i = #a1, 1, -1 do
        table.insert(v1, a1[i])
    end
    return v1
end