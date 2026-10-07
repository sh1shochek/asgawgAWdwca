-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.fromArray
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.fromArray
-- Decompile time: 0.14 ms

return function(a1) -- Line: 20 -- types: a1: table
    local v1 = table.create(#a1)
    for i, v in ipairs(a1) do
        v1[v] = true
    end
    return v1
end