-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSubset
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.isSubset
-- Decompile time: 0.13 ms

return function(a1, a2) -- Line: 19 -- types: a1: table, a2: table
    for k, v in pairs(a1) do
        if a2[k] ~= v then
            return false
        end
    end
    return true
end