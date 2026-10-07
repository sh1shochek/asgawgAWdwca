-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.map
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.map
-- Decompile time: 0.16 ms

return function(a1, a2) -- Line: 26 -- types: a1: table, a2: function
    local v1, v2
    local v3 = {}
    for k, v in pairs(a1) do
        v1, v2 = a2(v, k, a1)
        v3[v2 or k] = v1
    end
    return v3
end