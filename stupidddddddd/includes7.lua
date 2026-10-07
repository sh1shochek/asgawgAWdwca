-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.includes
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.includes
-- Decompile time: 0.13 ms

return function(a1, a2) -- Line: 19 -- types: a1: table
    for k, v in pairs(a1) do
        if v == a2 then
            return true
        end
    end
    return false
end