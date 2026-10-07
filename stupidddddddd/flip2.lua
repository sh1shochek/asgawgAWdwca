-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.flip
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.flip
-- Decompile time: 0.14 ms

return function(a1) -- Line: 17 -- types: a1: table
    local v1 = {}
    for k, v in pairs(a1) do
        v1[v] = k
    end
    return v1
end