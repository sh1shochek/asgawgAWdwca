-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.pop
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.pop
-- Decompile time: 0.27 ms

return function(a1, a2) -- Line: 20 -- types: a1: table, a2: number?
    local v1 = #a1
    local v2 = {}
    if type(a2) ~= "number" then
        a2 = 1
    end
    local v3 = v1 - a2
    for i = 1, v3 do
        table.insert(v2, a1[i])
    end
    return v2
end