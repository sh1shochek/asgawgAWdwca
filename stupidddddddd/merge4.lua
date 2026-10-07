-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.merge
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.merge
-- Decompile time: 0.23 ms

return function(...) -- Line: 20
    local v1
    local v2 = {}
    for i = 1, (select("#", ...)) do
        v1 = select(i, ...)
        if type(v1) == "table" then
            for k, v in pairs(v1) do
                v2[k] = true
            end
        end
    end
    return v2
end