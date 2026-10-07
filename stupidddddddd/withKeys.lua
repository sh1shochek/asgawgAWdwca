-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.withKeys
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.withKeys
-- Decompile time: 0.18 ms

return function(a1, ...) -- Line: 19 -- types: a1: table
    local v1 = {}
    for i, v in ipairs({...}) do
        v1[v] = a1[v]
    end
    return v1
end