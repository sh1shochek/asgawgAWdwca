-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeIndex
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeIndex
-- Decompile time: 0.21 ms

return function(a1, a2) -- Line: 19 -- types: a1: table, a2: number
    local v1 = #a1
    local v2 = {}
    if a2 < 1 then
        a2 = a2 + v1
    end
    for i, v in ipairs(a1) do
        if i ~= a2 then
            table.insert(v2, v)
        end
    end
    return v2
end