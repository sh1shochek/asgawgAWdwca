-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeValue
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.removeValue
-- Decompile time: 0.15 ms

return function(a1, a2) -- Line: 18 -- types: a1: table
    local v1 = {}
    for i, v in ipairs(a1) do
        if v ~= a2 then
            table.insert(v1, v)
        end
    end
    return v1
end