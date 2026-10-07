-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.difference
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.difference
-- Decompile time: 0.31 ms

require(script.Parent.Parent.Types)
return function(a1, ...) -- Line: 21
    local v1 = table.clone(a1)
    local v2 = {...}
    local v3 = nil
    local v4 = nil
    for i, j in v2, v3, v4 do
        if typeof(j) == "table" then
            for k in j do
                v1[k] = nil
            end
        end
    end
    return v1
end