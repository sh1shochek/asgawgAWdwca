-- ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.differenceSymmetric
-- Script path: ReplicatedStorage.Packages._Index.csqrl_sift@0.0.11.sift.Set.differenceSymmetric
-- Decompile time: 0.41 ms

require(script.Parent.Parent.Types)
return function(a1, ...) -- Line: 21
    local v1, v2, v3
    local v4 = table.clone(a1)
    local v5 = {...}
    local v6 = nil
    local v7 = nil
    for i, j in v5, v6, v7 do
        if typeof(j) == "table" then
            v2 = nil
            v3 = nil
            for k in j, v2, v3 do
                v1 = not (v4[k] ~= nil)
                v4[k] = v1
            end
        end
    end
    v6 = nil
    v7 = nil
    for n, m in v4, v6, v7 do
        v4[n] = if not m then nil else true
    end
    return v4
end