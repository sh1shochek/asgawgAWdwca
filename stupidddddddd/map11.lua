-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.map
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.map
-- Decompile time: 0.16 ms

return function(a1, a2) -- Line: 20 -- types: a1: table, a2: function
    local v1
    local v2 = {}
    for k, v in pairs(a1) do
        v1 = a2(k, a1)
        if v1 ~= nil then
            v2[v1] = true
        end
    end
    return v2
end