-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.some
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.some
-- Decompile time: 0.14 ms

return function(a1, a2) -- Line: 24 -- types: a1: table, a2: function
    for i, v in ipairs(a1) do
        if a2(v, i, a1) then
            return true
        end
    end
    return false
end