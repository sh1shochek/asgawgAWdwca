-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.fromEntries
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.fromEntries
-- Decompile time: 0.13 ms

return function(a1) -- Line: 17 -- types: a1: table
    local v1 = {}
    for i, v in ipairs(a1) do
        v1[v[1]] = v[2]
    end
    return v1
end