-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.reduce
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.reduce
-- Decompile time: 0.23 ms

return function(a1, a2, a3) -- Line: 27 -- types: a1: table, a2: function
    local v1 = a3
    local v2 = 1
    if v1 == nil then
        v1 = a1[1]
        v2 = 2
    end
    local v3 = #a1
    for i = v2, v3 do
        v1 = a2(v1, a1[i], i, a1)
    end
    return v1
end