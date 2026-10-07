-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.slice
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.slice
-- Decompile time: 0.32 ms

return function(a1, a2, a3) -- Line: 21 -- types: a1: table, a2: number?, a3: number?
    local v1 = #a1
    local v2 = {}
    if type(a2) ~= "number" then
        a2 = 1
    end
    local v3 = if type(a3) ~= "number" then v1 else a3
    if a2 < 1 then
        a2 = a2 + v1
    end
    if v3 < 1 then
        v3 = v3 + v1
    end
    for i = a2, v3 do
        table.insert(v2, a1[i])
    end
    return v2
end