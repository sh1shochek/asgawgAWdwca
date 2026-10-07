-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.every
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.every
-- Decompile time: 0.15 ms

return function(a1, a2) -- Line: 24 -- types: a1: table, a2: function
    for i, v in ipairs(a1) do
        if not a2(v, i, a1) then
            return false
        end
    end
    return true
end