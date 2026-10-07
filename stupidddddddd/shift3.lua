-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.shift
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.shift
-- Decompile time: 0.21 ms

return function(a1, a2) -- Line: 20 -- types: a1: table, a2: number?
    local v1 = #a1
    local v2 = {}
    for i = if type(a2) ~= "number" then 2 else a2 + 1, v1 do
        table.insert(v2, a1[i])
    end
    return v2
end