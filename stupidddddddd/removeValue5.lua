-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeValue
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Dictionary.removeValue
-- Decompile time: 0.16 ms

return function(a1, a2) -- Line: 19 -- types: a1: table
    local v1 = {}
    for k, v in pairs(a1) do
        if v ~= a2 then
            v1[k] = v
        end
    end
    return v1
end