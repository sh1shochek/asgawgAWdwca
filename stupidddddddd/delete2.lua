-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.delete
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.delete
-- Decompile time: 0.21 ms

return function(a1, ...) -- Line: 20 -- types: a1: table
    local v1 = {}
    for k, v in pairs(a1) do
        v1[k] = true
    end
    for i, i2 in ipairs({...}) do
        v1[i2] = nil
    end
    return v1
end