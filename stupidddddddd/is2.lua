-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.is
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Array.is
-- Decompile time: 0.16 ms

return function(a1) -- Line: 21
    local v1 = false
    if typeof(a1) == "table" then
        v1 = false
        if #a1 > 0 then
            v1 = next(a1, #a1) == nil
        end
    end
    return v1
end