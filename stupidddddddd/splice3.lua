-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.splice
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.splice
-- Decompile time: 0.43 ms

return function(a1, a2, a3, ...) -- Line: 22 -- types: a1: table, a2: number?, a3: number?
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
    local v4 = a2 - 1
    for i = 1, v4 do
        table.insert(v2, a1[i])
    end
    for i2, v in ipairs({...}) do
        table.insert(v2, v)
    end
    for j = v3 + 1, v1 do
        table.insert(v2, a1[j])
    end
    return v2
end