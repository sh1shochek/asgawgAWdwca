-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.push
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.push
-- Decompile time: 0.22 ms

return function(a1, ...) -- Line: 22 -- types: a1: table
    local v1 = {}
    for i, v in ipairs(a1) do
        table.insert(v1, v)
    end
    for i2, i3 in ipairs({...}) do
        table.insert(v1, i3)
    end
    return v1
end