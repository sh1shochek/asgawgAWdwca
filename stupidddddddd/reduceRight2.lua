-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.reduceRight
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.reduceRight
-- Decompile time: 0.22 ms

return function(a1, a2, a3) -- Line: 28 -- types: a1: table, a2: function
    local v1 = a3
    local v2 = #a1
    if v1 == nil then
        v1 = a1[v2]
        v2 = v2 - 1
    end
    for i = v2, 1, -1 do
        v1 = a2(v1, a1[i], i, a1)
    end
    return v1
end