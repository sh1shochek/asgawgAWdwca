-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.map
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.map
-- Decompile time: 0.17 ms

return function(a1, a2) -- Line: 20 -- types: a1: table, a2: function
    local v1
    local v2 = {}
    for i, v in ipairs(a1) do
        v1 = a2(v, i, a1)
        if v1 ~= nil then
            table.insert(v2, v1)
        end
    end
    return v2
end