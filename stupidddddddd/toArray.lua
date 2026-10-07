-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.toArray
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.toArray
-- Decompile time: 0.13 ms

return function(a1) -- Line: 17 -- types: a1: table
    local v1 = {}
    for k, v in pairs(a1) do
        table.insert(v1, k)
    end
    return v1
end