-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.every
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.every
-- Decompile time: 0.16 ms

return function(a1, a2) -- Line: 24 -- types: a1: table, a2: function
    for k, v in pairs(a1) do
        if not a2(v, k, a1) then
            return false
        end
    end
    return true
end