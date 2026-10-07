-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.fromArrays
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.fromArrays
-- Decompile time: 0.14 ms

return function(a1, a2) -- Line: 20 -- types: a1: table, a2: table
    local v1 = {}
    for i = 1, #a1 do
        v1[a1[i]] = a2[i]
    end
    return v1
end