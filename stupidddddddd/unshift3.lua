-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.unshift
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.unshift
-- Decompile time: 0.16 ms

return function(a1, ...) -- Line: 22 -- types: a1: table
    local v1 = {...}
    for i, v in ipairs(a1) do
        table.insert(v1, v)
    end
    return v1
end